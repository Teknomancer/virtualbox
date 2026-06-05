/* $Id: ClipboardImpl.h 114262 2026-06-05 17:00:59Z andreas.loeffler@oracle.com $ */
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

#ifndef MAIN_INCLUDED_ClipboardImpl_h
#define MAIN_INCLUDED_ClipboardImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardFormatWrap.h"
#include "ClipboardItemWrap.h"
#include "ClipboardTransferWrap.h"
#include "ClipboardTransferManagerWrap.h"
#include "ClipboardWrap.h"

class Machine;

/**
 * Clipboard data format object.
 */
class ATL_NO_VTABLE ClipboardFormat :
    public ClipboardFormatWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(ClipboardFormat)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(const com::Utf8Str &aMimeType);
    void uninit();

private:

    /** @name Wrapped IClipboardFormat properties
     * @{ */
    HRESULT getMimeType(com::Utf8Str &aMimeType);
    HRESULT setMimeType(const com::Utf8Str &aMimeType);
    /** @} */

    struct Data
    {
        /** MIME type of the clipboard format. */
        com::Utf8Str mMimeType;
    } mData;
};

/**
 * Clipboard item object.
 */
class ATL_NO_VTABLE ClipboardItem :
    public ClipboardItemWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(ClipboardItem)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(ULONG aId,
                 ClipboardSource_T aSource,
                 const ComPtr<IClipboardFormat> &aFormat,
                 const std::vector<BYTE> &aBuffer);
    void uninit();

private:

    /** @name Wrapped IClipboardItem properties
     * @{ */
    HRESULT getId(ULONG *aId);
    HRESULT setId(ULONG aId);
    HRESULT getSource(ClipboardSource_T *aSource);
    HRESULT setSource(ClipboardSource_T aSource);
    HRESULT getFormat(ComPtr<IClipboardFormat> &aFormat);
    HRESULT setFormat(const ComPtr<IClipboardFormat> &aFormat);
    HRESULT getBuffer(std::vector<BYTE> &aBuffer);
    HRESULT setBuffer(const std::vector<BYTE> &aBuffer);
    HRESULT getSize(ULONG *aSize);
    /** @} */

    struct Data
    {
        /** Unique item identifier. */
        ULONG mId;
        /** Clipboard source. */
        ClipboardSource_T mSource;
        /** Clipboard format. */
        ComPtr<IClipboardFormat> mFormat;
        /** Clipboard payload. */
        std::vector<BYTE> mBuffer;
    } mData;
};

/**
 * Clipboard transfer object.
 */
class ATL_NO_VTABLE ClipboardTransfer :
    public ClipboardTransferWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(ClipboardTransfer)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(ULONG aId,
                 ClipboardAction_T aAction,
                 const ComPtr<IClipboardItem> &aItem,
                 const ComPtr<IProgress> &aProgress);
    void uninit();

private:

    /** @name Wrapped IClipboardTransfer properties
     * @{ */
    HRESULT getId(ULONG *aId);
    HRESULT getAction(ClipboardAction_T *aAction);
    HRESULT getItem(ComPtr<IClipboardItem> &aItem);
    HRESULT getProgress(ComPtr<IProgress> &aProgress);
    /** @} */

    struct Data
    {
        /** Unique transfer identifier. */
        ULONG mId;
        /** Clipboard transfer action. */
        ClipboardAction_T mAction;
        /** Clipboard item being transferred. */
        ComPtr<IClipboardItem> mItem;
        /** Progress object for the transfer. */
        ComPtr<IProgress> mProgress;
    } mData;
};

/**
 * Clipboard transfer manager object.
 */
class ATL_NO_VTABLE ClipboardTransferManager :
    public ClipboardTransferManagerWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(ClipboardTransferManager)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init();
    void uninit();

    /** Resets the internally tracked transfer list. */
    void i_reset();

private:

    /** @name Wrapped IClipboardTransferManager properties and methods
     * @{ */
    HRESULT getTransfers(std::vector<ComPtr<IClipboardTransfer> > &aTransfers);
    HRESULT add(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT remove(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT cancel(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT reset();
    /** @} */

    struct Data
    {
        /** Current clipboard transfers. */
        std::vector<ComPtr<IClipboardTransfer> > mTransfers;
    } mData;
};

/**
 * Clipboard control object.
 */
class ATL_NO_VTABLE Clipboard :
    public ClipboardWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(Clipboard)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(Machine *aParent = NULL);
    void uninit();

    HRESULT i_setMode(ClipboardMode_T aMode);
    HRESULT i_getFileTransfersEnabled(BOOL *aEnabled);
    HRESULT i_setFileTransfersEnabled(BOOL aEnabled);
    HRESULT i_notifyClipboardModeChange(ClipboardMode_T aMode);
    HRESULT i_notifyClipboardFileTransferModeChange(BOOL aEnable);
    void i_rollback();
    void i_commit();

private:

    /** @name Wrapped IClipboard properties and methods
     * @{ */
    HRESULT getMode(ClipboardMode_T *aMode);
    HRESULT setMode(ClipboardMode_T aMode);
    HRESULT getFileTransfersEnabled(BOOL *aEnabled);
    HRESULT setFileTransfersEnabled(BOOL aEnabled);
    HRESULT getFileList(std::vector<com::Utf8Str> &aFileList);
    HRESULT setFileList(const std::vector<com::Utf8Str> &aFileList);
    HRESULT getTransfers(ComPtr<IClipboardTransferManager> &aTransfers);
    HRESULT getEventSource(ComPtr<IEventSource> &aEventSource);
    HRESULT readData(ClipboardAction_T aAction, ComPtr<IClipboardItem> &aItem);
    HRESULT readFormats(std::vector<ComPtr<IClipboardFormat> > &aFormats);
    HRESULT writeData(ClipboardAction_T aAction,
                      const ComPtr<IClipboardItem> &aItem,
                      ComPtr<IClipboardItem> &aWrittenItem);
    HRESULT writeFormats(const std::vector<ComPtr<IClipboardFormat> > &aFormats);
    HRESULT reset();
    HRESULT isFormatAvailable(ClipboardSource_T aSource,
                              const ComPtr<IClipboardFormat> &aFormat,
                              BOOL *aAvailable);
    HRESULT getSupportedFormats(ClipboardSource_T aSource,
                                std::vector<ComPtr<IClipboardFormat> > &aFormats);
    /** @} */

    struct Data
    {
        /** Clipboard settings. */
        struct Settings
        {
            Settings()
                : mode(ClipboardMode_Disabled)
                , fFileTransfersEnabled(false)
            { }

            /** Clipboard mode. */
            ClipboardMode_T mode;
            /** Whether clipboard file transfers are enabled. */
            bool fFileTransfersEnabled;
        };

        /** Parent machine. */
        Machine *mParent;
        /** Clipboard settings. */
        Backupable<Settings> bd;
        /** Clipboard file list. */
        std::vector<com::Utf8Str> mFileList;
        /** Transfer manager object. */
        ComObjPtr<ClipboardTransferManager> mTransfers;
        /** Clipboard event source. */
        ComPtr<IEventSource> mEventSource;
        /** Current available Shared Clipboard format mask (VBOX_SHCL_FMT_XXX). */
        uint32_t mFormats;
        /** Next clipboard item identifier to assign. */
        ULONG mNextItemId;
        /** Current clipboard data items. */
        std::vector<ComPtr<IClipboardItem> > mItems;
    } mData;
};

#endif /* !MAIN_INCLUDED_ClipboardImpl_h */
