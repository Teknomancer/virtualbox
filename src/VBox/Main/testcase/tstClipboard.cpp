/* $Id: tstClipboard.cpp 114549 2026-06-26 09:31:36Z andreas.loeffler@oracle.com $ */
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
#include <VBox/com/array.h>
#include <VBox/com/com.h>
#include <VBox/com/ErrorInfo.h>
#include <VBox/com/string.h>
#include <VBox/com/VirtualBox.h>
#include <VBox/log.h>

#include <iprt/log.h>
#include <iprt/message.h>
#include <iprt/string.h>
#include <iprt/test.h>
#include <iprt/thread.h>
#include <iprt/utf16.h>
#include <iprt/uuid.h>

#include <string.h>
#include <vector>

using namespace com;


/*********************************************************************************************************************************
*   Global Variables                                                                                                             *
*********************************************************************************************************************************/
/** The testcase logger. */
static PRTLOGGER    g_pLogger;


/*********************************************************************************************************************************
*   Internal Functions                                                                                                           *
*********************************************************************************************************************************/
/**
 * Creates a clipboard format object through the public Main API.
 *
 * @returns COM status code.
 * @param   pClipboard      Clipboard API object to use.
 * @param   pszMimeType     MIME type for the format object.
 * @param   ptrFormat       Where to return the created format object.
 */
static HRESULT tstCreateFormat(IClipboard *pClipboard, const char *pszMimeType, ComPtr<IClipboardFormat> &ptrFormat)
{
    AssertPtrReturn(pClipboard, E_POINTER);
    return pClipboard->CreateFormat(Bstr(pszMimeType).raw(), ptrFormat.asOutParam());
}


/**
 * Creates a clipboard item object through the public Main API.
 *
 * @returns COM status code.
 * @param   pClipboard      Clipboard API object to use.
 * @param   enmSource       Clipboard source.
 * @param   ptrFormat       Clipboard format object.
 * @param   abData          Payload bytes.
 * @param   ptrItem         Where to return the created item object.
 */
static HRESULT tstCreateItem(IClipboard *pClipboard, ClipboardSource_T enmSource, const ComPtr<IClipboardFormat> &ptrFormat,
                             const std::vector<BYTE> &abData, ComPtr<IClipboardItem> &ptrItem)
{
    AssertPtrReturn(pClipboard, E_POINTER);

    SafeArray<BYTE> aBuffer;
    if (!abData.empty())
    {
        HRESULT hrc = aBuffer.initFrom(&abData[0], abData.size());
        if (FAILED(hrc))
            return hrc;
    }

    return pClipboard->CreateItem(enmSource, ptrFormat, ComSafeArrayAsInParam(aBuffer), ptrItem.asOutParam());
}


/**
 * Checks whether a byte SafeArray contains the expected bytes.
 *
 * @returns true if the buffers match, false otherwise.
 * @param   aBuffer         Buffer to check.
 * @param   abExpected      Expected payload bytes.
 */
static bool tstByteArrayEquals(const SafeArray<BYTE> &aBuffer, const std::vector<BYTE> &abExpected)
{
    if (aBuffer.size() != abExpected.size())
        return false;
    if (abExpected.empty())
        return true;
    return !memcmp(aBuffer.raw(), &abExpected[0], abExpected.size());
}


/**
 * Creates deterministic byte test data from a NUL-terminated string, excluding the terminator.
 *
 * @returns Byte vector containing the string bytes.
 * @param   pszData         Test data string.
 */
static std::vector<BYTE> tstBytesFromString(const char *pszData)
{
    AssertPtrReturn(pszData, std::vector<BYTE>());

    size_t const cbData = strlen(pszData);
    std::vector<BYTE> abData(cbData);
    if (cbData)
        memcpy(&abData[0], pszData, cbData);
    return abData;
}


/**
 * Initializes a byte SafeArray from a vector.
 *
 * @returns COM status code.
 * @param   abData          Source bytes.
 * @param   aData           SafeArray to initialize.
 */
static HRESULT tstSafeArrayFromBytes(const std::vector<BYTE> &abData, SafeArray<BYTE> &aData)
{
    if (abData.empty())
        return S_OK;
    return aData.initFrom(&abData[0], abData.size());
}


/**
 * Reads raw clipboard data and checks the source, MIME type, and payload.
 *
 * @returns true if the read matched the expected data, false otherwise.
 * @param   pClipboard          Clipboard API object to use.
 * @param   pszWhat             Description used in failure messages.
 * @param   enmExpectedSource   Expected clipboard source.
 * @param   pszExpectedMimeType Expected MIME type.
 * @param   abExpected          Expected payload bytes.
 */
static bool tstReadDataRawEquals(IClipboard *pClipboard, const char *pszWhat, ClipboardSource_T enmExpectedSource,
                                 const char *pszExpectedMimeType, const std::vector<BYTE> &abExpected)
{
    AssertPtrReturn(pClipboard, false);
    AssertPtrReturn(pszWhat, false);
    AssertPtrReturn(pszExpectedMimeType, false);

    ClipboardSource_T enmReadSource = ClipboardSource_Custom;
    Bstr bstrRequestedMimeType("");
    Bstr bstrReadMimeType;
    SafeArray<BYTE> aReadBuffer;
    HRESULT hrc = pClipboard->ReadDataRaw(ClipboardAction_Copy, bstrRequestedMimeType.raw(), &enmReadSource,
                                          bstrReadMimeType.asOutParam(), ComSafeArrayAsOutParam(aReadBuffer));
    if (FAILED(hrc))
    {
        RTTestIFailed("%s: ReadDataRaw failed, hrc=%Rhrc\n", pszWhat, hrc);
        return false;
    }

    bool fRc = true;
    if (enmReadSource != enmExpectedSource)
    {
        RTTestIFailed("%s: ReadDataRaw source %d, expected %d\n", pszWhat, enmReadSource, enmExpectedSource);
        fRc = false;
    }

    Utf8Str strReadMimeType(bstrReadMimeType);
    if (RTStrCmp(strReadMimeType.c_str(), pszExpectedMimeType))
    {
        RTTestIFailed("%s: ReadDataRaw MIME '%s', expected '%s'\n", pszWhat, strReadMimeType.c_str(), pszExpectedMimeType);
        fRc = false;
    }

    if (!tstByteArrayEquals(aReadBuffer, abExpected))
    {
        RTTestIFailed("%s: ReadDataRaw returned %zu bytes, expected %zu\n", pszWhat, aReadBuffer.size(), abExpected.size());
        fRc = false;
    }

    return fRc;
}


/**
 * Writes data through IHostClipboard::SetData and verifies regular Main state is unchanged.
 *
 * @returns true if all readbacks matched, false otherwise.
 * @param   pClipboard          Clipboard API object to use for readback.
 * @param   pHostClipboard      Host clipboard endpoint to test.
 * @param   pszMimeType         MIME type to publish to the native host clipboard.
 * @param   abData              Deterministic payload bytes to publish.
 * @param   enmExpectedSource   Expected regular Main clipboard source after publication.
 * @param   pszExpectedMimeType Expected regular Main clipboard MIME type after publication.
 * @param   abExpected          Expected regular Main clipboard payload after publication.
 * @param   cReads              Number of repeated readbacks to perform.
 * @param   pszWhat             Description used in failure messages.
 */
static bool tstHostClipboardSetDataAndKeepReadBack(IClipboard *pClipboard, IHostClipboard *pHostClipboard,
                                                   const char *pszMimeType, const std::vector<BYTE> &abData,
                                                   ClipboardSource_T enmExpectedSource, const char *pszExpectedMimeType,
                                                   const std::vector<BYTE> &abExpected, unsigned cReads,
                                                   const char *pszWhat)
{
    AssertPtrReturn(pClipboard, false);
    AssertPtrReturn(pHostClipboard, false);
    AssertPtrReturn(pszMimeType, false);
    AssertPtrReturn(pszExpectedMimeType, false);
    AssertPtrReturn(pszWhat, false);

    SafeArray<BYTE> aData;
    HRESULT hrc = tstSafeArrayFromBytes(abData, aData);
    if (FAILED(hrc))
    {
        RTTestIFailed("%s: SafeArray initFrom failed, hrc=%Rhrc\n", pszWhat, hrc);
        return false;
    }

    hrc = pHostClipboard->SetData(ClipboardAction_Copy, ClipboardSource_Guest, Bstr(pszMimeType).raw(),
                                  ComSafeArrayAsInParam(aData));
    if (FAILED(hrc))
    {
        RTTestIFailed("%s: IHostClipboard::SetData failed, hrc=%Rhrc\n", pszWhat, hrc);
        return false;
    }

    bool fRc = true;
    for (unsigned i = 0; i < cReads; i++)
    {
        char szWhat[128];
        RTStrPrintf(szWhat, sizeof(szWhat), "%s preserved readback %u", pszWhat, i);
        if (!tstReadDataRawEquals(pClipboard, szWhat, enmExpectedSource, pszExpectedMimeType, abExpected))
            fRc = false;
    }
    return fRc;
}


/**
 * Tries to observe a native host-source readback after IHostClipboard publication.
 *
 * This is intentionally guarded: headless or no-backend environments may never
 * reflect the native clipboard back into Main as ClipboardSource_Host.
 *
 * @param   hTest               Test handle.
 * @param   pClipboard          Clipboard API object to use.
 * @param   pszMimeType         Expected MIME type.
 * @param   abExpected          Expected payload bytes.
 */
static void tstHostClipboardTryNativeReadBack(RTTEST hTest, IClipboard *pClipboard, const char *pszMimeType,
                                              const std::vector<BYTE> &abExpected)
{
    RTTestSub(hTest, "IHostClipboard native host clipboard observation");

    for (unsigned i = 0; i < 20; i++)
    {
        ClipboardSource_T enmReadSource = ClipboardSource_Custom;
        Bstr bstrRequestedMimeType("");
        Bstr bstrReadMimeType;
        SafeArray<BYTE> aReadBuffer;
        HRESULT hrc = pClipboard->ReadDataRaw(ClipboardAction_Copy, bstrRequestedMimeType.raw(), &enmReadSource,
                                              bstrReadMimeType.asOutParam(), ComSafeArrayAsOutParam(aReadBuffer));
        if (SUCCEEDED(hrc) && enmReadSource == ClipboardSource_Host)
        {
            Utf8Str strReadMimeType(bstrReadMimeType);
            if (   !RTStrCmp(strReadMimeType.c_str(), pszMimeType)
                && tstByteArrayEquals(aReadBuffer, abExpected))
                return;
        }
        RTThreadSleep(100);
    }

    RTTestSkipped(hTest, "Native host clipboard did not become observable as host-owned data; this is expected on "
                         "headless/no-backend or lazy/no-op backend runs");
}


/**
 * Tests the sole host clipboard endpoint implementation exposed by IClipboard.
 *
 * @param   hTest                   Test handle.
 * @param   pClipboard              Clipboard API object to use.
 * @param   pClipboardSettings      Clipboard settings for mode validation.
 * @param   pEventSource            Clipboard event source for data request events.
 * @param   ptrTextFormat           Supported text format object.
 * @param   bstrGuestReadMimeType   MIME type from the regular readback path.
 * @param   aGuestReadBuffer        Payload from the regular readback path.
 * @param   abRoundTripBuffer       Expected regular readback payload bytes.
 */
static void tstHostClipboard(RTTEST hTest, IClipboard *pClipboard, IClipboardSettings *pClipboardSettings,
                             IEventSource *pEventSource, const ComPtr<IClipboardFormat> &ptrTextFormat,
                             const Bstr &bstrGuestReadMimeType, const SafeArray<BYTE> &aGuestReadBuffer,
                             const std::vector<BYTE> &abRoundTripBuffer)
{
    RTTestSub(hTest, "IHostClipboard public endpoint");

    HRESULT hrc = S_OK;
    bool fListenerRegistered = false;
    ComPtr<IEventListener> ptrListener;
    ComPtr<IHostClipboard> ptrHostClipboard;

    do
    {
        /* Verify the endpoint object is reachable from the public clipboard API. */
        hrc = pClipboard->COMGETTER(HostClipboard)(ptrHostClipboard.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(HostClipboard) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG_BREAK(!ptrHostClipboard.isNull(), ("COMGETTER(HostClipboard) returned NULL\n"));

        /* Verify the native host endpoint can be explicitly reset. */
        hrc = ptrHostClipboard->Clear();
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("HostClipboard Clear failed, hrc=%Rhrc\n", hrc));

        std::vector<ComPtr<IClipboardFormat> > vecHostFormats;
        vecHostFormats.push_back(ptrTextFormat);
        SafeIfaceArray<IClipboardFormat> aHostTextFormats(vecHostFormats);

        /* Verify guest-origin offers are blocked when mode disallows guest-to-host publication. */
        hrc = pClipboardSettings->COMSETTER(Mode)(ClipboardMode_HostToGuest);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMSETTER(Mode) HostToGuest before IHostClipboard failed, hrc=%Rhrc\n", hrc));

        hrc = ptrHostClipboard->ReportFormats(ClipboardAction_Copy, ClipboardSource_Guest,
                                              ComSafeArrayAsInParam(aHostTextFormats));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ACCESS_DENIED,
                          ("HostClipboard ReportFormats in HostToGuest mode returned hrc=%Rhrc\n", hrc));

        hrc = ptrHostClipboard->ReportFormats(ClipboardAction_Copy, ClipboardSource_Host,
                                              ComSafeArrayAsInParam(aHostTextFormats));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ACCESS_DENIED,
                          ("HostClipboard ReportFormats with host source returned hrc=%Rhrc\n", hrc));

        ComPtr<IClipboardFormat> ptrOctetStreamFormat;
        hrc = tstCreateFormat(pClipboard, "application/octet-stream", ptrOctetStreamFormat);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateFormat(octet-stream) failed, hrc=%Rhrc\n", hrc));
        vecHostFormats.clear();
        vecHostFormats.push_back(ptrOctetStreamFormat);
        SafeIfaceArray<IClipboardFormat> aHostOctetFormats(vecHostFormats);
        hrc = ptrHostClipboard->ReportFormats(ClipboardAction_Copy, ClipboardSource_Guest,
                                              ComSafeArrayAsInParam(aHostOctetFormats));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_FORMAT_NOT_SUPPORTED,
                          ("HostClipboard ReportFormats with application/octet-stream returned hrc=%Rhrc\n", hrc));

        /* Restore bidirectional mode before exercising successful IHostClipboard guest publication. */
        hrc = pClipboardSettings->COMSETTER(Mode)(ClipboardMode_Bidirectional);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMSETTER(Mode) Bidirectional before IHostClipboard failed, hrc=%Rhrc\n", hrc));

        /* Verify guest format offers and early ProvideData rejection paths. */
        vecHostFormats.clear();
        vecHostFormats.push_back(ptrTextFormat);
        SafeIfaceArray<IClipboardFormat> aHostGuestTextFormats(vecHostFormats);
        hrc = ptrHostClipboard->ReportFormats(ClipboardAction_Copy, ClipboardSource_Guest,
                                              ComSafeArrayAsInParam(aHostGuestTextFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("HostClipboard ReportFormats(guest) failed, hrc=%Rhrc\n", hrc));

        hrc = ptrHostClipboard->ProvideData(0 /* requestId */, ClipboardAction_Copy, ClipboardSource_Guest,
                                            bstrGuestReadMimeType.raw(), ComSafeArrayAsInParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ERROR,
                          ("HostClipboard ProvideData with zero request ID returned hrc=%Rhrc\n", hrc));

        hrc = ptrHostClipboard->ProvideData(1 /* requestId */, ClipboardAction_Copy, ClipboardSource_Guest,
                                            Bstr("application/octet-stream").raw(), ComSafeArrayAsInParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_FORMAT_NOT_SUPPORTED,
                          ("HostClipboard ProvideData with application/octet-stream returned hrc=%Rhrc\n", hrc));

        hrc = ptrHostClipboard->ProvideData(1 /* requestId */, ClipboardAction_Copy, ClipboardSource_Guest,
                                            bstrGuestReadMimeType.raw(), ComSafeArrayAsInParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ERROR,
                          ("HostClipboard ProvideData without pending request returned hrc=%Rhrc\n", hrc));

        /* Validate ProvideData against a real pending request ID generated by Main. */
        hrc = pEventSource->CreateListener(ptrListener.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateListener(data requested) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrListener.isNull());
        SafeArray<VBoxEventType_T> aRequestEventTypes;
        aRequestEventTypes.push_back(VBoxEventType_OnClipboardDataRequested);
        hrc = pEventSource->RegisterListener(ptrListener, ComSafeArrayAsInParam(aRequestEventTypes), FALSE /* aActive */);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("RegisterListener(data requested) failed, hrc=%Rhrc\n", hrc));
        fListenerRegistered = SUCCEEDED(hrc);

        ComPtr<IInternalClipboardControl> ptrInternalClipboardControl(pClipboard);
        RTTESTI_CHECK_MSG_BREAK(!ptrInternalClipboardControl.isNull(), ("Query IInternalClipboardControl returned NULL\n"));

        ULONG idRequest = 0;
        hrc = ptrInternalClipboardControl->RequestData(bstrGuestReadMimeType.raw(), &idRequest);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("IInternalClipboardControl::RequestData failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG(idRequest != 0, ("IInternalClipboardControl::RequestData returned zero request ID\n"));

        ComPtr<IEvent> ptrRequestEvent;
        hrc = pEventSource->GetEvent(ptrListener, 1000 /* aTimeout */, ptrRequestEvent.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("GetEvent(data requested) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG_BREAK(!ptrRequestEvent.isNull(), ("GetEvent(data requested) returned no event\n"));

        VBoxEventType_T enmRequestEventType = VBoxEventType_Invalid;
        hrc = ptrRequestEvent->COMGETTER(Type)(&enmRequestEventType);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Type)(data requested) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG(enmRequestEventType == VBoxEventType_OnClipboardDataRequested,
                          ("GetEvent(data requested) returned type %d, expected %d\n",
                           enmRequestEventType, VBoxEventType_OnClipboardDataRequested));

        BOOL fRequestEventWaitable = TRUE;
        hrc = ptrRequestEvent->COMGETTER(Waitable)(&fRequestEventWaitable);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Waitable)(data requested) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG(!fRequestEventWaitable, ("OnClipboardDataRequested unexpectedly became waitable\n"));

        ComPtr<IClipboardDataRequestedEvent> ptrDataRequestedEvent = ptrRequestEvent;
        RTTESTI_CHECK(!ptrDataRequestedEvent.isNull());
        if (ptrDataRequestedEvent.isNotNull())
        {
            ULONG idEventRequest = 0;
            hrc = ptrDataRequestedEvent->COMGETTER(RequestId)(&idEventRequest);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(RequestId) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK_MSG(idEventRequest == idRequest,
                              ("Request event ID %RU32, expected %RU32\n", (uint32_t)idEventRequest, (uint32_t)idRequest));

            ClipboardAction_T enmRequestAction = ClipboardAction_Custom;
            hrc = ptrDataRequestedEvent->COMGETTER(Action)(&enmRequestAction);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Action) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(enmRequestAction == ClipboardAction_Copy);

            ClipboardSource_T enmRequestSource = ClipboardSource_Custom;
            hrc = ptrDataRequestedEvent->COMGETTER(ClipboardSource)(&enmRequestSource);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(ClipboardSource) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(enmRequestSource == ClipboardSource_Guest);

            ComPtr<IClipboardFormat> ptrRequestFormat;
            hrc = ptrDataRequestedEvent->COMGETTER(Format)(ptrRequestFormat.asOutParam());
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Format) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(!ptrRequestFormat.isNull());
            if (ptrRequestFormat.isNotNull())
            {
                Bstr bstrRequestMimeType;
                hrc = ptrRequestFormat->COMGETTER(MimeType)(bstrRequestMimeType.asOutParam());
                RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType)(request format) failed, hrc=%Rhrc\n", hrc));
                RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrRequestMimeType).c_str(), "text/plain;charset=utf-8"));
            }
        }

        hrc = ptrHostClipboard->ProvideData(idRequest, ClipboardAction_Copy, ClipboardSource_Guest,
                                            bstrGuestReadMimeType.raw(), ComSafeArrayAsInParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("HostClipboard ProvideData with pending request failed, hrc=%Rhrc\n", hrc));

        hrc = ptrHostClipboard->ProvideData(idRequest, ClipboardAction_Copy, ClipboardSource_Guest,
                                            bstrGuestReadMimeType.raw(), ComSafeArrayAsInParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ERROR,
                          ("HostClipboard ProvideData with consumed request ID returned hrc=%Rhrc\n", hrc));

        if (ptrListener.isNotNull())
            pEventSource->UnregisterListener(ptrListener);
        fListenerRegistered = false;
        ptrListener.setNull();

        /* Ensure data supplied for the pending request became the guest-owned clipboard content. */
        ClipboardSource_T enmProvidedReadSource = ClipboardSource_Custom;
        Bstr bstrProvidedRequestedMimeType("");
        Bstr bstrProvidedReadMimeType;
        SafeArray<BYTE> aProvidedReadBuffer;
        hrc = pClipboard->ReadDataRaw(ClipboardAction_Copy, bstrProvidedRequestedMimeType.raw(), &enmProvidedReadSource,
                                      bstrProvidedReadMimeType.asOutParam(), ComSafeArrayAsOutParam(aProvidedReadBuffer));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadDataRaw after HostClipboard ProvideData failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmProvidedReadSource == ClipboardSource_Guest);
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrProvidedReadMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aProvidedReadBuffer, abRoundTripBuffer),
                          ("ReadDataRaw after HostClipboard ProvideData returned %zu bytes, expected %zu\n",
                           aProvidedReadBuffer.size(), abRoundTripBuffer.size()));

        /* Seed host-owned Main state before lazy guest publication. */
        static const char s_szHostStateText[] = "tstClipboard host state preserved across IHostClipboard";
        std::vector<BYTE> abHostStateData = tstBytesFromString(s_szHostStateText);
        SafeArray<BYTE> aHostStateData;
        hrc = tstSafeArrayFromBytes(abHostStateData, aHostStateData);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("SafeArray initFrom(host state data) failed, hrc=%Rhrc\n", hrc));

        ClipboardSource_T enmHostStateWrittenSource = ClipboardSource_Custom;
        Bstr bstrHostStateWrittenMimeType;
        SafeArray<BYTE> aHostStateWrittenBuffer;
        hrc = pClipboard->WriteDataRaw(ClipboardAction_Copy, ClipboardSource_Host, bstrGuestReadMimeType.raw(),
                                       ComSafeArrayAsInParam(aHostStateData), &enmHostStateWrittenSource,
                                       bstrHostStateWrittenMimeType.asOutParam(),
                                       ComSafeArrayAsOutParam(aHostStateWrittenBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("WriteDataRaw(host state before IHostClipboard) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmHostStateWrittenSource == ClipboardSource_Host);
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aHostStateWrittenBuffer, abHostStateData),
                          ("WriteDataRaw(host state before IHostClipboard) returned %zu bytes, expected %zu\n",
                           aHostStateWrittenBuffer.size(), abHostStateData.size()));
        Utf8Str strHostStateMimeType(bstrHostStateWrittenMimeType);
        tstReadDataRawEquals(pClipboard, "host state before IHostClipboard publication", ClipboardSource_Host,
                             strHostStateMimeType.c_str(), abHostStateData);

        hrc = ptrHostClipboard->ReportFormats(ClipboardAction_Copy, ClipboardSource_Guest,
                                              ComSafeArrayAsInParam(aHostGuestTextFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("HostClipboard ReportFormats(guest) over host state failed, hrc=%Rhrc\n", hrc));

        hrc = pEventSource->CreateListener(ptrListener.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateListener(lazy host request) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrListener.isNull());
        hrc = pEventSource->RegisterListener(ptrListener, ComSafeArrayAsInParam(aRequestEventTypes), FALSE /* aActive */);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("RegisterListener(lazy host request) failed, hrc=%Rhrc\n", hrc));
        fListenerRegistered = SUCCEEDED(hrc);

        ULONG idLazyRequest = 0;
        hrc = ptrInternalClipboardControl->RequestData(bstrGuestReadMimeType.raw(), &idLazyRequest);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("IInternalClipboardControl::RequestData after HostClipboard ReportFormats failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG(idLazyRequest != 0, ("IInternalClipboardControl::RequestData after HostClipboard ReportFormats returned zero request ID\n"));

        ComPtr<IEvent> ptrLazyRequestEvent;
        hrc = pEventSource->GetEvent(ptrListener, 1000 /* aTimeout */, ptrLazyRequestEvent.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("GetEvent(lazy host request) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG_BREAK(!ptrLazyRequestEvent.isNull(), ("GetEvent(lazy host request) returned no event\n"));

        VBoxEventType_T enmLazyRequestEventType = VBoxEventType_Invalid;
        hrc = ptrLazyRequestEvent->COMGETTER(Type)(&enmLazyRequestEventType);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Type)(lazy host request) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG(enmLazyRequestEventType == VBoxEventType_OnClipboardDataRequested,
                          ("GetEvent(lazy host request) returned type %d, expected %d\n",
                           enmLazyRequestEventType, VBoxEventType_OnClipboardDataRequested));

        ComPtr<IClipboardDataRequestedEvent> ptrLazyDataRequestedEvent = ptrLazyRequestEvent;
        RTTESTI_CHECK(!ptrLazyDataRequestedEvent.isNull());
        if (ptrLazyDataRequestedEvent.isNotNull())
        {
            ULONG idLazyEventRequest = 0;
            hrc = ptrLazyDataRequestedEvent->COMGETTER(RequestId)(&idLazyEventRequest);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(RequestId)(lazy host request) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK_MSG(idLazyEventRequest == idLazyRequest,
                              ("Lazy request event ID %RU32, expected %RU32\n",
                               (uint32_t)idLazyEventRequest, (uint32_t)idLazyRequest));

            ClipboardAction_T enmLazyRequestAction = ClipboardAction_Custom;
            hrc = ptrLazyDataRequestedEvent->COMGETTER(Action)(&enmLazyRequestAction);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Action)(lazy host request) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(enmLazyRequestAction == ClipboardAction_Copy);

            ClipboardSource_T enmLazyRequestSource = ClipboardSource_Custom;
            hrc = ptrLazyDataRequestedEvent->COMGETTER(ClipboardSource)(&enmLazyRequestSource);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(ClipboardSource)(lazy host request) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(enmLazyRequestSource == ClipboardSource_Guest);

            ComPtr<IClipboardFormat> ptrLazyRequestFormat;
            hrc = ptrLazyDataRequestedEvent->COMGETTER(Format)(ptrLazyRequestFormat.asOutParam());
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Format)(lazy host request) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(!ptrLazyRequestFormat.isNull());
            if (ptrLazyRequestFormat.isNotNull())
            {
                Bstr bstrLazyRequestMimeType;
                hrc = ptrLazyRequestFormat->COMGETTER(MimeType)(bstrLazyRequestMimeType.asOutParam());
                RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType)(lazy host request format) failed, hrc=%Rhrc\n", hrc));
                RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrLazyRequestMimeType).c_str(), "text/plain;charset=utf-8"));
            }
        }

        hrc = ptrHostClipboard->ProvideData(idLazyRequest, ClipboardAction_Copy, ClipboardSource_Guest,
                                            bstrGuestReadMimeType.raw(), ComSafeArrayAsInParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("HostClipboard ProvideData for lazy host request failed, hrc=%Rhrc\n", hrc));

        if (ptrListener.isNotNull())
            pEventSource->UnregisterListener(ptrListener);
        fListenerRegistered = false;
        ptrListener.setNull();

        tstReadDataRawEquals(pClipboard, "IHostClipboard ReportFormats lazy guest data over host state", ClipboardSource_Guest,
                             "text/plain;charset=utf-8", abRoundTripBuffer);

        /* Reseed host-owned Main state before verifying SetData does not replace it. */
        aHostStateWrittenBuffer.setNull();
        hrc = pClipboard->WriteDataRaw(ClipboardAction_Copy, ClipboardSource_Host, bstrGuestReadMimeType.raw(),
                                       ComSafeArrayAsInParam(aHostStateData), &enmHostStateWrittenSource,
                                       bstrHostStateWrittenMimeType.asOutParam(),
                                       ComSafeArrayAsOutParam(aHostStateWrittenBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("WriteDataRaw(host state after lazy IHostClipboard) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmHostStateWrittenSource == ClipboardSource_Host);
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aHostStateWrittenBuffer, abHostStateData),
                          ("WriteDataRaw(host state after lazy IHostClipboard) returned %zu bytes, expected %zu\n",
                           aHostStateWrittenBuffer.size(), abHostStateData.size()));
        tstReadDataRawEquals(pClipboard, "host state after lazy IHostClipboard publication", ClipboardSource_Host,
                             strHostStateMimeType.c_str(), abHostStateData);

        RTTestSub(hTest, "IHostClipboard SetData preserves Main state");
        /* Verify deterministic SetData payloads do not overwrite host-owned Main state. */
        struct TSTHOSTCLIPBOARDSETDATA
        {
            const char *pszMimeType;
            const char *pszData;
            const char *pszWhat;
        };
        static const TSTHOSTCLIPBOARDSETDATA s_aHostClipboardSetData[] =
        {
            { "text/plain;charset=utf-8", "tstClipboard IHostClipboard text publish #1\n", "text/plain #1" },
            { "text/html", "<html><body><p>tstClipboard IHostClipboard html publish</p></body></html>", "text/html" },
            { "text/plain;charset=utf-8", "tstClipboard IHostClipboard text publish #2\n", "text/plain #2" }
        };

        bool fHaveLastHostClipboardSetData = false;
        const char *pszLastHostClipboardMimeType = NULL;
        std::vector<BYTE> abLastHostClipboardData;
        for (unsigned i = 0; i < RT_ELEMENTS(s_aHostClipboardSetData); i++)
        {
            std::vector<BYTE> abSetData = tstBytesFromString(s_aHostClipboardSetData[i].pszData);
            char szWhat[128];
            RTStrPrintf(szWhat, sizeof(szWhat), "IHostClipboard SetData %s", s_aHostClipboardSetData[i].pszWhat);
            if (tstHostClipboardSetDataAndKeepReadBack(pClipboard, ptrHostClipboard, s_aHostClipboardSetData[i].pszMimeType,
                                                       abSetData, ClipboardSource_Host, strHostStateMimeType.c_str(),
                                                       abHostStateData, 3 /* cReads */, szWhat))
            {
                fHaveLastHostClipboardSetData = true;
                pszLastHostClipboardMimeType = s_aHostClipboardSetData[i].pszMimeType;
                abLastHostClipboardData = abSetData;
            }
        }

        if (fHaveLastHostClipboardSetData)
        {
            SafeArray<BYTE> aLastHostClipboardData;
            hrc = tstSafeArrayFromBytes(abLastHostClipboardData, aLastHostClipboardData);
            RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("SafeArray initFrom(last host clipboard data) failed, hrc=%Rhrc\n", hrc));

            /* Verify SetData rejects wrong source, empty data, unsupported format, and disallowed mode. */
            hrc = ptrHostClipboard->SetData(ClipboardAction_Copy, ClipboardSource_Host, Bstr(pszLastHostClipboardMimeType).raw(),
                                            ComSafeArrayAsInParam(aLastHostClipboardData));
            RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ACCESS_DENIED,
                              ("HostClipboard SetData with host source returned hrc=%Rhrc\n", hrc));

            SafeArray<BYTE> aEmptyHostClipboardData;
            hrc = ptrHostClipboard->SetData(ClipboardAction_Copy, ClipboardSource_Guest, Bstr(pszLastHostClipboardMimeType).raw(),
                                            ComSafeArrayAsInParam(aEmptyHostClipboardData));
            RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_NO_DATA,
                              ("HostClipboard SetData with empty data returned hrc=%Rhrc\n", hrc));

            hrc = ptrHostClipboard->SetData(ClipboardAction_Copy, ClipboardSource_Guest, Bstr("application/octet-stream").raw(),
                                            ComSafeArrayAsInParam(aLastHostClipboardData));
            RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_FORMAT_NOT_SUPPORTED,
                              ("HostClipboard SetData with application/octet-stream returned hrc=%Rhrc\n", hrc));

            hrc = pClipboardSettings->COMSETTER(Mode)(ClipboardMode_HostToGuest);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc),
                              ("COMSETTER(Mode) HostToGuest before HostClipboard SetData denial failed, hrc=%Rhrc\n", hrc));
            if (SUCCEEDED(hrc))
            {
                hrc = ptrHostClipboard->SetData(ClipboardAction_Copy, ClipboardSource_Guest,
                                                Bstr(pszLastHostClipboardMimeType).raw(),
                                                ComSafeArrayAsInParam(aLastHostClipboardData));
                RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_ACCESS_DENIED,
                                  ("HostClipboard SetData in HostToGuest mode returned hrc=%Rhrc\n", hrc));

                hrc = pClipboardSettings->COMSETTER(Mode)(ClipboardMode_Bidirectional);
                RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc),
                                        ("COMSETTER(Mode) Bidirectional after HostClipboard SetData denial failed, "
                                         "hrc=%Rhrc\n", hrc));
            }

            /* Ensure rejection paths did not disturb the preserved host-owned Main payload. */
            tstReadDataRawEquals(pClipboard, "IHostClipboard SetData after failure cases", ClipboardSource_Host,
                                 strHostStateMimeType.c_str(), abHostStateData);
            tstHostClipboardTryNativeReadBack(hTest, pClipboard, pszLastHostClipboardMimeType, abLastHostClipboardData);
        }
    } while (0);

    if (fListenerRegistered && pEventSource && ptrListener.isNotNull())
        pEventSource->UnregisterListener(ptrListener);
    ptrListener.setNull();

    hrc = pClipboardSettings->COMSETTER(Mode)(ClipboardMode_Bidirectional);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(Mode) Bidirectional after IHostClipboard failed, hrc=%Rhrc\n", hrc));
}


/**
 * Configures Shared Clipboard logging to go to stdout.
 */
static void tstInitLogging(void)
{
    RTUINT fFlags = RTLOGFLAGS_PREFIX_THREAD | RTLOGFLAGS_PREFIX_TIME_PROG;
#if defined(RT_OS_WINDOWS) || defined(RT_OS_OS2)
    fFlags |= RTLOGFLAGS_USECRLF;
#endif
    static const char * const s_apszLogGroups[] = VBOX_LOGGROUP_NAMES;
    int vrc = RTLogCreate(&g_pLogger, fFlags, "all.e.l.f", "TST_CLIPBOARD_LOG",
                          RT_ELEMENTS(s_apszLogGroups), s_apszLogGroups, RTLOGDEST_STDOUT, NULL);
    if (RT_SUCCESS(vrc))
    {
        vrc = RTLogGroupSettings(g_pLogger, "main.e.l+shared_clipboard.e.l.l2.f");
        if (RT_SUCCESS(vrc))
            RTLogRelSetDefaultInstance(g_pLogger);
    }
    else
        RTMsgWarning("Failed to create shared clipboard logger: %Rrc", vrc);
}


/**
 * Logs COM error information for a testcase failure.
 *
 * @param   hTest           Test handle.
 * @param   pszWhat         Operation that failed.
 * @param   errorInfo       Error information to log.
 */
static void tstLogErrorInfo(RTTEST hTest, const char *pszWhat, const ErrorInfo &errorInfo)
{
    if (!errorInfo.isBasicAvailable())
    {
        RTTestPrintf(hTest, RTTESTLVL_ALWAYS, "%s: no error info available\n", pszWhat);
        return;
    }

    RTTestPrintf(hTest, RTTESTLVL_ALWAYS, "%s: hrc=%Rhrc, text='%ls'\n",
                 pszWhat, errorInfo.getResultCode(), errorInfo.getText().raw());
    if (errorInfo.getComponent().raw())
        RTTestPrintf(hTest, RTTESTLVL_ALWAYS, "%s: component='%ls'\n", pszWhat, errorInfo.getComponent().raw());
    if (errorInfo.getInterfaceName().raw())
        RTTestPrintf(hTest, RTTESTLVL_ALWAYS, "%s: interface='%ls'\n", pszWhat, errorInfo.getInterfaceName().raw());
}


/**
 * Waits for a temporary testcase machine to become unlocked before unregistering it.
 *
 * @returns COM status code from the last SessionState query.
 * @param   hTest           Test handle.
 * @param   pMachine        Machine to query.
 */
static HRESULT tstWaitMachineUnlocked(RTTEST hTest, IMachine *pMachine)
{
    AssertPtrReturn(pMachine, E_POINTER);

    HRESULT hrc = S_OK;
    SessionState_T enmSessionState = SessionState_Unlocked;
    for (uint32_t i = 0; i < 100; ++i)
    {
        hrc = pMachine->COMGETTER(SessionState)(&enmSessionState);
        if (FAILED(hrc))
            return hrc;
        if (enmSessionState == SessionState_Unlocked)
            return S_OK;
        RTThreadSleep(100);
    }

    RTTestPrintf(hTest, RTTESTLVL_ALWAYS, "Machine still not unlocked; SessionState=%d\n", enmSessionState);
    return VBOX_E_INVALID_OBJECT_STATE;
}


/**
 * Tests clipboard object factory methods and the returned public objects.
 *
 * @param   hTest           Test handle.
 * @param   pClipboard      Clipboard API object to use.
 */
static void tstClipboardPublicObjects(RTTEST hTest, IClipboard *pClipboard)
{
    RTTestSub(hTest, "Clipboard public objects");

    ComPtr<IClipboardFormat> ptrFormat;
    HRESULT hrc = tstCreateFormat(pClipboard, "text/plain;charset=utf-8", ptrFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("CreateFormat failed, hrc=%Rhrc\n", hrc));

    Bstr bstrMimeType;
    hrc = ptrFormat->COMGETTER(MimeType)(bstrMimeType.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardFormat::COMGETTER(MimeType) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrMimeType).c_str(), "text/plain;charset=utf-8"));

    hrc = ptrFormat->COMSETTER(MimeType)(Bstr("text/html").raw());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardFormat::COMSETTER(MimeType) failed, hrc=%Rhrc\n", hrc));
    bstrMimeType.setNull();
    hrc = ptrFormat->COMGETTER(MimeType)(bstrMimeType.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardFormat::COMGETTER(MimeType) after set failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrMimeType).c_str(), "text/html"));

    ComPtr<IClipboardFormat> ptrTextFormat;
    hrc = tstCreateFormat(pClipboard, "text/plain;charset=utf-8", ptrTextFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("CreateFormat(text) failed, hrc=%Rhrc\n", hrc));

    static const char s_szText[] = "Hello from the Main clipboard testcase";
    std::vector<BYTE> abText(sizeof(s_szText));
    memcpy(&abText[0], s_szText, sizeof(s_szText));

    ComPtr<IClipboardItem> ptrItem;
    hrc = tstCreateItem(pClipboard, ClipboardSource_Host, ptrTextFormat, abText, ptrItem);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("CreateItem failed, hrc=%Rhrc\n", hrc));

    ClipboardSource_T enmSource = ClipboardSource_Guest;
    hrc = ptrItem->COMGETTER(Source)(&enmSource);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Source) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(enmSource == ClipboardSource_Host);

    ComPtr<IClipboardFormat> ptrItemFormat;
    hrc = ptrItem->COMGETTER(Format)(ptrItemFormat.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Format) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!ptrItemFormat.isNull());
    if (ptrItemFormat.isNotNull())
    {
        Bstr bstrItemMimeType;
        hrc = ptrItemFormat->COMGETTER(MimeType)(bstrItemMimeType.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::Format::COMGETTER(MimeType) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrItemMimeType).c_str(), "text/plain;charset=utf-8"));
    }

    SafeArray<BYTE> aReadText;
    hrc = ptrItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(aReadText));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Buffer) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK_MSG(tstByteArrayEquals(aReadText, abText),
                      ("IClipboardItem::COMGETTER(Buffer) returned %zu bytes, expected %zu\n", aReadText.size(), abText.size()));

    ULONG cbItem = 0;
    hrc = ptrItem->COMGETTER(Size)(&cbItem);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Size) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(cbItem == sizeof(s_szText));

    ComPtr<IClipboardFormat> ptrHtmlFormat;
    hrc = tstCreateFormat(pClipboard, "text/html", ptrHtmlFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("CreateFormat(html) failed, hrc=%Rhrc\n", hrc));
    hrc = ptrItem->COMSETTER(Format)(ptrHtmlFormat);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMSETTER(Format) failed, hrc=%Rhrc\n", hrc));
    ptrItemFormat.setNull();
    hrc = ptrItem->COMGETTER(Format)(ptrItemFormat.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Format) after set failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!ptrItemFormat.isNull());
    if (ptrItemFormat.isNotNull())
    {
        Bstr bstrItemMimeType;
        hrc = ptrItemFormat->COMGETTER(MimeType)(bstrItemMimeType.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::Format::COMGETTER(MimeType) after set failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrItemMimeType).c_str(), "text/html"));
    }

    static const char s_szHtml[] = "<p>Hello from the Main clipboard testcase</p>";
    SafeArray<BYTE> aHtml;
    hrc = aHtml.initFrom(reinterpret_cast<const BYTE *>(s_szHtml), sizeof(s_szHtml));
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("SafeArray initFrom failed, hrc=%Rhrc\n", hrc));
    hrc = ptrItem->COMSETTER(Buffer)(ComSafeArrayAsInParam(aHtml));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMSETTER(Buffer) failed, hrc=%Rhrc\n", hrc));

    SafeArray<BYTE> aReadHtml;
    hrc = ptrItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(aReadHtml));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Buffer) after set failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(aReadHtml.size() == sizeof(s_szHtml));
    if (aReadHtml.size() == sizeof(s_szHtml))
        RTTESTI_CHECK(!memcmp(aReadHtml.raw(), s_szHtml, sizeof(s_szHtml)));

    hrc = ptrItem->COMGETTER(Size)(&cbItem);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IClipboardItem::COMGETTER(Size) after set failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(cbItem == sizeof(s_szHtml));
}


/**
 * Tests the public console clipboard API.
 *
 * @param   hTest           Test handle.
 */
static void tstClipboardPublicApi(RTTEST hTest)
{
    RTTestSub(hTest, "Clipboard public API");

    HRESULT hrc = S_OK;
    bool fMachineRegistered = false;
    bool fMachineLocked = false;
    bool fListenerRegistered = false;
    ComPtr<IVirtualBoxClient> ptrVirtualBoxClient;
    ComPtr<IVirtualBox> ptrVirtualBox;
    ComPtr<ISession> ptrSession;
    ComPtr<IMachine> ptrMachine;
    ComPtr<IConsole> ptrConsole;
    ComPtr<IClipboard> ptrClipboard;
    ComPtr<IEventSource> ptrEventSource;
    ComPtr<IEventListener> ptrListener;

    do
    {
        /* Create the frontend objects and a throwaway VM used for live console clipboard testing. */
        hrc = ptrVirtualBoxClient.createInprocObject(CLSID_VirtualBoxClient);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("createInprocObject(CLSID_VirtualBoxClient) failed, hrc=%Rhrc\n", hrc));
        hrc = ptrVirtualBoxClient->COMGETTER(VirtualBox)(ptrVirtualBox.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(VirtualBox) failed, hrc=%Rhrc\n", hrc));

        ComPtr<IHost> ptrHost;
        hrc = ptrVirtualBox->COMGETTER(Host)(ptrHost.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(Host) failed, hrc=%Rhrc\n", hrc));
        PlatformArchitecture_T enmPlatformArch = PlatformArchitecture_x86;
        hrc = ptrHost->COMGETTER(Architecture)(&enmPlatformArch);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(Architecture) failed, hrc=%Rhrc\n", hrc));

        RTUUID uuid;
        int vrc = RTUuidCreate(&uuid);
        RTTESTI_CHECK_RC_BREAK(vrc, VINF_SUCCESS);
        char szMachineName[64];
        RTStrPrintf(szMachineName, sizeof(szMachineName), "tstClipboard-%RTuuid", &uuid);

        SafeArray<BSTR> aGroups;
        hrc = ptrVirtualBox->CreateMachine(NULL,                          /* Settings file */
                                           Bstr(szMachineName).raw(),      /* Name */
                                           enmPlatformArch,
                                           ComSafeArrayAsInParam(aGroups), /* Groups */
                                           NULL,                          /* OS type */
                                           NULL,                          /* Flags */
                                           NULL,                          /* Cipher */
                                           NULL,                          /* Password ID */
                                           NULL,                          /* Password */
                                           ptrMachine.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateMachine failed, hrc=%Rhrc\n", hrc));

        /* Verify default clipboard settings before enabling the directions this testcase exercises. */
        ComPtr<IClipboardSettings> ptrClipboardSettings;
        hrc = ptrMachine->COMGETTER(Clipboard)(ptrClipboardSettings.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(IMachine::Clipboard) failed, hrc=%Rhrc\n", hrc));

        ClipboardMode_T enmInitialMode = ClipboardMode_Bidirectional;
        hrc = ptrClipboardSettings->COMGETTER(Mode)(&enmInitialMode);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(IClipboardSettings::Mode) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmInitialMode == ClipboardMode_Disabled);

        BOOL fFileTransfersEnabled = TRUE;
        hrc = ptrClipboardSettings->COMGETTER(FileTransfersEnabled)(&fFileTransfersEnabled);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(IClipboardSettings::FileTransfersEnabled) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!fFileTransfersEnabled);

        hrc = ptrClipboardSettings->COMSETTER(Mode)(ClipboardMode_Bidirectional);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMSETTER(Mode) failed, hrc=%Rhrc\n", hrc));
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        hrc = ptrClipboardSettings->COMSETTER(FileTransfersEnabled)(TRUE);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMSETTER(FileTransfersEnabled) failed, hrc=%Rhrc\n", hrc));
#endif

        /* Register and launch the VM so the console-scoped clipboard service is available. */
        hrc = ptrVirtualBox->RegisterMachine(ptrMachine);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("RegisterMachine failed, hrc=%Rhrc\n", hrc));
        fMachineRegistered = true;

        hrc = ptrSession.createInprocObject(CLSID_Session);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("createInprocObject(CLSID_Session) failed, hrc=%Rhrc\n", hrc));

        ComPtr<IProgress> ptrLaunchProgress;
        hrc = ptrMachine->LaunchVMProcess(ptrSession, Bstr("headless").raw(),
                                          ComSafeArrayNullInParam(), ptrLaunchProgress.asOutParam());
        if (FAILED(hrc))
        {
            tstLogErrorInfo(hTest, "LaunchVMProcess", ErrorInfo(ptrMachine, COM_IIDOF(IMachine)));
            RTTestSkipped(hTest, "LaunchVMProcess failed, hrc=%Rhrc", hrc);
            break;
        }
        RTTESTI_CHECK_MSG_BREAK(!ptrLaunchProgress.isNull(), ("LaunchVMProcess returned no progress object\n"));
        hrc = ptrLaunchProgress->WaitForCompletion(-1);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("WaitForCompletion(LaunchVMProcess) failed, hrc=%Rhrc\n", hrc));
        LONG lrcLaunchResult = S_OK;
        hrc = ptrLaunchProgress->COMGETTER(ResultCode)(&lrcLaunchResult);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(ResultCode) failed, hrc=%Rhrc\n", hrc));
        if (FAILED((HRESULT)lrcLaunchResult))
        {
            tstLogErrorInfo(hTest, "LaunchVMProcess progress", ProgressErrorInfo(ptrLaunchProgress));
            RTTestSkipped(hTest, "LaunchVMProcess result code is %Rhrc", lrcLaunchResult);
            break;
        }
        fMachineLocked = true;

        /* Resolve the live console and clipboard objects under test. */
        hrc = ptrSession->COMGETTER(Console)(ptrConsole.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(Console) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK_MSG_BREAK(!ptrConsole.isNull(), ("COMGETTER(Console) returned NULL\n"));

        ComPtr<IMachine> ptrSessionMachine;
        hrc = ptrSession->COMGETTER(Machine)(ptrSessionMachine.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(Machine) failed, hrc=%Rhrc\n", hrc));
        hrc = ptrSessionMachine->COMGETTER(Clipboard)(ptrClipboardSettings.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(IInternalSession::Machine::Clipboard) failed, hrc=%Rhrc\n", hrc));

        hrc = ptrConsole->COMGETTER(Clipboard)(ptrClipboard.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(Clipboard) failed, hrc=%Rhrc\n", hrc));

        /* Verify object construction helpers before exercising live clipboard state. */
        tstClipboardPublicObjects(hTest, ptrClipboard);
        RTTestSub(hTest, "Clipboard public API operations");

        /* Verify file-list storage and the auxiliary transfer/event-source getters. */
        SafeArray<BSTR> aFileList;
        hrc = ptrClipboard->COMGETTER(FileList)(ComSafeArrayAsOutParam(aFileList));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileList) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aFileList.size() == 0);

        SafeArray<IN_BSTR> aNewFileList;
        RTTESTI_CHECK(aNewFileList.push_back(Bstr("/tmp/tstClipboard-1").raw()));
        RTTESTI_CHECK(aNewFileList.push_back(Bstr("/tmp/tstClipboard-2").raw()));
        hrc = ptrClipboard->COMSETTER(FileList)(ComSafeArrayAsInParam(aNewFileList));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(FileList) failed, hrc=%Rhrc\n", hrc));
        aFileList.setNull();
        hrc = ptrClipboard->COMGETTER(FileList)(ComSafeArrayAsOutParam(aFileList));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileList) after set failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aFileList.size() == 2);
        if (aFileList.size() == 2)
        {
            RTTESTI_CHECK(!RTUtf16Cmp(aFileList[0], Bstr("/tmp/tstClipboard-1").raw()));
            RTTESTI_CHECK(!RTUtf16Cmp(aFileList[1], Bstr("/tmp/tstClipboard-2").raw()));
        }

        ComPtr<IClipboardTransferManager> ptrTransfers;
        hrc = ptrClipboard->COMGETTER(Transfers)(ptrTransfers.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Transfers) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrTransfers.isNull());

        hrc = ptrClipboard->COMGETTER(EventSource)(ptrEventSource.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(EventSource) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrEventSource.isNull());

        /* Register a broad passive listener for mode changes and explicit host-origin writes. */
        hrc = ptrEventSource->CreateListener(ptrListener.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("CreateListener failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrListener.isNull());
        SafeArray<VBoxEventType_T> aEventTypes;
        aEventTypes.push_back(VBoxEventType_OnClipboardModeChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardSourceChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardFormatChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardDataChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardDataRequested);
        hrc = ptrEventSource->RegisterListener(ptrListener, ComSafeArrayAsInParam(aEventTypes), FALSE /* aActive */);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("RegisterListener failed, hrc=%Rhrc\n", hrc));
        fListenerRegistered = SUCCEEDED(hrc);

        /* Check mode-change events before any data writes alter clipboard ownership. */
        hrc = ptrClipboardSettings->COMSETTER(Mode)(ClipboardMode_HostToGuest);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(Mode) live change failed, hrc=%Rhrc\n", hrc));
        if (SUCCEEDED(hrc))
        {
            ComPtr<IEvent> ptrEvent;
            hrc = ptrEventSource->GetEvent(ptrListener, 1000 /* aTimeout */, ptrEvent.asOutParam());
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("GetEvent(mode) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK_MSG(!ptrEvent.isNull(), ("GetEvent(mode) returned no event\n"));
            if (ptrEvent.isNotNull())
            {
                VBoxEventType_T enmType = VBoxEventType_Invalid;
                hrc = ptrEvent->COMGETTER(Type)(&enmType);
                RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Type)(mode) failed, hrc=%Rhrc\n", hrc));
                RTTESTI_CHECK_MSG(enmType == VBoxEventType_OnClipboardModeChanged,
                                  ("GetEvent(mode) returned type %d, expected %d\n",
                                   enmType, VBoxEventType_OnClipboardModeChanged));

                ComPtr<IClipboardModeChangedEvent> ptrModeEvent = ptrEvent;
                RTTESTI_CHECK(!ptrModeEvent.isNull());
                if (ptrModeEvent.isNotNull())
                {
                    ClipboardMode_T enmMode = ClipboardMode_Disabled;
                    hrc = ptrModeEvent->COMGETTER(ClipboardMode)(&enmMode);
                    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(ClipboardMode) failed, hrc=%Rhrc\n", hrc));
                    RTTESTI_CHECK_MSG(enmMode == ClipboardMode_HostToGuest,
                                      ("GetEvent(mode) returned mode %d, expected %d\n",
                                       enmMode, ClipboardMode_HostToGuest));
                }
            }
        }

        /* Verify the initial live clipboard has no formats, data, or queued data events. */
        SafeIfaceArray<IClipboardFormat> aReadFormats;
        hrc = ptrClipboard->ReadFormats(ComSafeArrayAsOutParam(aReadFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadFormats failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aReadFormats.size() == 0);

        ComPtr<IClipboardFormat> ptrTextFormat;
        hrc = tstCreateFormat(ptrClipboard, "text/plain;charset=utf-8", ptrTextFormat);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateFormat(text) failed, hrc=%Rhrc\n", hrc));

        BOOL fAvailable = TRUE;
        hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrTextFormat, &fAvailable);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IsFormatAvailable failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!fAvailable);

        SafeIfaceArray<IClipboardFormat> aSupportedFormats;
        hrc = ptrClipboard->GetSupportedFormats(ClipboardSource_Host, ComSafeArrayAsOutParam(aSupportedFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("GetSupportedFormats failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aSupportedFormats.size() == 0);

        ComPtr<IClipboardItem> ptrReadItem;
        hrc = ptrClipboard->ReadData(ClipboardAction_Copy, ptrReadItem.asOutParam());
        RTTESTI_CHECK_MSG(FAILED(hrc), ("ReadData without available formats unexpectedly succeeded\n"));

        ComPtr<IEvent> ptrUnexpectedEvent;
        hrc = ptrEventSource->GetEvent(ptrListener, 0 /* aTimeout */, ptrUnexpectedEvent.asOutParam());
        RTTESTI_CHECK_MSG(   hrc == VBOX_E_OBJECT_NOT_FOUND
                          || ptrUnexpectedEvent.isNull(),
                          ("Unexpected clipboard event before explicit API write, hrc=%Rhrc\n", hrc));

        /* Exercise validation failures for empty payloads and unsupported MIME types. */
        std::vector<BYTE> abBuffer;
        ComPtr<IClipboardItem> ptrEmptyItem;
        hrc = tstCreateItem(ptrClipboard, ClipboardSource_Host, ptrTextFormat, abBuffer, ptrEmptyItem);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateItem(empty) failed, hrc=%Rhrc\n", hrc));
        ComPtr<IClipboardItem> ptrWrittenItem;
        hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrEmptyItem, ptrWrittenItem.asOutParam());
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_NO_DATA, ("WriteData with empty buffer returned hrc=%Rhrc\n", hrc));

        ComPtr<IClipboardFormat> ptrUnsupportedFormat;
        hrc = tstCreateFormat(ptrClipboard, "application/x-unsupported", ptrUnsupportedFormat);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateFormat(unsupported) failed, hrc=%Rhrc\n", hrc));
        abBuffer.push_back('x');
        ComPtr<IClipboardItem> ptrUnsupportedItem;
        hrc = tstCreateItem(ptrClipboard, ClipboardSource_Host, ptrUnsupportedFormat, abBuffer, ptrUnsupportedItem);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateItem(unsupported) failed, hrc=%Rhrc\n", hrc));
        ptrWrittenItem.setNull();
        hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrUnsupportedItem, ptrWrittenItem.asOutParam());
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_FORMAT_NOT_SUPPORTED,
                          ("WriteData with unsupported MIME type returned hrc=%Rhrc\n", hrc));

        /* Write host-origin data and verify the expected source/format/data events. */
        static const char s_szRoundTripText[] = "tstClipboard host to guest round-trip data";
        std::vector<BYTE> abRoundTripBuffer(sizeof(s_szRoundTripText));
        memcpy(&abRoundTripBuffer[0], s_szRoundTripText, sizeof(s_szRoundTripText));

        ComPtr<IClipboardItem> ptrTextItem;
        hrc = tstCreateItem(ptrClipboard, ClipboardSource_Host, ptrTextFormat, abRoundTripBuffer, ptrTextItem);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("CreateItem(text) failed, hrc=%Rhrc\n", hrc));
        ptrWrittenItem.setNull();
        hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrTextItem, ptrWrittenItem.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("WriteData failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrWrittenItem.isNull());

        static VBoxEventType_T const s_aExpectedEvents[] =
        {
            VBoxEventType_OnClipboardSourceChanged,
            VBoxEventType_OnClipboardFormatChanged,
            VBoxEventType_OnClipboardDataChanged
        };
        for (size_t i = 0; i < RT_ELEMENTS(s_aExpectedEvents); i++)
        {
            ComPtr<IEvent> ptrEvent;
            hrc = ptrEventSource->GetEvent(ptrListener, 1000 /* aTimeout */, ptrEvent.asOutParam());
            RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("GetEvent[%zu] failed, hrc=%Rhrc\n", i, hrc));
            RTTESTI_CHECK_MSG_BREAK(!ptrEvent.isNull(), ("GetEvent[%zu] returned no event\n", i));

            VBoxEventType_T enmType = VBoxEventType_Invalid;
            hrc = ptrEvent->COMGETTER(Type)(&enmType);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Type)[%zu] failed, hrc=%Rhrc\n", i, hrc));
            RTTESTI_CHECK_MSG(enmType == s_aExpectedEvents[i],
                              ("GetEvent[%zu] returned type %d, expected %d\n", i, enmType, s_aExpectedEvents[i]));
            RTTESTI_CHECK_MSG(enmType != VBoxEventType_OnClipboardDataRequested,
                              ("Explicit API write unexpectedly emitted OnClipboardDataRequested\n"));
            if (enmType == VBoxEventType_OnClipboardFormatChanged)
            {
                ComPtr<IClipboardFormatChangedEvent> ptrFormatEvent = ptrEvent;
                RTTESTI_CHECK(!ptrFormatEvent.isNull());
                if (ptrFormatEvent.isNotNull())
                {
                    ClipboardSource_T enmSource = ClipboardSource_Custom;
                    hrc = ptrFormatEvent->COMGETTER(ClipboardSource)(&enmSource);
                    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(ClipboardSource)(format event) failed, hrc=%Rhrc\n", hrc));
                    RTTESTI_CHECK_MSG(enmSource == ClipboardSource_Host,
                                      ("Format event source %d, expected %d\n", enmSource, ClipboardSource_Host));

                    SafeIfaceArray<IClipboardFormat> aEventFormats;
                    hrc = ptrFormatEvent->COMGETTER(Formats)(ComSafeArrayAsOutParam(aEventFormats));
                    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Formats)(format event) failed, hrc=%Rhrc\n", hrc));
                    RTTESTI_CHECK_MSG(aEventFormats.size() == 1,
                                      ("Format event returned %zu formats, expected 1\n", aEventFormats.size()));
                    if (aEventFormats.size() == 1)
                    {
                        Bstr bstrEventMimeType;
                        hrc = aEventFormats[0]->COMGETTER(MimeType)(bstrEventMimeType.asOutParam());
                        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType)(format event) failed, hrc=%Rhrc\n", hrc));
                        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrEventMimeType).c_str(), "text/plain;charset=utf-8"));
                    }
                }
            }
        }

        ComPtr<IEvent> ptrUnexpectedAfterWrite;
        hrc = ptrEventSource->GetEvent(ptrListener, 0 /* aTimeout */, ptrUnexpectedAfterWrite.asOutParam());
        RTTESTI_CHECK_MSG(   hrc == VBOX_E_OBJECT_NOT_FOUND
                          || ptrUnexpectedAfterWrite.isNull(),
                          ("Unexpected clipboard event after explicit API write, hrc=%Rhrc\n", hrc));
        if (ptrUnexpectedAfterWrite.isNotNull())
        {
            BOOL fWaitable = FALSE;
            hrc = ptrUnexpectedAfterWrite->COMGETTER(Waitable)(&fWaitable);
            if (SUCCEEDED(hrc) && fWaitable)
                ptrEventSource->EventProcessed(ptrListener, ptrUnexpectedAfterWrite);
        }

        if (ptrListener.isNotNull())
            ptrEventSource->UnregisterListener(ptrListener);
        fListenerRegistered = false;
        ptrListener.setNull();

        /* Confirm the host-origin write is visible through query and raw read APIs. */
        aReadFormats.setNull();
        hrc = ptrClipboard->ReadFormats(ComSafeArrayAsOutParam(aReadFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadFormats after WriteData failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aReadFormats.size() == 1);

        fAvailable = FALSE;
        hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrTextFormat, &fAvailable);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IsFormatAvailable after WriteData failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(fAvailable);

        aSupportedFormats.setNull();
        hrc = ptrClipboard->GetSupportedFormats(ClipboardSource_Host, ComSafeArrayAsOutParam(aSupportedFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("GetSupportedFormats after WriteData failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aSupportedFormats.size() == 1);

        ClipboardSource_T enmGuestReadSource = ClipboardSource_Custom;
        Bstr bstrGuestRequestedMimeType("");
        Bstr bstrGuestReadMimeType;
        SafeArray<BYTE> aGuestReadBuffer;
        hrc = ptrClipboard->ReadDataRaw(ClipboardAction_Copy, bstrGuestRequestedMimeType.raw(), &enmGuestReadSource,
                                        bstrGuestReadMimeType.asOutParam(), ComSafeArrayAsOutParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("ReadDataRaw(host -> guest) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmGuestReadSource == ClipboardSource_Host);
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrGuestReadMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aGuestReadBuffer, abRoundTripBuffer),
                          ("ReadDataRaw(host -> guest) returned %zu bytes, expected %zu\n",
                           aGuestReadBuffer.size(), abRoundTripBuffer.size()));

        ClipboardSource_T enmTextPlainReadSource = ClipboardSource_Custom;
        Bstr bstrTextPlainRequestedMimeType("text/plain");
        Bstr bstrTextPlainReadMimeType;
        SafeArray<BYTE> aTextPlainReadBuffer;
        hrc = ptrClipboard->ReadDataRaw(ClipboardAction_Copy, bstrTextPlainRequestedMimeType.raw(), &enmTextPlainReadSource,
                                        bstrTextPlainReadMimeType.asOutParam(), ComSafeArrayAsOutParam(aTextPlainReadBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("ReadDataRaw(text/plain, host -> guest) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmTextPlainReadSource == ClipboardSource_Host);
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrTextPlainReadMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aTextPlainReadBuffer, abRoundTripBuffer),
                          ("ReadDataRaw(text/plain, host -> guest) returned %zu bytes, expected %zu\n",
                           aTextPlainReadBuffer.size(), abRoundTripBuffer.size()));

        /* Switch to bidirectional mode and verify raw guest-origin writes. */
        hrc = ptrClipboardSettings->COMSETTER(Mode)(ClipboardMode_Bidirectional);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc),
                                ("COMSETTER(Mode) bidirectional before guest write failed, hrc=%Rhrc\n", hrc));

        ClipboardSource_T enmWrittenSource = ClipboardSource_Custom;
        Bstr bstrWrittenMimeType;
        SafeArray<BYTE> aWrittenBuffer;
        hrc = ptrClipboard->WriteDataRaw(ClipboardAction_Copy, ClipboardSource_Guest, bstrGuestReadMimeType.raw(),
                                        ComSafeArrayAsInParam(aGuestReadBuffer), &enmWrittenSource,
                                        bstrWrittenMimeType.asOutParam(), ComSafeArrayAsOutParam(aWrittenBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("WriteDataRaw(guest -> host) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmWrittenSource == ClipboardSource_Guest);
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrWrittenMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aWrittenBuffer, abRoundTripBuffer),
                          ("WriteDataRaw(guest -> host) returned %zu bytes, expected %zu\n",
                           aWrittenBuffer.size(), abRoundTripBuffer.size()));

        enmTextPlainReadSource = ClipboardSource_Custom;
        bstrTextPlainReadMimeType.setNull();
        aTextPlainReadBuffer.setNull();
        hrc = ptrClipboard->ReadDataRaw(ClipboardAction_Copy, bstrTextPlainRequestedMimeType.raw(), &enmTextPlainReadSource,
                                        bstrTextPlainReadMimeType.asOutParam(), ComSafeArrayAsOutParam(aTextPlainReadBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("ReadDataRaw(text/plain, guest -> host) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmTextPlainReadSource == ClipboardSource_Guest);
        RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrTextPlainReadMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aTextPlainReadBuffer, abRoundTripBuffer),
                          ("ReadDataRaw(text/plain, guest -> host) returned %zu bytes, expected %zu\n",
                           aTextPlainReadBuffer.size(), abRoundTripBuffer.size()));

        /* Verify the object read API sees the same guest-origin payload. */
        ptrReadItem.setNull();
        hrc = ptrClipboard->ReadData(ClipboardAction_Copy, ptrReadItem.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("ReadData after guest write failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrReadItem.isNull());
        if (ptrReadItem.isNotNull())
        {
            ClipboardSource_T enmRoundTripSource = ClipboardSource_Custom;
            hrc = ptrReadItem->COMGETTER(Source)(&enmRoundTripSource);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Source)(round-trip) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(enmRoundTripSource == ClipboardSource_Guest);

            ComPtr<IClipboardFormat> ptrRoundTripFormat;
            hrc = ptrReadItem->COMGETTER(Format)(ptrRoundTripFormat.asOutParam());
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Format)(round-trip) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK(!ptrRoundTripFormat.isNull());
            if (ptrRoundTripFormat.isNotNull())
            {
                Bstr bstrRoundTripMimeType;
                hrc = ptrRoundTripFormat->COMGETTER(MimeType)(bstrRoundTripMimeType.asOutParam());
                RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType)(round-trip) failed, hrc=%Rhrc\n", hrc));
                RTTESTI_CHECK(!RTStrCmp(Utf8Str(bstrRoundTripMimeType).c_str(), "text/plain;charset=utf-8"));
            }

            SafeArray<BYTE> aRoundTripBuffer;
            hrc = ptrReadItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(aRoundTripBuffer));
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Buffer)(round-trip) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK_MSG(tstByteArrayEquals(aRoundTripBuffer, abRoundTripBuffer),
                              ("ReadData(round-trip) returned %zu bytes, expected %zu\n",
                               aRoundTripBuffer.size(), abRoundTripBuffer.size()));
        }

        /* Exercise the explicit IHostClipboard endpoint after normal IClipboard paths are known-good. */
        tstHostClipboard(hTest, ptrClipboard, ptrClipboardSettings, ptrEventSource, ptrTextFormat,
                         bstrGuestReadMimeType, aGuestReadBuffer, abRoundTripBuffer);

        /* Verify unsupported format offers fail before checking repeat format notifications. */
        std::vector<ComPtr<IClipboardFormat> > vecFormats;
        vecFormats.push_back(ptrTextFormat);
        vecFormats.push_back(ptrUnsupportedFormat);
        SafeIfaceArray<IClipboardFormat> aWriteFormats(vecFormats);
        hrc = ptrClipboard->WriteFormats(ComSafeArrayAsInParam(aWriteFormats));
        RTTESTI_CHECK_MSG(hrc == VBOX_E_SHCL_FORMAT_NOT_SUPPORTED,
                          ("WriteFormats with unsupported MIME type returned hrc=%Rhrc\n", hrc));

        /* Listen only for format changes to prove repeated offers still notify observers. */
        hrc = ptrEventSource->CreateListener(ptrListener.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("CreateListener(format) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrListener.isNull());
        SafeArray<VBoxEventType_T> aFormatEventTypes;
        aFormatEventTypes.push_back(VBoxEventType_OnClipboardFormatChanged);
        hrc = ptrEventSource->RegisterListener(ptrListener, ComSafeArrayAsInParam(aFormatEventTypes), FALSE /* aActive */);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("RegisterListener(format) failed, hrc=%Rhrc\n", hrc));
        fListenerRegistered = SUCCEEDED(hrc);

        vecFormats.clear();
        vecFormats.push_back(ptrTextFormat);
        SafeIfaceArray<IClipboardFormat> aWriteTextFormats(vecFormats);
        hrc = ptrClipboard->WriteFormats(ComSafeArrayAsInParam(aWriteTextFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("WriteFormats failed, hrc=%Rhrc\n", hrc));

        hrc = ptrClipboard->WriteFormats(ComSafeArrayAsInParam(aWriteTextFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("Repeated WriteFormats failed, hrc=%Rhrc\n", hrc));

        /* Repeated explicit host offers must remain visible to observers such as VBoxManage clipboard listen. */
        for (unsigned i = 0; i < 2; i++)
        {
            ComPtr<IEvent> ptrEvent;
            hrc = ptrEventSource->GetEvent(ptrListener, 1000 /* aTimeout */, ptrEvent.asOutParam());
            RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("GetEvent(format write %u) failed, hrc=%Rhrc\n", i, hrc));
            RTTESTI_CHECK_MSG_BREAK(!ptrEvent.isNull(), ("GetEvent(format write %u) returned no event\n", i));
            VBoxEventType_T enmType = VBoxEventType_Invalid;
            hrc = ptrEvent->COMGETTER(Type)(&enmType);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Type)(format write %u) failed, hrc=%Rhrc\n", i, hrc));
            RTTESTI_CHECK_MSG(enmType == VBoxEventType_OnClipboardFormatChanged,
                              ("GetEvent(format write %u) returned type %d, expected %d\n",
                               i, enmType, VBoxEventType_OnClipboardFormatChanged));
        }

        if (ptrListener.isNotNull())
            ptrEventSource->UnregisterListener(ptrListener);
        fListenerRegistered = false;
        ptrListener.setNull();

        /* Reset clears transient clipboard file-list and format state. */
        hrc = ptrClipboard->Reset();
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("Reset failed, hrc=%Rhrc\n", hrc));

        aFileList.setNull();
        hrc = ptrClipboard->COMGETTER(FileList)(ComSafeArrayAsOutParam(aFileList));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileList) after Reset failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aFileList.size() == 0);

        aReadFormats.setNull();
        hrc = ptrClipboard->ReadFormats(ComSafeArrayAsOutParam(aReadFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadFormats after Reset failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aReadFormats.size() == 0);
    } while (0);

    /* Clean up listeners and VM state regardless of which subtest exited early. */
    if (fListenerRegistered && ptrEventSource.isNotNull() && ptrListener.isNotNull())
        ptrEventSource->UnregisterListener(ptrListener);
    ptrListener.setNull();
    ptrEventSource.setNull();
    ptrClipboard.setNull();

    if (fMachineLocked && !ptrConsole.isNull())
    {
        ComPtr<IProgress> ptrPowerDownProgress;
        HRESULT hrcPowerDown = ptrConsole->PowerDown(ptrPowerDownProgress.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrcPowerDown), ("PowerDown failed, hrc=%Rhrc\n", hrcPowerDown));
        if (SUCCEEDED(hrcPowerDown) && !ptrPowerDownProgress.isNull())
        {
            hrcPowerDown = ptrPowerDownProgress->WaitForCompletion(-1);
            RTTESTI_CHECK_MSG(SUCCEEDED(hrcPowerDown), ("WaitForCompletion(PowerDown) failed, hrc=%Rhrc\n", hrcPowerDown));
        }
    }

    ptrConsole.setNull();

    if (fMachineLocked)
    {
        HRESULT hrcUnlock = ptrSession->UnlockMachine();
        RTTESTI_CHECK_MSG(SUCCEEDED(hrcUnlock), ("UnlockMachine failed, hrc=%Rhrc\n", hrcUnlock));
    }
    ptrSession.setNull();

    if (fMachineRegistered)
    {
        HRESULT hrcWait = tstWaitMachineUnlocked(hTest, ptrMachine);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrcWait), ("Waiting for machine unlock failed, hrc=%Rhrc\n", hrcWait));

        SafeIfaceArray<IMedium> aMedia;
        HRESULT hrcCleanup = ptrMachine->Unregister(CleanupMode_DetachAllReturnHardDisksOnly, ComSafeArrayAsOutParam(aMedia));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrcCleanup), ("Unregister failed, hrc=%Rhrc\n", hrcCleanup));
        if (SUCCEEDED(hrcCleanup))
        {
            ComPtr<IProgress> ptrProgress;
            hrcCleanup = ptrMachine->DeleteConfig(ComSafeArrayAsInParam(aMedia), ptrProgress.asOutParam());
            RTTESTI_CHECK_MSG(SUCCEEDED(hrcCleanup), ("DeleteConfig failed, hrc=%Rhrc\n", hrcCleanup));
            if (SUCCEEDED(hrcCleanup) && !ptrProgress.isNull())
            {
                hrcCleanup = ptrProgress->WaitForCompletion(-1);
                RTTESTI_CHECK_MSG(SUCCEEDED(hrcCleanup), ("WaitForCompletion(DeleteConfig) failed, hrc=%Rhrc\n", hrcCleanup));
            }
        }
    }
}


int main()
{
    RTTEST hTest;
    RTEXITCODE rcExit = RTTestInitAndCreate("tstClipboard", &hTest);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;

    tstInitLogging();

    RTTestBanner(hTest);

    HRESULT hrc = Initialize();
    if (FAILED(hrc))
    {
        RTTestFailed(hTest, "Failed to initialize COM, hrc=%Rhrc", hrc);
        return RTTestSummaryAndDestroy(hTest);
    }

    tstClipboardPublicApi(hTest);

    Shutdown();
    return RTTestSummaryAndDestroy(hTest);
}
