/* $Id: GuestShClPrivate.cpp 114470 2026-06-22 09:53:42Z andreas.loeffler@oracle.com $ */
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

#ifdef VBOX_WITH_SHARED_CLIPBOARD
# include "ClipboardImpl.h"
# include "ConsoleImpl.h"
# include "GuestShClPrivate.h"
# include "ProgressImpl.h"

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



/** Static (Singleton) instance of the Shared Clipboard management object. */
GuestShCl* GuestShCl::s_pInstance = NULL;




GuestShCl::GuestShCl(Console *pConsole)
    : m_pConsole(pConsole)
    , m_pfnExtCallback(NULL)
    , m_pClient(NULL)
    , m_uHostDataSeq(0)
    , m_uGuestDataSeq(0)
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
    m_uHostDataSeq = 0;
    m_uGuestDataSeq = 0;
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
 * Increments the host data sequence counter.
 *
 * @returns Incremented host data sequence counter, or 0 if the counter cannot be incremented.
 */
uint64_t GuestShCl::i_incHostDataSeq(void)
{
    uint64_t uSeq = 0;
    int const vrc = lock();
    if (RT_SUCCESS(vrc))
    {
        uSeq = i_incHostDataSeqLocked();
        unlock();
    }
    else
        AssertMsgFailed(("Incrementing host data sequence counter failed with %Rrc\n", vrc));
    return uSeq;
}

/**
 * Increments the host data sequence counter while the caller owns the object lock.
 *
 * @returns Incremented host data sequence counter.
 */
uint64_t GuestShCl::i_incHostDataSeqLocked(void)
{
    return ++m_uHostDataSeq;
}

/**
 * Increments the guest data sequence counter.
 *
 * @returns Incremented guest data sequence counter, or 0 if the counter cannot be incremented.
 */
uint64_t GuestShCl::i_incGuestDataSeq(void)
{
    uint64_t uSeq = 0;
    int const vrc = lock();
    if (RT_SUCCESS(vrc))
    {
        uSeq = ++m_uGuestDataSeq;
        unlock();
    }
    else
        AssertMsgFailed(("Incrementing guest data sequence counter failed with %Rrc\n", vrc));
    return uSeq;
}

/**
 * Gets the current host data sequence counter.
 *
 * The returned value can be passed to i_isHostDataSeqCurrent() later to check whether the host data
 * observed by the caller is still current.
 *
 * @returns Current host data sequence counter, or 0 if the counter cannot be read.
 */
uint64_t GuestShCl::i_getHostDataSeq(void)
{
    uint64_t uSeq = 0;
    int const vrc = lock();
    if (RT_SUCCESS(vrc))
    {
        uSeq = m_uHostDataSeq;
        unlock();
    }
    else
        AssertMsgFailed(("Getting host data sequence counter failed with %Rrc\n", vrc));
    return uSeq;
}


/**
 * Checks whether a previously read host data sequence counter is still current.
 *
 * @returns true if \a uSeq matches the current host data sequence counter, false otherwise.
 * @param   uSeq                Host data sequence counter value to check.
 */
bool GuestShCl::i_isHostDataSeqCurrent(uint64_t uSeq)
{
    bool fIsCurrent = false;
    int const vrc = lock();
    if (RT_SUCCESS(vrc))
    {
        fIsCurrent = i_isHostDataSeqCurrentLocked(uSeq);
        unlock();
    }
    else
        AssertMsgFailed(("Checking host data sequence counter failed with %Rrc\n", vrc));
    return fIsCurrent;
}


/**
 * Checks whether a previously read host data sequence counter is still current while the caller owns the object lock.
 *
 * @returns true if \a uSeq matches the current host data sequence counter, false otherwise.
 * @param   uSeq                Host data sequence counter value to check.
 */
bool GuestShCl::i_isHostDataSeqCurrentLocked(uint64_t uSeq)
{
    return m_uHostDataSeq == uSeq;
}


/**
 * Gets the current guest data sequence counter.
 *
 * The returned value can be passed to i_isGuestDataSeqCurrent() later to check whether the guest data
 * observed by the caller is still current.
 *
 * @returns Current guest data sequence counter, or 0 if the counter cannot be read.
 */
uint64_t GuestShCl::i_getGuestDataSeq(void)
{
    uint64_t uSeq = 0;
    int const vrc = lock();
    if (RT_SUCCESS(vrc))
    {
        uSeq = m_uGuestDataSeq;
        unlock();
    }
    else
        AssertMsgFailed(("Getting guest data sequence counter failed with %Rrc\n", vrc));
    return uSeq;
}


/**
 * Checks whether a previously read guest data sequence counter is still current.
 *
 * @returns true if \a uSeq matches the current guest data sequence counter, false otherwise.
 * @param   uSeq                Guest data sequence counter value to check.
 */
bool GuestShCl::i_isGuestDataSeqCurrent(uint64_t uSeq)
{
    bool fIsCurrent = false;
    int const vrc = lock();
    if (RT_SUCCESS(vrc))
    {
        fIsCurrent = m_uGuestDataSeq == uSeq;
        unlock();
    }
    else
        AssertMsgFailed(("Checking guest data sequence counter failed with %Rrc\n", vrc));
    return fIsCurrent;
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

    i_incHostDataSeqLocked();

    PSHCLCLIENT pClient = m_pClient;
    if (pClient)
        vrc = ShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
    else
        vrc = VINF_SUCCESS;

    unlock();
    return vrc;
}

/**
 * Reports clipboard formats to the guest via the service backend.
 *
 * @returns VBox status code.
 * @param   pClient     Clipboard client to report to.
 * @param   fFormats    Formats to report to the guest.
 * @param   enmSource   Source of the format report.
 */
int GuestShCl::reportFormatsToGuest(PSHCLCLIENT pClient, SHCLFORMATS fFormats, SHCLSOURCE enmSource)
{
    AssertPtrReturn(pClient, VERR_INVALID_POINTER);

    RT_NOREF(enmSource);
    return ShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
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

    int vrc = pThis->i_validateSvcExtParms(u32Function, pvParms, cbParms);
    if (RT_FAILURE(vrc))
    {
        LogFlowFuncLeaveRC(vrc);
        return vrc;
    }

    PSHCLEXTPARMS pParms = (PSHCLEXTPARMS)pvParms; /* pParms might be NULL for unknown messages. */
    vrc = VERR_NOT_SUPPORTED;

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
