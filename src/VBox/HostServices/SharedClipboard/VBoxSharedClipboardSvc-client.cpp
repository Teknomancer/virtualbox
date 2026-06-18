/* $Id: VBoxSharedClipboardSvc-client.cpp 114422 2026-06-18 07:43:19Z andreas.loeffler@oracle.com $ */
/** @file
 * Shared Clipboard Service - Client/session and message queue handling.
 */

/*
 * Copyright (C) 2006-2026 Oracle and/or its affiliates.
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
#include <VBox/vmm/vmmr3vtable.h> /* must be included before hgcmsvc.h */

#include <VBox/AssertGuest.h>
#include <VBox/err.h>
#include <VBox/HostServices/Service.h>
#include <VBox/GuestHost/clipboard-helper.h>
#include <VBox/HostServices/VBoxClipboardSvc.h>
#include <VBox/VMMDev.h>

#include <iprt/assert.h>
#include <iprt/critsect.h>
#include <iprt/mem.h>
#include <iprt/string.h>

#include "VBoxSharedClipboardSvc-internal.h"
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
# include "VBoxSharedClipboardSvc-transfers.h"
#endif

using namespace HGCM;


/*********************************************************************************************************************************
*   Internal Functions                                                                                                           *
*********************************************************************************************************************************/
static int  shClSvcClientStateInit(PSHCLCLIENTSTATE pState, uint32_t uClientID);
static int  shClSvcClientStateTerm(PSHCLCLIENTSTATE pState);
static void shclSvcClientStateReset(PSHCLCLIENTSTATE pState);

/**
 * Resets a client's state message queue.
 *
 * @param   pClient             Pointer to the client data structure to reset message queue for.
 * @note    Caller enters pClient->CritSect.
 */
static void shClSvcClientMsgQueueReset(PSHCLCLIENT pClient)
{
    Assert(RTCritSectIsOwner(&pClient->CritSect));
    LogFlowFuncEnter();

    while (!RTListIsEmpty(&pClient->MsgQueue))
    {
        PSHCLCLIENTMSG pMsg = RTListRemoveFirst(&pClient->MsgQueue, SHCLCLIENTMSG, ListEntry);
        ShClSvcClientMsgFree(pClient, pMsg);
    }
    pClient->cMsgAllocated = 0;

    while (!RTListIsEmpty(&pClient->Legacy.lstCID))
    {
        PSHCLCLIENTLEGACYCID pCID = RTListRemoveFirst(&pClient->Legacy.lstCID, SHCLCLIENTLEGACYCID, Node);
        RTMemFree(pCID);
    }
    pClient->Legacy.cCID = 0;
}

/**
 * Initializes a Shared Clipboard client.
 *
 * @param   pClient             Client to initialize.
 * @param   uClientID           HGCM client ID to assign client to.
 */
int ShClSvcClientInit(PSHCLCLIENT pClient, uint32_t uClientID)
{
    AssertPtrReturn(pClient, VERR_INVALID_POINTER);

    /* Assign the client ID. */
    pClient->State.uClientID = uClientID;

    /* Cache the current Shared Clipboard mode for the backend. */
    pClient->State.uMode = ShClSvcGetMode();

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    /* Cache the current Shared Clipboard transfer (file) mode for the backend. */
    pClient->State.Transfers.uTransferMode = g_fTransferMode;
#endif

    RTListInit(&pClient->MsgQueue);
    pClient->cMsgAllocated = 0;

    RTListInit(&pClient->Legacy.lstCID);
    pClient->Legacy.cCID = 0;

    LogFlowFunc(("[Client %RU32]\n", pClient->State.uClientID));

    int rc = RTCritSectInit(&pClient->CritSect);
    if (RT_SUCCESS(rc))
    {
        /* Create the client's own event source. */
        rc = ShClEventSourceInit(&pClient->EventSrc, 0 /* ID, ignored */);
        if (RT_SUCCESS(rc))
        {
            LogFlowFunc(("[Client %RU32] Using event source %RU32\n", uClientID, pClient->EventSrc.uID));

            /* Reset the client state. */
            shclSvcClientStateReset(&pClient->State);

            /* (Re-)initialize the client state. */
            rc = shClSvcClientStateInit(&pClient->State, uClientID);

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
            if (RT_SUCCESS(rc))
                rc = ShClTransferCtxInit(&pClient->Transfers.Ctx);
#endif
        }
    }

    LogFlowFuncLeaveRC(rc);
    return rc;
}

/**
 * Destroys a Shared Clipboard client.
 *
 * @param   pClient             Client to destroy.
 */
void shClSvcClientDestroy(PSHCLCLIENT pClient)
{
    AssertPtrReturnVoid(pClient);

    LogFlowFunc(("[Client %RU32]\n", pClient->State.uClientID));

    /* Make sure to send a quit message to the guest so that it can terminate gracefully. */
    ShClSvcClientLock(pClient);

    if (pClient->Pending.uType)
    {
        if (pClient->Pending.cParms > 1)
            HGCMSvcSetU32(&pClient->Pending.paParms[0], VBOX_SHCL_HOST_MSG_QUIT);
        if (pClient->Pending.cParms > 2)
            HGCMSvcSetU32(&pClient->Pending.paParms[1], 0);
        g_pHelpers->pfnCallComplete(pClient->Pending.hHandle, VINF_SUCCESS);
        pClient->Pending.uType   = 0;
        pClient->Pending.cParms  = 0;
        pClient->Pending.hHandle = NULL;
        pClient->Pending.paParms = NULL;
    }

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    shClSvcTransferDestroyAll(pClient);
    ShClTransferCtxDestroy(&pClient->Transfers.Ctx);
#endif

    ShClEventSourceTerm(&pClient->EventSrc);
    shClSvcClientStateTerm(&pClient->State);

    ShClSvcClientUnlock(pClient);

    PSHCLCLIENTLEGACYCID pCidIter, pCidIterNext;
    RTListForEachSafe(&pClient->Legacy.lstCID, pCidIter, pCidIterNext, SHCLCLIENTLEGACYCID, Node)
        RTMemFree(pCidIter);

    int rc2 = RTCritSectDelete(&pClient->CritSect);
    AssertRC(rc2);

    ClipboardClientMap::iterator itClient = g_mapClients.find(pClient->State.uClientID);
    if (itClient != g_mapClients.end())
        g_mapClients.erase(itClient);
    else
        AssertFailed();

    LogFlowFuncLeave();
}

/**
 * Resets a Shared Clipboard client.
 *
 * @param   pClient             Client to reset.
 */
void shClSvcClientReset(PSHCLCLIENT pClient)
{
    if (!pClient)
        return;

    LogFlowFunc(("[Client %RU32]\n", pClient->State.uClientID));
    RTCritSectEnter(&pClient->CritSect);

    /* Reset message queue. */
    shClSvcClientMsgQueueReset(pClient);

    /* Reset event source. */
    ShClEventSourceReset(&pClient->EventSrc);

    /* Reset pending state. */
    RT_ZERO(pClient->Pending);

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    shClSvcTransferDestroyAll(pClient);
#endif

    shclSvcClientStateReset(&pClient->State);

    RTCritSectLeave(&pClient->CritSect);
}

int shClSvcClientNegogiateChunkSize(PSHCLCLIENT pClient, VBOXHGCMCALLHANDLE hCall,
                                           uint32_t cParms, VBOXHGCMSVCPARM paParms[])
{
    /*
     * Validate the request.
     */
    ASSERT_GUEST_RETURN(cParms == VBOX_SHCL_CPARMS_NEGOTIATE_CHUNK_SIZE, VERR_WRONG_PARAMETER_COUNT);
    ASSERT_GUEST_RETURN(paParms[0].type == VBOX_HGCM_SVC_PARM_32BIT, VERR_WRONG_PARAMETER_TYPE);
    uint32_t const cbClientMaxChunkSize = paParms[0].u.uint32;
    ASSERT_GUEST_RETURN(paParms[1].type == VBOX_HGCM_SVC_PARM_32BIT, VERR_WRONG_PARAMETER_TYPE);
    uint32_t const cbClientChunkSize    = paParms[1].u.uint32;

    uint32_t const cbHostMaxChunkSize = VBOX_SHCL_MAX_CHUNK_SIZE; /** @todo Make this configurable. */

    /*
     * Do the work.
     */
    if (cbClientChunkSize == 0) /* Does the client want us to choose? */
    {
        paParms[0].u.uint32 = cbHostMaxChunkSize;                                     /* Maximum */
        paParms[1].u.uint32 = RT_MIN(pClient->State.cbChunkSize, cbHostMaxChunkSize); /* Preferred */

    }
    else /* The client told us what it supports, so update and report back. */
    {
        paParms[0].u.uint32 = RT_MIN(cbClientMaxChunkSize, cbHostMaxChunkSize);         /* Maximum */
        paParms[1].u.uint32 = RT_MIN(cbClientMaxChunkSize, pClient->State.cbChunkSize); /* Preferred */
    }

    int rc = g_pHelpers->pfnCallComplete(hCall, VINF_SUCCESS);
    if (RT_SUCCESS(rc))
    {
        Log(("[Client %RU32] chunk size: %#RU32, max: %#RU32\n",
             pClient->State.uClientID, paParms[1].u.uint32, paParms[0].u.uint32));
    }
    else
        LogFunc(("pfnCallComplete -> %Rrc\n", rc));

    return VINF_HGCM_ASYNC_EXECUTE;
}

/**
 * Implements VBOX_SHCL_GUEST_FN_REPORT_FEATURES.
 *
 * @returns VBox status code.
 * @retval  VINF_HGCM_ASYNC_EXECUTE on success (we complete the message here).
 * @retval  VERR_ACCESS_DENIED if not master
 * @retval  VERR_INVALID_PARAMETER if bit 63 in the 2nd parameter isn't set.
 * @retval  VERR_WRONG_PARAMETER_COUNT
 *
 * @param   pClient     The client state.
 * @param   hCall       The client's call handle.
 * @param   cParms      Number of parameters.
 * @param   paParms     Array of parameters.
 */
int shClSvcClientReportFeatures(PSHCLCLIENT pClient, VBOXHGCMCALLHANDLE hCall,
                                       uint32_t cParms, VBOXHGCMSVCPARM paParms[])
{
    /*
     * Validate the request.
     */
    ASSERT_GUEST_RETURN(cParms == 2, VERR_WRONG_PARAMETER_COUNT);
    ASSERT_GUEST_RETURN(paParms[0].type == VBOX_HGCM_SVC_PARM_64BIT, VERR_WRONG_PARAMETER_TYPE);
    uint64_t const fFeatures0 = paParms[0].u.uint64;
    ASSERT_GUEST_RETURN(paParms[1].type == VBOX_HGCM_SVC_PARM_64BIT, VERR_WRONG_PARAMETER_TYPE);
    uint64_t const fFeatures1 = paParms[1].u.uint64;
    ASSERT_GUEST_RETURN(fFeatures1 & VBOX_SHCL_GF_1_MUST_BE_ONE, VERR_INVALID_PARAMETER);

    /*
     * Do the work.
     */
    paParms[0].u.uint64 = g_fHostFeatures0;
    paParms[1].u.uint64 = 0;

    int rc = g_pHelpers->pfnCallComplete(hCall, VINF_SUCCESS);
    if (RT_SUCCESS(rc))
    {
        pClient->State.fGuestFeatures0 = fFeatures0;
        pClient->State.fGuestFeatures1 = fFeatures1;
        LogRel2(("Shared Clipboard: Guest reported the following features: %#RX64\n",
                 pClient->State.fGuestFeatures0)); /* Note: fFeatures1 not used yet. */
        if (pClient->State.fGuestFeatures0 & VBOX_SHCL_GF_0_TRANSFERS)
            LogRel2(("Shared Clipboard: Guest supports file transfers\n"));
    }
    else
        LogFunc(("pfnCallComplete -> %Rrc\n", rc));

    return VINF_HGCM_ASYNC_EXECUTE;
}

/**
 * Implements VBOX_SHCL_GUEST_FN_QUERY_FEATURES.
 *
 * @returns VBox status code.
 * @retval  VINF_HGCM_ASYNC_EXECUTE on success (we complete the message here).
 * @retval  VERR_WRONG_PARAMETER_COUNT
 *
 * @param   hCall       The client's call handle.
 * @param   cParms      Number of parameters.
 * @param   paParms     Array of parameters.
 */
int shClSvcClientMsgQueryFeatures(VBOXHGCMCALLHANDLE hCall, uint32_t cParms, VBOXHGCMSVCPARM paParms[])
{
    /*
     * Validate the request.
     */
    ASSERT_GUEST_RETURN(cParms == 2, VERR_WRONG_PARAMETER_COUNT);
    ASSERT_GUEST_RETURN(paParms[0].type == VBOX_HGCM_SVC_PARM_64BIT, VERR_WRONG_PARAMETER_TYPE);
    ASSERT_GUEST_RETURN(paParms[1].type == VBOX_HGCM_SVC_PARM_64BIT, VERR_WRONG_PARAMETER_TYPE);
    ASSERT_GUEST(paParms[1].u.uint64 & RT_BIT_64(63));

    /*
     * Do the work.
     */
    paParms[0].u.uint64 = g_fHostFeatures0;
    paParms[1].u.uint64 = 0;
    int rc = g_pHelpers->pfnCallComplete(hCall, VINF_SUCCESS);
    if (RT_FAILURE(rc))
        LogFunc(("pfnCallComplete -> %Rrc\n", rc));

    return VINF_HGCM_ASYNC_EXECUTE;
}

/**
 * Implements VBOX_SHCL_GUEST_FN_MSG_PEEK_WAIT and VBOX_SHCL_GUEST_FN_MSG_PEEK_NOWAIT.
 *
 * @returns VBox status code.
 * @retval  VINF_SUCCESS if a message was pending and is being returned.
 * @retval  VERR_TRY_AGAIN if no message pending and not blocking.
 * @retval  VERR_RESOURCE_BUSY if another read already made a waiting call.
 * @retval  VINF_HGCM_ASYNC_EXECUTE if message wait is pending.
 *
 * @param   pClient     The client state.
 * @param   hCall       The client's call handle.
 * @param   cParms      Number of parameters.
 * @param   paParms     Array of parameters.
 * @param   fWait       Set if we should wait for a message, clear if to return
 *                      immediately.
 *
 * @note    Caller takes and leave the client's critical section.
 */
int shClSvcClientMsgPeek(PSHCLCLIENT pClient, VBOXHGCMCALLHANDLE hCall, uint32_t cParms, VBOXHGCMSVCPARM paParms[], bool fWait)
{
    /*
     * Validate the request.
     */
    ASSERT_GUEST_MSG_RETURN(cParms >= 2, ("cParms=%u!\n", cParms), VERR_WRONG_PARAMETER_COUNT);

    uint64_t idRestoreCheck = 0;
    uint32_t i              = 0;
    if (paParms[i].type == VBOX_HGCM_SVC_PARM_64BIT)
    {
        idRestoreCheck = paParms[0].u.uint64;
        paParms[0].u.uint64 = 0;
        i++;
    }
    for (; i < cParms; i++)
    {
        ASSERT_GUEST_MSG_RETURN(paParms[i].type == VBOX_HGCM_SVC_PARM_32BIT, ("#%u type=%u\n", i, paParms[i].type),
                                VERR_WRONG_PARAMETER_TYPE);
        paParms[i].u.uint32 = 0;
    }

    /*
     * Check restore session ID.
     */
    if (idRestoreCheck != 0)
    {
        uint64_t idRestore = g_pHelpers->pfnGetVMMDevSessionId(g_pHelpers);
        if (idRestoreCheck != idRestore)
        {
            paParms[0].u.uint64 = idRestore;
            LogFlowFunc(("[Client %RU32] VBOX_SHCL_GUEST_FN_MSG_PEEK_XXX -> VERR_VM_RESTORED (%#RX64 -> %#RX64)\n",
                         pClient->State.uClientID, idRestoreCheck, idRestore));
            return VERR_VM_RESTORED;
        }
        Assert(!g_pHelpers->pfnIsCallRestored(hCall));
    }

    /*
     * Return information about the first message if one is pending in the list.
     */
    PSHCLCLIENTMSG pFirstMsg = RTListGetFirst(&pClient->MsgQueue, SHCLCLIENTMSG, ListEntry);
    if (pFirstMsg)
    {
        shClSvcMsgSetPeekReturn(pFirstMsg, paParms, cParms);
        LogFlowFunc(("[Client %RU32] VBOX_SHCL_GUEST_FN_MSG_PEEK_XXX -> VINF_SUCCESS (idMsg=%s (%u), cParms=%u)\n",
                     pClient->State.uClientID, ShClHostMsgToStr(pFirstMsg->idMsg), pFirstMsg->idMsg, pFirstMsg->cParms));
        return VINF_SUCCESS;
    }

    /*
     * If we cannot wait, fail the call.
     */
    if (!fWait)
    {
        LogFlowFunc(("[Client %RU32] GUEST_MSG_PEEK_NOWAIT -> VERR_TRY_AGAIN\n", pClient->State.uClientID));
        return VERR_TRY_AGAIN;
    }

    /*
     * Wait for the host to queue a message for this client.
     */
    ASSERT_GUEST_MSG_RETURN(pClient->Pending.uType == 0, ("Already pending! (idClient=%RU32)\n",
                                                           pClient->State.uClientID), VERR_RESOURCE_BUSY);
    pClient->Pending.hHandle = hCall;
    pClient->Pending.cParms  = cParms;
    pClient->Pending.paParms = paParms;
    pClient->Pending.uType   = VBOX_SHCL_GUEST_FN_MSG_PEEK_WAIT;
    LogFlowFunc(("[Client %RU32] Is now in pending mode...\n", pClient->State.uClientID));
    return VINF_HGCM_ASYNC_EXECUTE;
}

/**
 * Implements VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT.
 *
 * @returns VBox status code.
 * @retval  VINF_SUCCESS if a message was pending and is being returned.
 * @retval  VINF_HGCM_ASYNC_EXECUTE if message wait is pending.
 *
 * @param   pClient     The client state.
 * @param   hCall       The client's call handle.
 * @param   cParms      Number of parameters.
 * @param   paParms     Array of parameters.
 *
 * @note    Caller takes and leave the client's critical section.
 */
int shClSvcClientMsgOldGet(PSHCLCLIENT pClient, VBOXHGCMCALLHANDLE hCall, uint32_t cParms, VBOXHGCMSVCPARM paParms[])
{
    /*
     * Validate input.
     */
    ASSERT_GUEST_RETURN(cParms == VBOX_SHCL_CPARMS_GET_HOST_MSG_OLD, VERR_WRONG_PARAMETER_COUNT);
    ASSERT_GUEST_RETURN(paParms[0].type == VBOX_HGCM_SVC_PARM_32BIT, VERR_WRONG_PARAMETER_TYPE); /* id32Msg */
    ASSERT_GUEST_RETURN(paParms[1].type == VBOX_HGCM_SVC_PARM_32BIT, VERR_WRONG_PARAMETER_TYPE); /* f32Formats */

    paParms[0].u.uint32 = 0;
    paParms[1].u.uint32 = 0;

    /*
     * If there is a message pending we can return immediately.
     */
    int rc;
    PSHCLCLIENTMSG pFirstMsg = RTListGetFirst(&pClient->MsgQueue, SHCLCLIENTMSG, ListEntry);
    if (pFirstMsg)
    {
        LogFlowFunc(("[Client %RU32] uMsg=%s (%RU32), cParms=%RU32\n", pClient->State.uClientID,
                     ShClHostMsgToStr(pFirstMsg->idMsg), pFirstMsg->idMsg, pFirstMsg->cParms));

        rc = shClSvcMsgSetOldWaitReturn(pFirstMsg, paParms, cParms);
        AssertPtr(g_pHelpers);
        rc = g_pHelpers->pfnCallComplete(hCall, rc);
        if (rc != VERR_CANCELLED)
        {
            RTListNodeRemove(&pFirstMsg->ListEntry);
            ShClSvcClientMsgFree(pClient, pFirstMsg);

            rc = VINF_HGCM_ASYNC_EXECUTE; /* The caller must not complete it. */
        }
    }
    /*
     * Otherwise we must wait.
     */
    else
    {
        ASSERT_GUEST_MSG_RETURN(pClient->Pending.uType == 0, ("Already pending! (idClient=%RU32)\n", pClient->State.uClientID),
                                VERR_RESOURCE_BUSY);

        pClient->Pending.hHandle = hCall;
        pClient->Pending.cParms  = cParms;
        pClient->Pending.paParms = paParms;
        pClient->Pending.uType   = VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT;

        rc = VINF_HGCM_ASYNC_EXECUTE; /* The caller must not complete it. */

        LogFlowFunc(("[Client %RU32] Is now in pending mode...\n", pClient->State.uClientID));
    }

    LogFlowFunc(("[Client %RU32] rc=%Rrc\n", pClient->State.uClientID, rc));
    return rc;
}

/**
 * Implements VBOX_SHCL_GUEST_FN_MSG_GET.
 *
 * @returns VBox status code.
 * @retval  VINF_SUCCESS if message retrieved and removed from the pending queue.
 * @retval  VERR_TRY_AGAIN if no message pending.
 * @retval  VERR_BUFFER_OVERFLOW if a parmeter buffer is too small.  The buffer
 *          size was updated to reflect the required size, though this isn't yet
 *          forwarded to the guest.  (The guest is better of using peek with
 *          parameter count + 2 parameters to get the sizes.)
 * @retval  VERR_MISMATCH if the incoming message ID does not match the pending.
 * @retval  VINF_HGCM_ASYNC_EXECUTE if message was completed already.
 *
 * @param   pClient      The client state.
 * @param   hCall        The client's call handle.
 * @param   cParms       Number of parameters.
 * @param   paParms      Array of parameters.
 *
 * @note    Called from within pClient->CritSect.
 */
int shClSvcClientMsgGet(PSHCLCLIENT pClient, VBOXHGCMCALLHANDLE hCall, uint32_t cParms, VBOXHGCMSVCPARM paParms[])
{
    /*
     * Validate the request.
     */
    uint32_t const idMsgExpected = cParms > 0 && paParms[0].type == VBOX_HGCM_SVC_PARM_32BIT ? paParms[0].u.uint32
                                 : cParms > 0 && paParms[0].type == VBOX_HGCM_SVC_PARM_64BIT ? paParms[0].u.uint64
                                 : UINT32_MAX;

    /*
     * Return information about the first message if one is pending in the list.
     */
    PSHCLCLIENTMSG pFirstMsg = RTListGetFirst(&pClient->MsgQueue, SHCLCLIENTMSG, ListEntry);
    if (pFirstMsg)
    {
        LogFlowFunc(("First message is: %s (%u), cParms=%RU32\n", ShClHostMsgToStr(pFirstMsg->idMsg), pFirstMsg->idMsg, pFirstMsg->cParms));

        ASSERT_GUEST_MSG_RETURN(pFirstMsg->idMsg == idMsgExpected || idMsgExpected == UINT32_MAX,
                                ("idMsg=%u (%s) cParms=%u, caller expected %u (%s) and %u\n",
                                 pFirstMsg->idMsg, ShClHostMsgToStr(pFirstMsg->idMsg), pFirstMsg->cParms,
                                 idMsgExpected, ShClHostMsgToStr(idMsgExpected), cParms),
                                VERR_MISMATCH);
        ASSERT_GUEST_MSG_RETURN(pFirstMsg->cParms == cParms,
                                ("idMsg=%u (%s) cParms=%u, caller expected %u (%s) and %u\n",
                                 pFirstMsg->idMsg, ShClHostMsgToStr(pFirstMsg->idMsg), pFirstMsg->cParms,
                                 idMsgExpected, ShClHostMsgToStr(idMsgExpected), cParms),
                                VERR_WRONG_PARAMETER_COUNT);

        /* Check the parameter types. */
        for (uint32_t i = 0; i < cParms; i++)
            ASSERT_GUEST_MSG_RETURN(pFirstMsg->aParms[i].type == paParms[i].type,
                                    ("param #%u: type %u, caller expected %u (idMsg=%u %s)\n", i, pFirstMsg->aParms[i].type,
                                     paParms[i].type, pFirstMsg->idMsg, ShClHostMsgToStr(pFirstMsg->idMsg)),
                                    VERR_WRONG_PARAMETER_TYPE);
        /*
         * Copy out the parameters.
         *
         * No assertions on buffer overflows, and keep going till the end so we can
         * communicate all the required buffer sizes.
         */
        int rc = VINF_SUCCESS;
        for (uint32_t i = 0; i < cParms; i++)
            switch (pFirstMsg->aParms[i].type)
            {
                case VBOX_HGCM_SVC_PARM_32BIT:
                    paParms[i].u.uint32 = pFirstMsg->aParms[i].u.uint32;
                    break;

                case VBOX_HGCM_SVC_PARM_64BIT:
                    paParms[i].u.uint64 = pFirstMsg->aParms[i].u.uint64;
                    break;

                case VBOX_HGCM_SVC_PARM_PTR:
                {
                    uint32_t const cbSrc = pFirstMsg->aParms[i].u.pointer.size;
                    uint32_t const cbDst = paParms[i].u.pointer.size;
                    paParms[i].u.pointer.size = cbSrc; /** @todo Check if this is safe in other layers...
                                                        * Update: Safe, yes, but VMMDevHGCM doesn't pass it along. */
                    if (cbSrc <= cbDst)
                        memcpy(paParms[i].u.pointer.addr, pFirstMsg->aParms[i].u.pointer.addr, cbSrc);
                    else
                    {
                        AssertMsgFailed(("#%u: cbSrc=%RU32 is bigger than cbDst=%RU32\n", i, cbSrc, cbDst));
                        rc = VERR_BUFFER_OVERFLOW;
                    }
                    break;
                }

                default:
                    AssertMsgFailed(("#%u: %u\n", i, pFirstMsg->aParms[i].type));
                    rc = VERR_INTERNAL_ERROR;
                    break;
            }
        if (RT_SUCCESS(rc))
        {
            /*
             * Complete the message and remove the pending message unless the
             * guest raced us and cancelled this call in the meantime.
             */
            AssertPtr(g_pHelpers);
            rc = g_pHelpers->pfnCallComplete(hCall, rc);

            LogFlowFunc(("[Client %RU32] pfnCallComplete -> %Rrc\n", pClient->State.uClientID, rc));

            if (rc != VERR_CANCELLED)
            {
                RTListNodeRemove(&pFirstMsg->ListEntry);
                ShClSvcClientMsgFree(pClient, pFirstMsg);
            }

            return VINF_HGCM_ASYNC_EXECUTE; /* The caller must not complete it. */
        }

        LogFlowFunc(("[Client %RU32] Returning %Rrc\n", pClient->State.uClientID, rc));
        return rc;
    }

    paParms[0].u.uint32 = 0;
    paParms[1].u.uint32 = 0;
    LogFlowFunc(("[Client %RU32] -> VERR_TRY_AGAIN\n", pClient->State.uClientID));
    return VERR_TRY_AGAIN;
}

/**
 * Implements VBOX_SHCL_GUEST_FN_MSG_GET.
 *
 * @returns VBox status code.
 * @retval  VINF_SUCCESS if message retrieved and removed from the pending queue.
 * @retval  VERR_TRY_AGAIN if no message pending.
 * @retval  VERR_MISMATCH if the incoming message ID does not match the pending.
 * @retval  VINF_HGCM_ASYNC_EXECUTE if message was completed already.
 *
 * @param   pClient      The client state.
 * @param   cParms       Number of parameters.
 *
 * @note    Called from within pClient->CritSect.
 */
int shClSvcClientMsgCancel(PSHCLCLIENT pClient, uint32_t cParms)
{
    /*
     * Validate the request.
     */
    ASSERT_GUEST_MSG_RETURN(cParms == 0, ("cParms=%u!\n", cParms), VERR_WRONG_PARAMETER_COUNT);

    /*
     * Execute.
     */
    if (pClient->Pending.uType != 0)
    {
        LogFlowFunc(("[Client %RU32] Cancelling waiting thread, isPending=%d, pendingNumParms=%RU32, m_idSession=%x\n",
                     pClient->State.uClientID, pClient->Pending.uType, pClient->Pending.cParms, pClient->State.uSessionID));

        /*
         * The PEEK call is simple: At least two parameters, all set to zero before sleeping.
         */
        int rcComplete;
        if (pClient->Pending.uType == VBOX_SHCL_GUEST_FN_MSG_PEEK_WAIT)
        {
            Assert(pClient->Pending.cParms >= 2);
            if (pClient->Pending.paParms[0].type == VBOX_HGCM_SVC_PARM_64BIT)
                HGCMSvcSetU64(&pClient->Pending.paParms[0], VBOX_SHCL_HOST_MSG_CANCELED);
            else
                HGCMSvcSetU32(&pClient->Pending.paParms[0], VBOX_SHCL_HOST_MSG_CANCELED);
            rcComplete = VINF_TRY_AGAIN;
        }
        /*
         * The MSG_OLD call is complicated, though we're
         * generally here to wake up someone who is peeking and have two parameters.
         * If there aren't two parameters, fail the call.
         */
        else
        {
            Assert(pClient->Pending.uType == VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT);
            if (pClient->Pending.cParms > 0)
                HGCMSvcSetU32(&pClient->Pending.paParms[0], VBOX_SHCL_HOST_MSG_CANCELED);
            if (pClient->Pending.cParms > 1)
                HGCMSvcSetU32(&pClient->Pending.paParms[1], 0);
            rcComplete = pClient->Pending.cParms == 2 ? VINF_SUCCESS : VERR_TRY_AGAIN;
        }

        g_pHelpers->pfnCallComplete(pClient->Pending.hHandle, rcComplete);

        pClient->Pending.hHandle    = NULL;
        pClient->Pending.paParms    = NULL;
        pClient->Pending.cParms     = 0;
        pClient->Pending.uType      = 0;
        return VINF_SUCCESS;
    }
    return VWRN_NOT_FOUND;
}


/**
 * Initializes a Shared Clipboard service's client state.
 *
 * @returns VBox status code.
 * @param   pClientState        Client state to initialize.
 * @param   uClientID           Client ID (HGCM) to use for this client state.
 */
static int shClSvcClientStateInit(PSHCLCLIENTSTATE pClientState, uint32_t uClientID)
{
    LogFlowFuncEnter();

    shclSvcClientStateReset(pClientState);

    /* Register the client. */
    pClientState->uClientID    = uClientID;

    return VINF_SUCCESS;
}

/**
 * Terminated (uninitializes) a Shared Clipboard service's client state.
 *
 * @returns VBox status code.
 * @param   pState              Client state to destroy.
 */
static int shClSvcClientStateTerm(PSHCLCLIENTSTATE pState)
{
    LogFlowFuncEnter();

    shclSvcClientStateReset(pState);

    return VINF_SUCCESS;
}

/**
 * Resets a Shared Clipboard service's client state.
 *
 * @param   pState              Client state to reset.
 */
static void shclSvcClientStateReset(PSHCLCLIENTSTATE pState)
{
    LogFlowFuncEnter();

    pState->fGuestFeatures0 = VBOX_SHCL_GF_NONE;
    pState->fGuestFeatures1 = VBOX_SHCL_GF_NONE;

    pState->cbChunkSize     = VBOX_SHCL_DEFAULT_CHUNK_SIZE; /** @todo Make this configurable. */
    pState->enmSource       = SHCLSOURCE_INVALID;
    pState->fFlags          = SHCLCLIENTSTATE_FLAGS_NONE;

    pState->POD.enmDir             = SHCLTRANSFERDIR_UNKNOWN;
    pState->POD.uFormat            = VBOX_SHCL_FMT_NONE;
    pState->POD.cbToReadWriteTotal = 0;
    pState->POD.cbReadWritten      = 0;

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    pState->Transfers.enmTransferDir = SHCLTRANSFERDIR_UNKNOWN;
#endif
}

