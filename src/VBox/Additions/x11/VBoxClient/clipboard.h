/** $Id: clipboard.h 114458 2026-06-19 12:01:21Z knut.osmundsen@oracle.com $ */
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
            /** Protects OtherCache, fOtherFormats and uOtherRevision.  */
            RTCRITSECT          OtherCritSect;
            /** Caching the other-side's clipboard data in VBox format. */
            SHCLCACHE           OtherCache;
            /** The other side's VBox formats on offer (VBOX_SHCL_FMT_XXX). */
            SHCLFORMATS         fOtherFormats;
            /** Revision number of the other-side's data.
             * This is increased every time the host report new data. */
            uint64_t volatile   uOtherRevision;
        } Wl;
    };
};

/** Shared Clipboard context.
 *  Only one context is supported at a time for now. */
extern SHCLCONTEXT g_Ctx;

int VBClClipboardReadHostEvent(PSHCLCONTEXT pCtx, PFNHOSTCLIPREPORTFMTS pfnHGClipReport, PFNHOSTCLIPREAD pfnGHClipRead);
int VBClClipboardReadHostClipboard(PSHCLCONTEXT pCtx, SHCLFORMAT uFmt, void **ppvData, uint32_t *pcbData);

int VBClWaylandClipboardQueryHostData(PSHCLCONTEXT pCtx, const char *pszMimeType, void **ppvOutData, size_t *pcbOutData);

#endif /* !GA_INCLUDED_SRC_x11_VBoxClient_clipboard_h */
