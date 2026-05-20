/* $Id: GuestShClPrivate.cpp 114157 2026-05-20 15:00:55Z andreas.loeffler@oracle.com $ */
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
# include "ProgressImpl.h"
# include "GuestShClPrivate.h"

# include <iprt/semaphore.h>
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
 * @retval  VERR_NOT_SUPPORTED if the extension didn't handle the requested function. This will invoke the regular backend then.
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
    PSHCLSVCEXT const pSvcExtVRDP = &pThis->m_SvcExtVRDP; /* Currently we have one extension only. */

    switch (u32Function)
    {
        case VBOX_CLIPBOARD_EXT_FN_SET_CALLBACK:
            pThis->m_pfnExtCallback = pParms->u.SetCallback.pfnCallback;
            vrc = VINF_SUCCESS;
            break;

        case VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_HOST: // via VBOX_SHCL_GUEST_FN_REPORT_FORMATS in the guest
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLCLIENT pClient = pParms->u.ReportFormats.pClient;
                SHCLFORMATS fFormats = pParms->u.ReportFormats.uFormats;

                vrc = ShClBackendReportFormats(pClient->pBackend, pClient, fFormats);
                if (RT_FAILURE(vrc))
                    LogRel(("Shared Clipboard: Reporting guest clipboard formats to the host failed with %Rrc\n", vrc));
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_GUEST: // via VRDE_CLIPBOARD_FUNCTION_FORMAT_ANNOUNCE in the VRDE server
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLCLIENT pClient = pParms->u.ReportFormats.pClient;
                SHCLFORMATS fFormats = pParms->u.ReportFormats.uFormats;

                vrc = ShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_DATA_READ: // via VBOX_SHCL_GUEST_FN_DATA_READ in the guest
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
                SHCLCLIENTCMDCTX cmdCtx;
                void *pvData = pParms->u.ReadWriteData.pvData;
                uint32_t cbData = pParms->u.ReadWriteData.cbData;
                SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
                vrc = ShClBackendReadData(pClient->pBackend, pClient, &cmdCtx, fFormats, pvData, cbData,
                    &pParms->u.ReadWriteData.cbActual);
                if (RT_SUCCESS(vrc))
                    LogRel2(("Shared Clipboard: Read host clipboard data (max %RU32 bytes), got %RU32 bytes\n", cbData,
                        pParms->u.ReadWriteData.cbActual));
                else
                    LogRel(("Shared Clipboard: Reading host clipboard data failed with %Rrc\n", vrc));
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_DATA_READ_VRDE: // via VBOX_SHCL_GUEST_FN_DATA_READ in the guest via the VRDE server
        {
            PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
            SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
            PSHCLEVENT pEvent;
            void *pvData = pParms->u.ReadWriteData.pvData;
            uint32_t cbData = pParms->u.ReadWriteData.cbData;

            vrc = ShClSvcReadDataFromGuestAsync(pClient, fFormats, &pEvent);
            if (RT_SUCCESS(vrc))
            {
                PSHCLEVENTPAYLOAD pPayload;
                vrc = ShClEventWait(pEvent, SHCL_TIMEOUT_DEFAULT_MS, &pPayload);
                if (RT_SUCCESS(vrc))
                {
                    if (pPayload)
                    {
                        memcpy(pvData, pPayload->pvData, RT_MIN(cbData, pPayload->cbData));
                        ShClPayloadFree(pPayload);
                        pPayload = NULL;
                    }
                    else
                        pvData = NULL;
                }
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_DATA_WRITE: // via VBOX_SHCL_GUEST_FN_DATA_WRITE in the guest
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
                PSHCLCLIENTCMDCTX pCmdCtx = pParms->u.ReadWriteData.pCmdCtx;
                void *pvData = pParms->u.ReadWriteData.pvData;
                uint32_t cbData = pParms->u.ReadWriteData.cbData;
                SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
                vrc = ShClBackendWriteData(pClient->pBackend, pClient, pCmdCtx, fFormats, pvData, cbData);
                if (RT_FAILURE(vrc))
                    LogRel(("Shared Clipboard: Writing guest clipboard data to the host failed with %Rrc\n", vrc));
                /* Complete any pending events. */
                int vrc2 = ShClSvcGuestDataSignal(pClient, pCmdCtx, fFormats, pvData, cbData);
                if (RT_FAILURE(vrc2))
                    LogRel(("Shared Clipboard: Signalling host about guest clipboard data failed with %Rrc\n", vrc2));
                AssertRC(vrc2);
            }
            break;
        }

        // called via VbglR3ClipboardConnect()->VbglR3HGCMConnect() in the guest and then via
        // svcConnect() in the Shared Clipboard HGCM service to set things up before calling
        // VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT.
        case VBOX_CLIPBOARD_EXT_FN_BACKEND_INIT:
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
                VBOXHGCMSVCFNTABLE *pTable = pParms->u.ReadWriteData.pTable;
                vrc = ShClBackendInit(pBackend, pTable);
            }
            break;
        }

        // via VbglR3HGCMDisconnect()->...HGCMService::DisconnectClient()->...HGCMService::instanceDestroy()->...svcUnload()
        case VBOX_CLIPBOARD_EXT_FN_BACKEND_DESTROY:
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
                ShClBackendDestroy(pBackend);
                vrc = VINF_SUCCESS;
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT: // via VbglR3ClipboardConnect()->VbglR3HGCMConnect() in the guest
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
                PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
                bool fHeadless = pParms->u.ReadWriteData.fHeadless;
                vrc = ShClBackendConnect(pBackend, pClient, fHeadless);
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_DISCONNECT:  // via VbglR3ClipboardDisconnect()->VbglR3HGCMDisconnect() in the guest
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
                vrc = ShClBackendDisconnect(pClient->pBackend, pClient);
            }
            break;
        }

        // called via VbglR3ClipboardConnect()->VbglR3HGCMConnect() in the guest and then via
        // svcConnect() in the Shared Clipboard HGCM service after calling
        // VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT.
        case VBOX_CLIPBOARD_EXT_FN_BACKEND_SYNC:
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
                PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
                vrc = ShClBackendSync(pBackend, pClient);
            }
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_ERROR:
        {
            vrc = pThis->reportError(pParms->u.Error.pszId, pParms->u.Error.rc, pParms->u.Error.pszMsg);
            break;
        }

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        case VBOX_CLIPBOARD_EXT_FN_FILE_TRANSFER:
        {
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            if (vrc == VERR_NOT_SUPPORTED)
            {
                PSHCLCLIENT pClient = pParms->u.FileTransferData.pClient;
                PSHCLTRANSFER pTransfer = pParms->u.FileTransferData.pTransfer;
                SHCLSOURCE enmShClSource = pParms->u.FileTransferData.enmShClSource;
                PSHCLREPLY pReply = pParms->u.FileTransferData.pReply;
                vrc = ShClBackendTransferHandleStatusReply(pClient->pBackend, pClient, pTransfer, enmShClSource,
                                                           pReply->u.TransferStatus.uStatus, pReply->rc);
            }
            break;
        }
#endif

        default:
            if (pSvcExtVRDP->pfnExt)
                vrc = pSvcExtVRDP->pfnExt(pSvcExtVRDP->pvExt, u32Function, pvParms, cbParms);
            break;
    }

    LogFlowFuncLeaveRC(vrc);
    return vrc; /* Goes back to host service. */
}

#endif /* VBOX_WITH_SHARED_CLIPBOARD */
