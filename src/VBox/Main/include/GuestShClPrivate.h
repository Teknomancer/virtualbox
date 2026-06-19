/* $Id: GuestShClPrivate.h 114453 2026-06-19 09:25:11Z andreas.loeffler@oracle.com $ */
/** @file
 * Private Shared Clipboard code for the Main API.
 */

/*
 * Copyright (C) 2023-2026 Oracle and/or its affiliates.
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

#ifndef MAIN_INCLUDED_GuestShClPrivate_h
#define MAIN_INCLUDED_GuestShClPrivate_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include <iprt/thread.h>

#include <VBox/HostServices/VBoxClipboardExt.h>
#include <VBox/HostServices/VBoxSharedClipboardSvc.h>

/**
 * Forward prototype declarations.
 */
class Console;

/**
 * Struct for keeping a Shared Clipboard service extension.
 */
struct SHCLSVCEXT
{
    /** Service extension callback function.
     *  Setting this to NULL deactivates the extension. */
    PFNHGCMSVCEXT      pfnExt;
    /** User-supplied service extension data. Might be NULL if not being used. */
    void            *  pvExt;
    /** Pointer to an optional extension callback.
     *  Might be NULL if not being used. */
    PFNSHCLEXTCALLBACK pfnExtCallback;
};
/** Pointer to a Shared Clipboard service extension. */
typedef SHCLSVCEXT *PSHCLSVCEXT;

/**
 * Private singleton class for managing the Shared Clipboard implementation within Main.
 *
 * Can't be instanciated directly, only via the factory pattern via GuestShCl::createInstance().
 */
class GuestShCl
{
public:

    /**
     * Creates the Singleton GuestShCl object.
     *
     * @returns Newly created Singleton object, or NULL on failure.
     * @param   pConsole        Pointer to parent console.
     */
    static GuestShCl *createInstance(Console *pConsole)
    {
        AssertPtrReturn(pConsole, NULL);
        Assert(NULL == GuestShCl::s_pInstance);
        GuestShCl::s_pInstance = new GuestShCl(pConsole);
        return GuestShCl::s_pInstance;
    }

    /**
     * Destroys the Singleton GuestShCl object.
     */
    static void destroyInstance(void)
    {
        if (GuestShCl::s_pInstance)
        {
            delete GuestShCl::s_pInstance;
            GuestShCl::s_pInstance = NULL;
        }
    }

    /**
     * Returns the Singleton GuestShCl object.
     *
     * @returns Pointer to Singleton GuestShCl object, or NULL if not created yet.
     */
    static inline GuestShCl *getInstance(void)
    {
        AssertPtr(GuestShCl::s_pInstance);
        return GuestShCl::s_pInstance;
    }

    /**
     * Returns the Singleton GuestShCl object, if it has been created.
     *
     * @returns Pointer to Singleton GuestShCl object, or NULL if not created yet.
     */
    static inline GuestShCl *tryGetInstance(void)
    {
        return GuestShCl::s_pInstance;
    }

protected:

    /** Constructor; will throw vrc on failure. */
    GuestShCl(Console *pConsole);
    virtual ~GuestShCl(void);

    /** @name Object state helpers.
     * @{ */
    void uninit(void);
    int lock(void);
    int unlock(void);
    uint64_t i_incHostDataSeq(void);
    uint64_t i_incHostDataSeqLocked(void);
    uint64_t i_incGuestDataSeq(void);
    uint64_t i_getHostDataSeq(void);
    bool i_isHostDataSeqCurrent(uint64_t uSeq);
    bool i_isHostDataSeqCurrentLocked(uint64_t uSeq);
    uint64_t i_getGuestDataSeq(void);
    bool i_isGuestDataSeqCurrent(uint64_t uSeq);
    /** @}  */

public:

    /** @name Public helper functions.
     * @{ */
    int hostCall(uint32_t u32Function, uint32_t cParms, PVBOXHGCMSVCPARM paParms) const;
    int readDataFromGuest(SHCLFORMAT uFormat, void **ppvData, uint32_t *pcbData);
    int reportFormatsToGuest(SHCLFORMATS fFormats);
    int reportFormatsToGuest(PSHCLCLIENT pClient, SHCLFORMATS fFormats, SHCLSOURCE enmSource);
    int reportHostDataAsync(SHCLFORMATS fFormats, SHCLSOURCE enmSource, uint64_t uSeq);
    int reportHostData(SHCLFORMATS fFormats, SHCLSOURCE enmSource, uint64_t uSeq);
    int reportError(const char *pcszId, int vrc, const char *pcszMsgFmt, ...);
    int RegisterServiceExtension(PFNHGCMSVCEXT pfnExtension, void *pvExtension);
    int UnregisterServiceExtension(PFNHGCMSVCEXT pfnExtension);
    /** @}  */

public:

    /** @name Static low-level HGCM callback handler.
     * @{ */
    static DECLCALLBACK(int) hgcmDispatcher(void *pvExtension, uint32_t u32Function, void *pvParms, uint32_t cbParms);
    static DECLCALLBACK(int) reportHostDataThread(RTTHREAD hThread, void *pvUser);
    /** @}  */

protected:

    /** @name Service extension callback helpers.
     * @{ */
    int i_forwardToChainedSvcExt(uint32_t u32Function, void *pvParms, uint32_t cbParms);
    /** @}  */

protected:

    /** @name Service extension callback handlers.
     * @{ */
    int i_handleSvcExtSetCallback(PSHCLEXTPARMS pParms);
    int i_handleSvcExtReportFormatsToHost(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtReportFormatsToGuest(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtDataRead(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtDataReadVrde(PSHCLEXTPARMS pParms);
    int i_handleSvcExtDataWrite(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtBackendInit(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtBackendDestroy(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtBackendConnect(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtBackendDisconnect(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtBackendSync(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
    int i_handleSvcExtError(PSHCLEXTPARMS pParms);
#ifdef VBOX_WITH_SHARED_CLIPBOARD_TRANSFERS
    int i_handleSvcExtFileTransfer(PSHCLEXTPARMS pParms, void *pvParms, uint32_t cbParms);
#endif
    /** @}  */

    /** @name Singleton properties.
     * @{ */
    /** Pointer to console.
     *  Does not need any locking, as this object is a member of the console itself. */
    Console                    *m_pConsole;
    /** Critical section to serialize access. */
    RTCRITSECT                  m_CritSect;
    /** Pointer an additional service extension handle to serve (daisy chaining).
     *
     *  This currently only is being used by the Console VRDP server helper class (historical reasons).
     *  We might want to transform this into a map later if we (ever) need more than one service extension,
     *  or drop this concept althogether when we move the service stuff out of the VM process (later). */
    SHCLSVCEXT                  m_SvcExtVRDP;
    /** Pointer to an optional extension callback.
     *  Might be NULL if not being used. */
    PFNSHCLEXTCALLBACK          m_pfnExtCallback;
    /** Active guest clipboard client, if any.
     *  Weak pointer owned by the HGCM service and protected by m_CritSect. */
    PSHCLCLIENT                 m_pClient;
    /** Host data sequence counter, protected by m_CritSect. */
    uint64_t                    m_uHostDataSeq;
    /** Guest data sequence counter, protected by m_CritSect. */
    uint64_t                    m_uGuestDataSeq;
    /** @}  */

private:

    /** Static pointer to singleton instance. */
    static GuestShCl           *s_pInstance;
};

/** Access to the GuestShCl's singleton instance. */
#define GuestShClInst() GuestShCl::getInstance()

#endif /* !MAIN_INCLUDED_GuestShClPrivate_h */

