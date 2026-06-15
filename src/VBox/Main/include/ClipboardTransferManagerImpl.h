/* $Id: ClipboardTransferManagerImpl.h 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
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

#ifndef MAIN_INCLUDED_ClipboardTransferManagerImpl_h
#define MAIN_INCLUDED_ClipboardTransferManagerImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardTransferManagerWrap.h"

#include <vector>

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

    HRESULT init(IEventSource *aEventSource = NULL);
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
        /** Clipboard event source. */
        ComPtr<IEventSource> mEventSource;
        /** Current clipboard transfers. */
        std::vector<ComPtr<IClipboardTransfer> > mTransfers;
    } mData;
};

#endif /* !MAIN_INCLUDED_ClipboardTransferManagerImpl_h */
