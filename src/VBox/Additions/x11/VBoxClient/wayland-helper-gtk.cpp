/* $Id: wayland-helper-gtk.cpp 114620 2026-07-04 00:00:20Z knut.osmundsen@oracle.com $ */
/** @file
 * Guest Additions - Gtk helper for Wayland.
 *
 * This module implements Shared Clipboard and Drag-n-Drop
 * support for Wayland guests using Gtk library.
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

#include <iprt/file.h>
#include <iprt/localipc.h>
#include <iprt/path.h>
#include <iprt/process.h>
#include <iprt/pipe.h>
#include <iprt/rand.h>
#include <iprt/semaphore.h>
#include <iprt/string.h>
#include <iprt/ctype.h>

#include <VBox/GuestHost/DisplayServerType.h>
#include <VBox/GuestHost/clipboard-helper.h>
#include <VBox/GuestHost/mime-type-converter.h>

#include "VBoxClient.h"
#include "clipboard.h"
#include "wayland-helper.h"
#include "wayland-helper-ipc.h"

#include "vbox-gtk.h"

/** Gtk session data.
 *
 * A structure which accumulates all the necessary data required to
 * maintain session between host and Wayland for clipboard sharing
 * and drag-n-drop.*/
typedef struct
{
    /* Generic VBoxClient Wayland session data (synchronization point). */
    vbcl_wl_session_t                       Base;
    /** Randomly generated session ID, should be used by
     *  both VBoxClient and vboxwl tool. */
    uint32_t                                uSessionId;
    /** IPC connection flow control between VBoxClient and vboxwl tool. */
    vbcl::ipc::data::DataIpc                *oDataIpc;
    /** IPC connection handle. */
    RTLOCALIPCSESSION                       hIpcSession;
    /** Popup window process handle. */
    RTPROCESS                               popupProc;
} vbox_wl_gtk_ipc_session_t;

/**
 * A set of objects required to handle clipboard sharing over
 * and drag-n-drop using Gtk library. */
typedef struct
{
    /** Wayland event loop thread. */
    RTTHREAD                                Thread;

    /** A flag which indicates that Wayland event loop should terminate. */
    volatile bool                           fShutdown;

    /** Communication session between host event loop and Wayland. */
    vbox_wl_gtk_ipc_session_t               Session;

    /** Pointer to the VBoxClient shared clipboard context (where this structure
     *  probably should live). */
    PSHCLCONTEXT                            pShClCtx;

    /** Local IPC server object. */
    RTLOCALIPCSERVER                        hIpcServer;

    /** IPC server socket name prefix. */
    const char                              *pcszIpcSockPrefix;
} vbox_wl_gtk_ctx_t;

/** Private data for a callback when host reports clipboard formats. */
struct vbcl_wayland_hlp_gtk_clip_hg_report_priv
{
    /** Helper context. */
    vbox_wl_gtk_ctx_t *pCtx;
    /** Clipboard formats. */
    SHCLFORMATS fFormats;
};

/** Private data for a callback when host requests clipboard
 *  data in specified format. */
struct vbcl_wayland_hlp_gtk_clip_gh_read_priv
{
    /** Helper context. */
    vbox_wl_gtk_ctx_t *pCtx;
    /** Clipboard format. */
    SHCLFORMAT uFormat;
};

/** Helper context. */
static vbox_wl_gtk_ctx_t g_GtkClipCtx;


/**
 * Reset session, terminate popup process and free allocated resources.
 *
 * @returns IPRT status code.
 * @param   enmSessionType      Session type (unused).
 * @param   pvUser              User data.
 */
static DECLCALLBACK(int) vbcl_wayland_hlp_gtk_session_end_cb(
    vbcl_wl_session_type_t enmSessionType, void *pvUser)
{
    vbox_wl_gtk_ipc_session_t *pSession = (vbox_wl_gtk_ipc_session_t *)pvUser;
    AssertPtrReturn(pSession, VERR_INVALID_PARAMETER);

    RT_NOREF(enmSessionType);

    /* Make sure valid session is in progress. */
    AssertReturn(pSession->uSessionId > 0, VERR_INVALID_PARAMETER);

    int rc = RTProcWait(pSession->popupProc, RTPROCWAIT_FLAGS_BLOCK, NULL);
    if (RT_FAILURE(rc))
        rc = RTProcTerminate(pSession->popupProc);
    if (RT_FAILURE(rc))
        VBClLogError("session %u: unable to stop popup window process: rc=%Rrc\n",
                     pSession->uSessionId, rc);

    if (RT_SUCCESS(rc))
    {
        pSession->uSessionId = 0;

        pSession->oDataIpc->reset();
        delete pSession->oDataIpc;
    }

    return rc;
}

/**
 * Session callback: Handle sessions started by host events.
 *
 * @returns IPRT status code.
 * @param   enmSessionType      Session type, must be verified as
 *                              a consistency check.
 * @param   pvUser              User data (IPC connection handle
 *                              to vboxwl tool).
 */
static DECLCALLBACK(int) vbcl_wayland_hlp_gtk_worker_join_cb(
    vbcl_wl_session_type_t enmSessionType, void *pvUser)
{
    vbox_wl_gtk_ctx_t *pCtx = (vbox_wl_gtk_ctx_t *)pvUser;
    AssertPtrReturn(pCtx, VERR_INVALID_POINTER);

    VBCL_LOG_CALLBACK;

    /* Make sure valid session is in progress. */
    AssertReturn(pCtx->Session.uSessionId > 0, VERR_INVALID_PARAMETER);

    /* Select corresponding IPC flow depending on session type. */
    const vbcl::ipc::flow_t *pFlow;
    if      (enmSessionType == VBCL_WL_CLIPBOARD_SESSION_TYPE_COPY_TO_GUEST)
        pFlow = vbcl::ipc::data::HGCopyFlow;
    else if (enmSessionType == VBCL_WL_CLIPBOARD_SESSION_TYPE_ANNOUNCE_TO_HOST)
        pFlow = vbcl::ipc::data::GHAnnounceAndCopyFlow;
    else if (enmSessionType == VBCL_WL_CLIPBOARD_SESSION_TYPE_COPY_TO_HOST)
        pFlow = vbcl::ipc::data::GHCopyFlow;
    else
        AssertFailedReturn(VERR_INVALID_PARAMETER);
    AssertPtr(pFlow);

    /* Proceed with selected flow. */
    return pCtx->Session.oDataIpc->flow(pFlow, pCtx->Session.hIpcSession);
}

/**
 * @callback_method_impl{FNRTTHREAD, IPC server thread worker.}
 */
static DECLCALLBACK(int) vbcl_wayland_hlp_gtk_worker(RTTHREAD ThreadSelf, void *pvUser)
{
    vbox_wl_gtk_ctx_t * const pCtx = (vbox_wl_gtk_ctx_t *)pvUser;
    AssertPtrReturn(pCtx, VERR_INVALID_POINTER);
    AssertPtrReturn(pCtx->pcszIpcSockPrefix, VERR_INVALID_POINTER);

    /*
     * Create & configure IPC server.
     */
    VBClLogVerbose(1, "starting IPC...\n");
    char szIpcServerName[128];
    int rc = vbcl_wayland_hlp_gtk_ipc_srv_name(pCtx->pcszIpcSockPrefix, szIpcServerName, sizeof(szIpcServerName));
    if (RT_SUCCESS(rc))
    {
        rc = RTLocalIpcServerCreate(&pCtx->hIpcServer, szIpcServerName, 0);
        if (RT_SUCCESS(rc))
        {
            rc = RTLocalIpcServerSetAccessMode(pCtx->hIpcServer, RTFS_UNIX_IRUSR | RTFS_UNIX_IWUSR);
            if (RT_SUCCESS(rc))
            {
                VBClLogVerbose(1, "started IPC server '%s'\n", szIpcServerName);
                RTThreadUserSignal(ThreadSelf);

                vbcl_wayland_session_init(&pCtx->Session.Base);

                /*
                 * Process IPC requests till we're told to shut down.
                 */
                while (!ASMAtomicReadBool(&pCtx->fShutdown))
                {
                    rc = RTLocalIpcServerListen(pCtx->hIpcServer, &pCtx->Session.hIpcSession);
                    if (RT_SUCCESS(rc))
                    {
                        /* Authenticate remote user. Only allow connection from
                           process who belongs to the same UID. */
                        RTUID uUid;
                        rc = RTLocalIpcSessionQueryUserId(pCtx->Session.hIpcSession, &uUid);
                        if (RT_SUCCESS(rc))
                        {
                            RTUID uLocalUID = geteuid();
                            if (   uLocalUID != 0
                                && uLocalUID == uUid)
                            {
                                VBClLogVerbose(1, "new IPC connection\n");

                                rc = VBClWaylandSessionJoinAnyType(&pCtx->Session.Base, vbcl_wayland_hlp_gtk_worker_join_cb, pCtx);

                                VBClLogVerbose(1, "IPC flow completed, rc=%Rrc\n", rc);

                                rc = vbcl_wayland_session_end(&pCtx->Session.Base,
                                                              vbcl_wayland_hlp_gtk_session_end_cb,  &pCtx->Session);
                                VBClLogVerbose(1, "IPC session ended, rc=%Rrc\n", rc);
                            }
                            else
                                VBClLogError("incoming IPC connection rejected - UID mismatch: %d/%d\n", uLocalUID, uUid);
                        }
                        else
                            VBClLogError("failed to get remote IPC UID, rc=%Rrc\n", rc);

                        RTLocalIpcSessionClose(pCtx->Session.hIpcSession);
                    }
                    else if (rc != VERR_CANCELLED)
                        VBClLogVerbose(1, "IPC connection has failed, rc=%Rrc\n", rc);
                } /* loop */

                rc = VINF_SUCCESS;
            }
            int rc2 = RTLocalIpcServerDestroy(pCtx->hIpcServer);
            AssertRCStmt(rc2, rc = RT_SUCCESS(rc) ? rc2 : rc);
        }
        else
            VBClLogError("Failed to create IPC server instance: %Rrc\n", rc);
    }
    else
        VBClLogError("Failed to assemble IPC server name: %Rrc\n", rc);
    VBClLogVerbose(1, "IPC stopped\n");
    return rc;
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER,pfnProbe}
 */
static DECLCALLBACK(int) vbcl_wayland_hlp_gtk_probe(void)
{
    int fCaps = VBOX_WAYLAND_HELPER_CAP_NONE;

    if (VBGHDisplayServerTypeIsGtkAvailable())
        fCaps |= VBOX_WAYLAND_HELPER_CAP_CLIPBOARD;

    return fCaps;
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_CLIPBOARD,pfnInit}
 */
RTDECL(int) vbcl_wayland_hlp_gtk_clip_init(void)
{
    VBCL_LOG_CALLBACK;

    RT_ZERO(g_GtkClipCtx);

    /* Set IPC server socket name prefix before server is started. */
    g_GtkClipCtx.pcszIpcSockPrefix = VBOXWL_SRV_NAME_PREFIX_CLIP;

    return vbcl_wayland_thread_start(&g_GtkClipCtx.Thread, vbcl_wayland_hlp_gtk_worker, "wl-gtk-ipc", &g_GtkClipCtx);
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_CLIPBOARD,pfnTerm}
 */
RTDECL(int) vbcl_wayland_hlp_gtk_clip_term(void)
{
    int rc;
    int rcThread = 0;
    vbox_wl_gtk_ctx_t *pCtx = &g_GtkClipCtx;

    /* Set termination flag. */
    pCtx->fShutdown = true;

    /* Cancel IPC loop. */
    rc = RTLocalIpcServerCancel(pCtx->hIpcServer);
    if (RT_FAILURE(rc))
        VBClLogError("unable to notify IPC server about shutdown, rc=%Rrc\n", rc);

    if (RT_SUCCESS(rc))
    {
        /* Wait for Gtk event loop thread to shutdown. */
        rc = RTThreadWait(pCtx->Thread, RT_MS_30SEC, &rcThread);
        VBClLogInfo("gtk event thread exited with status, rc=%Rrc\n", rcThread);
    }
    else
        VBClLogError("unable to stop gtk thread, rc=%Rrc\n", rc);

    return rc;
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_CLIPBOARD,pfnSetClipboardCtx}
 */
static DECLCALLBACK(void) vbcl_wayland_hlp_gtk_clip_set_ctx(PSHCLCONTEXT pCtx)
{
    g_GtkClipCtx.pShClCtx = pCtx;
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_CLIPBOARD,pfnPopup}
 */
static DECLCALLBACK(int) vbcl_wayland_hlp_gtk_clip_popup(void)
{
    PSHCLCONTEXT const pShClCtx = &g_Ctx;
    LogRel3(("%s:\n", __func__));

    /*
     * Take down the revision number before we start, so we won't can detect
     * host clipboard updates racing us.
     */
    RTCritSectEnter(&pShClCtx->Wl.CritSect);
    uint64_t const uRevision = pShClCtx->Wl.uRevision;
    RTCritSectLeave(&pShClCtx->Wl.CritSect);

    /*
     * Read the clipboard content.
     */
    /* Create pipe for reading content. */
    RTHANDLE hPipeRead  = { RTHANDLETYPE_PIPE };
    RTHANDLE hStdOut    = { RTHANDLETYPE_PIPE };
    int rc = RTPipeCreate(&hPipeRead.u.hPipe, &hStdOut.u.hPipe, RTPIPE_C_INHERIT_WRITE);
    if (RT_SUCCESS(rc))
    {
        /* Pass on the log verbosity level. */
        char szSetVerbosity[sizeof(VBOXWL_OPT_VERBOSITY) + 64];
        RTStrPrintf(szSetVerbosity, sizeof(szSetVerbosity), VBOXWL_OPT_VERBOSITY "=%u", g_cVerbosity);
        const char *apszArgs[] =
        {
            RTProcExecutablePath(),
            "--clipboard-get",
            szSetVerbosity,
            NULL
        };

        /* Create the process. */
        RTPROCESS hProcess = NIL_RTPROCESS;
        rc = RTProcCreateEx(apszArgs[0], apszArgs, RTENV_DEFAULT, 0 /*fFlags*/,
                            NULL, &hStdOut, NULL, NULL, NULL, NULL, &hProcess);
        RTPipeClose(hStdOut.u.hPipe);
        if (RT_SUCCESS(rc))
        {
            /*
             * Read and process the output.
             */
            SHCLFORMATS fFormats = UINT32_MAX;
            SHCLCACHE   Cache;
            ShClCacheInit(&Cache);
            rc = VBClClipboardDeserializeCache(&hPipeRead, &Cache, &fFormats, RT_MS_30SEC);
            bool const fDataOkay = RT_SUCCESS(rc);

            rc = RTPipeClose(hPipeRead.u.hPipe);
            AssertLogRelRC(rc);

            /*
             * Make sure it terminates.
             */
            RTPROCSTATUS ProcStatus = { -1, RTPROCEXITREASON_ABEND };
            uint64_t const msProcWait = RTTimeMilliTS();
            for (;;)
            {
                rc = RTProcWait(hProcess, RTPROCWAIT_FLAGS_NOBLOCK, &ProcStatus);
                if (   (rc != VERR_PROCESS_RUNNING && rc != VERR_INTERRUPTED)
                    || RTTimeMilliTS() - msProcWait > RT_MS_1SEC)
                    break;
                RTThreadSleep(8 /*ms*/);
            }
            if (rc == VERR_PROCESS_RUNNING || rc == VERR_INTERRUPTED)
            {
                rc = RTProcTerminate(hProcess);
                rc = RTProcWait(hProcess, RT_SUCCESS(rc) ? RTPROCWAIT_FLAGS_BLOCK : RTPROCWAIT_FLAGS_NOBLOCK, &ProcStatus);
            }
            if (   RT_SUCCESS(rc)
                && ProcStatus.enmReason == RTPROCEXITREASON_NORMAL)
            {
                /*
                 * RTEXITCODE_SUCCESS: We've got data. Report it to the host.
                 */
                if (ProcStatus.iStatus == RTEXITCODE_SUCCESS && fDataOkay)
                {
                    RTCritSectEnter(&pShClCtx->Wl.CritSect);
                    if (pShClCtx->Wl.uRevision == uRevision)
                    {
                        if (   SHCLWLCTX_REV_IS_OTHER(pShClCtx->Wl.uRevision)
                            || pShClCtx->Wl.fOurFormats != fFormats
                            || !ShClCacheEquals(&pShClCtx->Wl.OurCache, &Cache))
                        {
                            LogRel2(("%s: --clipboard-get exit code: 0 - sending formats %#x and data to the host\n",
                                     __func__, fFormats));

                            VbghWaylandClipboardResetOurState(&pShClCtx->Wl, __func__, NULL);

                            pShClCtx->Wl.fOurFormats = fFormats;
                            rc = ShClCacheTransferAll(&pShClCtx->Wl.OurCache, &Cache);
                            AssertRC(rc);

                            rc = RTSemEventMultiSignal(pShClCtx->Wl.hOurCacheFilledEvent);
                            AssertRC(rc);

                            /* Do the reporting to the host. */
                            rc = VbglR3ClipboardReportFormats(pShClCtx->CmdCtx.idClient, fFormats);
                            AssertLogRelRC(rc);
                        }
                        else
                            LogRel2(("%s: --clipboard-get: skipping. data is unchanged\n", __func__));
                    }
                    else
                        LogRel2(("%s: --clipboard-get: Revision changed while getting guest clipboard data (%#RX64 -> %#RX64)\n",
                                 __func__, uRevision, pShClCtx->Wl.uRevision));
                    RTCritSectLeave(&pShClCtx->Wl.CritSect);
                }
                /*
                 * RTEXITCODE_SKIPPED: Clipboard contains host data or no data at all.
                 */
                else if (ProcStatus.iStatus == RTEXITCODE_SKIPPED && fDataOkay && fFormats == 0)
                    LogRel2(("%s: --clipboard-get exit code: skipped\n", __func__));
                /*
                 * Anything else is bad.
                 */
                else
                    VBClLogError("%s: --clipboard-get exit code: %d, fDataOkay=%d fFormats=%#x\n",
                                 __func__, ProcStatus.iStatus, fDataOkay, fFormats);
            }
            else if (RT_SUCCESS(rc) && ProcStatus.enmReason == RTPROCEXITREASON_SIGNAL)
                VBClLogError("%s: --clipboard-get terminated by signal: %d\n", __func__, ProcStatus.iStatus);
            else if (RT_SUCCESS(rc))
                VBClLogError("%s: --clipboard-get abend'ed (%d)\n", __func__, ProcStatus.iStatus);
            else
                VBClLogError("%s: RTProcWait failed on --clipboard-get: %Rrc\n", __func__, rc);
            ShClCacheTerm(&Cache);
        }
        else
        {
            VBClLogError("RTProcCreateEx failed: %Rrc\n", rc);
            RTPipeClose(hPipeRead.u.hPipe);
        }
    }
    else
        VBClLogError("RTPipeCreate failed: %Rrc\n", rc);
    return VINF_SUCCESS;
}

/**
 * Helper for terminating (kill -9 if not quitting by itself) a child and
 * waiting for it (zombie management).
 */
static int vbclWaylandHlpGtkTerminateAndWaitForChild(RTPROCESS hProcess)
{
    /*
     * Since we cannot wait on children with a generic timeout, we first poll
     * for 1 second, then do kill -9 and poll for another 5 seconds, and repeat
     * that once again before giving up.  A total of ~11 seconds.
     */
    RTPROCSTATUS ProcStatus =  { -1, RTPROCEXITREASON_ABEND };
    int rc = RTProcWait(hProcess, RTPROCWAIT_FLAGS_NOBLOCK, &ProcStatus);
    for (unsigned i = 0; rc == VERR_PROCESS_RUNNING && i < 3; i++)
    {
        uint64_t const msStart = RTTimeMilliTS();
        do
        {
            RTThreadSleep(32);
            rc = RTProcWait(hProcess, RTPROCWAIT_FLAGS_NOBLOCK, &ProcStatus);
        } while (   rc == VERR_PROCESS_RUNNING
                 && RTTimeMilliTS() - msStart < (!i ? RT_MS_1SEC : RT_MS_5SEC));
        if (rc == VERR_PROCESS_RUNNING)
            RTProcTerminate(hProcess);
    }
    if (RT_SUCCESS(rc))
        LogRel2(("--clipboard-set process %u (%#x) exited: iStatus=%d enmReason=%d (rc=%Rrc)\n",
                 hProcess, hProcess, ProcStatus.iStatus, ProcStatus.enmReason, rc));
    else
        VBClLogError("Failed to terminate --clipboard-set process %u (%#x): %Rrc\n", hProcess, hProcess, rc);
    return rc;
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_CLIPBOARD,pfnHGClipReport}
 */
static DECLCALLBACK(int) vbcl_wayland_hlp_gtk_clip_hg_report(PSHCLCONTEXT pCtx, SHCLFORMATS fFormats)
{
    LogRel3(("%s:\n", __func__));

    /*
     * Nudge any existing --clipboard-set process into quitting while we
     * retrieve the host data.
     */
    RTPROCESS const hProcPrev = pCtx->Wl.hProcClipboardSet;
    if (hProcPrev != NIL_RTPROCESS)
    {
        pCtx->Wl.hProcClipboardSet = NIL_RTPROCESS;
        RTPipeClose(pCtx->Wl.hPipeClipboardSet);
        pCtx->Wl.hPipeClipboardSet = NIL_RTPIPE;
    }

    /*
     * Read all the host formats into the cache.
     */
    RTCritSectEnter(&pCtx->Wl.CritSect);
    uint64_t const uRevision = pCtx->Wl.uRevision;
    RTCritSectLeave(&pCtx->Wl.CritSect);
    if (!SHCLWLCTX_REV_IS_OTHER(uRevision))
    {
        LogRel2(("%s: Owner switched (rev %#RX64)\n", __func__, uRevision));
        return VINF_SUCCESS;
    }

    SHCLFORMATS fFormatsLeft = fFormats;
    while (fFormatsLeft)
    {
        /* Get the first format left in the mask. */
        SHCLFORMAT const uCurFormat = fFormatsLeft & ~(fFormatsLeft - 1);
        Assert(uCurFormat && (fFormatsLeft & uCurFormat));
        fFormatsLeft &= ~uCurFormat;

        /* Retrieve the data. */
        void    *pvData = NULL;
        uint32_t cbData = 0;
        int rc = VbglR3ClipboardReadDataEx(&pCtx->CmdCtx, uCurFormat, &pvData, &cbData);

        RTCritSectEnter(&pCtx->Wl.CritSect);

        /* Recheck the revision number before continuing. */
        if (uRevision != pCtx->Wl.uRevision)
        {
            LogRel2(("%s: Revision changed while getting host data: %#RX64 -> %#RX64\n", __func__, uRevision, pCtx->Wl.uRevision));
            RTCritSectLeave(&pCtx->Wl.CritSect);
            if (RT_SUCCESS(rc))
                RTMemFree(pvData);
            return VINF_SUCCESS;
        }

        /* Enter the data into the cache on success.  A failure here is probably
           an indicator that the host clipboard has changed again, but we'll just
           remove the format from the mask for now as we don't know that for sure. */
        if (RT_SUCCESS(rc))
        {
            rc = ShClCacheSet(&pCtx->Wl.OtherCache, uCurFormat, pvData, cbData);
            RTMemFree(pvData);
        }
        else
            LogRel(("%s: Error reading %#x from the host: %Rrc\n", __func__, uCurFormat, rc));
        if (RT_FAILURE(rc))
        {
            pCtx->Wl.fOtherFormats = fFormats &= ~uCurFormat;
            LogRel(("%s: dropping format %#x, new mask %#x.\n", __func__, uCurFormat, fFormats));
        }

        RTCritSectLeave(&pCtx->Wl.CritSect);
    }

    /*
     * Kick of the --clipboard-set child.
     */
    /* Create pipe for reading content. */
    RTHANDLE hStdIn     = { RTHANDLETYPE_PIPE };
    RTHANDLE hPipeWrite = { RTHANDLETYPE_PIPE };
    int rc = RTPipeCreate(&hStdIn.u.hPipe, &hPipeWrite.u.hPipe, RTPIPE_C_INHERIT_READ);
    if (RT_SUCCESS(rc))
    {
        /* Create dummy pipe for signalling termination to poll(). */
        RTPIPE hPipeTermRead  = NIL_RTPIPE;
        RTPIPE hPipeWriteTerm = NIL_RTPIPE;
        rc = RTPipeCreate(&hPipeTermRead, &hPipeWriteTerm, RTPIPE_C_INHERIT_READ);
        if (RT_SUCCESS(rc))
        {
            /* Pass on the log verbosity level. */
            char szSetVerbosity[sizeof(VBOXWL_OPT_VERBOSITY) + 64];
            RTStrPrintf(szSetVerbosity, sizeof(szSetVerbosity), VBOXWL_OPT_VERBOSITY "=%u", g_cVerbosity);
            char szNotifyPipe[sizeof("--termination-pipe=10930940323467909656")];
            RTStrPrintf(szNotifyPipe, sizeof(szNotifyPipe), "--termination-pipe=%u", (uint32_t)RTPipeToNative(hPipeTermRead));
            const char *apszArgs[] =
            {
                RTProcExecutablePath(),
                "--clipboard-set",
                szSetVerbosity,
                szNotifyPipe,
                NULL
            };

            /* Create the process. */
            RTPROCESS hProcess = NIL_RTPROCESS;
            rc = RTProcCreateEx(apszArgs[0], apszArgs, RTENV_DEFAULT, 0 /*fFlags*/,
                                &hStdIn, NULL, NULL, NULL, NULL, NULL, &hProcess);
            if (RT_SUCCESS(rc))
            {
                /* close the child end of the pipes. */
                RTPipeClose(hPipeTermRead);
                hPipeTermRead = NIL_RTPIPE;
                RTPipeClose(hStdIn.u.hPipe);
                hStdIn.u.hPipe = NIL_RTPIPE;
                LogRel2(("Launched --clipboard-set process %u (%#x) ...\n", hProcess, hProcess));

                /* Feed the clipboard data to the child. */
                rc = VBClClipboardSerializeCache(&pCtx->Wl.OtherCache, fFormats, &hPipeWrite, RT_MS_30SEC);
                RTPipeClose(hPipeWrite.u.hPipe);
                hPipeWrite.u.hPipe = NIL_RTPIPE;
                if (RT_SUCCESS(rc))
                {
                    LogRel2(("Successfully transferred host clipboard data to --clipboard-set process %u (%#x).\n",
                             hProcess, hProcess));
                    pCtx->Wl.hProcClipboardSet = hProcess;
                    pCtx->Wl.hPipeClipboardSet = hPipeWriteTerm;
                }
                else
                {
                    /*
                     * Dang. Something went wrong transferring the clipboard data to the
                     * child process, so we have to terminate it and do zombie collecting.
                     */
                    VBClLogError("Terminating --clipboard-set child because VBClClipboardSerializeCache failed (%Rrc) ...\n", rc);
                    RTPipeClose(hPipeWriteTerm);
                    vbclWaylandHlpGtkTerminateAndWaitForChild(hProcess);
                }
                hProcess       = NIL_RTPROCESS;
                hPipeWriteTerm = NIL_RTPIPE;
            }
            else
                VBClLogError("RTProcCreateEx/--clipboard-set failed: %Rrc\n", rc);
            RTPipeClose(hPipeTermRead);
            RTPipeClose(hPipeWriteTerm);
        }
        else
            VBClLogError("RTPipeCreate failed: %Rrc (--clipboard-set #2)\n", rc);
        RTPipeClose(hStdIn.u.hPipe);
        RTPipeClose(hPipeWrite.u.hPipe);
    }
    else
        VBClLogError("RTPipeCreate failed: %Rrc (--clipboard-set #1)\n", rc);

    /*
     * If there was a previous process, do zombie processing for it.
     */
    if (hProcPrev != NIL_RTPROCESS)
        vbclWaylandHlpGtkTerminateAndWaitForChild(hProcPrev);

    return rc;
}


/***********************************************************************
 * DnD.
 **********************************************************************/

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_DND,pfnInit}
 */
RTDECL(int) vbcl_wayland_hlp_gtk_dnd_init(void)
{
    VBCL_LOG_CALLBACK;

    return VINF_SUCCESS;
}

/**
 * @interface_method_impl{VBCLWAYLANDHELPER_DND,pfnTerm}
 */
RTDECL(int) vbcl_wayland_hlp_gtk_dnd_term(void)
{
    VBCL_LOG_CALLBACK;

    return VINF_SUCCESS;
}


/** GTK helper callbacks. */
const VBCLWAYLANDHELPER g_WaylandHelperGtk =
{
    /* .pszName  = */ "wayland-gtk",
    /* .pfnProbe = */ vbcl_wayland_hlp_gtk_probe,
    /* .clip     = */
    {
        /* .pfnInit            = */ vbcl_wayland_hlp_gtk_clip_init,
        /* .pfnTerm            = */ vbcl_wayland_hlp_gtk_clip_term,
        /* .pfnSetClipboardCtx = */ vbcl_wayland_hlp_gtk_clip_set_ctx,
        /* .pfnPopup           = */ vbcl_wayland_hlp_gtk_clip_popup,
        /* .pfnHGClipReport    = */ vbcl_wayland_hlp_gtk_clip_hg_report,
        /* .pfnGHClipRead      = */ NULL,
    },
    /* .dnd      = */
    {
        /* .pfnInit = */            vbcl_wayland_hlp_gtk_dnd_init,
        /* .pfnTerm = */            vbcl_wayland_hlp_gtk_dnd_term,
    }
};
