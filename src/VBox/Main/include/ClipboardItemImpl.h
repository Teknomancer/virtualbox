/* $Id: ClipboardItemImpl.h 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
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

#ifndef MAIN_INCLUDED_ClipboardItemImpl_h
#define MAIN_INCLUDED_ClipboardItemImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardItemWrap.h"

#include <vector>

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

#endif /* !MAIN_INCLUDED_ClipboardItemImpl_h */
