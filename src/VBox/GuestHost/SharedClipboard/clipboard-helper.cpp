/* $Id: clipboard-helper.cpp 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * Shared Clipboard: Helper functions.
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

#define LOG_GROUP LOG_GROUP_SHARED_CLIPBOARD

#include <iprt/assert.h>
#include <iprt/stream.h>
#include <iprt/string.h>

#include <VBox/GuestHost/clipboard-helper.h>


/*********************************************************************************************************************************
*   Implementation                                                                                                               *
*********************************************************************************************************************************/

/**
 * Converts a clipboard source value to a printable string.
 *
 * @returns Printable source name.
 * @param   uSource             Clipboard source value.
 */
const char *ShClHlpSourceToString(uint32_t uSource)
{
    switch (uSource)
    {
        case VBOX_SHCL_CLIPBOARD_SOURCE_HOST:   return "host";
        case VBOX_SHCL_CLIPBOARD_SOURCE_GUEST:  return "guest";
        case VBOX_SHCL_CLIPBOARD_SOURCE_REMOTE: return "remote";
        case VBOX_SHCL_CLIPBOARD_SOURCE_CUSTOM: return "custom";
        default:                                break;
    }

    AssertFailedReturn("unknown");
}


/**
 * Converts a clipboard mode value to a printable string.
 *
 * @returns Printable mode name.
 * @param   uMode               Clipboard mode value.
 */
const char *ShClHlpModeToString(uint32_t uMode)
{
    switch (uMode)
    {
        case VBOX_SHCL_CLIPBOARD_MODE_DISABLED:      return "disabled";
        case VBOX_SHCL_CLIPBOARD_MODE_HOST_TO_GUEST: return "host-to-guest";
        case VBOX_SHCL_CLIPBOARD_MODE_GUEST_TO_HOST: return "guest-to-host";
        case VBOX_SHCL_CLIPBOARD_MODE_BIDIRECTIONAL: return "bidirectional";
        default:                                     break;
    }

    AssertFailedReturn("unknown");
}


/**
 * Converts a clipboard transfer state value to a printable string.
 *
 * @returns Printable transfer state name.
 * @param   uState              Clipboard transfer state value.
 */
const char *ShClHlpTransferStateToString(uint32_t uState)
{
    switch (uState)
    {
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_ADDED:       return "added";
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_REMOVED:     return "removed";
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_IN_PROGRESS: return "in-progress";
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_INTERACTION: return "interaction";
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_COMPLETED:   return "completed";
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_CANCELED:    return "canceled";
        case VBOX_SHCL_CLIPBOARD_TRANSFER_STATE_FAILED:      return "failed";
        default:                                            break;
    }

    AssertFailedReturn("unknown");
}


/**
 * Parses a clipboard sharing mode value.
 *
 * @returns true if the value was parsed successfully, false otherwise.
 * @param   pszMode             String value to parse.
 * @param   puMode              Where to return the parsed mode.
 */
bool ShClHlpModeFromString(const char *pszMode, uint32_t *puMode)
{
    AssertPtrReturn(pszMode, false);
    AssertPtrReturn(puMode, false);

    if (!RTStrICmp(pszMode, "disabled"))
        *puMode = VBOX_SHCL_CLIPBOARD_MODE_DISABLED;
    else if (!RTStrICmp(pszMode, "hosttoguest"))
        *puMode = VBOX_SHCL_CLIPBOARD_MODE_HOST_TO_GUEST;
    else if (!RTStrICmp(pszMode, "guesttohost"))
        *puMode = VBOX_SHCL_CLIPBOARD_MODE_GUEST_TO_HOST;
    else if (!RTStrICmp(pszMode, "bidirectional"))
        *puMode = VBOX_SHCL_CLIPBOARD_MODE_BIDIRECTIONAL;
    else
        return false;
    return true;
}


/**
 * Checks whether a MIME type represents text.
 *
 * @returns true if the MIME type is a text type, false otherwise.
 * @param   pszMimeType         MIME type to check.
 */
bool ShClHlpIsTextMimeType(const char *pszMimeType)
{
    AssertPtrReturn(pszMimeType, false);

    return RTStrNICmp(pszMimeType, RT_STR_TUPLE("text/")) == 0;
}


/**
 * Checks whether a MIME type is UTF-8 encoded text.
 *
 * @returns true if the MIME type is UTF-8 text, false otherwise.
 * @param   pszMimeType         MIME type to check.
 */
bool ShClHlpIsUtf8TextMimeType(const char *pszMimeType)
{
    AssertPtrReturn(pszMimeType, false);

    return    !RTStrICmp(pszMimeType, "UTF8_STRING")
           || (   ShClHlpIsTextMimeType(pszMimeType)
               && RTStrIStr(pszMimeType, "charset=utf-8"));
}


/**
 * Checks whether a MIME type is UTF-16 encoded text.
 *
 * @returns true if the MIME type is UTF-16 text, false otherwise.
 * @param   pszMimeType         MIME type to check.
 */
bool ShClHlpIsUtf16TextMimeType(const char *pszMimeType)
{
    AssertPtrReturn(pszMimeType, false);

    return    ShClHlpIsTextMimeType(pszMimeType)
           && RTStrIStr(pszMimeType, "charset=utf-16");
}


/**
 * Checks whether clipboard data is multiline text.
 *
 * @returns true if the payload is text and contains more than one line.
 * @param   pszMimeType         MIME type of the payload.
 * @param   pbData              Payload bytes.
 * @param   cbData              Number of payload bytes.
 */
bool ShClHlpIsMultilineText(const char *pszMimeType, const uint8_t *pbData, size_t cbData)
{
    if (!ShClHlpIsTextMimeType(pszMimeType))
        return false;
    if (!cbData)
        return false;
    AssertPtrReturn(pbData, false);

    for (size_t i = 0; i < cbData; i++)
    {
        if (pbData[i] == '\r' || pbData[i] == '\n')
        {
            if (pbData[i] == '\r' && i + 1 < cbData && pbData[i + 1] == '\n')
                i++;
            if (i + 1 < cbData)
                return true;
        }
    }
    return false;
}


/**
 * Prints an escaped UTF-8 string to an output stream.
 *
 * @param   pStrm               Output stream.
 * @param   pszText             UTF-8 text bytes.
 * @param   cchText             Number of bytes to print.
 */
void ShClHlpPrintEscapedString(PRTSTREAM pStrm, const char *pszText, size_t cchText)
{
    AssertPtrReturnVoid(pStrm);
    if (!cchText)
        return;
    AssertPtrReturnVoid(pszText);

    for (size_t i = 0; i < cchText; i++)
    {
        unsigned char const ch = (unsigned char)pszText[i];
        switch (ch)
        {
            case '\n': RTStrmWrite(pStrm, RT_STR_TUPLE("\\n")); break;
            case '\r': RTStrmWrite(pStrm, RT_STR_TUPLE("\\r")); break;
            case '\t': RTStrmWrite(pStrm, RT_STR_TUPLE("\\t")); break;
            case '\\': RTStrmWrite(pStrm, RT_STR_TUPLE("\\\\")); break;
            case '"':  RTStrmWrite(pStrm, RT_STR_TUPLE("\\\"")); break;
            default:
                if (ch >= 0x20)
                    RTStrmPutCh(pStrm, ch);
                else
                    RTStrmPrintf(pStrm, "\\x%02x", ch);
                break;
        }
    }
}
