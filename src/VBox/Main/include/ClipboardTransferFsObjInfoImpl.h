/* $Id: ClipboardTransferFsObjInfoImpl.h 114609 2026-07-03 15:22:37Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard transfer file system object information.
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

#ifndef MAIN_INCLUDED_ClipboardTransferFsObjInfoImpl_h
#define MAIN_INCLUDED_ClipboardTransferFsObjInfoImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardTransferFsObjInfoWrap.h"

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
# include <VBox/GuestHost/SharedClipboard-transfers.h>
#endif

/**
 * Clipboard transfer file system object information.
 */
class ATL_NO_VTABLE ClipboardTransferFsObjInfo :
    public ClipboardTransferFsObjInfoWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(ClipboardTransferFsObjInfo)

    HRESULT FinalConstruct();
    void FinalRelease();

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    HRESULT init(const com::Utf8Str &aPath,
                 const com::Utf8Str &aName,
                 PCSHCLFSOBJINFO aInfo);
#endif
    void uninit();

private:

    /** @name Wrapped IClipboardTransferFsObjInfo properties
     * @{ */
    HRESULT getName(com::Utf8Str &aName);
    HRESULT getType(FsObjType_T *aType);
    HRESULT getFileAttributes(com::Utf8Str &aFileAttributes);
    HRESULT getObjectSize(LONG64 *aObjectSize);
    HRESULT getAllocatedSize(LONG64 *aAllocatedSize);
    HRESULT getAccessTime(LONG64 *aAccessTime);
    HRESULT getBirthTime(LONG64 *aBirthTime);
    HRESULT getChangeTime(LONG64 *aChangeTime);
    HRESULT getModificationTime(LONG64 *aModificationTime);
    HRESULT getUID(LONG *aUID);
    HRESULT getUserName(com::Utf8Str &aUserName);
    HRESULT getGID(LONG *aGID);
    HRESULT getGroupName(com::Utf8Str &aGroupName);
    HRESULT getNodeId(LONG64 *aNodeId);
    HRESULT getNodeIdDevice(ULONG *aNodeIdDevice);
    HRESULT getHardLinks(ULONG *aHardLinks);
    HRESULT getDeviceNumber(ULONG *aDeviceNumber);
    HRESULT getGenerationId(ULONG *aGenerationId);
    HRESULT getUserFlags(ULONG *aUserFlags);
    HRESULT getPath(com::Utf8Str &aPath);
    /** @} */

    struct Data
    {
        Data()
            : mType(FsObjType_Unknown)
            , mObjectSize(0)
            , mAllocatedSize(0)
            , mAccessTime(0)
            , mBirthTime(0)
            , mChangeTime(0)
            , mModificationTime(0)
            , mUID(-1)
            , mGID(-1)
            , mNodeId(0)
            , mNodeIdDevice(0)
            , mHardLinks(1)
            , mDeviceNumber(0)
            , mGenerationId(0)
            , mUserFlags(0)
        { }

        com::Utf8Str mPath;
        com::Utf8Str mName;
        FsObjType_T  mType;
        com::Utf8Str mFileAttributes;
        LONG64       mObjectSize;
        LONG64       mAllocatedSize;
        LONG64       mAccessTime;
        LONG64       mBirthTime;
        LONG64       mChangeTime;
        LONG64       mModificationTime;
        LONG         mUID;
        com::Utf8Str mUserName;
        LONG         mGID;
        com::Utf8Str mGroupName;
        LONG64       mNodeId;
        ULONG        mNodeIdDevice;
        ULONG        mHardLinks;
        ULONG        mDeviceNumber;
        ULONG        mGenerationId;
        ULONG        mUserFlags;
    } mData;
};

#endif /* !MAIN_INCLUDED_ClipboardTransferFsObjInfoImpl_h */
