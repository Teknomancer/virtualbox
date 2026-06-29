/* $Id: ClipboardTransferManagerImpl.cpp 114560 2026-06-29 08:32:23Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard transfer manager object.
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
#include "ClipboardTransferManagerImpl.h"
#include "VBoxEvents.h"

#include <VBox/com/ErrorInfo.h>
#include <VBox/GuestHost/SharedClipboard.h>

#include <iprt/errcore.h>


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(ClipboardTransferManager)


/**
 * Completes construction of a clipboard transfer manager object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransferManager::FinalConstruct()
{
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard transfer manager object.
 */
void ClipboardTransferManager::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a clipboard transfer manager object.
 *
 * @returns COM status code.
 * @param   aEventSource    Optional event source used to emit anonymous transfer
 *                          events when no parent clipboard object is available.
 * @param   aParent         Optional parent clipboard object used to fire transfer
 *                          events with clipboard revision/session context.
 */
HRESULT ClipboardTransferManager::init(IEventSource *aEventSource /* = NULL */, Clipboard *aParent /* = NULL */)
{
    Log2Func(("aEventSource=%p, aParent=%p\n", aEventSource, aParent));
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mParent = aParent;
    mData.mEventSource = aEventSource;
    mData.mTransfers.clear();

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard transfer manager object.
 */
void ClipboardTransferManager::uninit()
{
    Log3Func(("cTransfers=%zu\n", mData.mTransfers.size()));
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mTransfers.clear();
    mData.mEventSource.setNull();
    mData.mParent = NULL;
}


/**
 * Resets the internally tracked transfer list.
 */
void ClipboardTransferManager::i_reset()
{
    LogFunc(("Resetting transfer manager\n"));
    ComPtr<IEventSource> ptrEventSource;
    std::vector<ComPtr<IClipboardTransfer> > aTransfers;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        ptrEventSource = mData.mEventSource;
        aTransfers = mData.mTransfers;
        mData.mTransfers.clear();
        Log2Func(("Detached %zu transfers during reset\n", aTransfers.size()));
    }

    RT_NOREF(ptrEventSource);
    for (std::vector<ComPtr<IClipboardTransfer> >::const_iterator it = aTransfers.begin();
         it != aTransfers.end(); ++it)
    {
        Log2Func(("Firing transfer removed event during reset: transfer=%p\n", (void *)*it));
        i_fireTransferEvent(*it, ClipboardTransferState_Removed, com::Utf8Str(), ClipboardError_None);
    }
}


/**
 * Fires a clipboard transfer event through the parent clipboard object when available.
 * If there is no parent clipboard object, emits an anonymous event directly on
 * the stored event source.
 *
 * @param   aTransfer       Transfer associated with the event.
 * @param   aState          Transfer state.
 * @param   aMessage        Optional event message.
 * @param   aError          Clipboard transfer error code.
 */
void ClipboardTransferManager::i_fireTransferEvent(IClipboardTransfer *aTransfer,
                                                   ClipboardTransferState_T aState,
                                                   const com::Utf8Str &aMessage,
                                                   ClipboardError_T aError)
{
    Clipboard *pParent = NULL;
    ComPtr<IEventSource> ptrEventSource;
    AutoCaller autoCaller;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData.mParent;
        if (pParent)
            autoCaller.attach(pParent);
        else
            ptrEventSource = mData.mEventSource;
    }

    if (pParent)
    {
        if (SUCCEEDED(autoCaller.hrc()))
            pParent->i_fireClipboardTransferEvent(VBOX_SHCL_MAIN_CLIENT_NONE, aTransfer, aState, aMessage, aError);
        else
            LogFunc(("Cannot fire clipboard transfer event through parent: hrc=%#x\n", autoCaller.hrc()));
        return;
    }

    if (ptrEventSource.isNotNull())
    {
        /*
         * No parent Clipboard is available to supply a live revision or session
         * fan-out context. Keep this legacy event anonymous.
         */
        ::FireClipboardTransferEvent(ptrEventSource, 0 /* anonymous revision */, VBOX_SHCL_MAIN_CLIENT_NONE,
                                     aTransfer, aState, aMessage, aError);
    }
}


/**
 * Returns the current clipboard transfers.
 *
 * @returns COM status code.
 * @param   aTransfers      Where to return the transfer list.
 */
HRESULT ClipboardTransferManager::getTransfers(std::vector<ComPtr<IClipboardTransfer> > &aTransfers)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aTransfers = mData.mTransfers;
    Log3Func(("cTransfers=%zu\n", aTransfers.size()));
    return S_OK;
}


/**
 * Adds a clipboard transfer.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to add.
 */
HRESULT ClipboardTransferManager::add(const ComPtr<IClipboardTransfer> &aTransfer)
{
    Log2Func(("aTransfer=%p\n", (void *)aTransfer));
    if (aTransfer.isNull())
    {
        LogFunc(("Rejecting NULL transfer add\n"));
        return E_INVALIDARG;
    }

    bool fFireEvent = false;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        mData.mTransfers.push_back(aTransfer);
        Log2Func(("Added transfer: cTransfers=%zu\n", mData.mTransfers.size()));
        fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
    }

    if (fFireEvent)
    {
        Log2Func(("Firing transfer added event: transfer=%p\n", (void *)aTransfer));
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Added, com::Utf8Str(), ClipboardError_None);
    }
    return S_OK;
}


/**
 * Removes a clipboard transfer.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to remove.
 */
HRESULT ClipboardTransferManager::remove(const ComPtr<IClipboardTransfer> &aTransfer)
{
    Log2Func(("aTransfer=%p\n", (void *)aTransfer));
    if (aTransfer.isNull())
    {
        LogFunc(("Rejecting NULL transfer remove\n"));
        return E_INVALIDARG;
    }

    bool fRemoved = false;
    bool fFireEvent = false;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        for (std::vector<ComPtr<IClipboardTransfer> >::iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (*it == aTransfer)
            {
                mData.mTransfers.erase(it);
                Log2Func(("Removed transfer: cTransfers=%zu\n", mData.mTransfers.size()));
                fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
                fRemoved = true;
                break;
            }
    }

    if (fRemoved && fFireEvent)
    {
        Log2Func(("Firing transfer removed event: transfer=%p\n", (void *)aTransfer));
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Removed, com::Utf8Str(), ClipboardError_None);
    }
    else if (!fRemoved)
        Log2Func(("Transfer not found for remove: transfer=%p\n", (void *)aTransfer));
    return S_OK;
}


/**
 * Cancels a clipboard transfer.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to cancel.
 */
HRESULT ClipboardTransferManager::cancel(const ComPtr<IClipboardTransfer> &aTransfer)
{
    Log2Func(("aTransfer=%p\n", (void *)aTransfer));
    if (aTransfer.isNull())
    {
        LogFunc(("Rejecting NULL transfer cancel\n"));
        return E_INVALIDARG;
    }

    bool fCanceled = false;
    bool fFireEvent = false;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        for (std::vector<ComPtr<IClipboardTransfer> >::iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (*it == aTransfer)
            {
                mData.mTransfers.erase(it);
                Log2Func(("Canceled transfer: cTransfers=%zu\n", mData.mTransfers.size()));
                fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
                fCanceled = true;
                break;
            }
    }

    if (fCanceled && fFireEvent)
    {
        Log2Func(("Firing transfer canceled event: transfer=%p\n", (void *)aTransfer));
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Canceled, com::Utf8Str(), ClipboardError_None);
    }
    else if (!fCanceled)
        Log2Func(("Transfer not found for cancel: transfer=%p\n", (void *)aTransfer));
    return S_OK;
}


/**
 * Resets all clipboard transfers.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransferManager::reset()
{
    LogFunc(("Resetting transfer manager via public API\n"));
    ComPtr<IEventSource> ptrEventSource;
    std::vector<ComPtr<IClipboardTransfer> > aTransfers;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        ptrEventSource = mData.mEventSource;
        aTransfers = mData.mTransfers;
        mData.mTransfers.clear();
        Log2Func(("Detached %zu transfers during public reset\n", aTransfers.size()));
    }

    RT_NOREF(ptrEventSource);
    for (std::vector<ComPtr<IClipboardTransfer> >::const_iterator it = aTransfers.begin();
         it != aTransfers.end(); ++it)
    {
        Log2Func(("Firing transfer removed event during public reset: transfer=%p\n", (void *)*it));
        i_fireTransferEvent(*it, ClipboardTransferState_Removed, com::Utf8Str(), ClipboardError_None);
    }
    return S_OK;
}
