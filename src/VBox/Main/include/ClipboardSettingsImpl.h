/* $Id: ClipboardSettingsImpl.h 114362 2026-06-15 18:31:38Z andreas.loeffler@oracle.com $ */
/** @file
 * VirtualBox Main - Clipboard settings API.
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

#ifndef MAIN_INCLUDED_ClipboardSettingsImpl_h
#define MAIN_INCLUDED_ClipboardSettingsImpl_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardSettingsWrap.h"

class Machine;
namespace settings
{
    struct Clipboard;
}

/**
 * Clipboard control object.
 */
class ATL_NO_VTABLE ClipboardSettings :
    public ClipboardSettingsWrap
{
public:

    DECLARE_COMMON_CLASS_METHODS(ClipboardSettings)

    HRESULT FinalConstruct();
    void FinalRelease();

    HRESULT init(Machine *aParent = NULL);
    HRESULT init(Machine *aParent, ClipboardSettings *aThat);
    HRESULT initCopy(Machine *aParent, ClipboardSettings *aThat);
    void uninit();

    HRESULT i_setMode(ClipboardMode_T aMode);
    HRESULT i_getFileTransfersEnabled(BOOL *aEnabled);
    HRESULT i_setFileTransfersEnabled(BOOL aEnabled);
    HRESULT i_loadSettings(const settings::Clipboard &data);
    HRESULT i_saveSettings(settings::Clipboard &data);
    void i_applyDefaults(void);
    HRESULT i_notifyClipboardModeChange(ClipboardMode_T aMode);
    HRESULT i_notifyClipboardFileTransferModeChange(BOOL aEnable);
    void i_rollback();
    void i_commit();
    void i_copyFrom(ClipboardSettings *aThat);

private:

    /** @name Wrapped IClipboardSettings properties and methods
     * @{ */
    HRESULT getMode(ClipboardMode_T *aMode);
    HRESULT setMode(ClipboardMode_T aMode);
    HRESULT getFileTransfersEnabled(BOOL *aEnabled);
    HRESULT setFileTransfersEnabled(BOOL aEnabled);
    /** @} */

    struct Data;
    Data *mData;
};

#endif /* !MAIN_INCLUDED_ClipboardSettingsImpl_h */
