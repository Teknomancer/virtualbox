/* $Id: mime-type-converter.h 114357 2026-06-13 01:07:47Z knut.osmundsen@oracle.com $ */
/** @file
 * Mime-type converter for Shared Clipboard and Drag-and-Drop code.
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
 * The contents of this file may alternatively be used under the terms
 * of the Common Development and Distribution License Version 1.0
 * (CDDL), a copy of it is provided in the "COPYING.CDDL" file included
 * in the VirtualBox distribution, in which case the provisions of the
 * CDDL are applicable instead of those of the GPL.
 *
 * You may elect to license modified versions of this file under the
 * terms and conditions of either the GPL or the CDDL or both.
 *
 * SPDX-License-Identifier: GPL-3.0-only OR CDDL-1.0
 */

#ifndef VBOX_INCLUDED_GuestHost_mime_type_converter_h
#define VBOX_INCLUDED_GuestHost_mime_type_converter_h
#ifndef RT_WITHOUT_PRAGMA_ONCE
# pragma once
#endif

#include <VBox/cdefs.h>
#include <VBox/GuestHost/clipboard-helper.h>


/** @name VBGH_MIME_CONV_F_XXX - MIME type priority and flags.
 * @{ */
/** Priority mask.
 * The priority of MIME types mapping to the same SHCLFORMAT and flags.
 * Higher value means higher priority. Range is range 0 thru 15.
 *
 * @note This assumes that we can use one common priority for all
 *       clipboard/toolkit implementations. Should we end up with different
 *       preferences, we'd have to partition it.
 */
#define VBGH_MIME_CONV_F_PRIORITY_MASK      UINT32_C(0x0000000f)
/** @} */

/**
 * MIME type enumeration callback function for use with
 * VbghMimeConvEnumerateByVBoxFormat().
 *
 * This is called for each MIME type matching the VBox format passed to
 * VbghMimeConvEnumerateByVBoxFormat().
 *
 * @param   pcszMimeType        String representation of a mime-type.
 * @param   fFlagsAndPriority   To be exported.
 * @param   pvUser              User data.
 */
typedef DECLCALLBACKTYPE(void, FNVBGHMIMECONVENUM, (const char *pcszMimeType, uint32_t fFlagsAndPriority, void *pvUser));
/** Pointer to a FNVBGHMIMECONVENUM. */
typedef FNVBGHMIMECONVENUM *PFNVBGHMIMECONVENUM;

/**
 * Enumerate list of MIME types by ID mask.
 *
 * This function goes through the list of supported MIME types and
 * triggers given callback function for each of them.
 *
 * @param   uFmtVBox        Formats bitmask in VBox representation.
 * @param   pfnCallback     Callback function.
 * @param   pvUser          User data.
 */
VBGH_DECL(void) VbghMimeConvEnumerateByVBoxFormat(const SHCLFORMAT uFmtVBox, PFNVBGHMIMECONVENUM pfnCallback, void *pvUser);

/**
 * Find VBox format for the given MIME type.
 *
 * @returns VBox format. VBOX_SHCL_FMT_NONE if no translation found.
 * @param   pcszMimeType        MIME type to convert.
 * @param   pfFlagsAndPriority  The priority and flags (VBGH_MIME_CONV_F_XXX).
 *                              Optional.
 */
VBGH_DECL(SHCLFORMAT) VbghMimeConvGetVBoxFormatByMime(const char *pcszMimeType, uint32_t *pfFlagsAndPriority);

/**
 * Converts from VirtualBox to X11/Wayland clipboard data format.
 *
 * @returns IPRT status code.
 * @param   pcszMimeType    Target MIME type.
 * @param   pvBufIn         Input buffer which contains data in VBox format.
 * @param   cbBufIn         Size of input buffer in bytes.
 * @param   ppvBufOut       Newly allocated output buffer which will contain data
 *                          in specified mime-type format (must be freed by caller).
 * @param   pcbBufOut       Size of output buffer.
 */
VBGH_DECL(int) VbghMimeConvFromVBox(const char *pcszMimeType, void *pvBufIn, int cbBufIn, void **ppvBufOut, size_t *pcbBufOut);

/**
 * Converts data from native format into VBox internal representation.
 *
 * @returns IPRT status code.
 * @param   pcszMimeType    Source MIME type.
 * @param   pvBufIn         Input buffer which contains data in specified mime-type format.
 * @param   cbBufIn         Size of input buffer in bytes.
 * @param   ppvBufOut       Newly allocated output buffer which will contain image data
 *                          in VBox internal representation format (must be freed by caller).
 * @param   pcbBufOut       Size of output buffer.
 */
VBGH_DECL(int) VbghMimeConvToVBox(const char *pcszMimeType, void *pvBufIn, int cbBufIn, void **ppvBufOut, size_t *pcbBufOut);


/** Mime-type cache handle.
 * @todo r=bird: Coding conventions... This can be entriely opaque! */
typedef struct vbox_mime_conv_cache_s
{
    /** Cache lock. */
    RTCRITSECT  CritSect;
    /** Number of elements in cache table. */
    size_t      iCacheElements;
    /** Opaque cache storage. */
    void        *pvCache;
} vbox_mime_conv_cache_t;

/**
 * Initializes mapping table cache.
 *
 * Must be called before any other VBoxMimeConvXXXCacheYYY call.
 *
 * @returns IPRT status code.
 * @param   pCache          Cache handle.
 */
VBGH_DECL(int) VBoxMimeConvInitCache(vbox_mime_conv_cache_t *pCache);

/**
 * Destroys mapping table cache.
 *
 * @returns IPRT status code.
 * @param   pCache          Cache handle.
 */
VBGH_DECL(int) VBoxMimeConvDestroyCache(vbox_mime_conv_cache_t *pCache);

/**
 * Clears mapping table cache.
 *
 * @returns IPRT status code.
 * @param   pCache          Cache handle.
 */
VBGH_DECL(int) VBoxMimeConvClearCache(vbox_mime_conv_cache_t *pCache);

/**
 * Adds data into cache using mime-type as a key.
 *
 * @returns VINF_SUCCESS on success, VERR_NOT_FOUND if given memi-type is unknown or IPRT error code.
 * @param   pCache          Cache handle.
 * @param   pcszMimeType    Mime-type in string representation.
 * @param   pvBuf           Input buffer which contains data in specified mime-type format.
 * @param   cbBuf           Size of input buffer in bytes.
 */
VBGH_DECL(int) VBoxMimeConvSetCacheByMime(vbox_mime_conv_cache_t *pCache, const char *pcszMimeType, void *pvBuf, int cbBuf);

/**
 * Extracts data from cache using mime-type as a key.
 *
 * @returns VINF_SUCCESS on success, VERR_NOT_FOUND if no cache entry corresponds to
 *          given memi-type or IPRT error code.
 * @param   pCache          Cache handle.
 * @param   pcszMimeType    Mime-type in string representation.
 * @param   ppvBufOut       Data which corresponds to given mime-type.
 * @param   pcbBufOut       Size of output buffer.
 */
VBGH_DECL(int) VBoxMimeConvGetCacheByMime(vbox_mime_conv_cache_t *pCache, const char *pcszMimeType, void **ppvBufOut, size_t *pcbBufOut);

/**
 * Extracts data from cache using format ID as a key.
 *
 * @returns VINF_SUCCESS on success, VERR_NOT_FOUND if no cache entry corresponds to
 *          given memi-type or IPRT error code.
 * @param   pCache          Cache handle.
 * @param   uFmtVBox        Format ID in VBox representation.
 * @param   ppvBufOut       Data which corresponds to given mime-type.
 * @param   pcbBufOut       Size of output buffer.
 */
VBGH_DECL(int) VBoxMimeConvGetCacheById(vbox_mime_conv_cache_t *pCache, const SHCLFORMAT uFmtVBox, void **ppvBufOut, size_t *pcbBufOut);

#endif /* !VBOX_INCLUDED_GuestHost_mime_type_converter_h */

