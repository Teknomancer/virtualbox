/* $Id: HostClipboardImpl.h 114560 2026-06-29 08:32:23Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Host clipboard API object.
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

#ifndef MAIN_INCLUDED_HostClipboardImpl_h
#define MAIN_INCLUDED_HostClipboardImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "HostClipboardWrap.h"

#include <VBox/GuestHost/SharedClipboard.h>

#include <vector>

class Clipboard;

/**
 * Native host clipboard endpoint for a console clipboard.
 */
class ATL_NO_VTABLE HostClipboard :
    public HostClipboardWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(HostClipboard)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(VBOXSHCLMAINCLIENTID aClientId, Clipboard *aParent);
    void uninit();

private:

    /** @name Wrapped IHostClipboard methods
     * @{ */
    HRESULT reportFormats(ClipboardAction_T aAction,
                          ClipboardSource_T aSource,
                          const std::vector<ComPtr<IClipboardFormat> > &aFormats);
    HRESULT provideData(ULONG aRequestId,
                        ClipboardAction_T aAction,
                        ClipboardSource_T aSource,
                        const com::Utf8Str &aMimeType,
                        const std::vector<BYTE> &aBuffer);
    HRESULT setData(ClipboardAction_T aAction,
                    ClipboardSource_T aSource,
                    const com::Utf8Str &aMimeType,
                    const std::vector<BYTE> &aBuffer);
    HRESULT clear();
    /** @} */

    struct Data
    {
        Data()
            : mClientId(VBOX_SHCL_MAIN_CLIENT_NONE)
            , mParent(NULL)
        { }

        /** Main clipboard client ID this endpoint is associated with. */
        VBOXSHCLMAINCLIENTID mClientId;
        /** Parent clipboard object. */
        Clipboard *mParent;
    } mData;
};

#endif /* !MAIN_INCLUDED_HostClipboardImpl_h */
