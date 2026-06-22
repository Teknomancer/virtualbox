/* $Id: GuestShClHelpers.cpp 114474 2026-06-22 11:02:15Z andreas.loeffler@oracle.com $ */
/** @file
 * Main Shared Clipboard helper functions.
 *
 * This module contains the small Shared Clipboard helpers used by
 * ClipboardImpl.cpp for Main public API validation and mode checks.  It is kept
 * separate from GuestShClPrivate.cpp so that API-level code does not live in the
 * VM-process Shared Clipboard host-service bridge implementation.
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

#ifdef VBOX_WITH_SHARED_CLIPBOARD
# include "ConsoleImpl.h"
# include "GuestShClHelpers.h"


/*********************************************************************************************************************************
*   Global Functions                                                                                                             *
*********************************************************************************************************************************/

bool ShClMainIsValidAction(ClipboardAction_T enmAction)
{
    switch (enmAction)
    {
        case ClipboardAction_Copy:
        case ClipboardAction_Cut:
        case ClipboardAction_Paste:
        case ClipboardAction_Custom:
            return true;
        default:
            return false;
    }
}


bool ShClMainIsValidSource(ClipboardSource_T enmSource)
{
    switch (enmSource)
    {
        case ClipboardSource_Host:
        case ClipboardSource_Guest:
        case ClipboardSource_Remote:
        case ClipboardSource_Custom:
            return true;
        default:
            return false;
    }
}


HRESULT ShClMainGetMode(Console *pConsole, ClipboardMode_T *penmMode)
{
    AssertPtrReturn(penmMode, E_POINTER);
    *penmMode = ClipboardMode_Disabled;

    if (!pConsole)
    {
        LogFunc(("Cannot query clipboard mode without console parent\n"));
        return E_FAIL;
    }

    const ComPtr<IMachine> &ptrMachine = pConsole->i_machine();
    if (ptrMachine.isNull())
    {
        LogFunc(("Cannot query clipboard mode without machine\n"));
        return E_FAIL;
    }

    ComPtr<IClipboardSettings> ptrClipboard;
    HRESULT hrc = ptrMachine->COMGETTER(Clipboard)(ptrClipboard.asOutParam());
    if (FAILED(hrc))
    {
        LogFunc(("COMGETTER(IMachine::Clipboard) failed: hrc=%#x\n", hrc));
        return hrc;
    }
    if (ptrClipboard.isNull())
    {
        LogFunc(("Cannot query clipboard mode without clipboard settings\n"));
        return E_FAIL;
    }

    hrc = ptrClipboard->COMGETTER(Mode)(penmMode);
    if (FAILED(hrc))
        LogFunc(("COMGETTER(IClipboardSettings::Mode) failed: hrc=%#x\n", hrc));
    return hrc;
}


bool ShClMainModeAllowsRead(ClipboardMode_T enmMode, ClipboardSource_T enmSource)
{
    switch (enmSource)
    {
        case ClipboardSource_Host:
            return    enmMode == ClipboardMode_HostToGuest
                   || enmMode == ClipboardMode_Bidirectional;
        case ClipboardSource_Guest:
            return    enmMode == ClipboardMode_GuestToHost
                   || enmMode == ClipboardMode_Bidirectional;
        case ClipboardSource_Remote:
        case ClipboardSource_Custom:
            return true;
        default:
            return false;
    }
}


bool ShClMainModeAllowsWrite(ClipboardMode_T enmMode, ClipboardSource_T enmSource)
{
    switch (enmSource)
    {
        case ClipboardSource_Host:
            return    enmMode == ClipboardMode_HostToGuest
                   || enmMode == ClipboardMode_Bidirectional;
        case ClipboardSource_Guest:
            return    enmMode == ClipboardMode_GuestToHost
                   || enmMode == ClipboardMode_Bidirectional;
        case ClipboardSource_Remote:
        case ClipboardSource_Custom:
            return true;
        default:
            return false;
    }
}


#endif /* VBOX_WITH_SHARED_CLIPBOARD */
