/** $Id: clipboard.h 114505 2026-06-24 08:58:53Z knut.osmundsen@oracle.com $ */
/** @file
 * Guest Additions - X11 Shared Clipboard - Main header.
 */

/*
 * Copyright (C) 2020-2026 Oracle and/or its affiliates.
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

#ifndef GA_INCLUDED_SRC_x11_VBoxClient_clipboard_h
#define GA_INCLUDED_SRC_x11_VBoxClient_clipboard_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include <VBox/GuestHost/SharedClipboard-x11.h>
#include <VBox/VBoxGuestLib.h>
#include <iprt/thread.h>

/**
 * Called upon receiving a new clipboard format report from the host.
 *
 * @returns VBox status code.
 * @param   pCtx            Our shared clipboard context structure.
 * @param   fFormats        The formats available (VBOX_SHCL_FMT_XXX).
 */
typedef DECLCALLBACKTYPE(int, FNHOSTCLIPREPORTFMTS, (PSHCLCONTEXT pCtx, SHCLFORMATS fFormats));
/** Pointer to FNHOSTCLIPREPORTFMTS. */
typedef FNHOSTCLIPREPORTFMTS *PFNHOSTCLIPREPORTFMTS;

/**
 * Called upon receiving a read clipboard query from the host.
 *
 * @returns VBox status code.
 * @param   pCtx            Our shared clipboard context structure.
 * @param   uFmt            The format in which the data should be read (a
 *                          single VBOX_SHCL_FMT_XXX).
 */
typedef DECLCALLBACKTYPE(int, FNHOSTCLIPREAD, (PSHCLCONTEXT pCtx, SHCLFORMAT uFmt));
/** Pointer to FNHOSTCLIPREAD. */
typedef FNHOSTCLIPREAD *PFNHOSTCLIPREAD;

/**
 * Hack for wayland callbacks so we can easily match uRevision.
 */
typedef struct SHCLWLCBCTXSLOT
{
    /** Pointer back to the context.   */
    struct SHCLCONTEXT *pCtx;
    /** The revision for this slot. */
    uint64_t            uRevision;
} SHCLWLCBCTXSLOT;

/**
 * The VBoxClient Shared Clipboard context structure.
 */
struct SHCLCONTEXT
{
    /** Client command context */
    VBGLR3SHCLCMDCTX     CmdCtx;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    /** Associated transfer data. */
    SHCLTRANSFERCTX      TransferCtx;
#endif
    /** Event source for waiting for X11 request responses in the VbglR3 clipboard event loop. */
    SHCLEVENTSOURCE      EventSrc;
    union
    {
        /** X11 clipboard context. */
        SHCLX11CTX       X11;
        /** Wayland clipboard context. */
        struct
        {
            /** Protects everything down to, but not including, aOurCbSlots. */
            RTCRITSECT          CritSect;
            /** Revision number for the data protected by the critical section.
             *
             * This is increased by two every time there is a change in the clipboard data.
             * It is set to an ODD number when the guest is the clipboard provider and EVEN
             * when the host is. */
            uint64_t volatile   uRevision;

            /** Caching the other-side's clipboard data in VBox format.
             * This is filled as-needed.  */
            SHCLCACHE           OtherCache;
            /** The other side's VBox formats on offer (VBOX_SHCL_FMT_XXX). */
            SHCLFORMATS         fOtherFormats;

            /** Caching our side's clipboard data.
             * Upon receiving an announcement, we get all the relevant data from the
             * clipboard and puts it in the cache, in VBox format.  This simplifies IPC
             * interaction. */
            SHCLCACHE           OurCache;
            /** MIME types for each VBOX_SHCL_FMT_XXX (indexed by its log2 value).*/
            struct
            {
                /** The MIME type (from mime-type-converter.cpp). */
                char const     *pszMimeType;
                /** The priority and flags of this MIME type. */
                uint32_t        fFlagsAndPriority;
            } aOurMimeTypes[VBOX_SHCL_FMT_LAST_BIT + 1];
            /** Event that get's set when the cache has been filled.
             * @note Should've been a condition variable, as there is a potential race if
             *       a 2nd clipboard announcement is processed between someone leaving the
             *       critsect and starts waiting. Harmless, though, since they'll be
             *       waken up once that cache filling is completed. */
            RTSEMEVENTMULTI     hOurCacheFilledEvent;
            /** Our side's VBox formats on offer (VBOX_SHCL_FMT_XXX). */
            SHCLFORMATS         fOurFormats;
            /** Next slot in aOurCbSlots. */
            uint32_t            idxOurCbSlots;

            /** HACK: Circular callback context slots. */
            SHCLWLCBCTXSLOT     aOurCbSlots[16];
        } Wl;
    };
};

/** Checks if the revision indicates other side's clipboard ownership. */
#define SHCLWLCTX_REV_IS_OTHER(a_uRevision) (((a_uRevision) & 1) == 0)
/** Checks if the revision indicates our side's clipboard ownership. */
#define SHCLWLCTX_REV_IS_OUR(a_uRevision)   (((a_uRevision) & 1) == 1)

/** MIME type used for storing SHCLCONTEXT::Wl::uRevision and flag the (wayland)
 *  clipboard as our. */
#define VBOX_CLIPBOARD_MIME_TYPE_REVISION_NO    "application/x.virtualbox.vboxclient.revno"

/** Shared Clipboard context.
 *  Only one context is supported at a time for now. */
extern SHCLCONTEXT g_Ctx;

int VBClClipboardReadHostEvent(PSHCLCONTEXT pCtx, PFNHOSTCLIPREPORTFMTS pfnHGClipReport, PFNHOSTCLIPREAD pfnGHClipRead);
int VBClClipboardReadHostClipboard(PSHCLCONTEXT pCtx, SHCLFORMAT uFmt, void **ppvData, uint32_t *pcbData);

int      VBClWaylandClipboardQueryHostData(PSHCLCONTEXT pCtx, const char *pszMimeType, void **ppvOutData, size_t *pcbOutData);
uint64_t VBClWaylandClipboardResetOurState(PSHCLCONTEXT pCtx, const char *pszCaller, SHCLWLCBCTXSLOT **ppCbCtxSlot);
int      VBClWaylandClipboardOurAddMimeType(PSHCLCONTEXT pCtx, uint64_t uRevision, const char *pszMimeType, const char *pszCaller);

#endif /* !GA_INCLUDED_SRC_x11_VBoxClient_clipboard_h */
