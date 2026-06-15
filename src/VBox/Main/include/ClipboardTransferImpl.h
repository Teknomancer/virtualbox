/* $Id: ClipboardTransferImpl.h 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
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

#ifndef MAIN_INCLUDED_ClipboardTransferImpl_h
#define MAIN_INCLUDED_ClipboardTransferImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardTransferWrap.h"

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

#endif /* !MAIN_INCLUDED_ClipboardTransferImpl_h */
