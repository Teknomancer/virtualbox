/* $Id: GuestShClHelpers.h 114474 2026-06-22 11:02:15Z andreas.loeffler@oracle.com $ */
/** @file
 * Main Shared Clipboard helper functions.
 *
 * This module intentionally contains Main public-API helper code used by
 * ClipboardImpl.cpp in VBoxC.  It is kept separate from GuestShClPrivate.cpp so
 * public API validation and mode checks stay independent from the VM-process
 * Shared Clipboard host-service bridge.
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

#ifndef MAIN_INCLUDED_GuestShClHelpers_h
#define MAIN_INCLUDED_GuestShClHelpers_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include "ClipboardWrap.h"

class Console;

/** @name Main Shared Clipboard public API helpers.
 * @{ */
bool    ShClMainIsValidAction(ClipboardAction_T enmAction);
bool    ShClMainIsValidSource(ClipboardSource_T enmSource);
HRESULT ShClMainGetMode(Console *pConsole, ClipboardMode_T *penmMode);
bool    ShClMainModeAllowsRead(ClipboardMode_T enmMode, ClipboardSource_T enmSource);
bool    ShClMainModeAllowsWrite(ClipboardMode_T enmMode, ClipboardSource_T enmSource);
/** @} */


#endif /* !MAIN_INCLUDED_GuestShClHelpers_h */
