/* $Id: DevVGATmpl.h 114125 2026-05-13 12:39:30Z michal.necasek@oracle.com $ */
/** @file
 * DevVGA - VBox VGA/VESA device, code templates.
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
 * --------------------------------------------------------------------
 *
 * This code is based on:
 *
 * QEMU VGA Emulator templates
 *
 * Copyright (c) 2003 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#if DEPTH == 8
#define BPP 1
#define PIXEL_TYPE uint8_t
#elif DEPTH == 15 || DEPTH == 16
#define BPP 2
#define PIXEL_TYPE uint16_t
#elif DEPTH == 32
#define BPP 4
#define PIXEL_TYPE uint32_t
#else
#error unsupport depth
#endif

#if DEPTH != 15

static inline void RT_CONCAT(vga_draw_glyph_line_, DEPTH)(uint8_t *d,
                                                          int font_data,
                                                          uint32_t xorcol,
                                                          uint32_t bgcol,
                                                          int dscan,
                                                          int linesize)
{
#if BPP == 1
        ((uint32_t *)d)[0] = (dmask16[(font_data >> 4)] & xorcol) ^ bgcol;
        ((uint32_t *)d)[1] = (dmask16[(font_data >> 0) & 0xf] & xorcol) ^ bgcol;
        if (dscan) {
            uint8_t *c = d + linesize;
            ((uint32_t *)c)[0] = ((uint32_t *)d)[0];
            ((uint32_t *)c)[1] = ((uint32_t *)d)[1];
        }
#elif BPP == 2
        ((uint32_t *)d)[0] = (dmask4[(font_data >> 6)] & xorcol) ^ bgcol;
        ((uint32_t *)d)[1] = (dmask4[(font_data >> 4) & 3] & xorcol) ^ bgcol;
        ((uint32_t *)d)[2] = (dmask4[(font_data >> 2) & 3] & xorcol) ^ bgcol;
        ((uint32_t *)d)[3] = (dmask4[(font_data >> 0) & 3] & xorcol) ^ bgcol;
        if (dscan)
            memcpy(d + linesize, d, 4 * sizeof(uint32_t));
#else
        ((uint32_t *)d)[0] = (-((font_data >> 7)) & xorcol) ^ bgcol;
        ((uint32_t *)d)[1] = (-((font_data >> 6) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[2] = (-((font_data >> 5) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[3] = (-((font_data >> 4) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[4] = (-((font_data >> 3) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[5] = (-((font_data >> 2) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[6] = (-((font_data >> 1) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[7] = (-((font_data >> 0) & 1) & xorcol) ^ bgcol;
        if (dscan)
            memcpy(d + linesize, d, 8 * sizeof(uint32_t));
#endif
}

static void RT_CONCAT(vga_draw_glyph8_, DEPTH)(uint8_t *d, int linesize,
                                               const uint8_t *font_ptr, int h,
                                               uint32_t fgcol, uint32_t bgcol, int dscan)
{
    uint32_t xorcol;
    int      font_data;

    xorcol = bgcol ^ fgcol;
    do {
        font_data = font_ptr[0];
        RT_CONCAT(vga_draw_glyph_line_, DEPTH)(d, font_data, xorcol, bgcol, dscan, linesize);
        font_ptr += 4;
        d += linesize << dscan;
        h -= 1 << dscan;
        if (h == 1)
            dscan = 0;  /* if only one scanline is left, turn off double scanning */
    } while (h > 0);
}

static void RT_CONCAT(vga_draw_glyph16_, DEPTH)(uint8_t *d, int linesize,
                                                const uint8_t *font_ptr, int h,
                                                uint32_t fgcol, uint32_t bgcol, int dscan)
{
    uint32_t xorcol;
    int      font_data;

    xorcol = bgcol ^ fgcol;
    do {
        font_data = font_ptr[0];
        RT_CONCAT(vga_draw_glyph_line_, DEPTH)(d,
                                               expand4to8[font_data >> 4],
                                               xorcol, bgcol, dscan, linesize);
        RT_CONCAT(vga_draw_glyph_line_, DEPTH)(d + 8 * BPP,
                                               expand4to8[font_data & 0x0f],
                                               xorcol, bgcol, dscan, linesize);
        font_ptr += 4;
        d += linesize << dscan;
        h -= 1 << dscan;
        if (h == 1)
            dscan = 0;  /* if only one scanline is left, turn off double scanning */
    } while (h > 0);
}

static void RT_CONCAT(vga_draw_glyph9_, DEPTH)(uint8_t *d, int linesize,
                                               const uint8_t *font_ptr, int h,
                                               uint32_t fgcol, uint32_t bgcol, int dup9)
{
    uint32_t xorcol, v;
    int      font_data;

    xorcol = bgcol ^ fgcol;
    do {
        font_data = font_ptr[0];
#if BPP == 1
        ((uint32_t *)d)[0] = RT_H2LE_U32((dmask16[(font_data >> 4)] & xorcol) ^ bgcol);
        v = (dmask16[(font_data >> 0) & 0xf] & xorcol) ^ bgcol;
        ((uint32_t *)d)[1] = RT_H2LE_U32(v);
        if (dup9)
            ((uint8_t *)d)[8] = v >> (24 * (1 - BIG));
        else
            ((uint8_t *)d)[8] = bgcol;

#elif BPP == 2
        ((uint32_t *)d)[0] = RT_H2LE_U32((dmask4[(font_data >> 6)] & xorcol) ^ bgcol);
        ((uint32_t *)d)[1] = RT_H2LE_U32((dmask4[(font_data >> 4) & 3] & xorcol) ^ bgcol);
        ((uint32_t *)d)[2] = RT_H2LE_U32((dmask4[(font_data >> 2) & 3] & xorcol) ^ bgcol);
        v = (dmask4[(font_data >> 0) & 3] & xorcol) ^ bgcol;
        ((uint32_t *)d)[3] = RT_H2LE_U32(v);
        if (dup9)
            ((uint16_t *)d)[8] = v >> (16 * (1 - BIG));
        else
            ((uint16_t *)d)[8] = bgcol;
#else
        ((uint32_t *)d)[0] = (-((font_data >> 7)) & xorcol) ^ bgcol;
        ((uint32_t *)d)[1] = (-((font_data >> 6) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[2] = (-((font_data >> 5) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[3] = (-((font_data >> 4) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[4] = (-((font_data >> 3) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[5] = (-((font_data >> 2) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[6] = (-((font_data >> 1) & 1) & xorcol) ^ bgcol;
        v = (-((font_data >> 0) & 1) & xorcol) ^ bgcol;
        ((uint32_t *)d)[7] = v;
        if (dup9)
            ((uint32_t *)d)[8] = v;
        else
            ((uint32_t *)d)[8] = bgcol;
#endif
        font_ptr += 4;
        d += linesize;
    } while (--h);
}

/* Slow glyph drawing routine that goes pixel by pixel but handles everything,
 * including skipping pixels on the left or right.
 */
static void RT_CONCAT(vga_draw_glyph_slow_, DEPTH)(uint8_t *d, int linesize,
                                                   const uint8_t *font_ptr, int h,
                                                   uint32_t fgcol, uint32_t bgcol,
                                                   int dup9, int dscan, int lr_skip, int cw)
{
    uint32_t    xorcol, v;
    int         font_data;
    int         fnt_sh, i;
    int         dclk  = 0;
    int         lskip = 0;
    int         width;

    switch (cw) {
    case 16:        // Double clocked 8-pixel wide font
        width = 8;
        dclk  = 1;
        break;
    case 9:         // 9-pixel wide text is mutually exclusive
        dscan  = 0; // with double scanning or double clocking
        width  = 9;
        break;
    default:        // Force 8-pixel wide for everything else
        width  = 8; // may or may not be double scanned
    }

    if (lr_skip > 0) {
        // Positive lr_skip means skipping pixels on the left (shift and reduce width)
        lskip = lr_skip;
        width = width - lr_skip;
    } else if (lr_skip < 0) {
        // Negative lr_skip means we skipped pixels on the left and now we need to
        // add that many pixels on the right
        width = -lr_skip;
    }

    xorcol = bgcol ^ fgcol;
    do {
        font_data = font_ptr[0];
        if (cw == 9) {
            fnt_sh = 8;
            if (dup9)
                font_data = (font_data << 1) | (font_data & 1);
            else
                font_data <<= 1;
        } else {
            fnt_sh = 7;
        }

        font_data <<= lskip;

        for (i = 0; i < width; ++i) {
            v = (-((font_data >> fnt_sh--) & 1) & xorcol) ^ bgcol;
            ((PIXEL_TYPE *)d)[i << dclk] = v;
            if (dclk)
                ((PIXEL_TYPE *)d)[(i << dclk) + 1] = v;
        }

        if (dscan)
            memcpy(d + linesize, d, (width << dclk) * sizeof(PIXEL_TYPE));

        font_ptr += 4;
        d += linesize << dscan;
        h -= 1 << dscan;
        if (h == 1)
            dscan = 0;  /* if only one scanline is left, turn off double scanning */
    } while (h > 0);
}

/*
 * 4 color mode
 */
static void RT_CONCAT(vga_draw_line2_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                              const uint8_t *s, int width, int lskip)
{
    uint32_t plane_mask, *palette, data, v, src_inc, dwb_mode;
    uint32_t vram_ofs, v1, v2;
    uint64_t vx2;
    int x;

    vram_ofs = s - pThisCC->pbVRam;
    palette = s1->last_palette;
    plane_mask = mask16[s1->ar[0x12] & 0xf];
    dwb_mode = (s1->cr[0x14] & 0x40) ? 2 : (s1->cr[0x17] & 0x40) ? 0 : 1;
    src_inc = 4 << dwb_mode;
    width >>= 3;

    for(x = 0; x < width; x++) {
        s = pThisCC->pbVRam + (vram_ofs & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v1  = expand2[GET_PLANE(data, 0)] << 16;
        v1 |= expand2[GET_PLANE(data, 2)] << 18;
        v1 |= expand2[GET_PLANE(data, 1)] << 0;
        v1 |= expand2[GET_PLANE(data, 3)] << 2;

        s = pThisCC->pbVRam + ((vram_ofs + src_inc) & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v2  = expand2[GET_PLANE(data, 0)] << 16;
        v2 |= expand2[GET_PLANE(data, 2)] << 18;
        v2 |= expand2[GET_PLANE(data, 1)] << 0;
        v2 |= expand2[GET_PLANE(data, 3)] << 2;

        vx2 = RT_MAKE_U64(v2, v1);
        vx2 <<= lskip * 4;
        v = vx2 >> 32;

        ((PIXEL_TYPE *)d)[0] = palette[v >> 28];
        ((PIXEL_TYPE *)d)[1] = palette[(v >> 24) & 0xf];
        ((PIXEL_TYPE *)d)[2] = palette[(v >> 20) & 0xf];
        ((PIXEL_TYPE *)d)[3] = palette[(v >> 16) & 0xf];
        ((PIXEL_TYPE *)d)[4] = palette[(v >> 12) & 0xf];
        ((PIXEL_TYPE *)d)[5] = palette[(v >> 8) & 0xf];
        ((PIXEL_TYPE *)d)[6] = palette[(v >> 4) & 0xf];
        ((PIXEL_TYPE *)d)[7] = palette[(v >> 0) & 0xf];

        d += BPP * 8;
        vram_ofs += src_inc;
    }
}

#if BPP == 1
#define PUT_PIXEL2(d, n, v) ((uint16_t *)d)[(n)] = (v)
#elif BPP == 2
#define PUT_PIXEL2(d, n, v) ((uint32_t *)d)[(n)] = (v)
#else
#define PUT_PIXEL2(d, n, v) \
((uint32_t *)d)[2*(n)] = ((uint32_t *)d)[2*(n)+1] = (v)
#endif

/*
 * 4 color mode, dup2 horizontal
 */
static void RT_CONCAT(vga_draw_line2d2_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                                const uint8_t *s, int width, int lskip)
{
    uint32_t plane_mask, *palette, data, v, src_inc, dwb_mode;
    uint32_t vram_ofs, v1, v2;
    uint64_t vx2;
    int x;
    RT_NOREF(pThisCC, lskip);

    vram_ofs = s - pThisCC->pbVRam;
    palette = s1->last_palette;
    plane_mask = mask16[s1->ar[0x12] & 0xf];
    dwb_mode = (s1->cr[0x14] & 0x40) ? 2 : (s1->cr[0x17] & 0x40) ? 0 : 1;
    src_inc = 4 << dwb_mode;
    width >>= 3;

    for(x = 0; x < width; x++) {
        s = pThisCC->pbVRam + (vram_ofs & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v1  = expand2[GET_PLANE(data, 0)] << 16;
        v1 |= expand2[GET_PLANE(data, 2)] << 18;
        v1 |= expand2[GET_PLANE(data, 1)] << 0;
        v1 |= expand2[GET_PLANE(data, 3)] << 2;

        s = pThisCC->pbVRam + ((vram_ofs + src_inc) & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v2  = expand2[GET_PLANE(data, 0)] << 16;
        v2 |= expand2[GET_PLANE(data, 2)] << 18;
        v2 |= expand2[GET_PLANE(data, 1)] << 0;
        v2 |= expand2[GET_PLANE(data, 3)] << 2;

        vx2 = RT_MAKE_U64(v2, v1);
        vx2 <<= lskip * 4;
        v = vx2 >> 32;

        PUT_PIXEL2(d, 0, palette[v >> 28]);
        PUT_PIXEL2(d, 1, palette[(v >> 24) & 0xf]);
        PUT_PIXEL2(d, 2, palette[(v >> 20) & 0xf]);
        PUT_PIXEL2(d, 3, palette[(v >> 16) & 0xf]);
        PUT_PIXEL2(d, 4, palette[(v >> 12) & 0xf]);
        PUT_PIXEL2(d, 5, palette[(v >> 8) & 0xf]);
        PUT_PIXEL2(d, 6, palette[(v >> 4) & 0xf]);
        PUT_PIXEL2(d, 7, palette[(v >> 0) & 0xf]);

        d += BPP * 16;
        vram_ofs += src_inc;
    }
}

/*
 * 16 color mode
 */
static void RT_CONCAT(vga_draw_line4_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                              const uint8_t *s, int width, int lskip)
{
    uint32_t plane_mask, data, v, *palette, vram_ofs;
    uint32_t v1, v2;
    uint64_t vx2;
    int x;

    vram_ofs = s - pThisCC->pbVRam;
    palette = s1->last_palette;
    plane_mask = mask16[s1->ar[0x12] & 0xf];
    width >>= 3;

    for(x = 0; x < width; x++) {
        // With VGA planar memory organization, eight 4-bit pixels live at the
        // same memory/CRTC address. Changing the CRTC start address only
        // changes the displayed image with 8-pixel granularity.
        // Pixel panning needs to shift and combine adjacent bits within
        // planes.
        s = pThisCC->pbVRam + (vram_ofs & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v1 = expand4[GET_PLANE(data, 0)];
        v1 |= expand4[GET_PLANE(data, 1)] << 1;
        v1 |= expand4[GET_PLANE(data, 2)] << 2;
        v1 |= expand4[GET_PLANE(data, 3)] << 3;

        s = pThisCC->pbVRam + ((vram_ofs + 4) & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v2 = expand4[GET_PLANE(data, 0)];
        v2 |= expand4[GET_PLANE(data, 1)] << 1;
        v2 |= expand4[GET_PLANE(data, 2)] << 2;
        v2 |= expand4[GET_PLANE(data, 3)] << 3;

        // Glue together 16 pixels, shift up to 7 pels left, keep the leftmost 8
        vx2 = RT_MAKE_U64(v2, v1);
        vx2 <<= lskip * 4;
        v = vx2 >> 32;

        ((PIXEL_TYPE *)d)[0] = palette[v >> 28];
        ((PIXEL_TYPE *)d)[1] = palette[(v >> 24) & 0xf];
        ((PIXEL_TYPE *)d)[2] = palette[(v >> 20) & 0xf];
        ((PIXEL_TYPE *)d)[3] = palette[(v >> 16) & 0xf];
        ((PIXEL_TYPE *)d)[4] = palette[(v >> 12) & 0xf];
        ((PIXEL_TYPE *)d)[5] = palette[(v >> 8) & 0xf];
        ((PIXEL_TYPE *)d)[6] = palette[(v >> 4) & 0xf];
        ((PIXEL_TYPE *)d)[7] = palette[(v >> 0) & 0xf];

        d += BPP * 8;
        vram_ofs += 4;
    }
}

/*
 * 16 color mode, dup2 horizontal
 */
static void RT_CONCAT(vga_draw_line4d2_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                                const uint8_t *s, int width, int lskip)
{
    uint32_t plane_mask, v, data, *palette, vram_ofs;
    uint32_t v1, v2;
    uint64_t vx2;
    int x;

    vram_ofs = s - pThisCC->pbVRam;
    palette = s1->last_palette;
    plane_mask = mask16[s1->ar[0x12] & 0xf];
    width >>= 3;
    for(x = 0; x < width; x++) {
        s = pThisCC->pbVRam + (vram_ofs & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v1 = expand4[GET_PLANE(data, 0)];
        v1 |= expand4[GET_PLANE(data, 1)] << 1;
        v1 |= expand4[GET_PLANE(data, 2)] << 2;
        v1 |= expand4[GET_PLANE(data, 3)] << 3;

        s = pThisCC->pbVRam + ((vram_ofs + 4) & s1->vga_addr_mask);
        data = ((uint32_t *)s)[0];
        data &= plane_mask;
        v2 = expand4[GET_PLANE(data, 0)];
        v2 |= expand4[GET_PLANE(data, 1)] << 1;
        v2 |= expand4[GET_PLANE(data, 2)] << 2;
        v2 |= expand4[GET_PLANE(data, 3)] << 3;

        vx2 = RT_MAKE_U64(v2, v1);
        vx2 <<= lskip * 4;
        v = vx2 >> 32;

        PUT_PIXEL2(d, 0, palette[v >> 28]);
        PUT_PIXEL2(d, 1, palette[(v >> 24) & 0xf]);
        PUT_PIXEL2(d, 2, palette[(v >> 20) & 0xf]);
        PUT_PIXEL2(d, 3, palette[(v >> 16) & 0xf]);
        PUT_PIXEL2(d, 4, palette[(v >> 12) & 0xf]);
        PUT_PIXEL2(d, 5, palette[(v >> 8) & 0xf]);
        PUT_PIXEL2(d, 6, palette[(v >> 4) & 0xf]);
        PUT_PIXEL2(d, 7, palette[(v >> 0) & 0xf]);

        d += BPP * 16;
        vram_ofs += 4;
    }
}

/*
 * VGA 256-color mode
 * NB: VGA 256-color is not double-clocked, but outputs pixels at half
 * the rate of EGA modes since it uses twice the bits per pixel
 */
static void RT_CONCAT(vga_draw_line8d2_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                                const uint8_t *s, int width, int lskip)
{
    uint32_t plane_mask, v, *palette, src_inc, dwb_mode, vram_ofs;
    uint32_t v1, v2;
    uint64_t vx2;
    int x;

    vram_ofs = s - pThisCC->pbVRam;
    palette = s1->last_palette;
    plane_mask = mask16[s1->ar[0x12] & 0xf];
    width >>= 3;
    if (s1->sr[0x07] & 1)
        dwb_mode = 0;   // Non-VGA modes use linear addressing
    else
        dwb_mode = (s1->cr[0x14] & 0x40) ? 2 : (s1->cr[0x17] & 0x40) ? 0 : 1;
    src_inc = 4 << dwb_mode;
    lskip >>= 1;

    // With VGA planar memory organization, four 8-bit pixels live at the
    // same memory/CRTC address, each in a separate plane. Changing the CRTC
    // start address only can only change the displayed image with 4-pixel
    // granularity. Pixel panning in effect allows starting the display
    // from plane n instead of plane 0. Things are complicated by the fact
    // that the next 4 pixels may live at addr + 1, addr + 2, or addr + 4,
    // and advancing the address may trigger wraparound.

    for(x = 0; x < width; x++) {
        s = pThisCC->pbVRam + (vram_ofs & s1->vga_addr_mask);
        v1 = ((uint32_t *)s)[0];
        v1 &= plane_mask;

        s = pThisCC->pbVRam + ((vram_ofs + src_inc) & s1->vga_addr_mask);
        v2 = ((uint32_t *)s)[0];
        v2 &= plane_mask;

        // Glue together 8 pixels, shift up to 3 pels off, keep the bottom 4
        vx2 = RT_MAKE_U64(v1, v2);
        vx2 >>= lskip * 8;
        v = (uint32_t)vx2;

        PUT_PIXEL2(d, 0, palette[GET_PLANE(v, 0)]);
        PUT_PIXEL2(d, 1, palette[GET_PLANE(v, 1)]);
        PUT_PIXEL2(d, 2, palette[GET_PLANE(v, 2)]);
        PUT_PIXEL2(d, 3, palette[GET_PLANE(v, 3)]);

        d += BPP * 8;
        vram_ofs += src_inc;
    }
}

/*
 * standard 256 color mode
 *
 * XXX: add plane_mask support (never used in standard VGA modes)
 */
static void RT_CONCAT(vga_draw_line8_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                              const uint8_t *s, int width, int lskip)
{
    uint32_t *palette, src_inc, dwb_mode;
    int x;
    RT_NOREF(pThisCC, lskip);

    palette = s1->last_palette;
    width >>= 3;
    if (s1->sr[0x07] & 1)
        dwb_mode = 0;   // Non-VGA modes use linear addressing
    else
        dwb_mode = (s1->cr[0x14] & 0x40) ? 2 : (s1->cr[0x17] & 0x40) ? 0 : 1;
    src_inc = 4 << dwb_mode;
    for(x = 0; x < width; x++) {
        ((PIXEL_TYPE *)d)[0] = palette[s[0]];
        ((PIXEL_TYPE *)d)[1] = palette[s[1]];
        ((PIXEL_TYPE *)d)[2] = palette[s[2]];
        ((PIXEL_TYPE *)d)[3] = palette[s[3]];
        s += src_inc;
        ((PIXEL_TYPE *)d)[4] = palette[s[0]];
        ((PIXEL_TYPE *)d)[5] = palette[s[1]];
        ((PIXEL_TYPE *)d)[6] = palette[s[2]];
        ((PIXEL_TYPE *)d)[7] = palette[s[3]];
        s += src_inc;
        d += BPP * 8;
    }
}

#endif /* DEPTH != 15 */


/* XXX: optimize */

/*
 * 15 bit color
 */
static void RT_CONCAT(vga_draw_line15_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                               const uint8_t *s, int width, int lskip)
{
    RT_NOREF(s1, pThisCC, lskip);
#if DEPTH == 15 && defined(WORDS_BIGENDIAN) == defined(TARGET_WORDS_BIGENDIAN)
    memcpy(d, s, width * 2);
#else
    int w;
    uint32_t v, r, g, b;

    w = width;
    do {
        v = s[0] | (s[1] << 8);
        r = (v >> 7) & 0xf8;
        g = (v >> 2) & 0xf8;
        b = (v << 3) & 0xf8;
        ((PIXEL_TYPE *)d)[0] = RT_CONCAT(rgb_to_pixel, DEPTH)(r, g, b);
        s += 2;
        d += BPP;
    } while (--w != 0);
#endif
}

/*
 * 16 bit color
 */
static void RT_CONCAT(vga_draw_line16_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                               const uint8_t *s, int width, int lskip)
{
    RT_NOREF(s1, pThisCC, lskip);
#if DEPTH == 16 && defined(WORDS_BIGENDIAN) == defined(TARGET_WORDS_BIGENDIAN)
    memcpy(d, s, width * 2);
#else
    int w;
    uint32_t v, r, g, b;

    w = width;
    do {
        v = s[0] | (s[1] << 8);
        r = (v >> 8) & 0xf8;
        g = (v >> 3) & 0xfc;
        b = (v << 3) & 0xf8;
        ((PIXEL_TYPE *)d)[0] = RT_CONCAT(rgb_to_pixel, DEPTH)(r, g, b);
        s += 2;
        d += BPP;
    } while (--w != 0);
#endif
}

/*
 * 24 bit color
 */
static void RT_CONCAT(vga_draw_line24_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                               const uint8_t *s, int width, int lskip)
{
    int w;
    uint32_t r, g, b;
    RT_NOREF(s1, pThisCC, lskip);

    w = width;
    do {
#if defined(TARGET_WORDS_BIGENDIAN)
        r = s[0];
        g = s[1];
        b = s[2];
#else
        b = s[0];
        g = s[1];
        r = s[2];
#endif
        ((PIXEL_TYPE *)d)[0] = RT_CONCAT(rgb_to_pixel, DEPTH)(r, g, b);
        s += 3;
        d += BPP;
    } while (--w != 0);
}

/*
 * 32 bit color
 */
static void RT_CONCAT(vga_draw_line32_, DEPTH)(VGAState *s1, PVGASTATER3 pThisCC, uint8_t *d,
                                               const uint8_t *s, int width, int lskip)
{
    RT_NOREF(s1, pThisCC, lskip);
#if DEPTH == 32 && defined(WORDS_BIGENDIAN) == defined(TARGET_WORDS_BIGENDIAN)
    memcpy(d, s, width * 4);
#else
    int w;
    uint32_t r, g, b;

    w = width;
    do {
#if defined(TARGET_WORDS_BIGENDIAN)
        r = s[1];
        g = s[2];
        b = s[3];
#else
        b = s[0];
        g = s[1];
        r = s[2];
#endif
        ((PIXEL_TYPE *)d)[0] = RT_CONCAT(rgb_to_pixel, DEPTH)(r, g, b);
        s += 4;
        d += BPP;
    } while (--w != 0);
#endif
}

#undef PUT_PIXEL2
#undef DEPTH
#undef BPP
#undef PIXEL_TYPE
