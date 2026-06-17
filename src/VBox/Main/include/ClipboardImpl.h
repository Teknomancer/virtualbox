/* $Id: ClipboardImpl.h 114405 2026-06-17 13:18:09Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Console clipboard API.
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

#include "ClipboardWrap.h"

#include <vector>

class Console;

/**
 * Client-side implementation of live clipboard operations for a console.
 */
class ATL_NO_VTABLE Clipboard :
    public ClipboardWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(Clipboard)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(Console *aParent);
    void uninit();

    HRESULT i_readData(ClipboardAction_T aAction,
                       ClipboardSource_T *aSource,
                       com::Utf8Str &aMimeType,
                       std::vector<BYTE> &aBuffer);
    HRESULT i_readFormats(std::vector<com::Utf8Str> &aFormats);
    HRESULT i_writeData(ClipboardAction_T aAction,
                        ClipboardSource_T aSource,
                        const com::Utf8Str &aMimeType,
                        const std::vector<BYTE> &aBuffer,
                        ClipboardSource_T *aWrittenSource,
                        com::Utf8Str &aWrittenMimeType,
                        std::vector<BYTE> &aWrittenBuffer);
    HRESULT i_writeFormats(const std::vector<com::Utf8Str> &aFormats);
    HRESULT i_reset();
    HRESULT i_transferCancel(ULONG aTransferId);
    HRESULT i_readDataForGuest(uint32_t uFormat, void *pvData, uint32_t cbData, uint32_t *pcbActual);
    HRESULT i_reportData(ClipboardAction_T aAction, ClipboardSource_T aSource, uint32_t fFormat, const void *pvData, uint32_t cbData);
    bool i_useHostClipboard();

    void i_reportFormats(uint32_t fFormats, ClipboardSource_T aSource, bool fForceNotify = false);
    void i_fireClipboardError(const com::Utf8Str &aId, const com::Utf8Str &aErrMsg, LONG aRc);
    void i_fireClipboardModeChanged(ClipboardMode_T aClipboardMode);
    void i_fireClipboardFileTransferModeChanged(bool fEnabled);
    int i_changeMode(ClipboardMode_T aClipboardMode);
    int i_changeFileTransferMode(bool fEnabled);

private:

    /** @name Wrapped IClipboard properties and methods
     * @{ */
    HRESULT getFileList(std::vector<com::Utf8Str> &aFileList);
    HRESULT setFileList(const std::vector<com::Utf8Str> &aFileList);
    HRESULT getTransfers(ComPtr<IClipboardTransferManager> &aTransfers);
    HRESULT getEventSource(ComPtr<IEventSource> &aEventSource);
    HRESULT getUseHostClipboard(BOOL *aUseHostClipboard);
    HRESULT setUseHostClipboard(BOOL aUseHostClipboard);
    HRESULT createFormat(const com::Utf8Str &aMimeType,
                         ComPtr<IClipboardFormat> &aFormat);
    HRESULT createItem(ClipboardSource_T aSource,
                       const ComPtr<IClipboardFormat> &aFormat,
                       const std::vector<BYTE> &aBuffer,
                       ComPtr<IClipboardItem> &aItem);
    HRESULT readData(ClipboardAction_T aAction, ComPtr<IClipboardItem> &aItem);
    HRESULT readFormats(std::vector<ComPtr<IClipboardFormat> > &aFormats);
    HRESULT writeData(ClipboardAction_T aAction,
                      const ComPtr<IClipboardItem> &aItem,
                      ComPtr<IClipboardItem> &aWrittenItem);
    HRESULT readDataRaw(ClipboardAction_T aAction,
                        ClipboardSource_T *aSource,
                        com::Utf8Str &aMimeType,
                        std::vector<BYTE> &aBuffer);
    HRESULT writeDataRaw(ClipboardAction_T aAction,
                         ClipboardSource_T aSource,
                         const com::Utf8Str &aMimeType,
                         const std::vector<BYTE> &aBuffer,
                         ClipboardSource_T *aWrittenSource,
                         com::Utf8Str &aWrittenMimeType,
                         std::vector<BYTE> &aWrittenBuffer);
    HRESULT writeFormats(const std::vector<ComPtr<IClipboardFormat> > &aFormats);
    HRESULT reset();
    HRESULT isFormatAvailable(ClipboardSource_T aSource,
                              const ComPtr<IClipboardFormat> &aFormat,
                              BOOL *aAvailable);
    HRESULT getSupportedFormats(ClipboardSource_T aSource,
                                std::vector<ComPtr<IClipboardFormat> > &aFormats);
    /** @} */

    HRESULT i_createFormat(const com::Utf8Str &aMimeType, ComPtr<IClipboardFormat> &aFormat);
    HRESULT i_createItem(ClipboardSource_T aSource,
                         const com::Utf8Str &aMimeType,
                         const std::vector<BYTE> &aBuffer,
                         ComPtr<IClipboardItem> &aItem);
    void i_storeData(ClipboardAction_T aAction,
                     ClipboardSource_T aSource,
                     const com::Utf8Str &aMimeType,
                     const std::vector<BYTE> &aBuffer);
    void i_fireDataChanged(ClipboardAction_T aAction,
                           ClipboardSource_T aSource,
                           const com::Utf8Str &aMimeType,
                           const std::vector<BYTE> &aBuffer);

    struct Data;
    Data *mData;

#ifdef VBOX_WITH_SHARED_CLIPBOARD
    /** Last Shared Clipboard format mask reported through the active service extension. */
    uint32_t m_fFormats;
#endif
};

#endif /* !MAIN_INCLUDED_ClipboardImpl_h */
/* vi: set tabstop=4 shiftwidth=4 expandtab: */
