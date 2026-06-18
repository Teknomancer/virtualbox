/* $Id: tstClipboardServiceHost.cpp 114425 2026-06-18 08:30:00Z andreas.loeffler@oracle.com $ */
/** @file
 * Shared Clipboard host service test case.
 */

/*
 * Copyright (C) 2011-2026 Oracle and/or its affiliates.
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

#define LOG_ENABLED
#define LOG_GROUP LOG_GROUP_SHARED_CLIPBOARD
#include <VBox/log.h>

#include <VBox/HostServices/VBoxClipboardExt.h>
#include <VBox/HostServices/VBoxClipboardSvc.h>
#include <VBox/HostServices/VBoxSharedClipboardSvc.h>

#include <iprt/assert.h>
#include <iprt/err.h>
#include <iprt/errcore.h>
#include <iprt/string.h>
#include <iprt/test.h>

extern "C" DECLCALLBACK(DECLEXPORT(int)) VBoxHGCMSvcLoad (VBOXHGCMSVCFNTABLE *ptable);
/**
 * The following no-op functions which correspond to their Shared Clipboard
 * backend namesakes (ShClBackend*()) are used by the dispatcher function
 * below (tstHgcmMockSvcDispatcher()) for intercepting unused backend calls.
 *
 * Note: These host service tests exercise the HGCM service layer,
 *       not the platform clipboard backends!
 */
static int tstShClBackendInit(PSHCLBACKEND pBackend, VBOXHGCMSVCFNTABLE *pTable) { pBackend->pHelpers = pTable->pHelpers; return VINF_SUCCESS; }
static void tstShClBackendDestroy(PSHCLBACKEND) { }
static int tstShClBackendConnect(PSHCLBACKEND, PSHCLCLIENT, bool) { return VINF_SUCCESS; }
static int tstShClBackendDisconnect(PSHCLBACKEND, PSHCLCLIENT) { return VINF_SUCCESS; }
static int tstShClBackendSync(PSHCLBACKEND, PSHCLCLIENT) { return VINF_SUCCESS; }
static int tstShClBackendReportFormats(PSHCLBACKEND, PSHCLCLIENT, SHCLFORMATS) { AssertFailed(); return VINF_SUCCESS; }
static int tstShClBackendReportFormatsToGuest(PSHCLBACKEND, PSHCLCLIENT, uint32_t) { AssertFailed(); return VINF_SUCCESS; }
static int tstShClBackendReadData(PSHCLBACKEND, PSHCLCLIENT, PSHCLCLIENTCMDCTX, SHCLFORMAT, void *, uint32_t, unsigned int *) { AssertFailed(); return VERR_WRONG_ORDER; }
static int tstShClBackendWriteData(PSHCLBACKEND, PSHCLCLIENT, PSHCLCLIENTCMDCTX, SHCLFORMAT, void *, uint32_t) { AssertFailed(); return VINF_SUCCESS; }

static SHCLCLIENT g_Client;
static VBOXHGCMSVCHELPERS g_Helpers = { NULL };

/** Simple call handle structure for the guest call completion callback */
struct VBOXHGCMCALLHANDLE_TYPEDEF
{
    /** Where to store the result code */
    int32_t rc;
};

/** Call completion callback for guest calls. */
static DECLCALLBACK(int) callComplete(VBOXHGCMCALLHANDLE callHandle, int32_t rc)
{
    callHandle->rc = rc;
    return VINF_SUCCESS;
}

/**
 * A copy of the GuestShCl::hgcmDispatcher() dispatcher routine which
 * handles callbacks from the Shared Clipboard host service.  For the
 * variety of tests here we only need ShClBackendInit() to get called to
 * setup the shared clipboard for the tests and the remainder of the
 * backend routines are routed to no-op equivalent routines.
 */
DECLCALLBACK(int) tstHgcmMockSvcDispatcher(void *pvExtension, uint32_t u32Function,
                                           void *pvParms, uint32_t cbParms)
{
    NOREF(pvExtension);
    int rc = VINF_SUCCESS;
    PSHCLEXTPARMS pParms = (PSHCLEXTPARMS)pvParms; /* pParms might be NULL, depending on the message. */

    LogFlowFunc(("u32Function=%RU32, pvParms=%p, cbParms=%RU32\n", u32Function, pvParms, cbParms));

    switch (u32Function)
    {
        case VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_HOST: // via VBOX_SHCL_GUEST_FN_REPORT_FORMATS in the guest
        {
            PSHCLCLIENT pClient = pParms->u.ReportFormats.pClient;
            SHCLFORMATS fFormats = pParms->u.ReportFormats.uFormats;

            rc = tstShClBackendReportFormats(pClient->pBackend, pClient, fFormats);
            if (RT_FAILURE(rc))
                LogRel(("Shared Clipboard: Reporting guest clipboard formats to the host failed with %Rrc\n", rc));
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_FORMAT_REPORT_TO_GUEST:
        {
            PSHCLCLIENT pClient = pParms->u.ReportFormats.pClient;
            SHCLFORMATS fFormats = pParms->u.ReportFormats.uFormats;

            rc = tstShClBackendReportFormatsToGuest(pClient->pBackend, pClient, fFormats);
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_DATA_READ: // via VBOX_SHCL_GUEST_FN_DATA_READ in the guest
        {
            PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
            SHCLCLIENTCMDCTX cmdCtx;
            void *pvData = pParms->u.ReadWriteData.pvData;
            uint32_t cbData = pParms->u.ReadWriteData.cbData;
            SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
            rc = tstShClBackendReadData(pClient->pBackend, pClient, &cmdCtx, fFormats, pvData, cbData,
                &pParms->u.ReadWriteData.cbActual);
            if (RT_SUCCESS(rc))
                LogRel2(("Shared Clipboard: Read host clipboard data (max %RU32 bytes), got %RU32 bytes\n", cbData,
                    pParms->u.ReadWriteData.cbActual));
            else
                LogRel(("Shared Clipboard: Reading host clipboard data failed with %Rrc\n", rc));
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_DATA_WRITE: // via VBOX_SHCL_GUEST_FN_DATA_WRITE in the guest
        {
            PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
            PSHCLCLIENTCMDCTX pCmdCtx = pParms->u.ReadWriteData.pCmdCtx;
            void *pvData = pParms->u.ReadWriteData.pvData;
            uint32_t cbData = pParms->u.ReadWriteData.cbData;
            SHCLFORMATS fFormats = pParms->u.ReadWriteData.uFormat;
            rc = tstShClBackendWriteData(pClient->pBackend, pClient, pCmdCtx, fFormats, pvData, cbData);
            if (RT_FAILURE(rc))
                LogRel(("Shared Clipboard: Writing guest clipboard data to the host failed with %Rrc\n", rc));
            /* Complete any pending events. */
            int rc2 = ShClSvcGuestDataSignal(pClient, pCmdCtx, fFormats, pvData, cbData);
            if (RT_FAILURE(rc2))
                LogRel(("Shared Clipboard: Signalling host about guest clipboard data failed with %Rrc\n", rc2));
            AssertRC(rc2);
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_INIT:
        {
            PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
            VBOXHGCMSVCFNTABLE *pTable = pParms->u.ReadWriteData.pTable;
            rc = tstShClBackendInit(pBackend, pTable);
            break;
        }

        // via VbglR3HGCMDisconnect()->...HGCMService::DisconnectClient()->...HGCMService::instanceDestroy()->...shClSvcUnload()
        case VBOX_CLIPBOARD_EXT_FN_BACKEND_DESTROY:
        {
            PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
            tstShClBackendDestroy(pBackend);
            rc = VINF_SUCCESS;
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_CONNECT: // via VbglR3ClipboardConnect()->VbglR3HGCMConnect() in the guest
        {
            PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
            PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
            bool fHeadless = pParms->u.ReadWriteData.fHeadless;
            rc = tstShClBackendConnect(pBackend, pClient, fHeadless);
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_DISCONNECT:  // via VbglR3ClipboardDisconnect()->VbglR3HGCMDisconnect() in the guest
        {
            PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
            rc = tstShClBackendDisconnect(pClient->pBackend, pClient);
            break;
        }

        case VBOX_CLIPBOARD_EXT_FN_BACKEND_SYNC:
        {
            PSHCLBACKEND pBackend = pParms->u.ReadWriteData.pBackend;
            PSHCLCLIENT pClient = pParms->u.ReadWriteData.pClient;
            rc = tstShClBackendSync(pBackend, pClient);
            break;
        }

        default:
            break;
    }

    return rc;
}

static int setupTable(VBOXHGCMSVCFNTABLE *pTable)
{
    pTable->cbSize = sizeof(*pTable);
    pTable->u32Version = VBOX_HGCM_SVC_VERSION;
    g_Helpers.pfnCallComplete = callComplete;
    pTable->pHelpers = &g_Helpers;
    int rc = VBoxHGCMSvcLoad(pTable);
    RTTESTI_CHECK_MSG_RET(RT_SUCCESS(rc), ("rc=%Rrc\n", rc), rc);
    return pTable->pfnRegisterExtension(pTable->pvService, tstHgcmMockSvcDispatcher, NULL);
}

static void testSetMode(void)
{
    struct VBOXHGCMSVCPARM parms[2];
    VBOXHGCMSVCFNTABLE table;
    uint32_t u32Mode;
    int rc;

    RTTestISub("Testing VBOX_SHCL_HOST_FN_SET_MODE");
    rc = setupTable(&table);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));

    RT_ZERO(g_Client);
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));

    /* Reset global variable which doesn't reset itself. */
    HGCMSvcSetU32(&parms[0], VBOX_SHCL_MODE_OFF);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 1, parms);
    RTTESTI_CHECK_RC_OK(rc);
    u32Mode = ShClSvcGetMode();
    RTTESTI_CHECK_MSG(u32Mode == VBOX_SHCL_MODE_OFF, ("u32Mode=%u\n", (unsigned) u32Mode));

    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 0, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);

    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 2, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);

    HGCMSvcSetU64(&parms[0], 99);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 1, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);

    HGCMSvcSetU32(&parms[0], VBOX_SHCL_MODE_HOST_TO_GUEST);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 1, parms);
    RTTESTI_CHECK_RC_OK(rc);
    u32Mode = ShClSvcGetMode();
    RTTESTI_CHECK_MSG(u32Mode == VBOX_SHCL_MODE_HOST_TO_GUEST, ("u32Mode=%u\n", (unsigned) u32Mode));

    HGCMSvcSetU32(&parms[0], 99);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 1, parms);
    RTTESTI_CHECK_RC(rc, VERR_NOT_SUPPORTED);

    u32Mode = ShClSvcGetMode();
    RTTESTI_CHECK_MSG(u32Mode == VBOX_SHCL_MODE_OFF, ("u32Mode=%u\n", (unsigned) u32Mode));

    rc = table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);
    rc = table.pfnUnload(NULL);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);
}

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
static void testSetTransferMode(void)
{
    struct VBOXHGCMSVCPARM parms[2];
    VBOXHGCMSVCFNTABLE table;

    RTTestISub("Testing VBOX_SHCL_HOST_FN_SET_TRANSFER_MODE");
    int rc = setupTable(&table);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));

    RT_ZERO(g_Client);
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));

    /* Invalid parameter. */
    HGCMSvcSetU64(&parms[0], 99);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_TRANSFER_MODE, 1, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);

    /* Invalid mode. */
    HGCMSvcSetU32(&parms[0], 99);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_TRANSFER_MODE, 1, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_FLAGS);

    /* Enable transfers. */
    HGCMSvcSetU32(&parms[0], VBOX_SHCL_TRANSFER_MODE_F_ENABLED);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_TRANSFER_MODE, 1, parms);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);

    /* Disable transfers again. */
    HGCMSvcSetU32(&parms[0], VBOX_SHCL_TRANSFER_MODE_F_NONE);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_TRANSFER_MODE, 1, parms);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);

    rc = table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);
    rc = table.pfnUnload(NULL);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);
}
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

/* Adds a host data read request message to the client's message queue. */
static void testMsgAddReadData(PSHCLCLIENT pClient, SHCLFORMATS fFormats)
{
    int rc = ShClSvcReadDataFromGuestAsync(pClient, fFormats, NULL /* ppEvent */);
    RTTESTI_CHECK_RC_OK(rc);
}

/* Does testing of VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, needed for providing compatibility to older Guest Additions clients. */
static void testGetHostMsgOld(void)
{
    struct VBOXHGCMSVCPARM parms[2];
    VBOXHGCMSVCFNTABLE table;
    VBOXHGCMCALLHANDLE_TYPEDEF call;
    int rc;

    RTTestISub("Setting up VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT test");
    rc = setupTable(&table);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));
    /* Unless we are bidirectional the host message requests will be dropped. */
    HGCMSvcSetU32(&parms[0], VBOX_SHCL_MODE_BIDIRECTIONAL);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_MODE, 1, parms);
    RTTESTI_CHECK_RC_OK(rc);


    RTTestISub("Testing one format, waiting guest call.");
    RT_ZERO(g_Client);
    HGCMSvcSetU32(&parms[0], 0);
    HGCMSvcSetU32(&parms[1], 0);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK_RC(call.rc, VERR_IPE_UNINITIALIZED_STATUS);  /* This should get updated only when the guest call completes. */
    testMsgAddReadData(&g_Client, VBOX_SHCL_FMT_UNICODETEXT);
    RTTESTI_CHECK(parms[0].u.uint32 == VBOX_SHCL_HOST_MSG_READ_DATA);
    RTTESTI_CHECK(parms[1].u.uint32 == VBOX_SHCL_FMT_UNICODETEXT);
    RTTESTI_CHECK_RC_OK(call.rc);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK_RC(call.rc, VERR_IPE_UNINITIALIZED_STATUS);  /* This call should not complete yet. */
    table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);

    RTTestISub("Testing one format, no waiting guest calls.");
    RT_ZERO(g_Client);
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));
    testMsgAddReadData(&g_Client, VBOX_SHCL_FMT_HTML);
    HGCMSvcSetU32(&parms[0], 0);
    HGCMSvcSetU32(&parms[1], 0);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK(parms[0].u.uint32 == VBOX_SHCL_HOST_MSG_READ_DATA);
    RTTESTI_CHECK(parms[1].u.uint32 == VBOX_SHCL_FMT_HTML);
    RTTESTI_CHECK_RC_OK(call.rc);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK_RC(call.rc, VERR_IPE_UNINITIALIZED_STATUS);  /* This call should not complete yet. */
    table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);

    RTTestISub("Testing two formats, waiting guest call.");
    RT_ZERO(g_Client);
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));
    HGCMSvcSetU32(&parms[0], 0);
    HGCMSvcSetU32(&parms[1], 0);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK_RC(call.rc, VERR_IPE_UNINITIALIZED_STATUS);  /* This should get updated only when the guest call completes. */
    testMsgAddReadData(&g_Client, VBOX_SHCL_FMT_UNICODETEXT | VBOX_SHCL_FMT_HTML);
    RTTESTI_CHECK(parms[0].u.uint32 == VBOX_SHCL_HOST_MSG_READ_DATA);
    RTTESTI_CHECK(parms[1].u.uint32 == VBOX_SHCL_FMT_UNICODETEXT);
    RTTESTI_CHECK_RC_OK(call.rc);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK(parms[0].u.uint32 == VBOX_SHCL_HOST_MSG_READ_DATA);
    RTTESTI_CHECK(parms[1].u.uint32 == VBOX_SHCL_FMT_HTML);
    RTTESTI_CHECK_RC_OK(call.rc);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK_RC(call.rc, VERR_IPE_UNINITIALIZED_STATUS);  /* This call should not complete yet. */
    table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);

    RTTestISub("Testing two formats, no waiting guest calls.");
    RT_ZERO(g_Client);
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));
    testMsgAddReadData(&g_Client, VBOX_SHCL_FMT_UNICODETEXT | VBOX_SHCL_FMT_HTML);
    HGCMSvcSetU32(&parms[0], 0);
    HGCMSvcSetU32(&parms[1], 0);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK(parms[0].u.uint32 == VBOX_SHCL_HOST_MSG_READ_DATA);
    RTTESTI_CHECK(parms[1].u.uint32 == VBOX_SHCL_FMT_UNICODETEXT);
    RTTESTI_CHECK_RC_OK(call.rc);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK(parms[0].u.uint32 == VBOX_SHCL_HOST_MSG_READ_DATA);
    RTTESTI_CHECK(parms[1].u.uint32 == VBOX_SHCL_FMT_HTML);
    RTTESTI_CHECK_RC_OK(call.rc);
    call.rc = VERR_IPE_UNINITIALIZED_STATUS;
    table.pfnCall(NULL, &call, 1 /* clientId */, &g_Client, VBOX_SHCL_GUEST_FN_MSG_OLD_GET_WAIT, 2, parms, 0);
    RTTESTI_CHECK_RC(call.rc, VERR_IPE_UNINITIALIZED_STATUS);  /* This call should not complete yet. */
    table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);
    table.pfnUnload(NULL);
}

static void testSetHeadless(void)
{
    struct VBOXHGCMSVCPARM parms[2];
    VBOXHGCMSVCFNTABLE table;
    bool fHeadless;
    int rc;

    RTTestISub("Testing HOST_FN_SET_HEADLESS");
    rc = setupTable(&table);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));

    RT_ZERO(g_Client);
    rc = table.pfnConnect(NULL, 1 /* clientId */, &g_Client, 0, 0);
    RTTESTI_CHECK_MSG_RETV(RT_SUCCESS(rc), ("rc=%Rrc\n", rc));

    /* Reset global variable which doesn't reset itself. */
    HGCMSvcSetU32(&parms[0], false);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_HEADLESS,
                           1, parms);
    RTTESTI_CHECK_RC_OK(rc);
    fHeadless = ShClSvcGetHeadless();
    RTTESTI_CHECK_MSG(fHeadless == false, ("fHeadless=%RTbool\n", fHeadless));
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_HEADLESS,
                           0, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_HEADLESS,
                           2, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);
    HGCMSvcSetU64(&parms[0], 99);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_HEADLESS,
                           1, parms);
    RTTESTI_CHECK_RC(rc, VERR_INVALID_PARAMETER);
    HGCMSvcSetU32(&parms[0], true);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_HEADLESS,
                           1, parms);
    RTTESTI_CHECK_RC_OK(rc);
    fHeadless = ShClSvcGetHeadless();
    RTTESTI_CHECK_MSG(fHeadless == true, ("fHeadless=%RTbool\n", fHeadless));
    HGCMSvcSetU32(&parms[0], 99);
    rc = table.pfnHostCall(NULL, VBOX_SHCL_HOST_FN_SET_HEADLESS,
                           1, parms);
    RTTESTI_CHECK_RC_OK(rc);
    fHeadless = ShClSvcGetHeadless();
    RTTESTI_CHECK_MSG(fHeadless == true, ("fHeadless=%RTbool\n", fHeadless));
    rc = table.pfnDisconnect(NULL, 1 /* clientId */, &g_Client);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);
    rc = table.pfnUnload(NULL);
    RTTESTI_CHECK_RC(rc, VINF_SUCCESS);
}

static void testHostCall(void)
{
    testSetMode();
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    testSetTransferMode();
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
    testSetHeadless();
}

int main(int argc, char *argv[])
{
    /*
     * Init the runtime, test and say hello.
     */
    const char *pcszExecName;
    NOREF(argc);
    pcszExecName = strrchr(argv[0], '/');
    pcszExecName = pcszExecName ? pcszExecName + 1 : argv[0];
    RTTEST hTest;
    RTEXITCODE rcExit = RTTestInitAndCreate(pcszExecName, &hTest);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;
    RTTestBanner(hTest);

    /* Don't let assertions in the host service panic (core dump) the test cases. */
    RTAssertSetMayPanic(false);

    /*
     * Run the tests.
     */
    testHostCall();
    testGetHostMsgOld();

    /*
     * Summary
     */
    return RTTestSummaryAndDestroy(hTest);
}


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
int ShClBackendTransferHandleStatusReply(PSHCLBACKEND, PSHCLCLIENT, PSHCLTRANSFER, SHCLSOURCE, SHCLTRANSFERSTATUS, int) { return VINF_SUCCESS; }
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
