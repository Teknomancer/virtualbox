/* $Id: ClipboardTransferManagerImpl.cpp 114614 2026-07-03 17:00:30Z andreas.loeffler@oracle.com $ */
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
#include "ClipboardTransferImpl.h"
#include "ClipboardTransferManagerImpl.h"
#include "GuestShClHelpers.h"
#include "ProgressImpl.h"
#include "VBoxEvents.h"

#include <VBox/com/ErrorInfo.h>
#include <VBox/GuestHost/SharedClipboard.h>
#include <VBox/log.h>

#include <iprt/errcore.h>
#include <iprt/string.h>


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


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
/**
 * Checks whether a transfer key is usable for Main-side lifecycle tracking.
 *
 * @returns true if the key identifies a non-nil service transfer, false otherwise.
 * @param   idSession       Service session ID.
 * @param   idTransfer      Service transfer ID.
 * @param   uGeneration     Service transfer generation.
 */
static bool clipboardTransferManagerKeyIsValid(SHCLSESSIONID idSession, ULONG idTransfer, SHCLTRANSFERGEN uGeneration)
{
    return    idSession != 0
           && idSession != NIL_SHCLSESSIONID
           && idTransfer > 0
           && idTransfer < VBOX_SHCL_MAX_TRANSFERS - 1
           && uGeneration != 0
           && uGeneration != NIL_SHCLTRANSFERGEN;
}


/**
 * Checks whether a transfer status ends the Main transfer record lifecycle.
 *
 * @returns true if the status is terminal, false otherwise.
 * @param   enmStatus       Transfer status to classify.
 */
static bool clipboardTransferManagerStatusIsTerminal(SHCLTRANSFERSTATUS enmStatus)
{
    return    enmStatus == SHCLTRANSFERSTATUS_COMPLETED
           || enmStatus == SHCLTRANSFERSTATUS_CANCELED
           || enmStatus == SHCLTRANSFERSTATUS_KILLED
           || enmStatus == SHCLTRANSFERSTATUS_ERROR
           || enmStatus == SHCLTRANSFERSTATUS_UNINITIALIZED;
}


/**
 * Converts a transfer status to the corresponding public Main transfer state.
 *
 * @returns Public Main transfer state.
 * @param   enmStatus       Transfer status to convert.
 */
static ClipboardTransferState_T clipboardTransferManagerStatusToState(SHCLTRANSFERSTATUS enmStatus)
{
    switch (enmStatus)
    {
        case SHCLTRANSFERSTATUS_REQUESTED:
        case SHCLTRANSFERSTATUS_INITIALIZED:
            return ClipboardTransferState_Added;
        case SHCLTRANSFERSTATUS_STARTED:
            return ClipboardTransferState_InProgress;
        case SHCLTRANSFERSTATUS_COMPLETED:
            return ClipboardTransferState_Completed;
        case SHCLTRANSFERSTATUS_CANCELED:
            return ClipboardTransferState_Canceled;
        case SHCLTRANSFERSTATUS_UNINITIALIZED:
            return ClipboardTransferState_Removed;
        case SHCLTRANSFERSTATUS_KILLED:
        case SHCLTRANSFERSTATUS_ERROR:
            return ClipboardTransferState_Failed;
        default:
            return ClipboardTransferState_Added;
    }
}


/**
 * Converts a failed transfer status to the public Main clipboard error value.
 *
 * @returns Public Main clipboard error value.
 * @param   enmStatus       Transfer status to convert.
 * @param   vrcTransfer     Transfer result code.
 */
static ClipboardError_T clipboardTransferManagerStatusToError(SHCLTRANSFERSTATUS enmStatus, int vrcTransfer)
{
    if (enmStatus == SHCLTRANSFERSTATUS_ERROR || enmStatus == SHCLTRANSFERSTATUS_KILLED)
    {
        if (vrcTransfer == VERR_ACCESS_DENIED)
            return ClipboardError_AccessDenied;
        if (vrcTransfer == VERR_NOT_SUPPORTED)
            return ClipboardError_NotSupported;
        return ClipboardError_OperationFailed;
    }
    return ClipboardError_None;
}


/**
 * Converts a transfer status to a progress completion HRESULT.
 *
 * @returns Progress completion HRESULT.
 * @param   enmStatus       Transfer status to convert.
 * @param   vrcTransfer     Transfer result code.
 */
static HRESULT clipboardTransferManagerStatusToProgressHrc(SHCLTRANSFERSTATUS enmStatus, int vrcTransfer)
{
    switch (enmStatus)
    {
        case SHCLTRANSFERSTATUS_COMPLETED:
            return S_OK;
        case SHCLTRANSFERSTATUS_CANCELED:
        case SHCLTRANSFERSTATUS_UNINITIALIZED:
            return E_ABORT;
        case SHCLTRANSFERSTATUS_KILLED:
        case SHCLTRANSFERSTATUS_ERROR:
            if (vrcTransfer == VERR_ACCESS_DENIED)
                return VBOX_E_SHCL_ACCESS_DENIED;
            return VBOX_E_SHCL_ERROR;
        default:
            return VBOX_E_SHCL_ERROR;
    }
}


/**
 * Completes a transfer progress object from a terminal service status.
 *
 * @param   ptrProgressControl  Internal progress control to complete. Optional.
 * @param   enmStatus           Terminal service transfer status.
 * @param   vrcTransfer         Service transfer result code.
 */
static void clipboardTransferManagerCompleteProgress(const ComPtr<IInternalProgressControl> &ptrProgressControl,
                                                     SHCLTRANSFERSTATUS enmStatus, int vrcTransfer)
{
    if (ptrProgressControl.isNull())
        return;

    HRESULT hrc = ptrProgressControl->NotifyComplete((LONG)clipboardTransferManagerStatusToProgressHrc(enmStatus, vrcTransfer),
                                                     NULL /* aErrorInfo */);
    AssertComRC(hrc);
}


/**
 * Validates an optional transfer-relative interaction path.
 *
 * @returns COM status code.
 * @param   aPath           Path to validate.
 * @param   fAllowEmpty     Whether the empty path is accepted.
 */
static HRESULT clipboardTransferManagerValidatePath(const com::Utf8Str &aPath, bool fAllowEmpty)
{
    if (aPath.isEmpty())
        return fAllowEmpty ? S_OK : E_INVALIDARG;

    const char *pszPath = aPath.c_str();
    if (   pszPath[0] == '/'
        || pszPath[0] == '\\'
        || strchr(pszPath, '\\')
        || strchr(pszPath, ':'))
        return E_INVALIDARG;

    const char *psz = pszPath;
    while (*psz)
    {
        const char *pszSlash = strchr(psz, '/');
        size_t const cchComponent = pszSlash ? (size_t)(pszSlash - psz) : strlen(psz);
        if (   cchComponent == 0
            || (cchComponent == 1 && psz[0] == '.')
            || (cchComponent == 2 && psz[0] == '.' && psz[1] == '.'))
            return E_INVALIDARG;
        if (!pszSlash)
            break;
        psz = pszSlash + 1;
    }
    return S_OK;
}
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */


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
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    mData.mNextTransferId = 1;
#endif

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
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    mData.mNextTransferId = 1;
#endif
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
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    std::vector<ComPtr<IInternalProgressControl> > aProgressControls;
#endif
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        ptrEventSource = mData.mEventSource;
        for (std::vector<Data::TransferRecord>::const_iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
        {
            aTransfers.push_back(it->mTransfer);
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
            if (it->mProgressControl.isNotNull())
                aProgressControls.push_back(it->mProgressControl);
#endif
        }
        mData.mTransfers.clear();
        Log2Func(("Detached %zu transfers during reset\n", aTransfers.size()));
    }

    RT_NOREF(ptrEventSource);
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    for (std::vector<ComPtr<IInternalProgressControl> >::const_iterator it = aProgressControls.begin();
         it != aProgressControls.end(); ++it)
        clipboardTransferManagerCompleteProgress(*it, SHCLTRANSFERSTATUS_UNINITIALIZED, VERR_CANCELLED);
#endif
    for (std::vector<ComPtr<IClipboardTransfer> >::const_iterator it = aTransfers.begin();
         it != aTransfers.end(); ++it)
    {
        Log2Func(("Firing transfer removed event during reset: transfer=%p\n", (void *)*it));
        i_fireTransferEvent(*it, ClipboardTransferState_Removed, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), ClipboardError_None);
    }
}


/**
 * Fires a clipboard transfer event through the parent clipboard object when available.
 * If there is no parent clipboard object, emits an anonymous event directly on
 * the stored event source.
 *
 * @param   aTransfer       Transfer associated with the event.
 * @param   aState          Transfer state.
 * @param   aInteraction    Transfer interaction type.
 * @param   aPath           Transfer-relative path associated with the event, if any.
 * @param   aMessage        Optional event message.
 * @param   aError          Clipboard transfer error code.
 */
void ClipboardTransferManager::i_fireTransferEvent(IClipboardTransfer *aTransfer,
                                                   ClipboardTransferState_T aState,
                                                   ClipboardTransferInteraction_T aInteraction,
                                                   const com::Utf8Str &aPath,
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
            pParent->i_fireClipboardTransferEvent(VBOX_SHCL_MAIN_CLIENT_NONE, aTransfer, aState, aInteraction,
                                                  aPath, aMessage, aError);
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
                                     aTransfer, aState, aInteraction, Bstr(aPath).raw(), aMessage, aError);
    }
}


/**
 * Returns the current clipboard transfers.
 *
 * @returns COM status code.
 * @param   aDirection      Transfer direction filter.
 * @param   aFlags          Reserved flags, must be zero.
 * @param   aTransfers      Where to return the transfer list.
 */
HRESULT ClipboardTransferManager::getTransfers(ClipboardTransferDirection_T aDirection,
                                               ULONG aFlags,
                                               std::vector<ComPtr<IClipboardTransfer> > &aTransfers)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aDirection, aFlags, aTransfers);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

    if (aFlags != 0)
        return E_INVALIDARG;

    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aTransfers.clear();
    for (std::vector<Data::TransferRecord>::const_iterator it = mData.mTransfers.begin();
         it != mData.mTransfers.end(); ++it)
    {
        if (!it->mfPublished)
            continue;
        if (aDirection != ClipboardTransferDirection_Any)
        {
            ClipboardTransferDirection_T enmDirection = ClipboardTransferDirection_Any;
            HRESULT hrc = it->mTransfer->COMGETTER(Direction)(&enmDirection);
            if (FAILED(hrc))
                return hrc;
            if (enmDirection != aDirection)
                continue;
        }
        aTransfers.push_back(it->mTransfer);
    }
    Log3Func(("cTransfers=%zu\n", aTransfers.size()));
    return S_OK;
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
}


/**
 * Creates an unpublished Main-owned clipboard transfer.
 *
 * @returns COM status code.
 * @param   aDirection      Transfer direction.
 * @param   aSource         Clipboard source owning the transfer.
 * @param   aAction         Clipboard transfer action.
 * @param   aTransfer       Where to return the transfer object.
 */
HRESULT ClipboardTransferManager::createTransfer(ClipboardTransferDirection_T aDirection,
                                                 ClipboardSource_T aSource,
                                                 ClipboardAction_T aAction,
                                                 ComPtr<IClipboardTransfer> &aTransfer)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aDirection, aSource, aAction, aTransfer);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

    aTransfer.setNull();
    Log2Func(("aDirection=%RU32, aSource=%RU32, aAction=%RU32\n",
              (uint32_t)aDirection, (uint32_t)aSource, (uint32_t)aAction));
    if (   aDirection != ClipboardTransferDirection_ToGuest
        && aDirection != ClipboardTransferDirection_ToHost)
    {
        LogFunc(("Rejecting invalid clipboard transfer direction %RU32\n", (uint32_t)aDirection));
        return setError(E_INVALIDARG, tr("Invalid clipboard transfer direction %RU32"), (uint32_t)aDirection);
    }
    if (!ShClMainIsValidSource(aSource))
    {
        LogFunc(("Rejecting invalid clipboard transfer source %RU32\n", (uint32_t)aSource));
        return setError(E_INVALIDARG, tr("Invalid clipboard transfer source %RU32"), (uint32_t)aSource);
    }
    if (!ShClMainIsValidAction(aAction))
    {
        LogFunc(("Rejecting invalid clipboard transfer action %RU32\n", (uint32_t)aAction));
        return setError(E_INVALIDARG, tr("Invalid clipboard transfer action %RU32"), (uint32_t)aAction);
    }

    ULONG idTransfer;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        idTransfer = mData.mNextTransferId++;
        if (mData.mNextTransferId == 0)
            mData.mNextTransferId = 1;
    }

    ComObjPtr<ClipboardTransfer> ptrTransferObj;
    HRESULT hrc = ptrTransferObj.createObject();
    if (FAILED(hrc))
        return hrc;

    ComPtr<IClipboardItem> ptrItem;
    ComPtr<IProgress> ptrProgress;
    hrc = ptrTransferObj->init(idTransfer, aDirection, aSource, aAction, ptrItem, ptrProgress);
    if (FAILED(hrc))
        return hrc;

    ComPtr<IClipboardTransfer> ptrTransfer;
    hrc = ptrTransferObj.queryInterfaceTo(ptrTransfer.asOutParam());
    if (FAILED(hrc))
        return hrc;

    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        Data::TransferRecord Record;
        Record.mTransferId = idTransfer;
        Record.mTransfer = ptrTransfer;
        Record.mfPublished = false;
        mData.mTransfers.push_back(Record);
    }

    aTransfer = ptrTransfer;
    return S_OK;
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
}


/**
 * Adds a clipboard transfer.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to add.
 */
HRESULT ClipboardTransferManager::add(const ComPtr<IClipboardTransfer> &aTransfer)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aTransfer);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

    Log2Func(("aTransfer=%p\n", (void *)aTransfer));
    if (aTransfer.isNull())
    {
        LogFunc(("Rejecting NULL transfer add\n"));
        return E_INVALIDARG;
    }

    ULONG idTransfer = 0;
    HRESULT hrc = aTransfer->COMGETTER(Id)(&idTransfer);
    if (FAILED(hrc))
        return hrc;

    bool fFireEvent = false;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        bool fKnown = false;
        for (std::vector<Data::TransferRecord>::iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (it->mTransfer == aTransfer)
            {
                if (it->mfPublished)
                    return S_OK;
                it->mfPublished = true;
                fKnown = true;
                Log2Func(("Published existing transfer: cTransfers=%zu\n", mData.mTransfers.size()));
                break;
            }

        if (!fKnown)
        {
            Data::TransferRecord Record;
            Record.mTransferId = idTransfer;
            Record.mTransfer = aTransfer;
            Record.mfPublished = true;
            mData.mTransfers.push_back(Record);
            Log2Func(("Added transfer: cTransfers=%zu\n", mData.mTransfers.size()));
        }
        fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
    }

    if (fFireEvent)
    {
        Log2Func(("Firing transfer added event: transfer=%p\n", (void *)aTransfer));
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Added, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), ClipboardError_None);
    }
    return S_OK;
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
}


/**
 * Removes a clipboard transfer.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to remove.
 */
HRESULT ClipboardTransferManager::remove(const ComPtr<IClipboardTransfer> &aTransfer)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aTransfer);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

    Log2Func(("aTransfer=%p\n", (void *)aTransfer));
    if (aTransfer.isNull())
    {
        LogFunc(("Rejecting NULL transfer remove\n"));
        return E_INVALIDARG;
    }

    bool fRemoved = false;
    bool fFireEvent = false;
    ComPtr<IInternalProgressControl> ptrProgressControl;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        for (std::vector<Data::TransferRecord>::iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (it->mTransfer == aTransfer)
            {
                ptrProgressControl = it->mProgressControl;
                mData.mTransfers.erase(it);
                Log2Func(("Removed transfer: cTransfers=%zu\n", mData.mTransfers.size()));
                fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
                fRemoved = true;
                break;
            }
    }

    if (fRemoved)
        clipboardTransferManagerCompleteProgress(ptrProgressControl, SHCLTRANSFERSTATUS_UNINITIALIZED, VERR_CANCELLED);
    if (fRemoved && fFireEvent)
    {
        Log2Func(("Firing transfer removed event: transfer=%p\n", (void *)aTransfer));
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Removed, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), ClipboardError_None);
    }
    else if (!fRemoved)
        Log2Func(("Transfer not found for remove: transfer=%p\n", (void *)aTransfer));
    return S_OK;
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
}


/**
 * Cancels a clipboard transfer.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to cancel.
 */
HRESULT ClipboardTransferManager::cancel(const ComPtr<IClipboardTransfer> &aTransfer)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aTransfer);
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

    Log2Func(("aTransfer=%p\n", (void *)aTransfer));
    if (aTransfer.isNull())
    {
        LogFunc(("Rejecting NULL transfer cancel\n"));
        return E_INVALIDARG;
    }

    bool fCanceled = false;
    bool fFireEvent = false;
    bool fNeedsHostCancel = false;
    SHCLSESSIONID idSession = NIL_SHCLSESSIONID;
    ULONG idTransfer = 0;
    SHCLTRANSFERGEN uGeneration = NIL_SHCLTRANSFERGEN;
    ComPtr<IInternalProgressControl> ptrProgressControl;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        for (std::vector<Data::TransferRecord>::iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (it->mTransfer == aTransfer)
            {
                idSession = it->mServiceSessionId;
                idTransfer = it->mTransferId;
                uGeneration = it->mGeneration;
                fNeedsHostCancel = clipboardTransferManagerKeyIsValid(idSession, idTransfer, uGeneration);
                if (!fNeedsHostCancel)
                {
                    ptrProgressControl = it->mProgressControl;
                    mData.mTransfers.erase(it);
                    Log2Func(("Canceled transfer: cTransfers=%zu\n", mData.mTransfers.size()));
                    fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
                    fCanceled = true;
                }
                else
                    it->mfCancelRequested = true;
                break;
            }
    }

    if (fNeedsHostCancel)
    {
        Clipboard *pParent = NULL;
        AutoCaller autoCaller;
        {
            AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
            pParent = mData.mParent;
            if (pParent)
                autoCaller.attach(pParent);
        }
        if (!pParent)
            return E_FAIL;
        if (FAILED(autoCaller.hrc()))
            return autoCaller.hrc();

        HRESULT hrc = pParent->i_transferCancel(idSession, (SHCLTRANSFERID)idTransfer, uGeneration);
        if (FAILED(hrc))
            return hrc;

        {
            AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
            for (std::vector<Data::TransferRecord>::iterator it = mData.mTransfers.begin();
                 it != mData.mTransfers.end(); ++it)
                if (it->mTransfer == aTransfer)
                {
                    ptrProgressControl = it->mProgressControl;
                    mData.mTransfers.erase(it);
                    Log2Func(("Canceled transfer after host request: cTransfers=%zu\n", mData.mTransfers.size()));
                    fFireEvent = mData.mParent != NULL || mData.mEventSource.isNotNull();
                    fCanceled = true;
                    break;
                }
        }
    }

    if (fCanceled)
        clipboardTransferManagerCompleteProgress(ptrProgressControl, SHCLTRANSFERSTATUS_CANCELED, VERR_CANCELLED);
    if (fCanceled && fFireEvent)
    {
        Log2Func(("Firing transfer canceled event: transfer=%p\n", (void *)aTransfer));
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Canceled, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), ClipboardError_None);
    }
    else if (!fCanceled)
        Log2Func(("Transfer not found for cancel: transfer=%p\n", (void *)aTransfer));
    return S_OK;
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
}


/**
 * Approves a transfer waiting for client approval.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to approve.
 * @param   aFlags          Reserved approval flags.
 */
HRESULT ClipboardTransferManager::approve(const ComPtr<IClipboardTransfer> &aTransfer, ULONG aFlags)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aTransfer, aFlags);
    ReturnComNotImplemented();
#else
    if (aFlags != 0)
        return E_INVALIDARG;
    return respond(aTransfer, ClipboardTransferInteraction_Approval, com::Utf8Str(), ClipboardTransferResponse_Accept,
                   com::Utf8Str(), 0);
#endif
}


/**
 * Denies a transfer waiting for client approval.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to deny.
 * @param   aReason         Optional denial reason.
 */
HRESULT ClipboardTransferManager::deny(const ComPtr<IClipboardTransfer> &aTransfer, const com::Utf8Str &aReason)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aTransfer, aReason);
    ReturnComNotImplemented();
#else
    HRESULT hrc = respond(aTransfer, ClipboardTransferInteraction_Approval, com::Utf8Str(), ClipboardTransferResponse_Reject,
                          com::Utf8Str(), 0);
    if (SUCCEEDED(hrc) && aReason.isNotEmpty())
        i_fireTransferEvent(aTransfer, ClipboardTransferState_Canceled, ClipboardTransferInteraction_Approval,
                            com::Utf8Str(), aReason, ClipboardError_AccessDenied);
    return hrc;
#endif
}


/**
 * Supplies a response to a transfer interaction request.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer waiting for interaction.
 * @param   aInteraction    Interaction being answered.
 * @param   aPath           Optional transfer-relative interaction path.
 * @param   aResponse       Client response.
 * @param   aResponsePath   Optional transfer-relative path supplied by the response.
 * @param   aFlags          Reserved response flags.
 */
HRESULT ClipboardTransferManager::respond(const ComPtr<IClipboardTransfer> &aTransfer,
                                          ClipboardTransferInteraction_T aInteraction,
                                          const com::Utf8Str &aPath,
                                          ClipboardTransferResponse_T aResponse,
                                          const com::Utf8Str &aResponsePath,
                                          ULONG aFlags)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aTransfer, aInteraction, aPath, aResponse, aResponsePath, aFlags);
    ReturnComNotImplemented();
#else
    if (aTransfer.isNull() || aInteraction == ClipboardTransferInteraction_None || aResponse == ClipboardTransferResponse_None)
        return E_INVALIDARG;
    if (aFlags != 0)
        return E_INVALIDARG;
    if (   aResponsePath.isNotEmpty()
        && aInteraction != ClipboardTransferInteraction_Destination
        && aInteraction != ClipboardTransferInteraction_Rename)
        return E_INVALIDARG;
    HRESULT hrc = clipboardTransferManagerValidatePath(aPath, true /* fAllowEmpty */);
    if (FAILED(hrc))
        return hrc;
    hrc = clipboardTransferManagerValidatePath(aResponsePath, true /* fAllowEmpty */);
    if (FAILED(hrc))
        return hrc;

    bool fKnown = false;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        for (std::vector<Data::TransferRecord>::const_iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (it->mTransfer == aTransfer)
            {
                fKnown = true;
                break;
            }
    }
    if (!fKnown)
        return VBOX_E_OBJECT_NOT_FOUND;

    ClipboardTransferState_T const enmState = aResponse == ClipboardTransferResponse_Reject
                                            || aResponse == ClipboardTransferResponse_Cancel
                                          ? ClipboardTransferState_Canceled : ClipboardTransferState_InProgress;
    ClipboardError_T const enmError = enmState == ClipboardTransferState_Canceled
                                    ? ClipboardError_AccessDenied : ClipboardError_None;
    i_fireTransferEvent(aTransfer, enmState, aInteraction, aPath, com::Utf8Str(), enmError);
    return S_OK;
#endif
}


/**
 * Pauses a running transfer when supported.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to pause.
 */
HRESULT ClipboardTransferManager::pause(const ComPtr<IClipboardTransfer> &aTransfer)
{
    RT_NOREF(aTransfer);
    return E_NOTIMPL;
}


/**
 * Resumes a paused transfer when supported.
 *
 * @returns COM status code.
 * @param   aTransfer       Transfer to resume.
 */
HRESULT ClipboardTransferManager::resume(const ComPtr<IClipboardTransfer> &aTransfer)
{
    RT_NOREF(aTransfer);
    return E_NOTIMPL;
}


/**
 * Resets all clipboard transfers.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransferManager::reset()
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    ReturnComNotImplemented();
#else /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */

    LogFunc(("Resetting transfer manager via public API\n"));
    ComPtr<IEventSource> ptrEventSource;
    std::vector<ComPtr<IClipboardTransfer> > aTransfers;
    std::vector<ComPtr<IInternalProgressControl> > aProgressControls;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        ptrEventSource = mData.mEventSource;
        for (std::vector<Data::TransferRecord>::const_iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
        {
            aTransfers.push_back(it->mTransfer);
            if (it->mProgressControl.isNotNull())
                aProgressControls.push_back(it->mProgressControl);
        }
        mData.mTransfers.clear();
        Log2Func(("Detached %zu transfers during public reset\n", aTransfers.size()));
    }

    RT_NOREF(ptrEventSource);
    for (std::vector<ComPtr<IInternalProgressControl> >::const_iterator it = aProgressControls.begin();
         it != aProgressControls.end(); ++it)
        clipboardTransferManagerCompleteProgress(*it, SHCLTRANSFERSTATUS_UNINITIALIZED, VERR_CANCELLED);
    for (std::vector<ComPtr<IClipboardTransfer> >::const_iterator it = aTransfers.begin();
         it != aTransfers.end(); ++it)
    {
        Log2Func(("Firing transfer removed event during public reset: transfer=%p\n", (void *)*it));
        i_fireTransferEvent(*it, ClipboardTransferState_Removed, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), ClipboardError_None);
    }
    return S_OK;
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
}


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
/**
 * Handles a Shared Clipboard transfer status from the host service.
 *
 * @returns COM status code.
 * @param   aServiceSessionId   Service session that owns the transfer.
 * @param   aTransferId         Shared Clipboard transfer ID.
 * @param   aGeneration         Host-private transfer generation.
 * @param   enmShClSource       Shared Clipboard status source.
 * @param   enmStatus           Transfer lifecycle status.
 * @param   vrcTransfer         Transfer result code associated with the status.
 */
HRESULT ClipboardTransferManager::i_handleTransferStatus(SHCLSESSIONID aServiceSessionId,
                                                         SHCLTRANSFERID aTransferId,
                                                         SHCLTRANSFERGEN aGeneration,
                                                         SHCLSOURCE enmShClSource,
                                                         SHCLTRANSFERSTATUS enmStatus,
                                                         int vrcTransfer)
{
    SHCLSESSIONID const idSession = aServiceSessionId;
    SHCLTRANSFERID const idTransfer = aTransferId;
    SHCLTRANSFERGEN const uGeneration = aGeneration;
    if (!clipboardTransferManagerKeyIsValid(idSession, idTransfer, uGeneration))
        return E_INVALIDARG;
    if (enmStatus == SHCLTRANSFERSTATUS_NONE)
        return S_OK;

    ClipboardTransferState_T const enmState = clipboardTransferManagerStatusToState(enmStatus);
    ClipboardError_T const enmError = clipboardTransferManagerStatusToError(enmStatus, vrcTransfer);
    bool const fTerminal = clipboardTransferManagerStatusIsTerminal(enmStatus);

    ComPtr<IClipboardTransfer> ptrTransfer;
    ComPtr<IProgress> ptrProgress;
    ComPtr<IInternalProgressControl> ptrProgressControl;
    bool fFireAdded = false;
    bool fFireState = false;

    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);

        size_t idxRecord = mData.mTransfers.size();
        for (size_t i = 0; i < mData.mTransfers.size(); ++i)
            if (   mData.mTransfers[i].mServiceSessionId == idSession
                && mData.mTransfers[i].mTransferId == idTransfer
                && mData.mTransfers[i].mGeneration == uGeneration)
            {
                idxRecord = i;
                break;
            }

        if (idxRecord == mData.mTransfers.size())
        {
            if (fTerminal)
            {
                Log2Func(("Ignoring terminal status for unknown transfer: session=%RU16, id=%RU16, generation=%RU64, status=%RU32\n",
                          idSession, idTransfer, uGeneration, (uint32_t)enmStatus));
                return S_OK;
            }

            ComObjPtr<Progress> ptrNewProgress;
            HRESULT hrc = ptrNewProgress.createObject();
            if (FAILED(hrc))
                return hrc;
            hrc = ptrNewProgress->init(FALSE /* aCancelable */, 1 /* aOperationCount */,
                                       com::Utf8Str("Shared Clipboard transfer"));
            if (FAILED(hrc))
                return hrc;

            ComPtr<IProgress> ptrIProgress;
            hrc = ptrNewProgress.queryInterfaceTo(ptrIProgress.asOutParam());
            if (FAILED(hrc))
                return hrc;

            ComPtr<IInternalProgressControl> ptrIProgressControl(ptrIProgress);
            if (ptrIProgressControl.isNull())
                return E_FAIL;

            ComObjPtr<ClipboardTransfer> ptrNewTransfer;
            hrc = ptrNewTransfer.createObject();
            if (FAILED(hrc))
                return hrc;

            ClipboardTransferDirection_T const enmDirection = enmShClSource == SHCLSOURCE_REMOTE
                                                            ? ClipboardTransferDirection_ToHost
                                                            : ClipboardTransferDirection_ToGuest;
            ClipboardSource_T const enmSource = enmShClSource == SHCLSOURCE_REMOTE
                                              ? ClipboardSource_Guest
                                              : ClipboardSource_Host;
            ComPtr<IClipboardItem> ptrItem;
            hrc = ptrNewTransfer->init(idTransfer, enmDirection, enmSource, ClipboardAction_Copy, ptrItem, ptrIProgress);
            if (FAILED(hrc))
                return hrc;

            ComPtr<IClipboardTransfer> ptrITransfer;
            hrc = ptrNewTransfer.queryInterfaceTo(ptrITransfer.asOutParam());
            if (FAILED(hrc))
                return hrc;

            Data::TransferRecord Record;
            Record.mServiceSessionId = idSession;
            Record.mTransferId = idTransfer;
            Record.mGeneration = uGeneration;
            Record.mStatus = enmStatus;
            Record.mState = ClipboardTransferState_Added;
            Record.mTransfer = ptrITransfer;
            Record.mfPublished = true;
            Record.mProgress = ptrIProgress;
            Record.mProgressControl = ptrIProgressControl;
            mData.mTransfers.push_back(Record);
            idxRecord = mData.mTransfers.size() - 1;
            fFireAdded = true;
        }

        Data::TransferRecord &Record = mData.mTransfers[idxRecord];
        ptrTransfer = Record.mTransfer;
        ptrProgress = Record.mProgress;
        ptrProgressControl = Record.mProgressControl;
        if (fTerminal)
        {
            Record.mStatus = enmStatus;
            Record.mState = enmState;
            Record.mfTerminal = true;
            fFireState = true;
            mData.mTransfers.erase(mData.mTransfers.begin() + idxRecord);
        }
        else if (enmState != ClipboardTransferState_Added && Record.mState != enmState)
        {
            Record.mStatus = enmStatus;
            Record.mState = enmState;
            fFireState = true;
        }
        else
            Record.mStatus = enmStatus;
    }

    RT_NOREF(ptrProgress);

    if (fTerminal)
        clipboardTransferManagerCompleteProgress(ptrProgressControl, enmStatus, vrcTransfer);

    if (fFireAdded)
        i_fireTransferEvent(ptrTransfer, ClipboardTransferState_Added, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), ClipboardError_None);
    if (fFireState)
        i_fireTransferEvent(ptrTransfer, enmState, ClipboardTransferInteraction_None,
                            com::Utf8Str(), com::Utf8Str(), enmError);

    return S_OK;
}


/**
 * Cancels the single live transfer with the given public transfer ID.
 *
 * @returns COM status code.
 * @param   aTransferId     Public transfer ID to resolve.
 */
HRESULT ClipboardTransferManager::i_cancelTransferById(ULONG aTransferId)
{
    ComPtr<IClipboardTransfer> ptrTransfer;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        for (std::vector<Data::TransferRecord>::const_iterator it = mData.mTransfers.begin();
             it != mData.mTransfers.end(); ++it)
            if (it->mTransferId == aTransferId)
            {
                if (ptrTransfer.isNotNull())
                    return E_INVALIDARG;
                ptrTransfer = it->mTransfer;
            }
    }

    if (ptrTransfer.isNull())
        return E_INVALIDARG;

    return cancel(ptrTransfer);
}
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */
