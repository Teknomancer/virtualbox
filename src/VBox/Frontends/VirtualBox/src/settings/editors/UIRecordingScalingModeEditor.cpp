/* $Id: UIRecordingScalingModeEditor.cpp 114487 2026-06-22 16:17:27Z serkan.bayraktar@oracle.com $ */
/** @file
 * VBox Qt GUI - UIRecordingScalingModeEditor class implementation.
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

/* Qt includes: */
#include <QComboBox>
#include <QGridLayout>
#include <QLabel>

/* GUI includes: */
#include "UIConverter.h"
#include "UIGlobalSession.h"
#include "UIRecordingScalingModeEditor.h"

/* COM includes: */
#include "CSystemProperties.h"

UIRecordingScalingModeEditor::UIRecordingScalingModeEditor(QWidget *pParent /* = 0 */)
    : UIEditor(pParent)
    , m_enmMode(KRecordingVideoScalingMode_Max)
    , m_pLabel(0)
    , m_pCombo(0)
{
    prepare();
}

void UIRecordingScalingModeEditor::setMode(KRecordingVideoScalingMode enmMode)
{
    if (m_enmMode == enmMode)
        return;
    m_enmMode = enmMode;
    if (m_pCombo)
    {
        int index = m_pCombo->findData(QVariant::fromValue(m_enmMode));
        if (index != -1)
        {
            m_pCombo->blockSignals(true);
            m_pCombo->setCurrentIndex(index);
            m_pCombo->blockSignals(false);
        }
    }
}

KRecordingVideoScalingMode UIRecordingScalingModeEditor::mode() const
{
    return m_pCombo ? m_pCombo->currentData().value<KRecordingVideoScalingMode>() : m_enmMode;
}

int UIRecordingScalingModeEditor::minimumLabelHorizontalHint() const
{
    return m_pLabel ? m_pLabel->minimumSizeHint().width() : 0;
}

void UIRecordingScalingModeEditor::setMinimumLayoutIndent(int iIndent)
{
    if (m_pLayout)
        m_pLayout->setColumnMinimumWidth(0, iIndent + m_pLayout->spacing());
}

void UIRecordingScalingModeEditor::sltRetranslateUI()
{
    m_pLabel->setText(tr("Scaling &Mode"));
    m_pCombo->setToolTip(tr("Scaling mode"));
    if (m_pCombo)
    {
        for (int i = 0; i < m_pCombo->count(); ++i)
        {
            KRecordingVideoScalingMode data = m_pCombo->itemData(i).value<KRecordingVideoScalingMode>();
            m_pCombo->setItemText(i, gpConverter->toString<KRecordingVideoScalingMode>(data));
        }
    }
}

void UIRecordingScalingModeEditor::prepare()
{
    prepareWidgets();
    prepareConnections();
    populateCombo();
    sltRetranslateUI();
}

void UIRecordingScalingModeEditor::prepareWidgets()
{
    m_pLayout = new QGridLayout(this);
    if (m_pLayout)
    {
        m_pLayout->setContentsMargins(0, 0, 0, 0);
        m_pLabel = new QLabel(this);
        if (m_pLabel)
        {
            m_pLabel->setAlignment(Qt::AlignRight | Qt::AlignVCenter);
            m_pLayout->addWidget(m_pLabel, 0, 0);
        }
        m_pCombo = new QComboBox(this);
        if (m_pCombo)
        {
            if (m_pLabel)
                m_pLabel->setBuddy(m_pCombo);
            m_pCombo->setSizePolicy(QSizePolicy(QSizePolicy::MinimumExpanding, QSizePolicy::Fixed));
            m_pLayout->addWidget(m_pCombo, 0, 1);
        }
    }
}

void UIRecordingScalingModeEditor::prepareConnections()
{
    connect(m_pCombo, &QComboBox::currentIndexChanged,
            this, &UIRecordingScalingModeEditor::sigModeChange);
}

void UIRecordingScalingModeEditor::populateCombo()
{
    if (m_pCombo)
    {
        m_pCombo->clear();
        QVector<KRecordingVideoScalingMode> supportedModes = gpGlobalSession->virtualBox().GetSystemProperties().GetSupportedRecordingVSModes();
        for (int i = 0; i < supportedModes.size(); ++i)
        {
            if (supportedModes[i] < KRecordingVideoScalingMode_None || supportedModes[i] >= KRecordingVideoScalingMode_Max)
                continue;
            m_pCombo->addItem(gpConverter->toString<KRecordingVideoScalingMode>(supportedModes[i]), QVariant::fromValue(supportedModes[i]));
        }
    }
}
