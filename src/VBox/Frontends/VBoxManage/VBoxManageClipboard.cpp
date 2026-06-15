/* $Id: VBoxManageClipboard.cpp 114364 2026-06-15 19:23:16Z andreas.loeffler@oracle.com $ */
/** @file
 * VBoxManage - Implementation of the clipboard command.
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


/*********************************************************************************************************************************
*   Header Files                                                                                                                 *
*********************************************************************************************************************************/
#include <VBox/com/array.h>
#include <VBox/com/com.h>
#include <VBox/com/errorprint.h>
#include <VBox/com/string.h>
#include <VBox/com/VirtualBox.h>
#include <VBox/GuestHost/clipboard-helper.h>

#include <iprt/err.h>
#include <iprt/ctype.h>
#include <iprt/getopt.h>
#include <iprt/mem.h>
#include <iprt/message.h>
#include <iprt/stream.h>
#include <iprt/string.h>
#include <iprt/time.h>
#include <iprt/utf16.h>

#include "VBoxManage.h"

#include <string.h>
#include <vector>

using namespace com;

DECLARE_TRANSLATION_CONTEXT(Clipboard);


/*********************************************************************************************************************************
*   Defined Constants And Macros                                                                                                 *
*********************************************************************************************************************************/
#define CLIPBOARD_DEFAULT_FORMAT       "text/plain;charset=utf-8"
#define CLIPBOARD_PREVIEW_MAX          1024
#define CLIPBOARD_VERBOSE_MAX          _64K


enum
{
    CLIPBOARD_OPT_FORMAT = 1000,
    CLIPBOARD_OPT_RAW,
    CLIPBOARD_OPT_WAIT,
    CLIPBOARD_OPT_TIMEOUT,
    CLIPBOARD_OPT_COUNT,
    CLIPBOARD_OPT_EVENTS,
    CLIPBOARD_OPT_OUTPUT_FORMAT,
    CLIPBOARD_OPT_MACHINE_READABLE,
    CLIPBOARD_OPT_VERBOSE
};


typedef enum CLIPBOARDLISTENFMT
{
    CLIPBOARDLISTENFMT_HUMAN = 0,
    CLIPBOARDLISTENFMT_MACHINE_READABLE,
    CLIPBOARDLISTENFMT_JSON
} CLIPBOARDLISTENFMT;


/*********************************************************************************************************************************
*   Internal Functions                                                                                                           *
*********************************************************************************************************************************/
/**
 * Gets the live clipboard object for a running VM.
 *
 * @returns COM status code.
 * @param   pArg            Command handler arguments.
 * @param   pszMachine      Machine name or UUID.
 * @param   ptrClipboard    Where to return the clipboard object.
 */
static HRESULT clipboardGet(HandlerArg *pArg, const char *pszMachine, ComPtr<IClipboard> &ptrClipboard)
{
    HRESULT hrc;
    ComPtr<IMachine> ptrMachine;
    CHECK_ERROR2_RET(hrc, pArg->virtualBox, FindMachine(Bstr(pszMachine).raw(), ptrMachine.asOutParam()), hrc);

    CHECK_ERROR2_RET(hrc, ptrMachine, LockMachine(pArg->session, LockType_Shared), hrc);

    ComPtr<IConsole> ptrConsole;
    CHECK_ERROR2_RET(hrc, pArg->session, COMGETTER(Console)(ptrConsole.asOutParam()), hrc);
    if (ptrConsole.isNull())
    {
        RTMsgError(Clipboard::tr("Machine '%s' is not currently running."), pszMachine);
        return E_FAIL;
    }

    CHECK_ERROR2_RET(hrc, ptrConsole, COMGETTER(Clipboard)(ptrClipboard.asOutParam()), hrc);
    if (ptrClipboard.isNull())
    {
        RTMsgError(Clipboard::tr("Machine '%s' has no live clipboard object."), pszMachine);
        return E_FAIL;
    }
    return hrc;
}


/**
 * Opens the VM clipboard settings object for modification.
 *
 * @returns COM status code.
 * @param   pArg            Command handler arguments.
 * @param   pszMachine      Machine name or UUID.
 * @param   ptrMachine      Where to return the session machine.
 * @param   ptrClipboard    Where to return the clipboard settings object.
 */
static HRESULT clipboardGetSettings(HandlerArg *pArg, const char *pszMachine, ComPtr<IMachine> &ptrMachine,
                                    ComPtr<IClipboardSettings> &ptrClipboard)
{
    HRESULT hrc;
    ComPtr<IMachine> ptrFoundMachine;
    CHECK_ERROR2_RET(hrc, pArg->virtualBox, FindMachine(Bstr(pszMachine).raw(), ptrFoundMachine.asOutParam()), hrc);

    CHECK_ERROR2_RET(hrc, ptrFoundMachine, LockMachine(pArg->session, LockType_Shared), hrc);

    CHECK_ERROR2(hrc, pArg->session, COMGETTER(Machine)(ptrMachine.asOutParam()));
    if (SUCCEEDED(hrc))
    {
        CHECK_ERROR2(hrc, ptrMachine, COMGETTER(Clipboard)(ptrClipboard.asOutParam()));
    }
    if (FAILED(hrc))
        pArg->session->UnlockMachine();
    return hrc;
}


/**
 * Reads all clipboard payload bytes from standard input.
 *
 * @returns VBox status code.
 * @param   abData          Where to append the bytes read from standard input.
 */
static int clipboardReadStdin(std::vector<BYTE> &abData)
{
    RTStrmSetMode(g_pStdIn, true /* fBinary */, -1 /* fCurrentCodeSet */);

    for (;;)
    {
        BYTE abBuf[_64K];
        size_t cbRead = 0;
        int vrc = RTStrmReadEx(g_pStdIn, abBuf, sizeof(abBuf), &cbRead);
        if (RT_FAILURE(vrc))
        {
            if (vrc == VERR_EOF)
                return VINF_SUCCESS;
            return vrc;
        }
        if (!cbRead)
            return VINF_SUCCESS;
        try
        {
            abData.insert(abData.end(), &abBuf[0], &abBuf[cbRead]);
        }
        catch (std::bad_alloc &)
        {
            return VERR_NO_MEMORY;
        }
    }
}


/**
 * Prints an escaped preview of clipboard payload bytes.
 *
 * @param   pbData          Payload bytes.
 * @param   cbData          Number of payload bytes.
 */
static void clipboardPrintEscapedPreview(const BYTE *pbData, size_t cbData)
{
    size_t const cbPreview = RT_MIN(cbData, (size_t)CLIPBOARD_PREVIEW_MAX);
    RTStrmPrintf(g_pStdErr, "%s\n", Clipboard::tr("Clipboard text preview:"));
    RTStrmPrintf(g_pStdErr, "---\n");
    for (size_t i = 0; i < cbPreview; i++)
    {
        BYTE const b = pbData[i];
        switch (b)
        {
            case '\n': RTStrmPrintf(g_pStdErr, "\\n\n"); break;
            case '\r': RTStrmPrintf(g_pStdErr, "\\r"); break;
            case '\t': RTStrmPrintf(g_pStdErr, "\\t"); break;
            case '\\': RTStrmPrintf(g_pStdErr, "\\\\"); break;
            default:
                if (RT_C_IS_PRINT(b))
                    RTStrmPutCh(g_pStdErr, b);
                else
                    RTStrmPrintf(g_pStdErr, "\\x%02x", b);
                break;
        }
    }
    if (cbPreview < cbData)
        RTStrmPrintf(g_pStdErr, "\n%s", Clipboard::tr("... (preview truncated)"));
    RTStrmPrintf(g_pStdErr, "\n---\n");
}


/**
 * Prompts before writing multiline clipboard text to an interactive terminal.
 *
 * @returns RTEXITCODE_SUCCESS if output may proceed, failure otherwise.
 * @param   strMimeType     MIME type of the payload.
 * @param   pbData          Payload bytes.
 * @param   cbData          Number of payload bytes.
 */
static RTEXITCODE clipboardConfirmMultilineTerminalPaste(const Utf8Str &strMimeType, const BYTE *pbData, size_t cbData)
{
    if (   !RTStrmIsTerminal(g_pStdOut)
        || !ShClHlpIsMultilineText(strMimeType.c_str(), pbData, cbData))
        return RTEXITCODE_SUCCESS;

    RTMsgWarning(Clipboard::tr("The clipboard contains multiline text. Writing it to an interactive terminal could be "
                                "unsafe if it is pasted or interpreted by a shell."));
    clipboardPrintEscapedPreview(pbData, cbData);

    if (!RTStrmIsTerminal(g_pStdIn))
        return RTMsgErrorExit(RTEXITCODE_FAILURE,
                              Clipboard::tr("Refusing to write multiline clipboard text to the terminal without confirmation. "
                                            "Redirect stdout to a file or pipe to avoid this prompt."));

    char szAnswer[16];
    RTStrmPrintf(g_pStdErr, "%s ", Clipboard::tr("Write this text to stdout? [y/N]"));
    int vrc = RTStrmGetLine(g_pStdIn, szAnswer, sizeof(szAnswer));
    if (RT_FAILURE(vrc))
        return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Failed to read confirmation: %Rrc"), vrc);
    if (   !RTStrICmp(szAnswer, "y")
        || !RTStrICmp(szAnswer, "yes"))
        return RTEXITCODE_SUCCESS;

    return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Clipboard output cancelled."));
}


/**
 * Writes clipboard payload bytes to standard output.
 *
 * @returns VBox status code.
 * @param   pbData          Payload bytes.
 * @param   cbData          Number of payload bytes.
 */
static int clipboardWriteStdout(const BYTE *pbData, size_t cbData)
{
    RTStrmSetMode(g_pStdOut, true /* fBinary */, -1 /* fCurrentCodeSet */);
    return cbData ? RTStrmWrite(g_pStdOut, pbData, cbData) : VINF_SUCCESS;
}



/**
 * Extracts data and metadata from a clipboard item.
 *
 * @returns COM status code.
 * @param   ptrItem         Clipboard item to inspect.
 * @param   strMimeType     Where to return the MIME type.
 * @param   penmSource      Where to return the source, optional.
 * @param   aBuffer         Where to return the payload bytes.
 */
static HRESULT clipboardGetItemData(const ComPtr<IClipboardItem> &ptrItem, Utf8Str &strMimeType, ClipboardSource_T *penmSource,
                                    SafeArray<BYTE> &aBuffer)
{
    ClipboardSource_T enmSource = ClipboardSource_Host;
    HRESULT hrc = ptrItem->COMGETTER(Source)(&enmSource);
    if (FAILED(hrc))
        return hrc;

    ComPtr<IClipboardFormat> ptrFormat;
    hrc = ptrItem->COMGETTER(Format)(ptrFormat.asOutParam());
    if (FAILED(hrc))
        return hrc;
    Bstr bstrMimeType;
    hrc = ptrFormat->COMGETTER(MimeType)(bstrMimeType.asOutParam());
    if (FAILED(hrc))
        return hrc;

    aBuffer.setNull();
    hrc = ptrItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(aBuffer));
    if (FAILED(hrc))
        return hrc;

    strMimeType = bstrMimeType;
    if (penmSource)
        *penmSource = enmSource;
    return S_OK;
}


/**
 * Checks whether an actual MIME type matches the optional requested type.
 *
 * @returns true on match, false otherwise.
 * @param   pszRequested    Requested MIME type, optional.
 * @param   strActual       Actual MIME type.
 */
static bool clipboardMimeMatches(const char *pszRequested, const Utf8Str &strActual)
{
    return !pszRequested || !*pszRequested || !RTStrICmp(pszRequested, strActual.c_str());
}


/**
 * Writes clipboard data for the paste command after validating its format.
 *
 * @returns Process exit code.
 * @param   strMimeType     MIME type of the payload.
 * @param   pszFormat       Requested MIME type, optional.
 * @param   pbData          Payload bytes.
 * @param   cbData          Number of payload bytes.
 */
static RTEXITCODE clipboardPasteOutputData(const Utf8Str &strMimeType, const char *pszFormat, const BYTE *pbData, size_t cbData)
{
    if (!clipboardMimeMatches(pszFormat, strMimeType))
        return RTMsgErrorExit(RTEXITCODE_FAILURE,
                              Clipboard::tr("Clipboard data has MIME type '%s', not requested MIME type '%s'."),
                              strMimeType.c_str(), pszFormat);

    RTEXITCODE rcExit = clipboardConfirmMultilineTerminalPaste(strMimeType, pbData, cbData);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;

    int vrc = clipboardWriteStdout(pbData, cbData);
    if (RT_FAILURE(vrc))
        return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Failed to write clipboard data: %Rrc"), vrc);

    return RTEXITCODE_SUCCESS;
}


/**
 * Writes a clipboard item for the paste command.
 *
 * @returns Process exit code.
 * @param   ptrItem         Clipboard item to output.
 * @param   pszFormat       Requested MIME type, optional.
 */
static RTEXITCODE clipboardPasteOutputItem(const ComPtr<IClipboardItem> &ptrItem, const char *pszFormat)
{
    Utf8Str strMimeType;
    ClipboardSource_T enmSource;
    SafeArray<BYTE> aBuffer;
    HRESULT hrc = clipboardGetItemData(ptrItem, strMimeType, &enmSource, aBuffer);
    if (FAILED(hrc))
        return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Failed to get clipboard data: %Rhrc"), hrc);

    RT_NOREF(enmSource);
    return clipboardPasteOutputData(strMimeType, pszFormat, aBuffer.raw(), aBuffer.size());
}


/**
 * Writes a JSON string value to standard output.
 *
 * @param   pszValue        String value to write, optional.
 * @param   cchValue        Number of bytes to write.
 */
static void clipboardJsonStringN(const char *pszValue, size_t cchValue)
{
    RTStrmPutCh(g_pStdOut, '"');
    if (pszValue)
    {
        for (size_t i = 0; i < cchValue; i++)
        {
            unsigned char const ch = (unsigned char)pszValue[i];
            switch (ch)
            {
                case '\\': RTStrmWrite(g_pStdOut, RT_STR_TUPLE("\\\\")); break;
                case '"':  RTStrmWrite(g_pStdOut, RT_STR_TUPLE("\\\"")); break;
                case '\n': RTStrmWrite(g_pStdOut, RT_STR_TUPLE("\\n")); break;
                case '\r': RTStrmWrite(g_pStdOut, RT_STR_TUPLE("\\r")); break;
                case '\t': RTStrmWrite(g_pStdOut, RT_STR_TUPLE("\\t")); break;
                default:
                    if (ch >= 0x20)
                        RTStrmPutCh(g_pStdOut, ch);
                    else
                        RTStrmPrintf(g_pStdOut, "\\u%04x", ch);
                    break;
            }
        }
    }
    RTStrmPutCh(g_pStdOut, '"');
}


/**
 * Writes a zero-terminated JSON string value to standard output.
 *
 * @param   pszValue        String value to write, optional.
 */
static void clipboardJsonString(const char *pszValue)
{
    clipboardJsonStringN(pszValue, pszValue ? strlen(pszValue) : 0);
}


/**
 * Converts a bounded UTF-8 or UTF-16 clipboard payload to UTF-8 for verbose event output.
 *
 * @returns true if UTF-8 text was returned, false if the format is unsupported or invalid.
 * @param   strMimeType     MIME type of the payload.
 * @param   pbData          Payload bytes.
 * @param   cbData          Number of payload bytes.
 * @param   ppszText        Where to return allocated UTF-8 text. Free with RTStrFree().
 * @param   pcchText        Where to return the UTF-8 byte length.
 * @param   pfTruncated     Where to return whether input was truncated to CLIPBOARD_VERBOSE_MAX.
 */
static bool clipboardGetVerboseText(const Utf8Str &strMimeType, const BYTE *pbData, size_t cbData, char **ppszText,
                                    size_t *pcchText, bool *pfTruncated)
{
    *ppszText = NULL;
    *pcchText = 0;
    *pfTruncated = cbData > CLIPBOARD_VERBOSE_MAX;

    size_t cbText = RT_MIN(cbData, (size_t)CLIPBOARD_VERBOSE_MAX);
    if (ShClHlpIsUtf8TextMimeType(strMimeType.c_str()))
    {
        if (!cbText)
        {
            *ppszText = RTStrDup("");
            return *ppszText != NULL;
        }

        size_t cchText = cbText;
        int vrc = RTStrValidateEncodingEx((const char *)pbData, cchText, RTSTR_VALIDATE_ENCODING_EXACT_LENGTH);
        for (unsigned i = 0; RT_FAILURE(vrc) && *pfTruncated && i < 3 && cchText > 0; i++)
        {
            cchText--;
            vrc = RTStrValidateEncodingEx((const char *)pbData, cchText, RTSTR_VALIDATE_ENCODING_EXACT_LENGTH);
        }
        if (RT_FAILURE(vrc))
            return false;

        *ppszText = RTStrDupN((const char *)pbData, cchText);
        if (!*ppszText)
            return false;
        *pcchText = cchText;
        return true;
    }

    if (!ShClHlpIsUtf16TextMimeType(strMimeType.c_str()))
        return false;

    cbText &= ~(size_t)1;
    if (!cbText)
    {
        *ppszText = RTStrDup("");
        return *ppszText != NULL;
    }

    size_t const cwcText = cbText / sizeof(RTUTF16);
    try
    {
        std::vector<RTUTF16> awcText(cwcText + 1);
        if (cbText)
            memcpy(&awcText[0], pbData, cbText);
        awcText[cwcText] = 0;

        PCRTUTF16 pwszText = &awcText[0];
        size_t cwcConvert = cwcText;
        bool fUtf16BE = RTStrIStr(strMimeType.c_str(), "charset=utf-16be") != NULL;
        bool fUtf16LE = RTStrIStr(strMimeType.c_str(), "charset=utf-16le") != NULL;
        if (cbText >= 2 && pbData[0] == 0xff && pbData[1] == 0xfe)
        {
            pwszText++;
            cwcConvert--;
            fUtf16LE = true;
            fUtf16BE = false;
        }
        else if (cbText >= 2 && pbData[0] == 0xfe && pbData[1] == 0xff)
        {
            pwszText++;
            cwcConvert--;
            fUtf16BE = true;
            fUtf16LE = false;
        }

        int vrc;
        if (fUtf16BE)
            vrc = RTUtf16BigToUtf8Ex(pwszText, cwcConvert, ppszText, 0, pcchText);
        else if (fUtf16LE)
            vrc = RTUtf16LittleToUtf8Ex(pwszText, cwcConvert, ppszText, 0, pcchText);
        else
            vrc = RTUtf16ToUtf8Ex(pwszText, cwcConvert, ppszText, 0, pcchText);
        if (RT_FAILURE(vrc) && *pfTruncated && cwcConvert > 0)
        {
            cwcConvert--;
            if (fUtf16BE)
                vrc = RTUtf16BigToUtf8Ex(pwszText, cwcConvert, ppszText, 0, pcchText);
            else if (fUtf16LE)
                vrc = RTUtf16LittleToUtf8Ex(pwszText, cwcConvert, ppszText, 0, pcchText);
            else
                vrc = RTUtf16ToUtf8Ex(pwszText, cwcConvert, ppszText, 0, pcchText);
        }
        if (RT_FAILURE(vrc))
            return false;
    }
    catch (std::bad_alloc &)
    {
        return false;
    }
    return true;
}


/**
 * Prints a clipboard event carrying an item.
 *
 * @param   enmFormat       Output format.
 * @param   pszEvent        Event name.
 * @param   ptrItem         Clipboard item associated with the event.
 * @param   fVerbose        Whether to include supported text payload data.
 */
static void clipboardPrintEventItem(CLIPBOARDLISTENFMT enmFormat, const char *pszEvent, const ComPtr<IClipboardItem> &ptrItem,
                                    bool fVerbose)
{
    Utf8Str strMimeType;
    ClipboardSource_T enmSource = ClipboardSource_Host;
    SafeArray<BYTE> aBuffer;
    HRESULT hrc = ptrItem.isNotNull() ? clipboardGetItemData(ptrItem, strMimeType, &enmSource, aBuffer) : E_FAIL;

    char *pszVerboseText = NULL;
    size_t cchVerboseText = 0;
    bool fVerboseTruncated = false;
    bool const fHaveVerboseData = fVerbose && SUCCEEDED(hrc);
    bool const fHaveVerboseText =    fHaveVerboseData
                                  && clipboardGetVerboseText(strMimeType, aBuffer.raw(), aBuffer.size(), &pszVerboseText,
                                                             &cchVerboseText, &fVerboseTruncated);

    if (enmFormat == CLIPBOARDLISTENFMT_JSON)
    {
        RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":"));
        clipboardJsonString(pszEvent);
        if (SUCCEEDED(hrc))
        {
            RTStrmPrintf(g_pStdOut, ",\"source\":");
            clipboardJsonString(ShClHlpSourceToString(enmSource));
            RTStrmPrintf(g_pStdOut, ",\"format\":");
            clipboardJsonString(strMimeType.c_str());
            RTStrmPrintf(g_pStdOut, ",\"size\":%zu", aBuffer.size());
            if (fHaveVerboseData)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE(",\"data\":"));
                if (fHaveVerboseText)
                    clipboardJsonStringN(pszVerboseText, cchVerboseText);
                else
                    RTStrmPrintf(g_pStdOut, "\"<binary data> (%zu)\"", aBuffer.size());
                if (fHaveVerboseText && fVerboseTruncated)
                    RTStrmWrite(g_pStdOut, RT_STR_TUPLE(",\"data-truncated\":true"));
            }
        }
        RTStrmWrite(g_pStdOut, RT_STR_TUPLE("}\n"));
    }
    else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
    {
        RTPrintf("event=\"%s\"", pszEvent);
        if (SUCCEEDED(hrc))
        {
            RTPrintf(" source=\"%s\" format=\"%s\" size=\"%zu\"",
                     ShClHlpSourceToString(enmSource), strMimeType.c_str(), aBuffer.size());
            if (fHaveVerboseData)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE(" data=\""));
                if (fHaveVerboseText)
                    ShClHlpPrintEscapedString(g_pStdOut, pszVerboseText, cchVerboseText);
                else
                    RTStrmPrintf(g_pStdOut, "<binary data> (%zu)", aBuffer.size());
                RTStrmPutCh(g_pStdOut, '"');
                if (fHaveVerboseText && fVerboseTruncated)
                    RTStrmWrite(g_pStdOut, RT_STR_TUPLE(" data-truncated=\"true\""));
            }
        }
        RTPrintf("\n");
    }
    else
    {
        RTPrintf("clipboard: %s", pszEvent);
        if (SUCCEEDED(hrc))
        {
            RTPrintf(" source=%s format=%s size=%zu", ShClHlpSourceToString(enmSource), strMimeType.c_str(), aBuffer.size());
            if (fHaveVerboseData)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE(" data=\""));
                if (fHaveVerboseText)
                    ShClHlpPrintEscapedString(g_pStdOut, pszVerboseText, cchVerboseText);
                else
                    RTStrmPrintf(g_pStdOut, "<binary data> (%zu)", aBuffer.size());
                RTStrmPutCh(g_pStdOut, '"');
                if (fHaveVerboseText && fVerboseTruncated)
                    RTStrmWrite(g_pStdOut, RT_STR_TUPLE(" data-truncated=true"));
            }
        }
        RTPrintf("\n");
    }

    RTStrFree(pszVerboseText);
}


/**
 * Prints a clipboard event without additional payload.
 *
 * @param   enmFormat       Output format.
 * @param   pszEvent        Event name.
 */
static void clipboardPrintSimpleEvent(CLIPBOARDLISTENFMT enmFormat, const char *pszEvent)
{
    if (enmFormat == CLIPBOARDLISTENFMT_JSON)
    {
        RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":"));
        clipboardJsonString(pszEvent);
        RTStrmWrite(g_pStdOut, RT_STR_TUPLE("}\n"));
    }
    else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
        RTPrintf("event=\"%s\"\n", pszEvent);
    else
        RTPrintf("clipboard: %s\n", pszEvent);
}


/**
 * Prints a clipboard event.
 *
 * @param   enmFormat       Output format.
 * @param   ptrEvent        Event object to print.
 * @param   fVerbose        Whether to include supported text payload data for data events.
 */
static void clipboardPrintEvent(CLIPBOARDLISTENFMT enmFormat, const ComPtr<IEvent> &ptrEvent, bool fVerbose)
{
    VBoxEventType_T enmType;
    HRESULT hrc = ptrEvent->COMGETTER(Type)(&enmType);
    if (FAILED(hrc))
        return;

    switch (enmType)
    {
        case VBoxEventType_OnClipboardSourceChanged:
        {
            ComPtr<IClipboardSourceChangedEvent> ptrSourceEvent = ptrEvent;
            ClipboardSource_T enmSource = ClipboardSource_Host;
            ptrSourceEvent->COMGETTER(ClipboardSource)(&enmSource);
            if (enmFormat == CLIPBOARDLISTENFMT_JSON)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":\"source-changed\",\"source\":"));
                clipboardJsonString(ShClHlpSourceToString(enmSource));
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("}\n"));
            }
            else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
                RTPrintf("event=\"source-changed\" source=\"%s\"\n", ShClHlpSourceToString(enmSource));
            else
                RTPrintf("clipboard: source-changed source=%s\n", ShClHlpSourceToString(enmSource));
            break;
        }
        case VBoxEventType_OnClipboardFormatChanged:
        {
            ComPtr<IClipboardFormatChangedEvent> ptrFormatEvent = ptrEvent;
            ComPtr<IClipboardItem> ptrItem;
            ptrFormatEvent->COMGETTER(Item)(ptrItem.asOutParam());
            clipboardPrintEventItem(enmFormat, "format-changed", ptrItem, false /* fVerbose */);
            break;
        }
        case VBoxEventType_OnClipboardDataChanged:
        {
            ComPtr<IClipboardDataChangedEvent> ptrDataEvent = ptrEvent;
            ComPtr<IClipboardItem> ptrItem;
            ptrDataEvent->COMGETTER(Item)(ptrItem.asOutParam());
            clipboardPrintEventItem(enmFormat, "data-changed", ptrItem, fVerbose);
            break;
        }
        case VBoxEventType_OnClipboardTransfer:
        {
            ComPtr<IClipboardTransferEvent> ptrTransferEvent = ptrEvent;
            ClipboardTransferState_T enmState = ClipboardTransferState_Added;
            ptrTransferEvent->COMGETTER(State)(&enmState);
            if (enmFormat == CLIPBOARDLISTENFMT_JSON)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":\"transfer\",\"state\":"));
                clipboardJsonString(ShClHlpTransferStateToString(enmState));
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("}\n"));
            }
            else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
                RTPrintf("event=\"transfer\" state=\"%s\"\n", ShClHlpTransferStateToString(enmState));
            else
                RTPrintf("clipboard: transfer state=%s\n", ShClHlpTransferStateToString(enmState));
            break;
        }
        case VBoxEventType_OnClipboardError:
        {
            ComPtr<IClipboardErrorEvent> ptrErrorEvent = ptrEvent;
            Bstr bstrMsg;
            LONG rcError = VERR_GENERAL_FAILURE;
            ptrErrorEvent->COMGETTER(Msg)(bstrMsg.asOutParam());
            ptrErrorEvent->COMGETTER(RcError)(&rcError);
            Utf8Str strMsg(bstrMsg);
            if (enmFormat == CLIPBOARDLISTENFMT_JSON)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":\"error\",\"rc\":"));
                RTStrmPrintf(g_pStdOut, "%ld,\"message\":", rcError);
                clipboardJsonString(strMsg.c_str());
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("}\n"));
            }
            else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
                RTPrintf("event=\"error\" rc=\"%ld\" message=\"%s\"\n", rcError, strMsg.c_str());
            else
                RTPrintf("clipboard: error rc=%ld message=%s\n", rcError, strMsg.c_str());
            break;
        }
        case VBoxEventType_OnClipboardModeChanged:
        {
            ComPtr<IClipboardModeChangedEvent> ptrModeEvent = ptrEvent;
            ClipboardMode_T enmMode = ClipboardMode_Disabled;
            ptrModeEvent->COMGETTER(ClipboardMode)(&enmMode);
            const char *pszMode = ShClHlpModeToString(enmMode);
            if (enmFormat == CLIPBOARDLISTENFMT_JSON)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":\"mode-changed\",\"mode\":"));
                clipboardJsonString(pszMode);
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE(",\"active\":true}\n"));
            }
            else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
                RTPrintf("event=\"mode-changed\" mode=\"%s\" active=\"true\"\n", pszMode);
            else
                RTPrintf("clipboard: mode-changed mode=%s now-active\n", pszMode);
            break;
        }
        case VBoxEventType_OnClipboardFileTransferModeChanged:
        {
            ComPtr<IClipboardFileTransferModeChangedEvent> ptrModeEvent = ptrEvent;
            BOOL fEnabled = FALSE;
            ptrModeEvent->COMGETTER(Enabled)(&fEnabled);
            if (enmFormat == CLIPBOARDLISTENFMT_JSON)
            {
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE("{\"event\":\"file-transfer-mode-changed\",\"enabled\":"));
                if (fEnabled)
                    RTStrmWrite(g_pStdOut, RT_STR_TUPLE("true"));
                else
                    RTStrmWrite(g_pStdOut, RT_STR_TUPLE("false"));
                RTStrmWrite(g_pStdOut, RT_STR_TUPLE(",\"active\":true}\n"));
            }
            else if (enmFormat == CLIPBOARDLISTENFMT_MACHINE_READABLE)
                RTPrintf("event=\"file-transfer-mode-changed\" enabled=\"%s\" active=\"true\"\n", fEnabled ? "true" : "false");
            else
                RTPrintf("clipboard: file-transfer-mode-changed enabled=%s now-active\n", fEnabled ? "true" : "false");
            break;
        }
        default:
            clipboardPrintSimpleEvent(enmFormat, "unknown");
            break;
    }
}


/**
 * Checks whether an event satisfies a paste wait request.
 *
 * @returns true if the event carries matching guest clipboard data.
 * @param   ptrEvent        Event object to inspect.
 * @param   pszFormat       Requested MIME type, optional.
 * @param   ptrItem         Where to return the matching item.
 */
static bool clipboardEventMatchesWait(const ComPtr<IEvent> &ptrEvent, const char *pszFormat, ComPtr<IClipboardItem> &ptrItem)
{
    VBoxEventType_T enmType;
    HRESULT hrc = ptrEvent->COMGETTER(Type)(&enmType);
    if (FAILED(hrc) || enmType != VBoxEventType_OnClipboardDataChanged)
        return false;

    ComPtr<IClipboardDataChangedEvent> ptrDataEvent = ptrEvent;
    hrc = ptrDataEvent->COMGETTER(Item)(ptrItem.asOutParam());
    if (FAILED(hrc) || ptrItem.isNull())
        return false;

    Utf8Str strMimeType;
    ClipboardSource_T enmSource = ClipboardSource_Host;
    SafeArray<BYTE> aBuffer;
    hrc = clipboardGetItemData(ptrItem, strMimeType, &enmSource, aBuffer);
    if (FAILED(hrc))
        return false;

    return enmSource == ClipboardSource_Guest && clipboardMimeMatches(pszFormat, strMimeType);
}


/**
 * Registers a passive clipboard event listener.
 *
 * @returns Process exit code.
 * @param   ptrClipboard    Clipboard object to listen on.
 * @param   aEventTypes     Event types to subscribe to.
 * @param   ptrEventSource  Where to return the event source.
 * @param   ptrListener     Where to return the event listener.
 */
static RTEXITCODE clipboardRegisterListener(const ComPtr<IClipboard> &ptrClipboard, SafeArray<VBoxEventType_T> &aEventTypes,
                                            ComPtr<IEventSource> &ptrEventSource, ComPtr<IEventListener> &ptrListener)
{
    HRESULT hrc;
    CHECK_ERROR2_RET(hrc, ptrClipboard, COMGETTER(EventSource)(ptrEventSource.asOutParam()), RTEXITCODE_FAILURE);
    CHECK_ERROR2_RET(hrc, ptrEventSource, CreateListener(ptrListener.asOutParam()), RTEXITCODE_FAILURE);
    CHECK_ERROR2_RET(hrc, ptrEventSource, RegisterListener(ptrListener, ComSafeArrayAsInParam(aEventTypes), false /* passive */),
                     RTEXITCODE_FAILURE);
    return RTEXITCODE_SUCCESS;
}


/**
 * Unregisters a clipboard event listener.
 *
 * @param   ptrEventSource  Event source the listener was registered with.
 * @param   ptrListener     Event listener to unregister.
 */
static void clipboardUnregisterListener(const ComPtr<IEventSource> &ptrEventSource, const ComPtr<IEventListener> &ptrListener)
{
    if (ptrEventSource.isNotNull() && ptrListener.isNotNull())
        ptrEventSource->UnregisterListener(ptrListener);
}


/**
 * Handles the clipboard set-mode subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandleSetMode(HandlerArg *pArg, int argc, char **argv)
{
    if (argc <= 2)
        return errorSyntax(Clipboard::tr("Missing argument to '%s'."), argv[1]);
    if (argc > 3)
        return errorSyntax(Clipboard::tr("Too many arguments to '%s'."), argv[1]);

    uint32_t uMode = ClipboardMode_Disabled;
    if (!ShClHlpModeFromString(argv[2], &uMode))
        return errorSyntax(Clipboard::tr("Invalid '%s' argument '%s'."), argv[1], argv[2]);
    ClipboardMode_T const enmMode = (ClipboardMode_T)uMode;

    ComPtr<IMachine> ptrMachine;
    ComPtr<IClipboardSettings> ptrClipboard;
    HRESULT hrc = clipboardGetSettings(pArg, argv[0], ptrMachine, ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    CHECK_ERROR2(hrc, ptrClipboard, COMSETTER(Mode)(enmMode));
    if (SUCCEEDED(hrc))
    {
        CHECK_ERROR2(hrc, ptrMachine, SaveSettings());
    }
    pArg->session->UnlockMachine();
    return SUCCEEDED(hrc) ? RTEXITCODE_SUCCESS : RTEXITCODE_FAILURE;
}


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
/**
 * Handles the clipboard set-filetransfers subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandleSetFileTransfers(HandlerArg *pArg, int argc, char **argv)
{
    if (argc <= 2)
        return errorSyntax(Clipboard::tr("Missing argument to '%s'."), argv[1]);
    if (argc > 3)
        return errorSyntax(Clipboard::tr("Too many arguments to '%s'."), argv[1]);

    bool fEnabled;
    if (RT_FAILURE(parseBool(argv[2], &fEnabled)))
        return errorSyntax(Clipboard::tr("Invalid '%s' argument '%s'."), argv[1], argv[2]);

    ComPtr<IMachine> ptrMachine;
    ComPtr<IClipboardSettings> ptrClipboard;
    HRESULT hrc = clipboardGetSettings(pArg, argv[0], ptrMachine, ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    CHECK_ERROR2(hrc, ptrClipboard, COMSETTER(FileTransfersEnabled)(fEnabled));
    if (SUCCEEDED(hrc))
    {
        CHECK_ERROR2(hrc, ptrMachine, SaveSettings());
    }
    pArg->session->UnlockMachine();
    return SUCCEEDED(hrc) ? RTEXITCODE_SUCCESS : RTEXITCODE_FAILURE;
}
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */


/**
 * Handles the clipboard copy subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandleCopy(HandlerArg *pArg, int argc, char **argv)
{
    static const RTGETOPTDEF s_aOptions[] =
    {
        { "--format", CLIPBOARD_OPT_FORMAT, RTGETOPT_REQ_STRING },
        { "--raw",    CLIPBOARD_OPT_RAW,    RTGETOPT_REQ_NOTHING }
    };

    const char *pszFormat = CLIPBOARD_DEFAULT_FORMAT;

    RTGETOPTSTATE GetState;
    RTGetOptInit(&GetState, argc, argv, s_aOptions, RT_ELEMENTS(s_aOptions), 2, RTGETOPTINIT_FLAGS_OPTS_FIRST);
    RTGETOPTUNION ValueUnion;
    int ch;
    while ((ch = RTGetOpt(&GetState, &ValueUnion)) != 0)
    {
        switch (ch)
        {
            case CLIPBOARD_OPT_FORMAT:
                pszFormat = ValueUnion.psz;
                break;
            case CLIPBOARD_OPT_RAW:
                if (!pszFormat || !*pszFormat || !strcmp(pszFormat, CLIPBOARD_DEFAULT_FORMAT))
                    pszFormat = "application/octet-stream";
                break;
            default:
                return errorGetOpt(ch, &ValueUnion);
        }
    }

    ComPtr<IClipboard> ptrClipboard;
    HRESULT hrc = clipboardGet(pArg, argv[0], ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    std::vector<BYTE> abData;
    int vrc = clipboardReadStdin(abData);
    if (RT_FAILURE(vrc))
        return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Failed to read clipboard input: %Rrc"), vrc);

    SafeArray<BYTE> aBuffer(abData.size());
    if (aBuffer.size() != abData.size())
        return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Failed to allocate clipboard input buffer."));
    if (!abData.empty())
        memcpy(aBuffer.raw(), &abData[0], abData.size());

    ClipboardSource_T enmWrittenSource = ClipboardSource_Host;
    Bstr bstrWrittenMimeType;
    SafeArray<BYTE> aWrittenBuffer;
    CHECK_ERROR2_RET(hrc, ptrClipboard, WriteDataRaw(ClipboardAction_Copy, ClipboardSource_Host, Bstr(pszFormat).raw(),
                                                    ComSafeArrayAsInParam(aBuffer), &enmWrittenSource,
                                                    bstrWrittenMimeType.asOutParam(), ComSafeArrayAsOutParam(aWrittenBuffer)),
                     RTEXITCODE_FAILURE);
    return RTEXITCODE_SUCCESS;
}


/**
 * Waits for guest clipboard data and writes the matching payload.
 *
 * @returns Process exit code.
 * @param   ptrClipboard    Clipboard object to wait on.
 * @param   pszFormat       Requested MIME type, optional.
 * @param   cMsWait         Maximum wait time in milliseconds.
 */
static RTEXITCODE clipboardWaitAndPaste(ComPtr<IClipboard> const &ptrClipboard, const char *pszFormat, uint32_t cMsWait)
{
    SafeArray<VBoxEventType_T> aEventTypes;
    aEventTypes.push_back(VBoxEventType_OnClipboardDataChanged);
    aEventTypes.push_back(VBoxEventType_OnClipboardError);

    ComPtr<IEventSource> ptrEventSource;
    ComPtr<IEventListener> ptrListener;
    RTEXITCODE rcExit = clipboardRegisterListener(ptrClipboard, aEventTypes, ptrEventSource, ptrListener);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;

    uint64_t const msStart = RTTimeMilliTS();
    bool fTimedOut = false;
    for (;;)
    {
        uint32_t cMsThisWait = 1000;
        if (cMsWait != RT_INDEFINITE_WAIT)
        {
            uint64_t const cMsElapsed = RTTimeMilliTS() - msStart;
            if (cMsElapsed >= cMsWait)
            {
                fTimedOut = true;
                break;
            }
            cMsThisWait = (uint32_t)RT_MIN((uint64_t)1000, cMsWait - cMsElapsed);
        }

        ComPtr<IEvent> ptrEvent;
        HRESULT hrc = ptrEventSource->GetEvent(ptrListener, (LONG)cMsThisWait, ptrEvent.asOutParam());
        if (FAILED(hrc) || ptrEvent.isNull())
            continue;

        VBoxEventType_T enmType;
        hrc = ptrEvent->COMGETTER(Type)(&enmType);
        if (SUCCEEDED(hrc) && enmType == VBoxEventType_OnClipboardError)
        {
            clipboardUnregisterListener(ptrEventSource, ptrListener);
            return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Clipboard error while waiting for data."));
        }

        ComPtr<IClipboardItem> ptrItem;
        if (clipboardEventMatchesWait(ptrEvent, pszFormat, ptrItem))
        {
            clipboardUnregisterListener(ptrEventSource, ptrListener);
            return clipboardPasteOutputItem(ptrItem, pszFormat);
        }
    }

    clipboardUnregisterListener(ptrEventSource, ptrListener);
    if (fTimedOut)
        return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Timed out waiting for new guest clipboard data."));
    return RTEXITCODE_FAILURE;
}


/**
 * Handles the clipboard paste subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandlePaste(HandlerArg *pArg, int argc, char **argv)
{
    static const RTGETOPTDEF s_aOptions[] =
    {
        { "--format", CLIPBOARD_OPT_FORMAT, RTGETOPT_REQ_STRING },
        { "--wait",   CLIPBOARD_OPT_WAIT,   RTGETOPT_REQ_UINT32 }
    };

    const char *pszFormat = NULL;
    uint32_t cMsWait = 0;

    RTGETOPTSTATE GetState;
    RTGetOptInit(&GetState, argc, argv, s_aOptions, RT_ELEMENTS(s_aOptions), 2, RTGETOPTINIT_FLAGS_OPTS_FIRST);
    RTGETOPTUNION ValueUnion;
    int ch;
    while ((ch = RTGetOpt(&GetState, &ValueUnion)) != 0)
    {
        switch (ch)
        {
            case CLIPBOARD_OPT_FORMAT:
                pszFormat = ValueUnion.psz;
                break;
            case CLIPBOARD_OPT_WAIT:
                cMsWait = ValueUnion.u32;
                break;
            default:
                return errorGetOpt(ch, &ValueUnion);
        }
    }

    ComPtr<IClipboard> ptrClipboard;
    HRESULT hrc = clipboardGet(pArg, argv[0], ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    if (cMsWait)
        return clipboardWaitAndPaste(ptrClipboard, pszFormat, cMsWait);

    ClipboardSource_T enmSource = ClipboardSource_Host;
    Bstr bstrMimeType;
    SafeArray<BYTE> aBuffer;
    CHECK_ERROR2_RET(hrc, ptrClipboard, ReadDataRaw(ClipboardAction_Copy, &enmSource, bstrMimeType.asOutParam(),
                                                   ComSafeArrayAsOutParam(aBuffer)), RTEXITCODE_FAILURE);
    RT_NOREF(enmSource);
    return clipboardPasteOutputData(Utf8Str(bstrMimeType), pszFormat, aBuffer.raw(), aBuffer.size());
}


/**
 * Handles the clipboard formats subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandleFormats(HandlerArg *pArg, int argc, char **argv)
{
    static const RTGETOPTDEF s_aOptions[] =
    {
        { "--machinereadable", CLIPBOARD_OPT_MACHINE_READABLE, RTGETOPT_REQ_NOTHING }
    };

    bool fMachineReadable = false;
    RTGETOPTSTATE GetState;
    RTGetOptInit(&GetState, argc, argv, s_aOptions, RT_ELEMENTS(s_aOptions), 2, RTGETOPTINIT_FLAGS_OPTS_FIRST);
    RTGETOPTUNION ValueUnion;
    int ch;
    while ((ch = RTGetOpt(&GetState, &ValueUnion)) != 0)
    {
        switch (ch)
        {
            case CLIPBOARD_OPT_MACHINE_READABLE:
                fMachineReadable = true;
                break;
            default:
                return errorGetOpt(ch, &ValueUnion);
        }
    }

    ComPtr<IClipboard> ptrClipboard;
    HRESULT hrc = clipboardGet(pArg, argv[0], ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    SafeIfaceArray<IClipboardFormat> aFormats;
    CHECK_ERROR2_RET(hrc, ptrClipboard, ReadFormats(ComSafeArrayAsOutParam(aFormats)), RTEXITCODE_FAILURE);
    for (size_t i = 0; i < aFormats.size(); i++)
    {
        Bstr bstrMimeType;
        hrc = aFormats[i]->COMGETTER(MimeType)(bstrMimeType.asOutParam());
        if (FAILED(hrc))
            return RTMsgErrorExit(RTEXITCODE_FAILURE, Clipboard::tr("Failed to get clipboard format: %Rhrc"), hrc);
        Utf8Str strMimeType(bstrMimeType);
        if (fMachineReadable)
            RTPrintf("format=\"%s\"\n", strMimeType.c_str());
        else
            RTPrintf("%s\n", strMimeType.c_str());
    }

    return RTEXITCODE_SUCCESS;
}


/**
 * Handles the clipboard reset subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandleReset(HandlerArg *pArg, int argc, char **argv)
{
    RT_NOREF(argc, argv);

    ComPtr<IClipboard> ptrClipboard;
    HRESULT hrc = clipboardGet(pArg, argv[0], ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    CHECK_ERROR2_RET(hrc, ptrClipboard, Reset(), RTEXITCODE_FAILURE);
    return RTEXITCODE_SUCCESS;
}


/**
 * Parses the listen subcommand event filter list.
 *
 * @returns true if the event list was parsed successfully, false otherwise.
 * @param   pszEvents       Comma-separated event list, optional.
 * @param   aEventTypes     Where to return the selected event types.
 */
static bool clipboardParseEventList(const char *pszEvents, SafeArray<VBoxEventType_T> &aEventTypes)
{
    if (!pszEvents || !*pszEvents)
    {
        aEventTypes.push_back(VBoxEventType_OnClipboardSourceChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardFormatChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardDataChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardTransfer);
        aEventTypes.push_back(VBoxEventType_OnClipboardError);
        aEventTypes.push_back(VBoxEventType_OnClipboardModeChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardFileTransferModeChanged);
        return true;
    }

    char **papszEvents = NULL;
    size_t cEvents = 0;
    int vrc = RTStrSplit(pszEvents, strlen(pszEvents) + 1, ",", &papszEvents, &cEvents);
    if (RT_FAILURE(vrc))
        return false;

    bool fSuccess = true;
    for (size_t i = 0; i < cEvents; i++)
    {
        const char *psz = papszEvents[i];
        if (   !RTStrICmp(psz, "source")
            || !RTStrICmp(psz, "source-changed"))
            aEventTypes.push_back(VBoxEventType_OnClipboardSourceChanged);
        else if (   !RTStrICmp(psz, "format")
                 || !RTStrICmp(psz, "format-changed"))
            aEventTypes.push_back(VBoxEventType_OnClipboardFormatChanged);
        else if (   !RTStrICmp(psz, "data")
                 || !RTStrICmp(psz, "data-changed"))
            aEventTypes.push_back(VBoxEventType_OnClipboardDataChanged);
        else if (!RTStrICmp(psz, "transfer"))
            aEventTypes.push_back(VBoxEventType_OnClipboardTransfer);
        else if (!RTStrICmp(psz, "error"))
            aEventTypes.push_back(VBoxEventType_OnClipboardError);
        else if (!RTStrICmp(psz, "mode"))
            aEventTypes.push_back(VBoxEventType_OnClipboardModeChanged);
        else if (!RTStrICmp(psz, "file-transfer-mode"))
            aEventTypes.push_back(VBoxEventType_OnClipboardFileTransferModeChanged);
        else
        {
            fSuccess = false;
            break;
        }
    }

    for (size_t i = 0; i < cEvents; i++)
        RTStrFree(papszEvents[i]);
    RTMemFree(papszEvents);
    return fSuccess && aEventTypes.size() > 0;
}


/**
 * Handles the clipboard listen subcommand.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 * @param   argc            Number of command arguments.
 * @param   argv            Command argument vector.
 */
static RTEXITCODE clipboardHandleListen(HandlerArg *pArg, int argc, char **argv)
{
    static const RTGETOPTDEF s_aOptions[] =
    {
        { "--events",          CLIPBOARD_OPT_EVENTS,           RTGETOPT_REQ_STRING },
        { "--format",          CLIPBOARD_OPT_OUTPUT_FORMAT,    RTGETOPT_REQ_STRING },
        { "--timeout",         CLIPBOARD_OPT_TIMEOUT,          RTGETOPT_REQ_UINT32 },
        { "--count",           CLIPBOARD_OPT_COUNT,            RTGETOPT_REQ_UINT32 },
        { "--machinereadable", CLIPBOARD_OPT_MACHINE_READABLE, RTGETOPT_REQ_NOTHING },
        { "--verbose",         CLIPBOARD_OPT_VERBOSE,          RTGETOPT_REQ_NOTHING }
    };

    const char *pszEvents = NULL;
    CLIPBOARDLISTENFMT enmOutputFormat = CLIPBOARDLISTENFMT_HUMAN;
    uint32_t cMsTimeout = RT_INDEFINITE_WAIT;
    uint32_t cEventsMax = UINT32_MAX;
    bool fVerbose = false;

    RTGETOPTSTATE GetState;
    RTGetOptInit(&GetState, argc, argv, s_aOptions, RT_ELEMENTS(s_aOptions), 2, RTGETOPTINIT_FLAGS_OPTS_FIRST);
    RTGETOPTUNION ValueUnion;
    int ch;
    while ((ch = RTGetOpt(&GetState, &ValueUnion)) != 0)
    {
        switch (ch)
        {
            case CLIPBOARD_OPT_EVENTS:
                pszEvents = ValueUnion.psz;
                break;
            case CLIPBOARD_OPT_OUTPUT_FORMAT:
                if (!RTStrICmp(ValueUnion.psz, "human"))
                    enmOutputFormat = CLIPBOARDLISTENFMT_HUMAN;
                else if (!RTStrICmp(ValueUnion.psz, "json"))
                    enmOutputFormat = CLIPBOARDLISTENFMT_JSON;
                else if (!RTStrICmp(ValueUnion.psz, "machinereadable"))
                    enmOutputFormat = CLIPBOARDLISTENFMT_MACHINE_READABLE;
                else
                    return errorArgument(Clipboard::tr("Invalid --format argument '%s'."), ValueUnion.psz);
                break;
            case CLIPBOARD_OPT_TIMEOUT:
                cMsTimeout = ValueUnion.u32;
                break;
            case CLIPBOARD_OPT_COUNT:
                cEventsMax = ValueUnion.u32 ? ValueUnion.u32 : UINT32_MAX;
                break;
            case CLIPBOARD_OPT_MACHINE_READABLE:
                enmOutputFormat = CLIPBOARDLISTENFMT_MACHINE_READABLE;
                break;
            case CLIPBOARD_OPT_VERBOSE:
                fVerbose = true;
                break;
            default:
                return errorGetOpt(ch, &ValueUnion);
        }
    }

    SafeArray<VBoxEventType_T> aEventTypes;
    if (!clipboardParseEventList(pszEvents, aEventTypes))
        return errorArgument(Clipboard::tr("Invalid --events argument '%s'."), pszEvents ? pszEvents : "");

    ComPtr<IClipboard> ptrClipboard;
    HRESULT hrc = clipboardGet(pArg, argv[0], ptrClipboard);
    if (FAILED(hrc))
        return RTEXITCODE_FAILURE;

    ComPtr<IEventSource> ptrEventSource;
    ComPtr<IEventListener> ptrListener;
    RTEXITCODE rcExit = clipboardRegisterListener(ptrClipboard, aEventTypes, ptrEventSource, ptrListener);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;

    uint64_t const msStart = RTTimeMilliTS();
    uint32_t cEvents = 0;
    bool fTimedOut = false;
    while (cEvents < cEventsMax)
    {
        uint32_t cMsThisWait = 1000;
        if (cMsTimeout != RT_INDEFINITE_WAIT)
        {
            uint64_t const cMsElapsed = RTTimeMilliTS() - msStart;
            if (cMsElapsed >= cMsTimeout)
            {
                fTimedOut = true;
                break;
            }
            cMsThisWait = (uint32_t)RT_MIN((uint64_t)1000, cMsTimeout - cMsElapsed);
        }

        ComPtr<IEvent> ptrEvent;
        hrc = ptrEventSource->GetEvent(ptrListener, (LONG)cMsThisWait, ptrEvent.asOutParam());
        if (FAILED(hrc) || ptrEvent.isNull())
            continue;

        clipboardPrintEvent(enmOutputFormat, ptrEvent, fVerbose);
        cEvents++;
    }

    clipboardUnregisterListener(ptrEventSource, ptrListener);
    if (fTimedOut)
        return RTEXITCODE_FAILURE;
    return RTEXITCODE_SUCCESS;
}


/**
 * Handles the VBoxManage clipboard command.
 *
 * @returns Process exit code.
 * @param   pArg            Command handler arguments.
 */
RTEXITCODE handleClipboard(HandlerArg *pArg)
{
    AssertPtr(pArg);

    if (pArg->argc < 2)
        return errorNoSubcommand();

    const char *pszSubcommand = pArg->argv[1];
    if (!strcmp(pszSubcommand, "set-mode"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_SET_MODE);
        return clipboardHandleSetMode(pArg, pArg->argc, pArg->argv);
    }
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    if (!strcmp(pszSubcommand, "set-filetransfers"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_SET_FILETRANSFERS);
        return clipboardHandleSetFileTransfers(pArg, pArg->argc, pArg->argv);
    }
#endif
    if (!strcmp(pszSubcommand, "copy"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_COPY);
        return clipboardHandleCopy(pArg, pArg->argc, pArg->argv);
    }
    if (!strcmp(pszSubcommand, "paste"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_PASTE);
        return clipboardHandlePaste(pArg, pArg->argc, pArg->argv);
    }
    if (!strcmp(pszSubcommand, "formats"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_FORMATS);
        return clipboardHandleFormats(pArg, pArg->argc, pArg->argv);
    }
    if (!strcmp(pszSubcommand, "reset"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_RESET);
        return clipboardHandleReset(pArg, pArg->argc, pArg->argv);
    }
    if (!strcmp(pszSubcommand, "listen"))
    {
        setCurrentSubcommand(HELP_SCOPE_CLIPBOARD_LISTEN);
        return clipboardHandleListen(pArg, pArg->argc, pArg->argv);
    }

    return errorUnknownSubcommand(pszSubcommand);
}
