/* $Id: tstClipboard.cpp 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
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
#include "ClipboardSettingsImpl.h"
#include "ClipboardFormatImpl.h"
#include "ClipboardItemImpl.h"
#include "ClipboardTransferImpl.h"
#include "ClipboardTransferManagerImpl.h"
#include "ClipboardImpl.h"
#include "ConsoleClipboardFormats.h"
#include "ConsoleImpl.h"
#include "MachineImpl.h"
#include "VMMDev.h"

#include <VBox/com/array.h>
#include <VBox/com/com.h>
#include <VBox/com/ErrorInfo.h>
#include <VBox/com/string.h>
#include <VBox/com/VirtualBox.h>
#include <VBox/log.h>

#include <iprt/env.h>
#include <iprt/log.h>
#include <iprt/message.h>
#include <iprt/string.h>
#include <iprt/test.h>
#include <iprt/thread.h>
#include <iprt/uuid.h>

#include <string.h>


/*********************************************************************************************************************************
*   Global Variables                                                                                                             *
*********************************************************************************************************************************/
/** The testcase logger. */
static PRTLOGGER    g_pLogger;


/*********************************************************************************************************************************
*   Testcase Stubs                                                                                                               *
*********************************************************************************************************************************/
/**
 * Testcase stub for Machine::i_addStateDependency.
 *
 * @returns COM status code.
 * @param   aDepType        State dependency type.
 * @param   aState          Where to return the machine state.
 * @param   aRegistered     Where to return the registration state.
 */
HRESULT Machine::i_addStateDependency(StateDependency aDepType, MachineState_T *aState, BOOL *aRegistered)
{
    RT_NOREF(aDepType, aState, aRegistered);
    AssertFailed();
    return E_FAIL;
}


/**
 * Testcase stub for Machine::i_releaseStateDependency.
 */
void Machine::i_releaseStateDependency()
{
    AssertFailed();
}


/**
 * Testcase stub for Console::i_addVMCaller.
 *
 * @returns COM status code.
 * @param   fQuiet          Whether to suppress error reporting.
 * @param   fAllowNullVM    Whether a NULL VM is allowed.
 */
HRESULT Console::i_addVMCaller(bool fQuiet, bool fAllowNullVM)
{
    RT_NOREF(fQuiet, fAllowNullVM);
    return E_FAIL;
}


/**
 * Testcase stub for Console::i_releaseVMCaller.
 */
void Console::i_releaseVMCaller()
{
    AssertFailed();
}


/**
 * Testcase stub for Console::i_safeVMPtrRetainer.
 *
 * @returns COM status code.
 * @param   ppUVM           Where to return the VM handle.
 * @param   ppVMM           Where to return the VMM vtable.
 * @param   fQuiet          Whether to suppress error reporting.
 */
HRESULT Console::i_safeVMPtrRetainer(PUVM *ppUVM, PCVMMR3VTABLE *ppVMM, bool fQuiet) RT_NOEXCEPT
{
    RT_NOREF(fQuiet);
    *ppUVM = NULL;
    *ppVMM = NULL;
    return E_FAIL;
}


/**
 * Testcase stub for Console::i_safeVMPtrReleaser.
 *
 * @param   ppUVM           VM handle pointer to release.
 */
void Console::i_safeVMPtrReleaser(PUVM *ppUVM)
{
    RT_NOREF(ppUVM);
    AssertFailed();
}


/**
 * Testcase stub for Console::i_setInvalidMachineStateError.
 *
 * @returns COM status code.
 */
HRESULT Console::i_setInvalidMachineStateError()
{
    return VBOX_E_INVALID_VM_STATE;
}


/**
 * Testcase stub for VMMDev::hgcmHostCall.
 *
 * @returns VBox status code.
 * @param   pszServiceName  HGCM service name.
 * @param   u32Function     HGCM function number.
 * @param   cParms          Number of HGCM parameters.
 * @param   paParms         HGCM parameters.
 */
int VMMDev::hgcmHostCall(const char *pszServiceName, uint32_t u32Function, uint32_t cParms, PVBOXHGCMSVCPARM paParms)
{
    RT_NOREF(pszServiceName, u32Function, cParms, paParms);
    AssertFailed();
    return VERR_NOT_IMPLEMENTED;
}


/*********************************************************************************************************************************
*   Internal Functions                                                                                                           *
*********************************************************************************************************************************/
/**
 * Creates a clipboard format object for tests.
 *
 * @returns COM status code.
 * @param   pszMimeType     MIME type for the format object.
 * @param   ptrFormat       Where to return the created format object.
 */
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


/**
 * Creates a clipboard item object for tests.
 *
 * @returns COM status code.
 * @param   enmSource       Clipboard source.
 * @param   ptrFormat       Clipboard format object.
 * @param   abData          Payload bytes.
 * @param   ptrItem         Where to return the created item object.
 */
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


/**
 * Checks whether a MIME type is present in a vector.
 *
 * @returns true if the MIME type is present, false otherwise.
 * @param   aFormats        MIME format vector to search.
 * @param   pszMimeType     MIME type to find.
 */
static bool tstFormatVectorContains(const std::vector<com::Utf8Str> &aFormats, const char *pszMimeType)
{
    for (std::vector<com::Utf8Str>::const_iterator it = aFormats.begin(); it != aFormats.end(); ++it)
        if (!RTStrCmp(it->c_str(), pszMimeType))
            return true;
    return false;
}


/**
 * Checks whether a byte SafeArray contains the expected bytes.
 *
 * @returns true if the buffers match, false otherwise.
 * @param   aBuffer         Buffer to check.
 * @param   abExpected      Expected payload bytes.
 */
static bool tstByteArrayEquals(const com::SafeArray<BYTE> &aBuffer, const std::vector<BYTE> &abExpected)
{
    if (aBuffer.size() != abExpected.size())
        return false;
    if (abExpected.empty())
        return true;
    return !memcmp(aBuffer.raw(), &abExpected[0], abExpected.size());
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
static void tstLogErrorInfo(RTTEST hTest, const char *pszWhat, const com::ErrorInfo &errorInfo)
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
 * Tests clipboard settings objects.
 *
 * @param   hTest           Test handle.
 */
static void tstClipboardSettings(RTTEST hTest)
{
    RTTestSub(hTest, "Settings");

    ComObjPtr<ClipboardSettings> ptrClipboardObj;
    HRESULT hrc = ptrClipboardObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("createObject failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboardObj->init();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardSettings> ptrClipboard;
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
    hrc = ptrClipboard->COMGETTER(FileTransfersEnabled)(&fFileTransfersEnabled);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileTransfersEnabled) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!fFileTransfersEnabled);

    hrc = ptrClipboard->COMSETTER(FileTransfersEnabled)(TRUE);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(FileTransfersEnabled) failed, hrc=%Rhrc\n", hrc));
    hrc = ptrClipboard->COMGETTER(FileTransfersEnabled)(&fFileTransfersEnabled);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileTransfersEnabled) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(fFileTransfersEnabled);
}


/**
 * Tests clipboard format objects.
 *
 * @param   hTest           Test handle.
 */
static void tstClipboardFormat(RTTEST hTest)
{
    RTTestSub(hTest, "Format object");

    ComPtr<IClipboardFormat> ptrFormat;
    HRESULT hrc = tstCreateFormat("text/plain;charset=utf-8", ptrFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat failed, hrc=%Rhrc\n", hrc));

    com::Bstr bstrMimeType;
    hrc = ptrFormat->COMGETTER(MimeType)(bstrMimeType.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(bstrMimeType).c_str(), "text/plain;charset=utf-8"));

    hrc = ptrFormat->COMSETTER(MimeType)(Bstr("text/html").raw());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(MimeType) failed, hrc=%Rhrc\n", hrc));
    bstrMimeType.setNull();
    hrc = ptrFormat->COMGETTER(MimeType)(bstrMimeType.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(bstrMimeType).c_str(), "text/html"));
}


/**
 * Tests console clipboard format conversion helpers.
 *
 * @param   hTest           Test handle.
 */
static void tstConsoleClipboardFormats(RTTEST hTest)
{
    RTTestSub(hTest, "Clipboard formats");

    RTTESTI_CHECK(consoleClipboardMimeTypeToFormat(com::Utf8Str("text/plain")) == VBOX_SHCL_FMT_UNICODETEXT);
    RTTESTI_CHECK(consoleClipboardMimeTypeToFormat(com::Utf8Str("text/plain;charset=UTF-8")) == VBOX_SHCL_FMT_UNICODETEXT);
    RTTESTI_CHECK(consoleClipboardMimeTypeToFormat(com::Utf8Str("text/html;charset=utf-8")) == VBOX_SHCL_FMT_HTML);
    RTTESTI_CHECK(consoleClipboardMimeTypeToFormat(com::Utf8Str("image/x-bmp")) == VBOX_SHCL_FMT_BITMAP);
    RTTESTI_CHECK(consoleClipboardMimeTypeToFormat(com::Utf8Str("application/octet-stream")) == VBOX_SHCL_FMT_NONE);

    RTTESTI_CHECK(!RTStrCmp(consoleClipboardFormatToMimeType(VBOX_SHCL_FMT_UNICODETEXT), "text/plain;charset=utf-8"));
    RTTESTI_CHECK(!RTStrCmp(consoleClipboardFormatToMimeType(VBOX_SHCL_FMT_HTML), "text/html"));
    RTTESTI_CHECK(!RTStrCmp(consoleClipboardFormatToMimeType(VBOX_SHCL_FMT_BITMAP), "image/bmp"));
    RTTESTI_CHECK(consoleClipboardFormatToMimeType(VBOX_SHCL_FMT_VALID_MASK + 1) == NULL);

    std::vector<com::Utf8Str> aFormats;
    aFormats.push_back(com::Utf8Str("text/plain"));
    aFormats.push_back(com::Utf8Str("text/html"));
    aFormats.push_back(com::Utf8Str("image/bmp"));

    SHCLFORMATS fFormats = VBOX_SHCL_FMT_NONE;
    HRESULT hrc = consoleClipboardMimeTypesToFormats(aFormats, &fFormats);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("consoleClipboardMimeTypesToFormats failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(fFormats == (VBOX_SHCL_FMT_UNICODETEXT | VBOX_SHCL_FMT_HTML | VBOX_SHCL_FMT_BITMAP));

    aFormats.push_back(com::Utf8Str("application/x-unsupported"));
    hrc = consoleClipboardMimeTypesToFormats(aFormats, &fFormats);
    RTTESTI_CHECK(hrc == E_INVALIDARG);

    consoleClipboardFormatsToMimeTypes(VBOX_SHCL_FMT_UNICODETEXT | VBOX_SHCL_FMT_HTML | VBOX_SHCL_FMT_BITMAP, aFormats);
    RTTESTI_CHECK(aFormats.size() == 3);
    RTTESTI_CHECK(tstFormatVectorContains(aFormats, "text/plain;charset=utf-8"));
    RTTESTI_CHECK(tstFormatVectorContains(aFormats, "text/html"));
    RTTESTI_CHECK(tstFormatVectorContains(aFormats, "image/bmp"));

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RTTESTI_CHECK(consoleClipboardMimeTypeToFormat(com::Utf8Str("text/uri-list")) == VBOX_SHCL_FMT_URI_LIST);
    RTTESTI_CHECK(!RTStrCmp(consoleClipboardFormatToMimeType(VBOX_SHCL_FMT_URI_LIST), "text/uri-list"));
#endif
}


/**
 * Tests the public console clipboard API.
 *
 * @param   hTest           Test handle.
 */
static void tstConsoleClipboardPublicApi(RTTEST hTest)
{
    RTTestSub(hTest, "Clipboard public API");

    HRESULT hrc = S_OK;
    bool fMachineRegistered = false;
    bool fMachineLocked = false;
    ComPtr<IVirtualBoxClient> ptrVirtualBoxClient;
    ComPtr<IVirtualBox> ptrVirtualBox;
    ComPtr<ISession> ptrSession;
    ComPtr<IMachine> ptrMachine;
    ComPtr<IConsole> ptrConsole;
    ComPtr<IClipboard> ptrClipboard;

    do
    {
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

        com::SafeArray<BSTR> aGroups;
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

        ComPtr<IClipboardSettings> ptrClipboardSettings;
        hrc = ptrMachine->COMGETTER(Clipboard)(ptrClipboardSettings.asOutParam());
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMGETTER(IMachine::Clipboard) failed, hrc=%Rhrc\n", hrc));
        hrc = ptrClipboardSettings->COMSETTER(Mode)(ClipboardMode_Bidirectional);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMSETTER(Mode) failed, hrc=%Rhrc\n", hrc));
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        hrc = ptrClipboardSettings->COMSETTER(FileTransfersEnabled)(TRUE);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("COMSETTER(FileTransfersEnabled) failed, hrc=%Rhrc\n", hrc));
#endif

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
            tstLogErrorInfo(hTest, "LaunchVMProcess", com::ErrorInfo(ptrMachine, COM_IIDOF(IMachine)));
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
            tstLogErrorInfo(hTest, "LaunchVMProcess progress", com::ProgressErrorInfo(ptrLaunchProgress));
            RTTestSkipped(hTest, "LaunchVMProcess result code is %Rhrc", lrcLaunchResult);
            break;
        }
        fMachineLocked = true;

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

        BOOL fUseHostClipboardInitial = FALSE;
        hrc = ptrClipboard->COMGETTER(UseHostClipboard)(&fUseHostClipboardInitial);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(UseHostClipboard) failed, hrc=%Rhrc\n", hrc));

        BOOL const fUseHostClipboardToggled = !fUseHostClipboardInitial;
        hrc = ptrClipboard->COMSETTER(UseHostClipboard)(fUseHostClipboardToggled);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(UseHostClipboard) toggling failed, hrc=%Rhrc\n", hrc));
        BOOL fUseHostClipboard = fUseHostClipboardInitial;
        hrc = ptrClipboard->COMGETTER(UseHostClipboard)(&fUseHostClipboard);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(UseHostClipboard) after toggling failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(fUseHostClipboard == fUseHostClipboardToggled);

        hrc = ptrClipboard->COMSETTER(UseHostClipboard)(fUseHostClipboardInitial);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(UseHostClipboard) restoring failed, hrc=%Rhrc\n", hrc));
        hrc = ptrClipboard->COMGETTER(UseHostClipboard)(&fUseHostClipboard);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(UseHostClipboard) after restoring failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(fUseHostClipboard == fUseHostClipboardInitial);

        hrc = ptrClipboard->COMSETTER(UseHostClipboard)(TRUE);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(UseHostClipboard) enabling failed, hrc=%Rhrc\n", hrc));

        com::SafeArray<BSTR> aFileList;
        hrc = ptrClipboard->COMGETTER(FileList)(ComSafeArrayAsOutParam(aFileList));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(FileList) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aFileList.size() == 0);

        com::SafeArray<IN_BSTR> aNewFileList;
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

        ComPtr<IEventSource> ptrEventSource;
        hrc = ptrClipboard->COMGETTER(EventSource)(ptrEventSource.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(EventSource) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrEventSource.isNull());

        ComPtr<IEventListener> ptrListener;
        hrc = ptrEventSource->CreateListener(ptrListener.asOutParam());
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("CreateListener failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!ptrListener.isNull());
        com::SafeArray<VBoxEventType_T> aEventTypes;
        aEventTypes.push_back(VBoxEventType_OnClipboardModeChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardSourceChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardFormatChanged);
        aEventTypes.push_back(VBoxEventType_OnClipboardDataChanged);
        hrc = ptrEventSource->RegisterListener(ptrListener, ComSafeArrayAsInParam(aEventTypes), FALSE /* aActive */);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("RegisterListener failed, hrc=%Rhrc\n", hrc));

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

        com::SafeIfaceArray<IClipboardFormat> aReadFormats;
        hrc = ptrClipboard->ReadFormats(ComSafeArrayAsOutParam(aReadFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("ReadFormats failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aReadFormats.size() == 0);

        ComPtr<IClipboardFormat> ptrTextFormat;
        hrc = tstCreateFormat("text/plain;charset=utf-8", ptrTextFormat);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("tstCreateFormat failed, hrc=%Rhrc\n", hrc));

        BOOL fAvailable = TRUE;
        hrc = ptrClipboard->IsFormatAvailable(ClipboardSource_Host, ptrTextFormat, &fAvailable);
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("IsFormatAvailable failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(!fAvailable);

        com::SafeIfaceArray<IClipboardFormat> aSupportedFormats;
        hrc = ptrClipboard->GetSupportedFormats(ClipboardSource_Host, ComSafeArrayAsOutParam(aSupportedFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("GetSupportedFormats failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(aSupportedFormats.size() == 0);

        ComPtr<IClipboardItem> ptrReadItem;
        hrc = ptrClipboard->ReadData(ClipboardAction_Copy, ptrReadItem.asOutParam());
        RTTESTI_CHECK_MSG(FAILED(hrc), ("ReadData without available formats unexpectedly succeeded\n"));

        std::vector<BYTE> abBuffer;
        ComPtr<IClipboardItem> ptrEmptyItem;
        hrc = tstCreateItem(ClipboardSource_Host, ptrTextFormat, abBuffer, ptrEmptyItem);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("tstCreateItem(empty) failed, hrc=%Rhrc\n", hrc));
        ComPtr<IClipboardItem> ptrWrittenItem;
        hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrEmptyItem, ptrWrittenItem.asOutParam());
        RTTESTI_CHECK_MSG(hrc == E_INVALIDARG, ("WriteData with empty buffer returned hrc=%Rhrc\n", hrc));

        ComPtr<IClipboardFormat> ptrUnsupportedFormat;
        hrc = tstCreateFormat("application/x-unsupported", ptrUnsupportedFormat);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("tstCreateFormat(unsupported) failed, hrc=%Rhrc\n", hrc));
        abBuffer.push_back('x');
        ComPtr<IClipboardItem> ptrUnsupportedItem;
        hrc = tstCreateItem(ClipboardSource_Host, ptrUnsupportedFormat, abBuffer, ptrUnsupportedItem);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("tstCreateItem(unsupported) failed, hrc=%Rhrc\n", hrc));
        ptrWrittenItem.setNull();
        hrc = ptrClipboard->WriteData(ClipboardAction_Copy, ptrUnsupportedItem, ptrWrittenItem.asOutParam());
        RTTESTI_CHECK_MSG(hrc == E_INVALIDARG, ("WriteData with unsupported MIME type returned hrc=%Rhrc\n", hrc));

        static const char s_szRoundTripText[] = "tstClipboard host to guest round-trip data";
        std::vector<BYTE> abRoundTripBuffer(sizeof(s_szRoundTripText));
        memcpy(&abRoundTripBuffer[0], s_szRoundTripText, sizeof(s_szRoundTripText));

        ComPtr<IClipboardItem> ptrTextItem;
        hrc = tstCreateItem(ClipboardSource_Host, ptrTextFormat, abRoundTripBuffer, ptrTextItem);
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("tstCreateItem(text) failed, hrc=%Rhrc\n", hrc));
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
        }
        if (ptrListener.isNotNull())
            ptrEventSource->UnregisterListener(ptrListener);
        ptrListener.setNull();

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
        com::Bstr bstrGuestReadMimeType;
        com::SafeArray<BYTE> aGuestReadBuffer;
        hrc = ptrClipboard->ReadDataRaw(ClipboardAction_Copy, &enmGuestReadSource, bstrGuestReadMimeType.asOutParam(),
                                       ComSafeArrayAsOutParam(aGuestReadBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("ReadDataRaw(host -> guest) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmGuestReadSource == ClipboardSource_Host);
        RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(bstrGuestReadMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aGuestReadBuffer, abRoundTripBuffer),
                          ("ReadDataRaw(host -> guest) returned %zu bytes, expected %zu\n",
                           aGuestReadBuffer.size(), abRoundTripBuffer.size()));

        ClipboardSource_T enmWrittenSource = ClipboardSource_Custom;
        com::Bstr bstrWrittenMimeType;
        com::SafeArray<BYTE> aWrittenBuffer;
        hrc = ptrClipboard->WriteDataRaw(ClipboardAction_Copy, ClipboardSource_Guest, bstrGuestReadMimeType.raw(),
                                        ComSafeArrayAsInParam(aGuestReadBuffer), &enmWrittenSource,
                                        bstrWrittenMimeType.asOutParam(), ComSafeArrayAsOutParam(aWrittenBuffer));
        RTTESTI_CHECK_MSG_BREAK(SUCCEEDED(hrc), ("WriteDataRaw(guest -> host) failed, hrc=%Rhrc\n", hrc));
        RTTESTI_CHECK(enmWrittenSource == ClipboardSource_Guest);
        RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(bstrWrittenMimeType).c_str(), "text/plain;charset=utf-8"));
        RTTESTI_CHECK_MSG(tstByteArrayEquals(aWrittenBuffer, abRoundTripBuffer),
                          ("WriteDataRaw(guest -> host) returned %zu bytes, expected %zu\n",
                           aWrittenBuffer.size(), abRoundTripBuffer.size()));

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
                com::Bstr bstrRoundTripMimeType;
                hrc = ptrRoundTripFormat->COMGETTER(MimeType)(bstrRoundTripMimeType.asOutParam());
                RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(MimeType)(round-trip) failed, hrc=%Rhrc\n", hrc));
                RTTESTI_CHECK(!RTStrCmp(com::Utf8Str(bstrRoundTripMimeType).c_str(), "text/plain;charset=utf-8"));
            }

            com::SafeArray<BYTE> aRoundTripBuffer;
            hrc = ptrReadItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(aRoundTripBuffer));
            RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Buffer)(round-trip) failed, hrc=%Rhrc\n", hrc));
            RTTESTI_CHECK_MSG(tstByteArrayEquals(aRoundTripBuffer, abRoundTripBuffer),
                              ("ReadData(round-trip) returned %zu bytes, expected %zu\n",
                               aRoundTripBuffer.size(), abRoundTripBuffer.size()));
        }

        std::vector<ComPtr<IClipboardFormat> > vecFormats;
        vecFormats.push_back(ptrTextFormat);
        vecFormats.push_back(ptrUnsupportedFormat);
        com::SafeIfaceArray<IClipboardFormat> aWriteFormats(vecFormats);
        hrc = ptrClipboard->WriteFormats(ComSafeArrayAsInParam(aWriteFormats));
        RTTESTI_CHECK_MSG(hrc == E_INVALIDARG, ("WriteFormats with unsupported MIME type returned hrc=%Rhrc\n", hrc));

        vecFormats.clear();
        vecFormats.push_back(ptrTextFormat);
        com::SafeIfaceArray<IClipboardFormat> aWriteTextFormats(vecFormats);
        hrc = ptrClipboard->WriteFormats(ComSafeArrayAsInParam(aWriteTextFormats));
        RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("WriteFormats failed, hrc=%Rhrc\n", hrc));

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

        com::SafeIfaceArray<IMedium> aMedia;
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


/**
 * Tests clipboard item objects.
 *
 * @param   hTest           Test handle.
 */
static void tstClipboardItem(RTTEST hTest)
{
    RTTestSub(hTest, "Item object");

    ComPtr<IClipboardFormat> ptrTextFormat;
    HRESULT hrc = tstCreateFormat("text/plain;charset=utf-8", ptrTextFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat failed, hrc=%Rhrc\n", hrc));

    const char szText[] = "Hello from the Main clipboard testcase";
    std::vector<BYTE> abText(sizeof(szText));
    memcpy(&abText[0], szText, sizeof(szText));

    ComPtr<IClipboardItem> ptrItem;
    hrc = tstCreateItem(ClipboardSource_Host, ptrTextFormat, abText, ptrItem);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateItem failed, hrc=%Rhrc\n", hrc));

    ClipboardSource_T enmSource = ClipboardSource_Guest;
    hrc = ptrItem->COMGETTER(Source)(&enmSource);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Source) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(enmSource == ClipboardSource_Host);

    ComPtr<IClipboardFormat> ptrFormat;
    hrc = ptrItem->COMGETTER(Format)(ptrFormat.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Format) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(ptrFormat == ptrTextFormat);

    com::SafeArray<BYTE> abReadText;
    hrc = ptrItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(abReadText));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Buffer) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(abReadText.size() == sizeof(szText));
    if (abReadText.size() == sizeof(szText))
        RTTESTI_CHECK(!memcmp(abReadText.raw(), szText, sizeof(szText)));

    ULONG cbItem = 0;
    hrc = ptrItem->COMGETTER(Size)(&cbItem);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Size) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(cbItem == sizeof(szText));

    ComPtr<IClipboardFormat> ptrHtmlFormat;
    hrc = tstCreateFormat("text/html", ptrHtmlFormat);
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("tstCreateFormat failed, hrc=%Rhrc\n", hrc));
    hrc = ptrItem->COMSETTER(Format)(ptrHtmlFormat);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(Format) failed, hrc=%Rhrc\n", hrc));
    ptrFormat.setNull();
    hrc = ptrItem->COMGETTER(Format)(ptrFormat.asOutParam());
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Format) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(ptrFormat == ptrHtmlFormat);

    const char szHtml[] = "<p>Hello from the Main clipboard testcase</p>";
    com::SafeArray<BYTE> abHtml;
    hrc = abHtml.initFrom(reinterpret_cast<const BYTE *>(szHtml), sizeof(szHtml));
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("SafeArray initFrom failed, hrc=%Rhrc\n", hrc));
    hrc = ptrItem->COMSETTER(Buffer)(ComSafeArrayAsInParam(abHtml));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMSETTER(Buffer) failed, hrc=%Rhrc\n", hrc));

    com::SafeArray<BYTE> abReadHtml;
    hrc = ptrItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(abReadHtml));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Buffer) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(abReadHtml.size() == sizeof(szHtml));
    if (abReadHtml.size() == sizeof(szHtml))
        RTTESTI_CHECK(!memcmp(abReadHtml.raw(), szHtml, sizeof(szHtml)));

    hrc = ptrItem->COMGETTER(Size)(&cbItem);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Size) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(cbItem == sizeof(szHtml));
}


/**
 * Tests clipboard transfer objects and manager operations.
 *
 * @param   hTest           Test handle.
 */
static void tstClipboardTransfers(RTTEST hTest)
{
    RTTestSub(hTest, "Transfers");

    ComObjPtr<ClipboardTransferManager> ptrTransfersObj;
    HRESULT hrc = ptrTransfersObj.createObject();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("create transfer manager failed, hrc=%Rhrc\n", hrc));
    hrc = ptrTransfersObj->init();
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("transfer manager init failed, hrc=%Rhrc\n", hrc));

    ComPtr<IClipboardTransferManager> ptrTransfers;
    hrc = ptrTransfersObj.queryInterfaceTo(ptrTransfers.asOutParam());
    RTTESTI_CHECK_MSG_RETV(SUCCEEDED(hrc), ("transfer manager queryInterfaceTo failed, hrc=%Rhrc\n", hrc));

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

    ULONG idTransfer = 0;
    hrc = ptrTransfer->COMGETTER(Id)(&idTransfer);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Id) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(idTransfer == 1);

    ClipboardAction_T enmAction = ClipboardAction_Invalid;
    hrc = ptrTransfer->COMGETTER(Action)(&enmAction);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Action) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(enmAction == ClipboardAction_Copy);

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

    hrc = ptrTransfers->Add(ptrTransfer);
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("transfer Add failed, hrc=%Rhrc\n", hrc));
    hrc = ptrTransfers->Reset();
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("transfer Reset failed, hrc=%Rhrc\n", hrc));
    aTransfers.setNull();
    hrc = ptrTransfers->COMGETTER(Transfers)(ComSafeArrayAsOutParam(aTransfers));
    RTTESTI_CHECK_MSG(SUCCEEDED(hrc), ("COMGETTER(Transfers) failed, hrc=%Rhrc\n", hrc));
    RTTESTI_CHECK(aTransfers.size() == 0);
}


int main()
{
    RTTEST hTest;
    RTEXITCODE rcExit = RTTestInitAndCreate("tstClipboard", &hTest);
    if (rcExit != RTEXITCODE_SUCCESS)
        return rcExit;

    tstInitLogging();

    RTTestBanner(hTest);

    HRESULT hrc = com::Initialize();
    if (FAILED(hrc))
    {
        RTTestFailed(hTest, "Failed to initialize COM, hrc=%Rhrc", hrc);
        return RTTestSummaryAndDestroy(hTest);
    }

    tstClipboardSettings(hTest);
    tstClipboardFormat(hTest);
    tstConsoleClipboardFormats(hTest);
    tstConsoleClipboardPublicApi(hTest);
    tstClipboardItem(hTest);
    tstClipboardTransfers(hTest);

    com::Shutdown();
    return RTTestSummaryAndDestroy(hTest);
}
