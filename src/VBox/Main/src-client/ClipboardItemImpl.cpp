/* $Id: ClipboardItemImpl.cpp 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard item object.
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
#include "ClipboardItemImpl.h"

#include <VBox/com/ErrorInfo.h>

#include <iprt/errcore.h>


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(ClipboardItem)


/**
 * Completes construction of a clipboard item object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardItem::FinalConstruct()
{
    Log3Func(("\n"));
    mData.mId     = 0;
    mData.mSource = ClipboardSource_Host;
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard item object.
 */
void ClipboardItem::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a clipboard item object.
 *
 * @returns COM status code.
 * @param   aId             Unique clipboard item identifier.
 * @param   aSource         Clipboard source.
 * @param   aFormat         Clipboard format.
 * @param   aBuffer         Clipboard item payload.
 */
HRESULT ClipboardItem::init(ULONG aId,
                            ClipboardSource_T aSource,
                            const ComPtr<IClipboardFormat> &aFormat,
                            const std::vector<BYTE> &aBuffer)
{
    Log2Func(("aId=%RU32, aSource=%RU32, aFormat=%p, cb=%zu\n",
              (uint32_t)aId, (uint32_t)aSource, (void *)aFormat, aBuffer.size()));
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mId     = aId;
    mData.mSource = aSource;
    mData.mFormat = aFormat;
    mData.mBuffer = aBuffer;

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard item object.
 */
void ClipboardItem::uninit()
{
    Log3Func(("id=%RU32, source=%RU32, cb=%zu\n", (uint32_t)mData.mId, (uint32_t)mData.mSource, mData.mBuffer.size()));
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mId = 0;
    mData.mSource = ClipboardSource_Host;
    mData.mFormat.setNull();
    mData.mBuffer.clear();
}


/**
 * Returns the clipboard item identifier.
 *
 * @returns COM status code.
 * @param   aId             Where to return the item identifier.
 */
HRESULT ClipboardItem::getId(ULONG *aId)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aId = mData.mId;
    Log3Func(("aId=%RU32\n", (uint32_t)*aId));
    return S_OK;
}


/**
 * Sets the clipboard item identifier.
 *
 * @returns COM status code.
 * @param   aId             New item identifier.
 */
HRESULT ClipboardItem::setId(ULONG aId)
{
    Log2Func(("oldId=%RU32, newId=%RU32\n", (uint32_t)mData.mId, (uint32_t)aId));
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mId = aId;
    return S_OK;
}


/**
 * Returns the clipboard source.
 *
 * @returns COM status code.
 * @param   aSource         Where to return the clipboard source.
 */
HRESULT ClipboardItem::getSource(ClipboardSource_T *aSource)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aSource = mData.mSource;
    Log3Func(("aSource=%RU32\n", (uint32_t)*aSource));
    return S_OK;
}


/**
 * Sets the clipboard source.
 *
 * @returns COM status code.
 * @param   aSource         New clipboard source.
 */
HRESULT ClipboardItem::setSource(ClipboardSource_T aSource)
{
    Log2Func(("oldSource=%RU32, newSource=%RU32\n", (uint32_t)mData.mSource, (uint32_t)aSource));
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mSource = aSource;
    return S_OK;
}


/**
 * Returns the clipboard format.
 *
 * @returns COM status code.
 * @param   aFormat         Where to return the clipboard format.
 */
HRESULT ClipboardItem::getFormat(ComPtr<IClipboardFormat> &aFormat)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aFormat = mData.mFormat;
    Log3Func(("aFormat=%p\n", (void *)aFormat));
    return S_OK;
}


/**
 * Sets the clipboard format.
 *
 * @returns COM status code.
 * @param   aFormat         New clipboard format.
 */
HRESULT ClipboardItem::setFormat(const ComPtr<IClipboardFormat> &aFormat)
{
    Log2Func(("aFormat=%p\n", (void *)aFormat));
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mFormat = aFormat;
    return S_OK;
}


/**
 * Returns the clipboard item payload.
 *
 * @returns COM status code.
 * @param   aBuffer         Where to return the payload bytes.
 */
HRESULT ClipboardItem::getBuffer(std::vector<BYTE> &aBuffer)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aBuffer = mData.mBuffer;
    Log3Func(("cb=%zu\n", aBuffer.size()));
    return S_OK;
}


/**
 * Sets the clipboard item payload.
 *
 * @returns COM status code.
 * @param   aBuffer         New payload bytes.
 */
HRESULT ClipboardItem::setBuffer(const std::vector<BYTE> &aBuffer)
{
    Log2Func(("oldSize=%zu, newSize=%zu\n", mData.mBuffer.size(), aBuffer.size()));
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mBuffer = aBuffer;
    return S_OK;
}


/**
 * Returns the clipboard item payload size.
 *
 * @returns COM status code.
 * @param   aSize           Where to return the payload size in bytes.
 */
HRESULT ClipboardItem::getSize(ULONG *aSize)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aSize = (ULONG)mData.mBuffer.size();
    Log3Func(("aSize=%RU32\n", (uint32_t)*aSize));
    return S_OK;
}
