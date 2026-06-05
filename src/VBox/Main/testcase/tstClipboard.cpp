/* $Id: tstClipboard.cpp 114262 2026-06-05 17:00:59Z andreas.loeffler@oracle.com $ */
/** @file
 * Main API Testcase - Clipboard.
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
#include "ClipboardImpl.h"

#include <VBox/com/array.h>
#include <VBox/com/com.h>
#include <VBox/com/string.h>

#include <iprt/string.h>
#include <iprt/test.h>

#include <string.h>


/*********************************************************************************************************************************
*   Internal Functions                                                                                                            *
*********************************************************************************************************************************/
static HRESULT tstCreateFormat(const char *pszMimeType, ComPtr<IClipboardFormat> &ptrFormat)
{
    ComObjPtr<ClipboardFormat> ptrFormatObj;
    HRESULT hrc = ptrFormatObj.createObject();
    if (FAILED(hrc))
        return hrc;
    hrc = ptrFormatObj->init(pszMimeType);
    if (FAILED(hrc))
        return hrc;
    return ptrFormatObj.queryInterfaceTo(ptrFormat.asOutParam());
}


static HRESULT tstCreateItem(ClipboardSource_T enmSource, const ComPtr<IClipboardFormat> &ptrFormat,
                             const std::vector<BYTE> &abData, ComPtr<IClipboardItem> &ptrItem)
{
    ComObjPtr<ClipboardItem> ptrItemObj;
    HRESULT hrc = ptrItemObj.createObject();
    if (FAILED(hrc))
        return hrc;
    hrc = ptrItemObj->init(0 /* aId */, enmSource, ptrFormat, abData);
    if (FAILED(hrc))
        return hrc;
    return ptrItemObj.queryInterfaceTo(ptrItem.asOutParam());
}


static bool tstFormatArrayContains(const com::SafeIfaceArray<IClipboardFormat> &aFormats, const char *pszMimeType)
{
    for (size_t i = 0; i < aFormats.size(); ++i)
    {
        com::Bstr bstrMimeType;
        HRESULT hrc = aFormats[i]->COMGETTER(MimeType)(bstrMimeType.asOutParam());
        if (SUCCEEDED(hrc) && !RTStrICmp(com::Utf8Str(bstrMimeType).c_str(), pszMimeType))
            return true;
    }
    return false;
}


static void tstClipboardBasics(RTTEST hTest)
{
    RTTestSub(hTest, "Basics");

    ComObjPtr<Clipboard> ptrClipboardObj;
    HRESULT hrc = ptrClipboardObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("createObject failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboardObj->init();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboard> ptrClipboard;
    hrc = ptrClipboardObj.queryInterfaceTo(ptrClipboard.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("queryInterfaceTo failed, hrc=%Rhrc\n", hrc));

    ClipboardMode_T enmMode = ClipboardMode_Bidirectional;
    hrc = ptrClipboard->COMGETTER(Mode)(&enmMode);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Mode) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(enmMode == ClipboardMode_Disabled);

    hrc = ptrClipboard->COMSETTER(Mode)(ClipboardMode_Bidirectional);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(Mode) failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboard->COMGETTER(Mode)(&enmMode);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Mode) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(enmMode == ClipboardMode_Bidirectional);

    BOOL fFileTransfersEnabled = TRUE;
    hrc = ptrClipboardObj->i_getFileTransfersEnabled(&fFileTransfersEnabled);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("i_getFileTransfersEnabled failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!fFileTransfersEnabled);
    hrc = ptrClipboardObj->i_setFileTransfersEnabled(TRUE);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("i_setFileTransfersEnabled failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboardObj->i_getFileTransfersEnabled(&fFileTransfersEnabled);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("i_getFileTransfersEnabled failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(fFileTransfersEnabled);

    com::SafeArray<BSTR> aFiles(2);
    com::Bstr bstrFile0("/tmp/clipboard-one.txt");
    com::Bstr bstrFile1("/tmp/clipboard-two.txt");
    bstrFile0.cloneTo(&aFiles[0]);
    bstrFile1.cloneTo(&aFiles[1]);
    hrc = ptrClipboard->COMSETTER(FileList)(ComSafeArrayAsInParam(aFiles));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(FileList) failed, hrc=%Rhrc\n", hrc));

    com::SafeArray<BSTR> aReadFiles;
    hrc = ptrClipboard->COMGETTER(FileList)(ComSafeArrayAsOutParam(aReadFiles));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileList) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(aReadFiles.size() == 2);
    if (aReadFiles.size() == 2)
    {
        RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(aReadFiles[0]).c_str(), "/tmp/clipboard-one.txt"));
        RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(aReadFiles[1]).c_str(), "/tmp/clipboard-two.txt"));
    }

    ComPtr<IEventSource> ptrEventSource;
    hrc = ptrClipboard->COMGETTER(EventSource)(ptrEventSource.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(EventSource) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!ptrEventSource.isNull());

    ComPtr<IClipboardTransferManager> ptrTransfers;
    hrc = ptrClipboard->COMGETTER(Transfers)(ptrTransfers.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Transfers) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!ptrTransfers.isNull());

    com::SafeIfaceArray<IClipboardFormat> aSupportedFormats;
    hrc = ptrClipboard->GetSupportedFormats(ClipboardSource_Host, ComSafeArrayAsOutParam(aSupportedFormats));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("GetSupportedFormats failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(tstFormatArrayContains(aSupportedFormats, "text/plain;charset=utf-8"));
    RTTESTI_CHECK(tstFormatArrayContains(aSupportedFormats, "text/html"));
    RTTESTI_CHECK(tstFormatArrayContains(aSupportedFormats, "image/bmp"));
}


static void tstClipboardFormats(RTTEST hTest)
{
    RTTestSub(hTest, "Formats");

    ComObjPtr<Clipboard> ptrClipboardObj;
    HRESULT hrc = ptrClipboardObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("createObject failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboardObj->init();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboard> ptrClipboard;
    hrc = ptrClipboardObj.queryInterfaceTo(ptrClipboard.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("queryInterfaceTo failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardFormat> ptrTextFormat;
    hrc = tstCreateFormat("text/plain", ptrTextFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat(text/plain) failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardFormat> ptrHtmlFormat;
    hrc = tstCreateFormat("text/html;charset=utf-8", ptrHtmlFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat(text/html) failed, hrc=%Rhrc\n", hrc));

    com::SafeIfaceArray<IClipboardFormat> aFormats(2);
    ptrTextFormat.queryInterfaceTo(&aFormats[0]);
    ptrHtmlFormat.queryInterfaceTo(&aFormats[1]);
    hrc = ptrClipboard->WriteFormats(ComSafeArrayAsInParam(aFormats));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("WriteFormats failed, hrc=%Rhrc\n", hrc));

    BOOL fAvailable = FALSE;
    hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrTextFormat, &fAvailable);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IsFormatAvailable(text) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(fAvailable == TRUE);

    com::SafeIfaceArray<IClipboardFormat> aReadFormats;
    hrc = ptrClipboard->ReadFormats(ComSafeArrayAsOutParam(aReadFormats));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadFormats failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(aReadFormats.size() == 2);
    RTTESTI_CHECK(tstFormatArrayContains(aReadFormats, "text/plain;charset=utf-8"));
    RTTESTI_CHECK(tstFormatArrayContains(aReadFormats, "text/html"));

    ComPtr<IClipboardFormat> ptrBadFormat;
    hrc = tstCreateFormat("application/x-unsupported", ptrBadFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat(unsupported) failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrBadFormat, &fAvailable);
    RTTESTI_CHECK(FAILED(hrc));
}


static void tstClipboardData(RTTEST hTest)
{
    RTTestSub(hTest, "Data");

    ComObjPtr<Clipboard> ptrClipboardObj;
    HRESULT hrc = ptrClipboardObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("createObject failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboardObj->init();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboard> ptrClipboard;
    hrc = ptrClipboardObj.queryInterfaceTo(ptrClipboard.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("queryInterfaceTo failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardFormat> ptrTextFormat;
    hrc = tstCreateFormat("text/plain;charset=utf-8", ptrTextFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat failed, hrc=%Rhrc\n", hrc));

    const char szText[] = "Hello from the Main clipboard testcase";
    std::vector<BYTE> abText(sizeof(szText));
    memcpy(&abText[0], szText, sizeof(szText));

    ComPtr<IClipboardItem> ptrItem;
    hrc = tstCreateItem(ClipboardSource_Host, ptrTextFormat, abText, ptrItem);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateItem failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardItem> ptrWrittenItem;
    hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrItem, ptrWrittenItem.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("WriteData failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!ptrWrittenItem.isNull());

    ULONG idWritten = 0;
    hrc = ptrWrittenItem->COMGETTER(Id)(&idWritten);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Id) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(idWritten != 0);

    ULONG cbWritten = 0;
    hrc = ptrWrittenItem->COMGETTER(Size)(&cbWritten);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Size) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(cbWritten == sizeof(szText));

    ComPtr<IClipboardItem> ptrReadItem;
    hrc = ptrClipboard->ReadData(ClipboardAction_Paste, ptrReadItem.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadData failed, hrc=%Rhrc\n", hrc));

    com::SafeArray<BYTE> abReadText;
    hrc = ptrReadItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(abReadText));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Buffer) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(abReadText.size() == sizeof(szText));
    if (abReadText.size() == sizeof(szText))
        RTTESTI_CHECK(!memcmp(abReadText.raw(), szText, sizeof(szText)));

    BOOL fAvailable = FALSE;
    hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrTextFormat, &fAvailable);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IsFormatAvailable failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(fAvailable == TRUE);

    hrc = ptrClipboard->ReadData(ClipboardAction_Invalid, ptrReadItem.asOutParam());
    RTTESTI_CHECK(FAILED(hrc));
}


static void tstClipboardTransfersAndReset(RTTEST hTest)
{
    RTTestSub(hTest, "Transfers and reset");

    ComObjPtr<Clipboard> ptrClipboardObj;
    HRESULT hrc = ptrClipboardObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("createObject failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboardObj->init();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboard> ptrClipboard;
    hrc = ptrClipboardObj.queryInterfaceTo(ptrClipboard.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("queryInterfaceTo failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardTransferManager> ptrTransfers;
    hrc = ptrClipboard->COMGETTER(Transfers)(ptrTransfers.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("COMGETTER(Transfers) failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardFormat> ptrTextFormat;
    hrc = tstCreateFormat("text/plain", ptrTextFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat failed, hrc=%Rhrc\n", hrc));
    std::vector<BYTE> abText(4, 'T');
    ComPtr<IClipboardItem> ptrItem;
    hrc = tstCreateItem(ClipboardSource_Guest, ptrTextFormat, abText, ptrItem);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateItem failed, hrc=%Rhrc\n", hrc));

    ComObjPtr<ClipboardTransfer> ptrTransferObj;
    hrc = ptrTransferObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("create transfer failed, hrc=%Rhrc\n", hrc));
    hrc = ptrTransferObj->init(1 /* aId */, ClipboardAction_Copy, ptrItem, NULL);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("transfer init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardTransfer> ptrTransfer;
    hrc = ptrTransferObj.queryInterfaceTo(ptrTransfer.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("transfer queryInterfaceTo failed, hrc=%Rhrc\n", hrc));

    hrc = ptrTransfers->Add(ptrTransfer);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("transfer Add failed, hrc=%Rhrc\n", hrc));

    com::SafeIfaceArray<IClipboardTransfer> aTransfers;
    hrc = ptrTransfers->COMGETTER(Transfers)(ComSafeArrayAsOutParam(aTransfers));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Transfers) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(aTransfers.size() == 1);

    hrc = ptrTransfers->Cancel(ptrTransfer);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("transfer Cancel failed, hrc=%Rhrc\n", hrc));
    aTransfers.setNull();
    hrc = ptrTransfers->COMGETTER(Transfers)(ComSafeArrayAsOutParam(aTransfers));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Transfers) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(aTransfers.size() == 0);

    ComPtr<IClipboardItem> ptrWrittenItem;
    hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrItem, ptrWrittenItem.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("WriteData failed, hrc=%Rhrc\n", hrc));

    hrc = ptrClipboard->Reset();
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("Reset failed, hrc=%Rhrc\n", hrc));

    BOOL fAvailable = TRUE;
    hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrTextFormat, &fAvailable);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IsFormatAvailable failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(fAvailable == FALSE);

    ComPtr<IClipboardItem> ptrReadItem;
    hrc = ptrClipboard->ReadData(ClipboardAction_Paste, ptrReadItem.asOutParam());
    RTTESTI_CHECK(FAILED(hrc));
}


int main()
{
    RTTEST hTest;
    RTEXITCODE rcExit = RTTestInitAndCreate("tstClipboard", &hTest);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;

    RTTestBanner(hTest);

    HRESULT hrc = com::Initialize();
    if (FAILED(hrc))
    {
        RTTestFailed(hTest, "Failed to initialize COM, hrc=%Rhrc", hrc);
        return RTTestSummaryAndDestroy(hTest);
    }

    tstClipboardBasics(hTest);
    tstClipboardFormats(hTest);
    tstClipboardData(hTest);
    tstClipboardTransfersAndReset(hTest);

    com::Shutdown();
    return RTTestSummaryAndDestroy(hTest);
}
