/* $Id: ClipboardImpl.cpp 114258 2026-06-04 13:34:20Z andreas.loeffler@oracle.com $ */
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

#define LOG_GROUP LOG_GROUP_MAIN
#include "LoggingNew.h"

#include "ClipboardImpl.h"
#include "AutoCaller.h"
#include "EventImpl.h"


// constructor / destructor
/////////////////////////////////////////////////////////////////////////////

DEFINE_EMPTY_CTOR_DTOR(ClipboardFormat)
DEFINE_EMPTY_CTOR_DTOR(ClipboardItem)
DEFINE_EMPTY_CTOR_DTOR(ClipboardTransfer)
DEFINE_EMPTY_CTOR_DTOR(ClipboardTransferManager)
DEFINE_EMPTY_CTOR_DTOR(Clipboard)


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
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mMimeType = aMimeType;
    return S_OK;
}


/**
 * Completes construction of a clipboard item object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardItem::FinalConstruct()
{
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
    return S_OK;
}


/**
 * Completes construction of a clipboard transfer object.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransfer::FinalConstruct()
{
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
    return S_OK;
}


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
 */
HRESULT ClipboardTransferManager::init()
{
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mTransfers.clear();

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard transfer manager object.
 */
void ClipboardTransferManager::uninit()
{
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mTransfers.clear();
}


/**
 * Resets the internally tracked transfer list.
 */
void ClipboardTransferManager::i_reset()
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mTransfers.clear();
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
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mTransfers.push_back(aTransfer);
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
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    for (std::vector<ComPtr<IClipboardTransfer> >::iterator it = mData.mTransfers.begin();
         it != mData.mTransfers.end(); ++it)
        if (*it == aTransfer)
        {
            mData.mTransfers.erase(it);
            return S_OK;
        }

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
    RT_NOREF(aTransfer);
    ReturnComNotImplemented();
}


/**
 * Resets all clipboard transfers.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransferManager::reset()
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mTransfers.clear();
    return S_OK;
}


/**
 * Completes construction of a clipboard control object.
 *
 * @returns COM status code.
 */
HRESULT Clipboard::FinalConstruct()
{
    mData.mMode = ClipboardMode_Disabled;
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard control object.
 */
void Clipboard::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


/**
 * Initializes a clipboard control object.
 *
 * @returns COM status code.
 */
HRESULT Clipboard::init()
{
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mMode = ClipboardMode_Disabled;
    mData.mFileList.clear();

    HRESULT hrc = mData.mTransfers.createObject();
    if (FAILED(hrc))
        return hrc;
    hrc = mData.mTransfers->init();
    if (FAILED(hrc))
        return hrc;

    ComObjPtr<EventSource> pEventSource;
    hrc = pEventSource.createObject();
    if (FAILED(hrc))
        return hrc;
    hrc = pEventSource->init();
    if (FAILED(hrc))
        return hrc;
    pEventSource.queryInterfaceTo(mData.mEventSource.asOutParam());

    autoInitSpan.setSucceeded();
    return S_OK;
}


/**
 * Uninitializes a clipboard control object.
 */
void Clipboard::uninit()
{
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    if (!mData.mTransfers.isNull())
        mData.mTransfers->uninit();
    mData.mTransfers.setNull();
    mData.mEventSource.setNull();
    mData.mFileList.clear();
    mData.mMode = ClipboardMode_Disabled;
}


/**
 * Returns the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           Where to return the clipboard mode.
 */
HRESULT Clipboard::getMode(ClipboardMode_T *aMode)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aMode = mData.mMode;
    return S_OK;
}


/**
 * Sets the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           New clipboard mode.
 */
HRESULT Clipboard::setMode(ClipboardMode_T aMode)
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mMode = aMode;
    return S_OK;
}


/**
 * Returns the clipboard file list.
 *
 * @returns COM status code.
 * @param   aFileList       Where to return the file list.
 */
HRESULT Clipboard::getFileList(std::vector<com::Utf8Str> &aFileList)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aFileList = mData.mFileList;
    return S_OK;
}


/**
 * Sets the clipboard file list.
 *
 * @returns COM status code.
 * @param   aFileList       New file list.
 */
HRESULT Clipboard::setFileList(const std::vector<com::Utf8Str> &aFileList)
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mFileList = aFileList;
    return S_OK;
}


/**
 * Returns the clipboard transfer manager.
 *
 * @returns COM status code.
 * @param   aTransfers      Where to return the transfer manager.
 */
HRESULT Clipboard::getTransfers(ComPtr<IClipboardTransferManager> &aTransfers)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    return mData.mTransfers.queryInterfaceTo(aTransfers.asOutParam());
}


/**
 * Returns the clipboard event source.
 *
 * @returns COM status code.
 * @param   aEventSource    Where to return the event source.
 */
HRESULT Clipboard::getEventSource(ComPtr<IEventSource> &aEventSource)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aEventSource = mData.mEventSource;
    return S_OK;
}


/**
 * Reads clipboard data for an action.
 *
 * @returns COM status code.
 * @param   aAction         Clipboard action to read data for.
 * @param   aItem           Where to return the clipboard item.
 */
HRESULT Clipboard::readData(ClipboardAction_T aAction, ComPtr<IClipboardItem> &aItem)
{
    RT_NOREF(aAction, aItem);
    ReturnComNotImplemented();
}


/**
 * Reads available clipboard formats.
 *
 * @returns COM status code.
 * @param   aFormats        Where to return the clipboard formats.
 */
HRESULT Clipboard::readFormats(std::vector<ComPtr<IClipboardFormat> > &aFormats)
{
    RT_NOREF(aFormats);
    ReturnComNotImplemented();
}


/**
 * Writes clipboard data for an action.
 *
 * @returns COM status code.
 * @param   aAction         Clipboard action to write data for.
 * @param   aItem           Clipboard item to write.
 * @param   aWrittenItem    Where to return the accepted clipboard item.
 */
HRESULT Clipboard::writeData(ClipboardAction_T aAction,
                             const ComPtr<IClipboardItem> &aItem,
                             ComPtr<IClipboardItem> &aWrittenItem)
{
    RT_NOREF(aAction, aItem, aWrittenItem);
    ReturnComNotImplemented();
}


/**
 * Writes available clipboard formats.
 *
 * @returns COM status code.
 * @param   aFormats        Clipboard formats to make available.
 */
HRESULT Clipboard::writeFormats(const std::vector<ComPtr<IClipboardFormat> > &aFormats)
{
    RT_NOREF(aFormats);
    ReturnComNotImplemented();
}


/**
 * Resets clipboard data and transfer state.
 *
 * @returns COM status code.
 */
HRESULT Clipboard::reset()
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mFileList.clear();
    if (!mData.mTransfers.isNull())
        mData.mTransfers->i_reset();
    return S_OK;
}


/**
 * Checks whether a clipboard format is available for a source.
 *
 * @returns COM status code.
 * @param   aSource         Clipboard source to check.
 * @param   aFormat         Clipboard format to check.
 * @param   aAvailable      Where to return whether the format is available.
 */
HRESULT Clipboard::isFormatAvailable(ClipboardSource_T aSource,
                                     const ComPtr<IClipboardFormat> &aFormat,
                                     BOOL *aAvailable)
{
    RT_NOREF(aSource, aFormat, aAvailable);
    ReturnComNotImplemented();
}


/**
 * Returns supported clipboard formats for a source.
 *
 * @returns COM status code.
 * @param   aSource         Clipboard source to query.
 * @param   aFormats        Where to return the supported formats.
 */
HRESULT Clipboard::getSupportedFormats(ClipboardSource_T aSource,
                                       std::vector<ComPtr<IClipboardFormat> > &aFormats)
{
    RT_NOREF(aSource, aFormats);
    ReturnComNotImplemented();
}
