/* $Id: ClipboardFormatImpl.h 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard format object.
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

#ifndef MAIN_INCLUDED_ClipboardFormatImpl_h
#define MAIN_INCLUDED_ClipboardFormatImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardFormatWrap.h"

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

#endif /* !MAIN_INCLUDED_ClipboardFormatImpl_h */
