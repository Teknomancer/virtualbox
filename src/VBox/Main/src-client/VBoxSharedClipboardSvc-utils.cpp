/* $Id: VBoxSharedClipboardSvc-utils.cpp 114157 2026-05-20 15:00:55Z andreas.loeffler@oracle.com $ */
/** @file
 * Shared Clipboard Service - Host service utility functions.
 */

/*
 * Copyright (C) 2019-2026 Oracle and/or its affiliates.
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


/*********************************************************************************************************************************
*   Header Files                                                                                                                 *
*********************************************************************************************************************************/
#define LOG_GROUP LOG_GROUP_SHARED_CLIPBOARD
#include <VBox/log.h>

#include <VBox/GuestHost/clipboard-helper.h>
#include <VBox/HostServices/VBoxClipboardSvc.h>
#include <VBox/HostServices/VBoxClipboardExt.h>


/**
 * Signals the host that clipboard data from the guest has been received.
 *
 * @returns VBox status code. Returns VERR_NOT_FOUND when related event ID was not found.
 * @param   pClient             Client the guest clipboard data was received from.
 * @param   pCmdCtx             Client command context.
 * @param   uFormat             Clipboard format of data received.
 * @param   pvData              Pointer to clipboard data received.  This can be
 *                              NULL if @a cbData is zero.
 * @param   cbData              Size (in bytes) of clipboard data received.
 *                              This can be zero.
 *
 * @thread  Backend thread.
 */
int ShClSvcGuestDataSignal(PSHCLCLIENT pClient, PSHCLCLIENTCMDCTX pCmdCtx, SHCLFORMAT uFormat, void *pvData, uint32_t cbData)
{
    LogFlowFuncEnter();
    RT_NOREF(uFormat);

    /*
     * Validate input.
     */
    AssertPtrReturn(pClient, VERR_INVALID_POINTER);
    AssertPtrReturn(pCmdCtx, VERR_INVALID_POINTER);
    if (cbData > 0)
        AssertPtrReturn(pvData, VERR_INVALID_POINTER);

    const SHCLEVENTID idEvent = VBOX_SHCL_CONTEXTID_GET_EVENT(pCmdCtx->uContextID);
    AssertMsgReturn(idEvent != NIL_SHCLEVENTID, ("NIL event in context ID %#RX64\n", pCmdCtx->uContextID), VERR_WRONG_ORDER);

    PSHCLEVENT pEvent = ShClEventSourceGetFromId(&pClient->EventSrc, idEvent);
#if defined(RT_OS_DARWIN)
    /* We do not wait for guest clipboard availability event on macOS. Rather,
     * we paste directly into pasteboard when guest sends its clipboard data.
     * Do not assert here. */
    if (!RT_VALID_PTR(pEvent))
        return VINF_SUCCESS;
#endif

    AssertMsgReturn(pEvent != NULL, ("Event %#x not found\n", idEvent), VERR_NOT_FOUND);

    /*
     * Make a copy of the data so we can attach it to the signal.
     *
     * Note! We still signal the waiter should we run out of memory,
     *       because otherwise it will be stuck waiting.
     */
    int vrc = VINF_SUCCESS;
    PSHCLEVENTPAYLOAD pPayload = NULL;
    if (cbData > 0)
        vrc = ShClPayloadAlloc(idEvent, pvData, cbData, &pPayload);

    /*
     * Signal the event.
     */
    int vrc2 = ShClEventSignal(pEvent, pPayload);
    if (RT_FAILURE(vrc2))
    {
        vrc = vrc2;
        ShClPayloadFree(pPayload);
        LogRel(("Shared Clipboard: Signalling of guest clipboard data to the host failed: %Rrc\n", vrc));
    }

    LogFlowFuncLeaveRC(vrc);
    return vrc;
}

/**
 * Reads clipboard data from the guest, asynchronous version.
 *
 * @returns VBox status code.
 * @param   pClient             Client to request to read data form.
 * @param   fFormats            The formats being requested, OR'ed together (VBOX_SHCL_FMT_XXX).
 * @param   ppEvent             Where to return the event for waiting for new data on success.
 *                              Must be released by the caller with ShClEventRelease(). Optional.
 *
 * @thread  On X11: Called from the X11 event thread.
 * @thread  On Windows: Called from the Windows event thread.
 *
 * @note    This will locally initialize a transfer if VBOX_SHCL_FMT_URI_LIST is being requested from the guest.
 */
int ShClSvcReadDataFromGuestAsync(PSHCLCLIENT pClient, SHCLFORMATS fFormats, PSHCLEVENT *ppEvent)
{
    AssertPtrReturn(pClient, VERR_INVALID_POINTER);

    LogFlowFunc(("fFormats=%#x\n", fFormats));

    int vrc = VERR_NOT_SUPPORTED;

    /* Generate a separate message for every (valid) format we support. */
    while (fFormats)
    {
        /* Pick the next format to get from the mask: */
        /** @todo Make format reporting precedence configurable? */
        SHCLFORMAT fFormat;
        if (fFormats & VBOX_SHCL_FMT_UNICODETEXT)
            fFormat = VBOX_SHCL_FMT_UNICODETEXT;
        else if (fFormats & VBOX_SHCL_FMT_BITMAP)
            fFormat = VBOX_SHCL_FMT_BITMAP;
        else if (fFormats & VBOX_SHCL_FMT_HTML)
            fFormat = VBOX_SHCL_FMT_HTML;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        else if (fFormats & VBOX_SHCL_FMT_URI_LIST)
            fFormat = VBOX_SHCL_FMT_URI_LIST;
#endif
        else
            AssertMsgFailedBreak(("%#x\n", fFormats));

        /* Remove it from the mask. */
        fFormats &= ~fFormat;

#ifdef LOG_ENABLED
        char *pszFmt = ShClFormatsToStrA(fFormat);
        AssertPtrReturn(pszFmt, VERR_NO_MEMORY);
        LogRel2(("Shared Clipboard: Requesting guest clipboard data in format '%s'\n", pszFmt));
        RTStrFree(pszFmt);
#endif
        /*
         * Allocate messages, one for each format.
         */
        PSHCLCLIENTMSG pMsg = ShClSvcClientMsgAlloc(pClient,
                                                      pClient->State.fGuestFeatures0 & VBOX_SHCL_GF_0_CONTEXT_ID
                                                    ? VBOX_SHCL_HOST_MSG_READ_DATA_CID : VBOX_SHCL_HOST_MSG_READ_DATA,
                                                    2);
        if (pMsg)
        {
            ShClSvcClientLock(pClient);

            PSHCLEVENT pEvent;
            vrc = ShClEventSourceGenerateAndRegisterEvent(&pClient->EventSrc, &pEvent);
            if (RT_SUCCESS(vrc))
            {
                LogFlowFunc(("fFormats=%#x -> fFormat=%#x, idEvent=%#x\n", fFormats, fFormat, pEvent->idEvent));

                const uint64_t uCID = VBOX_SHCL_CONTEXTID_MAKE(pClient->State.uSessionID, pClient->EventSrc.uID, pEvent->idEvent);

                vrc = VINF_SUCCESS;

                /* Save the context ID in our legacy cruft if we have to deal with old(er) Guest Additions (< 6.1). */
                if (!(pClient->State.fGuestFeatures0 & VBOX_SHCL_GF_0_CONTEXT_ID))
                {
                    AssertStmt(pClient->Legacy.cCID < 4096, vrc = VERR_TOO_MUCH_DATA);
                    if (RT_SUCCESS(vrc))
                    {
                        PSHCLCLIENTLEGACYCID pCID = (PSHCLCLIENTLEGACYCID)RTMemAlloc(sizeof(SHCLCLIENTLEGACYCID));
                        if (pCID)
                        {
                            pCID->uCID    = uCID;
                            pCID->enmType = 0; /* Not used yet. */
                            pCID->uFormat = fFormat;
                            RTListAppend(&pClient->Legacy.lstCID, &pCID->Node);
                            pClient->Legacy.cCID++;
                        }
                        else
                            vrc = VERR_NO_MEMORY;
                    }
                }

                if (RT_SUCCESS(vrc))
                {
                    /*
                     * Format the message.
                     */
                    if (pMsg->idMsg == VBOX_SHCL_HOST_MSG_READ_DATA_CID)
                        HGCMSvcSetU64(&pMsg->aParms[0], uCID);
                    else
                        HGCMSvcSetU32(&pMsg->aParms[0], VBOX_SHCL_HOST_MSG_READ_DATA);
                    HGCMSvcSetU32(&pMsg->aParms[1], fFormat);

                    ShClSvcClientMsgAdd(pClient, pMsg, true /* fAppend */);
                    /* Wake up the client to let it know that there are new messages. */
                    ShClSvcClientWakeup(pClient);

                    /* Return event to caller. */
                    if (ppEvent)
                        *ppEvent = pEvent;
                }

                /* Remove event from list if caller did not request event handle or in case
                 * of failure (in this case caller should not release event). */
                if (   RT_FAILURE(vrc)
                    || !ppEvent)
                {
                    ShClEventRelease(pEvent);
                    pEvent = NULL;
                }
            }
            else
                vrc = VERR_SHCLPB_MAX_EVENTS_REACHED;

            if (RT_FAILURE(vrc))
                ShClSvcClientMsgFree(pClient, pMsg);

            ShClSvcClientUnlock(pClient);
        }
        else
            vrc = VERR_NO_MEMORY;

        if (RT_FAILURE(vrc))
            break;
    }

    if (RT_FAILURE(vrc))
        LogRel(("Shared Clipboard: Requesting guest clipboard data failed with %Rrc\n", vrc));

    LogFlowFuncLeaveRC(vrc);
    return vrc;
}

/**
 * Reads clipboard data from the guest.
 *
 * @returns VBox status code.
 * @retval  VERR_SHCLPB_NO_DATA if no clipboard data is available.
 * @param   pClient             Client to request to read data form.
 * @param   fFormats            The formats being requested, OR'ed together (VBOX_SHCL_FMT_XXX).
 * @param   ppv                 Where to return the allocated data read.
 *                              Must be free'd by the caller.
 * @param   pcb                 Where to return number of bytes read.
 */
int ShClSvcReadDataFromGuest(PSHCLCLIENT pClient, SHCLFORMAT fFormats, void **ppv, uint32_t *pcb)
{
    AssertPtrReturn(ppv, VERR_INVALID_POINTER);
    AssertPtrReturn(pcb, VERR_INVALID_POINTER);

    LogFlowFuncEnter();

    /* Request data from the guest and wait for data to arrive. */
    PSHCLEVENT pEvent;
    int vrc = ShClSvcReadDataFromGuestAsync(pClient, fFormats, &pEvent);
    if (RT_SUCCESS(vrc))
    {
        PSHCLEVENTPAYLOAD pPayload;
        vrc = ShClEventWait(pEvent, SHCL_TIMEOUT_DEFAULT_MS, &pPayload);
        if (RT_SUCCESS(vrc))
        {
            if (   pPayload
                && pPayload->cbData)
            {
                *ppv = pPayload->pvData;
                *pcb = pPayload->cbData;

                LogFlowFunc(("pv=%p, cb=%RU32\n", pPayload->pvData, pPayload->cbData));
            }
            else
                vrc = VERR_SHCLPB_NO_DATA;
        }

        ShClEventRelease(pEvent);
    }

    if (   RT_FAILURE(vrc)
        && vrc != VERR_SHCLPB_NO_DATA)
        LogRel(("Shared Clipboard: Reading data from guest failed with %Rrc\n", vrc));
    return vrc;
}

