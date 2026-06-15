/* $Id: ClipboardSettingsImpl.cpp 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard API.
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

#include "MachineImpl.h"
#include "AutoCaller.h"
#include "ClipboardSettingsImpl.h"

#include <VBox/settings.h>

#include <iprt/errcore.h>


////////////////////////////////////////////////////////////////////////////////
//
// Clipboard settings private data definition
//
////////////////////////////////////////////////////////////////////////////////

struct ClipboardSettings::Data
{
    Data()
        : mParent(NULL)
        , mPeer(NULL)
    { }

    /** Parent machine. */
    Machine * const mParent;
    /** Peer clipboard object. */
    const ComObjPtr<ClipboardSettings> mPeer;
    /** Clipboard settings. */
    Backupable<settings::Clipboard> bd;
};


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(ClipboardSettings)


/**
 * Completes construction of a clipboard control object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardSettings::FinalConstruct()
{
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard control object.
 */
void ClipboardSettings::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a clipboard control object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardSettings::init(Machine *aParent /* = NULL */)
{
    Log2Func(("aParent=%p\n", aParent));
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData = new Data;
    unconst(mData->mParent) = aParent;
    /* mPeer is left null */
    mData->bd.allocate();

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Initializes a clipboard control object given another clipboard object.
 *
 * The new object shares settings data with the original object while keeping
 * runtime clipboard contents and transfer state private.
 *
 * @returns COM status code.
 */
HRESULT ClipboardSettings::init(Machine *aParent, ClipboardSettings *aThat)
{
    Log2Func(("aParent=%p, aThat=%p\n", aParent, aThat));
    ComAssertRet(aParent && aThat, E_INVALIDARG);

    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData = new Data;
    unconst(mData->mParent) = aParent;
    unconst(mData->mPeer)   = aThat;
    {
        AutoCaller thatCaller(aThat);
        AssertComRCReturnRC(thatCaller.hrc());

        AutoReadLock thatLock(aThat COMMA_LOCKVAL_SRC_POS);
        mData->bd.share(aThat->mData->bd);
    }

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Initializes a clipboard control object as a private copy of another clipboard object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardSettings::initCopy(Machine *aParent, ClipboardSettings *aThat)
{
    Log2Func(("aParent=%p, aThat=%p\n", aParent, aThat));
    ComAssertRet(aParent && aThat, E_INVALIDARG);

    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData = new Data;
    unconst(mData->mParent) = aParent;
    /* mPeer is left null */
    {
        AutoCaller thatCaller(aThat);
        AssertComRCReturnRC(thatCaller.hrc());

        AutoReadLock thatLock(aThat COMMA_LOCKVAL_SRC_POS);
        mData->bd.attachCopy(aThat->mData->bd);
    }

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard control object.
 */
void ClipboardSettings::uninit()
{
    Log3Func(("mData=%p\n", mData));
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    unconst(mData->mParent) = NULL;
    unconst(mData->mPeer).setNull();
    mData->bd.free();
    delete mData;
    mData = NULL;
}


/**
 * Gets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        Where to return the file transfer enabled state.
 */
HRESULT ClipboardSettings::i_getFileTransfersEnabled(BOOL *aEnabled)
{
    AssertPtrReturn(aEnabled, E_POINTER);

    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aEnabled = mData->bd->fFileTransfersEnabled;
    Log3Func(("aEnabled=%RTbool\n", RT_BOOL(*aEnabled)));
    return S_OK;
}


/**
 * Gets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        Where to return the file transfer enabled state.
 */
HRESULT ClipboardSettings::getFileTransfersEnabled(BOOL *aEnabled)
{
    return i_getFileTransfersEnabled(aEnabled);
}


/**
 * Sets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        New file transfer enabled state.
 */
HRESULT ClipboardSettings::i_setFileTransfersEnabled(BOOL aEnabled)
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);

    if (mData->bd->fFileTransfersEnabled != aEnabled)
    {
        LogFunc(("Changing file transfer setting: old=%RTbool, new=%RTbool\n",
                 mData->bd->fFileTransfersEnabled, RT_BOOL(aEnabled)));
        mData->bd.backup();
        mData->bd->fFileTransfersEnabled = RT_BOOL(aEnabled);

        alock.release();
    }
    else
        Log3Func(("File transfer setting unchanged: enabled=%RTbool\n", RT_BOOL(aEnabled)));
    return S_OK;
}


/**
 * Notifies the parent machine about a clipboard file transfer mode change.
 *
 * @returns COM status code.
 * @param   aEnable         New file transfer enabled state.
 */
HRESULT ClipboardSettings::i_notifyClipboardFileTransferModeChange(BOOL aEnable)
{
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData->mParent;
    }

    if (!pParent)
    {
        Log3Func(("No parent for file transfer mode notification: aEnable=%RTbool\n", RT_BOOL(aEnable)));
        return S_OK;
    }

    Log2Func(("Notifying parent about file transfer mode: aEnable=%RTbool\n", RT_BOOL(aEnable)));
    return pParent->i_onClipboardFileTransferModeChange(aEnable);
}


/**
 * Sets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        New file transfer enabled state.
 */
HRESULT ClipboardSettings::setFileTransfersEnabled(BOOL aEnabled)
{
    LogFunc(("aEnabled=%RTbool\n", RT_BOOL(aEnabled)));
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData->mParent;
    }

    if (pParent)
    {
        HRESULT hrc = pParent->i_checkClipboardSettingsChangeAllowed();
        if (FAILED(hrc))
            return hrc;

        hrc = i_notifyClipboardFileTransferModeChange(aEnabled);
        if (FAILED(hrc))
            return hrc;

        hrc = i_setFileTransfersEnabled(aEnabled);
        if (FAILED(hrc))
            return hrc;

        pParent->i_onSettingsChanged();
        return S_OK;
    }

    return i_setFileTransfersEnabled(aEnabled);
}


/**
 * Loads clipboard settings.
 *
 * @returns COM status code.
 * @param   data            Clipboard settings to load.
 */
HRESULT ClipboardSettings::i_loadSettings(const settings::Clipboard &data)
{
    LogFunc(("mode=%RU32, fFileTransfersEnabled=%RTbool\n", (uint32_t)data.mode, data.fFileTransfersEnabled));
    AutoCaller autoCaller(this);
    AssertComRCReturnRC(autoCaller.hrc());

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);

    mData->bd->mode                  = data.mode;
    mData->bd->fFileTransfersEnabled = data.fFileTransfersEnabled;
    return S_OK;
}


/**
 * Saves clipboard settings.
 *
 * @returns COM status code.
 * @param   data            Where to save clipboard settings.
 */
HRESULT ClipboardSettings::i_saveSettings(settings::Clipboard &data)
{
    Log3Func(("\n"));
    AutoCaller autoCaller(this);
    AssertComRCReturnRC(autoCaller.hrc());

    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);

    data.mode                  = mData->bd->mode;
    data.fFileTransfersEnabled = mData->bd->fFileTransfersEnabled;
    Log3Func(("mode=%RU32, fFileTransfersEnabled=%RTbool\n", (uint32_t)data.mode, data.fFileTransfersEnabled));
    return S_OK;
}


/**
 * Applies default clipboard settings.
 */
void ClipboardSettings::i_applyDefaults(void)
{
    LogFunc(("Applying default clipboard settings\n"));
    AutoCaller autoCaller(this);
    AssertComRCReturnVoid(autoCaller.hrc());

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);

    mData->bd->mode                  = ClipboardMode_Disabled;
    mData->bd->fFileTransfersEnabled = false;
}


/**
 * Rolls back settings changes made to this clipboard object.
 */
void ClipboardSettings::i_rollback()
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    LogFunc(("Rolling back clipboard settings: fBackedUp=%RTbool\n", mData->bd.isBackedUp()));
    mData->bd.rollback();
}


/**
 * Commits settings changes made to this clipboard object.
 */
void ClipboardSettings::i_commit()
{
    LogFunc(("Committing clipboard settings\n"));
    /* sanity */
    AutoCaller autoCaller(this);
    AssertComRCReturnVoid(autoCaller.hrc());

    /* sanity too */
    AutoCaller peerCaller(mData->mPeer);
    AssertComRCReturnVoid(peerCaller.hrc());

    /* lock both for writing since we modify both (mPeer is "master" so locked
     * first) */
    AutoMultiWriteLock2 alock(mData->mPeer, this COMMA_LOCKVAL_SRC_POS);

    if (mData->bd.isBackedUp())
    {
        Log2Func(("Commit backed-up settings: mode=%RU32, fFileTransfersEnabled=%RTbool\n",
                  (uint32_t)mData->bd->mode, mData->bd->fFileTransfersEnabled));
        mData->bd.commit();
        if (mData->mPeer)
            mData->mPeer->mData->bd.attach(mData->bd);
    }
    else
        Log3Func(("No backed-up clipboard settings to commit\n"));
}


/**
 * Copies settings from a given clipboard object.
 *
 * @param   aThat           Clipboard object to copy settings from.
 */
void ClipboardSettings::i_copyFrom(ClipboardSettings *aThat)
{
    Log2Func(("aThat=%p\n", aThat));
    AssertReturnVoid(aThat != NULL);

    /* sanity */
    AutoCaller autoCaller(this);
    AssertComRCReturnVoid(autoCaller.hrc());

    /* sanity too */
    AutoCaller thatCaller(aThat);
    AssertComRCReturnVoid(thatCaller.hrc());

    /* peer is not modified, lock it for reading (aThat is "master" so locked
     * first) */
    AutoReadLock rl(aThat COMMA_LOCKVAL_SRC_POS);
    AutoWriteLock wl(this COMMA_LOCKVAL_SRC_POS);

    mData->bd.assignCopy(aThat->mData->bd);
    Log2Func(("Copied settings: mode=%RU32, fFileTransfersEnabled=%RTbool\n",
              (uint32_t)mData->bd->mode, mData->bd->fFileTransfersEnabled));
}


/**
 * Returns the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           Where to return the clipboard mode.
 */
HRESULT ClipboardSettings::getMode(ClipboardMode_T *aMode)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aMode = mData->bd->mode;
    Log3Func(("aMode=%RU32\n", (uint32_t)*aMode));
    return S_OK;
}


/**
 * Sets the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           New clipboard mode.
 */
HRESULT ClipboardSettings::i_setMode(ClipboardMode_T aMode)
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);

    if (mData->bd->mode != aMode)
    {
        LogFunc(("Changing clipboard mode: old=%RU32, new=%RU32\n", (uint32_t)mData->bd->mode, (uint32_t)aMode));
        mData->bd.backup();
        mData->bd->mode = aMode;

        alock.release();
    }
    else
        Log3Func(("Clipboard mode unchanged: mode=%RU32\n", (uint32_t)aMode));

    return S_OK;
}


/**
 * Notifies the parent machine about a clipboard mode change.
 *
 * @returns COM status code.
 * @param   aMode           New clipboard mode.
 */
HRESULT ClipboardSettings::i_notifyClipboardModeChange(ClipboardMode_T aMode)
{
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData->mParent;
    }

    if (!pParent)
    {
        Log3Func(("No parent for clipboard mode notification: aMode=%RU32\n", (uint32_t)aMode));
        return S_OK;
    }

    Log2Func(("Notifying parent about clipboard mode: aMode=%RU32\n", (uint32_t)aMode));
    return pParent->i_onClipboardModeChange(aMode);
}


/**
 * Sets the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           New clipboard mode.
 */
HRESULT ClipboardSettings::setMode(ClipboardMode_T aMode)
{
    LogFunc(("aMode=%RU32\n", (uint32_t)aMode));
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        if (mData->bd->mode == aMode)
        {
            Log3Func(("Mode already set: aMode=%RU32\n", (uint32_t)aMode));
            return S_OK;
        }
        pParent = mData->mParent;
    }

    if (pParent)
    {
        HRESULT hrc = pParent->i_checkClipboardSettingsChangeAllowed();
        if (FAILED(hrc))
            return hrc;

        hrc = i_notifyClipboardModeChange(aMode);
        if (FAILED(hrc))
            return hrc;

        hrc = i_setMode(aMode);
        if (FAILED(hrc))
            return hrc;

        pParent->i_onSettingsChanged();
        return S_OK;
    }

    return i_setMode(aMode);
}

