/* $Id: ClipboardTransferManagerImpl.h 114609 2026-07-03 15:22:37Z andreas.loeffler@oracle.com $ */
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

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
# include <VBox/GuestHost/SharedClipboard-transfers.h>
#endif

#include <vector>

class Clipboard;

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

    HRESULT init(IEventSource *aEventSource = NULL, Clipboard *aParent = NULL);
    void uninit();

    /** Resets the internally tracked transfer list. */
    void i_reset();
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    HRESULT i_handleTransferStatus(SHCLSESSIONID aServiceSessionId,
                                   SHCLTRANSFERID aTransferId,
                                   SHCLTRANSFERGEN aGeneration,
                                   SHCLSOURCE enmShClSource,
                                   SHCLTRANSFERSTATUS enmStatus,
                                   int vrcTransfer);
    HRESULT i_cancelTransferById(ULONG aTransferId);
#endif

private:

    void i_fireTransferEvent(IClipboardTransfer *aTransfer,
                             ClipboardTransferState_T aState,
                             ClipboardTransferInteraction_T aInteraction,
                             const com::Utf8Str &aPath,
                             const com::Utf8Str &aMessage,
                             ClipboardError_T aError);

    /** @name Wrapped IClipboardTransferManager properties and methods
     * @{ */
    HRESULT getTransfers(ClipboardTransferDirection_T aDirection,
                          ULONG aFlags,
                          std::vector<ComPtr<IClipboardTransfer> > &aTransfers);
    HRESULT createTransfer(ClipboardTransferDirection_T aDirection,
                           ClipboardSource_T aSource,
                           ClipboardAction_T aAction,
                           ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT add(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT remove(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT cancel(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT approve(const ComPtr<IClipboardTransfer> &aTransfer,
                    ULONG aFlags);
    HRESULT deny(const ComPtr<IClipboardTransfer> &aTransfer,
                 const com::Utf8Str &aReason);
    HRESULT respond(const ComPtr<IClipboardTransfer> &aTransfer,
                    ClipboardTransferInteraction_T aInteraction,
                    const com::Utf8Str &aPath,
                    ClipboardTransferResponse_T aResponse,
                    const com::Utf8Str &aResponsePath,
                    ULONG aFlags);
    HRESULT pause(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT resume(const ComPtr<IClipboardTransfer> &aTransfer);
    HRESULT reset();
    /** @} */

    struct Data
    {
        Data()
            : mParent(NULL)
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
            , mNextTransferId(1)
#endif
        { }

        struct TransferRecord
        {
            TransferRecord()
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
                : mServiceSessionId(NIL_SHCLSESSIONID)
                , mTransferId(0)
                , mGeneration(NIL_SHCLTRANSFERGEN)
                , mStatus(SHCLTRANSFERSTATUS_NONE)
                , mState(ClipboardTransferState_Added)
                , mfTerminal(false)
                , mfCancelRequested(false)
                , mfPublished(false)
#endif
            { }

#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
            SHCLSESSIONID                    mServiceSessionId;
            ULONG                            mTransferId;
            SHCLTRANSFERGEN                  mGeneration;
            SHCLTRANSFERSTATUS               mStatus;
            ClipboardTransferState_T         mState;
            bool                             mfTerminal;
            bool                             mfCancelRequested;
#endif
            ComPtr<IClipboardTransfer>       mTransfer;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
            /** Whether the transfer is visible through getTransfers(). */
            bool                             mfPublished;
            ComPtr<IProgress>                mProgress;
            ComPtr<IInternalProgressControl> mProgressControl;
#endif
        };

        /** Parent clipboard object. */
        Clipboard *mParent;
        /** Clipboard event source. */
        ComPtr<IEventSource> mEventSource;
        /** Current clipboard transfer records. */
        std::vector<TransferRecord> mTransfers;
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
        /** Next Main-created transfer identifier. */
        ULONG mNextTransferId;
#endif
    } mData;
};

#endif /* !MAIN_INCLUDED_ClipboardTransferManagerImpl_h */
