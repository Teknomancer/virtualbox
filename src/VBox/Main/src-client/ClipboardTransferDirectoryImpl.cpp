/* $Id: ClipboardTransferDirectoryImpl.cpp 114609 2026-07-03 15:22:37Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard transfer directory handle.
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

#define LOG_GROUP LOG_GROUP_SHARED_CLIPBOARD
#include "LoggingNew.h"

#include "VirtualBoxBase.h"
#include "AutoCaller.h"
#include "ClipboardTransferDirectoryImpl.h"
#include "ClipboardTransferFsObjInfoImpl.h"

#include <VBox/com/ErrorInfo.h>
#include <VBox/com/array.h>

#include <iprt/string.h>


DEFINE_EMPTY_CTOR_DTOR(ClipboardTransferDirectory)


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
/**
 * Converts a Shared Clipboard result code to a Main API HRESULT.
 *
 * @returns COM status code.
 * @param   vrc                 VBox status code to convert.
 */
static HRESULT clipboardTransferDirectoryRcToHrc(int vrc)
{
    if (RT_SUCCESS(vrc))
        return S_OK;
    if (vrc == VERR_NO_DATA || vrc == VERR_NO_MORE_FILES || vrc == VERR_NOT_FOUND)
        return VBOX_E_OBJECT_NOT_FOUND;
    if (vrc == VERR_NO_MEMORY)
        return E_OUTOFMEMORY;
    if (vrc == VERR_NOT_SUPPORTED || vrc == VERR_NOT_IMPLEMENTED)
        return E_NOTIMPL;
    if (vrc == VERR_INVALID_PARAMETER || vrc == VERR_INVALID_POINTER || vrc == VERR_INVALID_HANDLE)
        return E_INVALIDARG;
    return VBOX_E_SHCL_ERROR;
}


/**
 * Builds a child transfer path from a directory path and entry name.
 *
 * @returns Child transfer path.
 * @param   aDirectoryPath      Parent directory path.
 * @param   pszName             Child entry name.
 */
static com::Utf8Str clipboardTransferDirectoryMakeChildPath(const com::Utf8Str &aDirectoryPath, const char *pszName)
{
    if (aDirectoryPath.isEmpty())
        return com::Utf8Str(pszName ? pszName : "");
    return com::Utf8StrFmt("%s/%s", aDirectoryPath.c_str(), pszName ? pszName : "");
}


/**
 * Opens a Shared Clipboard transfer directory list.
 *
 * @returns VBox status code.
 * @param   pTransfer           Backing transfer.
 * @param   aPath               Transfer-relative directory path.
 * @param   phList              Where to return the list handle.
 */
static int clipboardTransferDirectoryOpenList(PSHCLTRANSFER pTransfer, const com::Utf8Str &aPath, PSHCLLISTHANDLE phList)
{
    SHCLLISTOPENPARMS OpenParms;
    int vrc = ShClTransferListOpenParmsInit(&OpenParms);
    if (RT_SUCCESS(vrc))
    {
        OpenParms.fList = VBOX_SHCL_LIST_F_NONE;
        if (!aPath.isEmpty())
            vrc = RTStrCopy(OpenParms.pszPath, OpenParms.cbPath, aPath.c_str());
        if (RT_SUCCESS(vrc))
            vrc = ShClTransferListOpen(pTransfer, &OpenParms, phList);
        ShClTransferListOpenParmsDestroy(&OpenParms);
    }
    return vrc;
}


/**
 * Creates a Main transfer object-info wrapper from a Shared Clipboard list entry.
 *
 * @returns COM status code.
 * @param   aDirectoryPath      Parent directory path.
 * @param   Entry               Shared Clipboard list entry.
 * @param   aInfo               Where to return the object-info wrapper.
 */
static HRESULT clipboardTransferDirectoryEntryToInfo(const com::Utf8Str &aDirectoryPath,
                                                     const SHCLLISTENTRY &Entry,
                                                     ComPtr<IClipboardTransferFsObjInfo> &aInfo)
{
    if (   !(Entry.fInfo & VBOX_SHCL_INFO_F_FSOBJINFO)
        || !Entry.pvInfo
        || Entry.cbInfo != sizeof(SHCLFSOBJINFO))
        return E_INVALIDARG;

    ComObjPtr<ClipboardTransferFsObjInfo> ptrInfo;
    HRESULT hrc = ptrInfo.createObject();
    if (FAILED(hrc))
        return hrc;

    com::Utf8Str const strName(Entry.pszName ? Entry.pszName : "");
    com::Utf8Str const strPath = clipboardTransferDirectoryMakeChildPath(aDirectoryPath, Entry.pszName);
    hrc = ptrInfo->init(strPath, strName, (PCSHCLFSOBJINFO)Entry.pvInfo);
    if (FAILED(hrc))
        return hrc;

    return ptrInfo.queryInterfaceTo(aInfo.asOutParam());
}
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */


/**
 * Completes construction of a clipboard transfer directory handle.
 *
 * @returns COM status code.
 */
HRESULT ClipboardTransferDirectory::FinalConstruct()
{
    return BaseFinalConstruct();
}


/**
 * Releases a clipboard transfer directory handle.
 */
void ClipboardTransferDirectory::FinalRelease()
{
    uninit();
    BaseFinalRelease();
}


#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
/**
 * Initializes a clipboard transfer directory handle.
 *
 * @returns COM status code.
 * @param   aParent             Parent transfer object used to keep the backing transfer alive.
 * @param   aTransfer           Backing Shared Clipboard transfer.
 * @param   aPath               Transfer-relative directory path.
 * @param   aHandle             Open Shared Clipboard list handle.
 */
HRESULT ClipboardTransferDirectory::init(const ComPtr<IClipboardTransfer> &aParent,
                                         PSHCLTRANSFER aTransfer,
                                         const com::Utf8Str &aPath,
                                         SHCLLISTHANDLE aHandle)
{
    AssertPtrReturn(aTransfer, E_POINTER);
    AutoInitSpan autoInitSpan(this);
    AssertReturn(autoInitSpan.isOk(), E_FAIL);

    mData.mParent = aParent;
    mData.mTransfer = aTransfer;
    mData.mHandle = aHandle;
    mData.mPath = aPath;
    mData.mStatus = DirectoryStatus_Open;

    autoInitSpan.setSucceeded();
    return S_OK;
}
#endif /* VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS */


/**
 * Uninitializes a clipboard transfer directory handle.
 */
void ClipboardTransferDirectory::uninit()
{
    AutoUninitSpan autoUninitSpan(this);
    if (autoUninitSpan.uninitDone())
        return;

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    PSHCLTRANSFER pTransfer = NULL;
    SHCLLISTHANDLE hList = NIL_SHCLLISTHANDLE;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        pTransfer = mData.mTransfer;
        hList = mData.mHandle;
        mData.mTransfer = NULL;
        mData.mHandle = NIL_SHCLLISTHANDLE;
        mData.mStatus = DirectoryStatus_Close;
        mData.mParent.setNull();
    }
    if (pTransfer && hList != NIL_SHCLLISTHANDLE)
    {
        int vrc = ShClTransferListClose(pTransfer, hList);
        AssertRC(vrc);
    }
#endif
}


HRESULT ClipboardTransferDirectory::getDirectoryName(com::Utf8Str &aDirectoryName)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aDirectoryName = mData.mPath;
    return S_OK;
}


HRESULT ClipboardTransferDirectory::getEventSource(ComPtr<IEventSource> &aEventSource)
{
    aEventSource.setNull();
    return S_OK;
}


HRESULT ClipboardTransferDirectory::getFilter(com::Utf8Str &aFilter)
{
    aFilter.setNull();
    return S_OK;
}


HRESULT ClipboardTransferDirectory::getId(ULONG *aId)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aId = (ULONG)mData.mHandle;
    return S_OK;
}


HRESULT ClipboardTransferDirectory::getStatus(DirectoryStatus_T *aStatus)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    *aStatus = mData.mStatus;
    return S_OK;
}


HRESULT ClipboardTransferDirectory::close()
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    ReturnComNotImplemented();
#else
    PSHCLTRANSFER pTransfer = NULL;
    SHCLLISTHANDLE hList = NIL_SHCLLISTHANDLE;
    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        pTransfer = mData.mTransfer;
        hList = mData.mHandle;
        mData.mTransfer = NULL;
        mData.mHandle = NIL_SHCLLISTHANDLE;
        mData.mStatus = DirectoryStatus_Close;
    }
    if (!pTransfer || hList == NIL_SHCLLISTHANDLE)
        return S_OK;
    return clipboardTransferDirectoryRcToHrc(ShClTransferListClose(pTransfer, hList));
#endif
}


HRESULT ClipboardTransferDirectory::list(ULONG aMaxEntries, std::vector<ComPtr<IFsObjInfo> > &aObjInfo)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aMaxEntries, aObjInfo);
    ReturnComNotImplemented();
#else
    std::vector<ComPtr<IClipboardTransferFsObjInfo> > vecEntries;
    HRESULT hrc = listEx(aMaxEntries, ClipboardTransferListFlag_NoRecursion, vecEntries);
    if (FAILED(hrc))
        return hrc;
    aObjInfo.clear();
    for (std::vector<ComPtr<IClipboardTransferFsObjInfo> >::const_iterator it = vecEntries.begin(); it != vecEntries.end(); ++it)
    {
        ComPtr<IFsObjInfo> ptrInfo(*it);
        aObjInfo.push_back(ptrInfo);
    }
    return S_OK;
#endif
}


HRESULT ClipboardTransferDirectory::read(ComPtr<IFsObjInfo> &aObjInfo)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aObjInfo);
    ReturnComNotImplemented();
#else
    std::vector<ComPtr<IFsObjInfo> > vecInfo;
    HRESULT hrc = list(1, vecInfo);
    if (FAILED(hrc))
        return hrc;
    if (vecInfo.empty())
        return VBOX_E_OBJECT_NOT_FOUND;
    aObjInfo = vecInfo[0];
    return S_OK;
#endif
}


HRESULT ClipboardTransferDirectory::rewind()
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    ReturnComNotImplemented();
#else
    PSHCLTRANSFER pTransfer = NULL;
    SHCLLISTHANDLE hOld = NIL_SHCLLISTHANDLE;
    com::Utf8Str strPath;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pTransfer = mData.mTransfer;
        hOld = mData.mHandle;
        strPath = mData.mPath;
    }
    if (!pTransfer || hOld == NIL_SHCLLISTHANDLE)
        return VBOX_E_OBJECT_NOT_FOUND;

    SHCLLISTHANDLE hNew = NIL_SHCLLISTHANDLE;
    int vrc = clipboardTransferDirectoryOpenList(pTransfer, strPath, &hNew);
    if (RT_FAILURE(vrc))
        return clipboardTransferDirectoryRcToHrc(vrc);

    {
        AutoWriteLock alock(this COMMA_LOCKVAL_SRC_POS);
        hOld = mData.mHandle;
        mData.mHandle = hNew;
        mData.mStatus = DirectoryStatus_Open;
    }
    if (hOld != NIL_SHCLLISTHANDLE)
        ShClTransferListClose(pTransfer, hOld);
    return S_OK;
#endif
}


HRESULT ClipboardTransferDirectory::getPath(com::Utf8Str &aPath)
{
    AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
    aPath = mData.mPath;
    return S_OK;
}




HRESULT ClipboardTransferDirectory::listEx(ULONG aMaxEntries,
                                           ULONG aFlags,
                                           std::vector<ComPtr<IClipboardTransferFsObjInfo> > &aEntries)
{
#ifndef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    RT_NOREF(aMaxEntries, aFlags, aEntries);
    ReturnComNotImplemented();
#else
    if (aFlags & ~(ClipboardTransferListFlag_NoRecursion | ClipboardTransferListFlag_IncludeRoot | ClipboardTransferListFlag_NoFollowSymlinks))
        return E_INVALIDARG;

    aEntries.clear();
    if (!(aFlags & ClipboardTransferListFlag_NoRecursion))
    {
        ComPtr<IClipboardTransfer> ptrParent;
        com::Utf8Str strPath;
        {
            AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
            ptrParent = mData.mParent;
            strPath = mData.mPath;
        }
        if (ptrParent.isNull())
            return E_FAIL;
        SafeIfaceArray<IClipboardTransferFsObjInfo> aSafeEntries;
        HRESULT hrc = ptrParent->List(Bstr(strPath).raw(), aFlags, ComSafeArrayAsOutParam(aSafeEntries));
        if (FAILED(hrc))
            return hrc;
        for (size_t i = 0; i < aSafeEntries.size(); ++i)
        {
            if (aMaxEntries && aEntries.size() >= aMaxEntries)
                break;
            aEntries.push_back(ComPtr<IClipboardTransferFsObjInfo>(aSafeEntries[i]));
        }
        return S_OK;
    }

    PSHCLTRANSFER pTransfer = NULL;
    SHCLLISTHANDLE hList = NIL_SHCLLISTHANDLE;
    com::Utf8Str strPath;
    {
        AutoReadLock alock(this COMMA_LOCKVAL_SRC_POS);
        pTransfer = mData.mTransfer;
        hList = mData.mHandle;
        strPath = mData.mPath;
    }
    if (!pTransfer || hList == NIL_SHCLLISTHANDLE)
        return VBOX_E_OBJECT_NOT_FOUND;

    ULONG cEntries = 0;
    for (;;)
    {
        if (aMaxEntries && cEntries >= aMaxEntries)
            break;

        SHCLLISTENTRY Entry;
        int vrc = ShClTransferListEntryInit(&Entry);
        if (RT_FAILURE(vrc))
            return clipboardTransferDirectoryRcToHrc(vrc);
        vrc = ShClTransferListRead(pTransfer, hList, &Entry);
        if (RT_FAILURE(vrc))
        {
            ShClTransferListEntryDestroy(&Entry);
            if (vrc == VERR_NO_MORE_FILES || vrc == VERR_NO_DATA || vrc == VERR_NOT_FOUND)
                break;
            return clipboardTransferDirectoryRcToHrc(vrc);
        }

        ComPtr<IClipboardTransferFsObjInfo> ptrInfo;
        HRESULT hrc = clipboardTransferDirectoryEntryToInfo(strPath, Entry, ptrInfo);
        ShClTransferListEntryDestroy(&Entry);
        if (FAILED(hrc))
            return hrc;
        aEntries.push_back(ptrInfo);
        ++cEntries;
    }
    return S_OK;
#endif
}
