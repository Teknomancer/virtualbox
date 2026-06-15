/* $Id: ClipboardTransferImpl.cpp 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard transfer object.
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
#include "ClipboardTransferImpl.h"

#include <VBox/com/ErrorInfo.h>

#include <iprt/errcore.h>


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(ClipboardTransfer)


/**
 * Completes construction of a clipboard transfer object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransfer::FinalConstruct()
{
    Log3Func(("\n"));
    mData.mId     = 0;
    mData.mAction = ClipboardAction_Invalid;
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard transfer object.
 */
void ClipboardTransfer::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a clipboard transfer object.
 *
 * @returns COM status code.
 * @param   aId             Unique transfer identifier.
 * @param   aAction         Clipboard transfer action.
 * @param   aItem           Clipboard item being transferred.
 * @param   aProgress       Progress object for the transfer.
 */
HRESULT ClipboardTransfer::init(ULONG aId,
                                ClipboardAction_T aAction,
                                const ComPtr<IClipboardItem> &aItem,
                                const ComPtr<IProgress> &aProgress)
{
    Log2Func(("aId=%RU32, aAction=%RU32, aItem=%p, aProgress=%p\n",
              (uint32_t)aId, (uint32_t)aAction, (void *)aItem, (void *)aProgress));
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mId       = aId;
    mData.mAction   = aAction;
    mData.mItem     = aItem;
    mData.mProgress = aProgress;

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard transfer object.
 */
void ClipboardTransfer::uninit()
{
    Log3Func(("id=%RU32, action=%RU32\n", (uint32_t)mData.mId, (uint32_t)mData.mAction));
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mId = 0;
    mData.mAction = ClipboardAction_Invalid;
    mData.mItem.setNull();
    mData.mProgress.setNull();
}


/**
 * Returns the transfer identifier.
 *
 * @returns COM status code.
 * @param   aId             Where to return the transfer identifier.
 */
HRESULT ClipboardTransfer::getId(ULONG *aId)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aId = mData.mId;
    Log3Func(("aId=%RU32\n", (uint32_t)*aId));
    return S_OK;
}


/**
 * Returns the transfer action.
 *
 * @returns COM status code.
 * @param   aAction         Where to return the transfer action.
 */
HRESULT ClipboardTransfer::getAction(ClipboardAction_T *aAction)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aAction = mData.mAction;
    Log3Func(("aAction=%RU32\n", (uint32_t)*aAction));
    return S_OK;
}


/**
 * Returns the transfer item.
 *
 * @returns COM status code.
 * @param   aItem           Where to return the transfer item.
 */
HRESULT ClipboardTransfer::getItem(ComPtr<IClipboardItem> &aItem)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aItem = mData.mItem;
    Log3Func(("aItem=%p\n", (void *)aItem));
    return S_OK;
}


/**
 * Returns the transfer progress object.
 *
 * @returns COM status code.
 * @param   aProgress       Where to return the progress object.
 */
HRESULT ClipboardTransfer::getProgress(ComPtr<IProgress> &aProgress)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aProgress = mData.mProgress;
    Log3Func(("aProgress=%p\n", (void *)aProgress));
    return S_OK;
}
