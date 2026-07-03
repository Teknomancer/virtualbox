/* $Id: HostClipboardImpl.cpp 114609 2026-07-03 15:22:37Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Host clipboard API object.
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
#include "LoggingNew.h"

#include "VirtualBoxBase.h"
#include "AutoCaller.h"
#include "ClipboardImpl.h"
#include "HostClipboardImpl.h"

#include <iprt/errcore.h>


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(HostClipboard)


/**
 * Completes construction of a host clipboard object.
 *
 * @returns COM status code.
 */
HRESULT HostClipboard::FinalConstruct()
{
    return BaseFinalConstruct();
}


/**
 * Releases a host clipboard object.
 */
void HostClipboard::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a host clipboard object.
 *
 * @returns COM status code.
 * @param   aClientId       Main clipboard client ID this endpoint is associated with.
 * @param   aParent         Parent clipboard object.
 */
HRESULT HostClipboard::init(VBOXSHCLMAINCLIENTID aClientId, Clipboard *aParent)
{
    Log2Func(("aClientId=%RU32, aParent=%p\n", aClientId, aParent));
    AssertPtrReturn(aParent, E_INVALIDARG);

    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mClientId = aClientId;
    mData.mParent = aParent;

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a host clipboard object.
 */
void HostClipboard::uninit()
{
    Log3Func(("\n"));
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mClientId = VBOX_SHCL_MAIN_CLIENT_NONE;
    mData.mParent = NULL;
}


/**
 * Reports formats to the native host clipboard.
 *
 * @returns COM status code.
 */
HRESULT HostClipboard::reportFormats(ClipboardAction_T aAction,
                                     ClipboardSource_T aSource,
                                     const std::vector<ComPtr<IClipboardFormat> > &aFormats)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD
    RT_NOREF(aAction, aSource, aFormats);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD */

    Log2Func(("aAction=%RU32, aSource=%RU32, cFormats=%zu\n",
              (uint32_t)aAction, (uint32_t)aSource, aFormats.size()));

    VBOXSHCLMAINCLIENTID idClient = VBOX_SHCL_MAIN_CLIENT_NONE;
    Clipboard *pParent = NULL;
    AutoCaller autoCaller;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        idClient = mData.mClientId;
        pParent = mData.mParent;
        if (pParent)
            autoCaller.attach(pParent);
    }
    if (!pParent)
        return setError(VBOX_E_SHCL_ERROR, tr("Host clipboard object is not initialized"));
    AssertComRCReturnRC(autoCaller.hrc());

    return pParent->i_hostClipboardReportFormats(idClient, aAction, aSource, aFormats);
#endif /* VBOX_WITH_SHARED_CLIPBOARD */
}


/**
 * Provides payload data for a host clipboard request.
 *
 * @returns COM status code.
 */
HRESULT HostClipboard::provideData(ULONG aRequestId,
                                   ClipboardAction_T aAction,
                                   ClipboardSource_T aSource,
                                   const com::Utf8Str &aMimeType,
                                   const std::vector<BYTE> &aBuffer)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD
    RT_NOREF(aRequestId, aAction, aSource, aMimeType, aBuffer);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD */

    Log2Func(("aRequestId=%RU32, aAction=%RU32, aSource=%RU32, aMimeType=%s, cb=%zu\n",
              (uint32_t)aRequestId, (uint32_t)aAction, (uint32_t)aSource, aMimeType.c_str(), aBuffer.size()));

    VBOXSHCLMAINCLIENTID idClient = VBOX_SHCL_MAIN_CLIENT_NONE;
    Clipboard *pParent = NULL;
    AutoCaller autoCaller;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        idClient = mData.mClientId;
        pParent = mData.mParent;
        if (pParent)
            autoCaller.attach(pParent);
    }
    if (!pParent)
        return setError(VBOX_E_SHCL_ERROR, tr("Host clipboard object is not initialized"));
    AssertComRCReturnRC(autoCaller.hrc());

    return pParent->i_hostClipboardProvideData(idClient, aRequestId, aAction, aSource, aMimeType, aBuffer);
#endif /* VBOX_WITH_SHARED_CLIPBOARD */
}


/**
 * Sets payload data on the native host clipboard.
 *
 * @returns COM status code.
 */
HRESULT HostClipboard::setData(ClipboardAction_T aAction,
                               ClipboardSource_T aSource,
                               const com::Utf8Str &aMimeType,
                               const std::vector<BYTE> &aBuffer)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD
    RT_NOREF(aAction, aSource, aMimeType, aBuffer);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD */

    Log2Func(("aAction=%RU32, aSource=%RU32, aMimeType=%s, cb=%zu\n",
              (uint32_t)aAction, (uint32_t)aSource, aMimeType.c_str(), aBuffer.size()));

    VBOXSHCLMAINCLIENTID idClient = VBOX_SHCL_MAIN_CLIENT_NONE;
    Clipboard *pParent = NULL;
    AutoCaller autoCaller;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        idClient = mData.mClientId;
        pParent = mData.mParent;
        if (pParent)
            autoCaller.attach(pParent);
    }
    if (!pParent)
        return setError(VBOX_E_SHCL_ERROR, tr("Host clipboard object is not initialized"));
    AssertComRCReturnRC(autoCaller.hrc());

    return pParent->i_hostClipboardSetData(idClient, aAction, aSource, aMimeType, aBuffer);
#endif /* VBOX_WITH_SHARED_CLIPBOARD */
}


/**
 * Clears the native host clipboard endpoint.
 *
 * @returns COM status code.
 */
HRESULT HostClipboard::clear()
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD */

    Log2Func(("\n"));

    VBOXSHCLMAINCLIENTID idClient = VBOX_SHCL_MAIN_CLIENT_NONE;
    Clipboard *pParent = NULL;
    AutoCaller autoCaller;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        idClient = mData.mClientId;
        pParent = mData.mParent;
        if (pParent)
            autoCaller.attach(pParent);
    }
    if (!pParent)
        return setError(VBOX_E_SHCL_ERROR, tr("Host clipboard object is not initialized"));
    AssertComRCReturnRC(autoCaller.hrc());

    return pParent->i_hostClipboardClear(idClient);
#endif /* VBOX_WITH_SHARED_CLIPBOARD */
}
