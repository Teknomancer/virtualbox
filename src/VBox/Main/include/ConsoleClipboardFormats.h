/* $Id: ConsoleClipboardFormats.h 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VBox Console Clipboard format conversion helpers.
 */

/*
 * Copyright (C) 2026 Oracle and/or its affiliates.
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

#ifndef MAIN_INCLUDED_ConsoleClipboardFormats_h
#define MAIN_INCLUDED_ConsoleClipboardFormats_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include <vector>

#include <VBox/com/defs.h>
#include <VBox/com/string.h>
#include <VBox/GuestHost/SharedClipboard.h>

#include <iprt/assert.h>
#include <iprt/errcore.h>
#include <iprt/string.h>

/**
 * Converts a public MIME type to a Shared Clipboard format bit.
 *
 * @returns Shared Clipboard format bit, or VBOX_SHCL_FMT_NONE if unsupported.
 * @param   aMimeType       MIME type to convert.
 */
static SHCLFORMAT consoleClipboardMimeTypeToFormat(const com::Utf8Str &aMimeType)
{
    const char *pszMimeType = aMimeType.c_str();
    if (   !RTStrICmp(pszMimeType, "text/plain")
        || !RTStrNICmp(pszMimeType, "text/plain;", sizeof("text/plain;") - 1)
        || !RTStrICmp(pszMimeType, "text/plain;charset=utf-8")
        || !RTStrICmp(pszMimeType, "text/plain;charset=UTF-8"))
        return VBOX_SHCL_FMT_UNICODETEXT;
    if (   !RTStrICmp(pszMimeType, "text/html")
        || !RTStrNICmp(pszMimeType, "text/html;", sizeof("text/html;") - 1))
        return VBOX_SHCL_FMT_HTML;
    if (   !RTStrICmp(pszMimeType, "image/bmp")
        || !RTStrICmp(pszMimeType, "image/x-bmp")
        || !RTStrICmp(pszMimeType, "application/x-bmp"))
        return VBOX_SHCL_FMT_BITMAP;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    if (   !RTStrICmp(pszMimeType, "text/uri-list")
        || !RTStrICmp(pszMimeType, "application/x-virtualbox-shared-clipboard-uri-list"))
        return VBOX_SHCL_FMT_URI_LIST;
#endif
    return VBOX_SHCL_FMT_NONE;
}


/**
 * Converts a Shared Clipboard format bit to the public MIME type.
 *
 * @returns MIME type, or NULL if unsupported.
 * @param   uFormat         Shared Clipboard format bit.
 */
static const char *consoleClipboardFormatToMimeType(SHCLFORMAT uFormat)
{
    switch (uFormat)
    {
        case VBOX_SHCL_FMT_UNICODETEXT:
            return "text/plain;charset=utf-8";
        case VBOX_SHCL_FMT_HTML:
            return "text/html";
        case VBOX_SHCL_FMT_BITMAP:
            return "image/bmp";
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        case VBOX_SHCL_FMT_URI_LIST:
            return "text/uri-list";
#endif
        default:
            return NULL;
    }
}


/**
 * Converts a public MIME format vector to a Shared Clipboard format mask.
 *
 * @returns COM status code.
 * @param   aFormats        MIME formats to convert.
 * @param   pfFormats       Where to return the Shared Clipboard format mask.
 */
static HRESULT consoleClipboardMimeTypesToFormats(const std::vector<com::Utf8Str> &aFormats, SHCLFORMATS *pfFormats)
{
    AssertPtrReturn(pfFormats, E_POINTER);

    SHCLFORMATS fFormats = VBOX_SHCL_FMT_NONE;
    for (std::vector<com::Utf8Str>::const_iterator it = aFormats.begin(); it != aFormats.end(); ++it)
    {
        SHCLFORMAT uFormat = consoleClipboardMimeTypeToFormat(*it);
        if (uFormat == VBOX_SHCL_FMT_NONE)
            return E_INVALIDARG;
        fFormats |= uFormat;
    }

    *pfFormats = fFormats;
    return S_OK;
}


/**
 * Converts a Shared Clipboard format mask to public MIME formats.
 *
 * @param   fFormats        Shared Clipboard format mask.
 * @param   aFormats        Where to return MIME formats.
 */
static void consoleClipboardFormatsToMimeTypes(SHCLFORMATS fFormats, std::vector<com::Utf8Str> &aFormats)
{
    aFormats.clear();
    for (SHCLFORMAT uFormat = 1; uFormat <= VBOX_SHCL_FMT_VALID_MASK; uFormat <<= 1)
        if (fFormats & uFormat)
        {
            const char *pszMimeType = consoleClipboardFormatToMimeType(uFormat);
            if (pszMimeType)
                aFormats.push_back(com::Utf8Str(pszMimeType));
        }
}

#endif /* !MAIN_INCLUDED_ConsoleClipboardFormats_h */
/* vi: set tabstop=4 shiftwidth=4 expandtab: */
