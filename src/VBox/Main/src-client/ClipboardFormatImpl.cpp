/* $Id: ClipboardFormatImpl.cpp 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard format object.
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
#include "ClipboardFormatImpl.h"

#include <VBox/com/ErrorInfo.h>

#include <iprt/errcore.h>


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(ClipboardFormat)


/**
 * Completes construction of a clipboard format object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardFormat::FinalConstruct()
{
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard format object.
 */
void ClipboardFormat::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a clipboard format object.
 *
 * @returns COM status code.
 * @param   aMimeType       MIME type of the clipboard format.
 */
HRESULT ClipboardFormat::init(const com::Utf8Str &aMimeType)
{
    Log2Func(("aMimeType=%s\n", aMimeType.c_str()));
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mMimeType = aMimeType;

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard format object.
 */
void ClipboardFormat::uninit()
{
    Log3Func(("\n"));
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mMimeType.setNull();
}


/**
 * Returns the MIME type.
 *
 * @returns COM status code.
 * @param   aMimeType       Where to return the MIME type.
 */
HRESULT ClipboardFormat::getMimeType(com::Utf8Str &aMimeType)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aMimeType = mData.mMimeType;
    Log3Func(("aMimeType=%s\n", aMimeType.c_str()));
    return S_OK;
}


/**
 * Sets the MIME type.
 *
 * @returns COM status code.
 * @param   aMimeType       New MIME type.
 */
HRESULT ClipboardFormat::setMimeType(const com::Utf8Str &aMimeType)
{
    Log2Func(("aMimeType=%s\n", aMimeType.c_str()));
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mMimeType = aMimeType;
    return S_OK;
}
