/* $Id: UISharedClipboardProvider.h 114562 2026-06-29 10:30:36Z andreas.loeffler@oracle.com $ */
/** @file
 * VBox Qt GUI - UISharedClipboardProvider class declaration.
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

#ifndef FEQT_INCLUDED_SRC_runtime_UISharedClipboardProvider_h
#define FEQT_INCLUDED_SRC_runtime_UISharedClipboardProvider_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

/* Qt includes: */
#include <QObject>

/* COM includes: */
#include "CClipboardSession.h"
#include "CEventListener.h"
#include "CEventSource.h"
#include "CHostClipboard.h"

/* Forward declarations: */
class UISession;
class UISharedClipboardProviderThread;

/** Runtime shared clipboard provider using a session-aware Main clipboard API. */
class UISharedClipboardProvider : public QObject
{
    Q_OBJECT;

signals:

    /** Notifies about a shared clipboard error suitable for the notification center.
      * @param  strMsg  Brings the error message. */
    void sigClipboardError(const QString &strMsg);

public:

    /** Constructs a shared clipboard provider.
      * @param  pSession  Brings the UI session this provider belongs to. */
    UISharedClipboardProvider(UISession *pSession);
    /** Destructs the shared clipboard provider. */
    virtual ~UISharedClipboardProvider() RT_OVERRIDE;

    /** Prepares the provider. */
    void prepare();

private slots:

    /** Handles event worker thread termination. */
    void sltHandleThreadFinished();

private:
    /** Prepares the clipboard session. */
    void prepareSession();
    /** Prepares the session event listener. */
    void prepareListener();
    /** Prepares the event worker thread. */
    void prepareThread();
    /** Cleans up the event worker thread.
      * @returns @c true if the thread is stopped or was not running. */
    bool cleanupThread();
    /** Cleans up the session event listener. */
    void cleanupListener();
    /** Cleans up the clipboard session. */
    void cleanupSession();
    /** Cleans up the provider. */
    void cleanup();

    /** Holds the UI session reference. */
    UISession *m_pSession;
    /** Holds the clipboard session. */
    CClipboardSession m_comClipboardSession;
    /** Holds the session host clipboard endpoint. */
    CHostClipboard m_comHostClipboard;
    /** Holds the session event source. */
    CEventSource m_comEventSource;
    /** Holds the passive event listener. */
    CEventListener m_comEventListener;
    /** Holds the clipboard event worker thread. */
    UISharedClipboardProviderThread *m_pThread;
};

#endif /* !FEQT_INCLUDED_SRC_runtime_UISharedClipboardProvider_h */
