/* $Id: UIRecordingScalingModeEditor.h 114487 2026-06-22 16:17:27Z serkan.bayraktar@oracle.com $ */
/** @file
 * VBox Qt GUI - UIRecordingScalingModeEditor class declaration.
 */

/*
 * Copyright (C) 2006-2026 Oracle and/or its affiliates.
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

#ifndef FEQT_INCLUDED_SRC_settings_editors_UIRecordingScalingModeEditor_h
#define FEQT_INCLUDED_SRC_settings_editors_UIRecordingScalingModeEditor_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

/* GUI includes: */
#include "UIEditor.h"
#include "KRecordingVideoScalingMode.h"

/* Forward declarations: */
class QComboBox;
class QGridLayout;
class QLabel;

class SHARED_LIBRARY_STUFF UIRecordingScalingModeEditor : public UIEditor
{
    Q_OBJECT;

signals:

    void sigModeChange();

public:

    UIRecordingScalingModeEditor(QWidget *pParent = 0);

    void setMode(KRecordingVideoScalingMode enmMode);
    KRecordingVideoScalingMode mode() const;

    int minimumLabelHorizontalHint() const;
    void setMinimumLayoutIndent(int iIndent);

private slots:

    virtual void sltRetranslateUI() RT_OVERRIDE RT_FINAL;

private:

    void prepare();
    void prepareWidgets();
    void prepareConnections();
    void populateCombo();

    KRecordingVideoScalingMode m_enmMode;
    QGridLayout *m_pLayout;
    QLabel      *m_pLabel;
    QComboBox   *m_pCombo;
};

#endif /* !FEQT_INCLUDED_SRC_settings_editors_UIRecordingScalingModeEditor_h */
