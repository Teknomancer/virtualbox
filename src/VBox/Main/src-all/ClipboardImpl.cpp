/* $Id: ClipboardImpl.cpp 114265 2026-06-08 07:52:29Z andreas.loeffler@oracle.com $ */
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
#include "MachineImpl.h"

#include <VBox/GuestHost/SharedClipboard.h>

#include <iprt/errcore.h>
#include <iprt/string.h>


/*********************************************************************************************************************************
*   Internal Functions                                                                                                           *
*********************************************************************************************************************************/
/**
 * Converts a clipboard MIME type to a shared clipboard format mask bit.
 *
 * @returns Shared Clipboard format mask bit, or VBOX_SHCL_FMT_NONE if unsupported.
 * @param   aMimeType       MIME type to convert.
 */
static SHCLFORMAT clipboardMimeTypeToFormat(const com::Utf8Str &aMimeType)
{
    const char *pszMimeType = aMimeType.c_str();
    if (   !RTStrICmp(pszMimeType, "text/plain")
        || !RTStrNICmp(pszMimeType, "text/plain;", sizeof("text/plain;") - 1)
        || !RTStrICmp(pszMimeType, "text/plain;charset=utf-8")
        || !RTStrICmp(pszMimeType, "text/plain;charset=UTF-8"))
        return VBOX_SHCL_FMT_UNICODETEXT;
    if (   !RTStrICmp(pszMimeType, "text/html")
        || !RTStrNICmp(pszMimeType, "text/html;", sizeof("text/html;") - 1))
        return VBOX_SHCL_FMT_HTML;
    if (   !RTStrICmp(pszMimeType, "image/bmp")
        || !RTStrICmp(pszMimeType, "image/x-bmp")
        || !RTStrICmp(pszMimeType, "application/x-bmp"))
        return VBOX_SHCL_FMT_BITMAP;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    if (   !RTStrICmp(pszMimeType, "text/uri-list")
        || !RTStrICmp(pszMimeType, "application/x-virtualbox-shared-clipboard-uri-list"))
        return VBOX_SHCL_FMT_URI_LIST;
#endif
    return VBOX_SHCL_FMT_NONE;
}


/**
 * Converts a shared clipboard format bit to the public MIME type.
 *
 * @returns MIME type, or NULL if unsupported.
 * @param   uFormat         Shared Clipboard format bit.
 */
static const char *clipboardFormatToMimeType(SHCLFORMAT uFormat)
{
    switch (uFormat)
    {
        case VBOX_SHCL_FMT_UNICODETEXT:
            return "text/plain;charset=utf-8";
        case VBOX_SHCL_FMT_HTML:
            return "text/html";
        case VBOX_SHCL_FMT_BITMAP:
            return "image/bmp";
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        case VBOX_SHCL_FMT_URI_LIST:
            return "text/uri-list";
#endif
        default:
            return NULL;
    }
}


/**
 * Creates a clipboard format object for a shared clipboard format bit.
 *
 * @returns COM status code.
 * @param   uFormat         Shared Clipboard format bit.
 * @param   aFormat         Where to return the format object.
 */
static HRESULT clipboardCreateFormat(SHCLFORMAT uFormat, ComPtr<IClipboardFormat> &aFormat)
{
    const char *pszMimeType = clipboardFormatToMimeType(uFormat);
    AssertReturn(pszMimeType, E_INVALIDARG);

    ComObjPtr<ClipboardFormat> pFormat;
    HRESULT hrc = pFormat.createObject();
    if (FAILED(hrc))
        return hrc;
    hrc = pFormat->init(pszMimeType);
    if (FAILED(hrc))
        return hrc;
    return pFormat.queryInterfaceTo(aFormat.asOutParam());
}


/**
 * Gets the shared clipboard format bit for a public format object.
 *
 * @returns COM status code.
 * @param   aFormat         Public clipboard format object.
 * @param   puFormat        Where to return the shared clipboard format bit.
 */
static HRESULT clipboardGetFormatBit(const ComPtr<IClipboardFormat> &aFormat, SHCLFORMAT *puFormat)
{
    AssertReturn(!aFormat.isNull(), E_INVALIDARG);
    AssertPtrReturn(puFormat, E_POINTER);

    com::Bstr bstrMimeType;
    HRESULT hrc = aFormat->COMGETTER(MimeType)(bstrMimeType.asOutParam());
    if (FAILED(hrc))
        return hrc;

    const com::Utf8Str strMimeType(bstrMimeType);
    SHCLFORMAT uFormat = clipboardMimeTypeToFormat(strMimeType);
    if (uFormat == VBOX_SHCL_FMT_NONE)
        return E_INVALIDARG;

    *puFormat = uFormat;
    return S_OK;
}


/**
 * Validates a public clipboard action.
 *
 * @returns COM status code.
 * @param   aAction         Public clipboard action.
 */
static HRESULT clipboardValidateAction(ClipboardAction_T aAction)
{
    if (   aAction == ClipboardAction_Copy
        || aAction == ClipboardAction_Cut
        || aAction == ClipboardAction_Paste
        || aAction == ClipboardAction_Custom)
        return S_OK;
    return E_INVALIDARG;
}


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
    return remove(aTransfer);
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
    mData.mParent     = NULL;
    mData.mFormats    = VBOX_SHCL_FMT_NONE;
    mData.mNextItemId = 1;
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
HRESULT Clipboard::init(Machine *aParent /* = NULL */)
{
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mParent = aParent;
    mData.bd.allocate();
    mData.mFormats = VBOX_SHCL_FMT_NONE;
    mData.mNextItemId = 1;
    mData.mFileList.clear();
    mData.mItems.clear();

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
 * Initializes a clipboard control object as a private copy of another clipboard object.
 *
 * @returns COM status code.
 */
HRESULT Clipboard::initCopy(Machine *aParent, Clipboard *aThat)
{
    ComAssertRet(aParent && aThat, E_INVALIDARG);

    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mParent = aParent;
    {
        AutoCaller thatCaller(aThat);
        AssertComRCReturnRC(thatCaller.hrc());

        AutoReadLock thatLock(aThat COMMA_LOCKVAL_SRC_POS);
        mData.bd.attachCopy(aThat->mData.bd);
    }
    mData.mFormats = VBOX_SHCL_FMT_NONE;
    mData.mNextItemId = 1;
    mData.mFileList.clear();
    mData.mItems.clear();

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
    mData.mParent = NULL;
    mData.bd.free();
    mData.mEventSource.setNull();
    mData.mFileList.clear();
    mData.mItems.clear();
    mData.mFormats = VBOX_SHCL_FMT_NONE;
    mData.mNextItemId = 1;
}


/**
 * Gets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        Where to return the file transfer enabled state.
 */
HRESULT Clipboard::i_getFileTransfersEnabled(BOOL *aEnabled)
{
    AssertPtrReturn(aEnabled, E_POINTER);

    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aEnabled = mData.bd->fFileTransfersEnabled;
    return S_OK;
}


/**
 * Gets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        Where to return the file transfer enabled state.
 */
HRESULT Clipboard::getFileTransfersEnabled(BOOL *aEnabled)
{
    return i_getFileTransfersEnabled(aEnabled);
}


/**
 * Sets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        New file transfer enabled state.
 */
HRESULT Clipboard::i_setFileTransfersEnabled(BOOL aEnabled)
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.bd.backup();
    mData.bd->fFileTransfersEnabled = RT_BOOL(aEnabled);
    return S_OK;
}


HRESULT Clipboard::i_notifyClipboardFileTransferModeChange(BOOL aEnable)
{
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData.mParent;
    }

    if (!pParent)
        return S_OK;

    return pParent->i_onClipboardFileTransferModeChange(aEnable);
}


/**
 * Sets whether clipboard file transfers are enabled.
 *
 * @returns COM status code.
 * @param   aEnabled        New file transfer enabled state.
 */
HRESULT Clipboard::setFileTransfersEnabled(BOOL aEnabled)
{
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData.mParent;
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
 * Rolls back settings changes made to this clipboard object.
 */
void Clipboard::i_rollback()
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.bd.rollback();
}


/**
 * Commits settings changes made to this clipboard object.
 */
void Clipboard::i_commit()
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.bd.commit();
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
    *aMode = mData.bd->mode;
    return S_OK;
}


/**
 * Sets the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           New clipboard mode.
 */
HRESULT Clipboard::i_setMode(ClipboardMode_T aMode)
{
    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.bd.backup();
    mData.bd->mode = aMode;
    return S_OK;
}


HRESULT Clipboard::i_notifyClipboardModeChange(ClipboardMode_T aMode)
{
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData.mParent;
    }

    if (!pParent)
        return S_OK;

    return pParent->i_onClipboardModeChange(aMode);
}


/**
 * Sets the clipboard mode.
 *
 * @returns COM status code.
 * @param   aMode           New clipboard mode.
 */
HRESULT Clipboard::setMode(ClipboardMode_T aMode)
{
    Machine *pParent;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pParent = mData.mParent;
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
    HRESULT hrc = clipboardValidateAction(aAction);
    if (FAILED(hrc))
        return hrc;

    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    if (mData.mItems.empty())
        return E_FAIL;

    aItem = mData.mItems.back();
    return S_OK;
}


/**
 * Reads available clipboard formats.
 *
 * @returns COM status code.
 * @param   aFormats        Where to return the clipboard formats.
 */
HRESULT Clipboard::readFormats(std::vector<ComPtr<IClipboardFormat> > &aFormats)
{
    SHCLFORMATS fFormats;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        fFormats = mData.mFormats;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        if (!mData.mFileList.empty())
            fFormats |= VBOX_SHCL_FMT_URI_LIST;
#endif
    }

    aFormats.clear();
    for (SHCLFORMAT uFormat = 1; uFormat <= VBOX_SHCL_FMT_VALID_MASK; uFormat <<= 1)
        if (fFormats & uFormat)
        {
            ComPtr<IClipboardFormat> pFormat;
            HRESULT hrc = clipboardCreateFormat(uFormat, pFormat);
            if (FAILED(hrc))
                return hrc;
            aFormats.push_back(pFormat);
        }

    return S_OK;
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
    HRESULT hrc = clipboardValidateAction(aAction);
    if (FAILED(hrc))
        return hrc;
    AssertReturn(!aItem.isNull(), E_INVALIDARG);

    ComPtr<IClipboardFormat> pFormat;
    hrc = aItem->COMGETTER(Format)(pFormat.asOutParam());
    if (FAILED(hrc))
        return hrc;

    SHCLFORMAT uFormat;
    hrc = clipboardGetFormatBit(pFormat, &uFormat);
    if (FAILED(hrc))
        return hrc;

    ClipboardSource_T enmSource;
    hrc = aItem->COMGETTER(Source)(&enmSource);
    if (FAILED(hrc))
        return hrc;

    com::SafeArray<BYTE> aSafeBuffer;
    hrc = aItem->COMGETTER(Buffer)(ComSafeArrayAsOutParam(aSafeBuffer));
    if (FAILED(hrc))
        return hrc;

    std::vector<BYTE> aBuffer;
    if (aSafeBuffer.size())
        aBuffer.assign(aSafeBuffer.raw(), aSafeBuffer.raw() + aSafeBuffer.size());

    ComObjPtr<ClipboardItem> pWrittenItem;
    hrc = pWrittenItem.createObject();
    if (FAILED(hrc))
        return hrc;

    ULONG idItem;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        idItem = mData.mNextItemId++;
        if (mData.mNextItemId == 0)
            mData.mNextItemId = 1;
    }

    hrc = pWrittenItem->init(idItem, enmSource, pFormat, aBuffer);
    if (FAILED(hrc))
        return hrc;

    ComPtr<IClipboardItem> pWrittenItemIface;
    hrc = pWrittenItem.queryInterfaceTo(pWrittenItemIface.asOutParam());
    if (FAILED(hrc))
        return hrc;

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    for (std::vector<ComPtr<IClipboardItem> >::iterator it = mData.mItems.begin(); it != mData.mItems.end();)
    {
        ComPtr<IClipboardFormat> pItemFormat;
        HRESULT hrc2 = (*it)->COMGETTER(Format)(pItemFormat.asOutParam());
        SHCLFORMAT uItemFormat = VBOX_SHCL_FMT_NONE;
        if (SUCCEEDED(hrc2))
            hrc2 = clipboardGetFormatBit(pItemFormat, &uItemFormat);
        if (SUCCEEDED(hrc2) && uItemFormat == uFormat)
            it = mData.mItems.erase(it);
        else
            ++it;
    }
    mData.mItems.push_back(pWrittenItemIface);
    mData.mFormats |= uFormat;
    aWrittenItem = pWrittenItemIface;
    return S_OK;
}


/**
 * Writes available clipboard formats.
 *
 * @returns COM status code.
 * @param   aFormats        Clipboard formats to make available.
 */
HRESULT Clipboard::writeFormats(const std::vector<ComPtr<IClipboardFormat> > &aFormats)
{
    SHCLFORMATS fFormats = VBOX_SHCL_FMT_NONE;
    for (std::vector<ComPtr<IClipboardFormat> >::const_iterator it = aFormats.begin(); it != aFormats.end(); ++it)
    {
        SHCLFORMAT uFormat;
        HRESULT hrc = clipboardGetFormatBit(*it, &uFormat);
        if (FAILED(hrc))
            return hrc;
        fFormats |= uFormat;
    }

    AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
    mData.mFormats = fFormats;
    for (std::vector<ComPtr<IClipboardItem> >::iterator it = mData.mItems.begin(); it != mData.mItems.end();)
    {
        ComPtr<IClipboardFormat> pItemFormat;
        HRESULT hrc = (*it)->COMGETTER(Format)(pItemFormat.asOutParam());
        SHCLFORMAT uItemFormat = VBOX_SHCL_FMT_NONE;
        if (SUCCEEDED(hrc))
            hrc = clipboardGetFormatBit(pItemFormat, &uItemFormat);
        if (FAILED(hrc) || !(fFormats & uItemFormat))
            it = mData.mItems.erase(it);
        else
            ++it;
    }
    return S_OK;
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
    mData.mItems.clear();
    mData.mFormats = VBOX_SHCL_FMT_NONE;
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
    AssertPtrReturn(aAvailable, E_POINTER);
    if (   aSource != ClipboardSource_Host
        && aSource != ClipboardSource_Guest
        && aSource != ClipboardSource_Remote
        && aSource != ClipboardSource_Custom)
        return E_INVALIDARG;

    SHCLFORMAT uFormat;
    HRESULT hrc = clipboardGetFormatBit(aFormat, &uFormat);
    if (FAILED(hrc))
        return hrc;

    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    SHCLFORMATS fFormats = mData.mFormats;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    if (!mData.mFileList.empty())
        fFormats |= VBOX_SHCL_FMT_URI_LIST;
#endif
    *aAvailable = (fFormats & uFormat) ? TRUE : FALSE;
    return S_OK;
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
    if (   aSource != ClipboardSource_Host
        && aSource != ClipboardSource_Guest
        && aSource != ClipboardSource_Remote
        && aSource != ClipboardSource_Custom)
        return E_INVALIDARG;

    static const SHCLFORMAT s_aFormats[] =
    {
        VBOX_SHCL_FMT_UNICODETEXT,
        VBOX_SHCL_FMT_HTML,
        VBOX_SHCL_FMT_BITMAP,
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        VBOX_SHCL_FMT_URI_LIST,
#endif
    };

    aFormats.clear();
    for (size_t i = 0; i < RT_ELEMENTS(s_aFormats); ++i)
    {
        ComPtr<IClipboardFormat> pFormat;
        HRESULT hrc = clipboardCreateFormat(s_aFormats[i], pFormat);
        if (FAILED(hrc))
            return hrc;
        aFormats.push_back(pFormat);
    }
    return S_OK;
}
