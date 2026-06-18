/* $Id: GuestShClPrivate.cpp 114429 2026-06-18 09:39:21Z andreas.loeffler@oracle.com $ */
/** @file
 * Private Shared Clipboard code.
 */

/*
 * Copyright (C) 2023-2026 Oracle and/or its affiliates.
 *
 * This file is part of VirtualBox base platform packages, as
 * available from https://www.virtualbox.org.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, in version 3 of the
 * License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <https://www.gnu.org/licenses>.
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */

#define LOG_GROUP LOG_GROUP_SHARED_CLIPBOARD
#include "LoggingNew.h"

#include "GuestImpl.h"
#include "AutoCaller.h"

#ifdef VBOX_WITH_SHARED_CLIPBOARD
# include "ConsoleImpl.h"
# include "ClipboardImpl.h"
# include "ProgressImpl.h"
# include "GuestShClPrivate.h"

# include <iprt/mem.h>
# include <iprt/semaphore.h>
# include <iprt/thread.h>
# include <iprt/cpp/utils.h>

# include <VMMDev.h>
# include <VBox/VMMDevCoreTypes.h>


# include <VBox/GuestHost/SharedClipboard.h>
# ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
#  include <VBox/GuestHost/SharedClipboard-transfers.h>
# endif
# include <VBox/HostServices/VBoxClipboardSvc.h>
# include <VBox/HostServices/VBoxClipboardExt.h>
# include <VBox/GuestHost/clipboard-helper.h>
# include <VBox/version.h>


/*********************************************************************************************************************************
 * GuestShCl implementation.                                                                                                     *
 ********************************************************************************************************************************/

/** Maximum host clipboard payload Main will read eagerly for data changed events. */
static uint32_t const s_cbShClMainHostDataReadMax = _64M;

/** Host clipboard data report worker task. */
typedef struct SHCLMAINHOSTDATAREPORTTASK
{
    /** Guest shared clipboard instance. */
    GuestShCl  *pThis;
    /** Reported host formats. */
    SHCLFORMATS fFormats;
    /** Reported clipboard source. */
    SHCLSOURCE  enmSource;
    /** Host clipboard counter. */
    uint64_t    uSeq;
} SHCLMAINHOSTDATAREPORTTASK;
/** Pointer to a host clipboard data report worker task. */
typedef SHCLMAINHOSTDATAREPORTTASK *PSHCLMAINHOSTDATAREPORTTASK;

/** Static (Singleton) instance of the Shared Clipboard management object. */
GuestShCl* GuestShCl::s_pInstance = NULL;


/**
 * Selects a single format for reading host clipboard data into Main.
 *
 * @returns Shared Clipboard format bit, or VBOX_SHCL_FMT_NONE.
 * @param   fFormats        Shared Clipboard format mask.
 */
static SHCLFORMAT shClMainPickHostDataFormat(SHCLFORMATS fFormats)
{
    if (fFormats & VBOX_SHCL_FMT_UNICODETEXT)
        return VBOX_SHCL_FMT_UNICODETEXT;
    if (fFormats & VBOX_SHCL_FMT_HTML)
        return VBOX_SHCL_FMT_HTML;
    if (fFormats & VBOX_SHCL_FMT_BITMAP)
        return VBOX_SHCL_FMT_BITMAP;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    if (fFormats & VBOX_SHCL_FMT_URI_LIST)
        return VBOX_SHCL_FMT_URI_LIST;
#endif
    return VBOX_SHCL_FMT_NONE;
}

GuestShCl::GuestShCl(Console *pConsole)
    : m_pConsole(pConsole)
    , m_pfnExtCallback(NULL)
    , m_pClient(NULL)
    , m_uHostDataReportSeq(0)
    , m_uGuestDataReportSeq(0)
{
    LogFlowFuncEnter();

    RT_ZERO(m_SvcExtVRDP);

    int vrc = RTCritSectInit(&m_CritSect);
    if (RT_FAILURE(vrc))
        throw vrc;
}

GuestShCl::~GuestShCl(void)
{
    uninit();
}

/**
 * Uninitializes the Shared Clipboard management object.
 */
void GuestShCl::uninit(void)
{
    LogFlowFuncEnter();

    if (RTCritSectIsInitialized(&m_CritSect))
        RTCritSectDelete(&m_CritSect);

    RT_ZERO(m_SvcExtVRDP);

    m_pfnExtCallback = NULL;
    m_pClient = NULL;
    m_uHostDataReportSeq = 0;
    m_uGuestDataReportSeq = 0;
}

/**
 * Locks the Shared Clipboard management object.
 *
 * @returns VBox status code.
 */
int GuestShCl::lock(void)
{
    int vrc = RTCritSectEnter(&m_CritSect);
    AssertRC(vrc);
    return vrc;
}

/**
 * Unlocks the Shared Clipboard management object.
 *
 * @returns VBox status code.
 */
int GuestShCl::unlock(void)
{
    int vrc = RTCritSectLeave(&m_CritSect);
    AssertRC(vrc);
    return vrc;
}

/**
 * Registers a Shared Clipboard service extension.
 *
 * @returns VBox status code.
 * @param   pfnExtension        Service extension to register.
 * @param   pvExtension         User-supplied data pointer. Optional.
 */
int GuestShCl::RegisterServiceExtension(PFNHGCMSVCEXT pfnExtension, void *pvExtension)
{
    AssertPtrReturn(pfnExtension, VERR_INVALID_POINTER);
    /* pvExtension is optional. */

    lock();

    LogFlowFunc(("m_pfnExtCallback=%p\n", this->m_pfnExtCallback));

    PSHCLSVCEXT pExt = &this->m_SvcExtVRDP; /* Currently we only have one extension only. */

    Assert(pExt->pfnExt == NULL);

    pExt->pfnExt         = pfnExtension;
    pExt->pvExt          = pvExtension;
    pExt->pfnExtCallback = this->m_pfnExtCallback; /* Assign callback function. Optional and can be NULL. */

    if (pExt->pfnExtCallback)
    {
        /* Make sure to also give the extension the ability to use the callback. */
        SHCLEXTPARMS parms;
        RT_ZERO(parms);

        parms.u.SetCallback.pfnCallback = pExt->pfnExtCallback;

        /* ignore rc, callback is optional */ pExt->pfnExt(pExt->pvExt,
                                                           VBOX_CLIPBOARD_EXT_FN_SET_CALLBACK, &parms, sizeof(parms));
    }

    unlock();

    return VINF_SUCCESS;
}

/**
 * Unregisters a Shared Clipboard service extension.
 *
 * @returns VBox status code.
 * @param   pfnExtension        Service extension to unregister.
 */
int GuestShCl::UnregisterServiceExtension(PFNHGCMSVCEXT pfnExtension)
{
    AssertPtrReturn(pfnExtension, VERR_INVALID_POINTER);

    lock();

    PSHCLSVCEXT pExt = &this->m_SvcExtVRDP; /* Currently we only have one extension only. */

    AssertReturnStmt(pExt->pfnExt == pfnExtension, unlock(), VERR_INVALID_PARAMETER);
    AssertPtr(pExt->pfnExt);

    /* Unregister the callback (setting to NULL). */
    SHCLEXTPARMS parms;
    RT_ZERO(parms);

    /* ignore rc, callback is optional */ pExt->pfnExt(pExt->pvExt,
                                                       VBOX_CLIPBOARD_EXT_FN_SET_CALLBACK, &parms, sizeof(parms));

    RT_BZERO(pExt, sizeof(SHCLSVCEXT));

    unlock();

    return VINF_SUCCESS;
}

/**
 * Sends a (blocking) message to the host side of the host service.
 *
 * @returns VBox status code.
 * @param   u32Function         HGCM message ID to send.
 * @param   cParms              Number of parameters to send.
 * @param   paParms             Array of parameters to send. Must match \c cParms.
 */
int GuestShCl::hostCall(uint32_t u32Function, uint32_t cParms, PVBOXHGCMSVCPARM paParms) const
{
    /* Forward the information to the VMM device. */
    AssertPtr(m_pConsole);
    VMMDev *pVMMDev = m_pConsole->i_getVMMDev();
    if (!pVMMDev)
        return VERR_COM_OBJECT_NOT_FOUND;

    return pVMMDev->hgcmHostCall("VBoxSharedClipboard", u32Function, cParms, paParms);
}

/**
 * Reads clipboard data from the active guest clipboard client.
 *
 * @returns VBox status code.
 * @param   uFormat     Format to request from the guest.
 * @param   ppvData     Where to return the allocated data buffer.
 * @param   pcbData     Where to return the data size.
 */
int GuestShCl::readDataFromGuest(SHCLFORMAT uFormat, void **ppvData, uint32_t *pcbData)
{
    AssertPtrReturn(ppvData, VERR_INVALID_POINTER);
    AssertPtrReturn(pcbData, VERR_INVALID_POINTER);
    *ppvData = NULL;
    *pcbData = 0;

    int vrc = lock();
    if (RT_FAILURE(vrc))
        return vrc;

    PSHCLCLIENT pClient = m_pClient;
    if (pClient)
        vrc = ShClSvcReadDataFromGuest(pClient, uFormat, ppvData, pcbData);
    else
        vrc = VERR_SHCLPB_NO_DATA;

    unlock();
    return vrc;
}

/**
 * Reports host clipboard formats to the active guest clipboard client.
 *
 * @returns VBox status code.
 * @param   fFormats    Formats to report to the guest.
 */
int GuestShCl::reportFormatsToGuest(SHCLFORMATS fFormats)
{
    int vrc = lock();
    if (RT_FAILURE(vrc))
        return vrc;

    ++m_uHostDataReportSeq;

    PSHCLCLIENT pClient = m_pClient;
    if (pClient)
        vrc = ShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
    else
        vrc = VINF_SUCCESS;

    unlock();
    return vrc;
}

/**
 * Reports clipboard formats to the guest and updates Main clipboard listeners.
 *
 * @returns VBox status code.
 * @param   pClient     Clipboard client to report to.
 * @param   fFormats    Formats to report to the guest.
 * @param   enmSource   Source of the format report.
 */
int GuestShCl::reportFormatsToGuest(PSHCLCLIENT pClient, SHCLFORMATS fFormats, SHCLSOURCE enmSource)
{
    AssertPtrReturn(pClient, VERR_INVALID_POINTER);

    uint64_t uSeq = 0;
    if (enmSource == SHCLSOURCE_LOCAL)
    {
        int vrc2 = lock();
        if (RT_FAILURE(vrc2))
            return vrc2;
        uSeq = ++m_uHostDataReportSeq;
        unlock();
    }

    ClipboardSource_T const enmClipboardSource = enmSource == SHCLSOURCE_REMOTE
                                               ? ClipboardSource_Remote : ClipboardSource_Host;
    AssertPtr(m_pConsole->i_getClipboard());
    if (m_pConsole->i_getClipboard())
        m_pConsole->i_getClipboard()->i_reportFormats(fFormats, enmClipboardSource,
                                                       true /* fForceNotify */);

    int vrc = ShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
    if (   RT_SUCCESS(vrc)
        && enmSource == SHCLSOURCE_LOCAL)
    {
        int vrc2 = reportHostDataAsync(fFormats, enmSource, uSeq);
        if (RT_FAILURE(vrc2))
            LogRelMax(16, ("Shared Clipboard: Scheduling host clipboard data report failed with %Rrc\n", vrc2));
    }
    return vrc;
}


/**
 * Schedules reporting host clipboard data to Main listeners.
 *
 * @returns VBox status code.
 * @param   fFormats        Reported host formats.
 * @param   enmSource       Reported clipboard source.
 * @param   uSeq            Expected host clipboard counter.
 */
int GuestShCl::reportHostDataAsync(SHCLFORMATS fFormats, SHCLSOURCE enmSource, uint64_t uSeq)
{
    if (enmSource != SHCLSOURCE_LOCAL)
        return VINF_SUCCESS;
    if (shClMainPickHostDataFormat(fFormats) == VBOX_SHCL_FMT_NONE)
        return VINF_SUCCESS;

    PSHCLMAINHOSTDATAREPORTTASK pTask = (PSHCLMAINHOSTDATAREPORTTASK)RTMemAllocZ(sizeof(*pTask));
    if (!pTask)
        return VERR_NO_MEMORY;

    pTask->pThis     = this;
    pTask->fFormats  = fFormats;
    pTask->enmSource = enmSource;
    pTask->uSeq      = uSeq;

    int vrc = RTThreadCreate(NULL, GuestShCl::reportHostDataThread, pTask, 0 /* cbStack */,
                             RTTHREADTYPE_MAIN_WORKER, 0 /* fFlags */, "ShClData");
    if (RT_FAILURE(vrc))
        RTMemFree(pTask);
    return vrc;
}


/**
 * Reports host clipboard data to Main listeners.
 *
 * @returns VBox status code.
 * @param   fFormats        Reported host formats.
 * @param   enmSource       Reported clipboard source.
 * @param   uSeq            Expected host clipboard counter.
 */
int GuestShCl::reportHostData(SHCLFORMATS fFormats, SHCLSOURCE enmSource, uint64_t uSeq)
{
    if (enmSource != SHCLSOURCE_LOCAL)
        return VINF_SUCCESS;

    SHCLFORMAT const uFormat = shClMainPickHostDataFormat(fFormats);
    if (uFormat == VBOX_SHCL_FMT_NONE)
        return VINF_SUCCESS;

    int vrc = lock();
    if (RT_FAILURE(vrc))
        return vrc;

    if (uSeq != m_uHostDataReportSeq)
    {
        unlock();
        return VINF_SUCCESS;
    }

    Clipboard *pClipboard = m_pConsole ? m_pConsole->i_getClipboard() : NULL;
    PSHCLCLIENT pClient = m_pClient;
    if (!pClipboard || !pClient)
    {
        unlock();
        return VINF_SUCCESS;
    }

    uint8_t bProbe = 0;
    uint32_t cbActual = 0;
    SHCLCLIENTCMDCTX CmdCtx;
    RT_ZERO(CmdCtx);
    vrc = ShClBackendReadData(pClient->pBackend, pClient, &CmdCtx, uFormat, &bProbe, sizeof(bProbe), &cbActual);
    if (RT_FAILURE(vrc))
    {
        LogRelMax(16, ("Shared Clipboard: Reading host clipboard data failed with %Rrc\n", vrc));
        unlock();
        return vrc;
    }
    if (!cbActual)
    {
        unlock();
        return VINF_SUCCESS;
    }
    if (cbActual > s_cbShClMainHostDataReadMax)
    {
        LogRelMax(16, ("Shared Clipboard: Refusing to report oversized host clipboard data: %RU32 bytes (limit %RU32 bytes)\n",
                       cbActual, s_cbShClMainHostDataReadMax));
        unlock();
        return VERR_TOO_MUCH_DATA;
    }

    void *pvData = RTMemAlloc(cbActual);
    if (!pvData)
    {
        unlock();
        return VERR_NO_MEMORY;
    }

    uint32_t cbRead = 0;
    vrc = ShClBackendReadData(pClient->pBackend, pClient, &CmdCtx, uFormat, pvData, cbActual, &cbRead);
    if (RT_SUCCESS(vrc))
    {
        if (   cbRead > 0
            && cbRead <= cbActual
            && uSeq == m_uHostDataReportSeq)
        {
            HRESULT hrc = pClipboard->i_reportData(ClipboardAction_Copy, ClipboardSource_Host, uFormat, pvData, cbRead);
            if (FAILED(hrc))
                LogRelMax(16, ("Shared Clipboard: Reporting host clipboard data to Main failed with %Rhrc\n", hrc));
        }
        else if (cbRead > cbActual)
        {
            LogRelMax(16, ("Shared Clipboard: Host clipboard data grew while reading: %RU32 bytes reported, %RU32 bytes allocated\n",
                           cbRead, cbActual));
            vrc = VERR_BUFFER_OVERFLOW;
        }
    }
    else
        LogRelMax(16, ("Shared Clipboard: Reading host clipboard data failed with %Rrc\n", vrc));

    RTMemFree(pvData);
    unlock();
    return vrc;
}


/**
 * Host clipboard data reporting worker.
 *
 * @returns VBox status code.
 * @param   hThread         Worker thread handle.
 * @param   pvUser          Pointer to SHCLMAINHOSTDATAREPORTTASK.
 */
DECLCALLBACK(int) GuestShCl::reportHostDataThread(RTTHREAD hThread, void *pvUser)
{
    RT_NOREF(hThread);
    PSHCLMAINHOSTDATAREPORTTASK pTask = (PSHCLMAINHOSTDATAREPORTTASK)pvUser;
    AssertPtrReturn(pTask, VERR_INVALID_POINTER);

    RTThreadSleep(10);
    int vrc = pTask->pThis->reportHostData(pTask->fFormats, pTask->enmSource, pTask->uSeq);
    RTMemFree(pTask);
    return vrc;
}


/**
 * Reports an error by setting the error info and also informs subscribed listeners.
 *
 * @returns VBox status code.
 * @param   pcszId              ID (name) of the clipboard. Can be NULL if not being used.
 * @param   vrc                 Result code (IPRT-style) to report.
 * @param   pcszMsgFmt          Error message to report.
 * @param   ...                 Format string for \a pcszMsgFmt.
 */
int GuestShCl::reportError(const char *pcszId, int vrc, const char *pcszMsgFmt, ...)
{
    /* pcszId can be NULL. */
    AssertReturn(pcszMsgFmt && *pcszMsgFmt != '\0', E_INVALIDARG);

    va_list va;
    va_start(va, pcszMsgFmt);

    Utf8Str strMsg;
    int const vrc2 = strMsg.printfVNoThrow(pcszMsgFmt, va);
    if (RT_FAILURE(vrc2))
    {
        va_end(va);
        return vrc2;
    }

    va_end(va);

    if (pcszId)
        LogRel(("Shared Clipboard (%s): %s (%Rrc)\n", pcszId, strMsg.c_str(), vrc));
    else
        LogRel(("Shared Clipboard: %s (%Rrc)\n", strMsg.c_str(), vrc));

    m_pConsole->i_onClipboardError(pcszId, strMsg.c_str(), vrc);

    return VINF_SUCCESS;
}


/**
 * Forwards a Shared Clipboard service extension request to the chained VRDP extension.
 *
 * @returns VBox status code returned by the chained extension, or VERR_NOT_SUPPORTED if no
 *          chained extension is registered.
 * @param   u32Function         Service extension function to forward.
 * @param   pvParms             Raw service extension parameters to forward.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_forwardToChainedSvcExt(uint32_t u32Function, void *pvParms, uint32_t cbParms)
{
    PSHCLSVCEXT const pSvcExtVRDP = &m_SvcExtVRDP; /* Currently we have one extension only. */
    if (pSvcExtVRDP->pfnExt)
        return pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
    return VERR_NOT_SUPPORTED;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_SET_CALLBACK from the Shared Clipboard host service.
 *
 * @returns VBox status code.
 * @param   pParms              Service extension parameters containing the callback to install.
 */
int GuestShCl::i_handleSvcExtSetCallback(PSHCLEXTPARMS pParms)
{
    m_pfnExtCallback = pParms->u.SetCallback.pfnCallback;
    return VINF_SUCCESS;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_HOST from the Shared Clipboard host service.
 *
 * Reports guest clipboard formats to Main and forwards the notification to the chained VRDP extension
 * before falling back to the regular backend.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtReportFormatsToHost(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    PSHCLCLIENT pClient = pParms->u.ReportFormats.pClient;
    SHCLFORMATS fFormats = pParms->u.ReportFormats.uFormats;

    int vrc2 = lock();
    if (RT_SUCCESS(vrc2))
    {
        ++m_uGuestDataReportSeq;
        unlock();
    }
    else
        AssertMsgFailed(("Updating guest clipboard data sequence counter failed with %Rrc\n", vrc2));

    AssertPtr(m_pConsole->i_getClipboard());
    if (m_pConsole->i_getClipboard())
        m_pConsole->i_getClipboard()->i_reportFormats(fFormats, ClipboardSource_Guest,
                                                       true /* fForceNotify */);

    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_HOST, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        vrc = ShClBackendReportFormats(pClient->pBackend, pClient, fFormats);
        if (RT_FAILURE(vrc))
            LogRel(("Shared Clipboard: Reporting guest clipboard formats to the host failed with %Rrc\n", vrc));
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_GUEST from the Shared Clipboard host service.
 *
 * Reports host or remote clipboard formats to Main and forwards the notification to the chained VRDP
 * extension before falling back to the regular backend.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtReportFormatsToGuest(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    PSHCLCLIENT pClient = pParms->u.ReportFormats.pClient;
    SHCLFORMATS fFormats = pParms->u.ReportFormats.uFormats;
    ClipboardSource_T const enmSource = pParms->u.ReportFormats.enmSource == SHCLSOURCE_REMOTE
                                      ? ClipboardSource_Remote : ClipboardSource_Host;

    AssertPtr(m_pConsole->i_getClipboard());
    if (m_pConsole->i_getClipboard())
        m_pConsole->i_getClipboard()->i_reportFormats(fFormats, enmSource,
                                                       true /* fForceNotify */);

    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_GUEST, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
        vrc = ShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_DATA_READ from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension service the request first, then reads host clipboard data via Main
 * or the regular backend and mirrors successfully read backend data back into Main when appropriate.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtDataRead(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_DATA_READ, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
        SHCLCLIENTCMDCTX cmdCtx;
        RT_ZERO(cmdCtx);
        void *pvData = pParms->u.ReadWriteData.pvData;
        uint32_t cbData = pParms->u.ReadWriteData.cbData;
        SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
        uint64_t uHostSeq = 0;
        bool fHaveHostSeq = false;
        int vrcLock = lock();
        if (RT_SUCCESS(vrcLock))
        {
            uHostSeq = m_uHostDataReportSeq;
            fHaveHostSeq = true;
            unlock();
        }
        else
            AssertMsgFailed(("Snapshotting host clipboard sequence counter failed with %Rrc\n", vrcLock));

        Clipboard *pClipboard = m_pConsole->i_getClipboard();
        bool fReadFromMain = false;
        if (pClipboard)
        {
            HRESULT hrc = pClipboard->i_readDataForGuest(fFormats, pvData, cbData, &pParms->u.ReadWriteData.cbActual);
            if (SUCCEEDED(hrc))
            {
                fReadFromMain = true;
                vrc = VINF_SUCCESS;
            }
            else
                vrc = ShClBackendReadData(pClient->pBackend, pClient, &cmdCtx, fFormats, pvData, cbData,
                                          &pParms->u.ReadWriteData.cbActual);
        }
        else
            vrc = ShClBackendReadData(pClient->pBackend, pClient, &cmdCtx, fFormats, pvData, cbData,
                                      &pParms->u.ReadWriteData.cbActual);
        if (RT_SUCCESS(vrc))
        {
            LogRel2(("Shared Clipboard: Read host clipboard data (max %RU32 bytes), got %RU32 bytes\n", cbData,
                pParms->u.ReadWriteData.cbActual));

            if (   vrc == VINF_SUCCESS
                && !fReadFromMain
                && pClipboard
                && pvData
                && fHaveHostSeq
                && pParms->u.ReadWriteData.cbActual > 0
                && pParms->u.ReadWriteData.cbActual <= cbData)
            {
                bool fSeqUnchanged = false;
                vrcLock = lock();
                if (RT_SUCCESS(vrcLock))
                {
                    fSeqUnchanged = m_uHostDataReportSeq == uHostSeq;
                    unlock();
                }
                else
                    AssertMsgFailed(("Checking host clipboard sequence counter failed with %Rrc\n", vrcLock));

                if (fSeqUnchanged)
                {
                    HRESULT hrc = pClipboard->i_reportData(ClipboardAction_Copy, ClipboardSource_Host, fFormats, pvData,
                                                           pParms->u.ReadWriteData.cbActual);
                    if (FAILED(hrc))
                        LogRelMax(16, ("Shared Clipboard: Reporting host clipboard data to Main failed with %Rhrc\n", hrc));
                }
            }
        }
        else
            LogRel(("Shared Clipboard: Reading host clipboard data failed with %Rrc\n", vrc));
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_DATA_READ_VRDE from the Shared Clipboard host service.
 *
 * Reads clipboard data asynchronously from the guest for the VRDE extension path and copies the
 * received payload into the supplied extension buffer.
 *
 * @returns VBox status code.
 * @param   pParms              Service extension parameters describing the read request.
 */
int GuestShCl::i_handleSvcExtDataReadVrde(PSHCLEXTPARMS pParms)
{
    PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
    SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
    PSHCLEVENT pEvent;
    void *pvData = pParms->u.ReadWriteData.pvData;
    uint32_t cbData = pParms->u.ReadWriteData.cbData;

    int vrc = ShClSvcReadDataFromGuestAsync(pClient, fFormats, &pEvent);
    if (RT_SUCCESS(vrc))
    {
        PSHCLEVENTPAYLOAD pPayload;
        vrc = ShClEventWait(pEvent, SHCL_TIMEOUT_DEFAULT_MS, &pPayload);
        if (RT_SUCCESS(vrc))
        {
            if (pPayload)
            {
                memcpy(pvData, pPayload->pvData, RT_MIN(cbData, pPayload->cbData));
                ShClPayloadDestroy(pPayload);
                pPayload = NULL;
            }
            else
                pvData = NULL;
        }
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_DATA_WRITE from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension service the request first, then writes guest clipboard data through
 * the regular backend, signals pending guest-data waiters, and mirrors unchanged guest data into Main.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtDataWrite(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_DATA_WRITE, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
        PSHCLCLIENTCMDCTX pCmdCtx = pParms->u.ReadWriteData.pCmdCtx;
        void *pvData = pParms->u.ReadWriteData.pvData;
        uint32_t cbData = pParms->u.ReadWriteData.cbData;
        SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
        uint64_t uSeq = 0;
        bool fHaveSeq = false;
        int vrcLock = lock();
        if (RT_SUCCESS(vrcLock))
        {
            uSeq = m_uGuestDataReportSeq;
            fHaveSeq = true;
            unlock();
        }
        else
            AssertMsgFailed(("Snapshotting guest clipboard sequence counter failed with %Rrc\n", vrcLock));

        vrc = ShClBackendWriteData(pClient->pBackend, pClient, pCmdCtx, fFormats, pvData, cbData);
        if (RT_FAILURE(vrc))
            LogRel(("Shared Clipboard: Writing guest clipboard data to the host failed with %Rrc\n", vrc));
        /* Complete any pending events. */
        int vrc2 = ShClSvcGuestDataSignal(pClient, pCmdCtx, fFormats, pvData, cbData);
        if (RT_FAILURE(vrc2))
            LogRelMax(16, ("Shared Clipboard: Signalling host about guest clipboard data failed with %Rrc\n", vrc2));
        AssertRC(vrc2);

        Clipboard *pClipboard = m_pConsole->i_getClipboard();
        if (RT_SUCCESS(vrc) && pClipboard && fHaveSeq)
        {
            bool fSeqUnchanged = false;
            vrcLock = lock();
            if (RT_SUCCESS(vrcLock))
            {
                fSeqUnchanged = m_uGuestDataReportSeq == uSeq;
                unlock();
            }
            else
                AssertMsgFailed(("Checking guest clipboard sequence counter failed with %Rrc\n", vrcLock));

            if (fSeqUnchanged)
            {
                HRESULT hrc = pClipboard->i_reportData(ClipboardAction_Copy, ClipboardSource_Guest, fFormats, pvData, cbData);
                if (FAILED(hrc))
                    LogRelMax(16, ("Shared Clipboard: Reporting guest clipboard data to Main failed with %Rhrc\n", hrc));
            }
        }
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_BACKEND_INIT from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension initialize first, then initializes the regular Shared Clipboard
 * backend if the extension did not handle the request.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtBackendInit(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_BACKEND_INIT, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
        VBOXHGCMSVCFNTABLE *pTable = pParms->u.ReadWriteData.pTable;
        vrc = ShClBackendInit(pBackend, pTable);
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_BACKEND_DESTROY from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension tear down first, then destroys the regular Shared Clipboard backend
 * if the extension did not handle the request.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtBackendDestroy(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_BACKEND_DESTROY, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
        ShClBackendDestroy(pBackend);
        vrc = VINF_SUCCESS;
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension connect first, then connects the regular backend and records the
 * active HGCM client when the backend connection succeeds.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtBackendConnect(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
        PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
        bool fHeadless = pParms->u.ReadWriteData.fHeadless;
        vrc = ShClBackendConnect(pBackend, pClient, fHeadless);
        if (RT_SUCCESS(vrc))
        {
            lock();
            m_pClient = pClient;
            unlock();
        }
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_BACKEND_DISCONNECT from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension disconnect first, then disconnects the regular backend and clears
 * the active HGCM client if it matches the disconnecting client.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtBackendDisconnect(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_BACKEND_DISCONNECT, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
        lock();
        vrc = ShClBackendDisconnect(pClient->pBackend, pClient);
        if (m_pClient == pClient)
            m_pClient = NULL;
        unlock();
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_BACKEND_SYNC from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension synchronize first, then synchronizes the regular Shared Clipboard
 * backend if the extension did not handle the request.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtBackendSync(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_BACKEND_SYNC, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
        PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
        vrc = ShClBackendSync(pBackend, pClient);
    }
    return vrc;
}


/**
 * Handles VBOX_CLIPBOARD_EXT_FN_ERROR from the Shared Clipboard host service.
 *
 * Converts the extension error parameters into a Main clipboard error notification.
 *
 * @returns VBox status code.
 * @param   pParms              Service extension parameters containing the error details.
 */
int GuestShCl::i_handleSvcExtError(PSHCLEXTPARMS pParms)
{
    return reportError(pParms->u.Error.pszId, pParms->u.Error.rc, pParms->u.Error.pszMsg);
}


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
/**
 * Handles VBOX_CLIPBOARD_EXT_FN_FILE_TRANSFER from the Shared Clipboard host service.
 *
 * Lets the chained VRDP extension handle transfer status first, then forwards the transfer status
 * reply to the regular Shared Clipboard backend if the extension did not handle the request.
 *
 * @returns VBox status code.
 * @param   pParms              Decoded service extension parameters.
 * @param   pvParms             Raw service extension parameters to forward to the chained extension.
 * @param   cbParms             Size, in bytes, of \a pvParms.
 */
int GuestShCl::i_handleSvcExtFileTransfer(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms)
{
    int vrc = i_forwardToChainedSvcExt(VBOX_CLIPBOARD_EXT_FN_FILE_TRANSFER, pvParms, cbParms);
    if (vrc == VERR_NOT_SUPPORTED)
    {
        PSHCLCLIENT pClient = pParms->u.FileTransferData.pClient;
        PSHCLTRANSFER pTransfer = pParms->u.FileTransferData.pTransfer;
        SHCLSOURCE enmShClSource = pParms->u.FileTransferData.enmShClSource;
        PSHCLREPLY pReply = pParms->u.FileTransferData.pReply;
        vrc = ShClBackendTransferHandleStatusReply(pClient->pBackend, pClient, pTransfer, enmShClSource,
                                                   pReply->u.TransferStatus.uStatus, pReply->rc);
    }
    return vrc;
}
#endif


/**
 * Static main dispatcher function to handle callbacks from the Shared Clipboard host service.
 *
 * @returns VBox status code.
 * @retval  VERR_NOT_SUPPORTED if the extension did not handle the requested function. This will invoke the regular backend then.
 * @param   pvExtension         Pointer to service extension.
 * @param   u32Function         Callback HGCM message ID.
 * @param   pvParms             Pointer to optional data provided for a particular message. Optional.
 * @param   cbParms             Size (in bytes) of \a pvParms.
 */
/* static */
DECLCALLBACK(int) GuestShCl::hgcmDispatcher(void *pvExtension, uint32_t u32Function,
                                            void *pvParms, uint32_t cbParms)
{
    LogFlowFunc(("pvExtension=%p, u32Function=%RU32, pvParms=%p, cbParms=%RU32\n",
                 pvExtension, u32Function, pvParms, cbParms));

    GuestShCl *pThis = reinterpret_cast<GuestShCl*>(pvExtension);
    AssertPtrReturn(pThis, VERR_INVALID_POINTER);

    PSHCLEXTPARMS pParms = (PSHCLEXTPARMS)pvParms; /* pParms might be NULL, depending on the message. */
    int vrc = VERR_NOT_SUPPORTED;

    switch (u32Function)
    {
        case VBOX_CLIPBOARD_EXT_FN_SET_CALLBACK:
            vrc = pThis->i_handleSvcExtSetCallback(pParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_HOST:
            vrc = pThis->i_handleSvcExtReportFormatsToHost(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_GUEST:
            vrc = pThis->i_handleSvcExtReportFormatsToGuest(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_DATA_READ:
            vrc = pThis->i_handleSvcExtDataRead(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_DATA_READ_VRDE:
            vrc = pThis->i_handleSvcExtDataReadVrde(pParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_DATA_WRITE:
            vrc = pThis->i_handleSvcExtDataWrite(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_INIT:
            vrc = pThis->i_handleSvcExtBackendInit(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_DESTROY:
            vrc = pThis->i_handleSvcExtBackendDestroy(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT:
            vrc = pThis->i_handleSvcExtBackendConnect(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_DISCONNECT:
            vrc = pThis->i_handleSvcExtBackendDisconnect(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_SYNC:
            vrc = pThis->i_handleSvcExtBackendSync(pParms, pvParms, cbParms);
            break;

        case VBOX_CLIPBOARD_EXT_FN_ERROR:
            vrc = pThis->i_handleSvcExtError(pParms);
            break;

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        case VBOX_CLIPBOARD_EXT_FN_FILE_TRANSFER:
            vrc = pThis->i_handleSvcExtFileTransfer(pParms, pvParms, cbParms);
            break;
#endif

        default:
            vrc = pThis->i_forwardToChainedSvcExt(u32Function, pvParms, cbParms);
            break;
    }

    LogFlowFuncLeaveRC(vrc);
    return vrc; /* Goes back to host service. */
}

#endif /* VBOX_WITH_SHARED_CLIPBOARD */
