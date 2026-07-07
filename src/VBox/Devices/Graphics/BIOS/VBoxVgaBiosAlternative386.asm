; $Id: VBoxVgaBiosAlternative386.asm 114642 2026-07-07 18:33:04Z klaus.espenlaub@oracle.com $
;; @file
; Auto Generated source file. Do not edit.
;

;
; Source file: vgarom.asm
;
;  ============================================================================================
;
;   Copyright (C) 2001,2002 the LGPL VGABios developers Team
;
;   This library is free software; you can redistribute it and/or
;   modify it under the terms of the GNU Lesser General Public
;   License as published by the Free Software Foundation; either
;   version 2 of the License, or (at your option) any later version.
;
;   This library is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;   Lesser General Public License for more details.
;
;   You should have received a copy of the GNU Lesser General Public
;   License along with this library; if not, write to the Free Software
;   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
;
;  ============================================================================================
;
;   This VGA Bios is specific to the plex86/bochs Emulated VGA card.
;   You can NOT drive any physical vga card with it.
;
;  ============================================================================================
;

;
; Source file: vberom.asm
;
;  ============================================================================================
;
;   Copyright (C) 2002 Jeroen Janssen
;
;   This library is free software; you can redistribute it and/or
;   modify it under the terms of the GNU Lesser General Public
;   License as published by the Free Software Foundation; either
;   version 2 of the License, or (at your option) any later version.
;
;   This library is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;   Lesser General Public License for more details.
;
;   You should have received a copy of the GNU Lesser General Public
;   License along with this library; if not, write to the Free Software
;   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
;
;  ============================================================================================
;
;   This VBE is part of the VGA Bios specific to the plex86/bochs Emulated VGA card.
;   You can NOT drive any physical vga card with it.
;
;  ============================================================================================
;
;   This VBE Bios is based on information taken from :
;    - VESA BIOS EXTENSION (VBE) Core Functions Standard Version 3.0 located at www.vesa.org
;
;  ============================================================================================

;
; Source file: vgabios.c
;
;  // ============================================================================================
;
;  vgabios.c
;
;  // ============================================================================================
;  //
;  //  Copyright (C) 2001,2002 the LGPL VGABios developers Team
;  //
;  //  This library is free software; you can redistribute it and/or
;  //  modify it under the terms of the GNU Lesser General Public
;  //  License as published by the Free Software Foundation; either
;  //  version 2 of the License, or (at your option) any later version.
;  //
;  //  This library is distributed in the hope that it will be useful,
;  //  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  //  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;  //  Lesser General Public License for more details.
;  //
;  //  You should have received a copy of the GNU Lesser General Public
;  //  License along with this library; if not, write to the Free Software
;  //  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
;  //
;  // ============================================================================================
;  //
;  //  This VGA Bios is specific to the plex86/bochs Emulated VGA card.
;  //  You can NOT drive any physical vga card with it.
;  //
;  // ============================================================================================
;  //
;  //  This file contains code ripped from :
;  //   - rombios.c of plex86
;  //
;  //  This VGA Bios contains fonts from :
;  //   - fntcol16.zip (c) by Joseph Gil avalable at :
;  //      ftp://ftp.simtel.net/pub/simtelnet/msdos/screen/fntcol16.zip
;  //     These fonts are public domain
;  //
;  //  This VGA Bios is based on information taken from :
;  //   - Kevin Lawton's vga card emulation for bochs/plex86
;  //   - Ralf Brown's interrupts list available at http://www.cs.cmu.edu/afs/cs/user/ralf/pub/WWW/files.html
;  //   - Finn Thogersons' VGADOC4b available at http://home.worldonline.dk/~finth/
;  //   - Michael Abrash's Graphics Programming Black Book
;  //   - Francois Gervais' book "programmation des cartes graphiques cga-ega-vga" edited by sybex
;  //   - DOSEMU 1.0.1 source code for several tables values and formulas
;  //
;  // Thanks for patches, comments and ideas to :
;  //   - techt@pikeonline.net
;  //
;  // ============================================================================================

;
; Source file: vbe.c
;
;  // ============================================================================================
;  //
;  //  Copyright (C) 2002 Jeroen Janssen
;  //
;  //  This library is free software; you can redistribute it and/or
;  //  modify it under the terms of the GNU Lesser General Public
;  //  License as published by the Free Software Foundation; either
;  //  version 2 of the License, or (at your option) any later version.
;  //
;  //  This library is distributed in the hope that it will be useful,
;  //  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  //  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;  //  Lesser General Public License for more details.
;  //
;  //  You should have received a copy of the GNU Lesser General Public
;  //  License along with this library; if not, write to the Free Software
;  //  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
;  //
;  // ============================================================================================
;  //
;  //  This VBE is part of the VGA Bios specific to the plex86/bochs Emulated VGA card.
;  //  You can NOT drive any physical vga card with it.
;  //
;  // ============================================================================================
;  //
;  //  This VBE Bios is based on information taken from :
;  //   - VESA BIOS EXTENSION (VBE) Core Functions Standard Version 3.0 located at www.vesa.org
;  //
;  // ============================================================================================

;
; Oracle LGPL Disclaimer: For the avoidance of doubt, except that if any license choice
; other than GPL or LGPL is available it will apply instead, Oracle elects to use only
; the Lesser General Public License version 2.1 (LGPLv2) at this time for any software where
; a choice of LGPL license versions is made available with the language indicating
; that LGPLv2 or any later version may be used, or where a choice of which version
; of the LGPL is applied is otherwise unspecified.
;





section VGAROM progbits vstart=0x0 align=1 ; size=0x910 class=CODE group=AUTO
  ; disGetNextSymbol 0xc0000 LB 0x910 -> off=0x28 cb=0000000000000548 uValue=00000000000c0028 'vgabios_int10_handler'
    db  055h, 0aah, 040h, 0ebh, 01dh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 049h, 042h
    db  04dh, 000h, 00eh, 01fh, 0fch, 0e9h, 03ch, 00ah
vgabios_int10_handler:                       ; 0xc0028 LB 0x548
    pushfw                                    ; 9c                          ; 0xc0028 vgarom.asm:91
    cmp ah, 00fh                              ; 80 fc 0f                    ; 0xc0029 vgarom.asm:104
    jne short 00034h                          ; 75 06                       ; 0xc002c vgarom.asm:105
    call 0017dh                               ; e8 4c 01                    ; 0xc002e vgarom.asm:106
    jmp near 000edh                           ; e9 b9 00                    ; 0xc0031 vgarom.asm:107
    cmp ah, 01ah                              ; 80 fc 1a                    ; 0xc0034 vgarom.asm:109
    jne short 0003fh                          ; 75 06                       ; 0xc0037 vgarom.asm:110
    call 00532h                               ; e8 f6 04                    ; 0xc0039 vgarom.asm:111
    jmp near 000edh                           ; e9 ae 00                    ; 0xc003c vgarom.asm:112
    cmp ah, 00bh                              ; 80 fc 0b                    ; 0xc003f vgarom.asm:114
    jne short 0004ah                          ; 75 06                       ; 0xc0042 vgarom.asm:115
    call 000efh                               ; e8 a8 00                    ; 0xc0044 vgarom.asm:116
    jmp near 000edh                           ; e9 a3 00                    ; 0xc0047 vgarom.asm:117
    cmp ax, 01103h                            ; 3d 03 11                    ; 0xc004a vgarom.asm:119
    jne short 00055h                          ; 75 06                       ; 0xc004d vgarom.asm:120
    call 00429h                               ; e8 d7 03                    ; 0xc004f vgarom.asm:121
    jmp near 000edh                           ; e9 98 00                    ; 0xc0052 vgarom.asm:122
    cmp ah, 012h                              ; 80 fc 12                    ; 0xc0055 vgarom.asm:124
    jne short 00097h                          ; 75 3d                       ; 0xc0058 vgarom.asm:125
    cmp bl, 010h                              ; 80 fb 10                    ; 0xc005a vgarom.asm:126
    jne short 00065h                          ; 75 06                       ; 0xc005d vgarom.asm:127
    call 00436h                               ; e8 d4 03                    ; 0xc005f vgarom.asm:128
    jmp near 000edh                           ; e9 88 00                    ; 0xc0062 vgarom.asm:129
    cmp bl, 030h                              ; 80 fb 30                    ; 0xc0065 vgarom.asm:131
    jne short 0006fh                          ; 75 05                       ; 0xc0068 vgarom.asm:132
    call 00459h                               ; e8 ec 03                    ; 0xc006a vgarom.asm:133
    jmp short 000edh                          ; eb 7e                       ; 0xc006d vgarom.asm:134
    cmp bl, 031h                              ; 80 fb 31                    ; 0xc006f vgarom.asm:136
    jne short 00079h                          ; 75 05                       ; 0xc0072 vgarom.asm:137
    call 004ach                               ; e8 35 04                    ; 0xc0074 vgarom.asm:138
    jmp short 000edh                          ; eb 74                       ; 0xc0077 vgarom.asm:139
    cmp bl, 032h                              ; 80 fb 32                    ; 0xc0079 vgarom.asm:141
    jne short 00083h                          ; 75 05                       ; 0xc007c vgarom.asm:142
    call 004ceh                               ; e8 4d 04                    ; 0xc007e vgarom.asm:143
    jmp short 000edh                          ; eb 6a                       ; 0xc0081 vgarom.asm:144
    cmp bl, 033h                              ; 80 fb 33                    ; 0xc0083 vgarom.asm:146
    jne short 0008dh                          ; 75 05                       ; 0xc0086 vgarom.asm:147
    call 004ech                               ; e8 61 04                    ; 0xc0088 vgarom.asm:148
    jmp short 000edh                          ; eb 60                       ; 0xc008b vgarom.asm:149
    cmp bl, 034h                              ; 80 fb 34                    ; 0xc008d vgarom.asm:151
    jne short 000e1h                          ; 75 4f                       ; 0xc0090 vgarom.asm:152
    call 00510h                               ; e8 7b 04                    ; 0xc0092 vgarom.asm:153
    jmp short 000edh                          ; eb 56                       ; 0xc0095 vgarom.asm:154
    cmp ax, 0101bh                            ; 3d 1b 10                    ; 0xc0097 vgarom.asm:156
    je short 000e1h                           ; 74 45                       ; 0xc009a vgarom.asm:157
    cmp ah, 010h                              ; 80 fc 10                    ; 0xc009c vgarom.asm:158
    jne short 000a6h                          ; 75 05                       ; 0xc009f vgarom.asm:162
    call 001a4h                               ; e8 00 01                    ; 0xc00a1 vgarom.asm:164
    jmp short 000edh                          ; eb 47                       ; 0xc00a4 vgarom.asm:165
    cmp ah, 04fh                              ; 80 fc 4f                    ; 0xc00a6 vgarom.asm:168
    jne short 000e1h                          ; 75 36                       ; 0xc00a9 vgarom.asm:169
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc00ab vgarom.asm:170
    jne short 000b4h                          ; 75 05                       ; 0xc00ad vgarom.asm:171
    call 007dbh                               ; e8 29 07                    ; 0xc00af vgarom.asm:172
    jmp short 000edh                          ; eb 39                       ; 0xc00b2 vgarom.asm:173
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc00b4 vgarom.asm:175
    jne short 000bdh                          ; 75 05                       ; 0xc00b6 vgarom.asm:176
    call 00800h                               ; e8 45 07                    ; 0xc00b8 vgarom.asm:177
    jmp short 000edh                          ; eb 30                       ; 0xc00bb vgarom.asm:178
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc00bd vgarom.asm:180
    jne short 000c6h                          ; 75 05                       ; 0xc00bf vgarom.asm:181
    call 0082dh                               ; e8 69 07                    ; 0xc00c1 vgarom.asm:182
    jmp short 000edh                          ; eb 27                       ; 0xc00c4 vgarom.asm:183
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc00c6 vgarom.asm:185
    jne short 000cfh                          ; 75 05                       ; 0xc00c8 vgarom.asm:186
    call 00861h                               ; e8 94 07                    ; 0xc00ca vgarom.asm:187
    jmp short 000edh                          ; eb 1e                       ; 0xc00cd vgarom.asm:188
    cmp AL, strict byte 009h                  ; 3c 09                       ; 0xc00cf vgarom.asm:190
    jne short 000d8h                          ; 75 05                       ; 0xc00d1 vgarom.asm:191
    call 00898h                               ; e8 c2 07                    ; 0xc00d3 vgarom.asm:192
    jmp short 000edh                          ; eb 15                       ; 0xc00d6 vgarom.asm:193
    cmp AL, strict byte 00ah                  ; 3c 0a                       ; 0xc00d8 vgarom.asm:195
    jne short 000e1h                          ; 75 05                       ; 0xc00da vgarom.asm:196
    call 008fch                               ; e8 1d 08                    ; 0xc00dc vgarom.asm:197
    jmp short 000edh                          ; eb 0c                       ; 0xc00df vgarom.asm:198
    push ES                                   ; 06                          ; 0xc00e1 vgarom.asm:202
    push DS                                   ; 1e                          ; 0xc00e2 vgarom.asm:203
    pushaw                                    ; 60                          ; 0xc00e3 vgarom.asm:107
    push CS                                   ; 0e                          ; 0xc00e4 vgarom.asm:207
    pop DS                                    ; 1f                          ; 0xc00e5 vgarom.asm:208
    cld                                       ; fc                          ; 0xc00e6 vgarom.asm:209
    call 0362eh                               ; e8 44 35                    ; 0xc00e7 vgarom.asm:210
    popaw                                     ; 61                          ; 0xc00ea vgarom.asm:124
    pop DS                                    ; 1f                          ; 0xc00eb vgarom.asm:213
    pop ES                                    ; 07                          ; 0xc00ec vgarom.asm:214
    popfw                                     ; 9d                          ; 0xc00ed vgarom.asm:216
    iret                                      ; cf                          ; 0xc00ee vgarom.asm:217
    cmp bh, 000h                              ; 80 ff 00                    ; 0xc00ef vgarom.asm:222
    je short 000fah                           ; 74 06                       ; 0xc00f2 vgarom.asm:223
    cmp bh, 001h                              ; 80 ff 01                    ; 0xc00f4 vgarom.asm:224
    je short 0014bh                           ; 74 52                       ; 0xc00f7 vgarom.asm:225
    retn                                      ; c3                          ; 0xc00f9 vgarom.asm:229
    push ax                                   ; 50                          ; 0xc00fa vgarom.asm:231
    push bx                                   ; 53                          ; 0xc00fb vgarom.asm:232
    push cx                                   ; 51                          ; 0xc00fc vgarom.asm:233
    push dx                                   ; 52                          ; 0xc00fd vgarom.asm:234
    push DS                                   ; 1e                          ; 0xc00fe vgarom.asm:235
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc00ff vgarom.asm:236
    mov ds, dx                                ; 8e da                       ; 0xc0102 vgarom.asm:237
    mov dx, 003dah                            ; ba da 03                    ; 0xc0104 vgarom.asm:238
    in AL, DX                                 ; ec                          ; 0xc0107 vgarom.asm:239
    cmp byte [word 00049h], 003h              ; 80 3e 49 00 03              ; 0xc0108 vgarom.asm:240
    jbe short 0013eh                          ; 76 2f                       ; 0xc010d vgarom.asm:241
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc010f vgarom.asm:242
    mov AL, strict byte 000h                  ; b0 00                       ; 0xc0112 vgarom.asm:243
    out DX, AL                                ; ee                          ; 0xc0114 vgarom.asm:244
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0115 vgarom.asm:245
    and AL, strict byte 00fh                  ; 24 0f                       ; 0xc0117 vgarom.asm:246
    test AL, strict byte 008h                 ; a8 08                       ; 0xc0119 vgarom.asm:247
    je short 0011fh                           ; 74 02                       ; 0xc011b vgarom.asm:248
    add AL, strict byte 008h                  ; 04 08                       ; 0xc011d vgarom.asm:249
    out DX, AL                                ; ee                          ; 0xc011f vgarom.asm:251
    mov CL, strict byte 001h                  ; b1 01                       ; 0xc0120 vgarom.asm:252
    and bl, 010h                              ; 80 e3 10                    ; 0xc0122 vgarom.asm:253
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0125 vgarom.asm:255
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc0128 vgarom.asm:256
    out DX, AL                                ; ee                          ; 0xc012a vgarom.asm:257
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc012b vgarom.asm:258
    in AL, DX                                 ; ec                          ; 0xc012e vgarom.asm:259
    and AL, strict byte 0efh                  ; 24 ef                       ; 0xc012f vgarom.asm:260
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc0131 vgarom.asm:261
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0133 vgarom.asm:262
    out DX, AL                                ; ee                          ; 0xc0136 vgarom.asm:263
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc0137 vgarom.asm:264
    cmp cl, 004h                              ; 80 f9 04                    ; 0xc0139 vgarom.asm:265
    jne short 00125h                          ; 75 e7                       ; 0xc013c vgarom.asm:266
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc013e vgarom.asm:268
    out DX, AL                                ; ee                          ; 0xc0140 vgarom.asm:269
    mov dx, 003dah                            ; ba da 03                    ; 0xc0141 vgarom.asm:271
    in AL, DX                                 ; ec                          ; 0xc0144 vgarom.asm:272
    pop DS                                    ; 1f                          ; 0xc0145 vgarom.asm:274
    pop dx                                    ; 5a                          ; 0xc0146 vgarom.asm:275
    pop cx                                    ; 59                          ; 0xc0147 vgarom.asm:276
    pop bx                                    ; 5b                          ; 0xc0148 vgarom.asm:277
    pop ax                                    ; 58                          ; 0xc0149 vgarom.asm:278
    retn                                      ; c3                          ; 0xc014a vgarom.asm:279
    push ax                                   ; 50                          ; 0xc014b vgarom.asm:281
    push bx                                   ; 53                          ; 0xc014c vgarom.asm:282
    push cx                                   ; 51                          ; 0xc014d vgarom.asm:283
    push dx                                   ; 52                          ; 0xc014e vgarom.asm:284
    mov dx, 003dah                            ; ba da 03                    ; 0xc014f vgarom.asm:285
    in AL, DX                                 ; ec                          ; 0xc0152 vgarom.asm:286
    mov CL, strict byte 001h                  ; b1 01                       ; 0xc0153 vgarom.asm:287
    and bl, 001h                              ; 80 e3 01                    ; 0xc0155 vgarom.asm:288
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0158 vgarom.asm:290
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc015b vgarom.asm:291
    out DX, AL                                ; ee                          ; 0xc015d vgarom.asm:292
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc015e vgarom.asm:293
    in AL, DX                                 ; ec                          ; 0xc0161 vgarom.asm:294
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc0162 vgarom.asm:295
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc0164 vgarom.asm:296
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0166 vgarom.asm:297
    out DX, AL                                ; ee                          ; 0xc0169 vgarom.asm:298
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc016a vgarom.asm:299
    cmp cl, 004h                              ; 80 f9 04                    ; 0xc016c vgarom.asm:300
    jne short 00158h                          ; 75 e7                       ; 0xc016f vgarom.asm:301
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0171 vgarom.asm:302
    out DX, AL                                ; ee                          ; 0xc0173 vgarom.asm:303
    mov dx, 003dah                            ; ba da 03                    ; 0xc0174 vgarom.asm:305
    in AL, DX                                 ; ec                          ; 0xc0177 vgarom.asm:306
    pop dx                                    ; 5a                          ; 0xc0178 vgarom.asm:308
    pop cx                                    ; 59                          ; 0xc0179 vgarom.asm:309
    pop bx                                    ; 5b                          ; 0xc017a vgarom.asm:310
    pop ax                                    ; 58                          ; 0xc017b vgarom.asm:311
    retn                                      ; c3                          ; 0xc017c vgarom.asm:312
    push DS                                   ; 1e                          ; 0xc017d vgarom.asm:317
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc017e vgarom.asm:318
    mov ds, ax                                ; 8e d8                       ; 0xc0181 vgarom.asm:319
    push bx                                   ; 53                          ; 0xc0183 vgarom.asm:320
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc0184 vgarom.asm:321
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0187 vgarom.asm:322
    pop bx                                    ; 5b                          ; 0xc0189 vgarom.asm:323
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc018a vgarom.asm:324
    push bx                                   ; 53                          ; 0xc018c vgarom.asm:325
    mov bx, 00087h                            ; bb 87 00                    ; 0xc018d vgarom.asm:326
    mov ah, byte [bx]                         ; 8a 27                       ; 0xc0190 vgarom.asm:327
    and ah, 080h                              ; 80 e4 80                    ; 0xc0192 vgarom.asm:328
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0195 vgarom.asm:329
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0198 vgarom.asm:330
    db  00ah, 0c4h
    ; or al, ah                                 ; 0a c4                     ; 0xc019a vgarom.asm:331
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc019c vgarom.asm:332
    mov ah, byte [bx]                         ; 8a 27                       ; 0xc019f vgarom.asm:333
    pop bx                                    ; 5b                          ; 0xc01a1 vgarom.asm:334
    pop DS                                    ; 1f                          ; 0xc01a2 vgarom.asm:335
    retn                                      ; c3                          ; 0xc01a3 vgarom.asm:336
    cmp AL, strict byte 000h                  ; 3c 00                       ; 0xc01a4 vgarom.asm:341
    jne short 001aah                          ; 75 02                       ; 0xc01a6 vgarom.asm:342
    jmp short 0020bh                          ; eb 61                       ; 0xc01a8 vgarom.asm:343
    cmp AL, strict byte 001h                  ; 3c 01                       ; 0xc01aa vgarom.asm:345
    jne short 001b0h                          ; 75 02                       ; 0xc01ac vgarom.asm:346
    jmp short 00229h                          ; eb 79                       ; 0xc01ae vgarom.asm:347
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc01b0 vgarom.asm:349
    jne short 001b6h                          ; 75 02                       ; 0xc01b2 vgarom.asm:350
    jmp short 00231h                          ; eb 7b                       ; 0xc01b4 vgarom.asm:351
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc01b6 vgarom.asm:353
    jne short 001bdh                          ; 75 03                       ; 0xc01b8 vgarom.asm:354
    jmp near 00262h                           ; e9 a5 00                    ; 0xc01ba vgarom.asm:355
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc01bd vgarom.asm:357
    jne short 001c4h                          ; 75 03                       ; 0xc01bf vgarom.asm:358
    jmp near 0028ch                           ; e9 c8 00                    ; 0xc01c1 vgarom.asm:359
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc01c4 vgarom.asm:361
    jne short 001cbh                          ; 75 03                       ; 0xc01c6 vgarom.asm:362
    jmp near 002b4h                           ; e9 e9 00                    ; 0xc01c8 vgarom.asm:363
    cmp AL, strict byte 009h                  ; 3c 09                       ; 0xc01cb vgarom.asm:365
    jne short 001d2h                          ; 75 03                       ; 0xc01cd vgarom.asm:366
    jmp near 002c2h                           ; e9 f0 00                    ; 0xc01cf vgarom.asm:367
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc01d2 vgarom.asm:369
    jne short 001d9h                          ; 75 03                       ; 0xc01d4 vgarom.asm:370
    jmp near 00307h                           ; e9 2e 01                    ; 0xc01d6 vgarom.asm:371
    cmp AL, strict byte 012h                  ; 3c 12                       ; 0xc01d9 vgarom.asm:373
    jne short 001e0h                          ; 75 03                       ; 0xc01db vgarom.asm:374
    jmp near 00320h                           ; e9 40 01                    ; 0xc01dd vgarom.asm:375
    cmp AL, strict byte 013h                  ; 3c 13                       ; 0xc01e0 vgarom.asm:377
    jne short 001e7h                          ; 75 03                       ; 0xc01e2 vgarom.asm:378
    jmp near 00348h                           ; e9 61 01                    ; 0xc01e4 vgarom.asm:379
    cmp AL, strict byte 015h                  ; 3c 15                       ; 0xc01e7 vgarom.asm:381
    jne short 001eeh                          ; 75 03                       ; 0xc01e9 vgarom.asm:382
    jmp near 0038fh                           ; e9 a1 01                    ; 0xc01eb vgarom.asm:383
    cmp AL, strict byte 017h                  ; 3c 17                       ; 0xc01ee vgarom.asm:385
    jne short 001f5h                          ; 75 03                       ; 0xc01f0 vgarom.asm:386
    jmp near 003aah                           ; e9 b5 01                    ; 0xc01f2 vgarom.asm:387
    cmp AL, strict byte 018h                  ; 3c 18                       ; 0xc01f5 vgarom.asm:389
    jne short 001fch                          ; 75 03                       ; 0xc01f7 vgarom.asm:390
    jmp near 003d2h                           ; e9 d6 01                    ; 0xc01f9 vgarom.asm:391
    cmp AL, strict byte 019h                  ; 3c 19                       ; 0xc01fc vgarom.asm:393
    jne short 00203h                          ; 75 03                       ; 0xc01fe vgarom.asm:394
    jmp near 003ddh                           ; e9 da 01                    ; 0xc0200 vgarom.asm:395
    cmp AL, strict byte 01ah                  ; 3c 1a                       ; 0xc0203 vgarom.asm:397
    jne short 0020ah                          ; 75 03                       ; 0xc0205 vgarom.asm:398
    jmp near 003e8h                           ; e9 de 01                    ; 0xc0207 vgarom.asm:399
    retn                                      ; c3                          ; 0xc020a vgarom.asm:404
    cmp bl, 014h                              ; 80 fb 14                    ; 0xc020b vgarom.asm:407
    jnbe short 00228h                         ; 77 18                       ; 0xc020e vgarom.asm:408
    push ax                                   ; 50                          ; 0xc0210 vgarom.asm:409
    push dx                                   ; 52                          ; 0xc0211 vgarom.asm:410
    mov dx, 003dah                            ; ba da 03                    ; 0xc0212 vgarom.asm:411
    in AL, DX                                 ; ec                          ; 0xc0215 vgarom.asm:412
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0216 vgarom.asm:413
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0219 vgarom.asm:414
    out DX, AL                                ; ee                          ; 0xc021b vgarom.asm:415
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc021c vgarom.asm:416
    out DX, AL                                ; ee                          ; 0xc021e vgarom.asm:417
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc021f vgarom.asm:418
    out DX, AL                                ; ee                          ; 0xc0221 vgarom.asm:419
    mov dx, 003dah                            ; ba da 03                    ; 0xc0222 vgarom.asm:421
    in AL, DX                                 ; ec                          ; 0xc0225 vgarom.asm:422
    pop dx                                    ; 5a                          ; 0xc0226 vgarom.asm:424
    pop ax                                    ; 58                          ; 0xc0227 vgarom.asm:425
    retn                                      ; c3                          ; 0xc0228 vgarom.asm:427
    push bx                                   ; 53                          ; 0xc0229 vgarom.asm:432
    mov BL, strict byte 011h                  ; b3 11                       ; 0xc022a vgarom.asm:433
    call 0020bh                               ; e8 dc ff                    ; 0xc022c vgarom.asm:434
    pop bx                                    ; 5b                          ; 0xc022f vgarom.asm:435
    retn                                      ; c3                          ; 0xc0230 vgarom.asm:436
    push ax                                   ; 50                          ; 0xc0231 vgarom.asm:441
    push bx                                   ; 53                          ; 0xc0232 vgarom.asm:442
    push cx                                   ; 51                          ; 0xc0233 vgarom.asm:443
    push dx                                   ; 52                          ; 0xc0234 vgarom.asm:444
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc0235 vgarom.asm:445
    mov dx, 003dah                            ; ba da 03                    ; 0xc0237 vgarom.asm:446
    in AL, DX                                 ; ec                          ; 0xc023a vgarom.asm:447
    mov CL, strict byte 000h                  ; b1 00                       ; 0xc023b vgarom.asm:448
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc023d vgarom.asm:449
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc0240 vgarom.asm:451
    out DX, AL                                ; ee                          ; 0xc0242 vgarom.asm:452
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0243 vgarom.asm:453
    out DX, AL                                ; ee                          ; 0xc0246 vgarom.asm:454
    inc bx                                    ; 43                          ; 0xc0247 vgarom.asm:455
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc0248 vgarom.asm:456
    cmp cl, 010h                              ; 80 f9 10                    ; 0xc024a vgarom.asm:457
    jne short 00240h                          ; 75 f1                       ; 0xc024d vgarom.asm:458
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc024f vgarom.asm:459
    out DX, AL                                ; ee                          ; 0xc0251 vgarom.asm:460
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0252 vgarom.asm:461
    out DX, AL                                ; ee                          ; 0xc0255 vgarom.asm:462
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0256 vgarom.asm:463
    out DX, AL                                ; ee                          ; 0xc0258 vgarom.asm:464
    mov dx, 003dah                            ; ba da 03                    ; 0xc0259 vgarom.asm:466
    in AL, DX                                 ; ec                          ; 0xc025c vgarom.asm:467
    pop dx                                    ; 5a                          ; 0xc025d vgarom.asm:469
    pop cx                                    ; 59                          ; 0xc025e vgarom.asm:470
    pop bx                                    ; 5b                          ; 0xc025f vgarom.asm:471
    pop ax                                    ; 58                          ; 0xc0260 vgarom.asm:472
    retn                                      ; c3                          ; 0xc0261 vgarom.asm:473
    push ax                                   ; 50                          ; 0xc0262 vgarom.asm:478
    push bx                                   ; 53                          ; 0xc0263 vgarom.asm:479
    push dx                                   ; 52                          ; 0xc0264 vgarom.asm:480
    mov dx, 003dah                            ; ba da 03                    ; 0xc0265 vgarom.asm:481
    in AL, DX                                 ; ec                          ; 0xc0268 vgarom.asm:482
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0269 vgarom.asm:483
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc026c vgarom.asm:484
    out DX, AL                                ; ee                          ; 0xc026e vgarom.asm:485
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc026f vgarom.asm:486
    in AL, DX                                 ; ec                          ; 0xc0272 vgarom.asm:487
    and AL, strict byte 0f7h                  ; 24 f7                       ; 0xc0273 vgarom.asm:488
    and bl, 001h                              ; 80 e3 01                    ; 0xc0275 vgarom.asm:489
    sal bl, 003h                              ; c0 e3 03                    ; 0xc0278 vgarom.asm:491
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc027b vgarom.asm:497
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc027d vgarom.asm:498
    out DX, AL                                ; ee                          ; 0xc0280 vgarom.asm:499
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0281 vgarom.asm:500
    out DX, AL                                ; ee                          ; 0xc0283 vgarom.asm:501
    mov dx, 003dah                            ; ba da 03                    ; 0xc0284 vgarom.asm:503
    in AL, DX                                 ; ec                          ; 0xc0287 vgarom.asm:504
    pop dx                                    ; 5a                          ; 0xc0288 vgarom.asm:506
    pop bx                                    ; 5b                          ; 0xc0289 vgarom.asm:507
    pop ax                                    ; 58                          ; 0xc028a vgarom.asm:508
    retn                                      ; c3                          ; 0xc028b vgarom.asm:509
    cmp bl, 014h                              ; 80 fb 14                    ; 0xc028c vgarom.asm:514
    jnbe short 002b3h                         ; 77 22                       ; 0xc028f vgarom.asm:515
    push ax                                   ; 50                          ; 0xc0291 vgarom.asm:516
    push dx                                   ; 52                          ; 0xc0292 vgarom.asm:517
    mov dx, 003dah                            ; ba da 03                    ; 0xc0293 vgarom.asm:518
    in AL, DX                                 ; ec                          ; 0xc0296 vgarom.asm:519
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0297 vgarom.asm:520
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc029a vgarom.asm:521
    out DX, AL                                ; ee                          ; 0xc029c vgarom.asm:522
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc029d vgarom.asm:523
    in AL, DX                                 ; ec                          ; 0xc02a0 vgarom.asm:524
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc02a1 vgarom.asm:525
    mov dx, 003dah                            ; ba da 03                    ; 0xc02a3 vgarom.asm:526
    in AL, DX                                 ; ec                          ; 0xc02a6 vgarom.asm:527
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02a7 vgarom.asm:528
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc02aa vgarom.asm:529
    out DX, AL                                ; ee                          ; 0xc02ac vgarom.asm:530
    mov dx, 003dah                            ; ba da 03                    ; 0xc02ad vgarom.asm:532
    in AL, DX                                 ; ec                          ; 0xc02b0 vgarom.asm:533
    pop dx                                    ; 5a                          ; 0xc02b1 vgarom.asm:535
    pop ax                                    ; 58                          ; 0xc02b2 vgarom.asm:536
    retn                                      ; c3                          ; 0xc02b3 vgarom.asm:538
    push ax                                   ; 50                          ; 0xc02b4 vgarom.asm:543
    push bx                                   ; 53                          ; 0xc02b5 vgarom.asm:544
    mov BL, strict byte 011h                  ; b3 11                       ; 0xc02b6 vgarom.asm:545
    call 0028ch                               ; e8 d1 ff                    ; 0xc02b8 vgarom.asm:546
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc02bb vgarom.asm:547
    pop bx                                    ; 5b                          ; 0xc02bd vgarom.asm:548
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc02be vgarom.asm:549
    pop ax                                    ; 58                          ; 0xc02c0 vgarom.asm:550
    retn                                      ; c3                          ; 0xc02c1 vgarom.asm:551
    push ax                                   ; 50                          ; 0xc02c2 vgarom.asm:556
    push bx                                   ; 53                          ; 0xc02c3 vgarom.asm:557
    push cx                                   ; 51                          ; 0xc02c4 vgarom.asm:558
    push dx                                   ; 52                          ; 0xc02c5 vgarom.asm:559
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc02c6 vgarom.asm:560
    mov CL, strict byte 000h                  ; b1 00                       ; 0xc02c8 vgarom.asm:561
    mov dx, 003dah                            ; ba da 03                    ; 0xc02ca vgarom.asm:563
    in AL, DX                                 ; ec                          ; 0xc02cd vgarom.asm:564
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02ce vgarom.asm:565
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc02d1 vgarom.asm:566
    out DX, AL                                ; ee                          ; 0xc02d3 vgarom.asm:567
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc02d4 vgarom.asm:568
    in AL, DX                                 ; ec                          ; 0xc02d7 vgarom.asm:569
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc02d8 vgarom.asm:570
    inc bx                                    ; 43                          ; 0xc02db vgarom.asm:571
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc02dc vgarom.asm:572
    cmp cl, 010h                              ; 80 f9 10                    ; 0xc02de vgarom.asm:573
    jne short 002cah                          ; 75 e7                       ; 0xc02e1 vgarom.asm:574
    mov dx, 003dah                            ; ba da 03                    ; 0xc02e3 vgarom.asm:575
    in AL, DX                                 ; ec                          ; 0xc02e6 vgarom.asm:576
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02e7 vgarom.asm:577
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc02ea vgarom.asm:578
    out DX, AL                                ; ee                          ; 0xc02ec vgarom.asm:579
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc02ed vgarom.asm:580
    in AL, DX                                 ; ec                          ; 0xc02f0 vgarom.asm:581
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc02f1 vgarom.asm:582
    mov dx, 003dah                            ; ba da 03                    ; 0xc02f4 vgarom.asm:583
    in AL, DX                                 ; ec                          ; 0xc02f7 vgarom.asm:584
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02f8 vgarom.asm:585
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc02fb vgarom.asm:586
    out DX, AL                                ; ee                          ; 0xc02fd vgarom.asm:587
    mov dx, 003dah                            ; ba da 03                    ; 0xc02fe vgarom.asm:589
    in AL, DX                                 ; ec                          ; 0xc0301 vgarom.asm:590
    pop dx                                    ; 5a                          ; 0xc0302 vgarom.asm:592
    pop cx                                    ; 59                          ; 0xc0303 vgarom.asm:593
    pop bx                                    ; 5b                          ; 0xc0304 vgarom.asm:594
    pop ax                                    ; 58                          ; 0xc0305 vgarom.asm:595
    retn                                      ; c3                          ; 0xc0306 vgarom.asm:596
    push ax                                   ; 50                          ; 0xc0307 vgarom.asm:601
    push dx                                   ; 52                          ; 0xc0308 vgarom.asm:602
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc0309 vgarom.asm:603
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc030c vgarom.asm:604
    out DX, AL                                ; ee                          ; 0xc030e vgarom.asm:605
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc030f vgarom.asm:606
    pop ax                                    ; 58                          ; 0xc0312 vgarom.asm:607
    push ax                                   ; 50                          ; 0xc0313 vgarom.asm:608
    db  08ah, 0c4h
    ; mov al, ah                                ; 8a c4                     ; 0xc0314 vgarom.asm:609
    out DX, AL                                ; ee                          ; 0xc0316 vgarom.asm:610
    db  08ah, 0c5h
    ; mov al, ch                                ; 8a c5                     ; 0xc0317 vgarom.asm:611
    out DX, AL                                ; ee                          ; 0xc0319 vgarom.asm:612
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc031a vgarom.asm:613
    out DX, AL                                ; ee                          ; 0xc031c vgarom.asm:614
    pop dx                                    ; 5a                          ; 0xc031d vgarom.asm:615
    pop ax                                    ; 58                          ; 0xc031e vgarom.asm:616
    retn                                      ; c3                          ; 0xc031f vgarom.asm:617
    push ax                                   ; 50                          ; 0xc0320 vgarom.asm:622
    push bx                                   ; 53                          ; 0xc0321 vgarom.asm:623
    push cx                                   ; 51                          ; 0xc0322 vgarom.asm:624
    push dx                                   ; 52                          ; 0xc0323 vgarom.asm:625
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc0324 vgarom.asm:626
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0327 vgarom.asm:627
    out DX, AL                                ; ee                          ; 0xc0329 vgarom.asm:628
    pop dx                                    ; 5a                          ; 0xc032a vgarom.asm:629
    push dx                                   ; 52                          ; 0xc032b vgarom.asm:630
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc032c vgarom.asm:631
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc032e vgarom.asm:632
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0331 vgarom.asm:634
    out DX, AL                                ; ee                          ; 0xc0334 vgarom.asm:635
    inc bx                                    ; 43                          ; 0xc0335 vgarom.asm:636
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0336 vgarom.asm:637
    out DX, AL                                ; ee                          ; 0xc0339 vgarom.asm:638
    inc bx                                    ; 43                          ; 0xc033a vgarom.asm:639
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc033b vgarom.asm:640
    out DX, AL                                ; ee                          ; 0xc033e vgarom.asm:641
    inc bx                                    ; 43                          ; 0xc033f vgarom.asm:642
    dec cx                                    ; 49                          ; 0xc0340 vgarom.asm:643
    jne short 00331h                          ; 75 ee                       ; 0xc0341 vgarom.asm:644
    pop dx                                    ; 5a                          ; 0xc0343 vgarom.asm:645
    pop cx                                    ; 59                          ; 0xc0344 vgarom.asm:646
    pop bx                                    ; 5b                          ; 0xc0345 vgarom.asm:647
    pop ax                                    ; 58                          ; 0xc0346 vgarom.asm:648
    retn                                      ; c3                          ; 0xc0347 vgarom.asm:649
    push ax                                   ; 50                          ; 0xc0348 vgarom.asm:654
    push bx                                   ; 53                          ; 0xc0349 vgarom.asm:655
    push dx                                   ; 52                          ; 0xc034a vgarom.asm:656
    mov dx, 003dah                            ; ba da 03                    ; 0xc034b vgarom.asm:657
    in AL, DX                                 ; ec                          ; 0xc034e vgarom.asm:658
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc034f vgarom.asm:659
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc0352 vgarom.asm:660
    out DX, AL                                ; ee                          ; 0xc0354 vgarom.asm:661
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0355 vgarom.asm:662
    in AL, DX                                 ; ec                          ; 0xc0358 vgarom.asm:663
    and bl, 001h                              ; 80 e3 01                    ; 0xc0359 vgarom.asm:664
    jne short 0036bh                          ; 75 0d                       ; 0xc035c vgarom.asm:665
    and AL, strict byte 07fh                  ; 24 7f                       ; 0xc035e vgarom.asm:666
    sal bh, 007h                              ; c0 e7 07                    ; 0xc0360 vgarom.asm:668
    db  00ah, 0c7h
    ; or al, bh                                 ; 0a c7                     ; 0xc0363 vgarom.asm:678
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0365 vgarom.asm:679
    out DX, AL                                ; ee                          ; 0xc0368 vgarom.asm:680
    jmp short 00384h                          ; eb 19                       ; 0xc0369 vgarom.asm:681
    push ax                                   ; 50                          ; 0xc036b vgarom.asm:683
    mov dx, 003dah                            ; ba da 03                    ; 0xc036c vgarom.asm:684
    in AL, DX                                 ; ec                          ; 0xc036f vgarom.asm:685
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0370 vgarom.asm:686
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc0373 vgarom.asm:687
    out DX, AL                                ; ee                          ; 0xc0375 vgarom.asm:688
    pop ax                                    ; 58                          ; 0xc0376 vgarom.asm:689
    and AL, strict byte 080h                  ; 24 80                       ; 0xc0377 vgarom.asm:690
    jne short 0037eh                          ; 75 03                       ; 0xc0379 vgarom.asm:691
    sal bh, 002h                              ; c0 e7 02                    ; 0xc037b vgarom.asm:693
    and bh, 00fh                              ; 80 e7 0f                    ; 0xc037e vgarom.asm:699
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc0381 vgarom.asm:700
    out DX, AL                                ; ee                          ; 0xc0383 vgarom.asm:701
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0384 vgarom.asm:703
    out DX, AL                                ; ee                          ; 0xc0386 vgarom.asm:704
    mov dx, 003dah                            ; ba da 03                    ; 0xc0387 vgarom.asm:706
    in AL, DX                                 ; ec                          ; 0xc038a vgarom.asm:707
    pop dx                                    ; 5a                          ; 0xc038b vgarom.asm:709
    pop bx                                    ; 5b                          ; 0xc038c vgarom.asm:710
    pop ax                                    ; 58                          ; 0xc038d vgarom.asm:711
    retn                                      ; c3                          ; 0xc038e vgarom.asm:712
    push ax                                   ; 50                          ; 0xc038f vgarom.asm:717
    push dx                                   ; 52                          ; 0xc0390 vgarom.asm:718
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc0391 vgarom.asm:719
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0394 vgarom.asm:720
    out DX, AL                                ; ee                          ; 0xc0396 vgarom.asm:721
    pop ax                                    ; 58                          ; 0xc0397 vgarom.asm:722
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc0398 vgarom.asm:723
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc039a vgarom.asm:724
    in AL, DX                                 ; ec                          ; 0xc039d vgarom.asm:725
    db  086h, 0e0h
    ; xchg al, ah                               ; 86 e0                     ; 0xc039e vgarom.asm:726
    push ax                                   ; 50                          ; 0xc03a0 vgarom.asm:727
    in AL, DX                                 ; ec                          ; 0xc03a1 vgarom.asm:728
    db  08ah, 0e8h
    ; mov ch, al                                ; 8a e8                     ; 0xc03a2 vgarom.asm:729
    in AL, DX                                 ; ec                          ; 0xc03a4 vgarom.asm:730
    db  08ah, 0c8h
    ; mov cl, al                                ; 8a c8                     ; 0xc03a5 vgarom.asm:731
    pop dx                                    ; 5a                          ; 0xc03a7 vgarom.asm:732
    pop ax                                    ; 58                          ; 0xc03a8 vgarom.asm:733
    retn                                      ; c3                          ; 0xc03a9 vgarom.asm:734
    push ax                                   ; 50                          ; 0xc03aa vgarom.asm:739
    push bx                                   ; 53                          ; 0xc03ab vgarom.asm:740
    push cx                                   ; 51                          ; 0xc03ac vgarom.asm:741
    push dx                                   ; 52                          ; 0xc03ad vgarom.asm:742
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc03ae vgarom.asm:743
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc03b1 vgarom.asm:744
    out DX, AL                                ; ee                          ; 0xc03b3 vgarom.asm:745
    pop dx                                    ; 5a                          ; 0xc03b4 vgarom.asm:746
    push dx                                   ; 52                          ; 0xc03b5 vgarom.asm:747
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc03b6 vgarom.asm:748
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc03b8 vgarom.asm:749
    in AL, DX                                 ; ec                          ; 0xc03bb vgarom.asm:751
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc03bc vgarom.asm:752
    inc bx                                    ; 43                          ; 0xc03bf vgarom.asm:753
    in AL, DX                                 ; ec                          ; 0xc03c0 vgarom.asm:754
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc03c1 vgarom.asm:755
    inc bx                                    ; 43                          ; 0xc03c4 vgarom.asm:756
    in AL, DX                                 ; ec                          ; 0xc03c5 vgarom.asm:757
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc03c6 vgarom.asm:758
    inc bx                                    ; 43                          ; 0xc03c9 vgarom.asm:759
    dec cx                                    ; 49                          ; 0xc03ca vgarom.asm:760
    jne short 003bbh                          ; 75 ee                       ; 0xc03cb vgarom.asm:761
    pop dx                                    ; 5a                          ; 0xc03cd vgarom.asm:762
    pop cx                                    ; 59                          ; 0xc03ce vgarom.asm:763
    pop bx                                    ; 5b                          ; 0xc03cf vgarom.asm:764
    pop ax                                    ; 58                          ; 0xc03d0 vgarom.asm:765
    retn                                      ; c3                          ; 0xc03d1 vgarom.asm:766
    push ax                                   ; 50                          ; 0xc03d2 vgarom.asm:771
    push dx                                   ; 52                          ; 0xc03d3 vgarom.asm:772
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc03d4 vgarom.asm:773
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc03d7 vgarom.asm:774
    out DX, AL                                ; ee                          ; 0xc03d9 vgarom.asm:775
    pop dx                                    ; 5a                          ; 0xc03da vgarom.asm:776
    pop ax                                    ; 58                          ; 0xc03db vgarom.asm:777
    retn                                      ; c3                          ; 0xc03dc vgarom.asm:778
    push ax                                   ; 50                          ; 0xc03dd vgarom.asm:783
    push dx                                   ; 52                          ; 0xc03de vgarom.asm:784
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc03df vgarom.asm:785
    in AL, DX                                 ; ec                          ; 0xc03e2 vgarom.asm:786
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc03e3 vgarom.asm:787
    pop dx                                    ; 5a                          ; 0xc03e5 vgarom.asm:788
    pop ax                                    ; 58                          ; 0xc03e6 vgarom.asm:789
    retn                                      ; c3                          ; 0xc03e7 vgarom.asm:790
    push ax                                   ; 50                          ; 0xc03e8 vgarom.asm:795
    push dx                                   ; 52                          ; 0xc03e9 vgarom.asm:796
    mov dx, 003dah                            ; ba da 03                    ; 0xc03ea vgarom.asm:797
    in AL, DX                                 ; ec                          ; 0xc03ed vgarom.asm:798
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc03ee vgarom.asm:799
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc03f1 vgarom.asm:800
    out DX, AL                                ; ee                          ; 0xc03f3 vgarom.asm:801
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc03f4 vgarom.asm:802
    in AL, DX                                 ; ec                          ; 0xc03f7 vgarom.asm:803
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc03f8 vgarom.asm:804
    shr bl, 007h                              ; c0 eb 07                    ; 0xc03fa vgarom.asm:806
    mov dx, 003dah                            ; ba da 03                    ; 0xc03fd vgarom.asm:816
    in AL, DX                                 ; ec                          ; 0xc0400 vgarom.asm:817
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0401 vgarom.asm:818
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc0404 vgarom.asm:819
    out DX, AL                                ; ee                          ; 0xc0406 vgarom.asm:820
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0407 vgarom.asm:821
    in AL, DX                                 ; ec                          ; 0xc040a vgarom.asm:822
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc040b vgarom.asm:823
    and bh, 00fh                              ; 80 e7 0f                    ; 0xc040d vgarom.asm:824
    test bl, 001h                             ; f6 c3 01                    ; 0xc0410 vgarom.asm:825
    jne short 00418h                          ; 75 03                       ; 0xc0413 vgarom.asm:826
    shr bh, 002h                              ; c0 ef 02                    ; 0xc0415 vgarom.asm:828
    mov dx, 003dah                            ; ba da 03                    ; 0xc0418 vgarom.asm:834
    in AL, DX                                 ; ec                          ; 0xc041b vgarom.asm:835
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc041c vgarom.asm:836
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc041f vgarom.asm:837
    out DX, AL                                ; ee                          ; 0xc0421 vgarom.asm:838
    mov dx, 003dah                            ; ba da 03                    ; 0xc0422 vgarom.asm:840
    in AL, DX                                 ; ec                          ; 0xc0425 vgarom.asm:841
    pop dx                                    ; 5a                          ; 0xc0426 vgarom.asm:843
    pop ax                                    ; 58                          ; 0xc0427 vgarom.asm:844
    retn                                      ; c3                          ; 0xc0428 vgarom.asm:845
    push ax                                   ; 50                          ; 0xc0429 vgarom.asm:850
    push dx                                   ; 52                          ; 0xc042a vgarom.asm:851
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc042b vgarom.asm:852
    db  08ah, 0e3h
    ; mov ah, bl                                ; 8a e3                     ; 0xc042e vgarom.asm:853
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc0430 vgarom.asm:854
    out DX, ax                                ; ef                          ; 0xc0432 vgarom.asm:855
    pop dx                                    ; 5a                          ; 0xc0433 vgarom.asm:856
    pop ax                                    ; 58                          ; 0xc0434 vgarom.asm:857
    retn                                      ; c3                          ; 0xc0435 vgarom.asm:858
    push DS                                   ; 1e                          ; 0xc0436 vgarom.asm:863
    push ax                                   ; 50                          ; 0xc0437 vgarom.asm:864
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0438 vgarom.asm:865
    mov ds, ax                                ; 8e d8                       ; 0xc043b vgarom.asm:866
    db  032h, 0edh
    ; xor ch, ch                                ; 32 ed                     ; 0xc043d vgarom.asm:867
    mov bx, 00088h                            ; bb 88 00                    ; 0xc043f vgarom.asm:868
    mov cl, byte [bx]                         ; 8a 0f                       ; 0xc0442 vgarom.asm:869
    and cl, 00fh                              ; 80 e1 0f                    ; 0xc0444 vgarom.asm:870
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc0447 vgarom.asm:871
    mov ax, word [bx]                         ; 8b 07                       ; 0xc044a vgarom.asm:872
    mov bx, strict word 00003h                ; bb 03 00                    ; 0xc044c vgarom.asm:873
    cmp ax, 003b4h                            ; 3d b4 03                    ; 0xc044f vgarom.asm:874
    jne short 00456h                          ; 75 02                       ; 0xc0452 vgarom.asm:875
    mov BH, strict byte 001h                  ; b7 01                       ; 0xc0454 vgarom.asm:876
    pop ax                                    ; 58                          ; 0xc0456 vgarom.asm:878
    pop DS                                    ; 1f                          ; 0xc0457 vgarom.asm:879
    retn                                      ; c3                          ; 0xc0458 vgarom.asm:880
    push DS                                   ; 1e                          ; 0xc0459 vgarom.asm:888
    push bx                                   ; 53                          ; 0xc045a vgarom.asm:889
    push dx                                   ; 52                          ; 0xc045b vgarom.asm:890
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc045c vgarom.asm:891
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc045e vgarom.asm:892
    mov ds, ax                                ; 8e d8                       ; 0xc0461 vgarom.asm:893
    mov bx, 00089h                            ; bb 89 00                    ; 0xc0463 vgarom.asm:894
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0466 vgarom.asm:895
    mov bx, 00088h                            ; bb 88 00                    ; 0xc0468 vgarom.asm:896
    mov ah, byte [bx]                         ; 8a 27                       ; 0xc046b vgarom.asm:897
    cmp dl, 001h                              ; 80 fa 01                    ; 0xc046d vgarom.asm:898
    je short 00487h                           ; 74 15                       ; 0xc0470 vgarom.asm:899
    jc short 00491h                           ; 72 1d                       ; 0xc0472 vgarom.asm:900
    cmp dl, 002h                              ; 80 fa 02                    ; 0xc0474 vgarom.asm:901
    je short 0047bh                           ; 74 02                       ; 0xc0477 vgarom.asm:902
    jmp short 004a5h                          ; eb 2a                       ; 0xc0479 vgarom.asm:912
    and AL, strict byte 07fh                  ; 24 7f                       ; 0xc047b vgarom.asm:918
    or AL, strict byte 010h                   ; 0c 10                       ; 0xc047d vgarom.asm:919
    and ah, 0f0h                              ; 80 e4 f0                    ; 0xc047f vgarom.asm:920
    or ah, 009h                               ; 80 cc 09                    ; 0xc0482 vgarom.asm:921
    jne short 0049bh                          ; 75 14                       ; 0xc0485 vgarom.asm:922
    and AL, strict byte 06fh                  ; 24 6f                       ; 0xc0487 vgarom.asm:928
    and ah, 0f0h                              ; 80 e4 f0                    ; 0xc0489 vgarom.asm:929
    or ah, 009h                               ; 80 cc 09                    ; 0xc048c vgarom.asm:930
    jne short 0049bh                          ; 75 0a                       ; 0xc048f vgarom.asm:931
    and AL, strict byte 0efh                  ; 24 ef                       ; 0xc0491 vgarom.asm:937
    or AL, strict byte 080h                   ; 0c 80                       ; 0xc0493 vgarom.asm:938
    and ah, 0f0h                              ; 80 e4 f0                    ; 0xc0495 vgarom.asm:939
    or ah, 008h                               ; 80 cc 08                    ; 0xc0498 vgarom.asm:940
    mov bx, 00089h                            ; bb 89 00                    ; 0xc049b vgarom.asm:942
    mov byte [bx], al                         ; 88 07                       ; 0xc049e vgarom.asm:943
    mov bx, 00088h                            ; bb 88 00                    ; 0xc04a0 vgarom.asm:944
    mov byte [bx], ah                         ; 88 27                       ; 0xc04a3 vgarom.asm:945
    mov ax, 01212h                            ; b8 12 12                    ; 0xc04a5 vgarom.asm:947
    pop dx                                    ; 5a                          ; 0xc04a8 vgarom.asm:948
    pop bx                                    ; 5b                          ; 0xc04a9 vgarom.asm:949
    pop DS                                    ; 1f                          ; 0xc04aa vgarom.asm:950
    retn                                      ; c3                          ; 0xc04ab vgarom.asm:951
    push DS                                   ; 1e                          ; 0xc04ac vgarom.asm:960
    push bx                                   ; 53                          ; 0xc04ad vgarom.asm:961
    push dx                                   ; 52                          ; 0xc04ae vgarom.asm:962
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc04af vgarom.asm:963
    and dl, 001h                              ; 80 e2 01                    ; 0xc04b1 vgarom.asm:964
    sal dl, 003h                              ; c0 e2 03                    ; 0xc04b4 vgarom.asm:966
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc04b7 vgarom.asm:972
    mov ds, ax                                ; 8e d8                       ; 0xc04ba vgarom.asm:973
    mov bx, 00089h                            ; bb 89 00                    ; 0xc04bc vgarom.asm:974
    mov al, byte [bx]                         ; 8a 07                       ; 0xc04bf vgarom.asm:975
    and AL, strict byte 0f7h                  ; 24 f7                       ; 0xc04c1 vgarom.asm:976
    db  00ah, 0c2h
    ; or al, dl                                 ; 0a c2                     ; 0xc04c3 vgarom.asm:977
    mov byte [bx], al                         ; 88 07                       ; 0xc04c5 vgarom.asm:978
    mov ax, 01212h                            ; b8 12 12                    ; 0xc04c7 vgarom.asm:979
    pop dx                                    ; 5a                          ; 0xc04ca vgarom.asm:980
    pop bx                                    ; 5b                          ; 0xc04cb vgarom.asm:981
    pop DS                                    ; 1f                          ; 0xc04cc vgarom.asm:982
    retn                                      ; c3                          ; 0xc04cd vgarom.asm:983
    push bx                                   ; 53                          ; 0xc04ce vgarom.asm:987
    push dx                                   ; 52                          ; 0xc04cf vgarom.asm:988
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc04d0 vgarom.asm:989
    and bl, 001h                              ; 80 e3 01                    ; 0xc04d2 vgarom.asm:990
    xor bl, 001h                              ; 80 f3 01                    ; 0xc04d5 vgarom.asm:991
    sal bl, 1                                 ; d0 e3                       ; 0xc04d8 vgarom.asm:992
    mov dx, 003cch                            ; ba cc 03                    ; 0xc04da vgarom.asm:993
    in AL, DX                                 ; ec                          ; 0xc04dd vgarom.asm:994
    and AL, strict byte 0fdh                  ; 24 fd                       ; 0xc04de vgarom.asm:995
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc04e0 vgarom.asm:996
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc04e2 vgarom.asm:997
    out DX, AL                                ; ee                          ; 0xc04e5 vgarom.asm:998
    mov ax, 01212h                            ; b8 12 12                    ; 0xc04e6 vgarom.asm:999
    pop dx                                    ; 5a                          ; 0xc04e9 vgarom.asm:1000
    pop bx                                    ; 5b                          ; 0xc04ea vgarom.asm:1001
    retn                                      ; c3                          ; 0xc04eb vgarom.asm:1002
    push DS                                   ; 1e                          ; 0xc04ec vgarom.asm:1006
    push bx                                   ; 53                          ; 0xc04ed vgarom.asm:1007
    push dx                                   ; 52                          ; 0xc04ee vgarom.asm:1008
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc04ef vgarom.asm:1009
    and dl, 001h                              ; 80 e2 01                    ; 0xc04f1 vgarom.asm:1010
    xor dl, 001h                              ; 80 f2 01                    ; 0xc04f4 vgarom.asm:1011
    sal dl, 1                                 ; d0 e2                       ; 0xc04f7 vgarom.asm:1012
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc04f9 vgarom.asm:1013
    mov ds, ax                                ; 8e d8                       ; 0xc04fc vgarom.asm:1014
    mov bx, 00089h                            ; bb 89 00                    ; 0xc04fe vgarom.asm:1015
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0501 vgarom.asm:1016
    and AL, strict byte 0fdh                  ; 24 fd                       ; 0xc0503 vgarom.asm:1017
    db  00ah, 0c2h
    ; or al, dl                                 ; 0a c2                     ; 0xc0505 vgarom.asm:1018
    mov byte [bx], al                         ; 88 07                       ; 0xc0507 vgarom.asm:1019
    mov ax, 01212h                            ; b8 12 12                    ; 0xc0509 vgarom.asm:1020
    pop dx                                    ; 5a                          ; 0xc050c vgarom.asm:1021
    pop bx                                    ; 5b                          ; 0xc050d vgarom.asm:1022
    pop DS                                    ; 1f                          ; 0xc050e vgarom.asm:1023
    retn                                      ; c3                          ; 0xc050f vgarom.asm:1024
    push DS                                   ; 1e                          ; 0xc0510 vgarom.asm:1028
    push bx                                   ; 53                          ; 0xc0511 vgarom.asm:1029
    push dx                                   ; 52                          ; 0xc0512 vgarom.asm:1030
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc0513 vgarom.asm:1031
    and dl, 001h                              ; 80 e2 01                    ; 0xc0515 vgarom.asm:1032
    xor dl, 001h                              ; 80 f2 01                    ; 0xc0518 vgarom.asm:1033
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc051b vgarom.asm:1034
    mov ds, ax                                ; 8e d8                       ; 0xc051e vgarom.asm:1035
    mov bx, 00089h                            ; bb 89 00                    ; 0xc0520 vgarom.asm:1036
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0523 vgarom.asm:1037
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc0525 vgarom.asm:1038
    db  00ah, 0c2h
    ; or al, dl                                 ; 0a c2                     ; 0xc0527 vgarom.asm:1039
    mov byte [bx], al                         ; 88 07                       ; 0xc0529 vgarom.asm:1040
    mov ax, 01212h                            ; b8 12 12                    ; 0xc052b vgarom.asm:1041
    pop dx                                    ; 5a                          ; 0xc052e vgarom.asm:1042
    pop bx                                    ; 5b                          ; 0xc052f vgarom.asm:1043
    pop DS                                    ; 1f                          ; 0xc0530 vgarom.asm:1044
    retn                                      ; c3                          ; 0xc0531 vgarom.asm:1045
    cmp AL, strict byte 000h                  ; 3c 00                       ; 0xc0532 vgarom.asm:1050
    je short 0053bh                           ; 74 05                       ; 0xc0534 vgarom.asm:1051
    cmp AL, strict byte 001h                  ; 3c 01                       ; 0xc0536 vgarom.asm:1052
    je short 00550h                           ; 74 16                       ; 0xc0538 vgarom.asm:1053
    retn                                      ; c3                          ; 0xc053a vgarom.asm:1057
    push DS                                   ; 1e                          ; 0xc053b vgarom.asm:1059
    push ax                                   ; 50                          ; 0xc053c vgarom.asm:1060
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc053d vgarom.asm:1061
    mov ds, ax                                ; 8e d8                       ; 0xc0540 vgarom.asm:1062
    mov bx, 0008ah                            ; bb 8a 00                    ; 0xc0542 vgarom.asm:1063
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0545 vgarom.asm:1064
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc0547 vgarom.asm:1065
    db  032h, 0ffh
    ; xor bh, bh                                ; 32 ff                     ; 0xc0549 vgarom.asm:1066
    pop ax                                    ; 58                          ; 0xc054b vgarom.asm:1067
    db  08ah, 0c4h
    ; mov al, ah                                ; 8a c4                     ; 0xc054c vgarom.asm:1068
    pop DS                                    ; 1f                          ; 0xc054e vgarom.asm:1069
    retn                                      ; c3                          ; 0xc054f vgarom.asm:1070
    push DS                                   ; 1e                          ; 0xc0550 vgarom.asm:1072
    push ax                                   ; 50                          ; 0xc0551 vgarom.asm:1073
    push bx                                   ; 53                          ; 0xc0552 vgarom.asm:1074
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0553 vgarom.asm:1075
    mov ds, ax                                ; 8e d8                       ; 0xc0556 vgarom.asm:1076
    db  08bh, 0c3h
    ; mov ax, bx                                ; 8b c3                     ; 0xc0558 vgarom.asm:1077
    mov bx, 0008ah                            ; bb 8a 00                    ; 0xc055a vgarom.asm:1078
    mov byte [bx], al                         ; 88 07                       ; 0xc055d vgarom.asm:1079
    pop bx                                    ; 5b                          ; 0xc055f vgarom.asm:1089
    pop ax                                    ; 58                          ; 0xc0560 vgarom.asm:1090
    db  08ah, 0c4h
    ; mov al, ah                                ; 8a c4                     ; 0xc0561 vgarom.asm:1091
    pop DS                                    ; 1f                          ; 0xc0563 vgarom.asm:1092
    retn                                      ; c3                          ; 0xc0564 vgarom.asm:1093
    times 0xb db 0
  ; disGetNextSymbol 0xc0570 LB 0x3a0 -> off=0x0 cb=0000000000000007 uValue=00000000000c0570 'do_out_dx_ax'
do_out_dx_ax:                                ; 0xc0570 LB 0x7
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0570 vberom.asm:69
    out DX, AL                                ; ee                          ; 0xc0572 vberom.asm:70
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0573 vberom.asm:71
    out DX, AL                                ; ee                          ; 0xc0575 vberom.asm:72
    retn                                      ; c3                          ; 0xc0576 vberom.asm:73
  ; disGetNextSymbol 0xc0577 LB 0x399 -> off=0x0 cb=0000000000000040 uValue=00000000000c0577 'do_in_ax_dx'
do_in_ax_dx:                                 ; 0xc0577 LB 0x40
    in AL, DX                                 ; ec                          ; 0xc0577 vberom.asm:76
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0578 vberom.asm:77
    in AL, DX                                 ; ec                          ; 0xc057a vberom.asm:78
    retn                                      ; c3                          ; 0xc057b vberom.asm:79
    push ax                                   ; 50                          ; 0xc057c vberom.asm:90
    push dx                                   ; 52                          ; 0xc057d vberom.asm:91
    mov dx, 003dah                            ; ba da 03                    ; 0xc057e vberom.asm:92
    in AL, DX                                 ; ec                          ; 0xc0581 vberom.asm:94
    test AL, strict byte 008h                 ; a8 08                       ; 0xc0582 vberom.asm:95
    je short 00581h                           ; 74 fb                       ; 0xc0584 vberom.asm:96
    pop dx                                    ; 5a                          ; 0xc0586 vberom.asm:97
    pop ax                                    ; 58                          ; 0xc0587 vberom.asm:98
    retn                                      ; c3                          ; 0xc0588 vberom.asm:99
    push ax                                   ; 50                          ; 0xc0589 vberom.asm:102
    push dx                                   ; 52                          ; 0xc058a vberom.asm:103
    mov dx, 003dah                            ; ba da 03                    ; 0xc058b vberom.asm:104
    in AL, DX                                 ; ec                          ; 0xc058e vberom.asm:106
    test AL, strict byte 008h                 ; a8 08                       ; 0xc058f vberom.asm:107
    jne short 0058eh                          ; 75 fb                       ; 0xc0591 vberom.asm:108
    pop dx                                    ; 5a                          ; 0xc0593 vberom.asm:109
    pop ax                                    ; 58                          ; 0xc0594 vberom.asm:110
    retn                                      ; c3                          ; 0xc0595 vberom.asm:111
    push dx                                   ; 52                          ; 0xc0596 vberom.asm:116
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0597 vberom.asm:117
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc059a vberom.asm:118
    call 00570h                               ; e8 d0 ff                    ; 0xc059d vberom.asm:119
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc05a0 vberom.asm:120
    call 00577h                               ; e8 d1 ff                    ; 0xc05a3 vberom.asm:121
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc05a6 vberom.asm:122
    jbe short 005b5h                          ; 76 0b                       ; 0xc05a8 vberom.asm:123
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc05aa vberom.asm:124
    shr ah, 003h                              ; c0 ec 03                    ; 0xc05ac vberom.asm:126
    test AL, strict byte 007h                 ; a8 07                       ; 0xc05af vberom.asm:132
    je short 005b5h                           ; 74 02                       ; 0xc05b1 vberom.asm:133
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc05b3 vberom.asm:134
    pop dx                                    ; 5a                          ; 0xc05b5 vberom.asm:136
    retn                                      ; c3                          ; 0xc05b6 vberom.asm:137
  ; disGetNextSymbol 0xc05b7 LB 0x359 -> off=0x0 cb=0000000000000026 uValue=00000000000c05b7 '_dispi_get_max_bpp'
_dispi_get_max_bpp:                          ; 0xc05b7 LB 0x26
    push dx                                   ; 52                          ; 0xc05b7 vberom.asm:142
    push bx                                   ; 53                          ; 0xc05b8 vberom.asm:143
    call 005f1h                               ; e8 35 00                    ; 0xc05b9 vberom.asm:144
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc05bc vberom.asm:145
    or ax, strict byte 00002h                 ; 83 c8 02                    ; 0xc05be vberom.asm:146
    call 005ddh                               ; e8 19 00                    ; 0xc05c1 vberom.asm:147
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc05c4 vberom.asm:148
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc05c7 vberom.asm:149
    call 00570h                               ; e8 a3 ff                    ; 0xc05ca vberom.asm:150
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc05cd vberom.asm:151
    call 00577h                               ; e8 a4 ff                    ; 0xc05d0 vberom.asm:152
    push ax                                   ; 50                          ; 0xc05d3 vberom.asm:153
    db  08bh, 0c3h
    ; mov ax, bx                                ; 8b c3                     ; 0xc05d4 vberom.asm:154
    call 005ddh                               ; e8 04 00                    ; 0xc05d6 vberom.asm:155
    pop ax                                    ; 58                          ; 0xc05d9 vberom.asm:156
    pop bx                                    ; 5b                          ; 0xc05da vberom.asm:157
    pop dx                                    ; 5a                          ; 0xc05db vberom.asm:158
    retn                                      ; c3                          ; 0xc05dc vberom.asm:159
  ; disGetNextSymbol 0xc05dd LB 0x333 -> off=0x0 cb=0000000000000026 uValue=00000000000c05dd 'dispi_set_enable_'
dispi_set_enable_:                           ; 0xc05dd LB 0x26
    push dx                                   ; 52                          ; 0xc05dd vberom.asm:162
    push ax                                   ; 50                          ; 0xc05de vberom.asm:163
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc05df vberom.asm:164
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc05e2 vberom.asm:165
    call 00570h                               ; e8 88 ff                    ; 0xc05e5 vberom.asm:166
    pop ax                                    ; 58                          ; 0xc05e8 vberom.asm:167
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc05e9 vberom.asm:168
    call 00570h                               ; e8 81 ff                    ; 0xc05ec vberom.asm:169
    pop dx                                    ; 5a                          ; 0xc05ef vberom.asm:170
    retn                                      ; c3                          ; 0xc05f0 vberom.asm:171
    push dx                                   ; 52                          ; 0xc05f1 vberom.asm:174
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc05f2 vberom.asm:175
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc05f5 vberom.asm:176
    call 00570h                               ; e8 75 ff                    ; 0xc05f8 vberom.asm:177
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc05fb vberom.asm:178
    call 00577h                               ; e8 76 ff                    ; 0xc05fe vberom.asm:179
    pop dx                                    ; 5a                          ; 0xc0601 vberom.asm:180
    retn                                      ; c3                          ; 0xc0602 vberom.asm:181
  ; disGetNextSymbol 0xc0603 LB 0x30d -> off=0x0 cb=0000000000000026 uValue=00000000000c0603 'dispi_set_bank_'
dispi_set_bank_:                             ; 0xc0603 LB 0x26
    push dx                                   ; 52                          ; 0xc0603 vberom.asm:184
    push ax                                   ; 50                          ; 0xc0604 vberom.asm:185
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0605 vberom.asm:186
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0608 vberom.asm:187
    call 00570h                               ; e8 62 ff                    ; 0xc060b vberom.asm:188
    pop ax                                    ; 58                          ; 0xc060e vberom.asm:189
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc060f vberom.asm:190
    call 00570h                               ; e8 5b ff                    ; 0xc0612 vberom.asm:191
    pop dx                                    ; 5a                          ; 0xc0615 vberom.asm:192
    retn                                      ; c3                          ; 0xc0616 vberom.asm:193
    push dx                                   ; 52                          ; 0xc0617 vberom.asm:196
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0618 vberom.asm:197
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc061b vberom.asm:198
    call 00570h                               ; e8 4f ff                    ; 0xc061e vberom.asm:199
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0621 vberom.asm:200
    call 00577h                               ; e8 50 ff                    ; 0xc0624 vberom.asm:201
    pop dx                                    ; 5a                          ; 0xc0627 vberom.asm:202
    retn                                      ; c3                          ; 0xc0628 vberom.asm:203
  ; disGetNextSymbol 0xc0629 LB 0x2e7 -> off=0x0 cb=00000000000000a9 uValue=00000000000c0629 '_dispi_set_bank_farcall'
_dispi_set_bank_farcall:                     ; 0xc0629 LB 0xa9
    cmp bx, 00100h                            ; 81 fb 00 01                 ; 0xc0629 vberom.asm:206
    je short 00653h                           ; 74 24                       ; 0xc062d vberom.asm:207
    db  00bh, 0dbh
    ; or bx, bx                                 ; 0b db                     ; 0xc062f vberom.asm:208
    jne short 00665h                          ; 75 32                       ; 0xc0631 vberom.asm:209
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc0633 vberom.asm:210
    push dx                                   ; 52                          ; 0xc0635 vberom.asm:211
    push ax                                   ; 50                          ; 0xc0636 vberom.asm:212
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0637 vberom.asm:213
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc063a vberom.asm:214
    call 00570h                               ; e8 30 ff                    ; 0xc063d vberom.asm:215
    pop ax                                    ; 58                          ; 0xc0640 vberom.asm:216
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0641 vberom.asm:217
    call 00570h                               ; e8 29 ff                    ; 0xc0644 vberom.asm:218
    call 00577h                               ; e8 2d ff                    ; 0xc0647 vberom.asm:219
    pop dx                                    ; 5a                          ; 0xc064a vberom.asm:220
    db  03bh, 0d0h
    ; cmp dx, ax                                ; 3b d0                     ; 0xc064b vberom.asm:221
    jne short 00665h                          ; 75 16                       ; 0xc064d vberom.asm:222
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc064f vberom.asm:223
    retf                                      ; cb                          ; 0xc0652 vberom.asm:224
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0653 vberom.asm:226
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0656 vberom.asm:227
    call 00570h                               ; e8 14 ff                    ; 0xc0659 vberom.asm:228
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc065c vberom.asm:229
    call 00577h                               ; e8 15 ff                    ; 0xc065f vberom.asm:230
    db  08bh, 0d0h
    ; mov dx, ax                                ; 8b d0                     ; 0xc0662 vberom.asm:231
    retf                                      ; cb                          ; 0xc0664 vberom.asm:232
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc0665 vberom.asm:234
    retf                                      ; cb                          ; 0xc0668 vberom.asm:235
    push dx                                   ; 52                          ; 0xc0669 vberom.asm:238
    push ax                                   ; 50                          ; 0xc066a vberom.asm:239
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc066b vberom.asm:240
    mov ax, strict word 00008h                ; b8 08 00                    ; 0xc066e vberom.asm:241
    call 00570h                               ; e8 fc fe                    ; 0xc0671 vberom.asm:242
    pop ax                                    ; 58                          ; 0xc0674 vberom.asm:243
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0675 vberom.asm:244
    call 00570h                               ; e8 f5 fe                    ; 0xc0678 vberom.asm:245
    pop dx                                    ; 5a                          ; 0xc067b vberom.asm:246
    retn                                      ; c3                          ; 0xc067c vberom.asm:247
    push dx                                   ; 52                          ; 0xc067d vberom.asm:250
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc067e vberom.asm:251
    mov ax, strict word 00008h                ; b8 08 00                    ; 0xc0681 vberom.asm:252
    call 00570h                               ; e8 e9 fe                    ; 0xc0684 vberom.asm:253
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0687 vberom.asm:254
    call 00577h                               ; e8 ea fe                    ; 0xc068a vberom.asm:255
    pop dx                                    ; 5a                          ; 0xc068d vberom.asm:256
    retn                                      ; c3                          ; 0xc068e vberom.asm:257
    push dx                                   ; 52                          ; 0xc068f vberom.asm:260
    push ax                                   ; 50                          ; 0xc0690 vberom.asm:261
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0691 vberom.asm:262
    mov ax, strict word 00009h                ; b8 09 00                    ; 0xc0694 vberom.asm:263
    call 00570h                               ; e8 d6 fe                    ; 0xc0697 vberom.asm:264
    pop ax                                    ; 58                          ; 0xc069a vberom.asm:265
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc069b vberom.asm:266
    call 00570h                               ; e8 cf fe                    ; 0xc069e vberom.asm:267
    pop dx                                    ; 5a                          ; 0xc06a1 vberom.asm:268
    retn                                      ; c3                          ; 0xc06a2 vberom.asm:269
    push dx                                   ; 52                          ; 0xc06a3 vberom.asm:272
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc06a4 vberom.asm:273
    mov ax, strict word 00009h                ; b8 09 00                    ; 0xc06a7 vberom.asm:274
    call 00570h                               ; e8 c3 fe                    ; 0xc06aa vberom.asm:275
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc06ad vberom.asm:276
    call 00577h                               ; e8 c4 fe                    ; 0xc06b0 vberom.asm:277
    pop dx                                    ; 5a                          ; 0xc06b3 vberom.asm:278
    retn                                      ; c3                          ; 0xc06b4 vberom.asm:279
    push ax                                   ; 50                          ; 0xc06b5 vberom.asm:282
    push bx                                   ; 53                          ; 0xc06b6 vberom.asm:283
    push dx                                   ; 52                          ; 0xc06b7 vberom.asm:284
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc06b8 vberom.asm:285
    call 00596h                               ; e8 d9 fe                    ; 0xc06ba vberom.asm:286
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc06bd vberom.asm:287
    jnbe short 006c3h                         ; 77 02                       ; 0xc06bf vberom.asm:288
    shr bx, 1                                 ; d1 eb                       ; 0xc06c1 vberom.asm:289
    shr bx, 003h                              ; c1 eb 03                    ; 0xc06c3 vberom.asm:292
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc06c6 vberom.asm:298
    db  08ah, 0e3h
    ; mov ah, bl                                ; 8a e3                     ; 0xc06c9 vberom.asm:299
    mov AL, strict byte 013h                  ; b0 13                       ; 0xc06cb vberom.asm:300
    out DX, ax                                ; ef                          ; 0xc06cd vberom.asm:301
    pop dx                                    ; 5a                          ; 0xc06ce vberom.asm:302
    pop bx                                    ; 5b                          ; 0xc06cf vberom.asm:303
    pop ax                                    ; 58                          ; 0xc06d0 vberom.asm:304
    retn                                      ; c3                          ; 0xc06d1 vberom.asm:305
  ; disGetNextSymbol 0xc06d2 LB 0x23e -> off=0x0 cb=00000000000000f6 uValue=00000000000c06d2 '_vga_compat_setup'
_vga_compat_setup:                           ; 0xc06d2 LB 0xf6
    push ax                                   ; 50                          ; 0xc06d2 vberom.asm:308
    push dx                                   ; 52                          ; 0xc06d3 vberom.asm:309
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc06d4 vberom.asm:312
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc06d7 vberom.asm:313
    call 00570h                               ; e8 93 fe                    ; 0xc06da vberom.asm:314
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc06dd vberom.asm:315
    call 00577h                               ; e8 94 fe                    ; 0xc06e0 vberom.asm:316
    push ax                                   ; 50                          ; 0xc06e3 vberom.asm:317
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc06e4 vberom.asm:318
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc06e7 vberom.asm:319
    out DX, ax                                ; ef                          ; 0xc06ea vberom.asm:320
    pop ax                                    ; 58                          ; 0xc06eb vberom.asm:321
    push ax                                   ; 50                          ; 0xc06ec vberom.asm:322
    shr ax, 003h                              ; c1 e8 03                    ; 0xc06ed vberom.asm:324
    dec ax                                    ; 48                          ; 0xc06f0 vberom.asm:330
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc06f1 vberom.asm:331
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc06f3 vberom.asm:332
    out DX, ax                                ; ef                          ; 0xc06f5 vberom.asm:333
    pop ax                                    ; 58                          ; 0xc06f6 vberom.asm:334
    call 006b5h                               ; e8 bb ff                    ; 0xc06f7 vberom.asm:335
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc06fa vberom.asm:338
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc06fd vberom.asm:339
    call 00570h                               ; e8 6d fe                    ; 0xc0700 vberom.asm:340
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0703 vberom.asm:341
    call 00577h                               ; e8 6e fe                    ; 0xc0706 vberom.asm:342
    dec ax                                    ; 48                          ; 0xc0709 vberom.asm:343
    push ax                                   ; 50                          ; 0xc070a vberom.asm:344
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc070b vberom.asm:345
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc070e vberom.asm:346
    mov AL, strict byte 012h                  ; b0 12                       ; 0xc0710 vberom.asm:347
    out DX, ax                                ; ef                          ; 0xc0712 vberom.asm:348
    pop ax                                    ; 58                          ; 0xc0713 vberom.asm:349
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc0714 vberom.asm:350
    out DX, AL                                ; ee                          ; 0xc0716 vberom.asm:351
    inc dx                                    ; 42                          ; 0xc0717 vberom.asm:352
    in AL, DX                                 ; ec                          ; 0xc0718 vberom.asm:353
    and AL, strict byte 0bdh                  ; 24 bd                       ; 0xc0719 vberom.asm:354
    test ah, 001h                             ; f6 c4 01                    ; 0xc071b vberom.asm:355
    je short 00722h                           ; 74 02                       ; 0xc071e vberom.asm:356
    or AL, strict byte 002h                   ; 0c 02                       ; 0xc0720 vberom.asm:357
    test ah, 002h                             ; f6 c4 02                    ; 0xc0722 vberom.asm:359
    je short 00729h                           ; 74 02                       ; 0xc0725 vberom.asm:360
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc0727 vberom.asm:361
    out DX, AL                                ; ee                          ; 0xc0729 vberom.asm:363
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc072a vberom.asm:366
    mov ax, strict word 00009h                ; b8 09 00                    ; 0xc072d vberom.asm:367
    out DX, AL                                ; ee                          ; 0xc0730 vberom.asm:368
    mov dx, 003d5h                            ; ba d5 03                    ; 0xc0731 vberom.asm:369
    in AL, DX                                 ; ec                          ; 0xc0734 vberom.asm:370
    and AL, strict byte 060h                  ; 24 60                       ; 0xc0735 vberom.asm:371
    out DX, AL                                ; ee                          ; 0xc0737 vberom.asm:372
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc0738 vberom.asm:373
    mov AL, strict byte 017h                  ; b0 17                       ; 0xc073b vberom.asm:374
    out DX, AL                                ; ee                          ; 0xc073d vberom.asm:375
    mov dx, 003d5h                            ; ba d5 03                    ; 0xc073e vberom.asm:376
    in AL, DX                                 ; ec                          ; 0xc0741 vberom.asm:377
    or AL, strict byte 003h                   ; 0c 03                       ; 0xc0742 vberom.asm:378
    out DX, AL                                ; ee                          ; 0xc0744 vberom.asm:379
    mov dx, 003dah                            ; ba da 03                    ; 0xc0745 vberom.asm:380
    in AL, DX                                 ; ec                          ; 0xc0748 vberom.asm:381
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0749 vberom.asm:382
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc074c vberom.asm:383
    out DX, AL                                ; ee                          ; 0xc074e vberom.asm:384
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc074f vberom.asm:385
    in AL, DX                                 ; ec                          ; 0xc0752 vberom.asm:386
    or AL, strict byte 001h                   ; 0c 01                       ; 0xc0753 vberom.asm:387
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0755 vberom.asm:388
    out DX, AL                                ; ee                          ; 0xc0758 vberom.asm:389
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0759 vberom.asm:390
    out DX, AL                                ; ee                          ; 0xc075b vberom.asm:391
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc075c vberom.asm:392
    mov ax, 00506h                            ; b8 06 05                    ; 0xc075f vberom.asm:393
    out DX, ax                                ; ef                          ; 0xc0762 vberom.asm:394
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc0763 vberom.asm:395
    mov ax, 00f02h                            ; b8 02 0f                    ; 0xc0766 vberom.asm:396
    out DX, ax                                ; ef                          ; 0xc0769 vberom.asm:397
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc076a vberom.asm:400
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc076d vberom.asm:401
    call 00570h                               ; e8 fd fd                    ; 0xc0770 vberom.asm:402
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0773 vberom.asm:403
    call 00577h                               ; e8 fe fd                    ; 0xc0776 vberom.asm:404
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc0779 vberom.asm:405
    jc short 007bfh                           ; 72 42                       ; 0xc077b vberom.asm:406
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc077d vberom.asm:407
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc0780 vberom.asm:408
    out DX, AL                                ; ee                          ; 0xc0782 vberom.asm:409
    mov dx, 003d5h                            ; ba d5 03                    ; 0xc0783 vberom.asm:410
    in AL, DX                                 ; ec                          ; 0xc0786 vberom.asm:411
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc0787 vberom.asm:412
    out DX, AL                                ; ee                          ; 0xc0789 vberom.asm:413
    mov dx, 003dah                            ; ba da 03                    ; 0xc078a vberom.asm:414
    in AL, DX                                 ; ec                          ; 0xc078d vberom.asm:415
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc078e vberom.asm:416
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc0791 vberom.asm:417
    out DX, AL                                ; ee                          ; 0xc0793 vberom.asm:418
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0794 vberom.asm:419
    in AL, DX                                 ; ec                          ; 0xc0797 vberom.asm:420
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc0798 vberom.asm:421
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc079a vberom.asm:422
    out DX, AL                                ; ee                          ; 0xc079d vberom.asm:423
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc079e vberom.asm:424
    out DX, AL                                ; ee                          ; 0xc07a0 vberom.asm:425
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc07a1 vberom.asm:426
    mov AL, strict byte 004h                  ; b0 04                       ; 0xc07a4 vberom.asm:427
    out DX, AL                                ; ee                          ; 0xc07a6 vberom.asm:428
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc07a7 vberom.asm:429
    in AL, DX                                 ; ec                          ; 0xc07aa vberom.asm:430
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc07ab vberom.asm:431
    out DX, AL                                ; ee                          ; 0xc07ad vberom.asm:432
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc07ae vberom.asm:433
    mov AL, strict byte 005h                  ; b0 05                       ; 0xc07b1 vberom.asm:434
    out DX, AL                                ; ee                          ; 0xc07b3 vberom.asm:435
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc07b4 vberom.asm:436
    in AL, DX                                 ; ec                          ; 0xc07b7 vberom.asm:437
    and AL, strict byte 09fh                  ; 24 9f                       ; 0xc07b8 vberom.asm:438
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc07ba vberom.asm:439
    out DX, AL                                ; ee                          ; 0xc07bc vberom.asm:440
    jmp short 007c6h                          ; eb 07                       ; 0xc07bd vberom.asm:441
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc07bf vberom.asm:446
    mov ax, 00107h                            ; b8 07 01                    ; 0xc07c2 vberom.asm:447
    out DX, ax                                ; ef                          ; 0xc07c5 vberom.asm:448
    pop dx                                    ; 5a                          ; 0xc07c6 vberom.asm:451
    pop ax                                    ; 58                          ; 0xc07c7 vberom.asm:452
  ; disGetNextSymbol 0xc07c8 LB 0x148 -> off=0x0 cb=0000000000000013 uValue=00000000000c07c8 '_vbe_has_vbe_display'
_vbe_has_vbe_display:                        ; 0xc07c8 LB 0x13
    push DS                                   ; 1e                          ; 0xc07c8 vberom.asm:458
    push bx                                   ; 53                          ; 0xc07c9 vberom.asm:459
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc07ca vberom.asm:460
    mov ds, ax                                ; 8e d8                       ; 0xc07cd vberom.asm:461
    mov bx, 000b9h                            ; bb b9 00                    ; 0xc07cf vberom.asm:462
    mov al, byte [bx]                         ; 8a 07                       ; 0xc07d2 vberom.asm:463
    and AL, strict byte 001h                  ; 24 01                       ; 0xc07d4 vberom.asm:464
    db  032h, 0e4h
    ; xor ah, ah                                ; 32 e4                     ; 0xc07d6 vberom.asm:465
    pop bx                                    ; 5b                          ; 0xc07d8 vberom.asm:466
    pop DS                                    ; 1f                          ; 0xc07d9 vberom.asm:467
    retn                                      ; c3                          ; 0xc07da vberom.asm:468
  ; disGetNextSymbol 0xc07db LB 0x135 -> off=0x0 cb=0000000000000025 uValue=00000000000c07db 'vbe_biosfn_return_current_mode'
vbe_biosfn_return_current_mode:              ; 0xc07db LB 0x25
    push DS                                   ; 1e                          ; 0xc07db vberom.asm:481
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc07dc vberom.asm:482
    mov ds, ax                                ; 8e d8                       ; 0xc07df vberom.asm:483
    call 005f1h                               ; e8 0d fe                    ; 0xc07e1 vberom.asm:484
    and ax, strict byte 00001h                ; 83 e0 01                    ; 0xc07e4 vberom.asm:485
    je short 007f2h                           ; 74 09                       ; 0xc07e7 vberom.asm:486
    mov bx, 000bah                            ; bb ba 00                    ; 0xc07e9 vberom.asm:487
    mov ax, word [bx]                         ; 8b 07                       ; 0xc07ec vberom.asm:488
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc07ee vberom.asm:489
    jne short 007fbh                          ; 75 09                       ; 0xc07f0 vberom.asm:490
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc07f2 vberom.asm:492
    mov al, byte [bx]                         ; 8a 07                       ; 0xc07f5 vberom.asm:493
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc07f7 vberom.asm:494
    db  032h, 0ffh
    ; xor bh, bh                                ; 32 ff                     ; 0xc07f9 vberom.asm:495
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc07fb vberom.asm:497
    pop DS                                    ; 1f                          ; 0xc07fe vberom.asm:498
    retn                                      ; c3                          ; 0xc07ff vberom.asm:499
  ; disGetNextSymbol 0xc0800 LB 0x110 -> off=0x0 cb=000000000000002d uValue=00000000000c0800 'vbe_biosfn_display_window_control'
vbe_biosfn_display_window_control:           ; 0xc0800 LB 0x2d
    cmp bl, 000h                              ; 80 fb 00                    ; 0xc0800 vberom.asm:523
    jne short 00829h                          ; 75 24                       ; 0xc0803 vberom.asm:524
    cmp bh, 001h                              ; 80 ff 01                    ; 0xc0805 vberom.asm:525
    je short 00820h                           ; 74 16                       ; 0xc0808 vberom.asm:526
    jc short 00810h                           ; 72 04                       ; 0xc080a vberom.asm:527
    mov ax, 00100h                            ; b8 00 01                    ; 0xc080c vberom.asm:528
    retn                                      ; c3                          ; 0xc080f vberom.asm:529
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc0810 vberom.asm:531
    call 00603h                               ; e8 ee fd                    ; 0xc0812 vberom.asm:532
    call 00617h                               ; e8 ff fd                    ; 0xc0815 vberom.asm:533
    db  03bh, 0c2h
    ; cmp ax, dx                                ; 3b c2                     ; 0xc0818 vberom.asm:534
    jne short 00829h                          ; 75 0d                       ; 0xc081a vberom.asm:535
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc081c vberom.asm:536
    retn                                      ; c3                          ; 0xc081f vberom.asm:537
    call 00617h                               ; e8 f4 fd                    ; 0xc0820 vberom.asm:539
    db  08bh, 0d0h
    ; mov dx, ax                                ; 8b d0                     ; 0xc0823 vberom.asm:540
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0825 vberom.asm:541
    retn                                      ; c3                          ; 0xc0828 vberom.asm:542
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc0829 vberom.asm:544
    retn                                      ; c3                          ; 0xc082c vberom.asm:545
  ; disGetNextSymbol 0xc082d LB 0xe3 -> off=0x0 cb=0000000000000034 uValue=00000000000c082d 'vbe_biosfn_set_get_display_start'
vbe_biosfn_set_get_display_start:            ; 0xc082d LB 0x34
    cmp bl, 080h                              ; 80 fb 80                    ; 0xc082d vberom.asm:585
    je short 0083dh                           ; 74 0b                       ; 0xc0830 vberom.asm:586
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc0832 vberom.asm:587
    je short 00851h                           ; 74 1a                       ; 0xc0835 vberom.asm:588
    jc short 00843h                           ; 72 0a                       ; 0xc0837 vberom.asm:589
    mov ax, 00100h                            ; b8 00 01                    ; 0xc0839 vberom.asm:590
    retn                                      ; c3                          ; 0xc083c vberom.asm:591
    call 00589h                               ; e8 49 fd                    ; 0xc083d vberom.asm:593
    call 0057ch                               ; e8 39 fd                    ; 0xc0840 vberom.asm:594
    db  08bh, 0c1h
    ; mov ax, cx                                ; 8b c1                     ; 0xc0843 vberom.asm:596
    call 00669h                               ; e8 21 fe                    ; 0xc0845 vberom.asm:597
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc0848 vberom.asm:598
    call 0068fh                               ; e8 42 fe                    ; 0xc084a vberom.asm:599
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc084d vberom.asm:600
    retn                                      ; c3                          ; 0xc0850 vberom.asm:601
    call 0067dh                               ; e8 29 fe                    ; 0xc0851 vberom.asm:603
    db  08bh, 0c8h
    ; mov cx, ax                                ; 8b c8                     ; 0xc0854 vberom.asm:604
    call 006a3h                               ; e8 4a fe                    ; 0xc0856 vberom.asm:605
    db  08bh, 0d0h
    ; mov dx, ax                                ; 8b d0                     ; 0xc0859 vberom.asm:606
    db  032h, 0ffh
    ; xor bh, bh                                ; 32 ff                     ; 0xc085b vberom.asm:607
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc085d vberom.asm:608
    retn                                      ; c3                          ; 0xc0860 vberom.asm:609
  ; disGetNextSymbol 0xc0861 LB 0xaf -> off=0x0 cb=0000000000000037 uValue=00000000000c0861 'vbe_biosfn_set_get_dac_palette_format'
vbe_biosfn_set_get_dac_palette_format:       ; 0xc0861 LB 0x37
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc0861 vberom.asm:624
    je short 00884h                           ; 74 1e                       ; 0xc0864 vberom.asm:625
    jc short 0086ch                           ; 72 04                       ; 0xc0866 vberom.asm:626
    mov ax, 00100h                            ; b8 00 01                    ; 0xc0868 vberom.asm:627
    retn                                      ; c3                          ; 0xc086b vberom.asm:628
    call 005f1h                               ; e8 82 fd                    ; 0xc086c vberom.asm:630
    cmp bh, 006h                              ; 80 ff 06                    ; 0xc086f vberom.asm:631
    je short 0087eh                           ; 74 0a                       ; 0xc0872 vberom.asm:632
    cmp bh, 008h                              ; 80 ff 08                    ; 0xc0874 vberom.asm:633
    jne short 00894h                          ; 75 1b                       ; 0xc0877 vberom.asm:634
    or ax, strict byte 00020h                 ; 83 c8 20                    ; 0xc0879 vberom.asm:635
    jne short 00881h                          ; 75 03                       ; 0xc087c vberom.asm:636
    and ax, strict byte 0ffdfh                ; 83 e0 df                    ; 0xc087e vberom.asm:638
    call 005ddh                               ; e8 59 fd                    ; 0xc0881 vberom.asm:640
    mov BH, strict byte 006h                  ; b7 06                       ; 0xc0884 vberom.asm:642
    call 005f1h                               ; e8 68 fd                    ; 0xc0886 vberom.asm:643
    and ax, strict byte 00020h                ; 83 e0 20                    ; 0xc0889 vberom.asm:644
    je short 00890h                           ; 74 02                       ; 0xc088c vberom.asm:645
    mov BH, strict byte 008h                  ; b7 08                       ; 0xc088e vberom.asm:646
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0890 vberom.asm:648
    retn                                      ; c3                          ; 0xc0893 vberom.asm:649
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc0894 vberom.asm:651
    retn                                      ; c3                          ; 0xc0897 vberom.asm:652
  ; disGetNextSymbol 0xc0898 LB 0x78 -> off=0x0 cb=0000000000000064 uValue=00000000000c0898 'vbe_biosfn_set_get_palette_data'
vbe_biosfn_set_get_palette_data:             ; 0xc0898 LB 0x64
    test bl, bl                               ; 84 db                       ; 0xc0898 vberom.asm:691
    je short 008abh                           ; 74 0f                       ; 0xc089a vberom.asm:692
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc089c vberom.asm:693
    je short 008d3h                           ; 74 32                       ; 0xc089f vberom.asm:694
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc08a1 vberom.asm:695
    jbe short 008f8h                          ; 76 52                       ; 0xc08a4 vberom.asm:696
    cmp bl, 080h                              ; 80 fb 80                    ; 0xc08a6 vberom.asm:697
    jne short 008f4h                          ; 75 49                       ; 0xc08a9 vberom.asm:698
    pushad                                    ; 66 60                       ; 0xc08ab vberom.asm:141
    push DS                                   ; 1e                          ; 0xc08ad vberom.asm:704
    push ES                                   ; 06                          ; 0xc08ae vberom.asm:705
    pop DS                                    ; 1f                          ; 0xc08af vberom.asm:706
    db  08ah, 0c2h
    ; mov al, dl                                ; 8a c2                     ; 0xc08b0 vberom.asm:707
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc08b2 vberom.asm:708
    out DX, AL                                ; ee                          ; 0xc08b5 vberom.asm:709
    inc dx                                    ; 42                          ; 0xc08b6 vberom.asm:710
    db  08bh, 0f7h
    ; mov si, di                                ; 8b f7                     ; 0xc08b7 vberom.asm:711
    lodsd                                     ; 66 ad                       ; 0xc08b9 vberom.asm:714
    ror eax, 010h                             ; 66 c1 c8 10                 ; 0xc08bb vberom.asm:715
    out DX, AL                                ; ee                          ; 0xc08bf vberom.asm:716
    rol eax, 008h                             ; 66 c1 c0 08                 ; 0xc08c0 vberom.asm:717
    out DX, AL                                ; ee                          ; 0xc08c4 vberom.asm:718
    rol eax, 008h                             ; 66 c1 c0 08                 ; 0xc08c5 vberom.asm:719
    out DX, AL                                ; ee                          ; 0xc08c9 vberom.asm:720
    loop 008b9h                               ; e2 ed                       ; 0xc08ca vberom.asm:731
    pop DS                                    ; 1f                          ; 0xc08cc vberom.asm:732
    popad                                     ; 66 61                       ; 0xc08cd vberom.asm:160
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc08cf vberom.asm:735
    retn                                      ; c3                          ; 0xc08d2 vberom.asm:736
    pushad                                    ; 66 60                       ; 0xc08d3 vberom.asm:141
    db  08ah, 0c2h
    ; mov al, dl                                ; 8a c2                     ; 0xc08d5 vberom.asm:740
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc08d7 vberom.asm:741
    out DX, AL                                ; ee                          ; 0xc08da vberom.asm:742
    add dl, 002h                              ; 80 c2 02                    ; 0xc08db vberom.asm:743
    db  066h, 033h, 0c0h
    ; xor eax, eax                              ; 66 33 c0                  ; 0xc08de vberom.asm:746
    in AL, DX                                 ; ec                          ; 0xc08e1 vberom.asm:747
    sal eax, 008h                             ; 66 c1 e0 08                 ; 0xc08e2 vberom.asm:748
    in AL, DX                                 ; ec                          ; 0xc08e6 vberom.asm:749
    sal eax, 008h                             ; 66 c1 e0 08                 ; 0xc08e7 vberom.asm:750
    in AL, DX                                 ; ec                          ; 0xc08eb vberom.asm:751
    stosd                                     ; 66 ab                       ; 0xc08ec vberom.asm:752
    loop 008deh                               ; e2 ee                       ; 0xc08ee vberom.asm:765
    popad                                     ; 66 61                       ; 0xc08f0 vberom.asm:160
    jmp short 008cfh                          ; eb db                       ; 0xc08f2 vberom.asm:767
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc08f4 vberom.asm:770
    retn                                      ; c3                          ; 0xc08f7 vberom.asm:771
    mov ax, 0024fh                            ; b8 4f 02                    ; 0xc08f8 vberom.asm:773
    retn                                      ; c3                          ; 0xc08fb vberom.asm:774
  ; disGetNextSymbol 0xc08fc LB 0x14 -> off=0x0 cb=0000000000000014 uValue=00000000000c08fc 'vbe_biosfn_return_protected_mode_interface'
vbe_biosfn_return_protected_mode_interface: ; 0xc08fc LB 0x14
    test bl, bl                               ; 84 db                       ; 0xc08fc vberom.asm:788
    jne short 0090ch                          ; 75 0c                       ; 0xc08fe vberom.asm:789
    push CS                                   ; 0e                          ; 0xc0900 vberom.asm:790
    pop ES                                    ; 07                          ; 0xc0901 vberom.asm:791
    mov di, 04640h                            ; bf 40 46                    ; 0xc0902 vberom.asm:792
    mov cx, 00115h                            ; b9 15 01                    ; 0xc0905 vberom.asm:793
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0908 vberom.asm:794
    retn                                      ; c3                          ; 0xc090b vberom.asm:795
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc090c vberom.asm:797
    retn                                      ; c3                          ; 0xc090f vberom.asm:798

  ; Padding 0xe0 bytes at 0xc0910
  times 224 db 0

section _TEXT progbits vstart=0x9f0 align=1 ; size=0x3854 class=CODE group=AUTO
  ; disGetNextSymbol 0xc09f0 LB 0x3854 -> off=0x0 cb=000000000000001a uValue=00000000000c09f0 'set_int_vector'
set_int_vector:                              ; 0xc09f0 LB 0x1a
    push dx                                   ; 52                          ; 0xc09f0 vgabios.c:87
    push bp                                   ; 55                          ; 0xc09f1
    mov bp, sp                                ; 89 e5                       ; 0xc09f2
    mov dx, bx                                ; 89 da                       ; 0xc09f4
    movzx bx, al                              ; 0f b6 d8                    ; 0xc09f6 vgabios.c:91
    sal bx, 002h                              ; c1 e3 02                    ; 0xc09f9
    xor ax, ax                                ; 31 c0                       ; 0xc09fc
    mov es, ax                                ; 8e c0                       ; 0xc09fe
    mov word [es:bx], dx                      ; 26 89 17                    ; 0xc0a00
    mov word [es:bx+002h], cx                 ; 26 89 4f 02                 ; 0xc0a03
    pop bp                                    ; 5d                          ; 0xc0a07 vgabios.c:92
    pop dx                                    ; 5a                          ; 0xc0a08
    retn                                      ; c3                          ; 0xc0a09
  ; disGetNextSymbol 0xc0a0a LB 0x383a -> off=0x0 cb=000000000000001c uValue=00000000000c0a0a 'init_vga_card'
init_vga_card:                               ; 0xc0a0a LB 0x1c
    push bp                                   ; 55                          ; 0xc0a0a vgabios.c:143
    mov bp, sp                                ; 89 e5                       ; 0xc0a0b
    push dx                                   ; 52                          ; 0xc0a0d
    mov AL, strict byte 0c3h                  ; b0 c3                       ; 0xc0a0e vgabios.c:146
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc0a10
    out DX, AL                                ; ee                          ; 0xc0a13
    mov AL, strict byte 004h                  ; b0 04                       ; 0xc0a14 vgabios.c:149
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc0a16
    out DX, AL                                ; ee                          ; 0xc0a19
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc0a1a vgabios.c:150
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc0a1c
    out DX, AL                                ; ee                          ; 0xc0a1f
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc0a20 vgabios.c:155
    pop dx                                    ; 5a                          ; 0xc0a23
    pop bp                                    ; 5d                          ; 0xc0a24
    retn                                      ; c3                          ; 0xc0a25
  ; disGetNextSymbol 0xc0a26 LB 0x381e -> off=0x0 cb=000000000000003e uValue=00000000000c0a26 'init_bios_area'
init_bios_area:                              ; 0xc0a26 LB 0x3e
    push bx                                   ; 53                          ; 0xc0a26 vgabios.c:221
    push bp                                   ; 55                          ; 0xc0a27
    mov bp, sp                                ; 89 e5                       ; 0xc0a28
    xor bx, bx                                ; 31 db                       ; 0xc0a2a vgabios.c:225
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0a2c
    mov es, ax                                ; 8e c0                       ; 0xc0a2f
    mov al, byte [es:bx+010h]                 ; 26 8a 47 10                 ; 0xc0a31 vgabios.c:228
    and AL, strict byte 0cfh                  ; 24 cf                       ; 0xc0a35
    or AL, strict byte 020h                   ; 0c 20                       ; 0xc0a37
    mov byte [es:bx+010h], al                 ; 26 88 47 10                 ; 0xc0a39
    mov byte [es:bx+00085h], 010h             ; 26 c6 87 85 00 10           ; 0xc0a3d vgabios.c:232
    mov word [es:bx+00087h], 0f960h           ; 26 c7 87 87 00 60 f9        ; 0xc0a43 vgabios.c:234
    mov byte [es:bx+00089h], 051h             ; 26 c6 87 89 00 51           ; 0xc0a4a vgabios.c:238
    mov byte [es:bx+065h], 009h               ; 26 c6 47 65 09              ; 0xc0a50 vgabios.c:240
    mov word [es:bx+000a8h], 0554eh           ; 26 c7 87 a8 00 4e 55        ; 0xc0a55 vgabios.c:242
    mov [es:bx+000aah], ds                    ; 26 8c 9f aa 00              ; 0xc0a5c
    pop bp                                    ; 5d                          ; 0xc0a61 vgabios.c:243
    pop bx                                    ; 5b                          ; 0xc0a62
    retn                                      ; c3                          ; 0xc0a63
  ; disGetNextSymbol 0xc0a64 LB 0x37e0 -> off=0x0 cb=000000000000002f uValue=00000000000c0a64 'vgabios_init_func'
vgabios_init_func:                           ; 0xc0a64 LB 0x2f
    push bp                                   ; 55                          ; 0xc0a64 vgabios.c:250
    mov bp, sp                                ; 89 e5                       ; 0xc0a65
    call 00a0ah                               ; e8 a0 ff                    ; 0xc0a67 vgabios.c:252
    call 00a26h                               ; e8 b9 ff                    ; 0xc0a6a vgabios.c:253
    call 03bdeh                               ; e8 6e 31                    ; 0xc0a6d vgabios.c:255
    mov bx, strict word 00028h                ; bb 28 00                    ; 0xc0a70 vgabios.c:257
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0a73
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc0a76
    call 009f0h                               ; e8 74 ff                    ; 0xc0a79
    mov bx, strict word 00028h                ; bb 28 00                    ; 0xc0a7c vgabios.c:258
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0a7f
    mov ax, strict word 0006dh                ; b8 6d 00                    ; 0xc0a82
    call 009f0h                               ; e8 68 ff                    ; 0xc0a85
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc0a88 vgabios.c:284
    db  032h, 0e4h
    ; xor ah, ah                                ; 32 e4                     ; 0xc0a8b
    int 010h                                  ; cd 10                       ; 0xc0a8d
    mov sp, bp                                ; 89 ec                       ; 0xc0a8f vgabios.c:287
    pop bp                                    ; 5d                          ; 0xc0a91
    retf                                      ; cb                          ; 0xc0a92
  ; disGetNextSymbol 0xc0a93 LB 0x37b1 -> off=0x0 cb=000000000000002d uValue=00000000000c0a93 'vga_get_cursor_pos'
vga_get_cursor_pos:                          ; 0xc0a93 LB 0x2d
    push si                                   ; 56                          ; 0xc0a93 vgabios.c:356
    push di                                   ; 57                          ; 0xc0a94
    push bp                                   ; 55                          ; 0xc0a95
    mov bp, sp                                ; 89 e5                       ; 0xc0a96
    mov si, dx                                ; 89 d6                       ; 0xc0a98
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc0a9a vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc0a9d
    mov es, dx                                ; 8e c2                       ; 0xc0aa0
    mov di, word [es:di]                      ; 26 8b 3d                    ; 0xc0aa2
    push SS                                   ; 16                          ; 0xc0aa5 vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0aa6
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc0aa7
    movzx si, al                              ; 0f b6 f0                    ; 0xc0aaa vgabios.c:360
    add si, si                                ; 01 f6                       ; 0xc0aad
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc0aaf
    mov es, dx                                ; 8e c2                       ; 0xc0ab2 vgabios.c:57
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc0ab4
    push SS                                   ; 16                          ; 0xc0ab7 vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0ab8
    mov word [es:bx], si                      ; 26 89 37                    ; 0xc0ab9
    pop bp                                    ; 5d                          ; 0xc0abc vgabios.c:361
    pop di                                    ; 5f                          ; 0xc0abd
    pop si                                    ; 5e                          ; 0xc0abe
    retn                                      ; c3                          ; 0xc0abf
  ; disGetNextSymbol 0xc0ac0 LB 0x3784 -> off=0x0 cb=000000000000005d uValue=00000000000c0ac0 'vga_find_glyph'
vga_find_glyph:                              ; 0xc0ac0 LB 0x5d
    push bp                                   ; 55                          ; 0xc0ac0 vgabios.c:364
    mov bp, sp                                ; 89 e5                       ; 0xc0ac1
    push si                                   ; 56                          ; 0xc0ac3
    push di                                   ; 57                          ; 0xc0ac4
    push ax                                   ; 50                          ; 0xc0ac5
    push ax                                   ; 50                          ; 0xc0ac6
    push dx                                   ; 52                          ; 0xc0ac7
    push bx                                   ; 53                          ; 0xc0ac8
    mov bl, cl                                ; 88 cb                       ; 0xc0ac9
    mov word [bp-006h], strict word 00000h    ; c7 46 fa 00 00              ; 0xc0acb vgabios.c:366
    dec word [bp+004h]                        ; ff 4e 04                    ; 0xc0ad0 vgabios.c:368
    cmp word [bp+004h], strict byte 0ffffh    ; 83 7e 04 ff                 ; 0xc0ad3
    je short 00b11h                           ; 74 38                       ; 0xc0ad7
    movzx cx, byte [bp+006h]                  ; 0f b6 4e 06                 ; 0xc0ad9 vgabios.c:369
    mov dx, ss                                ; 8c d2                       ; 0xc0add
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc0adf
    mov di, word [bp-008h]                    ; 8b 7e f8                    ; 0xc0ae2
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc0ae5
    push DS                                   ; 1e                          ; 0xc0ae8
    mov ds, dx                                ; 8e da                       ; 0xc0ae9
    rep cmpsb                                 ; f3 a6                       ; 0xc0aeb
    pop DS                                    ; 1f                          ; 0xc0aed
    mov ax, strict word 00000h                ; b8 00 00                    ; 0xc0aee
    je near 00af7h                            ; 0f 84 02 00                 ; 0xc0af1
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc0af5
    test ax, ax                               ; 85 c0                       ; 0xc0af7
    jne short 00b06h                          ; 75 0b                       ; 0xc0af9
    movzx ax, bl                              ; 0f b6 c3                    ; 0xc0afb vgabios.c:370
    or ah, 080h                               ; 80 cc 80                    ; 0xc0afe
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0b01
    jmp short 00b11h                          ; eb 0b                       ; 0xc0b04 vgabios.c:371
    movzx ax, byte [bp+006h]                  ; 0f b6 46 06                 ; 0xc0b06 vgabios.c:373
    add word [bp-008h], ax                    ; 01 46 f8                    ; 0xc0b0a
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc0b0d vgabios.c:374
    jmp short 00ad0h                          ; eb bf                       ; 0xc0b0f vgabios.c:375
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc0b11 vgabios.c:377
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0b14
    pop di                                    ; 5f                          ; 0xc0b17
    pop si                                    ; 5e                          ; 0xc0b18
    pop bp                                    ; 5d                          ; 0xc0b19
    retn 00004h                               ; c2 04 00                    ; 0xc0b1a
  ; disGetNextSymbol 0xc0b1d LB 0x3727 -> off=0x0 cb=0000000000000046 uValue=00000000000c0b1d 'vga_read_glyph_planar'
vga_read_glyph_planar:                       ; 0xc0b1d LB 0x46
    push bp                                   ; 55                          ; 0xc0b1d vgabios.c:379
    mov bp, sp                                ; 89 e5                       ; 0xc0b1e
    push si                                   ; 56                          ; 0xc0b20
    push di                                   ; 57                          ; 0xc0b21
    push ax                                   ; 50                          ; 0xc0b22
    push ax                                   ; 50                          ; 0xc0b23
    mov si, ax                                ; 89 c6                       ; 0xc0b24
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc0b26
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc0b29
    mov bx, cx                                ; 89 cb                       ; 0xc0b2c
    mov ax, 00805h                            ; b8 05 08                    ; 0xc0b2e vgabios.c:386
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0b31
    out DX, ax                                ; ef                          ; 0xc0b34
    dec byte [bp+004h]                        ; fe 4e 04                    ; 0xc0b35 vgabios.c:388
    cmp byte [bp+004h], 0ffh                  ; 80 7e 04 ff                 ; 0xc0b38
    je short 00b53h                           ; 74 15                       ; 0xc0b3c
    mov es, [bp-006h]                         ; 8e 46 fa                    ; 0xc0b3e vgabios.c:389
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc0b41
    not al                                    ; f6 d0                       ; 0xc0b44
    mov di, bx                                ; 89 df                       ; 0xc0b46
    inc bx                                    ; 43                          ; 0xc0b48
    push SS                                   ; 16                          ; 0xc0b49
    pop ES                                    ; 07                          ; 0xc0b4a
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0b4b
    add si, word [bp-008h]                    ; 03 76 f8                    ; 0xc0b4e vgabios.c:390
    jmp short 00b35h                          ; eb e2                       ; 0xc0b51 vgabios.c:391
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0b53 vgabios.c:394
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0b56
    out DX, ax                                ; ef                          ; 0xc0b59
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0b5a vgabios.c:395
    pop di                                    ; 5f                          ; 0xc0b5d
    pop si                                    ; 5e                          ; 0xc0b5e
    pop bp                                    ; 5d                          ; 0xc0b5f
    retn 00002h                               ; c2 02 00                    ; 0xc0b60
  ; disGetNextSymbol 0xc0b63 LB 0x36e1 -> off=0x0 cb=000000000000002a uValue=00000000000c0b63 'vga_char_ofs_planar'
vga_char_ofs_planar:                         ; 0xc0b63 LB 0x2a
    push bp                                   ; 55                          ; 0xc0b63 vgabios.c:397
    mov bp, sp                                ; 89 e5                       ; 0xc0b64
    xor dh, dh                                ; 30 f6                       ; 0xc0b66 vgabios.c:401
    imul bx, dx                               ; 0f af da                    ; 0xc0b68
    movzx dx, byte [bp+004h]                  ; 0f b6 56 04                 ; 0xc0b6b
    imul bx, dx                               ; 0f af da                    ; 0xc0b6f
    xor ah, ah                                ; 30 e4                       ; 0xc0b72
    add ax, bx                                ; 01 d8                       ; 0xc0b74
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc0b76 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc0b79
    mov es, dx                                ; 8e c2                       ; 0xc0b7c
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0b7e
    movzx bx, cl                              ; 0f b6 d9                    ; 0xc0b81 vgabios.c:58
    imul dx, bx                               ; 0f af d3                    ; 0xc0b84
    add ax, dx                                ; 01 d0                       ; 0xc0b87
    pop bp                                    ; 5d                          ; 0xc0b89 vgabios.c:405
    retn 00002h                               ; c2 02 00                    ; 0xc0b8a
  ; disGetNextSymbol 0xc0b8d LB 0x36b7 -> off=0x0 cb=000000000000003e uValue=00000000000c0b8d 'vga_read_char_planar'
vga_read_char_planar:                        ; 0xc0b8d LB 0x3e
    push bp                                   ; 55                          ; 0xc0b8d vgabios.c:407
    mov bp, sp                                ; 89 e5                       ; 0xc0b8e
    push cx                                   ; 51                          ; 0xc0b90
    push si                                   ; 56                          ; 0xc0b91
    push di                                   ; 57                          ; 0xc0b92
    sub sp, strict byte 00010h                ; 83 ec 10                    ; 0xc0b93
    mov si, ax                                ; 89 c6                       ; 0xc0b96
    mov ax, dx                                ; 89 d0                       ; 0xc0b98
    movzx di, bl                              ; 0f b6 fb                    ; 0xc0b9a vgabios.c:411
    push di                                   ; 57                          ; 0xc0b9d
    lea cx, [bp-016h]                         ; 8d 4e ea                    ; 0xc0b9e
    mov bx, si                                ; 89 f3                       ; 0xc0ba1
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc0ba3
    call 00b1dh                               ; e8 74 ff                    ; 0xc0ba6
    push di                                   ; 57                          ; 0xc0ba9 vgabios.c:414
    push 00100h                               ; 68 00 01                    ; 0xc0baa
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0bad vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0bb0
    mov es, ax                                ; 8e c0                       ; 0xc0bb2
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0bb4
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0bb7
    xor cx, cx                                ; 31 c9                       ; 0xc0bbb vgabios.c:68
    lea bx, [bp-016h]                         ; 8d 5e ea                    ; 0xc0bbd
    call 00ac0h                               ; e8 fd fe                    ; 0xc0bc0
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc0bc3 vgabios.c:415
    pop di                                    ; 5f                          ; 0xc0bc6
    pop si                                    ; 5e                          ; 0xc0bc7
    pop cx                                    ; 59                          ; 0xc0bc8
    pop bp                                    ; 5d                          ; 0xc0bc9
    retn                                      ; c3                          ; 0xc0bca
  ; disGetNextSymbol 0xc0bcb LB 0x3679 -> off=0x0 cb=000000000000001a uValue=00000000000c0bcb 'vga_char_ofs_linear'
vga_char_ofs_linear:                         ; 0xc0bcb LB 0x1a
    push bp                                   ; 55                          ; 0xc0bcb vgabios.c:417
    mov bp, sp                                ; 89 e5                       ; 0xc0bcc
    xor dh, dh                                ; 30 f6                       ; 0xc0bce vgabios.c:421
    imul dx, bx                               ; 0f af d3                    ; 0xc0bd0
    movzx bx, byte [bp+004h]                  ; 0f b6 5e 04                 ; 0xc0bd3
    imul bx, dx                               ; 0f af da                    ; 0xc0bd7
    xor ah, ah                                ; 30 e4                       ; 0xc0bda
    add ax, bx                                ; 01 d8                       ; 0xc0bdc
    sal ax, 003h                              ; c1 e0 03                    ; 0xc0bde vgabios.c:422
    pop bp                                    ; 5d                          ; 0xc0be1 vgabios.c:424
    retn 00002h                               ; c2 02 00                    ; 0xc0be2
  ; disGetNextSymbol 0xc0be5 LB 0x365f -> off=0x0 cb=000000000000004b uValue=00000000000c0be5 'vga_read_glyph_linear'
vga_read_glyph_linear:                       ; 0xc0be5 LB 0x4b
    push si                                   ; 56                          ; 0xc0be5 vgabios.c:426
    push di                                   ; 57                          ; 0xc0be6
    enter 00004h, 000h                        ; c8 04 00 00                 ; 0xc0be7
    mov si, ax                                ; 89 c6                       ; 0xc0beb
    mov word [bp-002h], dx                    ; 89 56 fe                    ; 0xc0bed
    mov word [bp-004h], bx                    ; 89 5e fc                    ; 0xc0bf0
    mov bx, cx                                ; 89 cb                       ; 0xc0bf3
    dec byte [bp+008h]                        ; fe 4e 08                    ; 0xc0bf5 vgabios.c:432
    cmp byte [bp+008h], 0ffh                  ; 80 7e 08 ff                 ; 0xc0bf8
    je short 00c2ah                           ; 74 2c                       ; 0xc0bfc
    xor dh, dh                                ; 30 f6                       ; 0xc0bfe vgabios.c:433
    mov DL, strict byte 080h                  ; b2 80                       ; 0xc0c00 vgabios.c:434
    xor ax, ax                                ; 31 c0                       ; 0xc0c02 vgabios.c:435
    jmp short 00c0bh                          ; eb 05                       ; 0xc0c04
    cmp ax, strict word 00008h                ; 3d 08 00                    ; 0xc0c06
    jnl short 00c1fh                          ; 7d 14                       ; 0xc0c09
    mov es, [bp-002h]                         ; 8e 46 fe                    ; 0xc0c0b vgabios.c:436
    mov di, si                                ; 89 f7                       ; 0xc0c0e
    add di, ax                                ; 01 c7                       ; 0xc0c10
    cmp byte [es:di], 000h                    ; 26 80 3d 00                 ; 0xc0c12
    je short 00c1ah                           ; 74 02                       ; 0xc0c16
    or dh, dl                                 ; 08 d6                       ; 0xc0c18 vgabios.c:437
    shr dl, 1                                 ; d0 ea                       ; 0xc0c1a vgabios.c:438
    inc ax                                    ; 40                          ; 0xc0c1c vgabios.c:439
    jmp short 00c06h                          ; eb e7                       ; 0xc0c1d
    mov di, bx                                ; 89 df                       ; 0xc0c1f vgabios.c:440
    inc bx                                    ; 43                          ; 0xc0c21
    mov byte [ss:di], dh                      ; 36 88 35                    ; 0xc0c22
    add si, word [bp-004h]                    ; 03 76 fc                    ; 0xc0c25 vgabios.c:441
    jmp short 00bf5h                          ; eb cb                       ; 0xc0c28 vgabios.c:442
    leave                                     ; c9                          ; 0xc0c2a vgabios.c:443
    pop di                                    ; 5f                          ; 0xc0c2b
    pop si                                    ; 5e                          ; 0xc0c2c
    retn 00002h                               ; c2 02 00                    ; 0xc0c2d
  ; disGetNextSymbol 0xc0c30 LB 0x3614 -> off=0x0 cb=000000000000003f uValue=00000000000c0c30 'vga_read_char_linear'
vga_read_char_linear:                        ; 0xc0c30 LB 0x3f
    push bp                                   ; 55                          ; 0xc0c30 vgabios.c:445
    mov bp, sp                                ; 89 e5                       ; 0xc0c31
    push cx                                   ; 51                          ; 0xc0c33
    push si                                   ; 56                          ; 0xc0c34
    sub sp, strict byte 00010h                ; 83 ec 10                    ; 0xc0c35
    mov cx, ax                                ; 89 c1                       ; 0xc0c38
    mov ax, dx                                ; 89 d0                       ; 0xc0c3a
    movzx si, bl                              ; 0f b6 f3                    ; 0xc0c3c vgabios.c:449
    push si                                   ; 56                          ; 0xc0c3f
    mov bx, cx                                ; 89 cb                       ; 0xc0c40
    sal bx, 003h                              ; c1 e3 03                    ; 0xc0c42
    lea cx, [bp-014h]                         ; 8d 4e ec                    ; 0xc0c45
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc0c48
    call 00be5h                               ; e8 97 ff                    ; 0xc0c4b
    push si                                   ; 56                          ; 0xc0c4e vgabios.c:452
    push 00100h                               ; 68 00 01                    ; 0xc0c4f
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0c52 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0c55
    mov es, ax                                ; 8e c0                       ; 0xc0c57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0c59
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0c5c
    xor cx, cx                                ; 31 c9                       ; 0xc0c60 vgabios.c:68
    lea bx, [bp-014h]                         ; 8d 5e ec                    ; 0xc0c62
    call 00ac0h                               ; e8 58 fe                    ; 0xc0c65
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0c68 vgabios.c:453
    pop si                                    ; 5e                          ; 0xc0c6b
    pop cx                                    ; 59                          ; 0xc0c6c
    pop bp                                    ; 5d                          ; 0xc0c6d
    retn                                      ; c3                          ; 0xc0c6e
  ; disGetNextSymbol 0xc0c6f LB 0x35d5 -> off=0x0 cb=0000000000000035 uValue=00000000000c0c6f 'vga_read_2bpp_char'
vga_read_2bpp_char:                          ; 0xc0c6f LB 0x35
    push bp                                   ; 55                          ; 0xc0c6f vgabios.c:455
    mov bp, sp                                ; 89 e5                       ; 0xc0c70
    push bx                                   ; 53                          ; 0xc0c72
    push cx                                   ; 51                          ; 0xc0c73
    mov bx, ax                                ; 89 c3                       ; 0xc0c74
    mov es, dx                                ; 8e c2                       ; 0xc0c76
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0c78 vgabios.c:461
    mov DH, strict byte 080h                  ; b6 80                       ; 0xc0c7b vgabios.c:462
    xor dl, dl                                ; 30 d2                       ; 0xc0c7d vgabios.c:463
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0c7f vgabios.c:464
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0c82
    xor bx, bx                                ; 31 db                       ; 0xc0c84 vgabios.c:466
    jmp short 00c8dh                          ; eb 05                       ; 0xc0c86
    cmp bx, strict byte 00008h                ; 83 fb 08                    ; 0xc0c88
    jnl short 00c9bh                          ; 7d 0e                       ; 0xc0c8b
    test ax, cx                               ; 85 c8                       ; 0xc0c8d vgabios.c:467
    je short 00c93h                           ; 74 02                       ; 0xc0c8f
    or dl, dh                                 ; 08 f2                       ; 0xc0c91 vgabios.c:468
    shr dh, 1                                 ; d0 ee                       ; 0xc0c93 vgabios.c:469
    shr cx, 002h                              ; c1 e9 02                    ; 0xc0c95 vgabios.c:470
    inc bx                                    ; 43                          ; 0xc0c98 vgabios.c:471
    jmp short 00c88h                          ; eb ed                       ; 0xc0c99
    mov al, dl                                ; 88 d0                       ; 0xc0c9b vgabios.c:473
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0c9d
    pop cx                                    ; 59                          ; 0xc0ca0
    pop bx                                    ; 5b                          ; 0xc0ca1
    pop bp                                    ; 5d                          ; 0xc0ca2
    retn                                      ; c3                          ; 0xc0ca3
  ; disGetNextSymbol 0xc0ca4 LB 0x35a0 -> off=0x0 cb=0000000000000084 uValue=00000000000c0ca4 'vga_read_glyph_cga'
vga_read_glyph_cga:                          ; 0xc0ca4 LB 0x84
    push bp                                   ; 55                          ; 0xc0ca4 vgabios.c:475
    mov bp, sp                                ; 89 e5                       ; 0xc0ca5
    push cx                                   ; 51                          ; 0xc0ca7
    push si                                   ; 56                          ; 0xc0ca8
    push di                                   ; 57                          ; 0xc0ca9
    push ax                                   ; 50                          ; 0xc0caa
    mov si, dx                                ; 89 d6                       ; 0xc0cab
    cmp bl, 006h                              ; 80 fb 06                    ; 0xc0cad vgabios.c:483
    je short 00cech                           ; 74 3a                       ; 0xc0cb0
    mov bx, ax                                ; 89 c3                       ; 0xc0cb2 vgabios.c:485
    add bx, ax                                ; 01 c3                       ; 0xc0cb4
    mov word [bp-008h], 0b800h                ; c7 46 f8 00 b8              ; 0xc0cb6
    xor cx, cx                                ; 31 c9                       ; 0xc0cbb vgabios.c:487
    jmp short 00cc4h                          ; eb 05                       ; 0xc0cbd
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc0cbf
    jnl short 00d20h                          ; 7d 5c                       ; 0xc0cc2
    mov ax, bx                                ; 89 d8                       ; 0xc0cc4 vgabios.c:488
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc0cc6
    call 00c6fh                               ; e8 a3 ff                    ; 0xc0cc9
    mov di, si                                ; 89 f7                       ; 0xc0ccc
    inc si                                    ; 46                          ; 0xc0cce
    push SS                                   ; 16                          ; 0xc0ccf
    pop ES                                    ; 07                          ; 0xc0cd0
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0cd1
    lea ax, [bx+02000h]                       ; 8d 87 00 20                 ; 0xc0cd4 vgabios.c:489
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc0cd8
    call 00c6fh                               ; e8 91 ff                    ; 0xc0cdb
    mov di, si                                ; 89 f7                       ; 0xc0cde
    inc si                                    ; 46                          ; 0xc0ce0
    push SS                                   ; 16                          ; 0xc0ce1
    pop ES                                    ; 07                          ; 0xc0ce2
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0ce3
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc0ce6 vgabios.c:490
    inc cx                                    ; 41                          ; 0xc0ce9 vgabios.c:491
    jmp short 00cbfh                          ; eb d3                       ; 0xc0cea
    mov bx, ax                                ; 89 c3                       ; 0xc0cec vgabios.c:493
    mov word [bp-008h], 0b800h                ; c7 46 f8 00 b8              ; 0xc0cee
    xor cx, cx                                ; 31 c9                       ; 0xc0cf3 vgabios.c:494
    jmp short 00cfch                          ; eb 05                       ; 0xc0cf5
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc0cf7
    jnl short 00d20h                          ; 7d 24                       ; 0xc0cfa
    mov di, si                                ; 89 f7                       ; 0xc0cfc vgabios.c:495
    inc si                                    ; 46                          ; 0xc0cfe
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc0cff
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0d02
    push SS                                   ; 16                          ; 0xc0d05
    pop ES                                    ; 07                          ; 0xc0d06
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d07
    mov di, si                                ; 89 f7                       ; 0xc0d0a vgabios.c:496
    inc si                                    ; 46                          ; 0xc0d0c
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc0d0d
    mov al, byte [es:bx+02000h]               ; 26 8a 87 00 20              ; 0xc0d10
    push SS                                   ; 16                          ; 0xc0d15
    pop ES                                    ; 07                          ; 0xc0d16
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d17
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc0d1a vgabios.c:497
    inc cx                                    ; 41                          ; 0xc0d1d vgabios.c:498
    jmp short 00cf7h                          ; eb d7                       ; 0xc0d1e
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc0d20 vgabios.c:500
    pop di                                    ; 5f                          ; 0xc0d23
    pop si                                    ; 5e                          ; 0xc0d24
    pop cx                                    ; 59                          ; 0xc0d25
    pop bp                                    ; 5d                          ; 0xc0d26
    retn                                      ; c3                          ; 0xc0d27
  ; disGetNextSymbol 0xc0d28 LB 0x351c -> off=0x0 cb=0000000000000011 uValue=00000000000c0d28 'vga_char_ofs_cga'
vga_char_ofs_cga:                            ; 0xc0d28 LB 0x11
    push bp                                   ; 55                          ; 0xc0d28 vgabios.c:502
    mov bp, sp                                ; 89 e5                       ; 0xc0d29
    xor dh, dh                                ; 30 f6                       ; 0xc0d2b vgabios.c:507
    imul dx, bx                               ; 0f af d3                    ; 0xc0d2d
    sal dx, 002h                              ; c1 e2 02                    ; 0xc0d30
    xor ah, ah                                ; 30 e4                       ; 0xc0d33
    add ax, dx                                ; 01 d0                       ; 0xc0d35
    pop bp                                    ; 5d                          ; 0xc0d37 vgabios.c:508
    retn                                      ; c3                          ; 0xc0d38
  ; disGetNextSymbol 0xc0d39 LB 0x350b -> off=0x0 cb=0000000000000065 uValue=00000000000c0d39 'vga_read_char_cga'
vga_read_char_cga:                           ; 0xc0d39 LB 0x65
    push bp                                   ; 55                          ; 0xc0d39 vgabios.c:510
    mov bp, sp                                ; 89 e5                       ; 0xc0d3a
    push bx                                   ; 53                          ; 0xc0d3c
    push cx                                   ; 51                          ; 0xc0d3d
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc0d3e
    movzx bx, dl                              ; 0f b6 da                    ; 0xc0d41 vgabios.c:516
    lea dx, [bp-00eh]                         ; 8d 56 f2                    ; 0xc0d44
    call 00ca4h                               ; e8 5a ff                    ; 0xc0d47
    push strict byte 00008h                   ; 6a 08                       ; 0xc0d4a vgabios.c:519
    push 00080h                               ; 68 80 00                    ; 0xc0d4c
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0d4f vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0d52
    mov es, ax                                ; 8e c0                       ; 0xc0d54
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0d56
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0d59
    xor cx, cx                                ; 31 c9                       ; 0xc0d5d vgabios.c:68
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc0d5f
    call 00ac0h                               ; e8 5b fd                    ; 0xc0d62
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0d65
    test ah, 080h                             ; f6 c4 80                    ; 0xc0d68 vgabios.c:521
    jne short 00d94h                          ; 75 27                       ; 0xc0d6b
    mov bx, strict word 0007ch                ; bb 7c 00                    ; 0xc0d6d vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0d70
    mov es, ax                                ; 8e c0                       ; 0xc0d72
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0d74
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0d77
    test dx, dx                               ; 85 d2                       ; 0xc0d7b vgabios.c:525
    jne short 00d83h                          ; 75 04                       ; 0xc0d7d
    test ax, ax                               ; 85 c0                       ; 0xc0d7f
    je short 00d94h                           ; 74 11                       ; 0xc0d81
    push strict byte 00008h                   ; 6a 08                       ; 0xc0d83 vgabios.c:526
    push 00080h                               ; 68 80 00                    ; 0xc0d85
    mov cx, 00080h                            ; b9 80 00                    ; 0xc0d88
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc0d8b
    call 00ac0h                               ; e8 2f fd                    ; 0xc0d8e
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0d91
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc0d94 vgabios.c:529
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0d97
    pop cx                                    ; 59                          ; 0xc0d9a
    pop bx                                    ; 5b                          ; 0xc0d9b
    pop bp                                    ; 5d                          ; 0xc0d9c
    retn                                      ; c3                          ; 0xc0d9d
  ; disGetNextSymbol 0xc0d9e LB 0x34a6 -> off=0x0 cb=000000000000011b uValue=00000000000c0d9e 'vga_read_char_attr'
vga_read_char_attr:                          ; 0xc0d9e LB 0x11b
    push bp                                   ; 55                          ; 0xc0d9e vgabios.c:531
    mov bp, sp                                ; 89 e5                       ; 0xc0d9f
    push bx                                   ; 53                          ; 0xc0da1
    push cx                                   ; 51                          ; 0xc0da2
    push si                                   ; 56                          ; 0xc0da3
    push di                                   ; 57                          ; 0xc0da4
    sub sp, strict byte 00014h                ; 83 ec 14                    ; 0xc0da5
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc0da8
    mov si, dx                                ; 89 d6                       ; 0xc0dab
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0dad vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0db0
    mov es, ax                                ; 8e c0                       ; 0xc0db3
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0db5
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc0db8 vgabios.c:48
    xor ah, ah                                ; 30 e4                       ; 0xc0dbb vgabios.c:539
    call 0356fh                               ; e8 af 27                    ; 0xc0dbd
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc0dc0
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc0dc3 vgabios.c:540
    je near 00eb0h                            ; 0f 84 e7 00                 ; 0xc0dc5
    movzx cx, byte [bp-00eh]                  ; 0f b6 4e f2                 ; 0xc0dc9 vgabios.c:544
    lea bx, [bp-01ch]                         ; 8d 5e e4                    ; 0xc0dcd
    lea dx, [bp-01ah]                         ; 8d 56 e6                    ; 0xc0dd0
    mov ax, cx                                ; 89 c8                       ; 0xc0dd3
    call 00a93h                               ; e8 bb fc                    ; 0xc0dd5
    mov al, byte [bp-01ch]                    ; 8a 46 e4                    ; 0xc0dd8 vgabios.c:545
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc0ddb
    mov ax, word [bp-01ch]                    ; 8b 46 e4                    ; 0xc0dde vgabios.c:546
    xor al, al                                ; 30 c0                       ; 0xc0de1
    shr ax, 008h                              ; c1 e8 08                    ; 0xc0de3
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc0de6
    mov di, strict word 0004ah                ; bf 4a 00                    ; 0xc0de9 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc0dec
    mov es, dx                                ; 8e c2                       ; 0xc0def
    mov di, word [es:di]                      ; 26 8b 3d                    ; 0xc0df1
    mov word [bp-016h], di                    ; 89 7e ea                    ; 0xc0df4 vgabios.c:58
    movzx dx, byte [bp-012h]                  ; 0f b6 56 ee                 ; 0xc0df7 vgabios.c:552
    sal dx, 003h                              ; c1 e2 03                    ; 0xc0dfb
    mov word [bp-014h], dx                    ; 89 56 ec                    ; 0xc0dfe
    mov bx, dx                                ; 89 d3                       ; 0xc0e01
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc0e03
    jne short 00e38h                          ; 75 2e                       ; 0xc0e08
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc0e0a vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc0e0d
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc0e10 vgabios.c:58
    imul bx, dx                               ; 0f af da                    ; 0xc0e14
    xor ah, ah                                ; 30 e4                       ; 0xc0e17 vgabios.c:555
    imul ax, di                               ; 0f af c7                    ; 0xc0e19
    movzx dx, byte [bp-010h]                  ; 0f b6 56 f0                 ; 0xc0e1c
    add ax, dx                                ; 01 d0                       ; 0xc0e20
    add ax, ax                                ; 01 c0                       ; 0xc0e22
    add bx, ax                                ; 01 c3                       ; 0xc0e24
    mov di, word [bp-014h]                    ; 8b 7e ec                    ; 0xc0e26 vgabios.c:55
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc0e29
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0e2d
    push SS                                   ; 16                          ; 0xc0e30 vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0e31
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc0e32
    jmp near 00eb0h                           ; e9 78 00                    ; 0xc0e35 vgabios.c:558
    mov dl, byte [bx+047aeh]                  ; 8a 97 ae 47                 ; 0xc0e38 vgabios.c:559
    cmp dl, 005h                              ; 80 fa 05                    ; 0xc0e3c
    je short 00e8ch                           ; 74 4b                       ; 0xc0e3f
    cmp dl, 002h                              ; 80 fa 02                    ; 0xc0e41
    jc short 00eb0h                           ; 72 6a                       ; 0xc0e44
    jbe short 00e4fh                          ; 76 07                       ; 0xc0e46
    cmp dl, 004h                              ; 80 fa 04                    ; 0xc0e48
    jbe short 00e68h                          ; 76 1b                       ; 0xc0e4b
    jmp short 00eb0h                          ; eb 61                       ; 0xc0e4d
    movzx dx, byte [bp-00ch]                  ; 0f b6 56 f4                 ; 0xc0e4f vgabios.c:562
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc0e53
    mov bx, word [bp-016h]                    ; 8b 5e ea                    ; 0xc0e57
    call 00d28h                               ; e8 cb fe                    ; 0xc0e5a
    movzx dx, byte [bp-00ah]                  ; 0f b6 56 f6                 ; 0xc0e5d vgabios.c:563
    call 00d39h                               ; e8 d5 fe                    ; 0xc0e61
    xor ah, ah                                ; 30 e4                       ; 0xc0e64
    jmp short 00e30h                          ; eb c8                       ; 0xc0e66
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0e68 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0e6b
    xor dh, dh                                ; 30 f6                       ; 0xc0e6e vgabios.c:568
    mov word [bp-018h], dx                    ; 89 56 e8                    ; 0xc0e70
    push dx                                   ; 52                          ; 0xc0e73
    movzx dx, al                              ; 0f b6 d0                    ; 0xc0e74
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc0e77
    mov bx, di                                ; 89 fb                       ; 0xc0e7b
    call 00b63h                               ; e8 e3 fc                    ; 0xc0e7d
    mov bx, word [bp-018h]                    ; 8b 5e e8                    ; 0xc0e80 vgabios.c:569
    mov dx, ax                                ; 89 c2                       ; 0xc0e83
    mov ax, di                                ; 89 f8                       ; 0xc0e85
    call 00b8dh                               ; e8 03 fd                    ; 0xc0e87
    jmp short 00e64h                          ; eb d8                       ; 0xc0e8a
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0e8c vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0e8f
    xor dh, dh                                ; 30 f6                       ; 0xc0e92 vgabios.c:573
    mov word [bp-018h], dx                    ; 89 56 e8                    ; 0xc0e94
    push dx                                   ; 52                          ; 0xc0e97
    movzx dx, al                              ; 0f b6 d0                    ; 0xc0e98
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc0e9b
    mov bx, di                                ; 89 fb                       ; 0xc0e9f
    call 00bcbh                               ; e8 27 fd                    ; 0xc0ea1
    mov bx, word [bp-018h]                    ; 8b 5e e8                    ; 0xc0ea4 vgabios.c:574
    mov dx, ax                                ; 89 c2                       ; 0xc0ea7
    mov ax, di                                ; 89 f8                       ; 0xc0ea9
    call 00c30h                               ; e8 82 fd                    ; 0xc0eab
    jmp short 00e64h                          ; eb b4                       ; 0xc0eae
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc0eb0 vgabios.c:583
    pop di                                    ; 5f                          ; 0xc0eb3
    pop si                                    ; 5e                          ; 0xc0eb4
    pop cx                                    ; 59                          ; 0xc0eb5
    pop bx                                    ; 5b                          ; 0xc0eb6
    pop bp                                    ; 5d                          ; 0xc0eb7
    retn                                      ; c3                          ; 0xc0eb8
  ; disGetNextSymbol 0xc0eb9 LB 0x338b -> off=0x10 cb=0000000000000083 uValue=00000000000c0ec9 'vga_get_font_info'
    db  0e0h, 00eh, 025h, 00fh, 02ah, 00fh, 031h, 00fh, 036h, 00fh, 03bh, 00fh, 040h, 00fh, 045h, 00fh
vga_get_font_info:                           ; 0xc0ec9 LB 0x83
    push si                                   ; 56                          ; 0xc0ec9 vgabios.c:585
    push di                                   ; 57                          ; 0xc0eca
    push bp                                   ; 55                          ; 0xc0ecb
    mov bp, sp                                ; 89 e5                       ; 0xc0ecc
    mov di, dx                                ; 89 d7                       ; 0xc0ece
    mov si, bx                                ; 89 de                       ; 0xc0ed0
    cmp ax, strict word 00007h                ; 3d 07 00                    ; 0xc0ed2 vgabios.c:590
    jnbe short 00f1fh                         ; 77 48                       ; 0xc0ed5
    mov bx, ax                                ; 89 c3                       ; 0xc0ed7
    add bx, ax                                ; 01 c3                       ; 0xc0ed9
    jmp word [cs:bx+00eb9h]                   ; 2e ff a7 b9 0e              ; 0xc0edb
    mov bx, strict word 0007ch                ; bb 7c 00                    ; 0xc0ee0 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0ee3
    mov es, ax                                ; 8e c0                       ; 0xc0ee5
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0ee7
    mov ax, word [es:bx+002h]                 ; 26 8b 47 02                 ; 0xc0eea
    push SS                                   ; 16                          ; 0xc0eee vgabios.c:593
    pop ES                                    ; 07                          ; 0xc0eef
    mov word [es:si], dx                      ; 26 89 14                    ; 0xc0ef0
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc0ef3
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0ef6
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0ef9
    mov es, ax                                ; 8e c0                       ; 0xc0efc
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0efe
    xor ah, ah                                ; 30 e4                       ; 0xc0f01
    push SS                                   ; 16                          ; 0xc0f03
    pop ES                                    ; 07                          ; 0xc0f04
    mov bx, cx                                ; 89 cb                       ; 0xc0f05
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0f07
    mov bx, 00084h                            ; bb 84 00                    ; 0xc0f0a
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f0d
    mov es, ax                                ; 8e c0                       ; 0xc0f10
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f12
    xor ah, ah                                ; 30 e4                       ; 0xc0f15
    push SS                                   ; 16                          ; 0xc0f17
    pop ES                                    ; 07                          ; 0xc0f18
    mov bx, word [bp+008h]                    ; 8b 5e 08                    ; 0xc0f19
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0f1c
    pop bp                                    ; 5d                          ; 0xc0f1f
    pop di                                    ; 5f                          ; 0xc0f20
    pop si                                    ; 5e                          ; 0xc0f21
    retn 00002h                               ; c2 02 00                    ; 0xc0f22
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0f25 vgabios.c:67
    jmp short 00ee3h                          ; eb b9                       ; 0xc0f28
    mov dx, 05d6ah                            ; ba 6a 5d                    ; 0xc0f2a vgabios.c:598
    mov ax, ds                                ; 8c d8                       ; 0xc0f2d
    jmp short 00eeeh                          ; eb bd                       ; 0xc0f2f vgabios.c:599
    mov dx, 0556ah                            ; ba 6a 55                    ; 0xc0f31 vgabios.c:601
    jmp short 00f2dh                          ; eb f7                       ; 0xc0f34
    mov dx, 0596ah                            ; ba 6a 59                    ; 0xc0f36 vgabios.c:604
    jmp short 00f2dh                          ; eb f2                       ; 0xc0f39
    mov dx, 07b6ah                            ; ba 6a 7b                    ; 0xc0f3b vgabios.c:607
    jmp short 00f2dh                          ; eb ed                       ; 0xc0f3e
    mov dx, 06b6ah                            ; ba 6a 6b                    ; 0xc0f40 vgabios.c:610
    jmp short 00f2dh                          ; eb e8                       ; 0xc0f43
    mov dx, 07c97h                            ; ba 97 7c                    ; 0xc0f45 vgabios.c:613
    jmp short 00f2dh                          ; eb e3                       ; 0xc0f48
    jmp short 00f1fh                          ; eb d3                       ; 0xc0f4a vgabios.c:619
  ; disGetNextSymbol 0xc0f4c LB 0x32f8 -> off=0x0 cb=0000000000000156 uValue=00000000000c0f4c 'vga_read_pixel'
vga_read_pixel:                              ; 0xc0f4c LB 0x156
    push bp                                   ; 55                          ; 0xc0f4c vgabios.c:632
    mov bp, sp                                ; 89 e5                       ; 0xc0f4d
    push si                                   ; 56                          ; 0xc0f4f
    push di                                   ; 57                          ; 0xc0f50
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc0f51
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc0f54
    mov word [bp-00ch], bx                    ; 89 5e f4                    ; 0xc0f57
    mov si, cx                                ; 89 ce                       ; 0xc0f5a
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0f5c vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f5f
    mov es, ax                                ; 8e c0                       ; 0xc0f62
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f64
    xor ah, ah                                ; 30 e4                       ; 0xc0f67 vgabios.c:639
    call 0356fh                               ; e8 03 26                    ; 0xc0f69
    mov ah, al                                ; 88 c4                       ; 0xc0f6c
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc0f6e vgabios.c:640
    je near 0109bh                            ; 0f 84 27 01                 ; 0xc0f70
    movzx bx, al                              ; 0f b6 d8                    ; 0xc0f74 vgabios.c:642
    sal bx, 003h                              ; c1 e3 03                    ; 0xc0f77
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc0f7a
    je near 0109bh                            ; 0f 84 18 01                 ; 0xc0f7f
    mov ch, byte [bx+047aeh]                  ; 8a af ae 47                 ; 0xc0f83 vgabios.c:646
    cmp ch, 003h                              ; 80 fd 03                    ; 0xc0f87
    jc short 00f9dh                           ; 72 11                       ; 0xc0f8a
    jbe short 00fa5h                          ; 76 17                       ; 0xc0f8c
    cmp ch, 005h                              ; 80 fd 05                    ; 0xc0f8e
    je near 01074h                            ; 0f 84 df 00                 ; 0xc0f91
    cmp ch, 004h                              ; 80 fd 04                    ; 0xc0f95
    je short 00fa5h                           ; 74 0b                       ; 0xc0f98
    jmp near 01094h                           ; e9 f7 00                    ; 0xc0f9a
    cmp ch, 002h                              ; 80 fd 02                    ; 0xc0f9d
    je short 01010h                           ; 74 6e                       ; 0xc0fa0
    jmp near 01094h                           ; e9 ef 00                    ; 0xc0fa2
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc0fa5 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0fa8
    mov es, ax                                ; 8e c0                       ; 0xc0fab
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0fad
    imul ax, word [bp-00ch]                   ; 0f af 46 f4                 ; 0xc0fb0 vgabios.c:58
    mov bx, dx                                ; 89 d3                       ; 0xc0fb4
    shr bx, 003h                              ; c1 eb 03                    ; 0xc0fb6
    add bx, ax                                ; 01 c3                       ; 0xc0fb9
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc0fbb vgabios.c:57
    mov cx, word [es:di]                      ; 26 8b 0d                    ; 0xc0fbe
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc0fc1 vgabios.c:58
    imul ax, cx                               ; 0f af c1                    ; 0xc0fc5
    add bx, ax                                ; 01 c3                       ; 0xc0fc8
    mov cl, dl                                ; 88 d1                       ; 0xc0fca vgabios.c:651
    and cl, 007h                              ; 80 e1 07                    ; 0xc0fcc
    mov ax, 00080h                            ; b8 80 00                    ; 0xc0fcf
    sar ax, CL                                ; d3 f8                       ; 0xc0fd2
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc0fd4
    xor ch, ch                                ; 30 ed                       ; 0xc0fd7 vgabios.c:652
    mov byte [bp-006h], ch                    ; 88 6e fa                    ; 0xc0fd9 vgabios.c:653
    jmp short 00fe6h                          ; eb 08                       ; 0xc0fdc
    cmp byte [bp-006h], 004h                  ; 80 7e fa 04                 ; 0xc0fde
    jnc near 01096h                           ; 0f 83 b0 00                 ; 0xc0fe2
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc0fe6 vgabios.c:654
    sal ax, 008h                              ; c1 e0 08                    ; 0xc0fea
    or AL, strict byte 004h                   ; 0c 04                       ; 0xc0fed
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0fef
    out DX, ax                                ; ef                          ; 0xc0ff2
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc0ff3 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc0ff6
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0ff8
    and al, byte [bp-008h]                    ; 22 46 f8                    ; 0xc0ffb vgabios.c:48
    test al, al                               ; 84 c0                       ; 0xc0ffe vgabios.c:656
    jbe short 0100bh                          ; 76 09                       ; 0xc1000
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc1002 vgabios.c:657
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc1005
    sal al, CL                                ; d2 e0                       ; 0xc1007
    or ch, al                                 ; 08 c5                       ; 0xc1009
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc100b vgabios.c:658
    jmp short 00fdeh                          ; eb ce                       ; 0xc100e
    movzx cx, byte [bx+047afh]                ; 0f b6 8f af 47              ; 0xc1010 vgabios.c:661
    mov bx, strict word 00004h                ; bb 04 00                    ; 0xc1015
    sub bx, cx                                ; 29 cb                       ; 0xc1018
    mov cx, bx                                ; 89 d9                       ; 0xc101a
    mov bx, dx                                ; 89 d3                       ; 0xc101c
    shr bx, CL                                ; d3 eb                       ; 0xc101e
    mov cx, bx                                ; 89 d9                       ; 0xc1020
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc1022
    shr bx, 1                                 ; d1 eb                       ; 0xc1025
    imul bx, bx, strict byte 00050h           ; 6b db 50                    ; 0xc1027
    add bx, cx                                ; 01 cb                       ; 0xc102a
    test byte [bp-00ch], 001h                 ; f6 46 f4 01                 ; 0xc102c vgabios.c:662
    je short 01035h                           ; 74 03                       ; 0xc1030
    add bh, 020h                              ; 80 c7 20                    ; 0xc1032 vgabios.c:663
    mov cx, 0b800h                            ; b9 00 b8                    ; 0xc1035 vgabios.c:47
    mov es, cx                                ; 8e c1                       ; 0xc1038
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc103a
    movzx bx, ah                              ; 0f b6 dc                    ; 0xc103d vgabios.c:665
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1040
    cmp byte [bx+047afh], 002h                ; 80 bf af 47 02              ; 0xc1043
    jne short 0105fh                          ; 75 15                       ; 0xc1048
    and dx, strict byte 00003h                ; 83 e2 03                    ; 0xc104a vgabios.c:666
    mov cx, strict word 00003h                ; b9 03 00                    ; 0xc104d
    sub cx, dx                                ; 29 d1                       ; 0xc1050
    add cx, cx                                ; 01 c9                       ; 0xc1052
    xor ah, ah                                ; 30 e4                       ; 0xc1054
    sar ax, CL                                ; d3 f8                       ; 0xc1056
    mov ch, al                                ; 88 c5                       ; 0xc1058
    and ch, 003h                              ; 80 e5 03                    ; 0xc105a
    jmp short 01096h                          ; eb 37                       ; 0xc105d vgabios.c:667
    xor dh, dh                                ; 30 f6                       ; 0xc105f vgabios.c:668
    and dl, 007h                              ; 80 e2 07                    ; 0xc1061
    mov cx, strict word 00007h                ; b9 07 00                    ; 0xc1064
    sub cx, dx                                ; 29 d1                       ; 0xc1067
    xor ah, ah                                ; 30 e4                       ; 0xc1069
    sar ax, CL                                ; d3 f8                       ; 0xc106b
    mov ch, al                                ; 88 c5                       ; 0xc106d
    and ch, 001h                              ; 80 e5 01                    ; 0xc106f
    jmp short 01096h                          ; eb 22                       ; 0xc1072 vgabios.c:669
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc1074 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1077
    mov es, ax                                ; 8e c0                       ; 0xc107a
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc107c
    sal ax, 003h                              ; c1 e0 03                    ; 0xc107f vgabios.c:58
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc1082
    imul bx, ax                               ; 0f af d8                    ; 0xc1085
    add bx, dx                                ; 01 d3                       ; 0xc1088
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc108a vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc108d
    mov ch, byte [es:bx]                      ; 26 8a 2f                    ; 0xc108f
    jmp short 01096h                          ; eb 02                       ; 0xc1092 vgabios.c:673
    xor ch, ch                                ; 30 ed                       ; 0xc1094 vgabios.c:678
    push SS                                   ; 16                          ; 0xc1096 vgabios.c:680
    pop ES                                    ; 07                          ; 0xc1097
    mov byte [es:si], ch                      ; 26 88 2c                    ; 0xc1098
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc109b vgabios.c:681
    pop di                                    ; 5f                          ; 0xc109e
    pop si                                    ; 5e                          ; 0xc109f
    pop bp                                    ; 5d                          ; 0xc10a0
    retn                                      ; c3                          ; 0xc10a1
  ; disGetNextSymbol 0xc10a2 LB 0x31a2 -> off=0x0 cb=000000000000008c uValue=00000000000c10a2 'biosfn_perform_gray_scale_summing'
biosfn_perform_gray_scale_summing:           ; 0xc10a2 LB 0x8c
    push bp                                   ; 55                          ; 0xc10a2 vgabios.c:686
    mov bp, sp                                ; 89 e5                       ; 0xc10a3
    push bx                                   ; 53                          ; 0xc10a5
    push cx                                   ; 51                          ; 0xc10a6
    push si                                   ; 56                          ; 0xc10a7
    push di                                   ; 57                          ; 0xc10a8
    push ax                                   ; 50                          ; 0xc10a9
    push ax                                   ; 50                          ; 0xc10aa
    mov bx, ax                                ; 89 c3                       ; 0xc10ab
    mov di, dx                                ; 89 d7                       ; 0xc10ad
    mov dx, 003dah                            ; ba da 03                    ; 0xc10af vgabios.c:691
    in AL, DX                                 ; ec                          ; 0xc10b2
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc10b3
    xor al, al                                ; 30 c0                       ; 0xc10b5 vgabios.c:692
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc10b7
    out DX, AL                                ; ee                          ; 0xc10ba
    xor si, si                                ; 31 f6                       ; 0xc10bb vgabios.c:694
    cmp si, di                                ; 39 fe                       ; 0xc10bd
    jnc short 01113h                          ; 73 52                       ; 0xc10bf
    mov al, bl                                ; 88 d8                       ; 0xc10c1 vgabios.c:697
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc10c3
    out DX, AL                                ; ee                          ; 0xc10c6
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc10c7 vgabios.c:699
    in AL, DX                                 ; ec                          ; 0xc10ca
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc10cb
    mov cx, ax                                ; 89 c1                       ; 0xc10cd
    in AL, DX                                 ; ec                          ; 0xc10cf vgabios.c:700
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc10d0
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc10d2
    in AL, DX                                 ; ec                          ; 0xc10d5 vgabios.c:701
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc10d6
    xor ch, ch                                ; 30 ed                       ; 0xc10d8 vgabios.c:704
    imul cx, cx, strict byte 0004dh           ; 6b c9 4d                    ; 0xc10da
    mov word [bp-00ah], cx                    ; 89 4e f6                    ; 0xc10dd
    movzx cx, byte [bp-00ch]                  ; 0f b6 4e f4                 ; 0xc10e0
    imul cx, cx, 00097h                       ; 69 c9 97 00                 ; 0xc10e4
    add cx, word [bp-00ah]                    ; 03 4e f6                    ; 0xc10e8
    xor ah, ah                                ; 30 e4                       ; 0xc10eb
    imul ax, ax, strict byte 0001ch           ; 6b c0 1c                    ; 0xc10ed
    add cx, ax                                ; 01 c1                       ; 0xc10f0
    add cx, 00080h                            ; 81 c1 80 00                 ; 0xc10f2
    sar cx, 008h                              ; c1 f9 08                    ; 0xc10f6
    cmp cx, strict byte 0003fh                ; 83 f9 3f                    ; 0xc10f9 vgabios.c:706
    jbe short 01101h                          ; 76 03                       ; 0xc10fc
    mov cx, strict word 0003fh                ; b9 3f 00                    ; 0xc10fe
    mov al, bl                                ; 88 d8                       ; 0xc1101 vgabios.c:709
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc1103
    out DX, AL                                ; ee                          ; 0xc1106
    mov al, cl                                ; 88 c8                       ; 0xc1107 vgabios.c:711
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc1109
    out DX, AL                                ; ee                          ; 0xc110c
    out DX, AL                                ; ee                          ; 0xc110d vgabios.c:712
    out DX, AL                                ; ee                          ; 0xc110e vgabios.c:713
    inc bx                                    ; 43                          ; 0xc110f vgabios.c:714
    inc si                                    ; 46                          ; 0xc1110 vgabios.c:715
    jmp short 010bdh                          ; eb aa                       ; 0xc1111
    mov dx, 003dah                            ; ba da 03                    ; 0xc1113 vgabios.c:716
    in AL, DX                                 ; ec                          ; 0xc1116
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1117
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc1119 vgabios.c:717
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc111b
    out DX, AL                                ; ee                          ; 0xc111e
    mov dx, 003dah                            ; ba da 03                    ; 0xc111f vgabios.c:719
    in AL, DX                                 ; ec                          ; 0xc1122
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1123
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc1125 vgabios.c:721
    pop di                                    ; 5f                          ; 0xc1128
    pop si                                    ; 5e                          ; 0xc1129
    pop cx                                    ; 59                          ; 0xc112a
    pop bx                                    ; 5b                          ; 0xc112b
    pop bp                                    ; 5d                          ; 0xc112c
    retn                                      ; c3                          ; 0xc112d
  ; disGetNextSymbol 0xc112e LB 0x3116 -> off=0x0 cb=00000000000000f6 uValue=00000000000c112e 'biosfn_set_cursor_shape'
biosfn_set_cursor_shape:                     ; 0xc112e LB 0xf6
    push bp                                   ; 55                          ; 0xc112e vgabios.c:724
    mov bp, sp                                ; 89 e5                       ; 0xc112f
    push bx                                   ; 53                          ; 0xc1131
    push cx                                   ; 51                          ; 0xc1132
    push si                                   ; 56                          ; 0xc1133
    push di                                   ; 57                          ; 0xc1134
    push ax                                   ; 50                          ; 0xc1135
    mov bl, al                                ; 88 c3                       ; 0xc1136
    mov ah, dl                                ; 88 d4                       ; 0xc1138
    movzx cx, al                              ; 0f b6 c8                    ; 0xc113a vgabios.c:730
    sal cx, 008h                              ; c1 e1 08                    ; 0xc113d
    movzx dx, ah                              ; 0f b6 d4                    ; 0xc1140
    add dx, cx                                ; 01 ca                       ; 0xc1143
    mov si, strict word 00060h                ; be 60 00                    ; 0xc1145 vgabios.c:62
    mov cx, strict word 00040h                ; b9 40 00                    ; 0xc1148
    mov es, cx                                ; 8e c1                       ; 0xc114b
    mov word [es:si], dx                      ; 26 89 14                    ; 0xc114d
    mov si, 00087h                            ; be 87 00                    ; 0xc1150 vgabios.c:47
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc1153
    test dl, 008h                             ; f6 c2 08                    ; 0xc1156 vgabios.c:48
    jne near 011f9h                           ; 0f 85 9c 00                 ; 0xc1159
    mov dl, al                                ; 88 c2                       ; 0xc115d vgabios.c:736
    and dl, 060h                              ; 80 e2 60                    ; 0xc115f
    cmp dl, 020h                              ; 80 fa 20                    ; 0xc1162
    jne short 0116eh                          ; 75 07                       ; 0xc1165
    mov BL, strict byte 01eh                  ; b3 1e                       ; 0xc1167 vgabios.c:738
    xor ah, ah                                ; 30 e4                       ; 0xc1169 vgabios.c:739
    jmp near 011f9h                           ; e9 8b 00                    ; 0xc116b vgabios.c:740
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc116e vgabios.c:47
    test dl, 001h                             ; f6 c2 01                    ; 0xc1171 vgabios.c:48
    jne near 011f9h                           ; 0f 85 81 00                 ; 0xc1174
    cmp bl, 020h                              ; 80 fb 20                    ; 0xc1178
    jnc near 011f9h                           ; 0f 83 7a 00                 ; 0xc117b
    cmp ah, 020h                              ; 80 fc 20                    ; 0xc117f
    jnc near 011f9h                           ; 0f 83 73 00                 ; 0xc1182
    mov si, 00085h                            ; be 85 00                    ; 0xc1186 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1189
    mov es, dx                                ; 8e c2                       ; 0xc118c
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc118e
    mov dx, cx                                ; 89 ca                       ; 0xc1191 vgabios.c:58
    cmp ah, bl                                ; 38 dc                       ; 0xc1193 vgabios.c:751
    jnc short 011a3h                          ; 73 0c                       ; 0xc1195
    test ah, ah                               ; 84 e4                       ; 0xc1197 vgabios.c:753
    je short 011f9h                           ; 74 5e                       ; 0xc1199
    xor bl, bl                                ; 30 db                       ; 0xc119b vgabios.c:754
    mov ah, cl                                ; 88 cc                       ; 0xc119d vgabios.c:755
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc119f
    jmp short 011f9h                          ; eb 56                       ; 0xc11a1 vgabios.c:757
    movzx si, ah                              ; 0f b6 f4                    ; 0xc11a3 vgabios.c:758
    mov word [bp-00ah], si                    ; 89 76 f6                    ; 0xc11a6
    movzx si, bl                              ; 0f b6 f3                    ; 0xc11a9
    or si, word [bp-00ah]                     ; 0b 76 f6                    ; 0xc11ac
    cmp si, cx                                ; 39 ce                       ; 0xc11af
    jnc short 011c6h                          ; 73 13                       ; 0xc11b1
    movzx di, ah                              ; 0f b6 fc                    ; 0xc11b3
    mov si, cx                                ; 89 ce                       ; 0xc11b6
    dec si                                    ; 4e                          ; 0xc11b8
    cmp di, si                                ; 39 f7                       ; 0xc11b9
    je short 011f9h                           ; 74 3c                       ; 0xc11bb
    movzx si, bl                              ; 0f b6 f3                    ; 0xc11bd
    dec cx                                    ; 49                          ; 0xc11c0
    dec cx                                    ; 49                          ; 0xc11c1
    cmp si, cx                                ; 39 ce                       ; 0xc11c2
    je short 011f9h                           ; 74 33                       ; 0xc11c4
    cmp ah, 003h                              ; 80 fc 03                    ; 0xc11c6 vgabios.c:760
    jbe short 011f9h                          ; 76 2e                       ; 0xc11c9
    movzx si, bl                              ; 0f b6 f3                    ; 0xc11cb vgabios.c:761
    movzx di, ah                              ; 0f b6 fc                    ; 0xc11ce
    inc si                                    ; 46                          ; 0xc11d1
    inc si                                    ; 46                          ; 0xc11d2
    mov cl, dl                                ; 88 d1                       ; 0xc11d3
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc11d5
    cmp di, si                                ; 39 f7                       ; 0xc11d7
    jnle short 011eeh                         ; 7f 13                       ; 0xc11d9
    sub bl, ah                                ; 28 e3                       ; 0xc11db vgabios.c:763
    add bl, dl                                ; 00 d3                       ; 0xc11dd
    db  0feh, 0cbh
    ; dec bl                                    ; fe cb                     ; 0xc11df
    mov ah, cl                                ; 88 cc                       ; 0xc11e1 vgabios.c:764
    cmp dx, strict byte 0000eh                ; 83 fa 0e                    ; 0xc11e3 vgabios.c:765
    jc short 011f9h                           ; 72 11                       ; 0xc11e6
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc11e8 vgabios.c:767
    db  0feh, 0cbh
    ; dec bl                                    ; fe cb                     ; 0xc11ea vgabios.c:768
    jmp short 011f9h                          ; eb 0b                       ; 0xc11ec vgabios.c:770
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc11ee
    jbe short 011f7h                          ; 76 04                       ; 0xc11f1
    shr dx, 1                                 ; d1 ea                       ; 0xc11f3 vgabios.c:772
    mov bl, dl                                ; 88 d3                       ; 0xc11f5
    mov ah, cl                                ; 88 cc                       ; 0xc11f7 vgabios.c:776
    mov si, strict word 00063h                ; be 63 00                    ; 0xc11f9 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc11fc
    mov es, dx                                ; 8e c2                       ; 0xc11ff
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc1201
    mov AL, strict byte 00ah                  ; b0 0a                       ; 0xc1204 vgabios.c:787
    mov dx, cx                                ; 89 ca                       ; 0xc1206
    out DX, AL                                ; ee                          ; 0xc1208
    mov si, cx                                ; 89 ce                       ; 0xc1209 vgabios.c:788
    inc si                                    ; 46                          ; 0xc120b
    mov al, bl                                ; 88 d8                       ; 0xc120c
    mov dx, si                                ; 89 f2                       ; 0xc120e
    out DX, AL                                ; ee                          ; 0xc1210
    mov AL, strict byte 00bh                  ; b0 0b                       ; 0xc1211 vgabios.c:789
    mov dx, cx                                ; 89 ca                       ; 0xc1213
    out DX, AL                                ; ee                          ; 0xc1215
    mov al, ah                                ; 88 e0                       ; 0xc1216 vgabios.c:790
    mov dx, si                                ; 89 f2                       ; 0xc1218
    out DX, AL                                ; ee                          ; 0xc121a
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc121b vgabios.c:791
    pop di                                    ; 5f                          ; 0xc121e
    pop si                                    ; 5e                          ; 0xc121f
    pop cx                                    ; 59                          ; 0xc1220
    pop bx                                    ; 5b                          ; 0xc1221
    pop bp                                    ; 5d                          ; 0xc1222
    retn                                      ; c3                          ; 0xc1223
  ; disGetNextSymbol 0xc1224 LB 0x3020 -> off=0x0 cb=0000000000000071 uValue=00000000000c1224 'biosfn_set_cursor_pos'
biosfn_set_cursor_pos:                       ; 0xc1224 LB 0x71
    push bp                                   ; 55                          ; 0xc1224 vgabios.c:794
    mov bp, sp                                ; 89 e5                       ; 0xc1225
    push bx                                   ; 53                          ; 0xc1227
    push cx                                   ; 51                          ; 0xc1228
    push si                                   ; 56                          ; 0xc1229
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc122a vgabios.c:800
    jnbe short 0128dh                         ; 77 5f                       ; 0xc122c
    movzx bx, al                              ; 0f b6 d8                    ; 0xc122e vgabios.c:803
    add bx, bx                                ; 01 db                       ; 0xc1231
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc1233
    mov cx, strict word 00040h                ; b9 40 00                    ; 0xc1236 vgabios.c:62
    mov es, cx                                ; 8e c1                       ; 0xc1239
    mov word [es:bx], dx                      ; 26 89 17                    ; 0xc123b
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc123e vgabios.c:47
    mov ah, byte [es:bx]                      ; 26 8a 27                    ; 0xc1241
    cmp al, ah                                ; 38 e0                       ; 0xc1244 vgabios.c:807
    jne short 0128dh                          ; 75 45                       ; 0xc1246
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc1248 vgabios.c:57
    mov si, word [es:bx]                      ; 26 8b 37                    ; 0xc124b
    mov ax, dx                                ; 89 d0                       ; 0xc124e vgabios.c:812
    xor al, dl                                ; 30 d0                       ; 0xc1250
    shr ax, 008h                              ; c1 e8 08                    ; 0xc1252
    mov bx, strict word 0004eh                ; bb 4e 00                    ; 0xc1255 vgabios.c:57
    mov cx, word [es:bx]                      ; 26 8b 0f                    ; 0xc1258
    shr cx, 1                                 ; d1 e9                       ; 0xc125b vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc125d vgabios.c:817
    imul si, ax                               ; 0f af f0                    ; 0xc125f
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc1262
    add ax, si                                ; 01 f0                       ; 0xc1265
    add cx, ax                                ; 01 c1                       ; 0xc1267
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc1269 vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc126c
    mov AL, strict byte 00eh                  ; b0 0e                       ; 0xc126f vgabios.c:821
    mov dx, bx                                ; 89 da                       ; 0xc1271
    out DX, AL                                ; ee                          ; 0xc1273
    mov ax, cx                                ; 89 c8                       ; 0xc1274 vgabios.c:822
    xor al, cl                                ; 30 c8                       ; 0xc1276
    shr ax, 008h                              ; c1 e8 08                    ; 0xc1278
    lea si, [bx+001h]                         ; 8d 77 01                    ; 0xc127b
    mov dx, si                                ; 89 f2                       ; 0xc127e
    out DX, AL                                ; ee                          ; 0xc1280
    mov AL, strict byte 00fh                  ; b0 0f                       ; 0xc1281 vgabios.c:823
    mov dx, bx                                ; 89 da                       ; 0xc1283
    out DX, AL                                ; ee                          ; 0xc1285
    xor ch, ch                                ; 30 ed                       ; 0xc1286 vgabios.c:824
    mov ax, cx                                ; 89 c8                       ; 0xc1288
    mov dx, si                                ; 89 f2                       ; 0xc128a
    out DX, AL                                ; ee                          ; 0xc128c
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc128d vgabios.c:826
    pop si                                    ; 5e                          ; 0xc1290
    pop cx                                    ; 59                          ; 0xc1291
    pop bx                                    ; 5b                          ; 0xc1292
    pop bp                                    ; 5d                          ; 0xc1293
    retn                                      ; c3                          ; 0xc1294
  ; disGetNextSymbol 0xc1295 LB 0x2faf -> off=0x0 cb=000000000000009b uValue=00000000000c1295 'biosfn_set_active_page'
biosfn_set_active_page:                      ; 0xc1295 LB 0x9b
    push bp                                   ; 55                          ; 0xc1295 vgabios.c:829
    mov bp, sp                                ; 89 e5                       ; 0xc1296
    push bx                                   ; 53                          ; 0xc1298
    push cx                                   ; 51                          ; 0xc1299
    push dx                                   ; 52                          ; 0xc129a
    push si                                   ; 56                          ; 0xc129b
    push di                                   ; 57                          ; 0xc129c
    push ax                                   ; 50                          ; 0xc129d
    push ax                                   ; 50                          ; 0xc129e
    mov bl, al                                ; 88 c3                       ; 0xc129f
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc12a1 vgabios.c:835
    jnbe near 01326h                          ; 0f 87 7f 00                 ; 0xc12a3
    mov si, strict word 00049h                ; be 49 00                    ; 0xc12a7 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc12aa
    mov es, ax                                ; 8e c0                       ; 0xc12ad
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc12af
    xor ah, ah                                ; 30 e4                       ; 0xc12b2 vgabios.c:839
    call 0356fh                               ; e8 b8 22                    ; 0xc12b4
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc12b7 vgabios.c:840
    je short 01326h                           ; 74 6b                       ; 0xc12b9
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc12bb vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc12be
    mov es, dx                                ; 8e c2                       ; 0xc12c1
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc12c3
    movzx cx, bl                              ; 0f b6 cb                    ; 0xc12c6 vgabios.c:58
    imul cx, dx                               ; 0f af ca                    ; 0xc12c9
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc12cc vgabios.c:62
    mov word [es:si], cx                      ; 26 89 0c                    ; 0xc12cf
    movzx si, al                              ; 0f b6 f0                    ; 0xc12d2 vgabios.c:845
    sal si, 003h                              ; c1 e6 03                    ; 0xc12d5
    cmp byte [si+047adh], 000h                ; 80 bc ad 47 00              ; 0xc12d8
    jne short 012e1h                          ; 75 02                       ; 0xc12dd
    shr cx, 1                                 ; d1 e9                       ; 0xc12df vgabios.c:846
    mov si, strict word 00063h                ; be 63 00                    ; 0xc12e1 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc12e4
    mov es, ax                                ; 8e c0                       ; 0xc12e7
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc12e9
    mov AL, strict byte 00ch                  ; b0 0c                       ; 0xc12ec vgabios.c:850
    mov dx, si                                ; 89 f2                       ; 0xc12ee
    out DX, AL                                ; ee                          ; 0xc12f0
    mov ax, cx                                ; 89 c8                       ; 0xc12f1 vgabios.c:851
    xor al, cl                                ; 30 c8                       ; 0xc12f3
    shr ax, 008h                              ; c1 e8 08                    ; 0xc12f5
    lea di, [si+001h]                         ; 8d 7c 01                    ; 0xc12f8
    mov dx, di                                ; 89 fa                       ; 0xc12fb
    out DX, AL                                ; ee                          ; 0xc12fd
    mov AL, strict byte 00dh                  ; b0 0d                       ; 0xc12fe vgabios.c:852
    mov dx, si                                ; 89 f2                       ; 0xc1300
    out DX, AL                                ; ee                          ; 0xc1302
    xor ch, ch                                ; 30 ed                       ; 0xc1303 vgabios.c:853
    mov ax, cx                                ; 89 c8                       ; 0xc1305
    mov dx, di                                ; 89 fa                       ; 0xc1307
    out DX, AL                                ; ee                          ; 0xc1309
    mov si, strict word 00062h                ; be 62 00                    ; 0xc130a vgabios.c:52
    mov byte [es:si], bl                      ; 26 88 1c                    ; 0xc130d
    movzx cx, bl                              ; 0f b6 cb                    ; 0xc1310 vgabios.c:863
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc1313
    lea dx, [bp-00ch]                         ; 8d 56 f4                    ; 0xc1316
    mov ax, cx                                ; 89 c8                       ; 0xc1319
    call 00a93h                               ; e8 75 f7                    ; 0xc131b
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc131e vgabios.c:865
    mov ax, cx                                ; 89 c8                       ; 0xc1321
    call 01224h                               ; e8 fe fe                    ; 0xc1323
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc1326 vgabios.c:866
    pop di                                    ; 5f                          ; 0xc1329
    pop si                                    ; 5e                          ; 0xc132a
    pop dx                                    ; 5a                          ; 0xc132b
    pop cx                                    ; 59                          ; 0xc132c
    pop bx                                    ; 5b                          ; 0xc132d
    pop bp                                    ; 5d                          ; 0xc132e
    retn                                      ; c3                          ; 0xc132f
  ; disGetNextSymbol 0xc1330 LB 0x2f14 -> off=0x0 cb=0000000000000045 uValue=00000000000c1330 'find_vpti'
find_vpti:                                   ; 0xc1330 LB 0x45
    push bx                                   ; 53                          ; 0xc1330 vgabios.c:901
    push si                                   ; 56                          ; 0xc1331
    push bp                                   ; 55                          ; 0xc1332
    mov bp, sp                                ; 89 e5                       ; 0xc1333
    movzx bx, al                              ; 0f b6 d8                    ; 0xc1335 vgabios.c:906
    mov si, bx                                ; 89 de                       ; 0xc1338
    sal si, 003h                              ; c1 e6 03                    ; 0xc133a
    cmp byte [si+047adh], 000h                ; 80 bc ad 47 00              ; 0xc133d
    jne short 0136ch                          ; 75 28                       ; 0xc1342
    mov si, 00089h                            ; be 89 00                    ; 0xc1344 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1347
    mov es, ax                                ; 8e c0                       ; 0xc134a
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc134c
    test AL, strict byte 010h                 ; a8 10                       ; 0xc134f vgabios.c:908
    je short 0135ah                           ; 74 07                       ; 0xc1351
    movsx ax, byte [bx+07df3h]                ; 0f be 87 f3 7d              ; 0xc1353 vgabios.c:909
    jmp short 01371h                          ; eb 17                       ; 0xc1358 vgabios.c:910
    test AL, strict byte 080h                 ; a8 80                       ; 0xc135a
    je short 01365h                           ; 74 07                       ; 0xc135c
    movsx ax, byte [bx+07de3h]                ; 0f be 87 e3 7d              ; 0xc135e vgabios.c:911
    jmp short 01371h                          ; eb 0c                       ; 0xc1363 vgabios.c:912
    movsx ax, byte [bx+07debh]                ; 0f be 87 eb 7d              ; 0xc1365 vgabios.c:913
    jmp short 01371h                          ; eb 05                       ; 0xc136a vgabios.c:914
    movzx ax, byte [bx+0482ch]                ; 0f b6 87 2c 48              ; 0xc136c vgabios.c:915
    pop bp                                    ; 5d                          ; 0xc1371 vgabios.c:918
    pop si                                    ; 5e                          ; 0xc1372
    pop bx                                    ; 5b                          ; 0xc1373
    retn                                      ; c3                          ; 0xc1374
  ; disGetNextSymbol 0xc1375 LB 0x2ecf -> off=0x0 cb=00000000000004bb uValue=00000000000c1375 'biosfn_set_video_mode'
biosfn_set_video_mode:                       ; 0xc1375 LB 0x4bb
    push bp                                   ; 55                          ; 0xc1375 vgabios.c:923
    mov bp, sp                                ; 89 e5                       ; 0xc1376
    push bx                                   ; 53                          ; 0xc1378
    push cx                                   ; 51                          ; 0xc1379
    push dx                                   ; 52                          ; 0xc137a
    push si                                   ; 56                          ; 0xc137b
    push di                                   ; 57                          ; 0xc137c
    sub sp, strict byte 00016h                ; 83 ec 16                    ; 0xc137d
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc1380
    and AL, strict byte 080h                  ; 24 80                       ; 0xc1383 vgabios.c:927
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc1385
    call 007c8h                               ; e8 3d f4                    ; 0xc1388 vgabios.c:937
    test ax, ax                               ; 85 c0                       ; 0xc138b
    je short 0139bh                           ; 74 0c                       ; 0xc138d
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc138f vgabios.c:939
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc1391
    out DX, AL                                ; ee                          ; 0xc1394
    xor al, al                                ; 30 c0                       ; 0xc1395 vgabios.c:940
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc1397
    out DX, AL                                ; ee                          ; 0xc139a
    and byte [bp-010h], 07fh                  ; 80 66 f0 7f                 ; 0xc139b vgabios.c:945
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc139f vgabios.c:951
    call 0356fh                               ; e8 c9 21                    ; 0xc13a3
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc13a6
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc13a9 vgabios.c:957
    je near 01826h                            ; 0f 84 77 04                 ; 0xc13ab
    mov bx, 000a8h                            ; bb a8 00                    ; 0xc13af vgabios.c:67
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc13b2
    mov es, dx                                ; 8e c2                       ; 0xc13b5
    mov di, word [es:bx]                      ; 26 8b 3f                    ; 0xc13b7
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc13ba
    mov bx, di                                ; 89 fb                       ; 0xc13be vgabios.c:68
    mov word [bp-01ch], dx                    ; 89 56 e4                    ; 0xc13c0
    movzx cx, al                              ; 0f b6 c8                    ; 0xc13c3 vgabios.c:963
    mov ax, cx                                ; 89 c8                       ; 0xc13c6
    call 01330h                               ; e8 65 ff                    ; 0xc13c8
    mov es, dx                                ; 8e c2                       ; 0xc13cb vgabios.c:964
    mov si, word [es:di]                      ; 26 8b 35                    ; 0xc13cd
    mov dx, word [es:di+002h]                 ; 26 8b 55 02                 ; 0xc13d0
    mov word [bp-012h], dx                    ; 89 56 ee                    ; 0xc13d4
    xor ah, ah                                ; 30 e4                       ; 0xc13d7 vgabios.c:965
    sal ax, 006h                              ; c1 e0 06                    ; 0xc13d9
    add si, ax                                ; 01 c6                       ; 0xc13dc
    mov di, 00089h                            ; bf 89 00                    ; 0xc13de vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc13e1
    mov es, ax                                ; 8e c0                       ; 0xc13e4
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc13e6
    mov ah, al                                ; 88 c4                       ; 0xc13e9 vgabios.c:48
    test AL, strict byte 008h                 ; a8 08                       ; 0xc13eb vgabios.c:982
    jne near 01524h                           ; 0f 85 33 01                 ; 0xc13ed
    mov di, cx                                ; 89 cf                       ; 0xc13f1 vgabios.c:984
    sal di, 003h                              ; c1 e7 03                    ; 0xc13f3
    mov al, byte [di+047b2h]                  ; 8a 85 b2 47                 ; 0xc13f6
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc13fa
    out DX, AL                                ; ee                          ; 0xc13fd
    xor al, al                                ; 30 c0                       ; 0xc13fe vgabios.c:987
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc1400
    out DX, AL                                ; ee                          ; 0xc1403
    mov cl, byte [di+047b3h]                  ; 8a 8d b3 47                 ; 0xc1404 vgabios.c:990
    cmp cl, 001h                              ; 80 f9 01                    ; 0xc1408
    jc short 0141bh                           ; 72 0e                       ; 0xc140b
    jbe short 01426h                          ; 76 17                       ; 0xc140d
    cmp cl, 003h                              ; 80 f9 03                    ; 0xc140f
    je short 01434h                           ; 74 20                       ; 0xc1412
    cmp cl, 002h                              ; 80 f9 02                    ; 0xc1414
    je short 0142dh                           ; 74 14                       ; 0xc1417
    jmp short 01439h                          ; eb 1e                       ; 0xc1419
    test cl, cl                               ; 84 c9                       ; 0xc141b
    jne short 01439h                          ; 75 1a                       ; 0xc141d
    mov word [bp-016h], 04fc0h                ; c7 46 ea c0 4f              ; 0xc141f vgabios.c:992
    jmp short 01439h                          ; eb 13                       ; 0xc1424 vgabios.c:993
    mov word [bp-016h], 05080h                ; c7 46 ea 80 50              ; 0xc1426 vgabios.c:995
    jmp short 01439h                          ; eb 0c                       ; 0xc142b vgabios.c:996
    mov word [bp-016h], 05140h                ; c7 46 ea 40 51              ; 0xc142d vgabios.c:998
    jmp short 01439h                          ; eb 05                       ; 0xc1432 vgabios.c:999
    mov word [bp-016h], 05200h                ; c7 46 ea 00 52              ; 0xc1434 vgabios.c:1001
    movzx di, byte [bp-00eh]                  ; 0f b6 7e f2                 ; 0xc1439 vgabios.c:1005
    sal di, 003h                              ; c1 e7 03                    ; 0xc143d
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc1440
    jne short 01456h                          ; 75 0f                       ; 0xc1445
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1447 vgabios.c:1007
    cmp byte [es:si+002h], 008h               ; 26 80 7c 02 08              ; 0xc144a
    jne short 01456h                          ; 75 05                       ; 0xc144f
    mov word [bp-016h], 05080h                ; c7 46 ea 80 50              ; 0xc1451 vgabios.c:1008
    xor cx, cx                                ; 31 c9                       ; 0xc1456 vgabios.c:1011
    jmp short 01469h                          ; eb 0f                       ; 0xc1458
    xor al, al                                ; 30 c0                       ; 0xc145a vgabios.c:1018
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc145c
    out DX, AL                                ; ee                          ; 0xc145f
    out DX, AL                                ; ee                          ; 0xc1460 vgabios.c:1019
    out DX, AL                                ; ee                          ; 0xc1461 vgabios.c:1020
    inc cx                                    ; 41                          ; 0xc1462 vgabios.c:1022
    cmp cx, 00100h                            ; 81 f9 00 01                 ; 0xc1463
    jnc short 01494h                          ; 73 2b                       ; 0xc1467
    movzx di, byte [bp-00eh]                  ; 0f b6 7e f2                 ; 0xc1469
    sal di, 003h                              ; c1 e7 03                    ; 0xc146d
    movzx di, byte [di+047b3h]                ; 0f b6 bd b3 47              ; 0xc1470
    movzx dx, byte [di+0483ch]                ; 0f b6 95 3c 48              ; 0xc1475
    cmp cx, dx                                ; 39 d1                       ; 0xc147a
    jnbe short 0145ah                         ; 77 dc                       ; 0xc147c
    imul di, cx, strict byte 00003h           ; 6b f9 03                    ; 0xc147e
    add di, word [bp-016h]                    ; 03 7e ea                    ; 0xc1481
    mov al, byte [di]                         ; 8a 05                       ; 0xc1484
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc1486
    out DX, AL                                ; ee                          ; 0xc1489
    mov al, byte [di+001h]                    ; 8a 45 01                    ; 0xc148a
    out DX, AL                                ; ee                          ; 0xc148d
    mov al, byte [di+002h]                    ; 8a 45 02                    ; 0xc148e
    out DX, AL                                ; ee                          ; 0xc1491
    jmp short 01462h                          ; eb ce                       ; 0xc1492
    test ah, 002h                             ; f6 c4 02                    ; 0xc1494 vgabios.c:1023
    je short 014a1h                           ; 74 08                       ; 0xc1497
    mov dx, 00100h                            ; ba 00 01                    ; 0xc1499 vgabios.c:1025
    xor ax, ax                                ; 31 c0                       ; 0xc149c
    call 010a2h                               ; e8 01 fc                    ; 0xc149e
    mov dx, 003dah                            ; ba da 03                    ; 0xc14a1 vgabios.c:1029
    in AL, DX                                 ; ec                          ; 0xc14a4
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc14a5
    xor cx, cx                                ; 31 c9                       ; 0xc14a7 vgabios.c:1032
    jmp short 014b0h                          ; eb 05                       ; 0xc14a9
    cmp cx, strict byte 00013h                ; 83 f9 13                    ; 0xc14ab
    jnbe short 014c5h                         ; 77 15                       ; 0xc14ae
    mov al, cl                                ; 88 c8                       ; 0xc14b0 vgabios.c:1033
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc14b2
    out DX, AL                                ; ee                          ; 0xc14b5
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc14b6 vgabios.c:1034
    mov di, si                                ; 89 f7                       ; 0xc14b9
    add di, cx                                ; 01 cf                       ; 0xc14bb
    mov al, byte [es:di+023h]                 ; 26 8a 45 23                 ; 0xc14bd
    out DX, AL                                ; ee                          ; 0xc14c1
    inc cx                                    ; 41                          ; 0xc14c2 vgabios.c:1035
    jmp short 014abh                          ; eb e6                       ; 0xc14c3
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc14c5 vgabios.c:1036
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc14c7
    out DX, AL                                ; ee                          ; 0xc14ca
    xor al, al                                ; 30 c0                       ; 0xc14cb vgabios.c:1037
    out DX, AL                                ; ee                          ; 0xc14cd
    mov es, [bp-01ch]                         ; 8e 46 e4                    ; 0xc14ce vgabios.c:1040
    mov ax, word [es:bx+004h]                 ; 26 8b 47 04                 ; 0xc14d1
    mov dx, word [es:bx+006h]                 ; 26 8b 57 06                 ; 0xc14d5
    test dx, dx                               ; 85 d2                       ; 0xc14d9
    jne short 014e1h                          ; 75 04                       ; 0xc14db
    test ax, ax                               ; 85 c0                       ; 0xc14dd
    je short 01524h                           ; 74 43                       ; 0xc14df
    mov dx, ax                                ; 89 c2                       ; 0xc14e1 vgabios.c:1044
    mov ax, word [es:bx+006h]                 ; 26 8b 47 06                 ; 0xc14e3
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc14e7
    xor cx, cx                                ; 31 c9                       ; 0xc14ea vgabios.c:1045
    jmp short 014f3h                          ; eb 05                       ; 0xc14ec
    cmp cx, strict byte 00010h                ; 83 f9 10                    ; 0xc14ee
    jnc short 01514h                          ; 73 21                       ; 0xc14f1
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc14f3 vgabios.c:1046
    mov di, si                                ; 89 f7                       ; 0xc14f6
    add di, cx                                ; 01 cf                       ; 0xc14f8
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc14fa
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc14fd
    mov ax, dx                                ; 89 d0                       ; 0xc1500
    add ax, cx                                ; 01 c8                       ; 0xc1502
    mov word [bp-020h], ax                    ; 89 46 e0                    ; 0xc1504
    mov al, byte [es:di+023h]                 ; 26 8a 45 23                 ; 0xc1507
    les di, [bp-020h]                         ; c4 7e e0                    ; 0xc150b
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc150e
    inc cx                                    ; 41                          ; 0xc1511
    jmp short 014eeh                          ; eb da                       ; 0xc1512
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1514 vgabios.c:1047
    mov al, byte [es:si+034h]                 ; 26 8a 44 34                 ; 0xc1517
    mov es, [bp-01ah]                         ; 8e 46 e6                    ; 0xc151b
    mov di, dx                                ; 89 d7                       ; 0xc151e
    mov byte [es:di+010h], al                 ; 26 88 45 10                 ; 0xc1520
    xor al, al                                ; 30 c0                       ; 0xc1524 vgabios.c:1052
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc1526
    out DX, AL                                ; ee                          ; 0xc1529
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc152a vgabios.c:1053
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc152c
    out DX, AL                                ; ee                          ; 0xc152f
    mov cx, strict word 00001h                ; b9 01 00                    ; 0xc1530 vgabios.c:1054
    jmp short 0153ah                          ; eb 05                       ; 0xc1533
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc1535
    jnbe short 01552h                         ; 77 18                       ; 0xc1538
    mov al, cl                                ; 88 c8                       ; 0xc153a vgabios.c:1055
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc153c
    out DX, AL                                ; ee                          ; 0xc153f
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1540 vgabios.c:1056
    mov di, si                                ; 89 f7                       ; 0xc1543
    add di, cx                                ; 01 cf                       ; 0xc1545
    mov al, byte [es:di+004h]                 ; 26 8a 45 04                 ; 0xc1547
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc154b
    out DX, AL                                ; ee                          ; 0xc154e
    inc cx                                    ; 41                          ; 0xc154f vgabios.c:1057
    jmp short 01535h                          ; eb e3                       ; 0xc1550
    xor cx, cx                                ; 31 c9                       ; 0xc1552 vgabios.c:1060
    jmp short 0155bh                          ; eb 05                       ; 0xc1554
    cmp cx, strict byte 00008h                ; 83 f9 08                    ; 0xc1556
    jnbe short 01573h                         ; 77 18                       ; 0xc1559
    mov al, cl                                ; 88 c8                       ; 0xc155b vgabios.c:1061
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc155d
    out DX, AL                                ; ee                          ; 0xc1560
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1561 vgabios.c:1062
    mov di, si                                ; 89 f7                       ; 0xc1564
    add di, cx                                ; 01 cf                       ; 0xc1566
    mov al, byte [es:di+037h]                 ; 26 8a 45 37                 ; 0xc1568
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc156c
    out DX, AL                                ; ee                          ; 0xc156f
    inc cx                                    ; 41                          ; 0xc1570 vgabios.c:1063
    jmp short 01556h                          ; eb e3                       ; 0xc1571
    movzx di, byte [bp-00eh]                  ; 0f b6 7e f2                 ; 0xc1573 vgabios.c:1066
    sal di, 003h                              ; c1 e7 03                    ; 0xc1577
    cmp byte [di+047aeh], 001h                ; 80 bd ae 47 01              ; 0xc157a
    jne short 01586h                          ; 75 05                       ; 0xc157f
    mov cx, 003b4h                            ; b9 b4 03                    ; 0xc1581
    jmp short 01589h                          ; eb 03                       ; 0xc1584
    mov cx, 003d4h                            ; b9 d4 03                    ; 0xc1586
    mov word [bp-018h], cx                    ; 89 4e e8                    ; 0xc1589
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc158c vgabios.c:1069
    mov al, byte [es:si+009h]                 ; 26 8a 44 09                 ; 0xc158f
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc1593
    out DX, AL                                ; ee                          ; 0xc1596
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc1597 vgabios.c:1072
    mov dx, cx                                ; 89 ca                       ; 0xc159a
    out DX, ax                                ; ef                          ; 0xc159c
    xor cx, cx                                ; 31 c9                       ; 0xc159d vgabios.c:1074
    jmp short 015a6h                          ; eb 05                       ; 0xc159f
    cmp cx, strict byte 00018h                ; 83 f9 18                    ; 0xc15a1
    jnbe short 015bch                         ; 77 16                       ; 0xc15a4
    mov al, cl                                ; 88 c8                       ; 0xc15a6 vgabios.c:1075
    mov dx, word [bp-018h]                    ; 8b 56 e8                    ; 0xc15a8
    out DX, AL                                ; ee                          ; 0xc15ab
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc15ac vgabios.c:1076
    mov di, si                                ; 89 f7                       ; 0xc15af
    add di, cx                                ; 01 cf                       ; 0xc15b1
    inc dx                                    ; 42                          ; 0xc15b3
    mov al, byte [es:di+00ah]                 ; 26 8a 45 0a                 ; 0xc15b4
    out DX, AL                                ; ee                          ; 0xc15b8
    inc cx                                    ; 41                          ; 0xc15b9 vgabios.c:1077
    jmp short 015a1h                          ; eb e5                       ; 0xc15ba
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc15bc vgabios.c:1080
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc15be
    out DX, AL                                ; ee                          ; 0xc15c1
    mov dx, word [bp-018h]                    ; 8b 56 e8                    ; 0xc15c2 vgabios.c:1081
    add dx, strict byte 00006h                ; 83 c2 06                    ; 0xc15c5
    in AL, DX                                 ; ec                          ; 0xc15c8
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc15c9
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc15cb vgabios.c:1083
    jne short 0162dh                          ; 75 5c                       ; 0xc15cf
    movzx di, byte [bp-00eh]                  ; 0f b6 7e f2                 ; 0xc15d1 vgabios.c:1085
    sal di, 003h                              ; c1 e7 03                    ; 0xc15d5
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc15d8
    jne short 015f1h                          ; 75 12                       ; 0xc15dd
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc15df vgabios.c:1087
    mov cx, 04000h                            ; b9 00 40                    ; 0xc15e3
    mov ax, 00720h                            ; b8 20 07                    ; 0xc15e6
    xor di, di                                ; 31 ff                       ; 0xc15e9
    jcxz 015efh                               ; e3 02                       ; 0xc15eb
    rep stosw                                 ; f3 ab                       ; 0xc15ed
    jmp short 0162dh                          ; eb 3c                       ; 0xc15ef vgabios.c:1089
    cmp byte [bp-010h], 00dh                  ; 80 7e f0 0d                 ; 0xc15f1 vgabios.c:1091
    jnc short 01608h                          ; 73 11                       ; 0xc15f5
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc15f7 vgabios.c:1093
    mov cx, 04000h                            ; b9 00 40                    ; 0xc15fb
    xor ax, ax                                ; 31 c0                       ; 0xc15fe
    xor di, di                                ; 31 ff                       ; 0xc1600
    jcxz 01606h                               ; e3 02                       ; 0xc1602
    rep stosw                                 ; f3 ab                       ; 0xc1604
    jmp short 0162dh                          ; eb 25                       ; 0xc1606 vgabios.c:1095
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc1608 vgabios.c:1097
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc160a
    out DX, AL                                ; ee                          ; 0xc160d
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc160e vgabios.c:1098
    in AL, DX                                 ; ec                          ; 0xc1611
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1612
    mov word [bp-020h], ax                    ; 89 46 e0                    ; 0xc1614
    mov AL, strict byte 00fh                  ; b0 0f                       ; 0xc1617 vgabios.c:1099
    out DX, AL                                ; ee                          ; 0xc1619
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc161a vgabios.c:1100
    mov cx, 08000h                            ; b9 00 80                    ; 0xc161e
    xor ax, ax                                ; 31 c0                       ; 0xc1621
    xor di, di                                ; 31 ff                       ; 0xc1623
    jcxz 01629h                               ; e3 02                       ; 0xc1625
    rep stosw                                 ; f3 ab                       ; 0xc1627
    mov al, byte [bp-020h]                    ; 8a 46 e0                    ; 0xc1629 vgabios.c:1101
    out DX, AL                                ; ee                          ; 0xc162c
    mov di, strict word 00049h                ; bf 49 00                    ; 0xc162d vgabios.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1630
    mov es, ax                                ; 8e c0                       ; 0xc1633
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1635
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc1638
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc163b vgabios.c:1108
    movzx ax, byte [es:si]                    ; 26 0f b6 04                 ; 0xc163e
    mov di, strict word 0004ah                ; bf 4a 00                    ; 0xc1642 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1645
    mov es, dx                                ; 8e c2                       ; 0xc1648
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc164a
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc164d vgabios.c:60
    mov ax, word [es:si+003h]                 ; 26 8b 44 03                 ; 0xc1650
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc1654 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc1657
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc1659
    mov di, strict word 00063h                ; bf 63 00                    ; 0xc165c vgabios.c:62
    mov ax, word [bp-018h]                    ; 8b 46 e8                    ; 0xc165f
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc1662
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1665 vgabios.c:50
    mov al, byte [es:si+001h]                 ; 26 8a 44 01                 ; 0xc1668
    mov di, 00084h                            ; bf 84 00                    ; 0xc166c vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc166f
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc1671
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1674 vgabios.c:1112
    movzx ax, byte [es:si+002h]               ; 26 0f b6 44 02              ; 0xc1677
    mov di, 00085h                            ; bf 85 00                    ; 0xc167c vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc167f
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc1681
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1684 vgabios.c:1113
    movzx ax, byte [es:si+014h]               ; 26 0f b6 44 14              ; 0xc1687
    sal ax, 008h                              ; c1 e0 08                    ; 0xc168c
    movzx dx, byte [es:si+015h]               ; 26 0f b6 54 15              ; 0xc168f
    or ax, dx                                 ; 09 d0                       ; 0xc1694
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc1696 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1699
    mov es, dx                                ; 8e c2                       ; 0xc169c
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc169e
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc16a1 vgabios.c:1114
    or AL, strict byte 060h                   ; 0c 60                       ; 0xc16a4
    mov di, 00087h                            ; bf 87 00                    ; 0xc16a6 vgabios.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc16a9
    mov di, 00088h                            ; bf 88 00                    ; 0xc16ac vgabios.c:52
    mov byte [es:di], 0f9h                    ; 26 c6 05 f9                 ; 0xc16af
    mov di, 0008ah                            ; bf 8a 00                    ; 0xc16b3 vgabios.c:52
    mov byte [es:di], 008h                    ; 26 c6 05 08                 ; 0xc16b6
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc16ba vgabios.c:1120
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc16bd
    jnbe short 016e7h                         ; 77 26                       ; 0xc16bf
    movzx di, al                              ; 0f b6 f8                    ; 0xc16c1 vgabios.c:1122
    mov al, byte [di+07ddbh]                  ; 8a 85 db 7d                 ; 0xc16c4 vgabios.c:50
    mov di, strict word 00065h                ; bf 65 00                    ; 0xc16c8 vgabios.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc16cb
    cmp byte [bp-010h], 006h                  ; 80 7e f0 06                 ; 0xc16ce vgabios.c:1123
    jne short 016d9h                          ; 75 05                       ; 0xc16d2
    mov dx, strict word 0003fh                ; ba 3f 00                    ; 0xc16d4
    jmp short 016dch                          ; eb 03                       ; 0xc16d7
    mov dx, strict word 00030h                ; ba 30 00                    ; 0xc16d9
    mov di, strict word 00066h                ; bf 66 00                    ; 0xc16dc vgabios.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc16df
    mov es, ax                                ; 8e c0                       ; 0xc16e2
    mov byte [es:di], dl                      ; 26 88 15                    ; 0xc16e4
    xor cx, cx                                ; 31 c9                       ; 0xc16e7 vgabios.c:1128
    jmp short 016f0h                          ; eb 05                       ; 0xc16e9
    cmp cx, strict byte 00008h                ; 83 f9 08                    ; 0xc16eb
    jnc short 016fbh                          ; 73 0b                       ; 0xc16ee
    movzx ax, cl                              ; 0f b6 c1                    ; 0xc16f0 vgabios.c:1129
    xor dx, dx                                ; 31 d2                       ; 0xc16f3
    call 01224h                               ; e8 2c fb                    ; 0xc16f5
    inc cx                                    ; 41                          ; 0xc16f8
    jmp short 016ebh                          ; eb f0                       ; 0xc16f9
    xor ax, ax                                ; 31 c0                       ; 0xc16fb vgabios.c:1132
    call 01295h                               ; e8 95 fb                    ; 0xc16fd
    movzx di, byte [bp-00eh]                  ; 0f b6 7e f2                 ; 0xc1700 vgabios.c:1135
    sal di, 003h                              ; c1 e7 03                    ; 0xc1704
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc1707
    jne near 017f1h                           ; 0f 85 e1 00                 ; 0xc170c
    mov es, [bp-01ch]                         ; 8e 46 e4                    ; 0xc1710 vgabios.c:1137
    mov di, word [es:bx+008h]                 ; 26 8b 7f 08                 ; 0xc1713
    mov ax, word [es:bx+00ah]                 ; 26 8b 47 0a                 ; 0xc1717
    mov word [bp-014h], ax                    ; 89 46 ec                    ; 0xc171b
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc171e vgabios.c:1139
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc1721
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc1725
    je short 01749h                           ; 74 20                       ; 0xc1727
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc1729
    jne short 01773h                          ; 75 46                       ; 0xc172b
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc172d vgabios.c:1141
    movzx ax, byte [es:si+002h]               ; 26 0f b6 44 02              ; 0xc1730
    push ax                                   ; 50                          ; 0xc1735
    push dword 000000000h                     ; 66 6a 00                    ; 0xc1736
    mov cx, 00100h                            ; b9 00 01                    ; 0xc1739
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc173c
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc173f
    xor ax, ax                                ; 31 c0                       ; 0xc1742
    call 02b8ch                               ; e8 45 14                    ; 0xc1744
    jmp short 01795h                          ; eb 4c                       ; 0xc1747 vgabios.c:1142
    xor ah, ah                                ; 30 e4                       ; 0xc1749 vgabios.c:1144
    push ax                                   ; 50                          ; 0xc174b
    push dword 000000000h                     ; 66 6a 00                    ; 0xc174c
    mov cx, 00100h                            ; b9 00 01                    ; 0xc174f
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc1752
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc1755
    xor al, al                                ; 30 c0                       ; 0xc1758
    call 02b8ch                               ; e8 2f 14                    ; 0xc175a
    cmp byte [bp-010h], 007h                  ; 80 7e f0 07                 ; 0xc175d vgabios.c:1145
    jne short 01795h                          ; 75 32                       ; 0xc1761
    mov cx, strict word 0000eh                ; b9 0e 00                    ; 0xc1763 vgabios.c:1146
    xor bx, bx                                ; 31 db                       ; 0xc1766
    mov dx, 07b6ah                            ; ba 6a 7b                    ; 0xc1768
    mov ax, 0c000h                            ; b8 00 c0                    ; 0xc176b
    call 02b17h                               ; e8 a6 13                    ; 0xc176e
    jmp short 01795h                          ; eb 22                       ; 0xc1771 vgabios.c:1147
    xor ah, ah                                ; 30 e4                       ; 0xc1773 vgabios.c:1149
    push ax                                   ; 50                          ; 0xc1775
    push dword 000000000h                     ; 66 6a 00                    ; 0xc1776
    mov cx, 00100h                            ; b9 00 01                    ; 0xc1779
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc177c
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc177f
    xor al, al                                ; 30 c0                       ; 0xc1782
    call 02b8ch                               ; e8 05 14                    ; 0xc1784
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc1787 vgabios.c:1150
    xor bx, bx                                ; 31 db                       ; 0xc178a
    mov dx, 07c97h                            ; ba 97 7c                    ; 0xc178c
    mov ax, 0c000h                            ; b8 00 c0                    ; 0xc178f
    call 02b17h                               ; e8 82 13                    ; 0xc1792
    cmp word [bp-014h], strict byte 00000h    ; 83 7e ec 00                 ; 0xc1795 vgabios.c:1152
    jne short 0179fh                          ; 75 04                       ; 0xc1799
    test di, di                               ; 85 ff                       ; 0xc179b
    je short 017e9h                           ; 74 4a                       ; 0xc179d
    xor cx, cx                                ; 31 c9                       ; 0xc179f vgabios.c:1157
    mov es, [bp-014h]                         ; 8e 46 ec                    ; 0xc17a1 vgabios.c:1159
    mov bx, di                                ; 89 fb                       ; 0xc17a4
    add bx, cx                                ; 01 cb                       ; 0xc17a6
    mov al, byte [es:bx+00bh]                 ; 26 8a 47 0b                 ; 0xc17a8
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc17ac
    je short 017b8h                           ; 74 08                       ; 0xc17ae
    cmp al, byte [bp-010h]                    ; 3a 46 f0                    ; 0xc17b0 vgabios.c:1161
    je short 017b8h                           ; 74 03                       ; 0xc17b3
    inc cx                                    ; 41                          ; 0xc17b5 vgabios.c:1163
    jmp short 017a1h                          ; eb e9                       ; 0xc17b6 vgabios.c:1164
    mov es, [bp-014h]                         ; 8e 46 ec                    ; 0xc17b8 vgabios.c:1166
    mov bx, di                                ; 89 fb                       ; 0xc17bb
    add bx, cx                                ; 01 cb                       ; 0xc17bd
    mov al, byte [es:bx+00bh]                 ; 26 8a 47 0b                 ; 0xc17bf
    cmp al, byte [bp-010h]                    ; 3a 46 f0                    ; 0xc17c3
    jne short 017e9h                          ; 75 21                       ; 0xc17c6
    movzx ax, byte [es:di]                    ; 26 0f b6 05                 ; 0xc17c8 vgabios.c:1171
    push ax                                   ; 50                          ; 0xc17cc
    movzx ax, byte [es:di+001h]               ; 26 0f b6 45 01              ; 0xc17cd
    push ax                                   ; 50                          ; 0xc17d2
    push word [es:di+004h]                    ; 26 ff 75 04                 ; 0xc17d3
    mov cx, word [es:di+002h]                 ; 26 8b 4d 02                 ; 0xc17d7
    mov bx, word [es:di+006h]                 ; 26 8b 5d 06                 ; 0xc17db
    mov dx, word [es:di+008h]                 ; 26 8b 55 08                 ; 0xc17df
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc17e3
    call 02b8ch                               ; e8 a3 13                    ; 0xc17e6
    xor bl, bl                                ; 30 db                       ; 0xc17e9 vgabios.c:1175
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc17eb
    mov AH, strict byte 011h                  ; b4 11                       ; 0xc17ed
    int 06dh                                  ; cd 6d                       ; 0xc17ef
    mov bx, 0596ah                            ; bb 6a 59                    ; 0xc17f1 vgabios.c:1179
    mov cx, ds                                ; 8c d9                       ; 0xc17f4
    mov ax, strict word 0001fh                ; b8 1f 00                    ; 0xc17f6
    call 009f0h                               ; e8 f4 f1                    ; 0xc17f9
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc17fc vgabios.c:1181
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc17ff
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc1803
    je short 01821h                           ; 74 1a                       ; 0xc1805
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc1807
    je short 0181ch                           ; 74 11                       ; 0xc1809
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc180b
    jne short 01826h                          ; 75 17                       ; 0xc180d
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc180f vgabios.c:1183
    mov cx, ds                                ; 8c d9                       ; 0xc1812
    mov ax, strict word 00043h                ; b8 43 00                    ; 0xc1814
    call 009f0h                               ; e8 d6 f1                    ; 0xc1817
    jmp short 01826h                          ; eb 0a                       ; 0xc181a vgabios.c:1184
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc181c vgabios.c:1186
    jmp short 01812h                          ; eb f1                       ; 0xc181f
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc1821 vgabios.c:1189
    jmp short 01812h                          ; eb ec                       ; 0xc1824
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc1826 vgabios.c:1192
    pop di                                    ; 5f                          ; 0xc1829
    pop si                                    ; 5e                          ; 0xc182a
    pop dx                                    ; 5a                          ; 0xc182b
    pop cx                                    ; 59                          ; 0xc182c
    pop bx                                    ; 5b                          ; 0xc182d
    pop bp                                    ; 5d                          ; 0xc182e
    retn                                      ; c3                          ; 0xc182f
  ; disGetNextSymbol 0xc1830 LB 0x2a14 -> off=0x0 cb=0000000000000075 uValue=00000000000c1830 'vgamem_copy_pl4'
vgamem_copy_pl4:                             ; 0xc1830 LB 0x75
    push bp                                   ; 55                          ; 0xc1830 vgabios.c:1195
    mov bp, sp                                ; 89 e5                       ; 0xc1831
    push si                                   ; 56                          ; 0xc1833
    push di                                   ; 57                          ; 0xc1834
    push ax                                   ; 50                          ; 0xc1835
    push ax                                   ; 50                          ; 0xc1836
    mov bh, cl                                ; 88 cf                       ; 0xc1837
    movzx di, dl                              ; 0f b6 fa                    ; 0xc1839 vgabios.c:1201
    movzx cx, byte [bp+006h]                  ; 0f b6 4e 06                 ; 0xc183c
    imul di, cx                               ; 0f af f9                    ; 0xc1840
    movzx si, byte [bp+004h]                  ; 0f b6 76 04                 ; 0xc1843
    imul di, si                               ; 0f af fe                    ; 0xc1847
    xor ah, ah                                ; 30 e4                       ; 0xc184a
    add di, ax                                ; 01 c7                       ; 0xc184c
    mov word [bp-008h], di                    ; 89 7e f8                    ; 0xc184e
    movzx di, bl                              ; 0f b6 fb                    ; 0xc1851 vgabios.c:1202
    imul cx, di                               ; 0f af cf                    ; 0xc1854
    imul cx, si                               ; 0f af ce                    ; 0xc1857
    add cx, ax                                ; 01 c1                       ; 0xc185a
    mov word [bp-006h], cx                    ; 89 4e fa                    ; 0xc185c
    mov ax, 00105h                            ; b8 05 01                    ; 0xc185f vgabios.c:1203
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1862
    out DX, ax                                ; ef                          ; 0xc1865
    xor bl, bl                                ; 30 db                       ; 0xc1866 vgabios.c:1204
    cmp bl, byte [bp+006h]                    ; 3a 5e 06                    ; 0xc1868
    jnc short 01895h                          ; 73 28                       ; 0xc186b
    movzx cx, bh                              ; 0f b6 cf                    ; 0xc186d vgabios.c:1206
    movzx si, bl                              ; 0f b6 f3                    ; 0xc1870
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1873
    imul ax, si                               ; 0f af c6                    ; 0xc1877
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc187a
    add si, ax                                ; 01 c6                       ; 0xc187d
    mov di, word [bp-006h]                    ; 8b 7e fa                    ; 0xc187f
    add di, ax                                ; 01 c7                       ; 0xc1882
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1884
    mov es, dx                                ; 8e c2                       ; 0xc1887
    jcxz 01891h                               ; e3 06                       ; 0xc1889
    push DS                                   ; 1e                          ; 0xc188b
    mov ds, dx                                ; 8e da                       ; 0xc188c
    rep movsb                                 ; f3 a4                       ; 0xc188e
    pop DS                                    ; 1f                          ; 0xc1890
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc1891 vgabios.c:1207
    jmp short 01868h                          ; eb d3                       ; 0xc1893
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc1895 vgabios.c:1208
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1898
    out DX, ax                                ; ef                          ; 0xc189b
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc189c vgabios.c:1209
    pop di                                    ; 5f                          ; 0xc189f
    pop si                                    ; 5e                          ; 0xc18a0
    pop bp                                    ; 5d                          ; 0xc18a1
    retn 00004h                               ; c2 04 00                    ; 0xc18a2
  ; disGetNextSymbol 0xc18a5 LB 0x299f -> off=0x0 cb=0000000000000060 uValue=00000000000c18a5 'vgamem_fill_pl4'
vgamem_fill_pl4:                             ; 0xc18a5 LB 0x60
    push bp                                   ; 55                          ; 0xc18a5 vgabios.c:1212
    mov bp, sp                                ; 89 e5                       ; 0xc18a6
    push di                                   ; 57                          ; 0xc18a8
    push ax                                   ; 50                          ; 0xc18a9
    push ax                                   ; 50                          ; 0xc18aa
    mov byte [bp-004h], bl                    ; 88 5e fc                    ; 0xc18ab
    mov bh, cl                                ; 88 cf                       ; 0xc18ae
    movzx cx, dl                              ; 0f b6 ca                    ; 0xc18b0 vgabios.c:1218
    movzx dx, byte [bp+004h]                  ; 0f b6 56 04                 ; 0xc18b3
    imul cx, dx                               ; 0f af ca                    ; 0xc18b7
    movzx dx, bh                              ; 0f b6 d7                    ; 0xc18ba
    imul dx, cx                               ; 0f af d1                    ; 0xc18bd
    xor ah, ah                                ; 30 e4                       ; 0xc18c0
    add dx, ax                                ; 01 c2                       ; 0xc18c2
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc18c4
    mov ax, 00205h                            ; b8 05 02                    ; 0xc18c7 vgabios.c:1219
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc18ca
    out DX, ax                                ; ef                          ; 0xc18cd
    xor bl, bl                                ; 30 db                       ; 0xc18ce vgabios.c:1220
    cmp bl, byte [bp+004h]                    ; 3a 5e 04                    ; 0xc18d0
    jnc short 018f6h                          ; 73 21                       ; 0xc18d3
    movzx cx, byte [bp-004h]                  ; 0f b6 4e fc                 ; 0xc18d5 vgabios.c:1222
    movzx ax, byte [bp+006h]                  ; 0f b6 46 06                 ; 0xc18d9
    movzx dx, bl                              ; 0f b6 d3                    ; 0xc18dd
    movzx di, bh                              ; 0f b6 ff                    ; 0xc18e0
    imul di, dx                               ; 0f af fa                    ; 0xc18e3
    add di, word [bp-006h]                    ; 03 7e fa                    ; 0xc18e6
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc18e9
    mov es, dx                                ; 8e c2                       ; 0xc18ec
    jcxz 018f2h                               ; e3 02                       ; 0xc18ee
    rep stosb                                 ; f3 aa                       ; 0xc18f0
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc18f2 vgabios.c:1223
    jmp short 018d0h                          ; eb da                       ; 0xc18f4
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc18f6 vgabios.c:1224
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc18f9
    out DX, ax                                ; ef                          ; 0xc18fc
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc18fd vgabios.c:1225
    pop di                                    ; 5f                          ; 0xc1900
    pop bp                                    ; 5d                          ; 0xc1901
    retn 00004h                               ; c2 04 00                    ; 0xc1902
  ; disGetNextSymbol 0xc1905 LB 0x293f -> off=0x0 cb=00000000000000a3 uValue=00000000000c1905 'vgamem_copy_cga'
vgamem_copy_cga:                             ; 0xc1905 LB 0xa3
    push bp                                   ; 55                          ; 0xc1905 vgabios.c:1228
    mov bp, sp                                ; 89 e5                       ; 0xc1906
    push si                                   ; 56                          ; 0xc1908
    push di                                   ; 57                          ; 0xc1909
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc190a
    mov dh, bl                                ; 88 de                       ; 0xc190d
    mov byte [bp-006h], cl                    ; 88 4e fa                    ; 0xc190f
    movzx di, dl                              ; 0f b6 fa                    ; 0xc1912 vgabios.c:1234
    movzx si, byte [bp+006h]                  ; 0f b6 76 06                 ; 0xc1915
    imul di, si                               ; 0f af fe                    ; 0xc1919
    movzx bx, byte [bp+004h]                  ; 0f b6 5e 04                 ; 0xc191c
    imul di, bx                               ; 0f af fb                    ; 0xc1920
    sar di, 1                                 ; d1 ff                       ; 0xc1923
    xor ah, ah                                ; 30 e4                       ; 0xc1925
    add di, ax                                ; 01 c7                       ; 0xc1927
    mov word [bp-00ch], di                    ; 89 7e f4                    ; 0xc1929
    movzx dx, dh                              ; 0f b6 d6                    ; 0xc192c vgabios.c:1235
    imul dx, si                               ; 0f af d6                    ; 0xc192f
    imul dx, bx                               ; 0f af d3                    ; 0xc1932
    sar dx, 1                                 ; d1 fa                       ; 0xc1935
    add dx, ax                                ; 01 c2                       ; 0xc1937
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc1939
    mov byte [bp-008h], ah                    ; 88 66 f8                    ; 0xc193c vgabios.c:1236
    movzx ax, byte [bp+006h]                  ; 0f b6 46 06                 ; 0xc193f
    cwd                                       ; 99                          ; 0xc1943
    db  02bh, 0c2h
    ; sub ax, dx                                ; 2b c2                     ; 0xc1944
    sar ax, 1                                 ; d1 f8                       ; 0xc1946
    movzx bx, byte [bp-008h]                  ; 0f b6 5e f8                 ; 0xc1948
    cmp bx, ax                                ; 39 c3                       ; 0xc194c
    jnl short 0199fh                          ; 7d 4f                       ; 0xc194e
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc1950 vgabios.c:1238
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc1954
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1957
    imul bx, ax                               ; 0f af d8                    ; 0xc195b
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc195e
    add si, bx                                ; 01 de                       ; 0xc1961
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc1963
    add di, bx                                ; 01 df                       ; 0xc1966
    mov cx, word [bp-00eh]                    ; 8b 4e f2                    ; 0xc1968
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc196b
    mov es, dx                                ; 8e c2                       ; 0xc196e
    jcxz 01978h                               ; e3 06                       ; 0xc1970
    push DS                                   ; 1e                          ; 0xc1972
    mov ds, dx                                ; 8e da                       ; 0xc1973
    rep movsb                                 ; f3 a4                       ; 0xc1975
    pop DS                                    ; 1f                          ; 0xc1977
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc1978 vgabios.c:1239
    add si, 02000h                            ; 81 c6 00 20                 ; 0xc197b
    add si, bx                                ; 01 de                       ; 0xc197f
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc1981
    add di, 02000h                            ; 81 c7 00 20                 ; 0xc1984
    add di, bx                                ; 01 df                       ; 0xc1988
    mov cx, word [bp-00eh]                    ; 8b 4e f2                    ; 0xc198a
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc198d
    mov es, dx                                ; 8e c2                       ; 0xc1990
    jcxz 0199ah                               ; e3 06                       ; 0xc1992
    push DS                                   ; 1e                          ; 0xc1994
    mov ds, dx                                ; 8e da                       ; 0xc1995
    rep movsb                                 ; f3 a4                       ; 0xc1997
    pop DS                                    ; 1f                          ; 0xc1999
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc199a vgabios.c:1240
    jmp short 0193fh                          ; eb a0                       ; 0xc199d
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc199f vgabios.c:1241
    pop di                                    ; 5f                          ; 0xc19a2
    pop si                                    ; 5e                          ; 0xc19a3
    pop bp                                    ; 5d                          ; 0xc19a4
    retn 00004h                               ; c2 04 00                    ; 0xc19a5
  ; disGetNextSymbol 0xc19a8 LB 0x289c -> off=0x0 cb=0000000000000081 uValue=00000000000c19a8 'vgamem_fill_cga'
vgamem_fill_cga:                             ; 0xc19a8 LB 0x81
    push bp                                   ; 55                          ; 0xc19a8 vgabios.c:1244
    mov bp, sp                                ; 89 e5                       ; 0xc19a9
    push si                                   ; 56                          ; 0xc19ab
    push di                                   ; 57                          ; 0xc19ac
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc19ad
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc19b0
    mov byte [bp-008h], cl                    ; 88 4e f8                    ; 0xc19b3
    movzx bx, dl                              ; 0f b6 da                    ; 0xc19b6 vgabios.c:1250
    movzx dx, byte [bp+004h]                  ; 0f b6 56 04                 ; 0xc19b9
    imul bx, dx                               ; 0f af da                    ; 0xc19bd
    movzx dx, cl                              ; 0f b6 d1                    ; 0xc19c0
    imul dx, bx                               ; 0f af d3                    ; 0xc19c3
    sar dx, 1                                 ; d1 fa                       ; 0xc19c6
    xor ah, ah                                ; 30 e4                       ; 0xc19c8
    add dx, ax                                ; 01 c2                       ; 0xc19ca
    mov word [bp-00ch], dx                    ; 89 56 f4                    ; 0xc19cc
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc19cf vgabios.c:1251
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc19d2
    cwd                                       ; 99                          ; 0xc19d6
    db  02bh, 0c2h
    ; sub ax, dx                                ; 2b c2                     ; 0xc19d7
    sar ax, 1                                 ; d1 f8                       ; 0xc19d9
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc19db
    cmp dx, ax                                ; 39 c2                       ; 0xc19df
    jnl short 01a20h                          ; 7d 3d                       ; 0xc19e1
    movzx si, byte [bp-00ah]                  ; 0f b6 76 f6                 ; 0xc19e3 vgabios.c:1253
    movzx bx, byte [bp+006h]                  ; 0f b6 5e 06                 ; 0xc19e7
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc19eb
    imul dx, ax                               ; 0f af d0                    ; 0xc19ef
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc19f2
    mov di, word [bp-00ch]                    ; 8b 7e f4                    ; 0xc19f5
    add di, dx                                ; 01 d7                       ; 0xc19f8
    mov cx, si                                ; 89 f1                       ; 0xc19fa
    mov ax, bx                                ; 89 d8                       ; 0xc19fc
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc19fe
    mov es, dx                                ; 8e c2                       ; 0xc1a01
    jcxz 01a07h                               ; e3 02                       ; 0xc1a03
    rep stosb                                 ; f3 aa                       ; 0xc1a05
    mov di, word [bp-00ch]                    ; 8b 7e f4                    ; 0xc1a07 vgabios.c:1254
    add di, 02000h                            ; 81 c7 00 20                 ; 0xc1a0a
    add di, word [bp-00eh]                    ; 03 7e f2                    ; 0xc1a0e
    mov cx, si                                ; 89 f1                       ; 0xc1a11
    mov ax, bx                                ; 89 d8                       ; 0xc1a13
    mov es, dx                                ; 8e c2                       ; 0xc1a15
    jcxz 01a1bh                               ; e3 02                       ; 0xc1a17
    rep stosb                                 ; f3 aa                       ; 0xc1a19
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1a1b vgabios.c:1255
    jmp short 019d2h                          ; eb b2                       ; 0xc1a1e
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1a20 vgabios.c:1256
    pop di                                    ; 5f                          ; 0xc1a23
    pop si                                    ; 5e                          ; 0xc1a24
    pop bp                                    ; 5d                          ; 0xc1a25
    retn 00004h                               ; c2 04 00                    ; 0xc1a26
  ; disGetNextSymbol 0xc1a29 LB 0x281b -> off=0x0 cb=0000000000000079 uValue=00000000000c1a29 'vgamem_copy_linear'
vgamem_copy_linear:                          ; 0xc1a29 LB 0x79
    push bp                                   ; 55                          ; 0xc1a29 vgabios.c:1259
    mov bp, sp                                ; 89 e5                       ; 0xc1a2a
    push si                                   ; 56                          ; 0xc1a2c
    push di                                   ; 57                          ; 0xc1a2d
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc1a2e
    mov ah, al                                ; 88 c4                       ; 0xc1a31
    mov al, bl                                ; 88 d8                       ; 0xc1a33
    mov bx, cx                                ; 89 cb                       ; 0xc1a35
    xor dh, dh                                ; 30 f6                       ; 0xc1a37 vgabios.c:1265
    movzx di, byte [bp+006h]                  ; 0f b6 7e 06                 ; 0xc1a39
    imul dx, di                               ; 0f af d7                    ; 0xc1a3d
    imul dx, word [bp+004h]                   ; 0f af 56 04                 ; 0xc1a40
    movzx si, ah                              ; 0f b6 f4                    ; 0xc1a44
    add dx, si                                ; 01 f2                       ; 0xc1a47
    sal dx, 003h                              ; c1 e2 03                    ; 0xc1a49
    mov word [bp-008h], dx                    ; 89 56 f8                    ; 0xc1a4c
    xor ah, ah                                ; 30 e4                       ; 0xc1a4f vgabios.c:1266
    imul ax, di                               ; 0f af c7                    ; 0xc1a51
    imul ax, word [bp+004h]                   ; 0f af 46 04                 ; 0xc1a54
    add si, ax                                ; 01 c6                       ; 0xc1a58
    sal si, 003h                              ; c1 e6 03                    ; 0xc1a5a
    mov word [bp-00ah], si                    ; 89 76 f6                    ; 0xc1a5d
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1a60 vgabios.c:1267
    sal word [bp+004h], 003h                  ; c1 66 04 03                 ; 0xc1a63 vgabios.c:1268
    mov byte [bp-006h], 000h                  ; c6 46 fa 00                 ; 0xc1a67 vgabios.c:1269
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1a6b
    cmp al, byte [bp+006h]                    ; 3a 46 06                    ; 0xc1a6e
    jnc short 01a99h                          ; 73 26                       ; 0xc1a71
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc1a73 vgabios.c:1271
    imul ax, word [bp+004h]                   ; 0f af 46 04                 ; 0xc1a77
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc1a7b
    add si, ax                                ; 01 c6                       ; 0xc1a7e
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc1a80
    add di, ax                                ; 01 c7                       ; 0xc1a83
    mov cx, bx                                ; 89 d9                       ; 0xc1a85
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1a87
    mov es, dx                                ; 8e c2                       ; 0xc1a8a
    jcxz 01a94h                               ; e3 06                       ; 0xc1a8c
    push DS                                   ; 1e                          ; 0xc1a8e
    mov ds, dx                                ; 8e da                       ; 0xc1a8f
    rep movsb                                 ; f3 a4                       ; 0xc1a91
    pop DS                                    ; 1f                          ; 0xc1a93
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1a94 vgabios.c:1272
    jmp short 01a6bh                          ; eb d2                       ; 0xc1a97
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1a99 vgabios.c:1273
    pop di                                    ; 5f                          ; 0xc1a9c
    pop si                                    ; 5e                          ; 0xc1a9d
    pop bp                                    ; 5d                          ; 0xc1a9e
    retn 00004h                               ; c2 04 00                    ; 0xc1a9f
  ; disGetNextSymbol 0xc1aa2 LB 0x27a2 -> off=0x0 cb=000000000000005c uValue=00000000000c1aa2 'vgamem_fill_linear'
vgamem_fill_linear:                          ; 0xc1aa2 LB 0x5c
    push bp                                   ; 55                          ; 0xc1aa2 vgabios.c:1276
    mov bp, sp                                ; 89 e5                       ; 0xc1aa3
    push si                                   ; 56                          ; 0xc1aa5
    push di                                   ; 57                          ; 0xc1aa6
    push ax                                   ; 50                          ; 0xc1aa7
    push ax                                   ; 50                          ; 0xc1aa8
    mov si, bx                                ; 89 de                       ; 0xc1aa9
    mov bx, cx                                ; 89 cb                       ; 0xc1aab
    xor dh, dh                                ; 30 f6                       ; 0xc1aad vgabios.c:1282
    movzx di, byte [bp+004h]                  ; 0f b6 7e 04                 ; 0xc1aaf
    imul dx, di                               ; 0f af d7                    ; 0xc1ab3
    imul dx, cx                               ; 0f af d1                    ; 0xc1ab6
    xor ah, ah                                ; 30 e4                       ; 0xc1ab9
    add ax, dx                                ; 01 d0                       ; 0xc1abb
    sal ax, 003h                              ; c1 e0 03                    ; 0xc1abd
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc1ac0
    sal si, 003h                              ; c1 e6 03                    ; 0xc1ac3 vgabios.c:1283
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1ac6 vgabios.c:1284
    mov byte [bp-006h], 000h                  ; c6 46 fa 00                 ; 0xc1ac9 vgabios.c:1285
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1acd
    cmp al, byte [bp+004h]                    ; 3a 46 04                    ; 0xc1ad0
    jnc short 01af5h                          ; 73 20                       ; 0xc1ad3
    movzx ax, byte [bp+006h]                  ; 0f b6 46 06                 ; 0xc1ad5 vgabios.c:1287
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc1ad9
    imul dx, bx                               ; 0f af d3                    ; 0xc1add
    mov di, word [bp-008h]                    ; 8b 7e f8                    ; 0xc1ae0
    add di, dx                                ; 01 d7                       ; 0xc1ae3
    mov cx, si                                ; 89 f1                       ; 0xc1ae5
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1ae7
    mov es, dx                                ; 8e c2                       ; 0xc1aea
    jcxz 01af0h                               ; e3 02                       ; 0xc1aec
    rep stosb                                 ; f3 aa                       ; 0xc1aee
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1af0 vgabios.c:1288
    jmp short 01acdh                          ; eb d8                       ; 0xc1af3
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1af5 vgabios.c:1289
    pop di                                    ; 5f                          ; 0xc1af8
    pop si                                    ; 5e                          ; 0xc1af9
    pop bp                                    ; 5d                          ; 0xc1afa
    retn 00004h                               ; c2 04 00                    ; 0xc1afb
  ; disGetNextSymbol 0xc1afe LB 0x2746 -> off=0x0 cb=0000000000000622 uValue=00000000000c1afe 'biosfn_scroll'
biosfn_scroll:                               ; 0xc1afe LB 0x622
    push bp                                   ; 55                          ; 0xc1afe vgabios.c:1292
    mov bp, sp                                ; 89 e5                       ; 0xc1aff
    push si                                   ; 56                          ; 0xc1b01
    push di                                   ; 57                          ; 0xc1b02
    sub sp, strict byte 00018h                ; 83 ec 18                    ; 0xc1b03
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc1b06
    mov byte [bp-012h], dl                    ; 88 56 ee                    ; 0xc1b09
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc1b0c
    mov byte [bp-010h], cl                    ; 88 4e f0                    ; 0xc1b0f
    mov dl, byte [bp+006h]                    ; 8a 56 06                    ; 0xc1b12
    cmp bl, byte [bp+004h]                    ; 3a 5e 04                    ; 0xc1b15 vgabios.c:1301
    jnbe near 02117h                          ; 0f 87 fb 05                 ; 0xc1b18
    cmp dl, cl                                ; 38 ca                       ; 0xc1b1c vgabios.c:1302
    jc near 02117h                            ; 0f 82 f5 05                 ; 0xc1b1e
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc1b22 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1b25
    mov es, ax                                ; 8e c0                       ; 0xc1b28
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1b2a
    xor ah, ah                                ; 30 e4                       ; 0xc1b2d vgabios.c:1306
    call 0356fh                               ; e8 3d 1a                    ; 0xc1b2f
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc1b32
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc1b35 vgabios.c:1307
    je near 02117h                            ; 0f 84 dc 05                 ; 0xc1b37
    mov bx, 00084h                            ; bb 84 00                    ; 0xc1b3b vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1b3e
    mov es, ax                                ; 8e c0                       ; 0xc1b41
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1b43
    movzx cx, al                              ; 0f b6 c8                    ; 0xc1b46 vgabios.c:48
    inc cx                                    ; 41                          ; 0xc1b49
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc1b4a vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc1b4d
    mov word [bp-014h], ax                    ; 89 46 ec                    ; 0xc1b50 vgabios.c:58
    cmp byte [bp+008h], 0ffh                  ; 80 7e 08 ff                 ; 0xc1b53 vgabios.c:1314
    jne short 01b62h                          ; 75 09                       ; 0xc1b57
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc1b59 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1b5c
    mov byte [bp+008h], al                    ; 88 46 08                    ; 0xc1b5f vgabios.c:48
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1b62 vgabios.c:1317
    cmp ax, cx                                ; 39 c8                       ; 0xc1b66
    jc short 01b71h                           ; 72 07                       ; 0xc1b68
    mov al, cl                                ; 88 c8                       ; 0xc1b6a
    db  0feh, 0c8h
    ; dec al                                    ; fe c8                     ; 0xc1b6c
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc1b6e
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc1b71 vgabios.c:1318
    cmp ax, word [bp-014h]                    ; 3b 46 ec                    ; 0xc1b74
    jc short 01b7eh                           ; 72 05                       ; 0xc1b77
    mov dl, byte [bp-014h]                    ; 8a 56 ec                    ; 0xc1b79
    db  0feh, 0cah
    ; dec dl                                    ; fe ca                     ; 0xc1b7c
    movzx ax, byte [bp-00eh]                  ; 0f b6 46 f2                 ; 0xc1b7e vgabios.c:1319
    cmp ax, cx                                ; 39 c8                       ; 0xc1b82
    jbe short 01b8ah                          ; 76 04                       ; 0xc1b84
    mov byte [bp-00eh], 000h                  ; c6 46 f2 00                 ; 0xc1b86
    mov al, dl                                ; 88 d0                       ; 0xc1b8a vgabios.c:1320
    sub al, byte [bp-010h]                    ; 2a 46 f0                    ; 0xc1b8c
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc1b8f
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc1b91
    movzx di, byte [bp-00ch]                  ; 0f b6 7e f4                 ; 0xc1b94 vgabios.c:1322
    mov bx, di                                ; 89 fb                       ; 0xc1b98
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1b9a
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc1b9d
    dec ax                                    ; 48                          ; 0xc1ba0
    mov word [bp-01ch], ax                    ; 89 46 e4                    ; 0xc1ba1
    mov ax, cx                                ; 89 c8                       ; 0xc1ba4
    dec ax                                    ; 48                          ; 0xc1ba6
    mov word [bp-018h], ax                    ; 89 46 e8                    ; 0xc1ba7
    mov si, word [bp-014h]                    ; 8b 76 ec                    ; 0xc1baa
    imul si, cx                               ; 0f af f1                    ; 0xc1bad
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc1bb0
    jne near 01d59h                           ; 0f 85 a0 01                 ; 0xc1bb5
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc1bb9 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1bbc
    mov es, ax                                ; 8e c0                       ; 0xc1bbf
    mov cx, word [es:di]                      ; 26 8b 0d                    ; 0xc1bc1
    movzx ax, byte [bp+008h]                  ; 0f b6 46 08                 ; 0xc1bc4 vgabios.c:58
    imul cx, ax                               ; 0f af c8                    ; 0xc1bc8
    mov word [bp-016h], cx                    ; 89 4e ea                    ; 0xc1bcb
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1bce vgabios.c:1330
    jne short 01c0bh                          ; 75 37                       ; 0xc1bd2
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1bd4
    jne short 01c0bh                          ; 75 31                       ; 0xc1bd8
    cmp byte [bp-010h], 000h                  ; 80 7e f0 00                 ; 0xc1bda
    jne short 01c0bh                          ; 75 2b                       ; 0xc1bde
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1be0
    cmp ax, word [bp-018h]                    ; 3b 46 e8                    ; 0xc1be4
    jne short 01c0bh                          ; 75 22                       ; 0xc1be7
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc1be9
    cmp ax, word [bp-01ch]                    ; 3b 46 e4                    ; 0xc1bec
    jne short 01c0bh                          ; 75 1a                       ; 0xc1bef
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1bf1 vgabios.c:1332
    sal ax, 008h                              ; c1 e0 08                    ; 0xc1bf5
    add ax, strict word 00020h                ; 05 20 00                    ; 0xc1bf8
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1bfb
    mov cx, si                                ; 89 f1                       ; 0xc1bff
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1c01
    jcxz 01c08h                               ; e3 02                       ; 0xc1c04
    rep stosw                                 ; f3 ab                       ; 0xc1c06
    jmp near 02117h                           ; e9 0c 05                    ; 0xc1c08 vgabios.c:1334
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1c0b vgabios.c:1336
    jne near 01cabh                           ; 0f 85 98 00                 ; 0xc1c0f
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1c13 vgabios.c:1337
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1c17
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1c1a
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1c1e
    jc near 02117h                            ; 0f 82 f2 04                 ; 0xc1c21
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc1c25 vgabios.c:1339
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc1c29
    cmp dx, ax                                ; 39 c2                       ; 0xc1c2c
    jnbe short 01c36h                         ; 77 06                       ; 0xc1c2e
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1c30
    jne short 01c69h                          ; 75 33                       ; 0xc1c34
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1c36 vgabios.c:1340
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1c3a
    sal ax, 008h                              ; c1 e0 08                    ; 0xc1c3e
    add ax, strict word 00020h                ; 05 20 00                    ; 0xc1c41
    mov bx, word [bp-01ah]                    ; 8b 5e e6                    ; 0xc1c44
    imul bx, word [bp-014h]                   ; 0f af 5e ec                 ; 0xc1c47
    movzx dx, byte [bp-010h]                  ; 0f b6 56 f0                 ; 0xc1c4b
    add dx, bx                                ; 01 da                       ; 0xc1c4f
    add dx, dx                                ; 01 d2                       ; 0xc1c51
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1c53
    add di, dx                                ; 01 d7                       ; 0xc1c56
    movzx bx, byte [bp-00ch]                  ; 0f b6 5e f4                 ; 0xc1c58
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1c5c
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1c5f
    jcxz 01c67h                               ; e3 02                       ; 0xc1c63
    rep stosw                                 ; f3 ab                       ; 0xc1c65
    jmp short 01ca5h                          ; eb 3c                       ; 0xc1c67 vgabios.c:1341
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1c69 vgabios.c:1342
    imul dx, word [bp-014h]                   ; 0f af 56 ec                 ; 0xc1c6d
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1c71
    add dx, ax                                ; 01 c2                       ; 0xc1c75
    add dx, dx                                ; 01 d2                       ; 0xc1c77
    mov si, word [bp-016h]                    ; 8b 76 ea                    ; 0xc1c79
    add si, dx                                ; 01 d6                       ; 0xc1c7c
    movzx bx, byte [bp-00ch]                  ; 0f b6 5e f4                 ; 0xc1c7e
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1c82
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1c85
    mov dx, word [bp-01ah]                    ; 8b 56 e6                    ; 0xc1c89
    imul dx, word [bp-014h]                   ; 0f af 56 ec                 ; 0xc1c8c
    add ax, dx                                ; 01 d0                       ; 0xc1c90
    add ax, ax                                ; 01 c0                       ; 0xc1c92
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1c94
    add di, ax                                ; 01 c7                       ; 0xc1c97
    mov dx, bx                                ; 89 da                       ; 0xc1c99
    mov es, bx                                ; 8e c3                       ; 0xc1c9b
    jcxz 01ca5h                               ; e3 06                       ; 0xc1c9d
    push DS                                   ; 1e                          ; 0xc1c9f
    mov ds, dx                                ; 8e da                       ; 0xc1ca0
    rep movsw                                 ; f3 a5                       ; 0xc1ca2
    pop DS                                    ; 1f                          ; 0xc1ca4
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc1ca5 vgabios.c:1343
    jmp near 01c1ah                           ; e9 6f ff                    ; 0xc1ca8
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1cab vgabios.c:1346
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1caf
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1cb2
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1cb6
    jnbe near 02117h                          ; 0f 87 5a 04                 ; 0xc1cb9
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1cbd vgabios.c:1348
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc1cc1
    add ax, dx                                ; 01 d0                       ; 0xc1cc5
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1cc7
    jnbe short 01cd2h                         ; 77 06                       ; 0xc1cca
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1ccc
    jne short 01d05h                          ; 75 33                       ; 0xc1cd0
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1cd2 vgabios.c:1349
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1cd6
    sal ax, 008h                              ; c1 e0 08                    ; 0xc1cda
    add ax, strict word 00020h                ; 05 20 00                    ; 0xc1cdd
    mov dx, word [bp-01ah]                    ; 8b 56 e6                    ; 0xc1ce0
    imul dx, word [bp-014h]                   ; 0f af 56 ec                 ; 0xc1ce3
    movzx bx, byte [bp-010h]                  ; 0f b6 5e f0                 ; 0xc1ce7
    add dx, bx                                ; 01 da                       ; 0xc1ceb
    add dx, dx                                ; 01 d2                       ; 0xc1ced
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1cef
    add di, dx                                ; 01 d7                       ; 0xc1cf2
    movzx bx, byte [bp-00ch]                  ; 0f b6 5e f4                 ; 0xc1cf4
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1cf8
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1cfb
    jcxz 01d03h                               ; e3 02                       ; 0xc1cff
    rep stosw                                 ; f3 ab                       ; 0xc1d01
    jmp short 01d48h                          ; eb 43                       ; 0xc1d03 vgabios.c:1350
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1d05 vgabios.c:1351
    movzx ax, byte [bp-00eh]                  ; 0f b6 46 f2                 ; 0xc1d09
    mov si, word [bp-01ah]                    ; 8b 76 e6                    ; 0xc1d0d
    sub si, ax                                ; 29 c6                       ; 0xc1d10
    imul si, word [bp-014h]                   ; 0f af 76 ec                 ; 0xc1d12
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1d16
    add si, ax                                ; 01 c6                       ; 0xc1d1a
    add si, si                                ; 01 f6                       ; 0xc1d1c
    add si, word [bp-016h]                    ; 03 76 ea                    ; 0xc1d1e
    movzx bx, byte [bp-00ch]                  ; 0f b6 5e f4                 ; 0xc1d21
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1d25
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1d28
    mov dx, word [bp-01ah]                    ; 8b 56 e6                    ; 0xc1d2c
    imul dx, word [bp-014h]                   ; 0f af 56 ec                 ; 0xc1d2f
    add ax, dx                                ; 01 d0                       ; 0xc1d33
    add ax, ax                                ; 01 c0                       ; 0xc1d35
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1d37
    add di, ax                                ; 01 c7                       ; 0xc1d3a
    mov dx, bx                                ; 89 da                       ; 0xc1d3c
    mov es, bx                                ; 8e c3                       ; 0xc1d3e
    jcxz 01d48h                               ; e3 06                       ; 0xc1d40
    push DS                                   ; 1e                          ; 0xc1d42
    mov ds, dx                                ; 8e da                       ; 0xc1d43
    rep movsw                                 ; f3 a5                       ; 0xc1d45
    pop DS                                    ; 1f                          ; 0xc1d47
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1d48 vgabios.c:1352
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1d4c
    jc near 02117h                            ; 0f 82 c4 03                 ; 0xc1d4f
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc1d53 vgabios.c:1353
    jmp near 01cb2h                           ; e9 59 ff                    ; 0xc1d56
    movzx di, byte [di+0482ch]                ; 0f b6 bd 2c 48              ; 0xc1d59 vgabios.c:1359
    sal di, 006h                              ; c1 e7 06                    ; 0xc1d5e
    mov al, byte [di+04842h]                  ; 8a 85 42 48                 ; 0xc1d61
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc1d65
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc1d68 vgabios.c:1360
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc1d6c
    jc short 01d7fh                           ; 72 0f                       ; 0xc1d6e
    jbe short 01d88h                          ; 76 16                       ; 0xc1d70
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc1d72
    je near 01ffch                            ; 0f 84 84 02                 ; 0xc1d74
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc1d78
    je short 01d88h                           ; 74 0c                       ; 0xc1d7a
    jmp near 02117h                           ; e9 98 03                    ; 0xc1d7c
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc1d7f
    je near 01ec5h                            ; 0f 84 40 01                 ; 0xc1d81
    jmp near 02117h                           ; e9 8f 03                    ; 0xc1d85
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1d88 vgabios.c:1364
    jne short 01ddeh                          ; 75 50                       ; 0xc1d8c
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1d8e
    jne short 01ddeh                          ; 75 4a                       ; 0xc1d92
    cmp byte [bp-010h], 000h                  ; 80 7e f0 00                 ; 0xc1d94
    jne short 01ddeh                          ; 75 44                       ; 0xc1d98
    movzx bx, byte [bp+004h]                  ; 0f b6 5e 04                 ; 0xc1d9a
    mov ax, cx                                ; 89 c8                       ; 0xc1d9e
    dec ax                                    ; 48                          ; 0xc1da0
    cmp bx, ax                                ; 39 c3                       ; 0xc1da1
    jne short 01ddeh                          ; 75 39                       ; 0xc1da3
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc1da5
    mov dx, word [bp-014h]                    ; 8b 56 ec                    ; 0xc1da8
    dec dx                                    ; 4a                          ; 0xc1dab
    cmp ax, dx                                ; 39 d0                       ; 0xc1dac
    jne short 01ddeh                          ; 75 2e                       ; 0xc1dae
    mov ax, 00205h                            ; b8 05 02                    ; 0xc1db0 vgabios.c:1366
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1db3
    out DX, ax                                ; ef                          ; 0xc1db6
    imul cx, word [bp-014h]                   ; 0f af 4e ec                 ; 0xc1db7 vgabios.c:1367
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1dbb
    imul cx, ax                               ; 0f af c8                    ; 0xc1dbf
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1dc2
    movzx bx, byte [bp-00ch]                  ; 0f b6 5e f4                 ; 0xc1dc6
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1dca
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1dcd
    xor di, di                                ; 31 ff                       ; 0xc1dd1
    jcxz 01dd7h                               ; e3 02                       ; 0xc1dd3
    rep stosb                                 ; f3 aa                       ; 0xc1dd5
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc1dd7 vgabios.c:1368
    out DX, ax                                ; ef                          ; 0xc1dda
    jmp near 02117h                           ; e9 39 03                    ; 0xc1ddb vgabios.c:1370
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1dde vgabios.c:1372
    jne short 01e4dh                          ; 75 69                       ; 0xc1de2
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1de4 vgabios.c:1373
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1de8
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1deb
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1def
    jc near 02117h                            ; 0f 82 21 03                 ; 0xc1df2
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc1df6 vgabios.c:1375
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc1dfa
    cmp dx, ax                                ; 39 c2                       ; 0xc1dfd
    jnbe short 01e07h                         ; 77 06                       ; 0xc1dff
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1e01
    jne short 01e26h                          ; 75 1f                       ; 0xc1e05
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1e07 vgabios.c:1376
    push ax                                   ; 50                          ; 0xc1e0b
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1e0c
    push ax                                   ; 50                          ; 0xc1e10
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc1e11
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc1e15
    movzx dx, byte [bp-01ah]                  ; 0f b6 56 e6                 ; 0xc1e19
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1e1d
    call 018a5h                               ; e8 81 fa                    ; 0xc1e21
    jmp short 01e48h                          ; eb 22                       ; 0xc1e24 vgabios.c:1377
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1e26 vgabios.c:1378
    push ax                                   ; 50                          ; 0xc1e2a
    movzx ax, byte [bp-014h]                  ; 0f b6 46 ec                 ; 0xc1e2b
    push ax                                   ; 50                          ; 0xc1e2f
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1e30
    movzx bx, byte [bp-01ah]                  ; 0f b6 5e e6                 ; 0xc1e34
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc1e38
    add al, byte [bp-00eh]                    ; 02 46 f2                    ; 0xc1e3b
    movzx dx, al                              ; 0f b6 d0                    ; 0xc1e3e
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1e41
    call 01830h                               ; e8 e8 f9                    ; 0xc1e45
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc1e48 vgabios.c:1379
    jmp short 01debh                          ; eb 9e                       ; 0xc1e4b
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1e4d vgabios.c:1382
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1e51
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1e54
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1e58
    jnbe near 02117h                          ; 0f 87 b8 02                 ; 0xc1e5b
    movzx dx, byte [bp-008h]                  ; 0f b6 56 f8                 ; 0xc1e5f vgabios.c:1384
    movzx ax, byte [bp-00eh]                  ; 0f b6 46 f2                 ; 0xc1e63
    add ax, dx                                ; 01 d0                       ; 0xc1e67
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1e69
    jnbe short 01e74h                         ; 77 06                       ; 0xc1e6c
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1e6e
    jne short 01e93h                          ; 75 1f                       ; 0xc1e72
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1e74 vgabios.c:1385
    push ax                                   ; 50                          ; 0xc1e78
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1e79
    push ax                                   ; 50                          ; 0xc1e7d
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc1e7e
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc1e82
    movzx dx, byte [bp-01ah]                  ; 0f b6 56 e6                 ; 0xc1e86
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1e8a
    call 018a5h                               ; e8 14 fa                    ; 0xc1e8e
    jmp short 01eb5h                          ; eb 22                       ; 0xc1e91 vgabios.c:1386
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1e93 vgabios.c:1387
    push ax                                   ; 50                          ; 0xc1e97
    movzx ax, byte [bp-014h]                  ; 0f b6 46 ec                 ; 0xc1e98
    push ax                                   ; 50                          ; 0xc1e9c
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1e9d
    movzx bx, byte [bp-01ah]                  ; 0f b6 5e e6                 ; 0xc1ea1
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc1ea5
    sub al, byte [bp-00eh]                    ; 2a 46 f2                    ; 0xc1ea8
    movzx dx, al                              ; 0f b6 d0                    ; 0xc1eab
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1eae
    call 01830h                               ; e8 7b f9                    ; 0xc1eb2
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1eb5 vgabios.c:1388
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1eb9
    jc near 02117h                            ; 0f 82 57 02                 ; 0xc1ebc
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc1ec0 vgabios.c:1389
    jmp short 01e54h                          ; eb 8f                       ; 0xc1ec3
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc1ec5 vgabios.c:1394
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1ec9 vgabios.c:1395
    jne short 01f08h                          ; 75 39                       ; 0xc1ecd
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1ecf
    jne short 01f08h                          ; 75 33                       ; 0xc1ed3
    cmp byte [bp-010h], 000h                  ; 80 7e f0 00                 ; 0xc1ed5
    jne short 01f08h                          ; 75 2d                       ; 0xc1ed9
    movzx cx, byte [bp+004h]                  ; 0f b6 4e 04                 ; 0xc1edb
    cmp cx, word [bp-018h]                    ; 3b 4e e8                    ; 0xc1edf
    jne short 01f08h                          ; 75 24                       ; 0xc1ee2
    xor dh, dh                                ; 30 f6                       ; 0xc1ee4
    cmp dx, word [bp-01ch]                    ; 3b 56 e4                    ; 0xc1ee6
    jne short 01f08h                          ; 75 1d                       ; 0xc1ee9
    movzx cx, byte [bp-00ah]                  ; 0f b6 4e f6                 ; 0xc1eeb vgabios.c:1397
    imul cx, si                               ; 0f af ce                    ; 0xc1eef
    xor ah, ah                                ; 30 e4                       ; 0xc1ef2
    imul cx, ax                               ; 0f af c8                    ; 0xc1ef4
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1ef7
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1efb
    xor di, di                                ; 31 ff                       ; 0xc1eff
    jcxz 01f05h                               ; e3 02                       ; 0xc1f01
    rep stosb                                 ; f3 aa                       ; 0xc1f03
    jmp near 02117h                           ; e9 0f 02                    ; 0xc1f05 vgabios.c:1399
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc1f08 vgabios.c:1401
    jne short 01f15h                          ; 75 09                       ; 0xc1f0a
    sal byte [bp-010h], 1                     ; d0 66 f0                    ; 0xc1f0c vgabios.c:1403
    sal byte [bp-006h], 1                     ; d0 66 fa                    ; 0xc1f0f vgabios.c:1404
    sal word [bp-014h], 1                     ; d1 66 ec                    ; 0xc1f12 vgabios.c:1405
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1f15 vgabios.c:1408
    jne short 01f84h                          ; 75 69                       ; 0xc1f19
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1f1b vgabios.c:1409
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1f1f
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1f22
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1f26
    jc near 02117h                            ; 0f 82 ea 01                 ; 0xc1f29
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc1f2d vgabios.c:1411
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc1f31
    cmp dx, ax                                ; 39 c2                       ; 0xc1f34
    jnbe short 01f3eh                         ; 77 06                       ; 0xc1f36
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1f38
    jne short 01f5dh                          ; 75 1f                       ; 0xc1f3c
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1f3e vgabios.c:1412
    push ax                                   ; 50                          ; 0xc1f42
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1f43
    push ax                                   ; 50                          ; 0xc1f47
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc1f48
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc1f4c
    movzx dx, byte [bp-01ah]                  ; 0f b6 56 e6                 ; 0xc1f50
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1f54
    call 019a8h                               ; e8 4d fa                    ; 0xc1f58
    jmp short 01f7fh                          ; eb 22                       ; 0xc1f5b vgabios.c:1413
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1f5d vgabios.c:1414
    push ax                                   ; 50                          ; 0xc1f61
    movzx ax, byte [bp-014h]                  ; 0f b6 46 ec                 ; 0xc1f62
    push ax                                   ; 50                          ; 0xc1f66
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1f67
    movzx bx, byte [bp-01ah]                  ; 0f b6 5e e6                 ; 0xc1f6b
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc1f6f
    add al, byte [bp-00eh]                    ; 02 46 f2                    ; 0xc1f72
    movzx dx, al                              ; 0f b6 d0                    ; 0xc1f75
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1f78
    call 01905h                               ; e8 86 f9                    ; 0xc1f7c
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc1f7f vgabios.c:1415
    jmp short 01f22h                          ; eb 9e                       ; 0xc1f82
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1f84 vgabios.c:1418
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1f88
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc1f8b
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1f8f
    jnbe near 02117h                          ; 0f 87 81 01                 ; 0xc1f92
    movzx dx, byte [bp-008h]                  ; 0f b6 56 f8                 ; 0xc1f96 vgabios.c:1420
    movzx ax, byte [bp-00eh]                  ; 0f b6 46 f2                 ; 0xc1f9a
    add ax, dx                                ; 01 d0                       ; 0xc1f9e
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1fa0
    jnbe short 01fabh                         ; 77 06                       ; 0xc1fa3
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1fa5
    jne short 01fcah                          ; 75 1f                       ; 0xc1fa9
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc1fab vgabios.c:1421
    push ax                                   ; 50                          ; 0xc1faf
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1fb0
    push ax                                   ; 50                          ; 0xc1fb4
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc1fb5
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc1fb9
    movzx dx, byte [bp-01ah]                  ; 0f b6 56 e6                 ; 0xc1fbd
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1fc1
    call 019a8h                               ; e8 e0 f9                    ; 0xc1fc5
    jmp short 01fech                          ; eb 22                       ; 0xc1fc8 vgabios.c:1422
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc1fca vgabios.c:1423
    push ax                                   ; 50                          ; 0xc1fce
    movzx ax, byte [bp-014h]                  ; 0f b6 46 ec                 ; 0xc1fcf
    push ax                                   ; 50                          ; 0xc1fd3
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc1fd4
    movzx bx, byte [bp-01ah]                  ; 0f b6 5e e6                 ; 0xc1fd8
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc1fdc
    sub al, byte [bp-00eh]                    ; 2a 46 f2                    ; 0xc1fdf
    movzx dx, al                              ; 0f b6 d0                    ; 0xc1fe2
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc1fe5
    call 01905h                               ; e8 19 f9                    ; 0xc1fe9
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc1fec vgabios.c:1424
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1ff0
    jc near 02117h                            ; 0f 82 20 01                 ; 0xc1ff3
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc1ff7 vgabios.c:1425
    jmp short 01f8bh                          ; eb 8f                       ; 0xc1ffa
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1ffc vgabios.c:1430
    jne short 0203ah                          ; 75 38                       ; 0xc2000
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc2002
    jne short 0203ah                          ; 75 32                       ; 0xc2006
    cmp byte [bp-010h], 000h                  ; 80 7e f0 00                 ; 0xc2008
    jne short 0203ah                          ; 75 2c                       ; 0xc200c
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc200e
    cmp ax, word [bp-018h]                    ; 3b 46 e8                    ; 0xc2012
    jne short 0203ah                          ; 75 23                       ; 0xc2015
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc2017
    cmp ax, word [bp-01ch]                    ; 3b 46 e4                    ; 0xc201a
    jne short 0203ah                          ; 75 1b                       ; 0xc201d
    movzx cx, byte [bp-00ah]                  ; 0f b6 4e f6                 ; 0xc201f vgabios.c:1432
    imul cx, si                               ; 0f af ce                    ; 0xc2023
    sal cx, 003h                              ; c1 e1 03                    ; 0xc2026
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc2029
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc202d
    xor di, di                                ; 31 ff                       ; 0xc2031
    jcxz 02037h                               ; e3 02                       ; 0xc2033
    rep stosb                                 ; f3 aa                       ; 0xc2035
    jmp near 02117h                           ; e9 dd 00                    ; 0xc2037 vgabios.c:1434
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc203a vgabios.c:1437
    jne short 020a6h                          ; 75 66                       ; 0xc203e
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc2040 vgabios.c:1438
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc2044
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc2047
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc204b
    jc near 02117h                            ; 0f 82 c5 00                 ; 0xc204e
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc2052 vgabios.c:1440
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc2056
    cmp dx, ax                                ; 39 c2                       ; 0xc2059
    jnbe short 02063h                         ; 77 06                       ; 0xc205b
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc205d
    jne short 02081h                          ; 75 1e                       ; 0xc2061
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc2063 vgabios.c:1441
    push ax                                   ; 50                          ; 0xc2067
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc2068
    push ax                                   ; 50                          ; 0xc206c
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc206d
    movzx dx, byte [bp-01ah]                  ; 0f b6 56 e6                 ; 0xc2071
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc2075
    mov cx, word [bp-014h]                    ; 8b 4e ec                    ; 0xc2079
    call 01aa2h                               ; e8 23 fa                    ; 0xc207c
    jmp short 020a1h                          ; eb 20                       ; 0xc207f vgabios.c:1442
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc2081 vgabios.c:1443
    push ax                                   ; 50                          ; 0xc2085
    push word [bp-014h]                       ; ff 76 ec                    ; 0xc2086
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc2089
    movzx bx, byte [bp-01ah]                  ; 0f b6 5e e6                 ; 0xc208d
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc2091
    add al, byte [bp-00eh]                    ; 02 46 f2                    ; 0xc2094
    movzx dx, al                              ; 0f b6 d0                    ; 0xc2097
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc209a
    call 01a29h                               ; e8 88 f9                    ; 0xc209e
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc20a1 vgabios.c:1444
    jmp short 02047h                          ; eb a1                       ; 0xc20a4
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc20a6 vgabios.c:1447
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc20aa
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc20ad
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc20b1
    jnbe short 02117h                         ; 77 61                       ; 0xc20b4
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc20b6 vgabios.c:1449
    movzx dx, byte [bp-00eh]                  ; 0f b6 56 f2                 ; 0xc20ba
    add ax, dx                                ; 01 d0                       ; 0xc20be
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc20c0
    jnbe short 020cbh                         ; 77 06                       ; 0xc20c3
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc20c5
    jne short 020e9h                          ; 75 1e                       ; 0xc20c9
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc20cb vgabios.c:1450
    push ax                                   ; 50                          ; 0xc20cf
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc20d0
    push ax                                   ; 50                          ; 0xc20d4
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc20d5
    movzx dx, byte [bp-01ah]                  ; 0f b6 56 e6                 ; 0xc20d9
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc20dd
    mov cx, word [bp-014h]                    ; 8b 4e ec                    ; 0xc20e1
    call 01aa2h                               ; e8 bb f9                    ; 0xc20e4
    jmp short 02109h                          ; eb 20                       ; 0xc20e7 vgabios.c:1451
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc20e9 vgabios.c:1452
    push ax                                   ; 50                          ; 0xc20ed
    push word [bp-014h]                       ; ff 76 ec                    ; 0xc20ee
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc20f1
    movzx bx, byte [bp-01ah]                  ; 0f b6 5e e6                 ; 0xc20f5
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc20f9
    sub al, byte [bp-00eh]                    ; 2a 46 f2                    ; 0xc20fc
    movzx dx, al                              ; 0f b6 d0                    ; 0xc20ff
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc2102
    call 01a29h                               ; e8 20 f9                    ; 0xc2106
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc2109 vgabios.c:1453
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc210d
    jc short 02117h                           ; 72 05                       ; 0xc2110
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc2112 vgabios.c:1454
    jmp short 020adh                          ; eb 96                       ; 0xc2115
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2117 vgabios.c:1465
    pop di                                    ; 5f                          ; 0xc211a
    pop si                                    ; 5e                          ; 0xc211b
    pop bp                                    ; 5d                          ; 0xc211c
    retn 00008h                               ; c2 08 00                    ; 0xc211d
  ; disGetNextSymbol 0xc2120 LB 0x2124 -> off=0x0 cb=00000000000000ff uValue=00000000000c2120 'write_gfx_char_pl4'
write_gfx_char_pl4:                          ; 0xc2120 LB 0xff
    push bp                                   ; 55                          ; 0xc2120 vgabios.c:1468
    mov bp, sp                                ; 89 e5                       ; 0xc2121
    push si                                   ; 56                          ; 0xc2123
    push di                                   ; 57                          ; 0xc2124
    sub sp, strict byte 0000ch                ; 83 ec 0c                    ; 0xc2125
    mov ah, al                                ; 88 c4                       ; 0xc2128
    mov byte [bp-008h], dl                    ; 88 56 f8                    ; 0xc212a
    mov al, bl                                ; 88 d8                       ; 0xc212d
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc212f vgabios.c:67
    xor si, si                                ; 31 f6                       ; 0xc2132
    mov es, si                                ; 8e c6                       ; 0xc2134
    mov si, word [es:bx]                      ; 26 8b 37                    ; 0xc2136
    mov bx, word [es:bx+002h]                 ; 26 8b 5f 02                 ; 0xc2139
    mov word [bp-00ch], si                    ; 89 76 f4                    ; 0xc213d vgabios.c:68
    mov word [bp-00ah], bx                    ; 89 5e f6                    ; 0xc2140
    movzx bx, cl                              ; 0f b6 d9                    ; 0xc2143 vgabios.c:1477
    movzx cx, byte [bp+006h]                  ; 0f b6 4e 06                 ; 0xc2146
    imul bx, cx                               ; 0f af d9                    ; 0xc214a
    movzx si, byte [bp+004h]                  ; 0f b6 76 04                 ; 0xc214d
    imul si, bx                               ; 0f af f3                    ; 0xc2151
    movzx bx, al                              ; 0f b6 d8                    ; 0xc2154
    add si, bx                                ; 01 de                       ; 0xc2157
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc2159 vgabios.c:57
    mov di, strict word 00040h                ; bf 40 00                    ; 0xc215c
    mov es, di                                ; 8e c7                       ; 0xc215f
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc2161
    movzx di, byte [bp+008h]                  ; 0f b6 7e 08                 ; 0xc2164 vgabios.c:58
    imul bx, di                               ; 0f af df                    ; 0xc2168
    add si, bx                                ; 01 de                       ; 0xc216b
    movzx ax, ah                              ; 0f b6 c4                    ; 0xc216d vgabios.c:1479
    imul ax, cx                               ; 0f af c1                    ; 0xc2170
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc2173
    mov ax, 00f02h                            ; b8 02 0f                    ; 0xc2176 vgabios.c:1480
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2179
    out DX, ax                                ; ef                          ; 0xc217c
    mov ax, 00205h                            ; b8 05 02                    ; 0xc217d vgabios.c:1481
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2180
    out DX, ax                                ; ef                          ; 0xc2183
    test byte [bp-008h], 080h                 ; f6 46 f8 80                 ; 0xc2184 vgabios.c:1482
    je short 02190h                           ; 74 06                       ; 0xc2188
    mov ax, 01803h                            ; b8 03 18                    ; 0xc218a vgabios.c:1484
    out DX, ax                                ; ef                          ; 0xc218d
    jmp short 02194h                          ; eb 04                       ; 0xc218e vgabios.c:1486
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc2190 vgabios.c:1488
    out DX, ax                                ; ef                          ; 0xc2193
    xor ch, ch                                ; 30 ed                       ; 0xc2194 vgabios.c:1490
    cmp ch, byte [bp+006h]                    ; 3a 6e 06                    ; 0xc2196
    jnc short 02207h                          ; 73 6c                       ; 0xc2199
    movzx bx, ch                              ; 0f b6 dd                    ; 0xc219b vgabios.c:1492
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc219e
    imul bx, ax                               ; 0f af d8                    ; 0xc21a2
    add bx, si                                ; 01 f3                       ; 0xc21a5
    mov byte [bp-006h], 000h                  ; c6 46 fa 00                 ; 0xc21a7 vgabios.c:1493
    jmp short 021bfh                          ; eb 12                       ; 0xc21ab
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc21ad vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc21b0
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc21b2
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc21b6 vgabios.c:1506
    cmp byte [bp-006h], 008h                  ; 80 7e fa 08                 ; 0xc21b9
    jnc short 02203h                          ; 73 44                       ; 0xc21bd
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc21bf
    mov cl, al                                ; 88 c1                       ; 0xc21c3
    mov ax, 00080h                            ; b8 80 00                    ; 0xc21c5
    sar ax, CL                                ; d3 f8                       ; 0xc21c8
    xor ah, ah                                ; 30 e4                       ; 0xc21ca
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc21cc
    sal ax, 008h                              ; c1 e0 08                    ; 0xc21cf
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc21d2
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc21d4
    out DX, ax                                ; ef                          ; 0xc21d7
    mov dx, bx                                ; 89 da                       ; 0xc21d8
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc21da
    call 03596h                               ; e8 b6 13                    ; 0xc21dd
    movzx ax, ch                              ; 0f b6 c5                    ; 0xc21e0
    add ax, word [bp-00eh]                    ; 03 46 f2                    ; 0xc21e3
    les di, [bp-00ch]                         ; c4 7e f4                    ; 0xc21e6
    add di, ax                                ; 01 c7                       ; 0xc21e9
    movzx ax, byte [es:di]                    ; 26 0f b6 05                 ; 0xc21eb
    test word [bp-010h], ax                   ; 85 46 f0                    ; 0xc21ef
    je short 021adh                           ; 74 b9                       ; 0xc21f2
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc21f4
    and AL, strict byte 00fh                  ; 24 0f                       ; 0xc21f7
    mov di, 0a000h                            ; bf 00 a0                    ; 0xc21f9
    mov es, di                                ; 8e c7                       ; 0xc21fc
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc21fe
    jmp short 021b6h                          ; eb b3                       ; 0xc2201
    db  0feh, 0c5h
    ; inc ch                                    ; fe c5                     ; 0xc2203 vgabios.c:1507
    jmp short 02196h                          ; eb 8f                       ; 0xc2205
    mov ax, 0ff08h                            ; b8 08 ff                    ; 0xc2207 vgabios.c:1508
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc220a
    out DX, ax                                ; ef                          ; 0xc220d
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc220e vgabios.c:1509
    out DX, ax                                ; ef                          ; 0xc2211
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc2212 vgabios.c:1510
    out DX, ax                                ; ef                          ; 0xc2215
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2216 vgabios.c:1511
    pop di                                    ; 5f                          ; 0xc2219
    pop si                                    ; 5e                          ; 0xc221a
    pop bp                                    ; 5d                          ; 0xc221b
    retn 00006h                               ; c2 06 00                    ; 0xc221c
  ; disGetNextSymbol 0xc221f LB 0x2025 -> off=0x0 cb=00000000000000dd uValue=00000000000c221f 'write_gfx_char_cga'
write_gfx_char_cga:                          ; 0xc221f LB 0xdd
    push si                                   ; 56                          ; 0xc221f vgabios.c:1514
    push di                                   ; 57                          ; 0xc2220
    enter 00006h, 000h                        ; c8 06 00 00                 ; 0xc2221
    mov di, 0556ah                            ; bf 6a 55                    ; 0xc2225 vgabios.c:1521
    xor bh, bh                                ; 30 ff                       ; 0xc2228 vgabios.c:1522
    movzx si, byte [bp+00ah]                  ; 0f b6 76 0a                 ; 0xc222a
    imul si, bx                               ; 0f af f3                    ; 0xc222e
    movzx bx, cl                              ; 0f b6 d9                    ; 0xc2231
    imul bx, bx, 00140h                       ; 69 db 40 01                 ; 0xc2234
    add si, bx                                ; 01 de                       ; 0xc2238
    mov word [bp-004h], si                    ; 89 76 fc                    ; 0xc223a
    xor ah, ah                                ; 30 e4                       ; 0xc223d vgabios.c:1523
    sal ax, 003h                              ; c1 e0 03                    ; 0xc223f
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc2242
    xor ah, ah                                ; 30 e4                       ; 0xc2245 vgabios.c:1524
    jmp near 02265h                           ; e9 1b 00                    ; 0xc2247
    movzx si, ah                              ; 0f b6 f4                    ; 0xc224a vgabios.c:1539
    add si, word [bp-006h]                    ; 03 76 fa                    ; 0xc224d
    add si, di                                ; 01 fe                       ; 0xc2250
    mov al, byte [si]                         ; 8a 04                       ; 0xc2252
    mov si, 0b800h                            ; be 00 b8                    ; 0xc2254 vgabios.c:52
    mov es, si                                ; 8e c6                       ; 0xc2257
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2259
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc225c vgabios.c:1543
    cmp ah, 008h                              ; 80 fc 08                    ; 0xc225e
    jnc near 022f6h                           ; 0f 83 91 00                 ; 0xc2261
    movzx bx, ah                              ; 0f b6 dc                    ; 0xc2265
    sar bx, 1                                 ; d1 fb                       ; 0xc2268
    imul bx, bx, strict byte 00050h           ; 6b db 50                    ; 0xc226a
    add bx, word [bp-004h]                    ; 03 5e fc                    ; 0xc226d
    test ah, 001h                             ; f6 c4 01                    ; 0xc2270
    je short 02278h                           ; 74 03                       ; 0xc2273
    add bh, 020h                              ; 80 c7 20                    ; 0xc2275
    mov DH, strict byte 080h                  ; b6 80                       ; 0xc2278
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc227a
    jne short 02298h                          ; 75 18                       ; 0xc227e
    test dl, dh                               ; 84 f2                       ; 0xc2280
    je short 0224ah                           ; 74 c6                       ; 0xc2282
    mov si, 0b800h                            ; be 00 b8                    ; 0xc2284
    mov es, si                                ; 8e c6                       ; 0xc2287
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2289
    movzx si, ah                              ; 0f b6 f4                    ; 0xc228c
    add si, word [bp-006h]                    ; 03 76 fa                    ; 0xc228f
    add si, di                                ; 01 fe                       ; 0xc2292
    xor al, byte [si]                         ; 32 04                       ; 0xc2294
    jmp short 02254h                          ; eb bc                       ; 0xc2296
    test dh, dh                               ; 84 f6                       ; 0xc2298 vgabios.c:1545
    jbe short 0225ch                          ; 76 c0                       ; 0xc229a
    test dl, 080h                             ; f6 c2 80                    ; 0xc229c vgabios.c:1547
    je short 022abh                           ; 74 0a                       ; 0xc229f
    mov si, 0b800h                            ; be 00 b8                    ; 0xc22a1 vgabios.c:47
    mov es, si                                ; 8e c6                       ; 0xc22a4
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc22a6
    jmp short 022adh                          ; eb 02                       ; 0xc22a9 vgabios.c:1551
    xor al, al                                ; 30 c0                       ; 0xc22ab vgabios.c:1553
    mov byte [bp-002h], 000h                  ; c6 46 fe 00                 ; 0xc22ad vgabios.c:1555
    jmp short 022c0h                          ; eb 0d                       ; 0xc22b1
    or al, ch                                 ; 08 e8                       ; 0xc22b3 vgabios.c:1565
    shr dh, 1                                 ; d0 ee                       ; 0xc22b5 vgabios.c:1568
    inc byte [bp-002h]                        ; fe 46 fe                    ; 0xc22b7 vgabios.c:1569
    cmp byte [bp-002h], 004h                  ; 80 7e fe 04                 ; 0xc22ba
    jnc short 022ebh                          ; 73 2b                       ; 0xc22be
    movzx si, ah                              ; 0f b6 f4                    ; 0xc22c0
    add si, word [bp-006h]                    ; 03 76 fa                    ; 0xc22c3
    add si, di                                ; 01 fe                       ; 0xc22c6
    movzx si, byte [si]                       ; 0f b6 34                    ; 0xc22c8
    movzx cx, dh                              ; 0f b6 ce                    ; 0xc22cb
    test si, cx                               ; 85 ce                       ; 0xc22ce
    je short 022b5h                           ; 74 e3                       ; 0xc22d0
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc22d2
    sub cl, byte [bp-002h]                    ; 2a 4e fe                    ; 0xc22d4
    mov ch, dl                                ; 88 d5                       ; 0xc22d7
    and ch, 003h                              ; 80 e5 03                    ; 0xc22d9
    add cl, cl                                ; 00 c9                       ; 0xc22dc
    sal ch, CL                                ; d2 e5                       ; 0xc22de
    mov cl, ch                                ; 88 e9                       ; 0xc22e0
    test dl, 080h                             ; f6 c2 80                    ; 0xc22e2
    je short 022b3h                           ; 74 cc                       ; 0xc22e5
    xor al, ch                                ; 30 e8                       ; 0xc22e7
    jmp short 022b5h                          ; eb ca                       ; 0xc22e9
    mov cx, 0b800h                            ; b9 00 b8                    ; 0xc22eb vgabios.c:52
    mov es, cx                                ; 8e c1                       ; 0xc22ee
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc22f0
    inc bx                                    ; 43                          ; 0xc22f3 vgabios.c:1571
    jmp short 02298h                          ; eb a2                       ; 0xc22f4 vgabios.c:1572
    leave                                     ; c9                          ; 0xc22f6 vgabios.c:1575
    pop di                                    ; 5f                          ; 0xc22f7
    pop si                                    ; 5e                          ; 0xc22f8
    retn 00004h                               ; c2 04 00                    ; 0xc22f9
  ; disGetNextSymbol 0xc22fc LB 0x1f48 -> off=0x0 cb=0000000000000085 uValue=00000000000c22fc 'write_gfx_char_lin'
write_gfx_char_lin:                          ; 0xc22fc LB 0x85
    push si                                   ; 56                          ; 0xc22fc vgabios.c:1578
    push di                                   ; 57                          ; 0xc22fd
    enter 00006h, 000h                        ; c8 06 00 00                 ; 0xc22fe
    mov dh, dl                                ; 88 d6                       ; 0xc2302
    mov word [bp-002h], 0556ah                ; c7 46 fe 6a 55              ; 0xc2304 vgabios.c:1585
    movzx si, cl                              ; 0f b6 f1                    ; 0xc2309 vgabios.c:1586
    movzx cx, byte [bp+008h]                  ; 0f b6 4e 08                 ; 0xc230c
    imul cx, si                               ; 0f af ce                    ; 0xc2310
    sal cx, 006h                              ; c1 e1 06                    ; 0xc2313
    xor bh, bh                                ; 30 ff                       ; 0xc2316
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2318
    add bx, cx                                ; 01 cb                       ; 0xc231b
    mov word [bp-004h], bx                    ; 89 5e fc                    ; 0xc231d
    xor ah, ah                                ; 30 e4                       ; 0xc2320 vgabios.c:1587
    mov si, ax                                ; 89 c6                       ; 0xc2322
    sal si, 003h                              ; c1 e6 03                    ; 0xc2324
    xor al, al                                ; 30 c0                       ; 0xc2327 vgabios.c:1588
    jmp short 02360h                          ; eb 35                       ; 0xc2329
    cmp ah, 008h                              ; 80 fc 08                    ; 0xc232b vgabios.c:1592
    jnc short 0235ah                          ; 73 2a                       ; 0xc232e
    xor cl, cl                                ; 30 c9                       ; 0xc2330 vgabios.c:1594
    movzx bx, al                              ; 0f b6 d8                    ; 0xc2332 vgabios.c:1595
    add bx, si                                ; 01 f3                       ; 0xc2335
    add bx, word [bp-002h]                    ; 03 5e fe                    ; 0xc2337
    movzx bx, byte [bx]                       ; 0f b6 1f                    ; 0xc233a
    movzx di, dl                              ; 0f b6 fa                    ; 0xc233d
    test bx, di                               ; 85 fb                       ; 0xc2340
    je short 02346h                           ; 74 02                       ; 0xc2342
    mov cl, dh                                ; 88 f1                       ; 0xc2344 vgabios.c:1597
    movzx bx, ah                              ; 0f b6 dc                    ; 0xc2346 vgabios.c:1599
    add bx, word [bp-006h]                    ; 03 5e fa                    ; 0xc2349
    mov di, 0a000h                            ; bf 00 a0                    ; 0xc234c vgabios.c:52
    mov es, di                                ; 8e c7                       ; 0xc234f
    mov byte [es:bx], cl                      ; 26 88 0f                    ; 0xc2351
    shr dl, 1                                 ; d0 ea                       ; 0xc2354 vgabios.c:1600
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc2356 vgabios.c:1601
    jmp short 0232bh                          ; eb d1                       ; 0xc2358
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc235a vgabios.c:1602
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc235c
    jnc short 0237bh                          ; 73 1b                       ; 0xc235e
    movzx cx, al                              ; 0f b6 c8                    ; 0xc2360
    movzx bx, byte [bp+008h]                  ; 0f b6 5e 08                 ; 0xc2363
    imul bx, cx                               ; 0f af d9                    ; 0xc2367
    sal bx, 003h                              ; c1 e3 03                    ; 0xc236a
    mov cx, word [bp-004h]                    ; 8b 4e fc                    ; 0xc236d
    add cx, bx                                ; 01 d9                       ; 0xc2370
    mov word [bp-006h], cx                    ; 89 4e fa                    ; 0xc2372
    mov DL, strict byte 080h                  ; b2 80                       ; 0xc2375
    xor ah, ah                                ; 30 e4                       ; 0xc2377
    jmp short 02330h                          ; eb b5                       ; 0xc2379
    leave                                     ; c9                          ; 0xc237b vgabios.c:1603
    pop di                                    ; 5f                          ; 0xc237c
    pop si                                    ; 5e                          ; 0xc237d
    retn 00002h                               ; c2 02 00                    ; 0xc237e
  ; disGetNextSymbol 0xc2381 LB 0x1ec3 -> off=0x0 cb=0000000000000157 uValue=00000000000c2381 'biosfn_write_char_attr'
biosfn_write_char_attr:                      ; 0xc2381 LB 0x157
    push bp                                   ; 55                          ; 0xc2381 vgabios.c:1606
    mov bp, sp                                ; 89 e5                       ; 0xc2382
    push si                                   ; 56                          ; 0xc2384
    push di                                   ; 57                          ; 0xc2385
    sub sp, strict byte 00018h                ; 83 ec 18                    ; 0xc2386
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc2389
    mov byte [bp-00eh], dl                    ; 88 56 f2                    ; 0xc238c
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc238f
    mov si, cx                                ; 89 ce                       ; 0xc2392
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2394 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2397
    mov es, ax                                ; 8e c0                       ; 0xc239a
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc239c
    xor ah, ah                                ; 30 e4                       ; 0xc239f vgabios.c:1614
    call 0356fh                               ; e8 cb 11                    ; 0xc23a1
    mov cl, al                                ; 88 c1                       ; 0xc23a4
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc23a6
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc23a9 vgabios.c:1615
    je near 024d1h                            ; 0f 84 22 01                 ; 0xc23ab
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc23af vgabios.c:1618
    lea bx, [bp-01ah]                         ; 8d 5e e6                    ; 0xc23b2
    lea dx, [bp-01ch]                         ; 8d 56 e4                    ; 0xc23b5
    call 00a93h                               ; e8 d8 e6                    ; 0xc23b8
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc23bb vgabios.c:1619
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc23be
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc23c1
    xor al, al                                ; 30 c0                       ; 0xc23c4
    shr ax, 008h                              ; c1 e8 08                    ; 0xc23c6
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc23c9
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc23cc vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc23cf
    mov es, dx                                ; 8e c2                       ; 0xc23d2
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc23d4
    mov word [bp-016h], dx                    ; 89 56 ea                    ; 0xc23d7
    mov word [bp-018h], dx                    ; 89 56 e8                    ; 0xc23da vgabios.c:58
    movzx bx, cl                              ; 0f b6 d9                    ; 0xc23dd vgabios.c:1625
    mov di, bx                                ; 89 df                       ; 0xc23e0
    sal di, 003h                              ; c1 e7 03                    ; 0xc23e2
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc23e5
    jne short 0242bh                          ; 75 3f                       ; 0xc23ea
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc23ec vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc23ef
    movzx bx, byte [bp-00eh]                  ; 0f b6 5e f2                 ; 0xc23f2 vgabios.c:58
    imul dx, bx                               ; 0f af d3                    ; 0xc23f6
    xor ah, ah                                ; 30 e4                       ; 0xc23f9 vgabios.c:1629
    imul ax, word [bp-016h]                   ; 0f af 46 ea                 ; 0xc23fb
    movzx bx, byte [bp-010h]                  ; 0f b6 5e f0                 ; 0xc23ff
    add ax, bx                                ; 01 d8                       ; 0xc2403
    add ax, ax                                ; 01 c0                       ; 0xc2405
    add dx, ax                                ; 01 c2                       ; 0xc2407
    movzx bx, byte [bp-006h]                  ; 0f b6 5e fa                 ; 0xc2409 vgabios.c:1631
    sal bx, 008h                              ; c1 e3 08                    ; 0xc240d
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc2410
    add bx, ax                                ; 01 c3                       ; 0xc2414
    mov word [bp-01ch], bx                    ; 89 5e e4                    ; 0xc2416
    mov ax, word [bp-01ch]                    ; 8b 46 e4                    ; 0xc2419 vgabios.c:1632
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc241c
    mov cx, si                                ; 89 f1                       ; 0xc2420
    mov di, dx                                ; 89 d7                       ; 0xc2422
    jcxz 02428h                               ; e3 02                       ; 0xc2424
    rep stosw                                 ; f3 ab                       ; 0xc2426
    jmp near 024d1h                           ; e9 a6 00                    ; 0xc2428 vgabios.c:1634
    movzx ax, byte [bx+0482ch]                ; 0f b6 87 2c 48              ; 0xc242b vgabios.c:1637
    mov bx, ax                                ; 89 c3                       ; 0xc2430
    sal bx, 006h                              ; c1 e3 06                    ; 0xc2432
    mov al, byte [bx+04842h]                  ; 8a 87 42 48                 ; 0xc2435
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc2439
    mov al, byte [di+047afh]                  ; 8a 85 af 47                 ; 0xc243c vgabios.c:1638
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2440
    dec si                                    ; 4e                          ; 0xc2443 vgabios.c:1639
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2444
    je near 024d1h                            ; 0f 84 86 00                 ; 0xc2447
    movzx di, byte [bp-00ah]                  ; 0f b6 7e f6                 ; 0xc244b vgabios.c:1641
    sal di, 003h                              ; c1 e7 03                    ; 0xc244f
    mov al, byte [di+047aeh]                  ; 8a 85 ae 47                 ; 0xc2452
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc2456
    jc short 02466h                           ; 72 0c                       ; 0xc2458
    jbe short 0246ch                          ; 76 10                       ; 0xc245a
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc245c
    je short 024b3h                           ; 74 53                       ; 0xc245e
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc2460
    je short 02470h                           ; 74 0c                       ; 0xc2462
    jmp short 024cbh                          ; eb 65                       ; 0xc2464
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc2466
    je short 02494h                           ; 74 2a                       ; 0xc2468
    jmp short 024cbh                          ; eb 5f                       ; 0xc246a
    or byte [bp-006h], 001h                   ; 80 4e fa 01                 ; 0xc246c vgabios.c:1644
    movzx ax, byte [bp-00eh]                  ; 0f b6 46 f2                 ; 0xc2470 vgabios.c:1646
    push ax                                   ; 50                          ; 0xc2474
    movzx ax, byte [bp-00ch]                  ; 0f b6 46 f4                 ; 0xc2475
    push ax                                   ; 50                          ; 0xc2479
    movzx ax, byte [bp-018h]                  ; 0f b6 46 e8                 ; 0xc247a
    push ax                                   ; 50                          ; 0xc247e
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc247f
    movzx bx, byte [bp-010h]                  ; 0f b6 5e f0                 ; 0xc2483
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc2487
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc248b
    call 02120h                               ; e8 8e fc                    ; 0xc248f
    jmp short 024cbh                          ; eb 37                       ; 0xc2492 vgabios.c:1647
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc2494 vgabios.c:1649
    push ax                                   ; 50                          ; 0xc2498
    movzx ax, byte [bp-018h]                  ; 0f b6 46 e8                 ; 0xc2499
    push ax                                   ; 50                          ; 0xc249d
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc249e
    movzx bx, byte [bp-010h]                  ; 0f b6 5e f0                 ; 0xc24a2
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc24a6
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc24aa
    call 0221fh                               ; e8 6e fd                    ; 0xc24ae
    jmp short 024cbh                          ; eb 18                       ; 0xc24b1 vgabios.c:1650
    movzx ax, byte [bp-018h]                  ; 0f b6 46 e8                 ; 0xc24b3 vgabios.c:1652
    push ax                                   ; 50                          ; 0xc24b7
    movzx cx, byte [bp-014h]                  ; 0f b6 4e ec                 ; 0xc24b8
    movzx bx, byte [bp-010h]                  ; 0f b6 5e f0                 ; 0xc24bc
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc24c0
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc24c4
    call 022fch                               ; e8 31 fe                    ; 0xc24c8
    inc byte [bp-010h]                        ; fe 46 f0                    ; 0xc24cb vgabios.c:1659
    jmp near 02443h                           ; e9 72 ff                    ; 0xc24ce vgabios.c:1660
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc24d1 vgabios.c:1662
    pop di                                    ; 5f                          ; 0xc24d4
    pop si                                    ; 5e                          ; 0xc24d5
    pop bp                                    ; 5d                          ; 0xc24d6
    retn                                      ; c3                          ; 0xc24d7
  ; disGetNextSymbol 0xc24d8 LB 0x1d6c -> off=0x0 cb=0000000000000152 uValue=00000000000c24d8 'biosfn_write_char_only'
biosfn_write_char_only:                      ; 0xc24d8 LB 0x152
    push bp                                   ; 55                          ; 0xc24d8 vgabios.c:1665
    mov bp, sp                                ; 89 e5                       ; 0xc24d9
    push si                                   ; 56                          ; 0xc24db
    push di                                   ; 57                          ; 0xc24dc
    sub sp, strict byte 00016h                ; 83 ec 16                    ; 0xc24dd
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc24e0
    mov byte [bp-012h], dl                    ; 88 56 ee                    ; 0xc24e3
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc24e6
    mov si, cx                                ; 89 ce                       ; 0xc24e9
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc24eb vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc24ee
    mov es, ax                                ; 8e c0                       ; 0xc24f1
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc24f3
    xor ah, ah                                ; 30 e4                       ; 0xc24f6 vgabios.c:1673
    call 0356fh                               ; e8 74 10                    ; 0xc24f8
    mov cl, al                                ; 88 c1                       ; 0xc24fb
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc24fd
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc2500 vgabios.c:1674
    je near 02623h                            ; 0f 84 1d 01                 ; 0xc2502
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc2506 vgabios.c:1677
    lea bx, [bp-01ah]                         ; 8d 5e e6                    ; 0xc2509
    lea dx, [bp-018h]                         ; 8d 56 e8                    ; 0xc250c
    call 00a93h                               ; e8 81 e5                    ; 0xc250f
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc2512 vgabios.c:1678
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc2515
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc2518
    xor al, al                                ; 30 c0                       ; 0xc251b
    shr ax, 008h                              ; c1 e8 08                    ; 0xc251d
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc2520
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2523 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc2526
    mov es, dx                                ; 8e c2                       ; 0xc2529
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc252b
    mov word [bp-016h], dx                    ; 89 56 ea                    ; 0xc252e vgabios.c:58
    movzx di, cl                              ; 0f b6 f9                    ; 0xc2531 vgabios.c:1684
    mov bx, di                                ; 89 fb                       ; 0xc2534
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2536
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2539
    jne short 02579h                          ; 75 39                       ; 0xc253e
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc2540 vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc2543
    movzx cx, byte [bp-012h]                  ; 0f b6 4e ee                 ; 0xc2546 vgabios.c:58
    imul bx, cx                               ; 0f af d9                    ; 0xc254a
    xor ah, ah                                ; 30 e4                       ; 0xc254d vgabios.c:1688
    imul dx, ax                               ; 0f af d0                    ; 0xc254f
    movzx ax, byte [bp-00eh]                  ; 0f b6 46 f2                 ; 0xc2552
    add ax, dx                                ; 01 d0                       ; 0xc2556
    add ax, ax                                ; 01 c0                       ; 0xc2558
    add bx, ax                                ; 01 c3                       ; 0xc255a
    dec si                                    ; 4e                          ; 0xc255c vgabios.c:1690
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc255d
    je near 02623h                            ; 0f 84 bf 00                 ; 0xc2560
    movzx di, byte [bp-014h]                  ; 0f b6 7e ec                 ; 0xc2564 vgabios.c:1691
    sal di, 003h                              ; c1 e7 03                    ; 0xc2568
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc256b vgabios.c:50
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc256f
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2572
    inc bx                                    ; 43                          ; 0xc2575 vgabios.c:1692
    inc bx                                    ; 43                          ; 0xc2576
    jmp short 0255ch                          ; eb e3                       ; 0xc2577 vgabios.c:1693
    movzx ax, byte [di+0482ch]                ; 0f b6 85 2c 48              ; 0xc2579 vgabios.c:1698
    mov di, ax                                ; 89 c7                       ; 0xc257e
    sal di, 006h                              ; c1 e7 06                    ; 0xc2580
    mov al, byte [di+04842h]                  ; 8a 85 42 48                 ; 0xc2583
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc2587
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc258a vgabios.c:1699
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc258e
    dec si                                    ; 4e                          ; 0xc2591 vgabios.c:1700
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2592
    je near 02623h                            ; 0f 84 8a 00                 ; 0xc2595
    movzx bx, byte [bp-014h]                  ; 0f b6 5e ec                 ; 0xc2599 vgabios.c:1702
    sal bx, 003h                              ; c1 e3 03                    ; 0xc259d
    mov bl, byte [bx+047aeh]                  ; 8a 9f ae 47                 ; 0xc25a0
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc25a4
    jc short 025b7h                           ; 72 0e                       ; 0xc25a7
    jbe short 025beh                          ; 76 13                       ; 0xc25a9
    cmp bl, 005h                              ; 80 fb 05                    ; 0xc25ab
    je short 02605h                           ; 74 55                       ; 0xc25ae
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc25b0
    je short 025c2h                           ; 74 0d                       ; 0xc25b3
    jmp short 0261dh                          ; eb 66                       ; 0xc25b5
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc25b7
    je short 025e6h                           ; 74 2a                       ; 0xc25ba
    jmp short 0261dh                          ; eb 5f                       ; 0xc25bc
    or byte [bp-00ah], 001h                   ; 80 4e f6 01                 ; 0xc25be vgabios.c:1705
    movzx ax, byte [bp-012h]                  ; 0f b6 46 ee                 ; 0xc25c2 vgabios.c:1707
    push ax                                   ; 50                          ; 0xc25c6
    movzx ax, byte [bp-00ch]                  ; 0f b6 46 f4                 ; 0xc25c7
    push ax                                   ; 50                          ; 0xc25cb
    movzx ax, byte [bp-016h]                  ; 0f b6 46 ea                 ; 0xc25cc
    push ax                                   ; 50                          ; 0xc25d0
    movzx cx, byte [bp-010h]                  ; 0f b6 4e f0                 ; 0xc25d1
    movzx bx, byte [bp-00eh]                  ; 0f b6 5e f2                 ; 0xc25d5
    movzx dx, byte [bp-00ah]                  ; 0f b6 56 f6                 ; 0xc25d9
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc25dd
    call 02120h                               ; e8 3c fb                    ; 0xc25e1
    jmp short 0261dh                          ; eb 37                       ; 0xc25e4 vgabios.c:1708
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc25e6 vgabios.c:1710
    push ax                                   ; 50                          ; 0xc25ea
    movzx ax, byte [bp-016h]                  ; 0f b6 46 ea                 ; 0xc25eb
    push ax                                   ; 50                          ; 0xc25ef
    movzx cx, byte [bp-010h]                  ; 0f b6 4e f0                 ; 0xc25f0
    movzx bx, byte [bp-00eh]                  ; 0f b6 5e f2                 ; 0xc25f4
    movzx dx, byte [bp-00ah]                  ; 0f b6 56 f6                 ; 0xc25f8
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc25fc
    call 0221fh                               ; e8 1c fc                    ; 0xc2600
    jmp short 0261dh                          ; eb 18                       ; 0xc2603 vgabios.c:1711
    movzx ax, byte [bp-016h]                  ; 0f b6 46 ea                 ; 0xc2605 vgabios.c:1713
    push ax                                   ; 50                          ; 0xc2609
    movzx cx, byte [bp-010h]                  ; 0f b6 4e f0                 ; 0xc260a
    movzx bx, byte [bp-00eh]                  ; 0f b6 5e f2                 ; 0xc260e
    movzx dx, byte [bp-00ah]                  ; 0f b6 56 f6                 ; 0xc2612
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc2616
    call 022fch                               ; e8 df fc                    ; 0xc261a
    inc byte [bp-00eh]                        ; fe 46 f2                    ; 0xc261d vgabios.c:1720
    jmp near 02591h                           ; e9 6e ff                    ; 0xc2620 vgabios.c:1721
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2623 vgabios.c:1723
    pop di                                    ; 5f                          ; 0xc2626
    pop si                                    ; 5e                          ; 0xc2627
    pop bp                                    ; 5d                          ; 0xc2628
    retn                                      ; c3                          ; 0xc2629
  ; disGetNextSymbol 0xc262a LB 0x1c1a -> off=0x0 cb=0000000000000165 uValue=00000000000c262a 'biosfn_write_pixel'
biosfn_write_pixel:                          ; 0xc262a LB 0x165
    push bp                                   ; 55                          ; 0xc262a vgabios.c:1726
    mov bp, sp                                ; 89 e5                       ; 0xc262b
    push si                                   ; 56                          ; 0xc262d
    push ax                                   ; 50                          ; 0xc262e
    push ax                                   ; 50                          ; 0xc262f
    mov byte [bp-004h], al                    ; 88 46 fc                    ; 0xc2630
    mov byte [bp-006h], dl                    ; 88 56 fa                    ; 0xc2633
    mov dx, bx                                ; 89 da                       ; 0xc2636
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2638 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc263b
    mov es, ax                                ; 8e c0                       ; 0xc263e
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2640
    xor ah, ah                                ; 30 e4                       ; 0xc2643 vgabios.c:1733
    call 0356fh                               ; e8 27 0f                    ; 0xc2645
    mov ah, al                                ; 88 c4                       ; 0xc2648
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc264a vgabios.c:1734
    je near 0276ah                            ; 0f 84 1a 01                 ; 0xc264c
    movzx bx, al                              ; 0f b6 d8                    ; 0xc2650 vgabios.c:1735
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2653
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2656
    je near 0276ah                            ; 0f 84 0b 01                 ; 0xc265b
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc265f vgabios.c:1737
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc2663
    jc short 02676h                           ; 72 0f                       ; 0xc2665
    jbe short 0267dh                          ; 76 14                       ; 0xc2667
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc2669
    je near 02770h                            ; 0f 84 01 01                 ; 0xc266b
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc266f
    je short 0267dh                           ; 74 0a                       ; 0xc2671
    jmp near 0276ah                           ; e9 f4 00                    ; 0xc2673
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc2676
    je short 026ech                           ; 74 72                       ; 0xc2678
    jmp near 0276ah                           ; e9 ed 00                    ; 0xc267a
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc267d vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2680
    mov es, ax                                ; 8e c0                       ; 0xc2683
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc2685
    imul ax, cx                               ; 0f af c1                    ; 0xc2688 vgabios.c:58
    mov bx, dx                                ; 89 d3                       ; 0xc268b
    shr bx, 003h                              ; c1 eb 03                    ; 0xc268d
    add bx, ax                                ; 01 c3                       ; 0xc2690
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2692 vgabios.c:57
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc2695
    movzx ax, byte [bp-004h]                  ; 0f b6 46 fc                 ; 0xc2698 vgabios.c:58
    imul ax, cx                               ; 0f af c1                    ; 0xc269c
    add bx, ax                                ; 01 c3                       ; 0xc269f
    mov cl, dl                                ; 88 d1                       ; 0xc26a1 vgabios.c:1743
    and cl, 007h                              ; 80 e1 07                    ; 0xc26a3
    mov ax, 00080h                            ; b8 80 00                    ; 0xc26a6
    sar ax, CL                                ; d3 f8                       ; 0xc26a9
    xor ah, ah                                ; 30 e4                       ; 0xc26ab vgabios.c:1744
    sal ax, 008h                              ; c1 e0 08                    ; 0xc26ad
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc26b0
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc26b2
    out DX, ax                                ; ef                          ; 0xc26b5
    mov ax, 00205h                            ; b8 05 02                    ; 0xc26b6 vgabios.c:1745
    out DX, ax                                ; ef                          ; 0xc26b9
    mov dx, bx                                ; 89 da                       ; 0xc26ba vgabios.c:1746
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc26bc
    call 03596h                               ; e8 d4 0e                    ; 0xc26bf
    test byte [bp-006h], 080h                 ; f6 46 fa 80                 ; 0xc26c2 vgabios.c:1747
    je short 026cfh                           ; 74 07                       ; 0xc26c6
    mov ax, 01803h                            ; b8 03 18                    ; 0xc26c8 vgabios.c:1749
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc26cb
    out DX, ax                                ; ef                          ; 0xc26ce
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc26cf vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc26d2
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc26d4
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc26d7
    mov ax, 0ff08h                            ; b8 08 ff                    ; 0xc26da vgabios.c:1752
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc26dd
    out DX, ax                                ; ef                          ; 0xc26e0
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc26e1 vgabios.c:1753
    out DX, ax                                ; ef                          ; 0xc26e4
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc26e5 vgabios.c:1754
    out DX, ax                                ; ef                          ; 0xc26e8
    jmp near 0276ah                           ; e9 7e 00                    ; 0xc26e9 vgabios.c:1755
    mov si, cx                                ; 89 ce                       ; 0xc26ec vgabios.c:1757
    shr si, 1                                 ; d1 ee                       ; 0xc26ee
    imul si, si, strict byte 00050h           ; 6b f6 50                    ; 0xc26f0
    cmp al, byte [bx+047afh]                  ; 3a 87 af 47                 ; 0xc26f3
    jne short 02700h                          ; 75 07                       ; 0xc26f7
    mov bx, dx                                ; 89 d3                       ; 0xc26f9 vgabios.c:1759
    shr bx, 002h                              ; c1 eb 02                    ; 0xc26fb
    jmp short 02705h                          ; eb 05                       ; 0xc26fe vgabios.c:1761
    mov bx, dx                                ; 89 d3                       ; 0xc2700 vgabios.c:1763
    shr bx, 003h                              ; c1 eb 03                    ; 0xc2702
    add bx, si                                ; 01 f3                       ; 0xc2705
    test cl, 001h                             ; f6 c1 01                    ; 0xc2707 vgabios.c:1765
    je short 0270fh                           ; 74 03                       ; 0xc270a
    add bh, 020h                              ; 80 c7 20                    ; 0xc270c
    mov cx, 0b800h                            ; b9 00 b8                    ; 0xc270f vgabios.c:47
    mov es, cx                                ; 8e c1                       ; 0xc2712
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2714
    movzx si, ah                              ; 0f b6 f4                    ; 0xc2717 vgabios.c:1767
    sal si, 003h                              ; c1 e6 03                    ; 0xc271a
    cmp byte [si+047afh], 002h                ; 80 bc af 47 02              ; 0xc271d
    jne short 0273bh                          ; 75 17                       ; 0xc2722
    mov ah, dl                                ; 88 d4                       ; 0xc2724 vgabios.c:1769
    and ah, 003h                              ; 80 e4 03                    ; 0xc2726
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2729
    sub cl, ah                                ; 28 e1                       ; 0xc272b
    add cl, cl                                ; 00 c9                       ; 0xc272d
    mov dh, byte [bp-006h]                    ; 8a 76 fa                    ; 0xc272f
    and dh, 003h                              ; 80 e6 03                    ; 0xc2732
    sal dh, CL                                ; d2 e6                       ; 0xc2735
    mov DL, strict byte 003h                  ; b2 03                       ; 0xc2737 vgabios.c:1770
    jmp short 0274eh                          ; eb 13                       ; 0xc2739 vgabios.c:1772
    mov ah, dl                                ; 88 d4                       ; 0xc273b vgabios.c:1774
    and ah, 007h                              ; 80 e4 07                    ; 0xc273d
    mov CL, strict byte 007h                  ; b1 07                       ; 0xc2740
    sub cl, ah                                ; 28 e1                       ; 0xc2742
    mov dh, byte [bp-006h]                    ; 8a 76 fa                    ; 0xc2744
    and dh, 001h                              ; 80 e6 01                    ; 0xc2747
    sal dh, CL                                ; d2 e6                       ; 0xc274a
    mov DL, strict byte 001h                  ; b2 01                       ; 0xc274c vgabios.c:1775
    sal dl, CL                                ; d2 e2                       ; 0xc274e
    test byte [bp-006h], 080h                 ; f6 46 fa 80                 ; 0xc2750 vgabios.c:1777
    je short 0275ah                           ; 74 04                       ; 0xc2754
    xor al, dh                                ; 30 f0                       ; 0xc2756 vgabios.c:1779
    jmp short 02762h                          ; eb 08                       ; 0xc2758 vgabios.c:1781
    mov ah, dl                                ; 88 d4                       ; 0xc275a vgabios.c:1783
    not ah                                    ; f6 d4                       ; 0xc275c
    and al, ah                                ; 20 e0                       ; 0xc275e
    or al, dh                                 ; 08 f0                       ; 0xc2760 vgabios.c:1784
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc2762 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc2765
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2767
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc276a vgabios.c:1787
    pop si                                    ; 5e                          ; 0xc276d
    pop bp                                    ; 5d                          ; 0xc276e
    retn                                      ; c3                          ; 0xc276f
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2770 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2773
    mov es, ax                                ; 8e c0                       ; 0xc2776
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc2778
    sal ax, 003h                              ; c1 e0 03                    ; 0xc277b vgabios.c:58
    imul ax, cx                               ; 0f af c1                    ; 0xc277e
    mov bx, dx                                ; 89 d3                       ; 0xc2781
    add bx, ax                                ; 01 c3                       ; 0xc2783
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2785 vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc2788
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc278a
    jmp short 02767h                          ; eb d8                       ; 0xc278d
  ; disGetNextSymbol 0xc278f LB 0x1ab5 -> off=0x0 cb=0000000000000240 uValue=00000000000c278f 'biosfn_write_teletype'
biosfn_write_teletype:                       ; 0xc278f LB 0x240
    push bp                                   ; 55                          ; 0xc278f vgabios.c:1800
    mov bp, sp                                ; 89 e5                       ; 0xc2790
    push si                                   ; 56                          ; 0xc2792
    sub sp, strict byte 00012h                ; 83 ec 12                    ; 0xc2793
    mov ch, al                                ; 88 c5                       ; 0xc2796
    mov byte [bp-004h], dl                    ; 88 56 fc                    ; 0xc2798
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc279b
    cmp dl, 0ffh                              ; 80 fa ff                    ; 0xc279e vgabios.c:1808
    jne short 027b1h                          ; 75 0e                       ; 0xc27a1
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc27a3 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc27a6
    mov es, ax                                ; 8e c0                       ; 0xc27a9
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc27ab
    mov byte [bp-004h], al                    ; 88 46 fc                    ; 0xc27ae vgabios.c:48
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc27b1 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc27b4
    mov es, ax                                ; 8e c0                       ; 0xc27b7
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc27b9
    xor ah, ah                                ; 30 e4                       ; 0xc27bc vgabios.c:1813
    call 0356fh                               ; e8 ae 0d                    ; 0xc27be
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc27c1
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc27c4 vgabios.c:1814
    je near 029c9h                            ; 0f 84 ff 01                 ; 0xc27c6
    movzx ax, byte [bp-004h]                  ; 0f b6 46 fc                 ; 0xc27ca vgabios.c:1817
    lea bx, [bp-012h]                         ; 8d 5e ee                    ; 0xc27ce
    lea dx, [bp-014h]                         ; 8d 56 ec                    ; 0xc27d1
    call 00a93h                               ; e8 bc e2                    ; 0xc27d4
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc27d7 vgabios.c:1818
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc27da
    mov ax, word [bp-012h]                    ; 8b 46 ee                    ; 0xc27dd
    xor al, al                                ; 30 c0                       ; 0xc27e0
    shr ax, 008h                              ; c1 e8 08                    ; 0xc27e2
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc27e5
    mov bx, 00084h                            ; bb 84 00                    ; 0xc27e8 vgabios.c:47
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc27eb
    mov es, dx                                ; 8e c2                       ; 0xc27ee
    mov dl, byte [es:bx]                      ; 26 8a 17                    ; 0xc27f0
    xor dh, dh                                ; 30 f6                       ; 0xc27f3 vgabios.c:48
    inc dx                                    ; 42                          ; 0xc27f5
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc27f6
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc27f9 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc27fc
    mov word [bp-010h], dx                    ; 89 56 f0                    ; 0xc27ff vgabios.c:58
    cmp ch, 008h                              ; 80 fd 08                    ; 0xc2802 vgabios.c:1824
    jc short 02815h                           ; 72 0e                       ; 0xc2805
    jbe short 0281eh                          ; 76 15                       ; 0xc2807
    cmp ch, 00dh                              ; 80 fd 0d                    ; 0xc2809
    je short 02834h                           ; 74 26                       ; 0xc280c
    cmp ch, 00ah                              ; 80 fd 0a                    ; 0xc280e
    je short 0282ch                           ; 74 19                       ; 0xc2811
    jmp short 0283bh                          ; eb 26                       ; 0xc2813
    cmp ch, 007h                              ; 80 fd 07                    ; 0xc2815
    je near 0292ch                            ; 0f 84 10 01                 ; 0xc2818
    jmp short 0283bh                          ; eb 1d                       ; 0xc281c
    cmp byte [bp-00ah], 000h                  ; 80 7e f6 00                 ; 0xc281e vgabios.c:1831
    jbe near 0292ch                           ; 0f 86 06 01                 ; 0xc2822
    dec byte [bp-00ah]                        ; fe 4e f6                    ; 0xc2826
    jmp near 0292ch                           ; e9 00 01                    ; 0xc2829 vgabios.c:1832
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc282c vgabios.c:1835
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc282e
    jmp near 0292ch                           ; e9 f8 00                    ; 0xc2831 vgabios.c:1836
    mov byte [bp-00ah], 000h                  ; c6 46 f6 00                 ; 0xc2834 vgabios.c:1839
    jmp near 0292ch                           ; e9 f1 00                    ; 0xc2838 vgabios.c:1840
    movzx si, byte [bp-008h]                  ; 0f b6 76 f8                 ; 0xc283b vgabios.c:1844
    mov bx, si                                ; 89 f3                       ; 0xc283f
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2841
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2844
    jne short 0288dh                          ; 75 42                       ; 0xc2849
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc284b vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc284e
    mov es, ax                                ; 8e c0                       ; 0xc2851
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc2853
    movzx ax, byte [bp-004h]                  ; 0f b6 46 fc                 ; 0xc2856 vgabios.c:58
    imul si, ax                               ; 0f af f0                    ; 0xc285a
    movzx ax, byte [bp-00ch]                  ; 0f b6 46 f4                 ; 0xc285d vgabios.c:1848
    mov dx, word [bp-010h]                    ; 8b 56 f0                    ; 0xc2861
    imul dx, ax                               ; 0f af d0                    ; 0xc2864
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc2867
    add ax, dx                                ; 01 d0                       ; 0xc286b
    add ax, ax                                ; 01 c0                       ; 0xc286d
    add si, ax                                ; 01 c6                       ; 0xc286f
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2871 vgabios.c:50
    mov byte [es:si], ch                      ; 26 88 2c                    ; 0xc2875
    cmp cl, 003h                              ; 80 f9 03                    ; 0xc2878 vgabios.c:1853
    jne near 02919h                           ; 0f 85 9a 00                 ; 0xc287b
    inc si                                    ; 46                          ; 0xc287f vgabios.c:1854
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2880 vgabios.c:50
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2884
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2887
    jmp near 02919h                           ; e9 8c 00                    ; 0xc288a vgabios.c:1856
    movzx si, byte [si+0482ch]                ; 0f b6 b4 2c 48              ; 0xc288d vgabios.c:1859
    sal si, 006h                              ; c1 e6 06                    ; 0xc2892
    mov ah, byte [si+04842h]                  ; 8a a4 42 48                 ; 0xc2895
    mov dl, byte [bx+047afh]                  ; 8a 97 af 47                 ; 0xc2899 vgabios.c:1860
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc289d vgabios.c:1861
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc28a1
    jc short 028b1h                           ; 72 0c                       ; 0xc28a3
    jbe short 028b7h                          ; 76 10                       ; 0xc28a5
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc28a7
    je short 02900h                           ; 74 55                       ; 0xc28a9
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc28ab
    je short 028bbh                           ; 74 0c                       ; 0xc28ad
    jmp short 02919h                          ; eb 68                       ; 0xc28af
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc28b1
    je short 028e1h                           ; 74 2c                       ; 0xc28b3
    jmp short 02919h                          ; eb 62                       ; 0xc28b5
    or byte [bp-006h], 001h                   ; 80 4e fa 01                 ; 0xc28b7 vgabios.c:1864
    movzx dx, byte [bp-004h]                  ; 0f b6 56 fc                 ; 0xc28bb vgabios.c:1866
    push dx                                   ; 52                          ; 0xc28bf
    movzx ax, ah                              ; 0f b6 c4                    ; 0xc28c0
    push ax                                   ; 50                          ; 0xc28c3
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc28c4
    push ax                                   ; 50                          ; 0xc28c8
    movzx ax, byte [bp-00ch]                  ; 0f b6 46 f4                 ; 0xc28c9
    movzx bx, byte [bp-00ah]                  ; 0f b6 5e f6                 ; 0xc28cd
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc28d1
    movzx si, ch                              ; 0f b6 f5                    ; 0xc28d5
    mov cx, ax                                ; 89 c1                       ; 0xc28d8
    mov ax, si                                ; 89 f0                       ; 0xc28da
    call 02120h                               ; e8 41 f8                    ; 0xc28dc
    jmp short 02919h                          ; eb 38                       ; 0xc28df vgabios.c:1867
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc28e1 vgabios.c:1869
    push ax                                   ; 50                          ; 0xc28e4
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc28e5
    push ax                                   ; 50                          ; 0xc28e9
    movzx si, byte [bp-00ch]                  ; 0f b6 76 f4                 ; 0xc28ea
    movzx bx, byte [bp-00ah]                  ; 0f b6 5e f6                 ; 0xc28ee
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc28f2
    movzx ax, ch                              ; 0f b6 c5                    ; 0xc28f6
    mov cx, si                                ; 89 f1                       ; 0xc28f9
    call 0221fh                               ; e8 21 f9                    ; 0xc28fb
    jmp short 02919h                          ; eb 19                       ; 0xc28fe vgabios.c:1870
    movzx ax, byte [bp-010h]                  ; 0f b6 46 f0                 ; 0xc2900 vgabios.c:1872
    push ax                                   ; 50                          ; 0xc2904
    movzx si, byte [bp-00ch]                  ; 0f b6 76 f4                 ; 0xc2905
    movzx bx, byte [bp-00ah]                  ; 0f b6 5e f6                 ; 0xc2909
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc290d
    movzx ax, ch                              ; 0f b6 c5                    ; 0xc2911
    mov cx, si                                ; 89 f1                       ; 0xc2914
    call 022fch                               ; e8 e3 f9                    ; 0xc2916
    inc byte [bp-00ah]                        ; fe 46 f6                    ; 0xc2919 vgabios.c:1880
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc291c vgabios.c:1882
    cmp ax, word [bp-010h]                    ; 3b 46 f0                    ; 0xc2920
    jne short 0292ch                          ; 75 07                       ; 0xc2923
    mov byte [bp-00ah], 000h                  ; c6 46 f6 00                 ; 0xc2925 vgabios.c:1883
    inc byte [bp-00ch]                        ; fe 46 f4                    ; 0xc2929 vgabios.c:1884
    movzx ax, byte [bp-00ch]                  ; 0f b6 46 f4                 ; 0xc292c vgabios.c:1889
    cmp ax, word [bp-00eh]                    ; 3b 46 f2                    ; 0xc2930
    jne short 029adh                          ; 75 78                       ; 0xc2933
    movzx bx, byte [bp-008h]                  ; 0f b6 5e f8                 ; 0xc2935 vgabios.c:1891
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2939
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc293c
    db  0feh, 0c8h
    ; dec al                                    ; fe c8                     ; 0xc293f
    mov ah, byte [bp-010h]                    ; 8a 66 f0                    ; 0xc2941
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc2944
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2946
    jne short 02990h                          ; 75 43                       ; 0xc294b
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc294d vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc2950
    mov es, dx                                ; 8e c2                       ; 0xc2953
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc2955
    movzx dx, byte [bp-004h]                  ; 0f b6 56 fc                 ; 0xc2958 vgabios.c:58
    imul si, dx                               ; 0f af f2                    ; 0xc295c
    movzx cx, byte [bp-00ch]                  ; 0f b6 4e f4                 ; 0xc295f vgabios.c:1894
    dec cx                                    ; 49                          ; 0xc2963
    imul cx, word [bp-010h]                   ; 0f af 4e f0                 ; 0xc2964
    movzx dx, byte [bp-00ah]                  ; 0f b6 56 f6                 ; 0xc2968
    add dx, cx                                ; 01 ca                       ; 0xc296c
    add dx, dx                                ; 01 d2                       ; 0xc296e
    add si, dx                                ; 01 d6                       ; 0xc2970
    inc si                                    ; 46                          ; 0xc2972 vgabios.c:1895
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2973 vgabios.c:45
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc2977 vgabios.c:47
    push strict byte 00001h                   ; 6a 01                       ; 0xc297a vgabios.c:1896
    movzx bx, byte [bp-004h]                  ; 0f b6 5e fc                 ; 0xc297c
    push bx                                   ; 53                          ; 0xc2980
    movzx bx, ah                              ; 0f b6 dc                    ; 0xc2981
    push bx                                   ; 53                          ; 0xc2984
    xor ah, ah                                ; 30 e4                       ; 0xc2985
    push ax                                   ; 50                          ; 0xc2987
    xor dh, dh                                ; 30 f6                       ; 0xc2988
    xor cx, cx                                ; 31 c9                       ; 0xc298a
    xor bx, bx                                ; 31 db                       ; 0xc298c
    jmp short 029a4h                          ; eb 14                       ; 0xc298e vgabios.c:1898
    push strict byte 00001h                   ; 6a 01                       ; 0xc2990 vgabios.c:1900
    movzx dx, byte [bp-004h]                  ; 0f b6 56 fc                 ; 0xc2992
    push dx                                   ; 52                          ; 0xc2996
    movzx dx, ah                              ; 0f b6 d4                    ; 0xc2997
    push dx                                   ; 52                          ; 0xc299a
    xor ah, ah                                ; 30 e4                       ; 0xc299b
    push ax                                   ; 50                          ; 0xc299d
    xor cx, cx                                ; 31 c9                       ; 0xc299e
    xor bx, bx                                ; 31 db                       ; 0xc29a0
    xor dx, dx                                ; 31 d2                       ; 0xc29a2
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc29a4
    call 01afeh                               ; e8 54 f1                    ; 0xc29a7
    dec byte [bp-00ch]                        ; fe 4e f4                    ; 0xc29aa vgabios.c:1902
    movzx ax, byte [bp-00ch]                  ; 0f b6 46 f4                 ; 0xc29ad vgabios.c:1906
    mov word [bp-012h], ax                    ; 89 46 ee                    ; 0xc29b1
    sal word [bp-012h], 008h                  ; c1 66 ee 08                 ; 0xc29b4
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc29b8
    add word [bp-012h], ax                    ; 01 46 ee                    ; 0xc29bc
    mov dx, word [bp-012h]                    ; 8b 56 ee                    ; 0xc29bf vgabios.c:1907
    movzx ax, byte [bp-004h]                  ; 0f b6 46 fc                 ; 0xc29c2
    call 01224h                               ; e8 5b e8                    ; 0xc29c6
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc29c9 vgabios.c:1908
    pop si                                    ; 5e                          ; 0xc29cc
    pop bp                                    ; 5d                          ; 0xc29cd
    retn                                      ; c3                          ; 0xc29ce
  ; disGetNextSymbol 0xc29cf LB 0x1875 -> off=0x0 cb=0000000000000033 uValue=00000000000c29cf 'get_font_access'
get_font_access:                             ; 0xc29cf LB 0x33
    push bp                                   ; 55                          ; 0xc29cf vgabios.c:1911
    mov bp, sp                                ; 89 e5                       ; 0xc29d0
    push dx                                   ; 52                          ; 0xc29d2
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc29d3 vgabios.c:1913
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc29d6
    out DX, ax                                ; ef                          ; 0xc29d9
    mov AL, strict byte 006h                  ; b0 06                       ; 0xc29da vgabios.c:1914
    out DX, AL                                ; ee                          ; 0xc29dc
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc29dd vgabios.c:1915
    in AL, DX                                 ; ec                          ; 0xc29e0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc29e1
    and ax, strict word 00001h                ; 25 01 00                    ; 0xc29e3
    or AL, strict byte 004h                   ; 0c 04                       ; 0xc29e6
    sal ax, 008h                              ; c1 e0 08                    ; 0xc29e8
    or AL, strict byte 006h                   ; 0c 06                       ; 0xc29eb
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc29ed
    out DX, ax                                ; ef                          ; 0xc29f0
    mov ax, 00402h                            ; b8 02 04                    ; 0xc29f1 vgabios.c:1916
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc29f4
    out DX, ax                                ; ef                          ; 0xc29f7
    mov ax, 00604h                            ; b8 04 06                    ; 0xc29f8 vgabios.c:1917
    out DX, ax                                ; ef                          ; 0xc29fb
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc29fc vgabios.c:1918
    pop dx                                    ; 5a                          ; 0xc29ff
    pop bp                                    ; 5d                          ; 0xc2a00
    retn                                      ; c3                          ; 0xc2a01
  ; disGetNextSymbol 0xc2a02 LB 0x1842 -> off=0x0 cb=0000000000000030 uValue=00000000000c2a02 'release_font_access'
release_font_access:                         ; 0xc2a02 LB 0x30
    push bp                                   ; 55                          ; 0xc2a02 vgabios.c:1920
    mov bp, sp                                ; 89 e5                       ; 0xc2a03
    push dx                                   ; 52                          ; 0xc2a05
    mov dx, 003cch                            ; ba cc 03                    ; 0xc2a06 vgabios.c:1922
    in AL, DX                                 ; ec                          ; 0xc2a09
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2a0a
    and ax, strict word 00001h                ; 25 01 00                    ; 0xc2a0c
    sal ax, 002h                              ; c1 e0 02                    ; 0xc2a0f
    or AL, strict byte 00ah                   ; 0c 0a                       ; 0xc2a12
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2a14
    or AL, strict byte 006h                   ; 0c 06                       ; 0xc2a17
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2a19
    out DX, ax                                ; ef                          ; 0xc2a1c
    mov ax, 01005h                            ; b8 05 10                    ; 0xc2a1d vgabios.c:1923
    out DX, ax                                ; ef                          ; 0xc2a20
    mov ax, 00302h                            ; b8 02 03                    ; 0xc2a21 vgabios.c:1924
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2a24
    out DX, ax                                ; ef                          ; 0xc2a27
    mov ax, 00204h                            ; b8 04 02                    ; 0xc2a28 vgabios.c:1925
    out DX, ax                                ; ef                          ; 0xc2a2b
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2a2c vgabios.c:1926
    pop dx                                    ; 5a                          ; 0xc2a2f
    pop bp                                    ; 5d                          ; 0xc2a30
    retn                                      ; c3                          ; 0xc2a31
  ; disGetNextSymbol 0xc2a32 LB 0x1812 -> off=0x0 cb=00000000000000c3 uValue=00000000000c2a32 'set_scan_lines'
set_scan_lines:                              ; 0xc2a32 LB 0xc3
    push bp                                   ; 55                          ; 0xc2a32 vgabios.c:1928
    mov bp, sp                                ; 89 e5                       ; 0xc2a33
    push bx                                   ; 53                          ; 0xc2a35
    push cx                                   ; 51                          ; 0xc2a36
    push dx                                   ; 52                          ; 0xc2a37
    push si                                   ; 56                          ; 0xc2a38
    push di                                   ; 57                          ; 0xc2a39
    mov cl, al                                ; 88 c1                       ; 0xc2a3a
    mov si, strict word 00063h                ; be 63 00                    ; 0xc2a3c vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2a3f
    mov es, ax                                ; 8e c0                       ; 0xc2a42
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc2a44
    mov bx, si                                ; 89 f3                       ; 0xc2a47 vgabios.c:58
    mov AL, strict byte 009h                  ; b0 09                       ; 0xc2a49 vgabios.c:1934
    mov dx, si                                ; 89 f2                       ; 0xc2a4b
    out DX, AL                                ; ee                          ; 0xc2a4d
    lea dx, [si+001h]                         ; 8d 54 01                    ; 0xc2a4e vgabios.c:1935
    in AL, DX                                 ; ec                          ; 0xc2a51
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2a52
    and AL, strict byte 0e0h                  ; 24 e0                       ; 0xc2a54 vgabios.c:1936
    mov ah, cl                                ; 88 cc                       ; 0xc2a56
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc2a58
    or al, ah                                 ; 08 e0                       ; 0xc2a5a
    out DX, AL                                ; ee                          ; 0xc2a5c vgabios.c:1937
    movzx ax, cl                              ; 0f b6 c1                    ; 0xc2a5d vgabios.c:1942
    mov si, ax                                ; 89 c6                       ; 0xc2a60
    sal si, 008h                              ; c1 e6 08                    ; 0xc2a62
    dec ax                                    ; 48                          ; 0xc2a65
    sub si, 00200h                            ; 81 ee 00 02                 ; 0xc2a66
    or si, ax                                 ; 09 c6                       ; 0xc2a6a
    cmp cl, 00eh                              ; 80 f9 0e                    ; 0xc2a6c vgabios.c:1943
    jc short 02a75h                           ; 72 04                       ; 0xc2a6f
    sub si, 00101h                            ; 81 ee 01 01                 ; 0xc2a71 vgabios.c:1944
    mov ax, si                                ; 89 f0                       ; 0xc2a75 vgabios.c:1946
    xor al, al                                ; 30 c0                       ; 0xc2a77
    or AL, strict byte 00ah                   ; 0c 0a                       ; 0xc2a79
    mov dx, bx                                ; 89 da                       ; 0xc2a7b
    out DX, ax                                ; ef                          ; 0xc2a7d
    mov ax, si                                ; 89 f0                       ; 0xc2a7e vgabios.c:1947
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2a80
    or AL, strict byte 00bh                   ; 0c 0b                       ; 0xc2a83
    out DX, ax                                ; ef                          ; 0xc2a85
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc2a86 vgabios.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2a89
    mov es, ax                                ; 8e c0                       ; 0xc2a8c
    mov word [es:di], si                      ; 26 89 35                    ; 0xc2a8e
    movzx di, cl                              ; 0f b6 f9                    ; 0xc2a91 vgabios.c:1950
    mov si, 00085h                            ; be 85 00                    ; 0xc2a94 vgabios.c:62
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc2a97
    mov AL, strict byte 012h                  ; b0 12                       ; 0xc2a9a vgabios.c:1951
    out DX, AL                                ; ee                          ; 0xc2a9c
    lea si, [bx+001h]                         ; 8d 77 01                    ; 0xc2a9d vgabios.c:1952
    mov dx, si                                ; 89 f2                       ; 0xc2aa0
    in AL, DX                                 ; ec                          ; 0xc2aa2
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2aa3
    mov cx, ax                                ; 89 c1                       ; 0xc2aa5
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc2aa7 vgabios.c:1953
    mov dx, bx                                ; 89 da                       ; 0xc2aa9
    out DX, AL                                ; ee                          ; 0xc2aab
    mov dx, si                                ; 89 f2                       ; 0xc2aac vgabios.c:1954
    in AL, DX                                 ; ec                          ; 0xc2aae
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2aaf
    mov ah, al                                ; 88 c4                       ; 0xc2ab1 vgabios.c:1955
    and ah, 002h                              ; 80 e4 02                    ; 0xc2ab3
    movzx bx, ah                              ; 0f b6 dc                    ; 0xc2ab6
    sal bx, 007h                              ; c1 e3 07                    ; 0xc2ab9
    and AL, strict byte 040h                  ; 24 40                       ; 0xc2abc
    xor ah, ah                                ; 30 e4                       ; 0xc2abe
    sal ax, 003h                              ; c1 e0 03                    ; 0xc2ac0
    add ax, bx                                ; 01 d8                       ; 0xc2ac3
    inc ax                                    ; 40                          ; 0xc2ac5
    add ax, cx                                ; 01 c8                       ; 0xc2ac6
    xor dx, si                                ; 31 f2                       ; 0xc2ac8 vgabios.c:1956
    div di                                    ; f7 f7                       ; 0xc2aca
    mov cl, al                                ; 88 c1                       ; 0xc2acc vgabios.c:1957
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc2ace
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2ad0 vgabios.c:52
    mov byte [es:bx], cl                      ; 26 88 0f                    ; 0xc2ad3
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2ad6 vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc2ad9
    xor ah, ah                                ; 30 e4                       ; 0xc2adc vgabios.c:1963
    imul ax, bx                               ; 0f af c3                    ; 0xc2ade
    add ax, ax                                ; 01 c0                       ; 0xc2ae1
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc2ae3
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc2ae5 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc2ae8
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc2aeb vgabios.c:1964
    pop di                                    ; 5f                          ; 0xc2aee
    pop si                                    ; 5e                          ; 0xc2aef
    pop dx                                    ; 5a                          ; 0xc2af0
    pop cx                                    ; 59                          ; 0xc2af1
    pop bx                                    ; 5b                          ; 0xc2af2
    pop bp                                    ; 5d                          ; 0xc2af3
    retn                                      ; c3                          ; 0xc2af4
  ; disGetNextSymbol 0xc2af5 LB 0x174f -> off=0x0 cb=0000000000000022 uValue=00000000000c2af5 'biosfn_set_font_block'
biosfn_set_font_block:                       ; 0xc2af5 LB 0x22
    push bp                                   ; 55                          ; 0xc2af5 vgabios.c:1966
    mov bp, sp                                ; 89 e5                       ; 0xc2af6
    push bx                                   ; 53                          ; 0xc2af8
    push dx                                   ; 52                          ; 0xc2af9
    mov bl, al                                ; 88 c3                       ; 0xc2afa
    mov ax, 00100h                            ; b8 00 01                    ; 0xc2afc vgabios.c:1968
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2aff
    out DX, ax                                ; ef                          ; 0xc2b02
    movzx ax, bl                              ; 0f b6 c3                    ; 0xc2b03 vgabios.c:1969
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2b06
    or AL, strict byte 003h                   ; 0c 03                       ; 0xc2b09
    out DX, ax                                ; ef                          ; 0xc2b0b
    mov ax, 00300h                            ; b8 00 03                    ; 0xc2b0c vgabios.c:1970
    out DX, ax                                ; ef                          ; 0xc2b0f
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2b10 vgabios.c:1971
    pop dx                                    ; 5a                          ; 0xc2b13
    pop bx                                    ; 5b                          ; 0xc2b14
    pop bp                                    ; 5d                          ; 0xc2b15
    retn                                      ; c3                          ; 0xc2b16
  ; disGetNextSymbol 0xc2b17 LB 0x172d -> off=0x0 cb=0000000000000075 uValue=00000000000c2b17 'load_text_patch'
load_text_patch:                             ; 0xc2b17 LB 0x75
    push bp                                   ; 55                          ; 0xc2b17 vgabios.c:1973
    mov bp, sp                                ; 89 e5                       ; 0xc2b18
    push si                                   ; 56                          ; 0xc2b1a
    push di                                   ; 57                          ; 0xc2b1b
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc2b1c
    push ax                                   ; 50                          ; 0xc2b1f
    mov byte [bp-006h], cl                    ; 88 4e fa                    ; 0xc2b20
    call 029cfh                               ; e8 a9 fe                    ; 0xc2b23 vgabios.c:1978
    mov al, bl                                ; 88 d8                       ; 0xc2b26 vgabios.c:1980
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2b28
    movzx cx, al                              ; 0f b6 c8                    ; 0xc2b2a
    sal cx, 00eh                              ; c1 e1 0e                    ; 0xc2b2d
    mov al, bl                                ; 88 d8                       ; 0xc2b30
    and AL, strict byte 004h                  ; 24 04                       ; 0xc2b32
    xor ah, ah                                ; 30 e4                       ; 0xc2b34
    sal ax, 00bh                              ; c1 e0 0b                    ; 0xc2b36
    add cx, ax                                ; 01 c1                       ; 0xc2b39
    mov word [bp-00ch], cx                    ; 89 4e f4                    ; 0xc2b3b
    mov bx, dx                                ; 89 d3                       ; 0xc2b3e vgabios.c:1981
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2b40
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc2b43
    inc dx                                    ; 42                          ; 0xc2b46 vgabios.c:1982
    mov word [bp-008h], dx                    ; 89 56 f8                    ; 0xc2b47
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc2b4a vgabios.c:1983
    cmp byte [es:bx], 000h                    ; 26 80 3f 00                 ; 0xc2b4d
    je short 02b82h                           ; 74 2f                       ; 0xc2b51
    movzx ax, byte [es:bx]                    ; 26 0f b6 07                 ; 0xc2b53 vgabios.c:1984
    sal ax, 005h                              ; c1 e0 05                    ; 0xc2b57
    mov di, word [bp-00ch]                    ; 8b 7e f4                    ; 0xc2b5a
    add di, ax                                ; 01 c7                       ; 0xc2b5d
    movzx cx, byte [bp-006h]                  ; 0f b6 4e fa                 ; 0xc2b5f vgabios.c:1985
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc2b63
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc2b66
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2b69
    mov es, ax                                ; 8e c0                       ; 0xc2b6c
    jcxz 02b76h                               ; e3 06                       ; 0xc2b6e
    push DS                                   ; 1e                          ; 0xc2b70
    mov ds, dx                                ; 8e da                       ; 0xc2b71
    rep movsb                                 ; f3 a4                       ; 0xc2b73
    pop DS                                    ; 1f                          ; 0xc2b75
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc2b76 vgabios.c:1986
    inc ax                                    ; 40                          ; 0xc2b7a
    add word [bp-008h], ax                    ; 01 46 f8                    ; 0xc2b7b
    add bx, ax                                ; 01 c3                       ; 0xc2b7e vgabios.c:1987
    jmp short 02b4ah                          ; eb c8                       ; 0xc2b80 vgabios.c:1988
    call 02a02h                               ; e8 7d fe                    ; 0xc2b82 vgabios.c:1990
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2b85 vgabios.c:1991
    pop di                                    ; 5f                          ; 0xc2b88
    pop si                                    ; 5e                          ; 0xc2b89
    pop bp                                    ; 5d                          ; 0xc2b8a
    retn                                      ; c3                          ; 0xc2b8b
  ; disGetNextSymbol 0xc2b8c LB 0x16b8 -> off=0x0 cb=000000000000007c uValue=00000000000c2b8c 'biosfn_load_text_user_pat'
biosfn_load_text_user_pat:                   ; 0xc2b8c LB 0x7c
    push bp                                   ; 55                          ; 0xc2b8c vgabios.c:1993
    mov bp, sp                                ; 89 e5                       ; 0xc2b8d
    push si                                   ; 56                          ; 0xc2b8f
    push di                                   ; 57                          ; 0xc2b90
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc2b91
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2b94
    mov word [bp-00ch], dx                    ; 89 56 f4                    ; 0xc2b97
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc2b9a
    mov word [bp-00ah], cx                    ; 89 4e f6                    ; 0xc2b9d
    call 029cfh                               ; e8 2c fe                    ; 0xc2ba0 vgabios.c:1998
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2ba3 vgabios.c:1999
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2ba6
    xor ah, ah                                ; 30 e4                       ; 0xc2ba8
    mov bx, ax                                ; 89 c3                       ; 0xc2baa
    sal bx, 00eh                              ; c1 e3 0e                    ; 0xc2bac
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2baf
    and AL, strict byte 004h                  ; 24 04                       ; 0xc2bb2
    xor ah, ah                                ; 30 e4                       ; 0xc2bb4
    sal ax, 00bh                              ; c1 e0 0b                    ; 0xc2bb6
    add bx, ax                                ; 01 c3                       ; 0xc2bb9
    mov word [bp-00eh], bx                    ; 89 5e f2                    ; 0xc2bbb
    xor bx, bx                                ; 31 db                       ; 0xc2bbe vgabios.c:2000
    cmp bx, word [bp-00ah]                    ; 3b 5e f6                    ; 0xc2bc0
    jnc short 02befh                          ; 73 2a                       ; 0xc2bc3
    movzx cx, byte [bp+008h]                  ; 0f b6 4e 08                 ; 0xc2bc5 vgabios.c:2002
    mov si, bx                                ; 89 de                       ; 0xc2bc9
    imul si, cx                               ; 0f af f1                    ; 0xc2bcb
    add si, word [bp-008h]                    ; 03 76 f8                    ; 0xc2bce
    mov di, word [bp+004h]                    ; 8b 7e 04                    ; 0xc2bd1 vgabios.c:2003
    add di, bx                                ; 01 df                       ; 0xc2bd4
    sal di, 005h                              ; c1 e7 05                    ; 0xc2bd6
    add di, word [bp-00eh]                    ; 03 7e f2                    ; 0xc2bd9
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc2bdc vgabios.c:2004
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2bdf
    mov es, ax                                ; 8e c0                       ; 0xc2be2
    jcxz 02bech                               ; e3 06                       ; 0xc2be4
    push DS                                   ; 1e                          ; 0xc2be6
    mov ds, dx                                ; 8e da                       ; 0xc2be7
    rep movsb                                 ; f3 a4                       ; 0xc2be9
    pop DS                                    ; 1f                          ; 0xc2beb
    inc bx                                    ; 43                          ; 0xc2bec vgabios.c:2005
    jmp short 02bc0h                          ; eb d1                       ; 0xc2bed
    call 02a02h                               ; e8 10 fe                    ; 0xc2bef vgabios.c:2006
    cmp byte [bp-006h], 010h                  ; 80 7e fa 10                 ; 0xc2bf2 vgabios.c:2007
    jc short 02bffh                           ; 72 07                       ; 0xc2bf6
    movzx ax, byte [bp+008h]                  ; 0f b6 46 08                 ; 0xc2bf8 vgabios.c:2009
    call 02a32h                               ; e8 33 fe                    ; 0xc2bfc
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2bff vgabios.c:2011
    pop di                                    ; 5f                          ; 0xc2c02
    pop si                                    ; 5e                          ; 0xc2c03
    pop bp                                    ; 5d                          ; 0xc2c04
    retn 00006h                               ; c2 06 00                    ; 0xc2c05
  ; disGetNextSymbol 0xc2c08 LB 0x163c -> off=0x0 cb=0000000000000016 uValue=00000000000c2c08 'biosfn_load_gfx_8_8_chars'
biosfn_load_gfx_8_8_chars:                   ; 0xc2c08 LB 0x16
    push bp                                   ; 55                          ; 0xc2c08 vgabios.c:2013
    mov bp, sp                                ; 89 e5                       ; 0xc2c09
    push bx                                   ; 53                          ; 0xc2c0b
    push cx                                   ; 51                          ; 0xc2c0c
    mov bx, dx                                ; 89 d3                       ; 0xc2c0d vgabios.c:2015
    mov cx, ax                                ; 89 c1                       ; 0xc2c0f
    mov ax, strict word 0001fh                ; b8 1f 00                    ; 0xc2c11
    call 009f0h                               ; e8 d9 dd                    ; 0xc2c14
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2c17 vgabios.c:2016
    pop cx                                    ; 59                          ; 0xc2c1a
    pop bx                                    ; 5b                          ; 0xc2c1b
    pop bp                                    ; 5d                          ; 0xc2c1c
    retn                                      ; c3                          ; 0xc2c1d
  ; disGetNextSymbol 0xc2c1e LB 0x1626 -> off=0x0 cb=0000000000000049 uValue=00000000000c2c1e 'set_gfx_font'
set_gfx_font:                                ; 0xc2c1e LB 0x49
    push bp                                   ; 55                          ; 0xc2c1e vgabios.c:2018
    mov bp, sp                                ; 89 e5                       ; 0xc2c1f
    push si                                   ; 56                          ; 0xc2c21
    push di                                   ; 57                          ; 0xc2c22
    mov si, dx                                ; 89 d6                       ; 0xc2c23
    mov di, bx                                ; 89 df                       ; 0xc2c25
    mov dl, cl                                ; 88 ca                       ; 0xc2c27
    mov bx, ax                                ; 89 c3                       ; 0xc2c29 vgabios.c:2022
    mov cx, si                                ; 89 f1                       ; 0xc2c2b
    mov ax, strict word 00043h                ; b8 43 00                    ; 0xc2c2d
    call 009f0h                               ; e8 bd dd                    ; 0xc2c30
    test dl, dl                               ; 84 d2                       ; 0xc2c33 vgabios.c:2023
    je short 02c48h                           ; 74 11                       ; 0xc2c35
    cmp dl, 003h                              ; 80 fa 03                    ; 0xc2c37 vgabios.c:2024
    jbe short 02c3eh                          ; 76 02                       ; 0xc2c3a
    mov DL, strict byte 002h                  ; b2 02                       ; 0xc2c3c vgabios.c:2025
    movzx bx, dl                              ; 0f b6 da                    ; 0xc2c3e vgabios.c:2026
    mov al, byte [bx+07dfbh]                  ; 8a 87 fb 7d                 ; 0xc2c41
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc2c45
    mov bx, 00085h                            ; bb 85 00                    ; 0xc2c48 vgabios.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2c4b
    mov es, ax                                ; 8e c0                       ; 0xc2c4e
    mov word [es:bx], di                      ; 26 89 3f                    ; 0xc2c50
    movzx ax, byte [bp+004h]                  ; 0f b6 46 04                 ; 0xc2c53 vgabios.c:2031
    dec ax                                    ; 48                          ; 0xc2c57
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2c58 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc2c5b
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2c5e vgabios.c:2032
    pop di                                    ; 5f                          ; 0xc2c61
    pop si                                    ; 5e                          ; 0xc2c62
    pop bp                                    ; 5d                          ; 0xc2c63
    retn 00002h                               ; c2 02 00                    ; 0xc2c64
  ; disGetNextSymbol 0xc2c67 LB 0x15dd -> off=0x0 cb=000000000000001c uValue=00000000000c2c67 'biosfn_load_gfx_user_chars'
biosfn_load_gfx_user_chars:                  ; 0xc2c67 LB 0x1c
    push bp                                   ; 55                          ; 0xc2c67 vgabios.c:2034
    mov bp, sp                                ; 89 e5                       ; 0xc2c68
    push si                                   ; 56                          ; 0xc2c6a
    mov si, ax                                ; 89 c6                       ; 0xc2c6b
    mov ax, dx                                ; 89 d0                       ; 0xc2c6d
    movzx dx, byte [bp+004h]                  ; 0f b6 56 04                 ; 0xc2c6f vgabios.c:2037
    push dx                                   ; 52                          ; 0xc2c73
    xor ch, ch                                ; 30 ed                       ; 0xc2c74
    mov dx, si                                ; 89 f2                       ; 0xc2c76
    call 02c1eh                               ; e8 a3 ff                    ; 0xc2c78
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2c7b vgabios.c:2038
    pop si                                    ; 5e                          ; 0xc2c7e
    pop bp                                    ; 5d                          ; 0xc2c7f
    retn 00002h                               ; c2 02 00                    ; 0xc2c80
  ; disGetNextSymbol 0xc2c83 LB 0x15c1 -> off=0x0 cb=000000000000001e uValue=00000000000c2c83 'biosfn_load_gfx_8_14_chars'
biosfn_load_gfx_8_14_chars:                  ; 0xc2c83 LB 0x1e
    push bp                                   ; 55                          ; 0xc2c83 vgabios.c:2043
    mov bp, sp                                ; 89 e5                       ; 0xc2c84
    push bx                                   ; 53                          ; 0xc2c86
    push cx                                   ; 51                          ; 0xc2c87
    movzx cx, dl                              ; 0f b6 ca                    ; 0xc2c88 vgabios.c:2045
    push cx                                   ; 51                          ; 0xc2c8b
    movzx cx, al                              ; 0f b6 c8                    ; 0xc2c8c
    mov bx, strict word 0000eh                ; bb 0e 00                    ; 0xc2c8f
    mov ax, 05d6ah                            ; b8 6a 5d                    ; 0xc2c92
    mov dx, ds                                ; 8c da                       ; 0xc2c95
    call 02c1eh                               ; e8 84 ff                    ; 0xc2c97
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2c9a vgabios.c:2046
    pop cx                                    ; 59                          ; 0xc2c9d
    pop bx                                    ; 5b                          ; 0xc2c9e
    pop bp                                    ; 5d                          ; 0xc2c9f
    retn                                      ; c3                          ; 0xc2ca0
  ; disGetNextSymbol 0xc2ca1 LB 0x15a3 -> off=0x0 cb=000000000000001e uValue=00000000000c2ca1 'biosfn_load_gfx_8_8_dd_chars'
biosfn_load_gfx_8_8_dd_chars:                ; 0xc2ca1 LB 0x1e
    push bp                                   ; 55                          ; 0xc2ca1 vgabios.c:2047
    mov bp, sp                                ; 89 e5                       ; 0xc2ca2
    push bx                                   ; 53                          ; 0xc2ca4
    push cx                                   ; 51                          ; 0xc2ca5
    movzx cx, dl                              ; 0f b6 ca                    ; 0xc2ca6 vgabios.c:2049
    push cx                                   ; 51                          ; 0xc2ca9
    movzx cx, al                              ; 0f b6 c8                    ; 0xc2caa
    mov bx, strict word 00008h                ; bb 08 00                    ; 0xc2cad
    mov ax, 0556ah                            ; b8 6a 55                    ; 0xc2cb0
    mov dx, ds                                ; 8c da                       ; 0xc2cb3
    call 02c1eh                               ; e8 66 ff                    ; 0xc2cb5
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2cb8 vgabios.c:2050
    pop cx                                    ; 59                          ; 0xc2cbb
    pop bx                                    ; 5b                          ; 0xc2cbc
    pop bp                                    ; 5d                          ; 0xc2cbd
    retn                                      ; c3                          ; 0xc2cbe
  ; disGetNextSymbol 0xc2cbf LB 0x1585 -> off=0x0 cb=000000000000001e uValue=00000000000c2cbf 'biosfn_load_gfx_8_16_chars'
biosfn_load_gfx_8_16_chars:                  ; 0xc2cbf LB 0x1e
    push bp                                   ; 55                          ; 0xc2cbf vgabios.c:2051
    mov bp, sp                                ; 89 e5                       ; 0xc2cc0
    push bx                                   ; 53                          ; 0xc2cc2
    push cx                                   ; 51                          ; 0xc2cc3
    movzx cx, dl                              ; 0f b6 ca                    ; 0xc2cc4 vgabios.c:2053
    push cx                                   ; 51                          ; 0xc2cc7
    movzx cx, al                              ; 0f b6 c8                    ; 0xc2cc8
    mov bx, strict word 00010h                ; bb 10 00                    ; 0xc2ccb
    mov ax, 06b6ah                            ; b8 6a 6b                    ; 0xc2cce
    mov dx, ds                                ; 8c da                       ; 0xc2cd1
    call 02c1eh                               ; e8 48 ff                    ; 0xc2cd3
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2cd6 vgabios.c:2054
    pop cx                                    ; 59                          ; 0xc2cd9
    pop bx                                    ; 5b                          ; 0xc2cda
    pop bp                                    ; 5d                          ; 0xc2cdb
    retn                                      ; c3                          ; 0xc2cdc
  ; disGetNextSymbol 0xc2cdd LB 0x1567 -> off=0x0 cb=0000000000000005 uValue=00000000000c2cdd 'biosfn_alternate_prtsc'
biosfn_alternate_prtsc:                      ; 0xc2cdd LB 0x5
    push bp                                   ; 55                          ; 0xc2cdd vgabios.c:2056
    mov bp, sp                                ; 89 e5                       ; 0xc2cde
    pop bp                                    ; 5d                          ; 0xc2ce0 vgabios.c:2061
    retn                                      ; c3                          ; 0xc2ce1
  ; disGetNextSymbol 0xc2ce2 LB 0x1562 -> off=0x0 cb=0000000000000032 uValue=00000000000c2ce2 'biosfn_set_txt_lines'
biosfn_set_txt_lines:                        ; 0xc2ce2 LB 0x32
    push bx                                   ; 53                          ; 0xc2ce2 vgabios.c:2063
    push si                                   ; 56                          ; 0xc2ce3
    push bp                                   ; 55                          ; 0xc2ce4
    mov bp, sp                                ; 89 e5                       ; 0xc2ce5
    mov bl, al                                ; 88 c3                       ; 0xc2ce7
    mov si, 00089h                            ; be 89 00                    ; 0xc2ce9 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2cec
    mov es, ax                                ; 8e c0                       ; 0xc2cef
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2cf1
    and AL, strict byte 06fh                  ; 24 6f                       ; 0xc2cf4 vgabios.c:2069
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc2cf6 vgabios.c:2071
    je short 02d03h                           ; 74 08                       ; 0xc2cf9
    test bl, bl                               ; 84 db                       ; 0xc2cfb
    jne short 02d05h                          ; 75 06                       ; 0xc2cfd
    or AL, strict byte 080h                   ; 0c 80                       ; 0xc2cff vgabios.c:2074
    jmp short 02d05h                          ; eb 02                       ; 0xc2d01 vgabios.c:2075
    or AL, strict byte 010h                   ; 0c 10                       ; 0xc2d03 vgabios.c:2077
    mov bx, 00089h                            ; bb 89 00                    ; 0xc2d05 vgabios.c:52
    mov si, strict word 00040h                ; be 40 00                    ; 0xc2d08
    mov es, si                                ; 8e c6                       ; 0xc2d0b
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2d0d
    pop bp                                    ; 5d                          ; 0xc2d10 vgabios.c:2081
    pop si                                    ; 5e                          ; 0xc2d11
    pop bx                                    ; 5b                          ; 0xc2d12
    retn                                      ; c3                          ; 0xc2d13
  ; disGetNextSymbol 0xc2d14 LB 0x1530 -> off=0x0 cb=0000000000000005 uValue=00000000000c2d14 'biosfn_switch_video_interface'
biosfn_switch_video_interface:               ; 0xc2d14 LB 0x5
    push bp                                   ; 55                          ; 0xc2d14 vgabios.c:2084
    mov bp, sp                                ; 89 e5                       ; 0xc2d15
    pop bp                                    ; 5d                          ; 0xc2d17 vgabios.c:2089
    retn                                      ; c3                          ; 0xc2d18
  ; disGetNextSymbol 0xc2d19 LB 0x152b -> off=0x0 cb=0000000000000005 uValue=00000000000c2d19 'biosfn_enable_video_refresh_control'
biosfn_enable_video_refresh_control:         ; 0xc2d19 LB 0x5
    push bp                                   ; 55                          ; 0xc2d19 vgabios.c:2090
    mov bp, sp                                ; 89 e5                       ; 0xc2d1a
    pop bp                                    ; 5d                          ; 0xc2d1c vgabios.c:2095
    retn                                      ; c3                          ; 0xc2d1d
  ; disGetNextSymbol 0xc2d1e LB 0x1526 -> off=0x0 cb=0000000000000096 uValue=00000000000c2d1e 'biosfn_write_string'
biosfn_write_string:                         ; 0xc2d1e LB 0x96
    push bp                                   ; 55                          ; 0xc2d1e vgabios.c:2098
    mov bp, sp                                ; 89 e5                       ; 0xc2d1f
    push si                                   ; 56                          ; 0xc2d21
    push di                                   ; 57                          ; 0xc2d22
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc2d23
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2d26
    mov byte [bp-006h], dl                    ; 88 56 fa                    ; 0xc2d29
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc2d2c
    mov si, cx                                ; 89 ce                       ; 0xc2d2f
    mov di, word [bp+00ah]                    ; 8b 7e 0a                    ; 0xc2d31
    movzx ax, dl                              ; 0f b6 c2                    ; 0xc2d34 vgabios.c:2105
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc2d37
    lea dx, [bp-00ch]                         ; 8d 56 f4                    ; 0xc2d3a
    call 00a93h                               ; e8 53 dd                    ; 0xc2d3d
    cmp byte [bp+004h], 0ffh                  ; 80 7e 04 ff                 ; 0xc2d40 vgabios.c:2108
    jne short 02d57h                          ; 75 11                       ; 0xc2d44
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2d46 vgabios.c:2109
    mov byte [bp+006h], al                    ; 88 46 06                    ; 0xc2d49
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2d4c vgabios.c:2110
    xor al, al                                ; 30 c0                       ; 0xc2d4f
    shr ax, 008h                              ; c1 e8 08                    ; 0xc2d51
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc2d54
    movzx dx, byte [bp+004h]                  ; 0f b6 56 04                 ; 0xc2d57 vgabios.c:2113
    sal dx, 008h                              ; c1 e2 08                    ; 0xc2d5b
    movzx ax, byte [bp+006h]                  ; 0f b6 46 06                 ; 0xc2d5e
    add dx, ax                                ; 01 c2                       ; 0xc2d62
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc2d64 vgabios.c:2114
    call 01224h                               ; e8 b9 e4                    ; 0xc2d68
    dec si                                    ; 4e                          ; 0xc2d6b vgabios.c:2116
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2d6c
    je short 02d9bh                           ; 74 2a                       ; 0xc2d6f
    mov bx, di                                ; 89 fb                       ; 0xc2d71 vgabios.c:2118
    inc di                                    ; 47                          ; 0xc2d73
    mov es, [bp+008h]                         ; 8e 46 08                    ; 0xc2d74 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2d77
    test byte [bp-008h], 002h                 ; f6 46 f8 02                 ; 0xc2d7a vgabios.c:2119
    je short 02d89h                           ; 74 09                       ; 0xc2d7e
    mov bx, di                                ; 89 fb                       ; 0xc2d80 vgabios.c:2120
    inc di                                    ; 47                          ; 0xc2d82
    mov ah, byte [es:bx]                      ; 26 8a 27                    ; 0xc2d83 vgabios.c:47
    mov byte [bp-00ah], ah                    ; 88 66 f6                    ; 0xc2d86 vgabios.c:48
    movzx bx, byte [bp-00ah]                  ; 0f b6 5e f6                 ; 0xc2d89 vgabios.c:2122
    movzx dx, byte [bp-006h]                  ; 0f b6 56 fa                 ; 0xc2d8d
    xor ah, ah                                ; 30 e4                       ; 0xc2d91
    mov cx, strict word 00003h                ; b9 03 00                    ; 0xc2d93
    call 0278fh                               ; e8 f6 f9                    ; 0xc2d96
    jmp short 02d6bh                          ; eb d0                       ; 0xc2d99 vgabios.c:2123
    test byte [bp-008h], 001h                 ; f6 46 f8 01                 ; 0xc2d9b vgabios.c:2126
    jne short 02dabh                          ; 75 0a                       ; 0xc2d9f
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc2da1 vgabios.c:2127
    movzx ax, byte [bp-006h]                  ; 0f b6 46 fa                 ; 0xc2da4
    call 01224h                               ; e8 79 e4                    ; 0xc2da8
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2dab vgabios.c:2128
    pop di                                    ; 5f                          ; 0xc2dae
    pop si                                    ; 5e                          ; 0xc2daf
    pop bp                                    ; 5d                          ; 0xc2db0
    retn 00008h                               ; c2 08 00                    ; 0xc2db1
  ; disGetNextSymbol 0xc2db4 LB 0x1490 -> off=0x0 cb=00000000000001f2 uValue=00000000000c2db4 'biosfn_read_state_info'
biosfn_read_state_info:                      ; 0xc2db4 LB 0x1f2
    push bp                                   ; 55                          ; 0xc2db4 vgabios.c:2131
    mov bp, sp                                ; 89 e5                       ; 0xc2db5
    push cx                                   ; 51                          ; 0xc2db7
    push si                                   ; 56                          ; 0xc2db8
    push di                                   ; 57                          ; 0xc2db9
    push ax                                   ; 50                          ; 0xc2dba
    push ax                                   ; 50                          ; 0xc2dbb
    push dx                                   ; 52                          ; 0xc2dbc
    mov si, strict word 00049h                ; be 49 00                    ; 0xc2dbd vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2dc0
    mov es, ax                                ; 8e c0                       ; 0xc2dc3
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2dc5
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2dc8 vgabios.c:48
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2dcb vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc2dce
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc2dd1 vgabios.c:58
    mov ax, ds                                ; 8c d8                       ; 0xc2dd4 vgabios.c:2142
    mov es, dx                                ; 8e c2                       ; 0xc2dd6 vgabios.c:72
    mov word [es:bx], 05500h                  ; 26 c7 07 00 55              ; 0xc2dd8
    mov [es:bx+002h], ds                      ; 26 8c 5f 02                 ; 0xc2ddd
    lea di, [bx+004h]                         ; 8d 7f 04                    ; 0xc2de1 vgabios.c:2147
    mov cx, strict word 0001eh                ; b9 1e 00                    ; 0xc2de4
    mov si, strict word 00049h                ; be 49 00                    ; 0xc2de7
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc2dea
    jcxz 02df5h                               ; e3 06                       ; 0xc2ded
    push DS                                   ; 1e                          ; 0xc2def
    mov ds, dx                                ; 8e da                       ; 0xc2df0
    rep movsb                                 ; f3 a4                       ; 0xc2df2
    pop DS                                    ; 1f                          ; 0xc2df4
    mov si, 00084h                            ; be 84 00                    ; 0xc2df5 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2df8
    mov es, ax                                ; 8e c0                       ; 0xc2dfb
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2dfd
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc2e00 vgabios.c:48
    lea si, [bx+022h]                         ; 8d 77 22                    ; 0xc2e02
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2e05 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2e08
    lea di, [bx+023h]                         ; 8d 7f 23                    ; 0xc2e0b vgabios.c:2149
    mov cx, strict word 00002h                ; b9 02 00                    ; 0xc2e0e
    mov si, 00085h                            ; be 85 00                    ; 0xc2e11
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc2e14
    jcxz 02e1fh                               ; e3 06                       ; 0xc2e17
    push DS                                   ; 1e                          ; 0xc2e19
    mov ds, dx                                ; 8e da                       ; 0xc2e1a
    rep movsb                                 ; f3 a4                       ; 0xc2e1c
    pop DS                                    ; 1f                          ; 0xc2e1e
    mov si, 0008ah                            ; be 8a 00                    ; 0xc2e1f vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2e22
    mov es, ax                                ; 8e c0                       ; 0xc2e25
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2e27
    lea si, [bx+025h]                         ; 8d 77 25                    ; 0xc2e2a vgabios.c:48
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2e2d vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2e30
    lea si, [bx+026h]                         ; 8d 77 26                    ; 0xc2e33 vgabios.c:2152
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc2e36 vgabios.c:52
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc2e3a vgabios.c:2153
    mov word [es:si], strict word 00010h      ; 26 c7 04 10 00              ; 0xc2e3d vgabios.c:62
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc2e42 vgabios.c:2154
    mov byte [es:si], 008h                    ; 26 c6 04 08                 ; 0xc2e45 vgabios.c:52
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc2e49 vgabios.c:2155
    mov byte [es:si], 002h                    ; 26 c6 04 02                 ; 0xc2e4c vgabios.c:52
    lea si, [bx+02bh]                         ; 8d 77 2b                    ; 0xc2e50 vgabios.c:2156
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc2e53 vgabios.c:52
    lea si, [bx+02ch]                         ; 8d 77 2c                    ; 0xc2e57 vgabios.c:2157
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc2e5a vgabios.c:52
    lea si, [bx+02dh]                         ; 8d 77 2d                    ; 0xc2e5e vgabios.c:2158
    mov byte [es:si], 021h                    ; 26 c6 04 21                 ; 0xc2e61 vgabios.c:52
    lea si, [bx+031h]                         ; 8d 77 31                    ; 0xc2e65 vgabios.c:2159
    mov byte [es:si], 003h                    ; 26 c6 04 03                 ; 0xc2e68 vgabios.c:52
    lea si, [bx+032h]                         ; 8d 77 32                    ; 0xc2e6c vgabios.c:2160
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc2e6f vgabios.c:52
    mov si, 00089h                            ; be 89 00                    ; 0xc2e73 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2e76
    mov es, ax                                ; 8e c0                       ; 0xc2e79
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2e7b
    mov ah, al                                ; 88 c4                       ; 0xc2e7e vgabios.c:2165
    and ah, 080h                              ; 80 e4 80                    ; 0xc2e80
    movzx si, ah                              ; 0f b6 f4                    ; 0xc2e83
    sar si, 006h                              ; c1 fe 06                    ; 0xc2e86
    and AL, strict byte 010h                  ; 24 10                       ; 0xc2e89
    xor ah, ah                                ; 30 e4                       ; 0xc2e8b
    sar ax, 004h                              ; c1 f8 04                    ; 0xc2e8d
    or ax, si                                 ; 09 f0                       ; 0xc2e90
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc2e92 vgabios.c:2166
    je short 02ea8h                           ; 74 11                       ; 0xc2e95
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc2e97
    je short 02ea4h                           ; 74 08                       ; 0xc2e9a
    test ax, ax                               ; 85 c0                       ; 0xc2e9c
    jne short 02ea8h                          ; 75 08                       ; 0xc2e9e
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc2ea0 vgabios.c:2167
    jmp short 02eaah                          ; eb 06                       ; 0xc2ea2
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc2ea4 vgabios.c:2168
    jmp short 02eaah                          ; eb 02                       ; 0xc2ea6
    xor al, al                                ; 30 c0                       ; 0xc2ea8 vgabios.c:2170
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc2eaa vgabios.c:2172
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2ead vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2eb0
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2eb3 vgabios.c:2175
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc2eb6
    jc short 02ed9h                           ; 72 1f                       ; 0xc2eb8
    cmp AL, strict byte 012h                  ; 3c 12                       ; 0xc2eba
    jnbe short 02ed9h                         ; 77 1b                       ; 0xc2ebc
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc2ebe vgabios.c:2176
    test ax, ax                               ; 85 c0                       ; 0xc2ec1
    je short 02f1bh                           ; 74 56                       ; 0xc2ec3
    mov si, ax                                ; 89 c6                       ; 0xc2ec5 vgabios.c:2177
    shr si, 002h                              ; c1 ee 02                    ; 0xc2ec7
    mov ax, 04000h                            ; b8 00 40                    ; 0xc2eca
    xor dx, dx                                ; 31 d2                       ; 0xc2ecd
    div si                                    ; f7 f6                       ; 0xc2ecf
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc2ed1
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2ed4 vgabios.c:52
    jmp short 02f1bh                          ; eb 42                       ; 0xc2ed7 vgabios.c:2178
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc2ed9
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2edc
    cmp AL, strict byte 013h                  ; 3c 13                       ; 0xc2edf
    jne short 02ef4h                          ; 75 11                       ; 0xc2ee1
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2ee3 vgabios.c:52
    mov byte [es:si], 001h                    ; 26 c6 04 01                 ; 0xc2ee6
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc2eea vgabios.c:2180
    mov word [es:si], 00100h                  ; 26 c7 04 00 01              ; 0xc2eed vgabios.c:62
    jmp short 02f1bh                          ; eb 27                       ; 0xc2ef2 vgabios.c:2181
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc2ef4
    jc short 02f1bh                           ; 72 23                       ; 0xc2ef6
    cmp AL, strict byte 006h                  ; 3c 06                       ; 0xc2ef8
    jnbe short 02f1bh                         ; 77 1f                       ; 0xc2efa
    cmp word [bp-00ah], strict byte 00000h    ; 83 7e f6 00                 ; 0xc2efc vgabios.c:2183
    je short 02f10h                           ; 74 0e                       ; 0xc2f00
    mov ax, 04000h                            ; b8 00 40                    ; 0xc2f02 vgabios.c:2184
    xor dx, dx                                ; 31 d2                       ; 0xc2f05
    div word [bp-00ah]                        ; f7 76 f6                    ; 0xc2f07
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2f0a vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2f0d
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc2f10 vgabios.c:2185
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2f13 vgabios.c:62
    mov word [es:si], strict word 00004h      ; 26 c7 04 04 00              ; 0xc2f16
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2f1b vgabios.c:2187
    cmp AL, strict byte 006h                  ; 3c 06                       ; 0xc2f1e
    je short 02f26h                           ; 74 04                       ; 0xc2f20
    cmp AL, strict byte 011h                  ; 3c 11                       ; 0xc2f22
    jne short 02f31h                          ; 75 0b                       ; 0xc2f24
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc2f26 vgabios.c:2188
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2f29 vgabios.c:62
    mov word [es:si], strict word 00002h      ; 26 c7 04 02 00              ; 0xc2f2c
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2f31 vgabios.c:2190
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc2f34
    jc short 02f8fh                           ; 72 57                       ; 0xc2f36
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc2f38
    je short 02f8fh                           ; 74 53                       ; 0xc2f3a
    lea si, [bx+02dh]                         ; 8d 77 2d                    ; 0xc2f3c vgabios.c:2191
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2f3f vgabios.c:52
    mov byte [es:si], 001h                    ; 26 c6 04 01                 ; 0xc2f42
    mov si, 00084h                            ; be 84 00                    ; 0xc2f46 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2f49
    mov es, ax                                ; 8e c0                       ; 0xc2f4c
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2f4e
    movzx di, al                              ; 0f b6 f8                    ; 0xc2f51 vgabios.c:48
    inc di                                    ; 47                          ; 0xc2f54
    mov si, 00085h                            ; be 85 00                    ; 0xc2f55 vgabios.c:47
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2f58
    xor ah, ah                                ; 30 e4                       ; 0xc2f5b vgabios.c:48
    imul ax, di                               ; 0f af c7                    ; 0xc2f5d
    cmp ax, 0015eh                            ; 3d 5e 01                    ; 0xc2f60 vgabios.c:2193
    jc short 02f73h                           ; 72 0e                       ; 0xc2f63
    jbe short 02f7ch                          ; 76 15                       ; 0xc2f65
    cmp ax, 001e0h                            ; 3d e0 01                    ; 0xc2f67
    je short 02f84h                           ; 74 18                       ; 0xc2f6a
    cmp ax, 00190h                            ; 3d 90 01                    ; 0xc2f6c
    je short 02f80h                           ; 74 0f                       ; 0xc2f6f
    jmp short 02f84h                          ; eb 11                       ; 0xc2f71
    cmp ax, 000c8h                            ; 3d c8 00                    ; 0xc2f73
    jne short 02f84h                          ; 75 0c                       ; 0xc2f76
    xor al, al                                ; 30 c0                       ; 0xc2f78 vgabios.c:2194
    jmp short 02f86h                          ; eb 0a                       ; 0xc2f7a
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc2f7c vgabios.c:2195
    jmp short 02f86h                          ; eb 06                       ; 0xc2f7e
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc2f80 vgabios.c:2196
    jmp short 02f86h                          ; eb 02                       ; 0xc2f82
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc2f84 vgabios.c:2198
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc2f86 vgabios.c:2200
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2f89 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2f8c
    lea di, [bx+033h]                         ; 8d 7f 33                    ; 0xc2f8f vgabios.c:2203
    mov cx, strict word 0000dh                ; b9 0d 00                    ; 0xc2f92
    xor ax, ax                                ; 31 c0                       ; 0xc2f95
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2f97
    jcxz 02f9eh                               ; e3 02                       ; 0xc2f9a
    rep stosb                                 ; f3 aa                       ; 0xc2f9c
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc2f9e vgabios.c:2204
    pop di                                    ; 5f                          ; 0xc2fa1
    pop si                                    ; 5e                          ; 0xc2fa2
    pop cx                                    ; 59                          ; 0xc2fa3
    pop bp                                    ; 5d                          ; 0xc2fa4
    retn                                      ; c3                          ; 0xc2fa5
  ; disGetNextSymbol 0xc2fa6 LB 0x129e -> off=0x0 cb=0000000000000023 uValue=00000000000c2fa6 'biosfn_read_video_state_size2'
biosfn_read_video_state_size2:               ; 0xc2fa6 LB 0x23
    push dx                                   ; 52                          ; 0xc2fa6 vgabios.c:2207
    push bp                                   ; 55                          ; 0xc2fa7
    mov bp, sp                                ; 89 e5                       ; 0xc2fa8
    mov dx, ax                                ; 89 c2                       ; 0xc2faa
    xor ax, ax                                ; 31 c0                       ; 0xc2fac vgabios.c:2211
    test dl, 001h                             ; f6 c2 01                    ; 0xc2fae vgabios.c:2212
    je short 02fb6h                           ; 74 03                       ; 0xc2fb1
    mov ax, strict word 00046h                ; b8 46 00                    ; 0xc2fb3 vgabios.c:2213
    test dl, 002h                             ; f6 c2 02                    ; 0xc2fb6 vgabios.c:2215
    je short 02fbeh                           ; 74 03                       ; 0xc2fb9
    add ax, strict word 0002ah                ; 05 2a 00                    ; 0xc2fbb vgabios.c:2216
    test dl, 004h                             ; f6 c2 04                    ; 0xc2fbe vgabios.c:2218
    je short 02fc6h                           ; 74 03                       ; 0xc2fc1
    add ax, 00304h                            ; 05 04 03                    ; 0xc2fc3 vgabios.c:2219
    pop bp                                    ; 5d                          ; 0xc2fc6 vgabios.c:2222
    pop dx                                    ; 5a                          ; 0xc2fc7
    retn                                      ; c3                          ; 0xc2fc8
  ; disGetNextSymbol 0xc2fc9 LB 0x127b -> off=0x0 cb=0000000000000018 uValue=00000000000c2fc9 'vga_get_video_state_size'
vga_get_video_state_size:                    ; 0xc2fc9 LB 0x18
    push bp                                   ; 55                          ; 0xc2fc9 vgabios.c:2224
    mov bp, sp                                ; 89 e5                       ; 0xc2fca
    push bx                                   ; 53                          ; 0xc2fcc
    mov bx, dx                                ; 89 d3                       ; 0xc2fcd
    call 02fa6h                               ; e8 d4 ff                    ; 0xc2fcf vgabios.c:2227
    add ax, strict word 0003fh                ; 05 3f 00                    ; 0xc2fd2
    shr ax, 006h                              ; c1 e8 06                    ; 0xc2fd5
    mov word [ss:bx], ax                      ; 36 89 07                    ; 0xc2fd8
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2fdb vgabios.c:2228
    pop bx                                    ; 5b                          ; 0xc2fde
    pop bp                                    ; 5d                          ; 0xc2fdf
    retn                                      ; c3                          ; 0xc2fe0
  ; disGetNextSymbol 0xc2fe1 LB 0x1263 -> off=0x0 cb=00000000000002d6 uValue=00000000000c2fe1 'biosfn_save_video_state'
biosfn_save_video_state:                     ; 0xc2fe1 LB 0x2d6
    push bp                                   ; 55                          ; 0xc2fe1 vgabios.c:2230
    mov bp, sp                                ; 89 e5                       ; 0xc2fe2
    push cx                                   ; 51                          ; 0xc2fe4
    push si                                   ; 56                          ; 0xc2fe5
    push di                                   ; 57                          ; 0xc2fe6
    push ax                                   ; 50                          ; 0xc2fe7
    push ax                                   ; 50                          ; 0xc2fe8
    push ax                                   ; 50                          ; 0xc2fe9
    mov cx, dx                                ; 89 d1                       ; 0xc2fea
    mov si, strict word 00063h                ; be 63 00                    ; 0xc2fec vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2fef
    mov es, ax                                ; 8e c0                       ; 0xc2ff2
    mov di, word [es:si]                      ; 26 8b 3c                    ; 0xc2ff4
    mov si, di                                ; 89 fe                       ; 0xc2ff7 vgabios.c:58
    test byte [bp-00ch], 001h                 ; f6 46 f4 01                 ; 0xc2ff9 vgabios.c:2235
    je near 03114h                            ; 0f 84 13 01                 ; 0xc2ffd
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3001 vgabios.c:2236
    in AL, DX                                 ; ec                          ; 0xc3004
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3005
    mov es, cx                                ; 8e c1                       ; 0xc3007 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3009
    inc bx                                    ; 43                          ; 0xc300c vgabios.c:2236
    mov dx, di                                ; 89 fa                       ; 0xc300d
    in AL, DX                                 ; ec                          ; 0xc300f
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3010
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3012 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3015 vgabios.c:2237
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc3016
    in AL, DX                                 ; ec                          ; 0xc3019
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc301a
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc301c vgabios.c:52
    inc bx                                    ; 43                          ; 0xc301f vgabios.c:2238
    mov dx, 003dah                            ; ba da 03                    ; 0xc3020
    in AL, DX                                 ; ec                          ; 0xc3023
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3024
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc3026 vgabios.c:2240
    in AL, DX                                 ; ec                          ; 0xc3029
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc302a
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc302c
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc302f vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3032
    inc bx                                    ; 43                          ; 0xc3035 vgabios.c:2241
    mov dx, 003cah                            ; ba ca 03                    ; 0xc3036
    in AL, DX                                 ; ec                          ; 0xc3039
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc303a
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc303c vgabios.c:52
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc303f vgabios.c:2244
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3042
    add bx, ax                                ; 01 c3                       ; 0xc3045 vgabios.c:2242
    jmp short 0304fh                          ; eb 06                       ; 0xc3047
    cmp word [bp-008h], strict byte 00004h    ; 83 7e f8 04                 ; 0xc3049
    jnbe short 03067h                         ; 77 18                       ; 0xc304d
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc304f vgabios.c:2245
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3052
    out DX, AL                                ; ee                          ; 0xc3055
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc3056 vgabios.c:2246
    in AL, DX                                 ; ec                          ; 0xc3059
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc305a
    mov es, cx                                ; 8e c1                       ; 0xc305c vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc305e
    inc bx                                    ; 43                          ; 0xc3061 vgabios.c:2246
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3062 vgabios.c:2247
    jmp short 03049h                          ; eb e2                       ; 0xc3065
    xor al, al                                ; 30 c0                       ; 0xc3067 vgabios.c:2248
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3069
    out DX, AL                                ; ee                          ; 0xc306c
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc306d vgabios.c:2249
    in AL, DX                                 ; ec                          ; 0xc3070
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3071
    mov es, cx                                ; 8e c1                       ; 0xc3073 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3075
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3078 vgabios.c:2251
    inc bx                                    ; 43                          ; 0xc307d vgabios.c:2249
    jmp short 03086h                          ; eb 06                       ; 0xc307e
    cmp word [bp-008h], strict byte 00018h    ; 83 7e f8 18                 ; 0xc3080
    jnbe short 0309dh                         ; 77 17                       ; 0xc3084
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3086 vgabios.c:2252
    mov dx, si                                ; 89 f2                       ; 0xc3089
    out DX, AL                                ; ee                          ; 0xc308b
    lea dx, [si+001h]                         ; 8d 54 01                    ; 0xc308c vgabios.c:2253
    in AL, DX                                 ; ec                          ; 0xc308f
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3090
    mov es, cx                                ; 8e c1                       ; 0xc3092 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3094
    inc bx                                    ; 43                          ; 0xc3097 vgabios.c:2253
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3098 vgabios.c:2254
    jmp short 03080h                          ; eb e3                       ; 0xc309b
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc309d vgabios.c:2256
    jmp short 030aah                          ; eb 06                       ; 0xc30a2
    cmp word [bp-008h], strict byte 00013h    ; 83 7e f8 13                 ; 0xc30a4
    jnbe short 030ceh                         ; 77 24                       ; 0xc30a8
    mov dx, 003dah                            ; ba da 03                    ; 0xc30aa vgabios.c:2257
    in AL, DX                                 ; ec                          ; 0xc30ad
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc30ae
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc30b0 vgabios.c:2258
    and ax, strict word 00020h                ; 25 20 00                    ; 0xc30b3
    or ax, word [bp-008h]                     ; 0b 46 f8                    ; 0xc30b6
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc30b9
    out DX, AL                                ; ee                          ; 0xc30bc
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc30bd vgabios.c:2259
    in AL, DX                                 ; ec                          ; 0xc30c0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc30c1
    mov es, cx                                ; 8e c1                       ; 0xc30c3 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc30c5
    inc bx                                    ; 43                          ; 0xc30c8 vgabios.c:2259
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc30c9 vgabios.c:2260
    jmp short 030a4h                          ; eb d6                       ; 0xc30cc
    mov dx, 003dah                            ; ba da 03                    ; 0xc30ce vgabios.c:2261
    in AL, DX                                 ; ec                          ; 0xc30d1
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc30d2
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc30d4 vgabios.c:2263
    jmp short 030e1h                          ; eb 06                       ; 0xc30d9
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc30db
    jnbe short 030f9h                         ; 77 18                       ; 0xc30df
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc30e1 vgabios.c:2264
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc30e4
    out DX, AL                                ; ee                          ; 0xc30e7
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc30e8 vgabios.c:2265
    in AL, DX                                 ; ec                          ; 0xc30eb
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc30ec
    mov es, cx                                ; 8e c1                       ; 0xc30ee vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc30f0
    inc bx                                    ; 43                          ; 0xc30f3 vgabios.c:2265
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc30f4 vgabios.c:2266
    jmp short 030dbh                          ; eb e2                       ; 0xc30f7
    mov es, cx                                ; 8e c1                       ; 0xc30f9 vgabios.c:62
    mov word [es:bx], si                      ; 26 89 37                    ; 0xc30fb
    inc bx                                    ; 43                          ; 0xc30fe vgabios.c:2268
    inc bx                                    ; 43                          ; 0xc30ff
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc3100 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3104 vgabios.c:2271
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc3105 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3109 vgabios.c:2272
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc310a vgabios.c:52
    inc bx                                    ; 43                          ; 0xc310e vgabios.c:2273
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc310f vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3113 vgabios.c:2274
    test byte [bp-00ch], 002h                 ; f6 46 f4 02                 ; 0xc3114 vgabios.c:2276
    je near 0325bh                            ; 0f 84 3f 01                 ; 0xc3118
    mov si, strict word 00049h                ; be 49 00                    ; 0xc311c vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc311f
    mov es, ax                                ; 8e c0                       ; 0xc3122
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3124
    mov es, cx                                ; 8e c1                       ; 0xc3127 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3129
    inc bx                                    ; 43                          ; 0xc312c vgabios.c:2277
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc312d vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3130
    mov es, ax                                ; 8e c0                       ; 0xc3133
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3135
    mov es, cx                                ; 8e c1                       ; 0xc3138 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc313a
    inc bx                                    ; 43                          ; 0xc313d vgabios.c:2278
    inc bx                                    ; 43                          ; 0xc313e
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc313f vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3142
    mov es, ax                                ; 8e c0                       ; 0xc3145
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3147
    mov es, cx                                ; 8e c1                       ; 0xc314a vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc314c
    inc bx                                    ; 43                          ; 0xc314f vgabios.c:2279
    inc bx                                    ; 43                          ; 0xc3150
    mov si, strict word 00063h                ; be 63 00                    ; 0xc3151 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3154
    mov es, ax                                ; 8e c0                       ; 0xc3157
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3159
    mov es, cx                                ; 8e c1                       ; 0xc315c vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc315e
    inc bx                                    ; 43                          ; 0xc3161 vgabios.c:2280
    inc bx                                    ; 43                          ; 0xc3162
    mov si, 00084h                            ; be 84 00                    ; 0xc3163 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3166
    mov es, ax                                ; 8e c0                       ; 0xc3169
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc316b
    mov es, cx                                ; 8e c1                       ; 0xc316e vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3170
    inc bx                                    ; 43                          ; 0xc3173 vgabios.c:2281
    mov si, 00085h                            ; be 85 00                    ; 0xc3174 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3177
    mov es, ax                                ; 8e c0                       ; 0xc317a
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc317c
    mov es, cx                                ; 8e c1                       ; 0xc317f vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3181
    inc bx                                    ; 43                          ; 0xc3184 vgabios.c:2282
    inc bx                                    ; 43                          ; 0xc3185
    mov si, 00087h                            ; be 87 00                    ; 0xc3186 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3189
    mov es, ax                                ; 8e c0                       ; 0xc318c
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc318e
    mov es, cx                                ; 8e c1                       ; 0xc3191 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3193
    inc bx                                    ; 43                          ; 0xc3196 vgabios.c:2283
    mov si, 00088h                            ; be 88 00                    ; 0xc3197 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc319a
    mov es, ax                                ; 8e c0                       ; 0xc319d
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc319f
    mov es, cx                                ; 8e c1                       ; 0xc31a2 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc31a4
    inc bx                                    ; 43                          ; 0xc31a7 vgabios.c:2284
    mov si, 00089h                            ; be 89 00                    ; 0xc31a8 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc31ab
    mov es, ax                                ; 8e c0                       ; 0xc31ae
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc31b0
    mov es, cx                                ; 8e c1                       ; 0xc31b3 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc31b5
    inc bx                                    ; 43                          ; 0xc31b8 vgabios.c:2285
    mov si, strict word 00060h                ; be 60 00                    ; 0xc31b9 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc31bc
    mov es, ax                                ; 8e c0                       ; 0xc31bf
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc31c1
    mov es, cx                                ; 8e c1                       ; 0xc31c4 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc31c6
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc31c9 vgabios.c:2287
    inc bx                                    ; 43                          ; 0xc31ce vgabios.c:2286
    inc bx                                    ; 43                          ; 0xc31cf
    jmp short 031d8h                          ; eb 06                       ; 0xc31d0
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc31d2
    jnc short 031f4h                          ; 73 1c                       ; 0xc31d6
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc31d8 vgabios.c:2288
    add si, si                                ; 01 f6                       ; 0xc31db
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc31dd
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc31e0 vgabios.c:57
    mov es, ax                                ; 8e c0                       ; 0xc31e3
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc31e5
    mov es, cx                                ; 8e c1                       ; 0xc31e8 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc31ea
    inc bx                                    ; 43                          ; 0xc31ed vgabios.c:2289
    inc bx                                    ; 43                          ; 0xc31ee
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc31ef vgabios.c:2290
    jmp short 031d2h                          ; eb de                       ; 0xc31f2
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc31f4 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc31f7
    mov es, ax                                ; 8e c0                       ; 0xc31fa
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc31fc
    mov es, cx                                ; 8e c1                       ; 0xc31ff vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3201
    inc bx                                    ; 43                          ; 0xc3204 vgabios.c:2291
    inc bx                                    ; 43                          ; 0xc3205
    mov si, strict word 00062h                ; be 62 00                    ; 0xc3206 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3209
    mov es, ax                                ; 8e c0                       ; 0xc320c
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc320e
    mov es, cx                                ; 8e c1                       ; 0xc3211 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3213
    inc bx                                    ; 43                          ; 0xc3216 vgabios.c:2292
    mov si, strict word 0007ch                ; be 7c 00                    ; 0xc3217 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc321a
    mov es, ax                                ; 8e c0                       ; 0xc321c
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc321e
    mov es, cx                                ; 8e c1                       ; 0xc3221 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3223
    inc bx                                    ; 43                          ; 0xc3226 vgabios.c:2294
    inc bx                                    ; 43                          ; 0xc3227
    mov si, strict word 0007eh                ; be 7e 00                    ; 0xc3228 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc322b
    mov es, ax                                ; 8e c0                       ; 0xc322d
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc322f
    mov es, cx                                ; 8e c1                       ; 0xc3232 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3234
    inc bx                                    ; 43                          ; 0xc3237 vgabios.c:2295
    inc bx                                    ; 43                          ; 0xc3238
    mov si, 0010ch                            ; be 0c 01                    ; 0xc3239 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc323c
    mov es, ax                                ; 8e c0                       ; 0xc323e
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3240
    mov es, cx                                ; 8e c1                       ; 0xc3243 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3245
    inc bx                                    ; 43                          ; 0xc3248 vgabios.c:2296
    inc bx                                    ; 43                          ; 0xc3249
    mov si, 0010eh                            ; be 0e 01                    ; 0xc324a vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc324d
    mov es, ax                                ; 8e c0                       ; 0xc324f
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3251
    mov es, cx                                ; 8e c1                       ; 0xc3254 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3256
    inc bx                                    ; 43                          ; 0xc3259 vgabios.c:2297
    inc bx                                    ; 43                          ; 0xc325a
    test byte [bp-00ch], 004h                 ; f6 46 f4 04                 ; 0xc325b vgabios.c:2299
    je short 032adh                           ; 74 4c                       ; 0xc325f
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc3261 vgabios.c:2301
    in AL, DX                                 ; ec                          ; 0xc3264
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3265
    mov es, cx                                ; 8e c1                       ; 0xc3267 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3269
    inc bx                                    ; 43                          ; 0xc326c vgabios.c:2301
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc326d
    in AL, DX                                 ; ec                          ; 0xc3270
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3271
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3273 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3276 vgabios.c:2302
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc3277
    in AL, DX                                 ; ec                          ; 0xc327a
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc327b
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc327d vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3280 vgabios.c:2303
    xor al, al                                ; 30 c0                       ; 0xc3281
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc3283
    out DX, AL                                ; ee                          ; 0xc3286
    xor ah, ah                                ; 30 e4                       ; 0xc3287 vgabios.c:2306
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3289
    jmp short 03295h                          ; eb 07                       ; 0xc328c
    cmp word [bp-008h], 00300h                ; 81 7e f8 00 03              ; 0xc328e
    jnc short 032a6h                          ; 73 11                       ; 0xc3293
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc3295 vgabios.c:2307
    in AL, DX                                 ; ec                          ; 0xc3298
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3299
    mov es, cx                                ; 8e c1                       ; 0xc329b vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc329d
    inc bx                                    ; 43                          ; 0xc32a0 vgabios.c:2307
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc32a1 vgabios.c:2308
    jmp short 0328eh                          ; eb e8                       ; 0xc32a4
    mov es, cx                                ; 8e c1                       ; 0xc32a6 vgabios.c:52
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc32a8
    inc bx                                    ; 43                          ; 0xc32ac vgabios.c:2309
    mov ax, bx                                ; 89 d8                       ; 0xc32ad vgabios.c:2312
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc32af
    pop di                                    ; 5f                          ; 0xc32b2
    pop si                                    ; 5e                          ; 0xc32b3
    pop cx                                    ; 59                          ; 0xc32b4
    pop bp                                    ; 5d                          ; 0xc32b5
    retn                                      ; c3                          ; 0xc32b6
  ; disGetNextSymbol 0xc32b7 LB 0xf8d -> off=0x0 cb=00000000000002b8 uValue=00000000000c32b7 'biosfn_restore_video_state'
biosfn_restore_video_state:                  ; 0xc32b7 LB 0x2b8
    push bp                                   ; 55                          ; 0xc32b7 vgabios.c:2314
    mov bp, sp                                ; 89 e5                       ; 0xc32b8
    push cx                                   ; 51                          ; 0xc32ba
    push si                                   ; 56                          ; 0xc32bb
    push di                                   ; 57                          ; 0xc32bc
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc32bd
    push ax                                   ; 50                          ; 0xc32c0
    mov cx, dx                                ; 89 d1                       ; 0xc32c1
    test byte [bp-010h], 001h                 ; f6 46 f0 01                 ; 0xc32c3 vgabios.c:2318
    je near 033ffh                            ; 0f 84 34 01                 ; 0xc32c7
    mov dx, 003dah                            ; ba da 03                    ; 0xc32cb vgabios.c:2320
    in AL, DX                                 ; ec                          ; 0xc32ce
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32cf
    lea si, [bx+040h]                         ; 8d 77 40                    ; 0xc32d1 vgabios.c:2322
    mov es, cx                                ; 8e c1                       ; 0xc32d4 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc32d6
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc32d9 vgabios.c:58
    mov si, bx                                ; 89 de                       ; 0xc32dc vgabios.c:2323
    mov word [bp-00eh], strict word 00001h    ; c7 46 f2 01 00              ; 0xc32de vgabios.c:2326
    add bx, strict byte 00005h                ; 83 c3 05                    ; 0xc32e3 vgabios.c:2324
    jmp short 032eeh                          ; eb 06                       ; 0xc32e6
    cmp word [bp-00eh], strict byte 00004h    ; 83 7e f2 04                 ; 0xc32e8
    jnbe short 03304h                         ; 77 16                       ; 0xc32ec
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc32ee vgabios.c:2327
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc32f1
    out DX, AL                                ; ee                          ; 0xc32f4
    mov es, cx                                ; 8e c1                       ; 0xc32f5 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc32f7
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc32fa vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc32fd
    inc bx                                    ; 43                          ; 0xc32fe vgabios.c:2328
    inc word [bp-00eh]                        ; ff 46 f2                    ; 0xc32ff vgabios.c:2329
    jmp short 032e8h                          ; eb e4                       ; 0xc3302
    xor al, al                                ; 30 c0                       ; 0xc3304 vgabios.c:2330
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3306
    out DX, AL                                ; ee                          ; 0xc3309
    mov es, cx                                ; 8e c1                       ; 0xc330a vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc330c
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc330f vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3312
    inc bx                                    ; 43                          ; 0xc3313 vgabios.c:2331
    mov dx, 003cch                            ; ba cc 03                    ; 0xc3314
    in AL, DX                                 ; ec                          ; 0xc3317
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3318
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc331a
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc331c
    cmp word [bp-00ah], 003d4h                ; 81 7e f6 d4 03              ; 0xc331f vgabios.c:2335
    jne short 0332ah                          ; 75 04                       ; 0xc3324
    or byte [bp-008h], 001h                   ; 80 4e f8 01                 ; 0xc3326 vgabios.c:2336
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc332a vgabios.c:2337
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc332d
    out DX, AL                                ; ee                          ; 0xc3330
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc3331 vgabios.c:2340
    mov dx, word [bp-00ah]                    ; 8b 56 f6                    ; 0xc3334
    out DX, ax                                ; ef                          ; 0xc3337
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc3338 vgabios.c:2342
    jmp short 03345h                          ; eb 06                       ; 0xc333d
    cmp word [bp-00eh], strict byte 00018h    ; 83 7e f2 18                 ; 0xc333f
    jnbe short 0335fh                         ; 77 1a                       ; 0xc3343
    cmp word [bp-00eh], strict byte 00011h    ; 83 7e f2 11                 ; 0xc3345 vgabios.c:2343
    je short 03359h                           ; 74 0e                       ; 0xc3349
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc334b vgabios.c:2344
    mov dx, word [bp-00ah]                    ; 8b 56 f6                    ; 0xc334e
    out DX, AL                                ; ee                          ; 0xc3351
    mov es, cx                                ; 8e c1                       ; 0xc3352 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3354
    inc dx                                    ; 42                          ; 0xc3357 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3358
    inc bx                                    ; 43                          ; 0xc3359 vgabios.c:2347
    inc word [bp-00eh]                        ; ff 46 f2                    ; 0xc335a vgabios.c:2348
    jmp short 0333fh                          ; eb e0                       ; 0xc335d
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc335f vgabios.c:2350
    mov dx, word [bp-00ah]                    ; 8b 56 f6                    ; 0xc3361
    out DX, AL                                ; ee                          ; 0xc3364
    lea di, [word bx-00007h]                  ; 8d bf f9 ff                 ; 0xc3365 vgabios.c:2351
    mov es, cx                                ; 8e c1                       ; 0xc3369 vgabios.c:47
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc336b
    inc dx                                    ; 42                          ; 0xc336e vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc336f
    lea di, [si+003h]                         ; 8d 7c 03                    ; 0xc3370 vgabios.c:2354
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc3373 vgabios.c:47
    xor ah, ah                                ; 30 e4                       ; 0xc3376 vgabios.c:48
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc3378
    mov dx, 003dah                            ; ba da 03                    ; 0xc337b vgabios.c:2355
    in AL, DX                                 ; ec                          ; 0xc337e
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc337f
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc3381 vgabios.c:2356
    jmp short 0338eh                          ; eb 06                       ; 0xc3386
    cmp word [bp-00eh], strict byte 00013h    ; 83 7e f2 13                 ; 0xc3388
    jnbe short 033a7h                         ; 77 19                       ; 0xc338c
    mov ax, word [bp-00ch]                    ; 8b 46 f4                    ; 0xc338e vgabios.c:2357
    and ax, strict word 00020h                ; 25 20 00                    ; 0xc3391
    or ax, word [bp-00eh]                     ; 0b 46 f2                    ; 0xc3394
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc3397
    out DX, AL                                ; ee                          ; 0xc339a
    mov es, cx                                ; 8e c1                       ; 0xc339b vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc339d
    out DX, AL                                ; ee                          ; 0xc33a0 vgabios.c:48
    inc bx                                    ; 43                          ; 0xc33a1 vgabios.c:2358
    inc word [bp-00eh]                        ; ff 46 f2                    ; 0xc33a2 vgabios.c:2359
    jmp short 03388h                          ; eb e1                       ; 0xc33a5
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc33a7 vgabios.c:2360
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc33aa
    out DX, AL                                ; ee                          ; 0xc33ad
    mov dx, 003dah                            ; ba da 03                    ; 0xc33ae vgabios.c:2361
    in AL, DX                                 ; ec                          ; 0xc33b1
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc33b2
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc33b4 vgabios.c:2363
    jmp short 033c1h                          ; eb 06                       ; 0xc33b9
    cmp word [bp-00eh], strict byte 00008h    ; 83 7e f2 08                 ; 0xc33bb
    jnbe short 033d7h                         ; 77 16                       ; 0xc33bf
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc33c1 vgabios.c:2364
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc33c4
    out DX, AL                                ; ee                          ; 0xc33c7
    mov es, cx                                ; 8e c1                       ; 0xc33c8 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc33ca
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc33cd vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc33d0
    inc bx                                    ; 43                          ; 0xc33d1 vgabios.c:2365
    inc word [bp-00eh]                        ; ff 46 f2                    ; 0xc33d2 vgabios.c:2366
    jmp short 033bbh                          ; eb e4                       ; 0xc33d5
    add bx, strict byte 00006h                ; 83 c3 06                    ; 0xc33d7 vgabios.c:2367
    mov es, cx                                ; 8e c1                       ; 0xc33da vgabios.c:47
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33dc
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc33df vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc33e2
    inc si                                    ; 46                          ; 0xc33e3 vgabios.c:2370
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33e4 vgabios.c:47
    mov dx, word [bp-00ah]                    ; 8b 56 f6                    ; 0xc33e7 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc33ea
    inc si                                    ; 46                          ; 0xc33eb vgabios.c:2371
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33ec vgabios.c:47
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc33ef vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc33f2
    inc si                                    ; 46                          ; 0xc33f3 vgabios.c:2372
    inc si                                    ; 46                          ; 0xc33f4
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33f5 vgabios.c:47
    mov dx, word [bp-00ah]                    ; 8b 56 f6                    ; 0xc33f8 vgabios.c:48
    add dx, strict byte 00006h                ; 83 c2 06                    ; 0xc33fb
    out DX, AL                                ; ee                          ; 0xc33fe
    test byte [bp-010h], 002h                 ; f6 46 f0 02                 ; 0xc33ff vgabios.c:2376
    je near 03522h                            ; 0f 84 1b 01                 ; 0xc3403
    mov es, cx                                ; 8e c1                       ; 0xc3407 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3409
    mov si, strict word 00049h                ; be 49 00                    ; 0xc340c vgabios.c:52
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc340f
    mov es, dx                                ; 8e c2                       ; 0xc3412
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3414
    inc bx                                    ; 43                          ; 0xc3417 vgabios.c:2377
    mov es, cx                                ; 8e c1                       ; 0xc3418 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc341a
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc341d vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc3420
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3422
    inc bx                                    ; 43                          ; 0xc3425 vgabios.c:2378
    inc bx                                    ; 43                          ; 0xc3426
    mov es, cx                                ; 8e c1                       ; 0xc3427 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3429
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc342c vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc342f
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3431
    inc bx                                    ; 43                          ; 0xc3434 vgabios.c:2379
    inc bx                                    ; 43                          ; 0xc3435
    mov es, cx                                ; 8e c1                       ; 0xc3436 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3438
    mov si, strict word 00063h                ; be 63 00                    ; 0xc343b vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc343e
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3440
    inc bx                                    ; 43                          ; 0xc3443 vgabios.c:2380
    inc bx                                    ; 43                          ; 0xc3444
    mov es, cx                                ; 8e c1                       ; 0xc3445 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3447
    mov si, 00084h                            ; be 84 00                    ; 0xc344a vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc344d
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc344f
    inc bx                                    ; 43                          ; 0xc3452 vgabios.c:2381
    mov es, cx                                ; 8e c1                       ; 0xc3453 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3455
    mov si, 00085h                            ; be 85 00                    ; 0xc3458 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc345b
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc345d
    inc bx                                    ; 43                          ; 0xc3460 vgabios.c:2382
    inc bx                                    ; 43                          ; 0xc3461
    mov es, cx                                ; 8e c1                       ; 0xc3462 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3464
    mov si, 00087h                            ; be 87 00                    ; 0xc3467 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc346a
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc346c
    inc bx                                    ; 43                          ; 0xc346f vgabios.c:2383
    mov es, cx                                ; 8e c1                       ; 0xc3470 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3472
    mov si, 00088h                            ; be 88 00                    ; 0xc3475 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc3478
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc347a
    inc bx                                    ; 43                          ; 0xc347d vgabios.c:2384
    mov es, cx                                ; 8e c1                       ; 0xc347e vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3480
    mov si, 00089h                            ; be 89 00                    ; 0xc3483 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc3486
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3488
    inc bx                                    ; 43                          ; 0xc348b vgabios.c:2385
    mov es, cx                                ; 8e c1                       ; 0xc348c vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc348e
    mov si, strict word 00060h                ; be 60 00                    ; 0xc3491 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc3494
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3496
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc3499 vgabios.c:2387
    inc bx                                    ; 43                          ; 0xc349e vgabios.c:2386
    inc bx                                    ; 43                          ; 0xc349f
    jmp short 034a8h                          ; eb 06                       ; 0xc34a0
    cmp word [bp-00eh], strict byte 00008h    ; 83 7e f2 08                 ; 0xc34a2
    jnc short 034c4h                          ; 73 1c                       ; 0xc34a6
    mov es, cx                                ; 8e c1                       ; 0xc34a8 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc34aa
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc34ad vgabios.c:58
    add si, si                                ; 01 f6                       ; 0xc34b0
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc34b2
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc34b5 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc34b8
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc34ba
    inc bx                                    ; 43                          ; 0xc34bd vgabios.c:2389
    inc bx                                    ; 43                          ; 0xc34be
    inc word [bp-00eh]                        ; ff 46 f2                    ; 0xc34bf vgabios.c:2390
    jmp short 034a2h                          ; eb de                       ; 0xc34c2
    mov es, cx                                ; 8e c1                       ; 0xc34c4 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc34c6
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc34c9 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc34cc
    mov es, dx                                ; 8e c2                       ; 0xc34cf
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc34d1
    inc bx                                    ; 43                          ; 0xc34d4 vgabios.c:2391
    inc bx                                    ; 43                          ; 0xc34d5
    mov es, cx                                ; 8e c1                       ; 0xc34d6 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc34d8
    mov si, strict word 00062h                ; be 62 00                    ; 0xc34db vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc34de
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc34e0
    inc bx                                    ; 43                          ; 0xc34e3 vgabios.c:2392
    mov es, cx                                ; 8e c1                       ; 0xc34e4 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc34e6
    mov si, strict word 0007ch                ; be 7c 00                    ; 0xc34e9 vgabios.c:62
    xor dx, dx                                ; 31 d2                       ; 0xc34ec
    mov es, dx                                ; 8e c2                       ; 0xc34ee
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc34f0
    inc bx                                    ; 43                          ; 0xc34f3 vgabios.c:2394
    inc bx                                    ; 43                          ; 0xc34f4
    mov es, cx                                ; 8e c1                       ; 0xc34f5 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc34f7
    mov si, strict word 0007eh                ; be 7e 00                    ; 0xc34fa vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc34fd
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc34ff
    inc bx                                    ; 43                          ; 0xc3502 vgabios.c:2395
    inc bx                                    ; 43                          ; 0xc3503
    mov es, cx                                ; 8e c1                       ; 0xc3504 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3506
    mov si, 0010ch                            ; be 0c 01                    ; 0xc3509 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc350c
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc350e
    inc bx                                    ; 43                          ; 0xc3511 vgabios.c:2396
    inc bx                                    ; 43                          ; 0xc3512
    mov es, cx                                ; 8e c1                       ; 0xc3513 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3515
    mov si, 0010eh                            ; be 0e 01                    ; 0xc3518 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc351b
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc351d
    inc bx                                    ; 43                          ; 0xc3520 vgabios.c:2397
    inc bx                                    ; 43                          ; 0xc3521
    test byte [bp-010h], 004h                 ; f6 46 f0 04                 ; 0xc3522 vgabios.c:2399
    je short 03565h                           ; 74 3d                       ; 0xc3526
    inc bx                                    ; 43                          ; 0xc3528 vgabios.c:2400
    mov es, cx                                ; 8e c1                       ; 0xc3529 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc352b
    xor ah, ah                                ; 30 e4                       ; 0xc352e vgabios.c:48
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3530
    inc bx                                    ; 43                          ; 0xc3533 vgabios.c:2401
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3534 vgabios.c:47
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc3537 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc353a
    inc bx                                    ; 43                          ; 0xc353b vgabios.c:2402
    xor al, al                                ; 30 c0                       ; 0xc353c
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc353e
    out DX, AL                                ; ee                          ; 0xc3541
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc3542 vgabios.c:2405
    jmp short 0354eh                          ; eb 07                       ; 0xc3545
    cmp word [bp-00eh], 00300h                ; 81 7e f2 00 03              ; 0xc3547
    jnc short 0355dh                          ; 73 0f                       ; 0xc354c
    mov es, cx                                ; 8e c1                       ; 0xc354e vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3550
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc3553 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3556
    inc bx                                    ; 43                          ; 0xc3557 vgabios.c:2406
    inc word [bp-00eh]                        ; ff 46 f2                    ; 0xc3558 vgabios.c:2407
    jmp short 03547h                          ; eb ea                       ; 0xc355b
    inc bx                                    ; 43                          ; 0xc355d vgabios.c:2408
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc355e
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc3561
    out DX, AL                                ; ee                          ; 0xc3564
    mov ax, bx                                ; 89 d8                       ; 0xc3565 vgabios.c:2412
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3567
    pop di                                    ; 5f                          ; 0xc356a
    pop si                                    ; 5e                          ; 0xc356b
    pop cx                                    ; 59                          ; 0xc356c
    pop bp                                    ; 5d                          ; 0xc356d
    retn                                      ; c3                          ; 0xc356e
  ; disGetNextSymbol 0xc356f LB 0xcd5 -> off=0x0 cb=0000000000000027 uValue=00000000000c356f 'find_vga_entry'
find_vga_entry:                              ; 0xc356f LB 0x27
    push bx                                   ; 53                          ; 0xc356f vgabios.c:2421
    push dx                                   ; 52                          ; 0xc3570
    push bp                                   ; 55                          ; 0xc3571
    mov bp, sp                                ; 89 e5                       ; 0xc3572
    mov dl, al                                ; 88 c2                       ; 0xc3574
    mov AH, strict byte 0ffh                  ; b4 ff                       ; 0xc3576 vgabios.c:2423
    xor al, al                                ; 30 c0                       ; 0xc3578 vgabios.c:2424
    jmp short 03582h                          ; eb 06                       ; 0xc357a
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc357c vgabios.c:2425
    cmp AL, strict byte 00fh                  ; 3c 0f                       ; 0xc357e
    jnbe short 03590h                         ; 77 0e                       ; 0xc3580
    movzx bx, al                              ; 0f b6 d8                    ; 0xc3582
    sal bx, 003h                              ; c1 e3 03                    ; 0xc3585
    cmp dl, byte [bx+047ach]                  ; 3a 97 ac 47                 ; 0xc3588
    jne short 0357ch                          ; 75 ee                       ; 0xc358c
    mov ah, al                                ; 88 c4                       ; 0xc358e
    mov al, ah                                ; 88 e0                       ; 0xc3590 vgabios.c:2430
    pop bp                                    ; 5d                          ; 0xc3592
    pop dx                                    ; 5a                          ; 0xc3593
    pop bx                                    ; 5b                          ; 0xc3594
    retn                                      ; c3                          ; 0xc3595
  ; disGetNextSymbol 0xc3596 LB 0xcae -> off=0x0 cb=000000000000000e uValue=00000000000c3596 'readx_byte'
readx_byte:                                  ; 0xc3596 LB 0xe
    push bx                                   ; 53                          ; 0xc3596 vgabios.c:2442
    push bp                                   ; 55                          ; 0xc3597
    mov bp, sp                                ; 89 e5                       ; 0xc3598
    mov bx, dx                                ; 89 d3                       ; 0xc359a
    mov es, ax                                ; 8e c0                       ; 0xc359c vgabios.c:2444
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc359e
    pop bp                                    ; 5d                          ; 0xc35a1 vgabios.c:2445
    pop bx                                    ; 5b                          ; 0xc35a2
    retn                                      ; c3                          ; 0xc35a3
  ; disGetNextSymbol 0xc35a4 LB 0xca0 -> off=0x8a cb=000000000000047c uValue=00000000000c362e 'int10_func'
    db  056h, 04fh, 01ch, 01bh, 013h, 012h, 011h, 010h, 00eh, 00dh, 00ch, 00ah, 009h, 008h, 007h, 006h
    db  005h, 004h, 003h, 002h, 001h, 000h, 0a3h, 03ah, 059h, 036h, 096h, 036h, 0aah, 036h, 0bbh, 036h
    db  0cfh, 036h, 0e0h, 036h, 0ebh, 036h, 025h, 037h, 029h, 037h, 03ah, 037h, 057h, 037h, 074h, 037h
    db  094h, 037h, 0b1h, 037h, 0c8h, 037h, 0d4h, 037h, 0d9h, 038h, 066h, 039h, 093h, 039h, 0a8h, 039h
    db  0eah, 039h, 075h, 03ah, 030h, 024h, 023h, 022h, 021h, 020h, 014h, 012h, 011h, 010h, 004h, 003h
    db  002h, 001h, 000h, 0a3h, 03ah, 0f5h, 037h, 015h, 038h, 031h, 038h, 046h, 038h, 051h, 038h, 0f5h
    db  037h, 015h, 038h, 031h, 038h, 051h, 038h, 066h, 038h, 072h, 038h, 08dh, 038h, 09eh, 038h, 0afh
    db  038h, 0c0h, 038h, 00ah, 009h, 006h, 004h, 002h, 001h, 000h, 067h, 03ah, 012h, 03ah, 020h, 03ah
    db  031h, 03ah, 041h, 03ah, 056h, 03ah, 067h, 03ah, 067h, 03ah
int10_func:                                  ; 0xc362e LB 0x47c
    push bp                                   ; 55                          ; 0xc362e vgabios.c:2523
    mov bp, sp                                ; 89 e5                       ; 0xc362f
    push si                                   ; 56                          ; 0xc3631
    push di                                   ; 57                          ; 0xc3632
    push ax                                   ; 50                          ; 0xc3633
    mov si, word [bp+004h]                    ; 8b 76 04                    ; 0xc3634
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3637 vgabios.c:2528
    shr ax, 008h                              ; c1 e8 08                    ; 0xc363a
    cmp ax, strict word 00056h                ; 3d 56 00                    ; 0xc363d
    jnbe near 03aa3h                          ; 0f 87 5f 04                 ; 0xc3640
    push CS                                   ; 0e                          ; 0xc3644
    pop ES                                    ; 07                          ; 0xc3645
    mov cx, strict word 00017h                ; b9 17 00                    ; 0xc3646
    mov di, 035a4h                            ; bf a4 35                    ; 0xc3649
    repne scasb                               ; f2 ae                       ; 0xc364c
    sal cx, 1                                 ; d1 e1                       ; 0xc364e
    mov di, cx                                ; 89 cf                       ; 0xc3650
    mov ax, word [cs:di+035bah]               ; 2e 8b 85 ba 35              ; 0xc3652
    jmp ax                                    ; ff e0                       ; 0xc3657
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc3659 vgabios.c:2531
    call 01375h                               ; e8 15 dd                    ; 0xc365d
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3660 vgabios.c:2532
    and ax, strict word 0007fh                ; 25 7f 00                    ; 0xc3663
    cmp ax, strict word 00007h                ; 3d 07 00                    ; 0xc3666
    je short 03680h                           ; 74 15                       ; 0xc3669
    cmp ax, strict word 00006h                ; 3d 06 00                    ; 0xc366b
    je short 03677h                           ; 74 07                       ; 0xc366e
    cmp ax, strict word 00005h                ; 3d 05 00                    ; 0xc3670
    jbe short 03680h                          ; 76 0b                       ; 0xc3673
    jmp short 03689h                          ; eb 12                       ; 0xc3675
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3677 vgabios.c:2534
    xor al, al                                ; 30 c0                       ; 0xc367a
    or AL, strict byte 03fh                   ; 0c 3f                       ; 0xc367c
    jmp short 03690h                          ; eb 10                       ; 0xc367e vgabios.c:2535
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3680 vgabios.c:2543
    xor al, al                                ; 30 c0                       ; 0xc3683
    or AL, strict byte 030h                   ; 0c 30                       ; 0xc3685
    jmp short 03690h                          ; eb 07                       ; 0xc3687
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3689 vgabios.c:2546
    xor al, al                                ; 30 c0                       ; 0xc368c
    or AL, strict byte 020h                   ; 0c 20                       ; 0xc368e
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc3690
    jmp near 03aa3h                           ; e9 0d 04                    ; 0xc3693 vgabios.c:2548
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc3696 vgabios.c:2550
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3699
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc369c
    shr ax, 008h                              ; c1 e8 08                    ; 0xc369f
    xor ah, ah                                ; 30 e4                       ; 0xc36a2
    call 0112eh                               ; e8 87 da                    ; 0xc36a4
    jmp near 03aa3h                           ; e9 f9 03                    ; 0xc36a7 vgabios.c:2551
    mov dx, word [bp+00eh]                    ; 8b 56 0e                    ; 0xc36aa vgabios.c:2553
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc36ad
    shr ax, 008h                              ; c1 e8 08                    ; 0xc36b0
    xor ah, ah                                ; 30 e4                       ; 0xc36b3
    call 01224h                               ; e8 6c db                    ; 0xc36b5
    jmp near 03aa3h                           ; e9 e8 03                    ; 0xc36b8 vgabios.c:2554
    lea bx, [bp+00eh]                         ; 8d 5e 0e                    ; 0xc36bb vgabios.c:2556
    lea dx, [bp+010h]                         ; 8d 56 10                    ; 0xc36be
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc36c1
    shr ax, 008h                              ; c1 e8 08                    ; 0xc36c4
    xor ah, ah                                ; 30 e4                       ; 0xc36c7
    call 00a93h                               ; e8 c7 d3                    ; 0xc36c9
    jmp near 03aa3h                           ; e9 d4 03                    ; 0xc36cc vgabios.c:2557
    xor ax, ax                                ; 31 c0                       ; 0xc36cf vgabios.c:2563
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc36d1
    mov word [bp+00ch], ax                    ; 89 46 0c                    ; 0xc36d4 vgabios.c:2564
    mov word [bp+010h], ax                    ; 89 46 10                    ; 0xc36d7 vgabios.c:2565
    mov word [bp+00eh], ax                    ; 89 46 0e                    ; 0xc36da vgabios.c:2566
    jmp near 03aa3h                           ; e9 c3 03                    ; 0xc36dd vgabios.c:2567
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc36e0 vgabios.c:2569
    xor ah, ah                                ; 30 e4                       ; 0xc36e3
    call 01295h                               ; e8 ad db                    ; 0xc36e5
    jmp near 03aa3h                           ; e9 b8 03                    ; 0xc36e8 vgabios.c:2570
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc36eb vgabios.c:2572
    push ax                                   ; 50                          ; 0xc36ee
    mov ax, 000ffh                            ; b8 ff 00                    ; 0xc36ef
    push ax                                   ; 50                          ; 0xc36f2
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc36f3
    xor ah, ah                                ; 30 e4                       ; 0xc36f6
    push ax                                   ; 50                          ; 0xc36f8
    mov ax, word [bp+00eh]                    ; 8b 46 0e                    ; 0xc36f9
    shr ax, 008h                              ; c1 e8 08                    ; 0xc36fc
    xor ah, ah                                ; 30 e4                       ; 0xc36ff
    push ax                                   ; 50                          ; 0xc3701
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc3702
    movzx cx, al                              ; 0f b6 c8                    ; 0xc3705
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3708
    shr ax, 008h                              ; c1 e8 08                    ; 0xc370b
    movzx bx, al                              ; 0f b6 d8                    ; 0xc370e
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3711
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3714
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3717
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc371a
    xor ah, ah                                ; 30 e4                       ; 0xc371d
    call 01afeh                               ; e8 dc e3                    ; 0xc371f
    jmp near 03aa3h                           ; e9 7e 03                    ; 0xc3722 vgabios.c:2573
    xor ax, ax                                ; 31 c0                       ; 0xc3725 vgabios.c:2575
    jmp short 036eeh                          ; eb c5                       ; 0xc3727
    lea dx, [bp+012h]                         ; 8d 56 12                    ; 0xc3729 vgabios.c:2578
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc372c
    shr ax, 008h                              ; c1 e8 08                    ; 0xc372f
    xor ah, ah                                ; 30 e4                       ; 0xc3732
    call 00d9eh                               ; e8 67 d6                    ; 0xc3734
    jmp near 03aa3h                           ; e9 69 03                    ; 0xc3737 vgabios.c:2579
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc373a vgabios.c:2581
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc373d
    movzx bx, al                              ; 0f b6 d8                    ; 0xc3740
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3743
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3746
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3749
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc374c
    xor ah, ah                                ; 30 e4                       ; 0xc374f
    call 02381h                               ; e8 2d ec                    ; 0xc3751
    jmp near 03aa3h                           ; e9 4c 03                    ; 0xc3754 vgabios.c:2582
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc3757 vgabios.c:2584
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc375a
    movzx bx, al                              ; 0f b6 d8                    ; 0xc375d
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3760
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3763
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3766
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3769
    xor ah, ah                                ; 30 e4                       ; 0xc376c
    call 024d8h                               ; e8 67 ed                    ; 0xc376e
    jmp near 03aa3h                           ; e9 2f 03                    ; 0xc3771 vgabios.c:2585
    mov cx, word [bp+00eh]                    ; 8b 4e 0e                    ; 0xc3774 vgabios.c:2587
    mov bx, word [bp+010h]                    ; 8b 5e 10                    ; 0xc3777
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc377a
    movzx dx, al                              ; 0f b6 d0                    ; 0xc377d
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3780
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3783
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc3786
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc3789
    xor ah, ah                                ; 30 e4                       ; 0xc378c
    call 0262ah                               ; e8 99 ee                    ; 0xc378e
    jmp near 03aa3h                           ; e9 0f 03                    ; 0xc3791 vgabios.c:2588
    lea cx, [bp+012h]                         ; 8d 4e 12                    ; 0xc3794 vgabios.c:2590
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3797
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc379a
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc379d
    shr ax, 008h                              ; c1 e8 08                    ; 0xc37a0
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc37a3
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc37a6
    xor ah, ah                                ; 30 e4                       ; 0xc37a9
    call 00f4ch                               ; e8 9e d7                    ; 0xc37ab
    jmp near 03aa3h                           ; e9 f2 02                    ; 0xc37ae vgabios.c:2591
    mov cx, strict word 00002h                ; b9 02 00                    ; 0xc37b1 vgabios.c:2599
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc37b4
    movzx bx, al                              ; 0f b6 d8                    ; 0xc37b7
    mov dx, 000ffh                            ; ba ff 00                    ; 0xc37ba
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc37bd
    xor ah, ah                                ; 30 e4                       ; 0xc37c0
    call 0278fh                               ; e8 ca ef                    ; 0xc37c2
    jmp near 03aa3h                           ; e9 db 02                    ; 0xc37c5 vgabios.c:2600
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc37c8 vgabios.c:2603
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc37cb
    call 010a2h                               ; e8 d1 d8                    ; 0xc37ce
    jmp near 03aa3h                           ; e9 cf 02                    ; 0xc37d1 vgabios.c:2604
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc37d4 vgabios.c:2606
    xor ah, ah                                ; 30 e4                       ; 0xc37d7
    cmp ax, strict word 00030h                ; 3d 30 00                    ; 0xc37d9
    jnbe near 03aa3h                          ; 0f 87 c3 02                 ; 0xc37dc
    push CS                                   ; 0e                          ; 0xc37e0
    pop ES                                    ; 07                          ; 0xc37e1
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc37e2
    mov di, 035e8h                            ; bf e8 35                    ; 0xc37e5
    repne scasb                               ; f2 ae                       ; 0xc37e8
    sal cx, 1                                 ; d1 e1                       ; 0xc37ea
    mov di, cx                                ; 89 cf                       ; 0xc37ec
    mov ax, word [cs:di+035f7h]               ; 2e 8b 85 f7 35              ; 0xc37ee
    jmp ax                                    ; ff e0                       ; 0xc37f3
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc37f5 vgabios.c:2610
    shr ax, 008h                              ; c1 e8 08                    ; 0xc37f8
    xor ah, ah                                ; 30 e4                       ; 0xc37fb
    push ax                                   ; 50                          ; 0xc37fd
    movzx ax, byte [bp+00ch]                  ; 0f b6 46 0c                 ; 0xc37fe
    push ax                                   ; 50                          ; 0xc3802
    push word [bp+00eh]                       ; ff 76 0e                    ; 0xc3803
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc3806
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc380a
    mov bx, word [bp+008h]                    ; 8b 5e 08                    ; 0xc380d
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3810
    jmp short 0382bh                          ; eb 16                       ; 0xc3813
    push strict byte 0000eh                   ; 6a 0e                       ; 0xc3815 vgabios.c:2614
    movzx ax, byte [bp+00ch]                  ; 0f b6 46 0c                 ; 0xc3817
    push ax                                   ; 50                          ; 0xc381b
    push strict byte 00000h                   ; 6a 00                       ; 0xc381c
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc381e
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3822
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc3825
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc3828
    call 02b8ch                               ; e8 5e f3                    ; 0xc382b
    jmp near 03aa3h                           ; e9 72 02                    ; 0xc382e
    push strict byte 00008h                   ; 6a 08                       ; 0xc3831 vgabios.c:2618
    movzx ax, byte [bp+00ch]                  ; 0f b6 46 0c                 ; 0xc3833
    push ax                                   ; 50                          ; 0xc3837
    push strict byte 00000h                   ; 6a 00                       ; 0xc3838
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc383a
    mov cx, 00100h                            ; b9 00 01                    ; 0xc383e
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc3841
    jmp short 03828h                          ; eb e2                       ; 0xc3844
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3846 vgabios.c:2621
    xor ah, ah                                ; 30 e4                       ; 0xc3849
    call 02af5h                               ; e8 a7 f2                    ; 0xc384b
    jmp near 03aa3h                           ; e9 52 02                    ; 0xc384e vgabios.c:2622
    push strict byte 00010h                   ; 6a 10                       ; 0xc3851 vgabios.c:2625
    movzx ax, byte [bp+00ch]                  ; 0f b6 46 0c                 ; 0xc3853
    push ax                                   ; 50                          ; 0xc3857
    push strict byte 00000h                   ; 6a 00                       ; 0xc3858
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc385a
    mov cx, 00100h                            ; b9 00 01                    ; 0xc385e
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc3861
    jmp short 03828h                          ; eb c2                       ; 0xc3864
    mov dx, word [bp+008h]                    ; 8b 56 08                    ; 0xc3866 vgabios.c:2628
    mov ax, word [bp+016h]                    ; 8b 46 16                    ; 0xc3869
    call 02c08h                               ; e8 99 f3                    ; 0xc386c
    jmp near 03aa3h                           ; e9 31 02                    ; 0xc386f vgabios.c:2629
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3872 vgabios.c:2631
    xor ah, ah                                ; 30 e4                       ; 0xc3875
    push ax                                   ; 50                          ; 0xc3877
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3878
    movzx cx, al                              ; 0f b6 c8                    ; 0xc387b
    mov bx, word [bp+010h]                    ; 8b 5e 10                    ; 0xc387e
    mov dx, word [bp+008h]                    ; 8b 56 08                    ; 0xc3881
    mov ax, word [bp+016h]                    ; 8b 46 16                    ; 0xc3884
    call 02c67h                               ; e8 dd f3                    ; 0xc3887
    jmp near 03aa3h                           ; e9 16 02                    ; 0xc388a vgabios.c:2632
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc388d vgabios.c:2634
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3890
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3893
    xor ah, ah                                ; 30 e4                       ; 0xc3896
    call 02c83h                               ; e8 e8 f3                    ; 0xc3898
    jmp near 03aa3h                           ; e9 05 02                    ; 0xc389b vgabios.c:2635
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc389e vgabios.c:2637
    movzx dx, al                              ; 0f b6 d0                    ; 0xc38a1
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc38a4
    xor ah, ah                                ; 30 e4                       ; 0xc38a7
    call 02ca1h                               ; e8 f5 f3                    ; 0xc38a9
    jmp near 03aa3h                           ; e9 f4 01                    ; 0xc38ac vgabios.c:2638
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc38af vgabios.c:2640
    movzx dx, al                              ; 0f b6 d0                    ; 0xc38b2
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc38b5
    xor ah, ah                                ; 30 e4                       ; 0xc38b8
    call 02cbfh                               ; e8 02 f4                    ; 0xc38ba
    jmp near 03aa3h                           ; e9 e3 01                    ; 0xc38bd vgabios.c:2641
    lea ax, [bp+00eh]                         ; 8d 46 0e                    ; 0xc38c0 vgabios.c:2643
    push ax                                   ; 50                          ; 0xc38c3
    lea cx, [bp+010h]                         ; 8d 4e 10                    ; 0xc38c4
    lea bx, [bp+008h]                         ; 8d 5e 08                    ; 0xc38c7
    lea dx, [bp+016h]                         ; 8d 56 16                    ; 0xc38ca
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc38cd
    shr ax, 008h                              ; c1 e8 08                    ; 0xc38d0
    call 00ec9h                               ; e8 f3 d5                    ; 0xc38d3
    jmp near 03aa3h                           ; e9 ca 01                    ; 0xc38d6 vgabios.c:2651
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc38d9 vgabios.c:2653
    xor ah, ah                                ; 30 e4                       ; 0xc38dc
    cmp ax, strict word 00034h                ; 3d 34 00                    ; 0xc38de
    jc short 038f2h                           ; 72 0f                       ; 0xc38e1
    jbe short 03925h                          ; 76 40                       ; 0xc38e3
    cmp ax, strict word 00036h                ; 3d 36 00                    ; 0xc38e5
    je short 0395ch                           ; 74 72                       ; 0xc38e8
    cmp ax, strict word 00035h                ; 3d 35 00                    ; 0xc38ea
    je short 0394dh                           ; 74 5e                       ; 0xc38ed
    jmp near 03aa3h                           ; e9 b1 01                    ; 0xc38ef
    cmp ax, strict word 00030h                ; 3d 30 00                    ; 0xc38f2
    je short 03904h                           ; 74 0d                       ; 0xc38f5
    cmp ax, strict word 00020h                ; 3d 20 00                    ; 0xc38f7
    jne near 03aa3h                           ; 0f 85 a5 01                 ; 0xc38fa
    call 02cddh                               ; e8 dc f3                    ; 0xc38fe vgabios.c:2656
    jmp near 03aa3h                           ; e9 9f 01                    ; 0xc3901 vgabios.c:2657
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3904 vgabios.c:2659
    xor ah, ah                                ; 30 e4                       ; 0xc3907
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3909
    jnbe near 03aa3h                          ; 0f 87 93 01                 ; 0xc390c
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3910 vgabios.c:2660
    xor ah, ah                                ; 30 e4                       ; 0xc3913
    call 02ce2h                               ; e8 ca f3                    ; 0xc3915
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3918 vgabios.c:2661
    xor al, al                                ; 30 c0                       ; 0xc391b
    or AL, strict byte 012h                   ; 0c 12                       ; 0xc391d
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc391f
    jmp near 03aa3h                           ; e9 7e 01                    ; 0xc3922 vgabios.c:2663
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3925 vgabios.c:2665
    xor ah, ah                                ; 30 e4                       ; 0xc3928
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc392a
    jnc short 03947h                          ; 73 18                       ; 0xc392d
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc392f vgabios.c:45
    mov si, 00087h                            ; be 87 00                    ; 0xc3932
    mov es, ax                                ; 8e c0                       ; 0xc3935 vgabios.c:47
    mov ah, byte [es:si]                      ; 26 8a 24                    ; 0xc3937
    and ah, 0feh                              ; 80 e4 fe                    ; 0xc393a vgabios.c:48
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc393d
    or al, ah                                 ; 08 e0                       ; 0xc3940
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3942 vgabios.c:52
    jmp short 03918h                          ; eb d1                       ; 0xc3945
    mov byte [bp+012h], ah                    ; 88 66 12                    ; 0xc3947 vgabios.c:2671
    jmp near 03aa3h                           ; e9 56 01                    ; 0xc394a vgabios.c:2672
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc394d vgabios.c:2674
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3951
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3954
    call 02d14h                               ; e8 ba f3                    ; 0xc3957
    jmp short 03918h                          ; eb bc                       ; 0xc395a
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc395c vgabios.c:2678
    xor ah, ah                                ; 30 e4                       ; 0xc395f
    call 02d19h                               ; e8 b5 f3                    ; 0xc3961
    jmp short 03918h                          ; eb b2                       ; 0xc3964
    push word [bp+008h]                       ; ff 76 08                    ; 0xc3966 vgabios.c:2688
    push word [bp+016h]                       ; ff 76 16                    ; 0xc3969
    movzx ax, byte [bp+00eh]                  ; 0f b6 46 0e                 ; 0xc396c
    push ax                                   ; 50                          ; 0xc3970
    mov ax, word [bp+00eh]                    ; 8b 46 0e                    ; 0xc3971
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3974
    xor ah, ah                                ; 30 e4                       ; 0xc3977
    push ax                                   ; 50                          ; 0xc3979
    movzx bx, byte [bp+00ch]                  ; 0f b6 5e 0c                 ; 0xc397a
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc397e
    shr dx, 008h                              ; c1 ea 08                    ; 0xc3981
    xor dh, dh                                ; 30 f6                       ; 0xc3984
    movzx ax, byte [bp+012h]                  ; 0f b6 46 12                 ; 0xc3986
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc398a
    call 02d1eh                               ; e8 8e f3                    ; 0xc398d
    jmp near 03aa3h                           ; e9 10 01                    ; 0xc3990 vgabios.c:2689
    mov bx, si                                ; 89 f3                       ; 0xc3993 vgabios.c:2691
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3995
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3998
    call 02db4h                               ; e8 16 f4                    ; 0xc399b
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc399e vgabios.c:2692
    xor al, al                                ; 30 c0                       ; 0xc39a1
    or AL, strict byte 01bh                   ; 0c 1b                       ; 0xc39a3
    jmp near 0391fh                           ; e9 77 ff                    ; 0xc39a5
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc39a8 vgabios.c:2695
    xor ah, ah                                ; 30 e4                       ; 0xc39ab
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc39ad
    je short 039d4h                           ; 74 22                       ; 0xc39b0
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc39b2
    je short 039c6h                           ; 74 0f                       ; 0xc39b5
    test ax, ax                               ; 85 c0                       ; 0xc39b7
    jne short 039e0h                          ; 75 25                       ; 0xc39b9
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc39bb vgabios.c:2698
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc39be
    call 02fc9h                               ; e8 05 f6                    ; 0xc39c1
    jmp short 039e0h                          ; eb 1a                       ; 0xc39c4 vgabios.c:2699
    mov bx, word [bp+00ch]                    ; 8b 5e 0c                    ; 0xc39c6 vgabios.c:2701
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc39c9
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc39cc
    call 02fe1h                               ; e8 0f f6                    ; 0xc39cf
    jmp short 039e0h                          ; eb 0c                       ; 0xc39d2 vgabios.c:2702
    mov bx, word [bp+00ch]                    ; 8b 5e 0c                    ; 0xc39d4 vgabios.c:2704
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc39d7
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc39da
    call 032b7h                               ; e8 d7 f8                    ; 0xc39dd
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc39e0 vgabios.c:2711
    xor al, al                                ; 30 c0                       ; 0xc39e3
    or AL, strict byte 01ch                   ; 0c 1c                       ; 0xc39e5
    jmp near 0391fh                           ; e9 35 ff                    ; 0xc39e7
    call 007c8h                               ; e8 db cd                    ; 0xc39ea vgabios.c:2716
    test ax, ax                               ; 85 c0                       ; 0xc39ed
    je near 03a6eh                            ; 0f 84 7b 00                 ; 0xc39ef
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc39f3 vgabios.c:2717
    xor ah, ah                                ; 30 e4                       ; 0xc39f6
    cmp ax, strict word 0000ah                ; 3d 0a 00                    ; 0xc39f8
    jnbe short 03a67h                         ; 77 6a                       ; 0xc39fb
    push CS                                   ; 0e                          ; 0xc39fd
    pop ES                                    ; 07                          ; 0xc39fe
    mov cx, strict word 00008h                ; b9 08 00                    ; 0xc39ff
    mov di, 03617h                            ; bf 17 36                    ; 0xc3a02
    repne scasb                               ; f2 ae                       ; 0xc3a05
    sal cx, 1                                 ; d1 e1                       ; 0xc3a07
    mov di, cx                                ; 89 cf                       ; 0xc3a09
    mov ax, word [cs:di+0361eh]               ; 2e 8b 85 1e 36              ; 0xc3a0b
    jmp ax                                    ; ff e0                       ; 0xc3a10
    mov bx, si                                ; 89 f3                       ; 0xc3a12 vgabios.c:2720
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3a14
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3a17
    call 03c74h                               ; e8 57 02                    ; 0xc3a1a
    jmp near 03aa3h                           ; e9 83 00                    ; 0xc3a1d vgabios.c:2721
    mov cx, si                                ; 89 f1                       ; 0xc3a20 vgabios.c:2723
    mov bx, word [bp+016h]                    ; 8b 5e 16                    ; 0xc3a22
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3a25
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3a28
    call 03d99h                               ; e8 6b 03                    ; 0xc3a2b
    jmp near 03aa3h                           ; e9 72 00                    ; 0xc3a2e vgabios.c:2724
    mov cx, si                                ; 89 f1                       ; 0xc3a31 vgabios.c:2726
    mov bx, word [bp+016h]                    ; 8b 5e 16                    ; 0xc3a33
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc3a36
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3a39
    call 03e34h                               ; e8 f5 03                    ; 0xc3a3c
    jmp short 03aa3h                          ; eb 62                       ; 0xc3a3f vgabios.c:2727
    lea ax, [bp+00ch]                         ; 8d 46 0c                    ; 0xc3a41 vgabios.c:2729
    push ax                                   ; 50                          ; 0xc3a44
    mov cx, word [bp+016h]                    ; 8b 4e 16                    ; 0xc3a45
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3a48
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3a4b
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3a4e
    call 04004h                               ; e8 b0 05                    ; 0xc3a51
    jmp short 03aa3h                          ; eb 4d                       ; 0xc3a54 vgabios.c:2730
    lea cx, [bp+00eh]                         ; 8d 4e 0e                    ; 0xc3a56 vgabios.c:2732
    lea bx, [bp+010h]                         ; 8d 5e 10                    ; 0xc3a59
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3a5c
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3a5f
    call 04090h                               ; e8 2b 06                    ; 0xc3a62
    jmp short 03aa3h                          ; eb 3c                       ; 0xc3a65 vgabios.c:2733
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3a67 vgabios.c:2755
    jmp short 03aa3h                          ; eb 35                       ; 0xc3a6c vgabios.c:2758
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3a6e vgabios.c:2760
    jmp short 03aa3h                          ; eb 2e                       ; 0xc3a73 vgabios.c:2762
    call 007c8h                               ; e8 50 cd                    ; 0xc3a75 vgabios.c:2764
    test ax, ax                               ; 85 c0                       ; 0xc3a78
    je short 03a9eh                           ; 74 22                       ; 0xc3a7a
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3a7c vgabios.c:2765
    xor ah, ah                                ; 30 e4                       ; 0xc3a7f
    cmp ax, strict word 00042h                ; 3d 42 00                    ; 0xc3a81
    jne short 03a97h                          ; 75 11                       ; 0xc3a84
    lea cx, [bp+00eh]                         ; 8d 4e 0e                    ; 0xc3a86 vgabios.c:2768
    lea bx, [bp+010h]                         ; 8d 5e 10                    ; 0xc3a89
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3a8c
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3a8f
    call 0415fh                               ; e8 ca 06                    ; 0xc3a92
    jmp short 03aa3h                          ; eb 0c                       ; 0xc3a95 vgabios.c:2769
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3a97 vgabios.c:2771
    jmp short 03aa3h                          ; eb 05                       ; 0xc3a9c vgabios.c:2774
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3a9e vgabios.c:2776
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3aa3 vgabios.c:2786
    pop di                                    ; 5f                          ; 0xc3aa6
    pop si                                    ; 5e                          ; 0xc3aa7
    pop bp                                    ; 5d                          ; 0xc3aa8
    retn                                      ; c3                          ; 0xc3aa9
  ; disGetNextSymbol 0xc3aaa LB 0x79a -> off=0x0 cb=000000000000001f uValue=00000000000c3aaa 'dispi_set_xres'
dispi_set_xres:                              ; 0xc3aaa LB 0x1f
    push bp                                   ; 55                          ; 0xc3aaa vbe.c:100
    mov bp, sp                                ; 89 e5                       ; 0xc3aab
    push bx                                   ; 53                          ; 0xc3aad
    push dx                                   ; 52                          ; 0xc3aae
    mov bx, ax                                ; 89 c3                       ; 0xc3aaf
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc3ab1 vbe.c:105
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3ab4
    call 00570h                               ; e8 b6 ca                    ; 0xc3ab7
    mov ax, bx                                ; 89 d8                       ; 0xc3aba vbe.c:106
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3abc
    call 00570h                               ; e8 ae ca                    ; 0xc3abf
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3ac2 vbe.c:107
    pop dx                                    ; 5a                          ; 0xc3ac5
    pop bx                                    ; 5b                          ; 0xc3ac6
    pop bp                                    ; 5d                          ; 0xc3ac7
    retn                                      ; c3                          ; 0xc3ac8
  ; disGetNextSymbol 0xc3ac9 LB 0x77b -> off=0x0 cb=000000000000001f uValue=00000000000c3ac9 'dispi_set_yres'
dispi_set_yres:                              ; 0xc3ac9 LB 0x1f
    push bp                                   ; 55                          ; 0xc3ac9 vbe.c:109
    mov bp, sp                                ; 89 e5                       ; 0xc3aca
    push bx                                   ; 53                          ; 0xc3acc
    push dx                                   ; 52                          ; 0xc3acd
    mov bx, ax                                ; 89 c3                       ; 0xc3ace
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3ad0 vbe.c:114
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3ad3
    call 00570h                               ; e8 97 ca                    ; 0xc3ad6
    mov ax, bx                                ; 89 d8                       ; 0xc3ad9 vbe.c:115
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3adb
    call 00570h                               ; e8 8f ca                    ; 0xc3ade
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3ae1 vbe.c:116
    pop dx                                    ; 5a                          ; 0xc3ae4
    pop bx                                    ; 5b                          ; 0xc3ae5
    pop bp                                    ; 5d                          ; 0xc3ae6
    retn                                      ; c3                          ; 0xc3ae7
  ; disGetNextSymbol 0xc3ae8 LB 0x75c -> off=0x0 cb=0000000000000019 uValue=00000000000c3ae8 'dispi_get_yres'
dispi_get_yres:                              ; 0xc3ae8 LB 0x19
    push bp                                   ; 55                          ; 0xc3ae8 vbe.c:118
    mov bp, sp                                ; 89 e5                       ; 0xc3ae9
    push dx                                   ; 52                          ; 0xc3aeb
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3aec vbe.c:120
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3aef
    call 00570h                               ; e8 7b ca                    ; 0xc3af2
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3af5 vbe.c:121
    call 00577h                               ; e8 7c ca                    ; 0xc3af8
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3afb vbe.c:122
    pop dx                                    ; 5a                          ; 0xc3afe
    pop bp                                    ; 5d                          ; 0xc3aff
    retn                                      ; c3                          ; 0xc3b00
  ; disGetNextSymbol 0xc3b01 LB 0x743 -> off=0x0 cb=000000000000001f uValue=00000000000c3b01 'dispi_set_bpp'
dispi_set_bpp:                               ; 0xc3b01 LB 0x1f
    push bp                                   ; 55                          ; 0xc3b01 vbe.c:124
    mov bp, sp                                ; 89 e5                       ; 0xc3b02
    push bx                                   ; 53                          ; 0xc3b04
    push dx                                   ; 52                          ; 0xc3b05
    mov bx, ax                                ; 89 c3                       ; 0xc3b06
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3b08 vbe.c:129
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3b0b
    call 00570h                               ; e8 5f ca                    ; 0xc3b0e
    mov ax, bx                                ; 89 d8                       ; 0xc3b11 vbe.c:130
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3b13
    call 00570h                               ; e8 57 ca                    ; 0xc3b16
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3b19 vbe.c:131
    pop dx                                    ; 5a                          ; 0xc3b1c
    pop bx                                    ; 5b                          ; 0xc3b1d
    pop bp                                    ; 5d                          ; 0xc3b1e
    retn                                      ; c3                          ; 0xc3b1f
  ; disGetNextSymbol 0xc3b20 LB 0x724 -> off=0x0 cb=0000000000000019 uValue=00000000000c3b20 'dispi_get_bpp'
dispi_get_bpp:                               ; 0xc3b20 LB 0x19
    push bp                                   ; 55                          ; 0xc3b20 vbe.c:133
    mov bp, sp                                ; 89 e5                       ; 0xc3b21
    push dx                                   ; 52                          ; 0xc3b23
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3b24 vbe.c:135
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3b27
    call 00570h                               ; e8 43 ca                    ; 0xc3b2a
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3b2d vbe.c:136
    call 00577h                               ; e8 44 ca                    ; 0xc3b30
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3b33 vbe.c:137
    pop dx                                    ; 5a                          ; 0xc3b36
    pop bp                                    ; 5d                          ; 0xc3b37
    retn                                      ; c3                          ; 0xc3b38
  ; disGetNextSymbol 0xc3b39 LB 0x70b -> off=0x0 cb=000000000000001f uValue=00000000000c3b39 'dispi_set_virt_width'
dispi_set_virt_width:                        ; 0xc3b39 LB 0x1f
    push bp                                   ; 55                          ; 0xc3b39 vbe.c:139
    mov bp, sp                                ; 89 e5                       ; 0xc3b3a
    push bx                                   ; 53                          ; 0xc3b3c
    push dx                                   ; 52                          ; 0xc3b3d
    mov bx, ax                                ; 89 c3                       ; 0xc3b3e
    mov ax, strict word 00006h                ; b8 06 00                    ; 0xc3b40 vbe.c:144
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3b43
    call 00570h                               ; e8 27 ca                    ; 0xc3b46
    mov ax, bx                                ; 89 d8                       ; 0xc3b49 vbe.c:145
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3b4b
    call 00570h                               ; e8 1f ca                    ; 0xc3b4e
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3b51 vbe.c:146
    pop dx                                    ; 5a                          ; 0xc3b54
    pop bx                                    ; 5b                          ; 0xc3b55
    pop bp                                    ; 5d                          ; 0xc3b56
    retn                                      ; c3                          ; 0xc3b57
  ; disGetNextSymbol 0xc3b58 LB 0x6ec -> off=0x0 cb=0000000000000019 uValue=00000000000c3b58 'dispi_get_virt_width'
dispi_get_virt_width:                        ; 0xc3b58 LB 0x19
    push bp                                   ; 55                          ; 0xc3b58 vbe.c:148
    mov bp, sp                                ; 89 e5                       ; 0xc3b59
    push dx                                   ; 52                          ; 0xc3b5b
    mov ax, strict word 00006h                ; b8 06 00                    ; 0xc3b5c vbe.c:150
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3b5f
    call 00570h                               ; e8 0b ca                    ; 0xc3b62
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3b65 vbe.c:151
    call 00577h                               ; e8 0c ca                    ; 0xc3b68
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3b6b vbe.c:152
    pop dx                                    ; 5a                          ; 0xc3b6e
    pop bp                                    ; 5d                          ; 0xc3b6f
    retn                                      ; c3                          ; 0xc3b70
  ; disGetNextSymbol 0xc3b71 LB 0x6d3 -> off=0x0 cb=0000000000000019 uValue=00000000000c3b71 'dispi_get_virt_height'
dispi_get_virt_height:                       ; 0xc3b71 LB 0x19
    push bp                                   ; 55                          ; 0xc3b71 vbe.c:154
    mov bp, sp                                ; 89 e5                       ; 0xc3b72
    push dx                                   ; 52                          ; 0xc3b74
    mov ax, strict word 00007h                ; b8 07 00                    ; 0xc3b75 vbe.c:156
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3b78
    call 00570h                               ; e8 f2 c9                    ; 0xc3b7b
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3b7e vbe.c:157
    call 00577h                               ; e8 f3 c9                    ; 0xc3b81
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3b84 vbe.c:158
    pop dx                                    ; 5a                          ; 0xc3b87
    pop bp                                    ; 5d                          ; 0xc3b88
    retn                                      ; c3                          ; 0xc3b89
  ; disGetNextSymbol 0xc3b8a LB 0x6ba -> off=0x0 cb=0000000000000012 uValue=00000000000c3b8a 'in_word'
in_word:                                     ; 0xc3b8a LB 0x12
    push bp                                   ; 55                          ; 0xc3b8a vbe.c:160
    mov bp, sp                                ; 89 e5                       ; 0xc3b8b
    push bx                                   ; 53                          ; 0xc3b8d
    mov bx, ax                                ; 89 c3                       ; 0xc3b8e
    mov ax, dx                                ; 89 d0                       ; 0xc3b90
    mov dx, bx                                ; 89 da                       ; 0xc3b92 vbe.c:162
    out DX, ax                                ; ef                          ; 0xc3b94
    in ax, DX                                 ; ed                          ; 0xc3b95 vbe.c:163
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3b96 vbe.c:164
    pop bx                                    ; 5b                          ; 0xc3b99
    pop bp                                    ; 5d                          ; 0xc3b9a
    retn                                      ; c3                          ; 0xc3b9b
  ; disGetNextSymbol 0xc3b9c LB 0x6a8 -> off=0x0 cb=0000000000000014 uValue=00000000000c3b9c 'in_byte'
in_byte:                                     ; 0xc3b9c LB 0x14
    push bp                                   ; 55                          ; 0xc3b9c vbe.c:166
    mov bp, sp                                ; 89 e5                       ; 0xc3b9d
    push bx                                   ; 53                          ; 0xc3b9f
    mov bx, ax                                ; 89 c3                       ; 0xc3ba0
    mov ax, dx                                ; 89 d0                       ; 0xc3ba2
    mov dx, bx                                ; 89 da                       ; 0xc3ba4 vbe.c:168
    out DX, ax                                ; ef                          ; 0xc3ba6
    in AL, DX                                 ; ec                          ; 0xc3ba7 vbe.c:169
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3ba8
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3baa vbe.c:170
    pop bx                                    ; 5b                          ; 0xc3bad
    pop bp                                    ; 5d                          ; 0xc3bae
    retn                                      ; c3                          ; 0xc3baf
  ; disGetNextSymbol 0xc3bb0 LB 0x694 -> off=0x0 cb=0000000000000014 uValue=00000000000c3bb0 'dispi_get_id'
dispi_get_id:                                ; 0xc3bb0 LB 0x14
    push bp                                   ; 55                          ; 0xc3bb0 vbe.c:173
    mov bp, sp                                ; 89 e5                       ; 0xc3bb1
    push dx                                   ; 52                          ; 0xc3bb3
    xor ax, ax                                ; 31 c0                       ; 0xc3bb4 vbe.c:175
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3bb6
    out DX, ax                                ; ef                          ; 0xc3bb9
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3bba vbe.c:176
    in ax, DX                                 ; ed                          ; 0xc3bbd
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3bbe vbe.c:177
    pop dx                                    ; 5a                          ; 0xc3bc1
    pop bp                                    ; 5d                          ; 0xc3bc2
    retn                                      ; c3                          ; 0xc3bc3
  ; disGetNextSymbol 0xc3bc4 LB 0x680 -> off=0x0 cb=000000000000001a uValue=00000000000c3bc4 'dispi_set_id'
dispi_set_id:                                ; 0xc3bc4 LB 0x1a
    push bp                                   ; 55                          ; 0xc3bc4 vbe.c:179
    mov bp, sp                                ; 89 e5                       ; 0xc3bc5
    push bx                                   ; 53                          ; 0xc3bc7
    push dx                                   ; 52                          ; 0xc3bc8
    mov bx, ax                                ; 89 c3                       ; 0xc3bc9
    xor ax, ax                                ; 31 c0                       ; 0xc3bcb vbe.c:181
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3bcd
    out DX, ax                                ; ef                          ; 0xc3bd0
    mov ax, bx                                ; 89 d8                       ; 0xc3bd1 vbe.c:182
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3bd3
    out DX, ax                                ; ef                          ; 0xc3bd6
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3bd7 vbe.c:183
    pop dx                                    ; 5a                          ; 0xc3bda
    pop bx                                    ; 5b                          ; 0xc3bdb
    pop bp                                    ; 5d                          ; 0xc3bdc
    retn                                      ; c3                          ; 0xc3bdd
  ; disGetNextSymbol 0xc3bde LB 0x666 -> off=0x0 cb=000000000000002a uValue=00000000000c3bde 'vbe_init'
vbe_init:                                    ; 0xc3bde LB 0x2a
    push bp                                   ; 55                          ; 0xc3bde vbe.c:188
    mov bp, sp                                ; 89 e5                       ; 0xc3bdf
    push bx                                   ; 53                          ; 0xc3be1
    mov ax, 0b0c0h                            ; b8 c0 b0                    ; 0xc3be2 vbe.c:190
    call 03bc4h                               ; e8 dc ff                    ; 0xc3be5
    call 03bb0h                               ; e8 c5 ff                    ; 0xc3be8 vbe.c:191
    cmp ax, 0b0c0h                            ; 3d c0 b0                    ; 0xc3beb
    jne short 03c02h                          ; 75 12                       ; 0xc3bee
    mov bx, 000b9h                            ; bb b9 00                    ; 0xc3bf0 vbe.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3bf3
    mov es, ax                                ; 8e c0                       ; 0xc3bf6
    mov byte [es:bx], 001h                    ; 26 c6 07 01                 ; 0xc3bf8
    mov ax, 0b0c4h                            ; b8 c4 b0                    ; 0xc3bfc vbe.c:194
    call 03bc4h                               ; e8 c2 ff                    ; 0xc3bff
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3c02 vbe.c:199
    pop bx                                    ; 5b                          ; 0xc3c05
    pop bp                                    ; 5d                          ; 0xc3c06
    retn                                      ; c3                          ; 0xc3c07
  ; disGetNextSymbol 0xc3c08 LB 0x63c -> off=0x0 cb=000000000000006c uValue=00000000000c3c08 'mode_info_find_mode'
mode_info_find_mode:                         ; 0xc3c08 LB 0x6c
    push bp                                   ; 55                          ; 0xc3c08 vbe.c:202
    mov bp, sp                                ; 89 e5                       ; 0xc3c09
    push bx                                   ; 53                          ; 0xc3c0b
    push cx                                   ; 51                          ; 0xc3c0c
    push si                                   ; 56                          ; 0xc3c0d
    push di                                   ; 57                          ; 0xc3c0e
    mov di, ax                                ; 89 c7                       ; 0xc3c0f
    mov si, dx                                ; 89 d6                       ; 0xc3c11
    xor dx, dx                                ; 31 d2                       ; 0xc3c13 vbe.c:208
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3c15
    call 03b8ah                               ; e8 6f ff                    ; 0xc3c18
    cmp ax, 077cch                            ; 3d cc 77                    ; 0xc3c1b vbe.c:209
    jne short 03c69h                          ; 75 49                       ; 0xc3c1e
    test si, si                               ; 85 f6                       ; 0xc3c20 vbe.c:213
    je short 03c37h                           ; 74 13                       ; 0xc3c22
    mov ax, strict word 0000bh                ; b8 0b 00                    ; 0xc3c24 vbe.c:220
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3c27
    call 00570h                               ; e8 43 c9                    ; 0xc3c2a
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3c2d vbe.c:221
    call 00577h                               ; e8 44 c9                    ; 0xc3c30
    test ax, ax                               ; 85 c0                       ; 0xc3c33 vbe.c:222
    je short 03c6bh                           ; 74 34                       ; 0xc3c35
    mov bx, strict word 00004h                ; bb 04 00                    ; 0xc3c37 vbe.c:226
    mov dx, bx                                ; 89 da                       ; 0xc3c3a vbe.c:232
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3c3c
    call 03b8ah                               ; e8 48 ff                    ; 0xc3c3f
    mov cx, ax                                ; 89 c1                       ; 0xc3c42
    cmp cx, strict byte 0ffffh                ; 83 f9 ff                    ; 0xc3c44 vbe.c:233
    je short 03c69h                           ; 74 20                       ; 0xc3c47
    lea dx, [bx+002h]                         ; 8d 57 02                    ; 0xc3c49 vbe.c:235
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3c4c
    call 03b8ah                               ; e8 38 ff                    ; 0xc3c4f
    lea dx, [bx+044h]                         ; 8d 57 44                    ; 0xc3c52
    cmp cx, di                                ; 39 f9                       ; 0xc3c55 vbe.c:237
    jne short 03c65h                          ; 75 0c                       ; 0xc3c57
    test si, si                               ; 85 f6                       ; 0xc3c59 vbe.c:239
    jne short 03c61h                          ; 75 04                       ; 0xc3c5b
    mov ax, bx                                ; 89 d8                       ; 0xc3c5d vbe.c:240
    jmp short 03c6bh                          ; eb 0a                       ; 0xc3c5f
    test AL, strict byte 080h                 ; a8 80                       ; 0xc3c61 vbe.c:241
    jne short 03c5dh                          ; 75 f8                       ; 0xc3c63
    mov bx, dx                                ; 89 d3                       ; 0xc3c65 vbe.c:244
    jmp short 03c3ch                          ; eb d3                       ; 0xc3c67 vbe.c:249
    xor ax, ax                                ; 31 c0                       ; 0xc3c69 vbe.c:252
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc3c6b vbe.c:253
    pop di                                    ; 5f                          ; 0xc3c6e
    pop si                                    ; 5e                          ; 0xc3c6f
    pop cx                                    ; 59                          ; 0xc3c70
    pop bx                                    ; 5b                          ; 0xc3c71
    pop bp                                    ; 5d                          ; 0xc3c72
    retn                                      ; c3                          ; 0xc3c73
  ; disGetNextSymbol 0xc3c74 LB 0x5d0 -> off=0x0 cb=0000000000000125 uValue=00000000000c3c74 'vbe_biosfn_return_controller_information'
vbe_biosfn_return_controller_information: ; 0xc3c74 LB 0x125
    push bp                                   ; 55                          ; 0xc3c74 vbe.c:284
    mov bp, sp                                ; 89 e5                       ; 0xc3c75
    push cx                                   ; 51                          ; 0xc3c77
    push si                                   ; 56                          ; 0xc3c78
    push di                                   ; 57                          ; 0xc3c79
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc3c7a
    mov si, ax                                ; 89 c6                       ; 0xc3c7d
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc3c7f
    mov di, bx                                ; 89 df                       ; 0xc3c82
    mov word [bp-00ch], strict word 00022h    ; c7 46 f4 22 00              ; 0xc3c84 vbe.c:289
    call 005b7h                               ; e8 2b c9                    ; 0xc3c89 vbe.c:292
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc3c8c
    mov bx, di                                ; 89 fb                       ; 0xc3c8f vbe.c:295
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3c91
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3c94
    xor dx, dx                                ; 31 d2                       ; 0xc3c97 vbe.c:298
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3c99
    call 03b8ah                               ; e8 eb fe                    ; 0xc3c9c
    cmp ax, 077cch                            ; 3d cc 77                    ; 0xc3c9f vbe.c:299
    je short 03caeh                           ; 74 0a                       ; 0xc3ca2
    push SS                                   ; 16                          ; 0xc3ca4 vbe.c:301
    pop ES                                    ; 07                          ; 0xc3ca5
    mov word [es:si], 00100h                  ; 26 c7 04 00 01              ; 0xc3ca6
    jmp near 03d91h                           ; e9 e3 00                    ; 0xc3cab vbe.c:305
    mov cx, strict word 00004h                ; b9 04 00                    ; 0xc3cae vbe.c:307
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc3cb1 vbe.c:314
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3cb6 vbe.c:322
    cmp word [es:bx+002h], 03245h             ; 26 81 7f 02 45 32           ; 0xc3cb9
    jne short 03cc8h                          ; 75 07                       ; 0xc3cbf
    cmp word [es:bx], 04256h                  ; 26 81 3f 56 42              ; 0xc3cc1
    je short 03cd7h                           ; 74 0f                       ; 0xc3cc6
    cmp word [es:bx+002h], 04153h             ; 26 81 7f 02 53 41           ; 0xc3cc8
    jne short 03cdch                          ; 75 0c                       ; 0xc3cce
    cmp word [es:bx], 04556h                  ; 26 81 3f 56 45              ; 0xc3cd0
    jne short 03cdch                          ; 75 05                       ; 0xc3cd5
    mov word [bp-00eh], strict word 00001h    ; c7 46 f2 01 00              ; 0xc3cd7 vbe.c:324
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3cdc vbe.c:332
    db  066h, 026h, 0c7h, 007h, 056h, 045h, 053h, 041h
    ; mov dword [es:bx], strict dword 041534556h ; 66 26 c7 07 56 45 53 41  ; 0xc3cdf
    mov word [es:bx+004h], 00200h             ; 26 c7 47 04 00 02           ; 0xc3ce7 vbe.c:338
    mov word [es:bx+006h], 07e00h             ; 26 c7 47 06 00 7e           ; 0xc3ced vbe.c:341
    mov [es:bx+008h], ds                      ; 26 8c 5f 08                 ; 0xc3cf3
    db  066h, 026h, 0c7h, 047h, 00ah, 001h, 000h, 000h, 000h
    ; mov dword [es:bx+00ah], strict dword 000000001h ; 66 26 c7 47 0a 01 00 00 00; 0xc3cf7 vbe.c:344
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3d00 vbe.c:350
    mov word [es:bx+010h], ax                 ; 26 89 47 10                 ; 0xc3d03
    lea ax, [di+022h]                         ; 8d 45 22                    ; 0xc3d07 vbe.c:351
    mov word [es:bx+00eh], ax                 ; 26 89 47 0e                 ; 0xc3d0a
    mov dx, strict word 0ffffh                ; ba ff ff                    ; 0xc3d0e vbe.c:354
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3d11
    call 03b8ah                               ; e8 73 fe                    ; 0xc3d14
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3d17
    mov word [es:bx+012h], ax                 ; 26 89 47 12                 ; 0xc3d1a
    cmp word [bp-00eh], strict byte 00000h    ; 83 7e f2 00                 ; 0xc3d1e vbe.c:356
    je short 03d48h                           ; 74 24                       ; 0xc3d22
    mov word [es:bx+014h], strict word 00003h ; 26 c7 47 14 03 00           ; 0xc3d24 vbe.c:359
    mov word [es:bx+016h], 07e15h             ; 26 c7 47 16 15 7e           ; 0xc3d2a vbe.c:360
    mov [es:bx+018h], ds                      ; 26 8c 5f 18                 ; 0xc3d30
    mov word [es:bx+01ah], 07e32h             ; 26 c7 47 1a 32 7e           ; 0xc3d34 vbe.c:361
    mov [es:bx+01ch], ds                      ; 26 8c 5f 1c                 ; 0xc3d3a
    mov word [es:bx+01eh], 07e50h             ; 26 c7 47 1e 50 7e           ; 0xc3d3e vbe.c:362
    mov [es:bx+020h], ds                      ; 26 8c 5f 20                 ; 0xc3d44
    mov dx, cx                                ; 89 ca                       ; 0xc3d48 vbe.c:369
    add dx, strict byte 0001bh                ; 83 c2 1b                    ; 0xc3d4a
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3d4d
    call 03b9ch                               ; e8 49 fe                    ; 0xc3d50
    xor ah, ah                                ; 30 e4                       ; 0xc3d53 vbe.c:370
    cmp ax, word [bp-010h]                    ; 3b 46 f0                    ; 0xc3d55
    jnbe short 03d71h                         ; 77 17                       ; 0xc3d58
    mov dx, cx                                ; 89 ca                       ; 0xc3d5a vbe.c:372
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3d5c
    call 03b8ah                               ; e8 28 fe                    ; 0xc3d5f
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc3d62 vbe.c:376
    add bx, di                                ; 01 fb                       ; 0xc3d65
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc3d67 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3d6a
    add word [bp-00ch], strict byte 00002h    ; 83 46 f4 02                 ; 0xc3d6d vbe.c:378
    add cx, strict byte 00044h                ; 83 c1 44                    ; 0xc3d71 vbe.c:380
    mov dx, cx                                ; 89 ca                       ; 0xc3d74 vbe.c:381
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3d76
    call 03b8ah                               ; e8 0e fe                    ; 0xc3d79
    cmp ax, strict word 0ffffh                ; 3d ff ff                    ; 0xc3d7c vbe.c:382
    jne short 03d48h                          ; 75 c7                       ; 0xc3d7f
    add di, word [bp-00ch]                    ; 03 7e f4                    ; 0xc3d81 vbe.c:385
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc3d84 vbe.c:62
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc3d87
    push SS                                   ; 16                          ; 0xc3d8a vbe.c:386
    pop ES                                    ; 07                          ; 0xc3d8b
    mov word [es:si], strict word 0004fh      ; 26 c7 04 4f 00              ; 0xc3d8c
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3d91 vbe.c:387
    pop di                                    ; 5f                          ; 0xc3d94
    pop si                                    ; 5e                          ; 0xc3d95
    pop cx                                    ; 59                          ; 0xc3d96
    pop bp                                    ; 5d                          ; 0xc3d97
    retn                                      ; c3                          ; 0xc3d98
  ; disGetNextSymbol 0xc3d99 LB 0x4ab -> off=0x0 cb=000000000000009b uValue=00000000000c3d99 'vbe_biosfn_return_mode_information'
vbe_biosfn_return_mode_information:          ; 0xc3d99 LB 0x9b
    push bp                                   ; 55                          ; 0xc3d99 vbe.c:399
    mov bp, sp                                ; 89 e5                       ; 0xc3d9a
    push si                                   ; 56                          ; 0xc3d9c
    push di                                   ; 57                          ; 0xc3d9d
    push ax                                   ; 50                          ; 0xc3d9e
    push ax                                   ; 50                          ; 0xc3d9f
    mov ax, dx                                ; 89 d0                       ; 0xc3da0
    mov si, bx                                ; 89 de                       ; 0xc3da2
    mov bx, cx                                ; 89 cb                       ; 0xc3da4
    test dh, 040h                             ; f6 c6 40                    ; 0xc3da6 vbe.c:410
    db  00fh, 095h, 0c2h
    ; setne dl                                  ; 0f 95 c2                  ; 0xc3da9
    xor dh, dh                                ; 30 f6                       ; 0xc3dac
    and ah, 001h                              ; 80 e4 01                    ; 0xc3dae vbe.c:411
    call 03c08h                               ; e8 54 fe                    ; 0xc3db1 vbe.c:413
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc3db4
    test ax, ax                               ; 85 c0                       ; 0xc3db7 vbe.c:415
    je short 03e22h                           ; 74 67                       ; 0xc3db9
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3dbb vbe.c:420
    xor ax, ax                                ; 31 c0                       ; 0xc3dbe
    mov di, bx                                ; 89 df                       ; 0xc3dc0
    mov es, si                                ; 8e c6                       ; 0xc3dc2
    jcxz 03dc8h                               ; e3 02                       ; 0xc3dc4
    rep stosb                                 ; f3 aa                       ; 0xc3dc6
    xor cx, cx                                ; 31 c9                       ; 0xc3dc8 vbe.c:421
    jmp short 03dd1h                          ; eb 05                       ; 0xc3dca
    cmp cx, strict byte 00042h                ; 83 f9 42                    ; 0xc3dcc
    jnc short 03deah                          ; 73 19                       ; 0xc3dcf
    mov dx, word [bp-006h]                    ; 8b 56 fa                    ; 0xc3dd1 vbe.c:424
    inc dx                                    ; 42                          ; 0xc3dd4
    inc dx                                    ; 42                          ; 0xc3dd5
    add dx, cx                                ; 01 ca                       ; 0xc3dd6
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3dd8
    call 03b9ch                               ; e8 be fd                    ; 0xc3ddb
    mov di, bx                                ; 89 df                       ; 0xc3dde vbe.c:425
    add di, cx                                ; 01 cf                       ; 0xc3de0
    mov es, si                                ; 8e c6                       ; 0xc3de2 vbe.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc3de4
    inc cx                                    ; 41                          ; 0xc3de7 vbe.c:426
    jmp short 03dcch                          ; eb e2                       ; 0xc3de8
    lea di, [bx+002h]                         ; 8d 7f 02                    ; 0xc3dea vbe.c:427
    mov es, si                                ; 8e c6                       ; 0xc3ded vbe.c:47
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc3def
    test AL, strict byte 001h                 ; a8 01                       ; 0xc3df2 vbe.c:428
    je short 03e06h                           ; 74 10                       ; 0xc3df4
    lea di, [bx+00ch]                         ; 8d 7f 0c                    ; 0xc3df6 vbe.c:429
    mov word [es:di], 00629h                  ; 26 c7 05 29 06              ; 0xc3df9 vbe.c:62
    lea di, [bx+00eh]                         ; 8d 7f 0e                    ; 0xc3dfe vbe.c:431
    mov word [es:di], 0c000h                  ; 26 c7 05 00 c0              ; 0xc3e01 vbe.c:62
    mov ax, strict word 0000bh                ; b8 0b 00                    ; 0xc3e06 vbe.c:434
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3e09
    call 00570h                               ; e8 61 c7                    ; 0xc3e0c
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3e0f vbe.c:435
    call 00577h                               ; e8 62 c7                    ; 0xc3e12
    add bx, strict byte 0002ah                ; 83 c3 2a                    ; 0xc3e15
    mov es, si                                ; 8e c6                       ; 0xc3e18 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3e1a
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc3e1d vbe.c:437
    jmp short 03e25h                          ; eb 03                       ; 0xc3e20 vbe.c:438
    mov ax, 00100h                            ; b8 00 01                    ; 0xc3e22 vbe.c:442
    push SS                                   ; 16                          ; 0xc3e25 vbe.c:445
    pop ES                                    ; 07                          ; 0xc3e26
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc3e27
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3e2a
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3e2d vbe.c:446
    pop di                                    ; 5f                          ; 0xc3e30
    pop si                                    ; 5e                          ; 0xc3e31
    pop bp                                    ; 5d                          ; 0xc3e32
    retn                                      ; c3                          ; 0xc3e33
  ; disGetNextSymbol 0xc3e34 LB 0x410 -> off=0x0 cb=00000000000000ee uValue=00000000000c3e34 'vbe_biosfn_set_mode'
vbe_biosfn_set_mode:                         ; 0xc3e34 LB 0xee
    push bp                                   ; 55                          ; 0xc3e34 vbe.c:458
    mov bp, sp                                ; 89 e5                       ; 0xc3e35
    push si                                   ; 56                          ; 0xc3e37
    push di                                   ; 57                          ; 0xc3e38
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc3e39
    mov si, ax                                ; 89 c6                       ; 0xc3e3c
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc3e3e
    test byte [bp-009h], 040h                 ; f6 46 f7 40                 ; 0xc3e41 vbe.c:466
    db  00fh, 095h, 0c0h
    ; setne al                                  ; 0f 95 c0                  ; 0xc3e45
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3e48
    mov ax, dx                                ; 89 d0                       ; 0xc3e4b
    test dx, dx                               ; 85 d2                       ; 0xc3e4d vbe.c:467
    je short 03e54h                           ; 74 03                       ; 0xc3e4f
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc3e51
    mov byte [bp-008h], dl                    ; 88 56 f8                    ; 0xc3e54
    test byte [bp-009h], 080h                 ; f6 46 f7 80                 ; 0xc3e57 vbe.c:468
    je short 03e62h                           ; 74 05                       ; 0xc3e5b
    mov dx, 00080h                            ; ba 80 00                    ; 0xc3e5d
    jmp short 03e64h                          ; eb 02                       ; 0xc3e60
    xor dx, dx                                ; 31 d2                       ; 0xc3e62
    mov byte [bp-006h], dl                    ; 88 56 fa                    ; 0xc3e64
    and byte [bp-009h], 001h                  ; 80 66 f7 01                 ; 0xc3e67 vbe.c:470
    cmp word [bp-00ah], 00100h                ; 81 7e f6 00 01              ; 0xc3e6b vbe.c:473
    jnc short 03e84h                          ; 73 12                       ; 0xc3e70
    xor ax, ax                                ; 31 c0                       ; 0xc3e72 vbe.c:477
    call 005ddh                               ; e8 66 c7                    ; 0xc3e74
    movzx ax, byte [bp-00ah]                  ; 0f b6 46 f6                 ; 0xc3e77 vbe.c:481
    call 01375h                               ; e8 f7 d4                    ; 0xc3e7b
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc3e7e vbe.c:482
    jmp near 03f16h                           ; e9 92 00                    ; 0xc3e81 vbe.c:483
    mov dx, ax                                ; 89 c2                       ; 0xc3e84 vbe.c:486
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3e86
    call 03c08h                               ; e8 7c fd                    ; 0xc3e89
    mov bx, ax                                ; 89 c3                       ; 0xc3e8c
    test ax, ax                               ; 85 c0                       ; 0xc3e8e vbe.c:488
    je near 03f13h                            ; 0f 84 7f 00                 ; 0xc3e90
    lea dx, [bx+014h]                         ; 8d 57 14                    ; 0xc3e94 vbe.c:493
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3e97
    call 03b8ah                               ; e8 ed fc                    ; 0xc3e9a
    mov cx, ax                                ; 89 c1                       ; 0xc3e9d
    lea dx, [bx+016h]                         ; 8d 57 16                    ; 0xc3e9f vbe.c:494
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3ea2
    call 03b8ah                               ; e8 e2 fc                    ; 0xc3ea5
    mov di, ax                                ; 89 c7                       ; 0xc3ea8
    lea dx, [bx+01bh]                         ; 8d 57 1b                    ; 0xc3eaa vbe.c:495
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3ead
    call 03b9ch                               ; e8 e9 fc                    ; 0xc3eb0
    mov bl, al                                ; 88 c3                       ; 0xc3eb3
    mov bh, al                                ; 88 c7                       ; 0xc3eb5
    xor ax, ax                                ; 31 c0                       ; 0xc3eb7 vbe.c:503
    call 005ddh                               ; e8 21 c7                    ; 0xc3eb9
    mov ax, strict word 00007h                ; b8 07 00                    ; 0xc3ebc vbe.c:505
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3ebf
    out DX, ax                                ; ef                          ; 0xc3ec2
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc3ec3 vbe.c:507
    jne short 03eceh                          ; 75 06                       ; 0xc3ec6
    mov ax, strict word 0006ah                ; b8 6a 00                    ; 0xc3ec8 vbe.c:509
    call 01375h                               ; e8 a7 d4                    ; 0xc3ecb
    movzx ax, bh                              ; 0f b6 c7                    ; 0xc3ece vbe.c:512
    call 03b01h                               ; e8 2d fc                    ; 0xc3ed1
    mov ax, cx                                ; 89 c8                       ; 0xc3ed4 vbe.c:513
    call 03aaah                               ; e8 d1 fb                    ; 0xc3ed6
    mov ax, di                                ; 89 f8                       ; 0xc3ed9 vbe.c:514
    call 03ac9h                               ; e8 eb fb                    ; 0xc3edb
    xor ax, ax                                ; 31 c0                       ; 0xc3ede vbe.c:515
    call 00603h                               ; e8 20 c7                    ; 0xc3ee0
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc3ee3 vbe.c:516
    or AL, strict byte 001h                   ; 0c 01                       ; 0xc3ee6
    movzx dx, al                              ; 0f b6 d0                    ; 0xc3ee8
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc3eeb
    or ax, dx                                 ; 09 d0                       ; 0xc3eef
    call 005ddh                               ; e8 e9 c6                    ; 0xc3ef1
    call 006d2h                               ; e8 db c7                    ; 0xc3ef4 vbe.c:517
    mov bx, 000bah                            ; bb ba 00                    ; 0xc3ef7 vbe.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3efa
    mov es, ax                                ; 8e c0                       ; 0xc3efd
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3eff
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3f02
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc3f05 vbe.c:520
    or AL, strict byte 060h                   ; 0c 60                       ; 0xc3f08
    mov bx, 00087h                            ; bb 87 00                    ; 0xc3f0a vbe.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3f0d
    jmp near 03e7eh                           ; e9 6b ff                    ; 0xc3f10
    mov ax, 00100h                            ; b8 00 01                    ; 0xc3f13 vbe.c:529
    push SS                                   ; 16                          ; 0xc3f16 vbe.c:533
    pop ES                                    ; 07                          ; 0xc3f17
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3f18
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3f1b vbe.c:534
    pop di                                    ; 5f                          ; 0xc3f1e
    pop si                                    ; 5e                          ; 0xc3f1f
    pop bp                                    ; 5d                          ; 0xc3f20
    retn                                      ; c3                          ; 0xc3f21
  ; disGetNextSymbol 0xc3f22 LB 0x322 -> off=0x0 cb=0000000000000008 uValue=00000000000c3f22 'vbe_biosfn_read_video_state_size'
vbe_biosfn_read_video_state_size:            ; 0xc3f22 LB 0x8
    push bp                                   ; 55                          ; 0xc3f22 vbe.c:536
    mov bp, sp                                ; 89 e5                       ; 0xc3f23
    mov ax, strict word 00012h                ; b8 12 00                    ; 0xc3f25 vbe.c:539
    pop bp                                    ; 5d                          ; 0xc3f28
    retn                                      ; c3                          ; 0xc3f29
  ; disGetNextSymbol 0xc3f2a LB 0x31a -> off=0x0 cb=000000000000004b uValue=00000000000c3f2a 'vbe_biosfn_save_video_state'
vbe_biosfn_save_video_state:                 ; 0xc3f2a LB 0x4b
    push bp                                   ; 55                          ; 0xc3f2a vbe.c:541
    mov bp, sp                                ; 89 e5                       ; 0xc3f2b
    push bx                                   ; 53                          ; 0xc3f2d
    push cx                                   ; 51                          ; 0xc3f2e
    push si                                   ; 56                          ; 0xc3f2f
    mov si, ax                                ; 89 c6                       ; 0xc3f30
    mov bx, dx                                ; 89 d3                       ; 0xc3f32
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc3f34 vbe.c:545
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3f37
    out DX, ax                                ; ef                          ; 0xc3f3a
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3f3b vbe.c:546
    in ax, DX                                 ; ed                          ; 0xc3f3e
    mov es, si                                ; 8e c6                       ; 0xc3f3f vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3f41
    inc bx                                    ; 43                          ; 0xc3f44 vbe.c:548
    inc bx                                    ; 43                          ; 0xc3f45
    test AL, strict byte 001h                 ; a8 01                       ; 0xc3f46 vbe.c:549
    je short 03f6dh                           ; 74 23                       ; 0xc3f48
    mov cx, strict word 00001h                ; b9 01 00                    ; 0xc3f4a vbe.c:551
    jmp short 03f54h                          ; eb 05                       ; 0xc3f4d
    cmp cx, strict byte 00009h                ; 83 f9 09                    ; 0xc3f4f
    jnbe short 03f6dh                         ; 77 19                       ; 0xc3f52
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc3f54 vbe.c:552
    je short 03f6ah                           ; 74 11                       ; 0xc3f57
    mov ax, cx                                ; 89 c8                       ; 0xc3f59 vbe.c:553
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3f5b
    out DX, ax                                ; ef                          ; 0xc3f5e
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3f5f vbe.c:554
    in ax, DX                                 ; ed                          ; 0xc3f62
    mov es, si                                ; 8e c6                       ; 0xc3f63 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3f65
    inc bx                                    ; 43                          ; 0xc3f68 vbe.c:555
    inc bx                                    ; 43                          ; 0xc3f69
    inc cx                                    ; 41                          ; 0xc3f6a vbe.c:557
    jmp short 03f4fh                          ; eb e2                       ; 0xc3f6b
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3f6d vbe.c:558
    pop si                                    ; 5e                          ; 0xc3f70
    pop cx                                    ; 59                          ; 0xc3f71
    pop bx                                    ; 5b                          ; 0xc3f72
    pop bp                                    ; 5d                          ; 0xc3f73
    retn                                      ; c3                          ; 0xc3f74
  ; disGetNextSymbol 0xc3f75 LB 0x2cf -> off=0x0 cb=000000000000008f uValue=00000000000c3f75 'vbe_biosfn_restore_video_state'
vbe_biosfn_restore_video_state:              ; 0xc3f75 LB 0x8f
    push bp                                   ; 55                          ; 0xc3f75 vbe.c:561
    mov bp, sp                                ; 89 e5                       ; 0xc3f76
    push bx                                   ; 53                          ; 0xc3f78
    push cx                                   ; 51                          ; 0xc3f79
    push si                                   ; 56                          ; 0xc3f7a
    push ax                                   ; 50                          ; 0xc3f7b
    mov cx, ax                                ; 89 c1                       ; 0xc3f7c
    mov bx, dx                                ; 89 d3                       ; 0xc3f7e
    mov es, ax                                ; 8e c0                       ; 0xc3f80 vbe.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3f82
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3f85
    inc bx                                    ; 43                          ; 0xc3f88 vbe.c:566
    inc bx                                    ; 43                          ; 0xc3f89
    test byte [bp-008h], 001h                 ; f6 46 f8 01                 ; 0xc3f8a vbe.c:568
    jne short 03fa0h                          ; 75 10                       ; 0xc3f8e
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc3f90 vbe.c:569
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3f93
    out DX, ax                                ; ef                          ; 0xc3f96
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc3f97 vbe.c:570
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3f9a
    out DX, ax                                ; ef                          ; 0xc3f9d
    jmp short 03ffch                          ; eb 5c                       ; 0xc3f9e vbe.c:571
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc3fa0 vbe.c:572
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3fa3
    out DX, ax                                ; ef                          ; 0xc3fa6
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3fa7 vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3faa vbe.c:58
    out DX, ax                                ; ef                          ; 0xc3fad
    inc bx                                    ; 43                          ; 0xc3fae vbe.c:574
    inc bx                                    ; 43                          ; 0xc3faf
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3fb0
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3fb3
    out DX, ax                                ; ef                          ; 0xc3fb6
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3fb7 vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3fba vbe.c:58
    out DX, ax                                ; ef                          ; 0xc3fbd
    inc bx                                    ; 43                          ; 0xc3fbe vbe.c:577
    inc bx                                    ; 43                          ; 0xc3fbf
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3fc0
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3fc3
    out DX, ax                                ; ef                          ; 0xc3fc6
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3fc7 vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3fca vbe.c:58
    out DX, ax                                ; ef                          ; 0xc3fcd
    inc bx                                    ; 43                          ; 0xc3fce vbe.c:580
    inc bx                                    ; 43                          ; 0xc3fcf
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc3fd0
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3fd3
    out DX, ax                                ; ef                          ; 0xc3fd6
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc3fd7 vbe.c:582
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3fda
    out DX, ax                                ; ef                          ; 0xc3fdd
    mov si, strict word 00005h                ; be 05 00                    ; 0xc3fde vbe.c:584
    jmp short 03fe8h                          ; eb 05                       ; 0xc3fe1
    cmp si, strict byte 00009h                ; 83 fe 09                    ; 0xc3fe3
    jnbe short 03ffch                         ; 77 14                       ; 0xc3fe6
    mov ax, si                                ; 89 f0                       ; 0xc3fe8 vbe.c:585
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3fea
    out DX, ax                                ; ef                          ; 0xc3fed
    mov es, cx                                ; 8e c1                       ; 0xc3fee vbe.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3ff0
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3ff3 vbe.c:58
    out DX, ax                                ; ef                          ; 0xc3ff6
    inc bx                                    ; 43                          ; 0xc3ff7 vbe.c:587
    inc bx                                    ; 43                          ; 0xc3ff8
    inc si                                    ; 46                          ; 0xc3ff9 vbe.c:588
    jmp short 03fe3h                          ; eb e7                       ; 0xc3ffa
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3ffc vbe.c:590
    pop si                                    ; 5e                          ; 0xc3fff
    pop cx                                    ; 59                          ; 0xc4000
    pop bx                                    ; 5b                          ; 0xc4001
    pop bp                                    ; 5d                          ; 0xc4002
    retn                                      ; c3                          ; 0xc4003
  ; disGetNextSymbol 0xc4004 LB 0x240 -> off=0x0 cb=000000000000008c uValue=00000000000c4004 'vbe_biosfn_save_restore_state'
vbe_biosfn_save_restore_state:               ; 0xc4004 LB 0x8c
    push bp                                   ; 55                          ; 0xc4004 vbe.c:606
    mov bp, sp                                ; 89 e5                       ; 0xc4005
    push si                                   ; 56                          ; 0xc4007
    push di                                   ; 57                          ; 0xc4008
    push ax                                   ; 50                          ; 0xc4009
    mov si, ax                                ; 89 c6                       ; 0xc400a
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc400c
    mov ax, bx                                ; 89 d8                       ; 0xc400f
    mov bx, word [bp+004h]                    ; 8b 5e 04                    ; 0xc4011
    mov di, strict word 0004fh                ; bf 4f 00                    ; 0xc4014 vbe.c:611
    xor ah, ah                                ; 30 e4                       ; 0xc4017 vbe.c:612
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc4019
    je short 04063h                           ; 74 45                       ; 0xc401c
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc401e
    je short 04047h                           ; 74 24                       ; 0xc4021
    test ax, ax                               ; 85 c0                       ; 0xc4023
    jne short 0407fh                          ; 75 58                       ; 0xc4025
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc4027 vbe.c:614
    call 02fa6h                               ; e8 79 ef                    ; 0xc402a
    mov cx, ax                                ; 89 c1                       ; 0xc402d
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc402f vbe.c:618
    je short 0403ah                           ; 74 05                       ; 0xc4033
    call 03f22h                               ; e8 ea fe                    ; 0xc4035 vbe.c:619
    add ax, cx                                ; 01 c8                       ; 0xc4038
    add ax, strict word 0003fh                ; 05 3f 00                    ; 0xc403a vbe.c:620
    shr ax, 006h                              ; c1 e8 06                    ; 0xc403d
    push SS                                   ; 16                          ; 0xc4040
    pop ES                                    ; 07                          ; 0xc4041
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc4042
    jmp short 04082h                          ; eb 3b                       ; 0xc4045 vbe.c:621
    push SS                                   ; 16                          ; 0xc4047 vbe.c:623
    pop ES                                    ; 07                          ; 0xc4048
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc4049
    mov dx, cx                                ; 89 ca                       ; 0xc404c vbe.c:624
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc404e
    call 02fe1h                               ; e8 8d ef                    ; 0xc4051
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc4054 vbe.c:628
    je short 04082h                           ; 74 28                       ; 0xc4058
    mov dx, ax                                ; 89 c2                       ; 0xc405a vbe.c:629
    mov ax, cx                                ; 89 c8                       ; 0xc405c
    call 03f2ah                               ; e8 c9 fe                    ; 0xc405e
    jmp short 04082h                          ; eb 1f                       ; 0xc4061 vbe.c:630
    push SS                                   ; 16                          ; 0xc4063 vbe.c:632
    pop ES                                    ; 07                          ; 0xc4064
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc4065
    mov dx, cx                                ; 89 ca                       ; 0xc4068 vbe.c:633
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc406a
    call 032b7h                               ; e8 47 f2                    ; 0xc406d
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc4070 vbe.c:637
    je short 04082h                           ; 74 0c                       ; 0xc4074
    mov dx, ax                                ; 89 c2                       ; 0xc4076 vbe.c:638
    mov ax, cx                                ; 89 c8                       ; 0xc4078
    call 03f75h                               ; e8 f8 fe                    ; 0xc407a
    jmp short 04082h                          ; eb 03                       ; 0xc407d vbe.c:639
    mov di, 00100h                            ; bf 00 01                    ; 0xc407f vbe.c:642
    push SS                                   ; 16                          ; 0xc4082 vbe.c:645
    pop ES                                    ; 07                          ; 0xc4083
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc4084
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc4087 vbe.c:646
    pop di                                    ; 5f                          ; 0xc408a
    pop si                                    ; 5e                          ; 0xc408b
    pop bp                                    ; 5d                          ; 0xc408c
    retn 00002h                               ; c2 02 00                    ; 0xc408d
  ; disGetNextSymbol 0xc4090 LB 0x1b4 -> off=0x0 cb=00000000000000cf uValue=00000000000c4090 'vbe_biosfn_get_set_scanline_length'
vbe_biosfn_get_set_scanline_length:          ; 0xc4090 LB 0xcf
    push bp                                   ; 55                          ; 0xc4090 vbe.c:667
    mov bp, sp                                ; 89 e5                       ; 0xc4091
    push si                                   ; 56                          ; 0xc4093
    push di                                   ; 57                          ; 0xc4094
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc4095
    push ax                                   ; 50                          ; 0xc4098
    mov di, dx                                ; 89 d7                       ; 0xc4099
    mov si, bx                                ; 89 de                       ; 0xc409b
    mov word [bp-008h], cx                    ; 89 4e f8                    ; 0xc409d
    call 03b20h                               ; e8 7d fa                    ; 0xc40a0 vbe.c:676
    cmp AL, strict byte 00fh                  ; 3c 0f                       ; 0xc40a3 vbe.c:677
    jne short 040ach                          ; 75 05                       ; 0xc40a5
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc40a7
    jmp short 040afh                          ; eb 03                       ; 0xc40aa
    movzx cx, al                              ; 0f b6 c8                    ; 0xc40ac
    call 03b58h                               ; e8 a6 fa                    ; 0xc40af vbe.c:678
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc40b2
    mov word [bp-006h], strict word 0004fh    ; c7 46 fa 4f 00              ; 0xc40b5 vbe.c:679
    push SS                                   ; 16                          ; 0xc40ba vbe.c:680
    pop ES                                    ; 07                          ; 0xc40bb
    mov bx, word [es:si]                      ; 26 8b 1c                    ; 0xc40bc
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc40bf vbe.c:681
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc40c2 vbe.c:685
    je short 040d1h                           ; 74 0b                       ; 0xc40c4
    cmp AL, strict byte 001h                  ; 3c 01                       ; 0xc40c6
    je short 040f8h                           ; 74 2e                       ; 0xc40c8
    test al, al                               ; 84 c0                       ; 0xc40ca
    je short 040f3h                           ; 74 25                       ; 0xc40cc
    jmp near 04148h                           ; e9 77 00                    ; 0xc40ce
    cmp cl, 004h                              ; 80 f9 04                    ; 0xc40d1 vbe.c:687
    jne short 040dbh                          ; 75 05                       ; 0xc40d4
    sal bx, 003h                              ; c1 e3 03                    ; 0xc40d6 vbe.c:688
    jmp short 040f3h                          ; eb 18                       ; 0xc40d9 vbe.c:689
    movzx ax, cl                              ; 0f b6 c1                    ; 0xc40db vbe.c:690
    cwd                                       ; 99                          ; 0xc40de
    sal dx, 003h                              ; c1 e2 03                    ; 0xc40df
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc40e2
    sar ax, 003h                              ; c1 f8 03                    ; 0xc40e4
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc40e7
    mov ax, bx                                ; 89 d8                       ; 0xc40ea
    xor dx, dx                                ; 31 d2                       ; 0xc40ec
    div word [bp-00ch]                        ; f7 76 f4                    ; 0xc40ee
    mov bx, ax                                ; 89 c3                       ; 0xc40f1
    mov ax, bx                                ; 89 d8                       ; 0xc40f3 vbe.c:693
    call 03b39h                               ; e8 41 fa                    ; 0xc40f5
    call 03b58h                               ; e8 5d fa                    ; 0xc40f8 vbe.c:696
    mov bx, ax                                ; 89 c3                       ; 0xc40fb
    push SS                                   ; 16                          ; 0xc40fd vbe.c:697
    pop ES                                    ; 07                          ; 0xc40fe
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc40ff
    cmp cl, 004h                              ; 80 f9 04                    ; 0xc4102 vbe.c:698
    jne short 0410ch                          ; 75 05                       ; 0xc4105
    shr bx, 003h                              ; c1 eb 03                    ; 0xc4107 vbe.c:699
    jmp short 0411bh                          ; eb 0f                       ; 0xc410a vbe.c:700
    movzx ax, cl                              ; 0f b6 c1                    ; 0xc410c vbe.c:701
    cwd                                       ; 99                          ; 0xc410f
    sal dx, 003h                              ; c1 e2 03                    ; 0xc4110
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc4113
    sar ax, 003h                              ; c1 f8 03                    ; 0xc4115
    imul bx, ax                               ; 0f af d8                    ; 0xc4118
    add bx, strict byte 00003h                ; 83 c3 03                    ; 0xc411b vbe.c:702
    and bl, 0fch                              ; 80 e3 fc                    ; 0xc411e
    push SS                                   ; 16                          ; 0xc4121 vbe.c:703
    pop ES                                    ; 07                          ; 0xc4122
    mov word [es:di], bx                      ; 26 89 1d                    ; 0xc4123
    call 03b71h                               ; e8 48 fa                    ; 0xc4126 vbe.c:704
    push SS                                   ; 16                          ; 0xc4129
    pop ES                                    ; 07                          ; 0xc412a
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc412b
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc412e
    call 03ae8h                               ; e8 b4 f9                    ; 0xc4131 vbe.c:705
    push SS                                   ; 16                          ; 0xc4134
    pop ES                                    ; 07                          ; 0xc4135
    cmp ax, word [es:bx]                      ; 26 3b 07                    ; 0xc4136
    jbe short 0414dh                          ; 76 12                       ; 0xc4139
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc413b vbe.c:706
    call 03b39h                               ; e8 f8 f9                    ; 0xc413e
    mov word [bp-006h], 00200h                ; c7 46 fa 00 02              ; 0xc4141 vbe.c:707
    jmp short 0414dh                          ; eb 05                       ; 0xc4146 vbe.c:709
    mov word [bp-006h], 00100h                ; c7 46 fa 00 01              ; 0xc4148 vbe.c:712
    push SS                                   ; 16                          ; 0xc414d vbe.c:715
    pop ES                                    ; 07                          ; 0xc414e
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc414f
    mov bx, word [bp-00eh]                    ; 8b 5e f2                    ; 0xc4152
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc4155
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc4158 vbe.c:716
    pop di                                    ; 5f                          ; 0xc415b
    pop si                                    ; 5e                          ; 0xc415c
    pop bp                                    ; 5d                          ; 0xc415d
    retn                                      ; c3                          ; 0xc415e
  ; disGetNextSymbol 0xc415f LB 0xe5 -> off=0x0 cb=00000000000000e5 uValue=00000000000c415f 'private_biosfn_custom_mode'
private_biosfn_custom_mode:                  ; 0xc415f LB 0xe5
    push bp                                   ; 55                          ; 0xc415f vbe.c:742
    mov bp, sp                                ; 89 e5                       ; 0xc4160
    push si                                   ; 56                          ; 0xc4162
    push di                                   ; 57                          ; 0xc4163
    push ax                                   ; 50                          ; 0xc4164
    push ax                                   ; 50                          ; 0xc4165
    push ax                                   ; 50                          ; 0xc4166
    mov si, dx                                ; 89 d6                       ; 0xc4167
    mov dx, cx                                ; 89 ca                       ; 0xc4169
    mov di, strict word 0004fh                ; bf 4f 00                    ; 0xc416b vbe.c:755
    push SS                                   ; 16                          ; 0xc416e vbe.c:756
    pop ES                                    ; 07                          ; 0xc416f
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc4170
    test al, al                               ; 84 c0                       ; 0xc4173 vbe.c:757
    jne short 04199h                          ; 75 22                       ; 0xc4175
    push SS                                   ; 16                          ; 0xc4177 vbe.c:759
    pop ES                                    ; 07                          ; 0xc4178
    mov cx, word [es:bx]                      ; 26 8b 0f                    ; 0xc4179
    mov bx, dx                                ; 89 d3                       ; 0xc417c vbe.c:760
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc417e
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc4181 vbe.c:761
    shr ax, 008h                              ; c1 e8 08                    ; 0xc4184
    and ax, strict word 0007fh                ; 25 7f 00                    ; 0xc4187
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc418a
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc418d vbe.c:766
    je short 0419fh                           ; 74 0e                       ; 0xc418f
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc4191
    je short 0419fh                           ; 74 0a                       ; 0xc4193
    cmp AL, strict byte 020h                  ; 3c 20                       ; 0xc4195
    je short 0419fh                           ; 74 06                       ; 0xc4197
    mov di, 00100h                            ; bf 00 01                    ; 0xc4199 vbe.c:767
    jmp near 04235h                           ; e9 96 00                    ; 0xc419c vbe.c:768
    push SS                                   ; 16                          ; 0xc419f vbe.c:772
    pop ES                                    ; 07                          ; 0xc41a0
    test byte [es:si+001h], 080h              ; 26 f6 44 01 80              ; 0xc41a1
    je short 041adh                           ; 74 05                       ; 0xc41a6
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc41a8
    jmp short 041afh                          ; eb 02                       ; 0xc41ab
    xor ax, ax                                ; 31 c0                       ; 0xc41ad
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc41af
    cmp cx, 00280h                            ; 81 f9 80 02                 ; 0xc41b2 vbe.c:775
    jnc short 041bdh                          ; 73 05                       ; 0xc41b6
    mov cx, 00280h                            ; b9 80 02                    ; 0xc41b8 vbe.c:776
    jmp short 041c6h                          ; eb 09                       ; 0xc41bb vbe.c:777
    cmp cx, 00a00h                            ; 81 f9 00 0a                 ; 0xc41bd
    jbe short 041c6h                          ; 76 03                       ; 0xc41c1
    mov cx, 00a00h                            ; b9 00 0a                    ; 0xc41c3 vbe.c:778
    cmp bx, 001e0h                            ; 81 fb e0 01                 ; 0xc41c6 vbe.c:779
    jnc short 041d1h                          ; 73 05                       ; 0xc41ca
    mov bx, 001e0h                            ; bb e0 01                    ; 0xc41cc vbe.c:780
    jmp short 041dah                          ; eb 09                       ; 0xc41cf vbe.c:781
    cmp bx, 00780h                            ; 81 fb 80 07                 ; 0xc41d1
    jbe short 041dah                          ; 76 03                       ; 0xc41d5
    mov bx, 00780h                            ; bb 80 07                    ; 0xc41d7 vbe.c:782
    mov dx, strict word 0ffffh                ; ba ff ff                    ; 0xc41da vbe.c:788
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc41dd
    call 03b8ah                               ; e8 a7 f9                    ; 0xc41e0
    mov si, ax                                ; 89 c6                       ; 0xc41e3
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc41e5 vbe.c:791
    cwd                                       ; 99                          ; 0xc41e9
    sal dx, 003h                              ; c1 e2 03                    ; 0xc41ea
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc41ed
    sar ax, 003h                              ; c1 f8 03                    ; 0xc41ef
    imul ax, cx                               ; 0f af c1                    ; 0xc41f2
    add ax, strict word 00003h                ; 05 03 00                    ; 0xc41f5 vbe.c:792
    and AL, strict byte 0fch                  ; 24 fc                       ; 0xc41f8
    mov dx, bx                                ; 89 da                       ; 0xc41fa vbe.c:794
    mul dx                                    ; f7 e2                       ; 0xc41fc
    cmp dx, si                                ; 39 f2                       ; 0xc41fe vbe.c:796
    jnbe short 04208h                         ; 77 06                       ; 0xc4200
    jne short 0420dh                          ; 75 09                       ; 0xc4202
    test ax, ax                               ; 85 c0                       ; 0xc4204
    jbe short 0420dh                          ; 76 05                       ; 0xc4206
    mov di, 00200h                            ; bf 00 02                    ; 0xc4208 vbe.c:798
    jmp short 04235h                          ; eb 28                       ; 0xc420b vbe.c:799
    xor ax, ax                                ; 31 c0                       ; 0xc420d vbe.c:803
    call 005ddh                               ; e8 cb c3                    ; 0xc420f
    movzx ax, byte [bp-008h]                  ; 0f b6 46 f8                 ; 0xc4212 vbe.c:804
    call 03b01h                               ; e8 e8 f8                    ; 0xc4216
    mov ax, cx                                ; 89 c8                       ; 0xc4219 vbe.c:805
    call 03aaah                               ; e8 8c f8                    ; 0xc421b
    mov ax, bx                                ; 89 d8                       ; 0xc421e vbe.c:806
    call 03ac9h                               ; e8 a6 f8                    ; 0xc4220
    xor ax, ax                                ; 31 c0                       ; 0xc4223 vbe.c:807
    call 00603h                               ; e8 db c3                    ; 0xc4225
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc4228 vbe.c:808
    or AL, strict byte 001h                   ; 0c 01                       ; 0xc422b
    xor ah, ah                                ; 30 e4                       ; 0xc422d
    call 005ddh                               ; e8 ab c3                    ; 0xc422f
    call 006d2h                               ; e8 9d c4                    ; 0xc4232 vbe.c:809
    push SS                                   ; 16                          ; 0xc4235 vbe.c:817
    pop ES                                    ; 07                          ; 0xc4236
    mov bx, word [bp-00ah]                    ; 8b 5e f6                    ; 0xc4237
    mov word [es:bx], di                      ; 26 89 3f                    ; 0xc423a
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc423d vbe.c:818
    pop di                                    ; 5f                          ; 0xc4240
    pop si                                    ; 5e                          ; 0xc4241
    pop bp                                    ; 5d                          ; 0xc4242
    retn                                      ; c3                          ; 0xc4243

  ; Padding 0x3fc bytes at 0xc4244
  times 1020 db 0

section VBE32 progbits vstart=0x4640 align=1 ; size=0x115 class=CODE group=AUTO
  ; disGetNextSymbol 0xc4640 LB 0x115 -> off=0x0 cb=0000000000000114 uValue=00000000000c0000 'vesa_pm_start'
vesa_pm_start:                               ; 0xc4640 LB 0x114
    sbb byte [bx+si], al                      ; 18 00                       ; 0xc4640
    dec di                                    ; 4f                          ; 0xc4642
    add byte [bx+si], dl                      ; 00 10                       ; 0xc4643
    add word [bx+si], cx                      ; 01 08                       ; 0xc4645
    add dh, cl                                ; 00 ce                       ; 0xc4647
    add di, cx                                ; 01 cf                       ; 0xc4649
    add di, cx                                ; 01 cf                       ; 0xc464b
    add ax, dx                                ; 01 d0                       ; 0xc464d
    add word [bp-048fdh], si                  ; 01 b6 03 b7                 ; 0xc464f
    db  003h, 0ffh
    ; add di, di                                ; 03 ff                     ; 0xc4653
    db  0ffh
    db  0ffh
    jmp word [bp-07dh]                        ; ff 66 83                    ; 0xc4657
    sti                                       ; fb                          ; 0xc465a
    add byte [si+005h], dh                    ; 00 74 05                    ; 0xc465b
    mov eax, strict dword 066c30100h          ; 66 b8 00 01 c3 66           ; 0xc465e vberom.asm:833
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc4664
    push edx                                  ; 66 52                       ; 0xc4666 vberom.asm:837
    push eax                                  ; 66 50                       ; 0xc4668 vberom.asm:838
    mov edx, strict dword 0b86601ceh          ; 66 ba ce 01 66 b8           ; 0xc466a vberom.asm:839
    add ax, 06600h                            ; 05 00 66                    ; 0xc4670
    out DX, ax                                ; ef                          ; 0xc4673
    pop eax                                   ; 66 58                       ; 0xc4674 vberom.asm:842
    mov edx, strict dword 0ef6601cfh          ; 66 ba cf 01 66 ef           ; 0xc4676 vberom.asm:843
    in eax, DX                                ; 66 ed                       ; 0xc467c vberom.asm:845
    pop edx                                   ; 66 5a                       ; 0xc467e vberom.asm:846
    db  066h, 03bh, 0d0h
    ; cmp edx, eax                              ; 66 3b d0                  ; 0xc4680 vberom.asm:847
    jne short 0468ah                          ; 75 05                       ; 0xc4683 vberom.asm:848
    mov eax, strict dword 066c3004fh          ; 66 b8 4f 00 c3 66           ; 0xc4685 vberom.asm:849
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc468b
    retn                                      ; c3                          ; 0xc468e vberom.asm:853
    cmp bl, 080h                              ; 80 fb 80                    ; 0xc468f vberom.asm:855
    je short 0469eh                           ; 74 0a                       ; 0xc4692 vberom.asm:856
    cmp bl, 000h                              ; 80 fb 00                    ; 0xc4694 vberom.asm:857
    je short 046aeh                           ; 74 15                       ; 0xc4697 vberom.asm:858
    mov eax, strict dword 052c30100h          ; 66 b8 00 01 c3 52           ; 0xc4699 vberom.asm:859
    mov edx, strict dword 0a8ec03dah          ; 66 ba da 03 ec a8           ; 0xc469f vberom.asm:863
    or byte [di-005h], dh                     ; 08 75 fb                    ; 0xc46a5
    in AL, DX                                 ; ec                          ; 0xc46a8 vberom.asm:869
    test AL, strict byte 008h                 ; a8 08                       ; 0xc46a9 vberom.asm:870
    je short 046a8h                           ; 74 fb                       ; 0xc46ab vberom.asm:871
    pop dx                                    ; 5a                          ; 0xc46ad vberom.asm:872
    push ax                                   ; 50                          ; 0xc46ae vberom.asm:876
    push cx                                   ; 51                          ; 0xc46af vberom.asm:877
    push dx                                   ; 52                          ; 0xc46b0 vberom.asm:878
    push si                                   ; 56                          ; 0xc46b1 vberom.asm:879
    push di                                   ; 57                          ; 0xc46b2 vberom.asm:880
    sal dx, 010h                              ; c1 e2 10                    ; 0xc46b3 vberom.asm:881
    and cx, strict word 0ffffh                ; 81 e1 ff ff                 ; 0xc46b6 vberom.asm:882
    add byte [bx+si], al                      ; 00 00                       ; 0xc46ba
    db  00bh, 0cah
    ; or cx, dx                                 ; 0b ca                     ; 0xc46bc vberom.asm:883
    sal cx, 002h                              ; c1 e1 02                    ; 0xc46be vberom.asm:884
    db  08bh, 0c1h
    ; mov ax, cx                                ; 8b c1                     ; 0xc46c1 vberom.asm:885
    push ax                                   ; 50                          ; 0xc46c3 vberom.asm:886
    mov edx, strict dword 0b86601ceh          ; 66 ba ce 01 66 b8           ; 0xc46c4 vberom.asm:887
    push ES                                   ; 06                          ; 0xc46ca
    add byte [bp-011h], ah                    ; 00 66 ef                    ; 0xc46cb
    mov edx, strict dword 0ed6601cfh          ; 66 ba cf 01 66 ed           ; 0xc46ce vberom.asm:890
    db  00fh, 0b7h, 0c8h
    ; movzx cx, ax                              ; 0f b7 c8                  ; 0xc46d4 vberom.asm:892
    mov edx, strict dword 0b86601ceh          ; 66 ba ce 01 66 b8           ; 0xc46d7 vberom.asm:893
    add ax, word [bx+si]                      ; 03 00                       ; 0xc46dd
    out DX, eax                               ; 66 ef                       ; 0xc46df vberom.asm:895
    mov edx, strict dword 0ed6601cfh          ; 66 ba cf 01 66 ed           ; 0xc46e1 vberom.asm:896
    db  00fh, 0b7h, 0f0h
    ; movzx si, ax                              ; 0f b7 f0                  ; 0xc46e7 vberom.asm:898
    pop ax                                    ; 58                          ; 0xc46ea vberom.asm:899
    cmp si, strict byte 00004h                ; 83 fe 04                    ; 0xc46eb vberom.asm:901
    je short 04707h                           ; 74 17                       ; 0xc46ee vberom.asm:902
    add si, strict byte 00007h                ; 83 c6 07                    ; 0xc46f0 vberom.asm:903
    shr si, 003h                              ; c1 ee 03                    ; 0xc46f3 vberom.asm:904
    imul cx, si                               ; 0f af ce                    ; 0xc46f6 vberom.asm:905
    db  033h, 0d2h
    ; xor dx, dx                                ; 33 d2                     ; 0xc46f9 vberom.asm:906
    div cx                                    ; f7 f1                       ; 0xc46fb vberom.asm:907
    db  08bh, 0f8h
    ; mov di, ax                                ; 8b f8                     ; 0xc46fd vberom.asm:908
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc46ff vberom.asm:909
    db  033h, 0d2h
    ; xor dx, dx                                ; 33 d2                     ; 0xc4701 vberom.asm:910
    div si                                    ; f7 f6                       ; 0xc4703 vberom.asm:911
    jmp short 04713h                          ; eb 0c                       ; 0xc4705 vberom.asm:912
    shr cx, 1                                 ; d1 e9                       ; 0xc4707 vberom.asm:915
    db  033h, 0d2h
    ; xor dx, dx                                ; 33 d2                     ; 0xc4709 vberom.asm:916
    div cx                                    ; f7 f1                       ; 0xc470b vberom.asm:917
    db  08bh, 0f8h
    ; mov di, ax                                ; 8b f8                     ; 0xc470d vberom.asm:918
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc470f vberom.asm:919
    sal ax, 1                                 ; d1 e0                       ; 0xc4711 vberom.asm:920
    push edx                                  ; 66 52                       ; 0xc4713 vberom.asm:923
    push eax                                  ; 66 50                       ; 0xc4715 vberom.asm:924
    mov edx, strict dword 0b86601ceh          ; 66 ba ce 01 66 b8           ; 0xc4717 vberom.asm:925
    or byte [bx+si], al                       ; 08 00                       ; 0xc471d
    out DX, eax                               ; 66 ef                       ; 0xc471f vberom.asm:927
    pop eax                                   ; 66 58                       ; 0xc4721 vberom.asm:928
    mov edx, strict dword 0ef6601cfh          ; 66 ba cf 01 66 ef           ; 0xc4723 vberom.asm:929
    pop edx                                   ; 66 5a                       ; 0xc4729 vberom.asm:931
    db  066h, 08bh, 0c7h
    ; mov eax, edi                              ; 66 8b c7                  ; 0xc472b vberom.asm:933
    push edx                                  ; 66 52                       ; 0xc472e vberom.asm:934
    push eax                                  ; 66 50                       ; 0xc4730 vberom.asm:935
    mov edx, strict dword 0b86601ceh          ; 66 ba ce 01 66 b8           ; 0xc4732 vberom.asm:936
    or word [bx+si], ax                       ; 09 00                       ; 0xc4738
    out DX, eax                               ; 66 ef                       ; 0xc473a vberom.asm:938
    pop eax                                   ; 66 58                       ; 0xc473c vberom.asm:939
    mov edx, strict dword 0ef6601cfh          ; 66 ba cf 01 66 ef           ; 0xc473e vberom.asm:940
    pop edx                                   ; 66 5a                       ; 0xc4744 vberom.asm:942
    pop di                                    ; 5f                          ; 0xc4746 vberom.asm:944
    pop si                                    ; 5e                          ; 0xc4747 vberom.asm:945
    pop dx                                    ; 5a                          ; 0xc4748 vberom.asm:946
    pop cx                                    ; 59                          ; 0xc4749 vberom.asm:947
    pop ax                                    ; 58                          ; 0xc474a vberom.asm:948
    mov eax, strict dword 066c3004fh          ; 66 b8 4f 00 c3 66           ; 0xc474b vberom.asm:949
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc4751
  ; disGetNextSymbol 0xc4754 LB 0x1 -> off=0x0 cb=0000000000000001 uValue=0000000000000114 'vesa_pm_end'
vesa_pm_end:                                 ; 0xc4754 LB 0x1
    retn                                      ; c3                          ; 0xc4754 vberom.asm:954

  ; Padding 0x2b bytes at 0xc4755
  times 43 db 0

section _DATA progbits vstart=0x4780 align=1 ; size=0x3745 class=DATA group=DGROUP
  ; disGetNextSymbol 0xc4780 LB 0x3745 -> off=0x0 cb=000000000000002c uValue=00000000000c0000 '_msg_vga_init'
_msg_vga_init:                               ; 0xc4780 LB 0x2c
    db  'Oracle VirtualBox Version 7.2.97 VGA BIOS', 00dh, 00ah, 000h
  ; disGetNextSymbol 0xc47ac LB 0x3719 -> off=0x0 cb=0000000000000080 uValue=00000000000c002c 'vga_modes'
vga_modes:                                   ; 0xc47ac LB 0x80
    db  000h, 000h, 000h, 004h, 000h, 0b8h, 0ffh, 002h, 001h, 000h, 000h, 004h, 000h, 0b8h, 0ffh, 002h
    db  002h, 000h, 000h, 004h, 000h, 0b8h, 0ffh, 002h, 003h, 000h, 000h, 004h, 000h, 0b8h, 0ffh, 002h
    db  004h, 001h, 002h, 002h, 000h, 0b8h, 0ffh, 001h, 005h, 001h, 002h, 002h, 000h, 0b8h, 0ffh, 001h
    db  006h, 001h, 002h, 001h, 000h, 0b8h, 0ffh, 001h, 007h, 000h, 001h, 004h, 000h, 0b0h, 0ffh, 000h
    db  00dh, 001h, 004h, 004h, 000h, 0a0h, 0ffh, 001h, 00eh, 001h, 004h, 004h, 000h, 0a0h, 0ffh, 001h
    db  00fh, 001h, 003h, 001h, 000h, 0a0h, 0ffh, 000h, 010h, 001h, 004h, 004h, 000h, 0a0h, 0ffh, 002h
    db  011h, 001h, 003h, 001h, 000h, 0a0h, 0ffh, 002h, 012h, 001h, 004h, 004h, 000h, 0a0h, 0ffh, 002h
    db  013h, 001h, 005h, 008h, 000h, 0a0h, 0ffh, 003h, 06ah, 001h, 004h, 004h, 000h, 0a0h, 0ffh, 002h
  ; disGetNextSymbol 0xc482c LB 0x3699 -> off=0x0 cb=0000000000000010 uValue=00000000000c00ac 'line_to_vpti'
line_to_vpti:                                ; 0xc482c LB 0x10
    db  017h, 017h, 018h, 018h, 004h, 005h, 006h, 007h, 00dh, 00eh, 011h, 012h, 01ah, 01bh, 01ch, 01dh
  ; disGetNextSymbol 0xc483c LB 0x3689 -> off=0x0 cb=0000000000000004 uValue=00000000000c00bc 'dac_regs'
dac_regs:                                    ; 0xc483c LB 0x4
    dd  0ff3f3f3fh
  ; disGetNextSymbol 0xc4840 LB 0x3685 -> off=0x0 cb=0000000000000780 uValue=00000000000c00c0 'video_param_table'
video_param_table:                           ; 0xc4840 LB 0x780
    db  028h, 018h, 008h, 000h, 008h, 009h, 003h, 000h, 002h, 063h, 02dh, 027h, 028h, 090h, 02bh, 0a0h
    db  0bfh, 01fh, 000h, 0c7h, 006h, 007h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 014h, 01fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 008h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  028h, 018h, 008h, 000h, 008h, 009h, 003h, 000h, 002h, 063h, 02dh, 027h, 028h, 090h, 02bh, 0a0h
    db  0bfh, 01fh, 000h, 0c7h, 006h, 007h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 014h, 01fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 008h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  050h, 018h, 008h, 000h, 010h, 001h, 003h, 000h, 002h, 063h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 0c7h, 006h, 007h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 01fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 008h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  050h, 018h, 008h, 000h, 010h, 001h, 003h, 000h, 002h, 063h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 0c7h, 006h, 007h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 01fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 008h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  028h, 018h, 008h, 000h, 040h, 009h, 003h, 000h, 002h, 063h, 02dh, 027h, 028h, 090h, 02bh, 080h
    db  0bfh, 01fh, 000h, 0c1h, 000h, 000h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 014h, 000h, 096h
    db  0b9h, 0a2h, 0ffh, 000h, 013h, 015h, 017h, 002h, 004h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 001h, 000h, 003h, 000h, 000h, 000h, 000h, 000h, 000h, 030h, 00fh, 00fh, 0ffh
    db  028h, 018h, 008h, 000h, 040h, 009h, 003h, 000h, 002h, 063h, 02dh, 027h, 028h, 090h, 02bh, 080h
    db  0bfh, 01fh, 000h, 0c1h, 000h, 000h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 014h, 000h, 096h
    db  0b9h, 0a2h, 0ffh, 000h, 013h, 015h, 017h, 002h, 004h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 001h, 000h, 003h, 000h, 000h, 000h, 000h, 000h, 000h, 030h, 00fh, 00fh, 0ffh
    db  050h, 018h, 008h, 000h, 040h, 001h, 001h, 000h, 006h, 063h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  0bfh, 01fh, 000h, 0c1h, 000h, 000h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 000h, 096h
    db  0b9h, 0c2h, 0ffh, 000h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h, 017h
    db  017h, 017h, 017h, 001h, 000h, 001h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 00dh, 00fh, 0ffh
    db  050h, 018h, 00eh, 000h, 010h, 000h, 003h, 000h, 003h, 0a6h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 04dh, 00bh, 00ch, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 028h, 00dh, 063h
    db  0bah, 0a3h, 0ffh, 000h, 008h, 008h, 008h, 008h, 008h, 008h, 008h, 010h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 00eh, 000h, 00fh, 008h, 000h, 000h, 000h, 000h, 000h, 010h, 00ah, 000h, 0ffh
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  028h, 018h, 008h, 000h, 020h, 009h, 00fh, 000h, 006h, 063h, 02dh, 027h, 028h, 090h, 02bh, 080h
    db  0bfh, 01fh, 000h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 014h, 000h, 096h
    db  0b9h, 0e3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 001h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
    db  050h, 018h, 008h, 000h, 040h, 001h, 00fh, 000h, 006h, 063h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  0bfh, 01fh, 000h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 000h, 096h
    db  0b9h, 0e3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 010h, 011h, 012h, 013h, 014h
    db  015h, 016h, 017h, 001h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  050h, 018h, 00eh, 000h, 080h, 001h, 00fh, 000h, 006h, 0a3h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  0bfh, 01fh, 000h, 040h, 000h, 000h, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 028h, 00fh, 063h
    db  0bah, 0e3h, 0ffh, 000h, 008h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 008h, 000h, 000h, 000h
    db  018h, 000h, 000h, 001h, 000h, 001h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
    db  050h, 018h, 00eh, 000h, 080h, 001h, 00fh, 000h, 006h, 0a3h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  0bfh, 01fh, 000h, 040h, 000h, 000h, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 028h, 00fh, 063h
    db  0bah, 0e3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 001h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
    db  028h, 018h, 00eh, 000h, 008h, 009h, 003h, 000h, 002h, 0a3h, 02dh, 027h, 028h, 090h, 02bh, 0a0h
    db  0bfh, 01fh, 000h, 04dh, 00bh, 00ch, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 014h, 01fh, 063h
    db  0bah, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 008h, 000h, 00fh, 008h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  028h, 018h, 00eh, 000h, 008h, 009h, 003h, 000h, 002h, 0a3h, 02dh, 027h, 028h, 090h, 02bh, 0a0h
    db  0bfh, 01fh, 000h, 04dh, 00bh, 00ch, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 014h, 01fh, 063h
    db  0bah, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 008h, 000h, 00fh, 008h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  050h, 018h, 00eh, 000h, 010h, 001h, 003h, 000h, 002h, 0a3h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 04dh, 00bh, 00ch, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 028h, 01fh, 063h
    db  0bah, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 008h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  050h, 018h, 00eh, 000h, 010h, 001h, 003h, 000h, 002h, 0a3h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 04dh, 00bh, 00ch, 000h, 000h, 000h, 000h, 083h, 085h, 05dh, 028h, 01fh, 063h
    db  0bah, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 008h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 000h, 0ffh
    db  028h, 018h, 010h, 000h, 008h, 008h, 003h, 000h, 002h, 067h, 02dh, 027h, 028h, 090h, 02bh, 0a0h
    db  0bfh, 01fh, 000h, 04fh, 00dh, 00eh, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 014h, 01fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 00ch, 000h, 00fh, 008h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 00fh, 0ffh
    db  050h, 018h, 010h, 000h, 010h, 000h, 003h, 000h, 002h, 067h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 04fh, 00dh, 00eh, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 01fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 00ch, 000h, 00fh, 008h, 000h, 000h, 000h, 000h, 000h, 010h, 00eh, 00fh, 0ffh
    db  050h, 018h, 010h, 000h, 010h, 000h, 003h, 000h, 002h, 066h, 05fh, 04fh, 050h, 082h, 055h, 081h
    db  0bfh, 01fh, 000h, 04fh, 00dh, 00eh, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 00fh, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 008h, 008h, 008h, 008h, 008h, 008h, 008h, 010h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 00eh, 000h, 00fh, 008h, 000h, 000h, 000h, 000h, 000h, 010h, 00ah, 00fh, 0ffh
    db  050h, 01dh, 010h, 000h, 0a0h, 001h, 00fh, 000h, 006h, 0e3h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  00bh, 03eh, 000h, 040h, 000h, 000h, 000h, 000h, 000h, 000h, 0eah, 08ch, 0dfh, 028h, 000h, 0e7h
    db  004h, 0c3h, 0ffh, 000h, 03fh, 000h, 03fh, 000h, 03fh, 000h, 03fh, 000h, 03fh, 000h, 03fh, 000h
    db  03fh, 000h, 03fh, 001h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
    db  050h, 01dh, 010h, 000h, 0a0h, 001h, 00fh, 000h, 006h, 0e3h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  00bh, 03eh, 000h, 040h, 000h, 000h, 000h, 000h, 000h, 000h, 0eah, 08ch, 0dfh, 028h, 000h, 0e7h
    db  004h, 0e3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 001h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
    db  028h, 018h, 008h, 000h, 020h, 001h, 00fh, 000h, 00eh, 063h, 05fh, 04fh, 050h, 082h, 054h, 080h
    db  0bfh, 01fh, 000h, 041h, 000h, 000h, 000h, 000h, 000h, 000h, 09ch, 08eh, 08fh, 028h, 040h, 096h
    db  0b9h, 0a3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 006h, 007h, 008h, 009h, 00ah, 00bh, 00ch
    db  00dh, 00eh, 00fh, 041h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 040h, 005h, 00fh, 0ffh
    db  064h, 024h, 010h, 000h, 000h, 001h, 00fh, 000h, 006h, 0e3h, 07fh, 063h, 063h, 083h, 06bh, 01bh
    db  072h, 0f0h, 000h, 060h, 000h, 000h, 000h, 000h, 000h, 000h, 059h, 08dh, 057h, 032h, 000h, 057h
    db  073h, 0e3h, 0ffh, 000h, 001h, 002h, 003h, 004h, 005h, 014h, 007h, 038h, 039h, 03ah, 03bh, 03ch
    db  03dh, 03eh, 03fh, 001h, 000h, 00fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 005h, 00fh, 0ffh
  ; disGetNextSymbol 0xc4fc0 LB 0x2f05 -> off=0x0 cb=00000000000000c0 uValue=00000000000c0840 'palette0'
palette0:                                    ; 0xc4fc0 LB 0xc0
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah
    db  02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah
    db  02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah
    db  02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh
    db  03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah
    db  02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah
    db  02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah
    db  02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 02ah, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh
    db  03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh, 03fh
  ; disGetNextSymbol 0xc5080 LB 0x2e45 -> off=0x0 cb=00000000000000c0 uValue=00000000000c0900 'palette1'
palette1:                                    ; 0xc5080 LB 0xc0
    db  000h, 000h, 000h, 000h, 000h, 02ah, 000h, 02ah, 000h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 02ah
    db  000h, 02ah, 02ah, 015h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 000h, 000h, 000h, 02ah, 000h, 02ah
    db  000h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 02ah, 000h, 02ah, 02ah, 015h, 000h, 02ah, 02ah, 02ah
    db  015h, 015h, 015h, 015h, 015h, 03fh, 015h, 03fh, 015h, 015h, 03fh, 03fh, 03fh, 015h, 015h, 03fh
    db  015h, 03fh, 03fh, 03fh, 015h, 03fh, 03fh, 03fh, 015h, 015h, 015h, 015h, 015h, 03fh, 015h, 03fh
    db  015h, 015h, 03fh, 03fh, 03fh, 015h, 015h, 03fh, 015h, 03fh, 03fh, 03fh, 015h, 03fh, 03fh, 03fh
    db  000h, 000h, 000h, 000h, 000h, 02ah, 000h, 02ah, 000h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 02ah
    db  000h, 02ah, 02ah, 015h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 000h, 000h, 000h, 02ah, 000h, 02ah
    db  000h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 02ah, 000h, 02ah, 02ah, 015h, 000h, 02ah, 02ah, 02ah
    db  015h, 015h, 015h, 015h, 015h, 03fh, 015h, 03fh, 015h, 015h, 03fh, 03fh, 03fh, 015h, 015h, 03fh
    db  015h, 03fh, 03fh, 03fh, 015h, 03fh, 03fh, 03fh, 015h, 015h, 015h, 015h, 015h, 03fh, 015h, 03fh
    db  015h, 015h, 03fh, 03fh, 03fh, 015h, 015h, 03fh, 015h, 03fh, 03fh, 03fh, 015h, 03fh, 03fh, 03fh
  ; disGetNextSymbol 0xc5140 LB 0x2d85 -> off=0x0 cb=00000000000000c0 uValue=00000000000c09c0 'palette2'
palette2:                                    ; 0xc5140 LB 0xc0
    db  000h, 000h, 000h, 000h, 000h, 02ah, 000h, 02ah, 000h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 02ah
    db  000h, 02ah, 02ah, 02ah, 000h, 02ah, 02ah, 02ah, 000h, 000h, 015h, 000h, 000h, 03fh, 000h, 02ah
    db  015h, 000h, 02ah, 03fh, 02ah, 000h, 015h, 02ah, 000h, 03fh, 02ah, 02ah, 015h, 02ah, 02ah, 03fh
    db  000h, 015h, 000h, 000h, 015h, 02ah, 000h, 03fh, 000h, 000h, 03fh, 02ah, 02ah, 015h, 000h, 02ah
    db  015h, 02ah, 02ah, 03fh, 000h, 02ah, 03fh, 02ah, 000h, 015h, 015h, 000h, 015h, 03fh, 000h, 03fh
    db  015h, 000h, 03fh, 03fh, 02ah, 015h, 015h, 02ah, 015h, 03fh, 02ah, 03fh, 015h, 02ah, 03fh, 03fh
    db  015h, 000h, 000h, 015h, 000h, 02ah, 015h, 02ah, 000h, 015h, 02ah, 02ah, 03fh, 000h, 000h, 03fh
    db  000h, 02ah, 03fh, 02ah, 000h, 03fh, 02ah, 02ah, 015h, 000h, 015h, 015h, 000h, 03fh, 015h, 02ah
    db  015h, 015h, 02ah, 03fh, 03fh, 000h, 015h, 03fh, 000h, 03fh, 03fh, 02ah, 015h, 03fh, 02ah, 03fh
    db  015h, 015h, 000h, 015h, 015h, 02ah, 015h, 03fh, 000h, 015h, 03fh, 02ah, 03fh, 015h, 000h, 03fh
    db  015h, 02ah, 03fh, 03fh, 000h, 03fh, 03fh, 02ah, 015h, 015h, 015h, 015h, 015h, 03fh, 015h, 03fh
    db  015h, 015h, 03fh, 03fh, 03fh, 015h, 015h, 03fh, 015h, 03fh, 03fh, 03fh, 015h, 03fh, 03fh, 03fh
  ; disGetNextSymbol 0xc5200 LB 0x2cc5 -> off=0x0 cb=0000000000000300 uValue=00000000000c0a80 'palette3'
palette3:                                    ; 0xc5200 LB 0x300
    db  000h, 000h, 000h, 000h, 000h, 02ah, 000h, 02ah, 000h, 000h, 02ah, 02ah, 02ah, 000h, 000h, 02ah
    db  000h, 02ah, 02ah, 015h, 000h, 02ah, 02ah, 02ah, 015h, 015h, 015h, 015h, 015h, 03fh, 015h, 03fh
    db  015h, 015h, 03fh, 03fh, 03fh, 015h, 015h, 03fh, 015h, 03fh, 03fh, 03fh, 015h, 03fh, 03fh, 03fh
    db  000h, 000h, 000h, 005h, 005h, 005h, 008h, 008h, 008h, 00bh, 00bh, 00bh, 00eh, 00eh, 00eh, 011h
    db  011h, 011h, 014h, 014h, 014h, 018h, 018h, 018h, 01ch, 01ch, 01ch, 020h, 020h, 020h, 024h, 024h
    db  024h, 028h, 028h, 028h, 02dh, 02dh, 02dh, 032h, 032h, 032h, 038h, 038h, 038h, 03fh, 03fh, 03fh
    db  000h, 000h, 03fh, 010h, 000h, 03fh, 01fh, 000h, 03fh, 02fh, 000h, 03fh, 03fh, 000h, 03fh, 03fh
    db  000h, 02fh, 03fh, 000h, 01fh, 03fh, 000h, 010h, 03fh, 000h, 000h, 03fh, 010h, 000h, 03fh, 01fh
    db  000h, 03fh, 02fh, 000h, 03fh, 03fh, 000h, 02fh, 03fh, 000h, 01fh, 03fh, 000h, 010h, 03fh, 000h
    db  000h, 03fh, 000h, 000h, 03fh, 010h, 000h, 03fh, 01fh, 000h, 03fh, 02fh, 000h, 03fh, 03fh, 000h
    db  02fh, 03fh, 000h, 01fh, 03fh, 000h, 010h, 03fh, 01fh, 01fh, 03fh, 027h, 01fh, 03fh, 02fh, 01fh
    db  03fh, 037h, 01fh, 03fh, 03fh, 01fh, 03fh, 03fh, 01fh, 037h, 03fh, 01fh, 02fh, 03fh, 01fh, 027h
    db  03fh, 01fh, 01fh, 03fh, 027h, 01fh, 03fh, 02fh, 01fh, 03fh, 037h, 01fh, 03fh, 03fh, 01fh, 037h
    db  03fh, 01fh, 02fh, 03fh, 01fh, 027h, 03fh, 01fh, 01fh, 03fh, 01fh, 01fh, 03fh, 027h, 01fh, 03fh
    db  02fh, 01fh, 03fh, 037h, 01fh, 03fh, 03fh, 01fh, 037h, 03fh, 01fh, 02fh, 03fh, 01fh, 027h, 03fh
    db  02dh, 02dh, 03fh, 031h, 02dh, 03fh, 036h, 02dh, 03fh, 03ah, 02dh, 03fh, 03fh, 02dh, 03fh, 03fh
    db  02dh, 03ah, 03fh, 02dh, 036h, 03fh, 02dh, 031h, 03fh, 02dh, 02dh, 03fh, 031h, 02dh, 03fh, 036h
    db  02dh, 03fh, 03ah, 02dh, 03fh, 03fh, 02dh, 03ah, 03fh, 02dh, 036h, 03fh, 02dh, 031h, 03fh, 02dh
    db  02dh, 03fh, 02dh, 02dh, 03fh, 031h, 02dh, 03fh, 036h, 02dh, 03fh, 03ah, 02dh, 03fh, 03fh, 02dh
    db  03ah, 03fh, 02dh, 036h, 03fh, 02dh, 031h, 03fh, 000h, 000h, 01ch, 007h, 000h, 01ch, 00eh, 000h
    db  01ch, 015h, 000h, 01ch, 01ch, 000h, 01ch, 01ch, 000h, 015h, 01ch, 000h, 00eh, 01ch, 000h, 007h
    db  01ch, 000h, 000h, 01ch, 007h, 000h, 01ch, 00eh, 000h, 01ch, 015h, 000h, 01ch, 01ch, 000h, 015h
    db  01ch, 000h, 00eh, 01ch, 000h, 007h, 01ch, 000h, 000h, 01ch, 000h, 000h, 01ch, 007h, 000h, 01ch
    db  00eh, 000h, 01ch, 015h, 000h, 01ch, 01ch, 000h, 015h, 01ch, 000h, 00eh, 01ch, 000h, 007h, 01ch
    db  00eh, 00eh, 01ch, 011h, 00eh, 01ch, 015h, 00eh, 01ch, 018h, 00eh, 01ch, 01ch, 00eh, 01ch, 01ch
    db  00eh, 018h, 01ch, 00eh, 015h, 01ch, 00eh, 011h, 01ch, 00eh, 00eh, 01ch, 011h, 00eh, 01ch, 015h
    db  00eh, 01ch, 018h, 00eh, 01ch, 01ch, 00eh, 018h, 01ch, 00eh, 015h, 01ch, 00eh, 011h, 01ch, 00eh
    db  00eh, 01ch, 00eh, 00eh, 01ch, 011h, 00eh, 01ch, 015h, 00eh, 01ch, 018h, 00eh, 01ch, 01ch, 00eh
    db  018h, 01ch, 00eh, 015h, 01ch, 00eh, 011h, 01ch, 014h, 014h, 01ch, 016h, 014h, 01ch, 018h, 014h
    db  01ch, 01ah, 014h, 01ch, 01ch, 014h, 01ch, 01ch, 014h, 01ah, 01ch, 014h, 018h, 01ch, 014h, 016h
    db  01ch, 014h, 014h, 01ch, 016h, 014h, 01ch, 018h, 014h, 01ch, 01ah, 014h, 01ch, 01ch, 014h, 01ah
    db  01ch, 014h, 018h, 01ch, 014h, 016h, 01ch, 014h, 014h, 01ch, 014h, 014h, 01ch, 016h, 014h, 01ch
    db  018h, 014h, 01ch, 01ah, 014h, 01ch, 01ch, 014h, 01ah, 01ch, 014h, 018h, 01ch, 014h, 016h, 01ch
    db  000h, 000h, 010h, 004h, 000h, 010h, 008h, 000h, 010h, 00ch, 000h, 010h, 010h, 000h, 010h, 010h
    db  000h, 00ch, 010h, 000h, 008h, 010h, 000h, 004h, 010h, 000h, 000h, 010h, 004h, 000h, 010h, 008h
    db  000h, 010h, 00ch, 000h, 010h, 010h, 000h, 00ch, 010h, 000h, 008h, 010h, 000h, 004h, 010h, 000h
    db  000h, 010h, 000h, 000h, 010h, 004h, 000h, 010h, 008h, 000h, 010h, 00ch, 000h, 010h, 010h, 000h
    db  00ch, 010h, 000h, 008h, 010h, 000h, 004h, 010h, 008h, 008h, 010h, 00ah, 008h, 010h, 00ch, 008h
    db  010h, 00eh, 008h, 010h, 010h, 008h, 010h, 010h, 008h, 00eh, 010h, 008h, 00ch, 010h, 008h, 00ah
    db  010h, 008h, 008h, 010h, 00ah, 008h, 010h, 00ch, 008h, 010h, 00eh, 008h, 010h, 010h, 008h, 00eh
    db  010h, 008h, 00ch, 010h, 008h, 00ah, 010h, 008h, 008h, 010h, 008h, 008h, 010h, 00ah, 008h, 010h
    db  00ch, 008h, 010h, 00eh, 008h, 010h, 010h, 008h, 00eh, 010h, 008h, 00ch, 010h, 008h, 00ah, 010h
    db  00bh, 00bh, 010h, 00ch, 00bh, 010h, 00dh, 00bh, 010h, 00fh, 00bh, 010h, 010h, 00bh, 010h, 010h
    db  00bh, 00fh, 010h, 00bh, 00dh, 010h, 00bh, 00ch, 010h, 00bh, 00bh, 010h, 00ch, 00bh, 010h, 00dh
    db  00bh, 010h, 00fh, 00bh, 010h, 010h, 00bh, 00fh, 010h, 00bh, 00dh, 010h, 00bh, 00ch, 010h, 00bh
    db  00bh, 010h, 00bh, 00bh, 010h, 00ch, 00bh, 010h, 00dh, 00bh, 010h, 00fh, 00bh, 010h, 010h, 00bh
    db  00fh, 010h, 00bh, 00dh, 010h, 00bh, 00ch, 010h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc5500 LB 0x29c5 -> off=0x0 cb=0000000000000010 uValue=00000000000c0d80 'static_functionality'
static_functionality:                        ; 0xc5500 LB 0x10
    db  0ffh, 0e0h, 00fh, 000h, 000h, 000h, 000h, 007h, 002h, 008h, 0e7h, 00ch, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc5510 LB 0x29b5 -> off=0x0 cb=0000000000000024 uValue=00000000000c0d90 '_dcc_table'
_dcc_table:                                  ; 0xc5510 LB 0x24
    db  010h, 001h, 007h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc5534 LB 0x2991 -> off=0x0 cb=000000000000001a uValue=00000000000c0db4 '_secondary_save_area'
_secondary_save_area:                        ; 0xc5534 LB 0x1a
    db  01ah, 000h, 010h, 055h, 000h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc554e LB 0x2977 -> off=0x0 cb=000000000000001c uValue=00000000000c0dce '_video_save_pointer_table'
_video_save_pointer_table:                   ; 0xc554e LB 0x1c
    db  040h, 048h, 000h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  034h, 055h, 000h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc556a LB 0x295b -> off=0x0 cb=0000000000000800 uValue=00000000000c0dea 'vgafont8'
vgafont8:                                    ; 0xc556a LB 0x800
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07eh, 081h, 0a5h, 081h, 0bdh, 099h, 081h, 07eh
    db  07eh, 0ffh, 0dbh, 0ffh, 0c3h, 0e7h, 0ffh, 07eh, 06ch, 0feh, 0feh, 0feh, 07ch, 038h, 010h, 000h
    db  010h, 038h, 07ch, 0feh, 07ch, 038h, 010h, 000h, 038h, 07ch, 038h, 0feh, 0feh, 07ch, 038h, 07ch
    db  010h, 010h, 038h, 07ch, 0feh, 07ch, 038h, 07ch, 000h, 000h, 018h, 03ch, 03ch, 018h, 000h, 000h
    db  0ffh, 0ffh, 0e7h, 0c3h, 0c3h, 0e7h, 0ffh, 0ffh, 000h, 03ch, 066h, 042h, 042h, 066h, 03ch, 000h
    db  0ffh, 0c3h, 099h, 0bdh, 0bdh, 099h, 0c3h, 0ffh, 00fh, 007h, 00fh, 07dh, 0cch, 0cch, 0cch, 078h
    db  03ch, 066h, 066h, 066h, 03ch, 018h, 07eh, 018h, 03fh, 033h, 03fh, 030h, 030h, 070h, 0f0h, 0e0h
    db  07fh, 063h, 07fh, 063h, 063h, 067h, 0e6h, 0c0h, 099h, 05ah, 03ch, 0e7h, 0e7h, 03ch, 05ah, 099h
    db  080h, 0e0h, 0f8h, 0feh, 0f8h, 0e0h, 080h, 000h, 002h, 00eh, 03eh, 0feh, 03eh, 00eh, 002h, 000h
    db  018h, 03ch, 07eh, 018h, 018h, 07eh, 03ch, 018h, 066h, 066h, 066h, 066h, 066h, 000h, 066h, 000h
    db  07fh, 0dbh, 0dbh, 07bh, 01bh, 01bh, 01bh, 000h, 03eh, 063h, 038h, 06ch, 06ch, 038h, 0cch, 078h
    db  000h, 000h, 000h, 000h, 07eh, 07eh, 07eh, 000h, 018h, 03ch, 07eh, 018h, 07eh, 03ch, 018h, 0ffh
    db  018h, 03ch, 07eh, 018h, 018h, 018h, 018h, 000h, 018h, 018h, 018h, 018h, 07eh, 03ch, 018h, 000h
    db  000h, 018h, 00ch, 0feh, 00ch, 018h, 000h, 000h, 000h, 030h, 060h, 0feh, 060h, 030h, 000h, 000h
    db  000h, 000h, 0c0h, 0c0h, 0c0h, 0feh, 000h, 000h, 000h, 024h, 066h, 0ffh, 066h, 024h, 000h, 000h
    db  000h, 018h, 03ch, 07eh, 0ffh, 0ffh, 000h, 000h, 000h, 0ffh, 0ffh, 07eh, 03ch, 018h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 030h, 078h, 078h, 030h, 030h, 000h, 030h, 000h
    db  06ch, 06ch, 06ch, 000h, 000h, 000h, 000h, 000h, 06ch, 06ch, 0feh, 06ch, 0feh, 06ch, 06ch, 000h
    db  030h, 07ch, 0c0h, 078h, 00ch, 0f8h, 030h, 000h, 000h, 0c6h, 0cch, 018h, 030h, 066h, 0c6h, 000h
    db  038h, 06ch, 038h, 076h, 0dch, 0cch, 076h, 000h, 060h, 060h, 0c0h, 000h, 000h, 000h, 000h, 000h
    db  018h, 030h, 060h, 060h, 060h, 030h, 018h, 000h, 060h, 030h, 018h, 018h, 018h, 030h, 060h, 000h
    db  000h, 066h, 03ch, 0ffh, 03ch, 066h, 000h, 000h, 000h, 030h, 030h, 0fch, 030h, 030h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 030h, 030h, 060h, 000h, 000h, 000h, 0fch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 030h, 030h, 000h, 006h, 00ch, 018h, 030h, 060h, 0c0h, 080h, 000h
    db  07ch, 0c6h, 0ceh, 0deh, 0f6h, 0e6h, 07ch, 000h, 030h, 070h, 030h, 030h, 030h, 030h, 0fch, 000h
    db  078h, 0cch, 00ch, 038h, 060h, 0cch, 0fch, 000h, 078h, 0cch, 00ch, 038h, 00ch, 0cch, 078h, 000h
    db  01ch, 03ch, 06ch, 0cch, 0feh, 00ch, 01eh, 000h, 0fch, 0c0h, 0f8h, 00ch, 00ch, 0cch, 078h, 000h
    db  038h, 060h, 0c0h, 0f8h, 0cch, 0cch, 078h, 000h, 0fch, 0cch, 00ch, 018h, 030h, 030h, 030h, 000h
    db  078h, 0cch, 0cch, 078h, 0cch, 0cch, 078h, 000h, 078h, 0cch, 0cch, 07ch, 00ch, 018h, 070h, 000h
    db  000h, 030h, 030h, 000h, 000h, 030h, 030h, 000h, 000h, 030h, 030h, 000h, 000h, 030h, 030h, 060h
    db  018h, 030h, 060h, 0c0h, 060h, 030h, 018h, 000h, 000h, 000h, 0fch, 000h, 000h, 0fch, 000h, 000h
    db  060h, 030h, 018h, 00ch, 018h, 030h, 060h, 000h, 078h, 0cch, 00ch, 018h, 030h, 000h, 030h, 000h
    db  07ch, 0c6h, 0deh, 0deh, 0deh, 0c0h, 078h, 000h, 030h, 078h, 0cch, 0cch, 0fch, 0cch, 0cch, 000h
    db  0fch, 066h, 066h, 07ch, 066h, 066h, 0fch, 000h, 03ch, 066h, 0c0h, 0c0h, 0c0h, 066h, 03ch, 000h
    db  0f8h, 06ch, 066h, 066h, 066h, 06ch, 0f8h, 000h, 0feh, 062h, 068h, 078h, 068h, 062h, 0feh, 000h
    db  0feh, 062h, 068h, 078h, 068h, 060h, 0f0h, 000h, 03ch, 066h, 0c0h, 0c0h, 0ceh, 066h, 03eh, 000h
    db  0cch, 0cch, 0cch, 0fch, 0cch, 0cch, 0cch, 000h, 078h, 030h, 030h, 030h, 030h, 030h, 078h, 000h
    db  01eh, 00ch, 00ch, 00ch, 0cch, 0cch, 078h, 000h, 0e6h, 066h, 06ch, 078h, 06ch, 066h, 0e6h, 000h
    db  0f0h, 060h, 060h, 060h, 062h, 066h, 0feh, 000h, 0c6h, 0eeh, 0feh, 0feh, 0d6h, 0c6h, 0c6h, 000h
    db  0c6h, 0e6h, 0f6h, 0deh, 0ceh, 0c6h, 0c6h, 000h, 038h, 06ch, 0c6h, 0c6h, 0c6h, 06ch, 038h, 000h
    db  0fch, 066h, 066h, 07ch, 060h, 060h, 0f0h, 000h, 078h, 0cch, 0cch, 0cch, 0dch, 078h, 01ch, 000h
    db  0fch, 066h, 066h, 07ch, 06ch, 066h, 0e6h, 000h, 078h, 0cch, 0e0h, 070h, 01ch, 0cch, 078h, 000h
    db  0fch, 0b4h, 030h, 030h, 030h, 030h, 078h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 0fch, 000h
    db  0cch, 0cch, 0cch, 0cch, 0cch, 078h, 030h, 000h, 0c6h, 0c6h, 0c6h, 0d6h, 0feh, 0eeh, 0c6h, 000h
    db  0c6h, 0c6h, 06ch, 038h, 038h, 06ch, 0c6h, 000h, 0cch, 0cch, 0cch, 078h, 030h, 030h, 078h, 000h
    db  0feh, 0c6h, 08ch, 018h, 032h, 066h, 0feh, 000h, 078h, 060h, 060h, 060h, 060h, 060h, 078h, 000h
    db  0c0h, 060h, 030h, 018h, 00ch, 006h, 002h, 000h, 078h, 018h, 018h, 018h, 018h, 018h, 078h, 000h
    db  010h, 038h, 06ch, 0c6h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh
    db  030h, 030h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 078h, 00ch, 07ch, 0cch, 076h, 000h
    db  0e0h, 060h, 060h, 07ch, 066h, 066h, 0dch, 000h, 000h, 000h, 078h, 0cch, 0c0h, 0cch, 078h, 000h
    db  01ch, 00ch, 00ch, 07ch, 0cch, 0cch, 076h, 000h, 000h, 000h, 078h, 0cch, 0fch, 0c0h, 078h, 000h
    db  038h, 06ch, 060h, 0f0h, 060h, 060h, 0f0h, 000h, 000h, 000h, 076h, 0cch, 0cch, 07ch, 00ch, 0f8h
    db  0e0h, 060h, 06ch, 076h, 066h, 066h, 0e6h, 000h, 030h, 000h, 070h, 030h, 030h, 030h, 078h, 000h
    db  00ch, 000h, 00ch, 00ch, 00ch, 0cch, 0cch, 078h, 0e0h, 060h, 066h, 06ch, 078h, 06ch, 0e6h, 000h
    db  070h, 030h, 030h, 030h, 030h, 030h, 078h, 000h, 000h, 000h, 0cch, 0feh, 0feh, 0d6h, 0c6h, 000h
    db  000h, 000h, 0f8h, 0cch, 0cch, 0cch, 0cch, 000h, 000h, 000h, 078h, 0cch, 0cch, 0cch, 078h, 000h
    db  000h, 000h, 0dch, 066h, 066h, 07ch, 060h, 0f0h, 000h, 000h, 076h, 0cch, 0cch, 07ch, 00ch, 01eh
    db  000h, 000h, 0dch, 076h, 066h, 060h, 0f0h, 000h, 000h, 000h, 07ch, 0c0h, 078h, 00ch, 0f8h, 000h
    db  010h, 030h, 07ch, 030h, 030h, 034h, 018h, 000h, 000h, 000h, 0cch, 0cch, 0cch, 0cch, 076h, 000h
    db  000h, 000h, 0cch, 0cch, 0cch, 078h, 030h, 000h, 000h, 000h, 0c6h, 0d6h, 0feh, 0feh, 06ch, 000h
    db  000h, 000h, 0c6h, 06ch, 038h, 06ch, 0c6h, 000h, 000h, 000h, 0cch, 0cch, 0cch, 07ch, 00ch, 0f8h
    db  000h, 000h, 0fch, 098h, 030h, 064h, 0fch, 000h, 01ch, 030h, 030h, 0e0h, 030h, 030h, 01ch, 000h
    db  018h, 018h, 018h, 000h, 018h, 018h, 018h, 000h, 0e0h, 030h, 030h, 01ch, 030h, 030h, 0e0h, 000h
    db  076h, 0dch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 038h, 06ch, 0c6h, 0c6h, 0feh, 000h
    db  078h, 0cch, 0c0h, 0cch, 078h, 018h, 00ch, 078h, 000h, 0cch, 000h, 0cch, 0cch, 0cch, 07eh, 000h
    db  01ch, 000h, 078h, 0cch, 0fch, 0c0h, 078h, 000h, 07eh, 0c3h, 03ch, 006h, 03eh, 066h, 03fh, 000h
    db  0cch, 000h, 078h, 00ch, 07ch, 0cch, 07eh, 000h, 0e0h, 000h, 078h, 00ch, 07ch, 0cch, 07eh, 000h
    db  030h, 030h, 078h, 00ch, 07ch, 0cch, 07eh, 000h, 000h, 000h, 078h, 0c0h, 0c0h, 078h, 00ch, 038h
    db  07eh, 0c3h, 03ch, 066h, 07eh, 060h, 03ch, 000h, 0cch, 000h, 078h, 0cch, 0fch, 0c0h, 078h, 000h
    db  0e0h, 000h, 078h, 0cch, 0fch, 0c0h, 078h, 000h, 0cch, 000h, 070h, 030h, 030h, 030h, 078h, 000h
    db  07ch, 0c6h, 038h, 018h, 018h, 018h, 03ch, 000h, 0e0h, 000h, 070h, 030h, 030h, 030h, 078h, 000h
    db  0c6h, 038h, 06ch, 0c6h, 0feh, 0c6h, 0c6h, 000h, 030h, 030h, 000h, 078h, 0cch, 0fch, 0cch, 000h
    db  01ch, 000h, 0fch, 060h, 078h, 060h, 0fch, 000h, 000h, 000h, 07fh, 00ch, 07fh, 0cch, 07fh, 000h
    db  03eh, 06ch, 0cch, 0feh, 0cch, 0cch, 0ceh, 000h, 078h, 0cch, 000h, 078h, 0cch, 0cch, 078h, 000h
    db  000h, 0cch, 000h, 078h, 0cch, 0cch, 078h, 000h, 000h, 0e0h, 000h, 078h, 0cch, 0cch, 078h, 000h
    db  078h, 0cch, 000h, 0cch, 0cch, 0cch, 07eh, 000h, 000h, 0e0h, 000h, 0cch, 0cch, 0cch, 07eh, 000h
    db  000h, 0cch, 000h, 0cch, 0cch, 07ch, 00ch, 0f8h, 0c3h, 018h, 03ch, 066h, 066h, 03ch, 018h, 000h
    db  0cch, 000h, 0cch, 0cch, 0cch, 0cch, 078h, 000h, 018h, 018h, 07eh, 0c0h, 0c0h, 07eh, 018h, 018h
    db  038h, 06ch, 064h, 0f0h, 060h, 0e6h, 0fch, 000h, 0cch, 0cch, 078h, 0fch, 030h, 0fch, 030h, 030h
    db  0f8h, 0cch, 0cch, 0fah, 0c6h, 0cfh, 0c6h, 0c7h, 00eh, 01bh, 018h, 03ch, 018h, 018h, 0d8h, 070h
    db  01ch, 000h, 078h, 00ch, 07ch, 0cch, 07eh, 000h, 038h, 000h, 070h, 030h, 030h, 030h, 078h, 000h
    db  000h, 01ch, 000h, 078h, 0cch, 0cch, 078h, 000h, 000h, 01ch, 000h, 0cch, 0cch, 0cch, 07eh, 000h
    db  000h, 0f8h, 000h, 0f8h, 0cch, 0cch, 0cch, 000h, 0fch, 000h, 0cch, 0ech, 0fch, 0dch, 0cch, 000h
    db  03ch, 06ch, 06ch, 03eh, 000h, 07eh, 000h, 000h, 038h, 06ch, 06ch, 038h, 000h, 07ch, 000h, 000h
    db  030h, 000h, 030h, 060h, 0c0h, 0cch, 078h, 000h, 000h, 000h, 000h, 0fch, 0c0h, 0c0h, 000h, 000h
    db  000h, 000h, 000h, 0fch, 00ch, 00ch, 000h, 000h, 0c3h, 0c6h, 0cch, 0deh, 033h, 066h, 0cch, 00fh
    db  0c3h, 0c6h, 0cch, 0dbh, 037h, 06fh, 0cfh, 003h, 018h, 018h, 000h, 018h, 018h, 018h, 018h, 000h
    db  000h, 033h, 066h, 0cch, 066h, 033h, 000h, 000h, 000h, 0cch, 066h, 033h, 066h, 0cch, 000h, 000h
    db  022h, 088h, 022h, 088h, 022h, 088h, 022h, 088h, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah
    db  0dbh, 077h, 0dbh, 0eeh, 0dbh, 077h, 0dbh, 0eeh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 0f8h, 018h, 018h, 018h, 018h, 018h, 0f8h, 018h, 0f8h, 018h, 018h, 018h
    db  036h, 036h, 036h, 036h, 0f6h, 036h, 036h, 036h, 000h, 000h, 000h, 000h, 0feh, 036h, 036h, 036h
    db  000h, 000h, 0f8h, 018h, 0f8h, 018h, 018h, 018h, 036h, 036h, 0f6h, 006h, 0f6h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 000h, 000h, 0feh, 006h, 0f6h, 036h, 036h, 036h
    db  036h, 036h, 0f6h, 006h, 0feh, 000h, 000h, 000h, 036h, 036h, 036h, 036h, 0feh, 000h, 000h, 000h
    db  018h, 018h, 0f8h, 018h, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0f8h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 01fh, 000h, 000h, 000h, 018h, 018h, 018h, 018h, 0ffh, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 01fh, 018h, 018h, 018h
    db  000h, 000h, 000h, 000h, 0ffh, 000h, 000h, 000h, 018h, 018h, 018h, 018h, 0ffh, 018h, 018h, 018h
    db  018h, 018h, 01fh, 018h, 01fh, 018h, 018h, 018h, 036h, 036h, 036h, 036h, 037h, 036h, 036h, 036h
    db  036h, 036h, 037h, 030h, 03fh, 000h, 000h, 000h, 000h, 000h, 03fh, 030h, 037h, 036h, 036h, 036h
    db  036h, 036h, 0f7h, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 0f7h, 036h, 036h, 036h
    db  036h, 036h, 037h, 030h, 037h, 036h, 036h, 036h, 000h, 000h, 0ffh, 000h, 0ffh, 000h, 000h, 000h
    db  036h, 036h, 0f7h, 000h, 0f7h, 036h, 036h, 036h, 018h, 018h, 0ffh, 000h, 0ffh, 000h, 000h, 000h
    db  036h, 036h, 036h, 036h, 0ffh, 000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 0ffh, 018h, 018h, 018h
    db  000h, 000h, 000h, 000h, 0ffh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 03fh, 000h, 000h, 000h
    db  018h, 018h, 01fh, 018h, 01fh, 000h, 000h, 000h, 000h, 000h, 01fh, 018h, 01fh, 018h, 018h, 018h
    db  000h, 000h, 000h, 000h, 03fh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 0ffh, 036h, 036h, 036h
    db  018h, 018h, 0ffh, 018h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0f8h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 01fh, 018h, 018h, 018h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
    db  000h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h
    db  00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 0ffh, 0ffh, 0ffh, 0ffh, 000h, 000h, 000h, 000h
    db  000h, 000h, 076h, 0dch, 0c8h, 0dch, 076h, 000h, 000h, 078h, 0cch, 0f8h, 0cch, 0f8h, 0c0h, 0c0h
    db  000h, 0fch, 0cch, 0c0h, 0c0h, 0c0h, 0c0h, 000h, 000h, 0feh, 06ch, 06ch, 06ch, 06ch, 06ch, 000h
    db  0fch, 0cch, 060h, 030h, 060h, 0cch, 0fch, 000h, 000h, 000h, 07eh, 0d8h, 0d8h, 0d8h, 070h, 000h
    db  000h, 066h, 066h, 066h, 066h, 07ch, 060h, 0c0h, 000h, 076h, 0dch, 018h, 018h, 018h, 018h, 000h
    db  0fch, 030h, 078h, 0cch, 0cch, 078h, 030h, 0fch, 038h, 06ch, 0c6h, 0feh, 0c6h, 06ch, 038h, 000h
    db  038h, 06ch, 0c6h, 0c6h, 06ch, 06ch, 0eeh, 000h, 01ch, 030h, 018h, 07ch, 0cch, 0cch, 078h, 000h
    db  000h, 000h, 07eh, 0dbh, 0dbh, 07eh, 000h, 000h, 006h, 00ch, 07eh, 0dbh, 0dbh, 07eh, 060h, 0c0h
    db  038h, 060h, 0c0h, 0f8h, 0c0h, 060h, 038h, 000h, 078h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 000h
    db  000h, 0fch, 000h, 0fch, 000h, 0fch, 000h, 000h, 030h, 030h, 0fch, 030h, 030h, 000h, 0fch, 000h
    db  060h, 030h, 018h, 030h, 060h, 000h, 0fch, 000h, 018h, 030h, 060h, 030h, 018h, 000h, 0fch, 000h
    db  00eh, 01bh, 01bh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0d8h, 0d8h, 070h
    db  030h, 030h, 000h, 0fch, 000h, 030h, 030h, 000h, 000h, 076h, 0dch, 000h, 076h, 0dch, 000h, 000h
    db  038h, 06ch, 06ch, 038h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 000h, 000h, 000h, 00fh, 00ch, 00ch, 00ch, 0ech, 06ch, 03ch, 01ch
    db  078h, 06ch, 06ch, 06ch, 06ch, 000h, 000h, 000h, 070h, 018h, 030h, 060h, 078h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 03ch, 03ch, 03ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc5d6a LB 0x215b -> off=0x0 cb=0000000000000e00 uValue=00000000000c15ea 'vgafont14'
vgafont14:                                   ; 0xc5d6a LB 0xe00
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  07eh, 081h, 0a5h, 081h, 081h, 0bdh, 099h, 081h, 07eh, 000h, 000h, 000h, 000h, 000h, 07eh, 0ffh
    db  0dbh, 0ffh, 0ffh, 0c3h, 0e7h, 0ffh, 07eh, 000h, 000h, 000h, 000h, 000h, 000h, 06ch, 0feh, 0feh
    db  0feh, 0feh, 07ch, 038h, 010h, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 038h, 07ch, 0feh, 07ch
    db  038h, 010h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 03ch, 03ch, 0e7h, 0e7h, 0e7h, 018h, 018h
    db  03ch, 000h, 000h, 000h, 000h, 000h, 018h, 03ch, 07eh, 0ffh, 0ffh, 07eh, 018h, 018h, 03ch, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 03ch, 03ch, 018h, 000h, 000h, 000h, 000h, 000h
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0e7h, 0c3h, 0c3h, 0e7h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 000h, 000h
    db  000h, 000h, 03ch, 066h, 042h, 042h, 066h, 03ch, 000h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh
    db  0c3h, 099h, 0bdh, 0bdh, 099h, 0c3h, 0ffh, 0ffh, 0ffh, 0ffh, 000h, 000h, 01eh, 00eh, 01ah, 032h
    db  078h, 0cch, 0cch, 0cch, 078h, 000h, 000h, 000h, 000h, 000h, 03ch, 066h, 066h, 066h, 03ch, 018h
    db  07eh, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 03fh, 033h, 03fh, 030h, 030h, 030h, 070h, 0f0h
    db  0e0h, 000h, 000h, 000h, 000h, 000h, 07fh, 063h, 07fh, 063h, 063h, 063h, 067h, 0e7h, 0e6h, 0c0h
    db  000h, 000h, 000h, 000h, 018h, 018h, 0dbh, 03ch, 0e7h, 03ch, 0dbh, 018h, 018h, 000h, 000h, 000h
    db  000h, 000h, 080h, 0c0h, 0e0h, 0f8h, 0feh, 0f8h, 0e0h, 0c0h, 080h, 000h, 000h, 000h, 000h, 000h
    db  002h, 006h, 00eh, 03eh, 0feh, 03eh, 00eh, 006h, 002h, 000h, 000h, 000h, 000h, 000h, 018h, 03ch
    db  07eh, 018h, 018h, 018h, 07eh, 03ch, 018h, 000h, 000h, 000h, 000h, 000h, 066h, 066h, 066h, 066h
    db  066h, 066h, 000h, 066h, 066h, 000h, 000h, 000h, 000h, 000h, 07fh, 0dbh, 0dbh, 0dbh, 07bh, 01bh
    db  01bh, 01bh, 01bh, 000h, 000h, 000h, 000h, 07ch, 0c6h, 060h, 038h, 06ch, 0c6h, 0c6h, 06ch, 038h
    db  00ch, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 0feh, 0feh, 000h
    db  000h, 000h, 000h, 000h, 018h, 03ch, 07eh, 018h, 018h, 018h, 07eh, 03ch, 018h, 07eh, 000h, 000h
    db  000h, 000h, 018h, 03ch, 07eh, 018h, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 018h, 018h, 018h, 018h, 07eh, 03ch, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 00ch, 0feh, 00ch, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 030h, 060h
    db  0feh, 060h, 030h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0c0h, 0c0h, 0c0h
    db  0feh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 028h, 06ch, 0feh, 06ch, 028h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 010h, 038h, 038h, 07ch, 07ch, 0feh, 0feh, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0feh, 0feh, 07ch, 07ch, 038h, 038h, 010h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 03ch, 03ch, 03ch, 018h, 018h, 000h, 018h, 018h, 000h, 000h, 000h, 000h, 066h, 066h, 066h
    db  024h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 06ch, 06ch, 0feh, 06ch
    db  06ch, 06ch, 0feh, 06ch, 06ch, 000h, 000h, 000h, 018h, 018h, 07ch, 0c6h, 0c2h, 0c0h, 07ch, 006h
    db  086h, 0c6h, 07ch, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 0c2h, 0c6h, 00ch, 018h, 030h, 066h
    db  0c6h, 000h, 000h, 000h, 000h, 000h, 038h, 06ch, 06ch, 038h, 076h, 0dch, 0cch, 0cch, 076h, 000h
    db  000h, 000h, 000h, 030h, 030h, 030h, 060h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 00ch, 018h, 030h, 030h, 030h, 030h, 030h, 018h, 00ch, 000h, 000h, 000h, 000h, 000h
    db  030h, 018h, 00ch, 00ch, 00ch, 00ch, 00ch, 018h, 030h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  066h, 03ch, 0ffh, 03ch, 066h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h
    db  07eh, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 018h, 030h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 000h
    db  000h, 000h, 000h, 000h, 002h, 006h, 00ch, 018h, 030h, 060h, 0c0h, 080h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0ceh, 0deh, 0f6h, 0e6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h
    db  018h, 038h, 078h, 018h, 018h, 018h, 018h, 018h, 07eh, 000h, 000h, 000h, 000h, 000h, 07ch, 0c6h
    db  006h, 00ch, 018h, 030h, 060h, 0c6h, 0feh, 000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 006h, 006h
    db  03ch, 006h, 006h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 00ch, 01ch, 03ch, 06ch, 0cch, 0feh
    db  00ch, 00ch, 01eh, 000h, 000h, 000h, 000h, 000h, 0feh, 0c0h, 0c0h, 0c0h, 0fch, 006h, 006h, 0c6h
    db  07ch, 000h, 000h, 000h, 000h, 000h, 038h, 060h, 0c0h, 0c0h, 0fch, 0c6h, 0c6h, 0c6h, 07ch, 000h
    db  000h, 000h, 000h, 000h, 0feh, 0c6h, 006h, 00ch, 018h, 030h, 030h, 030h, 030h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 07ch, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h
    db  07ch, 0c6h, 0c6h, 0c6h, 07eh, 006h, 006h, 00ch, 078h, 000h, 000h, 000h, 000h, 000h, 000h, 018h
    db  018h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 000h
    db  000h, 000h, 018h, 018h, 030h, 000h, 000h, 000h, 000h, 000h, 006h, 00ch, 018h, 030h, 060h, 030h
    db  018h, 00ch, 006h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07eh, 000h, 000h, 07eh, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 060h, 030h, 018h, 00ch, 006h, 00ch, 018h, 030h, 060h, 000h
    db  000h, 000h, 000h, 000h, 07ch, 0c6h, 0c6h, 00ch, 018h, 018h, 000h, 018h, 018h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 0deh, 0deh, 0deh, 0dch, 0c0h, 07ch, 000h, 000h, 000h, 000h, 000h
    db  010h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h, 000h, 0fch, 066h
    db  066h, 066h, 07ch, 066h, 066h, 066h, 0fch, 000h, 000h, 000h, 000h, 000h, 03ch, 066h, 0c2h, 0c0h
    db  0c0h, 0c0h, 0c2h, 066h, 03ch, 000h, 000h, 000h, 000h, 000h, 0f8h, 06ch, 066h, 066h, 066h, 066h
    db  066h, 06ch, 0f8h, 000h, 000h, 000h, 000h, 000h, 0feh, 066h, 062h, 068h, 078h, 068h, 062h, 066h
    db  0feh, 000h, 000h, 000h, 000h, 000h, 0feh, 066h, 062h, 068h, 078h, 068h, 060h, 060h, 0f0h, 000h
    db  000h, 000h, 000h, 000h, 03ch, 066h, 0c2h, 0c0h, 0c0h, 0deh, 0c6h, 066h, 03ah, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h, 000h
    db  03ch, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h, 000h, 01eh, 00ch
    db  00ch, 00ch, 00ch, 00ch, 0cch, 0cch, 078h, 000h, 000h, 000h, 000h, 000h, 0e6h, 066h, 06ch, 06ch
    db  078h, 06ch, 06ch, 066h, 0e6h, 000h, 000h, 000h, 000h, 000h, 0f0h, 060h, 060h, 060h, 060h, 060h
    db  062h, 066h, 0feh, 000h, 000h, 000h, 000h, 000h, 0c6h, 0eeh, 0feh, 0feh, 0d6h, 0c6h, 0c6h, 0c6h
    db  0c6h, 000h, 000h, 000h, 000h, 000h, 0c6h, 0e6h, 0f6h, 0feh, 0deh, 0ceh, 0c6h, 0c6h, 0c6h, 000h
    db  000h, 000h, 000h, 000h, 038h, 06ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 06ch, 038h, 000h, 000h, 000h
    db  000h, 000h, 0fch, 066h, 066h, 066h, 07ch, 060h, 060h, 060h, 0f0h, 000h, 000h, 000h, 000h, 000h
    db  07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0d6h, 0deh, 07ch, 00ch, 00eh, 000h, 000h, 000h, 000h, 0fch, 066h
    db  066h, 066h, 07ch, 06ch, 066h, 066h, 0e6h, 000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0c6h, 060h
    db  038h, 00ch, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 07eh, 07eh, 05ah, 018h, 018h, 018h
    db  018h, 018h, 03ch, 000h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h
    db  07ch, 000h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 06ch, 038h, 010h, 000h
    db  000h, 000h, 000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0d6h, 0d6h, 0feh, 07ch, 06ch, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 06ch, 038h, 038h, 038h, 06ch, 0c6h, 0c6h, 000h, 000h, 000h, 000h, 000h
    db  066h, 066h, 066h, 066h, 03ch, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h, 000h, 0feh, 0c6h
    db  08ch, 018h, 030h, 060h, 0c2h, 0c6h, 0feh, 000h, 000h, 000h, 000h, 000h, 03ch, 030h, 030h, 030h
    db  030h, 030h, 030h, 030h, 03ch, 000h, 000h, 000h, 000h, 000h, 080h, 0c0h, 0e0h, 070h, 038h, 01ch
    db  00eh, 006h, 002h, 000h, 000h, 000h, 000h, 000h, 03ch, 00ch, 00ch, 00ch, 00ch, 00ch, 00ch, 00ch
    db  03ch, 000h, 000h, 000h, 010h, 038h, 06ch, 0c6h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh, 000h
    db  030h, 030h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 000h, 0e0h, 060h
    db  060h, 078h, 06ch, 066h, 066h, 066h, 07ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07ch
    db  0c6h, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 01ch, 00ch, 00ch, 03ch, 06ch, 0cch
    db  0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c6h
    db  07ch, 000h, 000h, 000h, 000h, 000h, 038h, 06ch, 064h, 060h, 0f0h, 060h, 060h, 060h, 0f0h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 076h, 0cch, 0cch, 0cch, 07ch, 00ch, 0cch, 078h, 000h
    db  000h, 000h, 0e0h, 060h, 060h, 06ch, 076h, 066h, 066h, 066h, 0e6h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 000h, 038h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h, 000h, 006h, 006h
    db  000h, 00eh, 006h, 006h, 006h, 006h, 066h, 066h, 03ch, 000h, 000h, 000h, 0e0h, 060h, 060h, 066h
    db  06ch, 078h, 06ch, 066h, 0e6h, 000h, 000h, 000h, 000h, 000h, 038h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 03ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ech, 0feh, 0d6h, 0d6h, 0d6h
    db  0c6h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0dch, 066h, 066h, 066h, 066h, 066h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0dch, 066h, 066h, 066h, 07ch, 060h, 060h, 0f0h, 000h, 000h, 000h
    db  000h, 000h, 000h, 076h, 0cch, 0cch, 0cch, 07ch, 00ch, 00ch, 01eh, 000h, 000h, 000h, 000h, 000h
    db  000h, 0dch, 076h, 066h, 060h, 060h, 0f0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07ch
    db  0c6h, 070h, 01ch, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 010h, 030h, 030h, 0fch, 030h, 030h
    db  030h, 036h, 01ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch
    db  076h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 066h, 066h, 066h, 066h, 03ch, 018h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 0d6h, 0d6h, 0feh, 06ch, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0c6h, 06ch, 038h, 038h, 06ch, 0c6h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 07eh, 006h, 00ch, 0f8h, 000h, 000h, 000h, 000h, 000h
    db  000h, 0feh, 0cch, 018h, 030h, 066h, 0feh, 000h, 000h, 000h, 000h, 000h, 00eh, 018h, 018h, 018h
    db  070h, 018h, 018h, 018h, 00eh, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 018h, 018h, 000h, 018h
    db  018h, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 070h, 018h, 018h, 018h, 00eh, 018h, 018h, 018h
    db  070h, 000h, 000h, 000h, 000h, 000h, 076h, 0dch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 010h, 038h, 06ch, 0c6h, 0c6h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 066h, 0c2h, 0c0h, 0c0h, 0c2h, 066h, 03ch, 00ch, 006h, 07ch, 000h, 000h, 000h
    db  0cch, 0cch, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 00ch, 018h, 030h
    db  000h, 07ch, 0c6h, 0feh, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 010h, 038h, 06ch, 000h, 078h
    db  00ch, 07ch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 000h, 0cch, 0cch, 000h, 078h, 00ch, 07ch
    db  0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 060h, 030h, 018h, 000h, 078h, 00ch, 07ch, 0cch, 0cch
    db  076h, 000h, 000h, 000h, 000h, 038h, 06ch, 038h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 076h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 03ch, 066h, 060h, 066h, 03ch, 00ch, 006h, 03ch, 000h, 000h
    db  000h, 010h, 038h, 06ch, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h
    db  0cch, 0cch, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 060h, 030h, 018h
    db  000h, 07ch, 0c6h, 0feh, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 066h, 066h, 000h, 038h
    db  018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h, 018h, 03ch, 066h, 000h, 038h, 018h, 018h
    db  018h, 018h, 03ch, 000h, 000h, 000h, 000h, 060h, 030h, 018h, 000h, 038h, 018h, 018h, 018h, 018h
    db  03ch, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 010h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 000h
    db  000h, 000h, 038h, 06ch, 038h, 000h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 000h, 000h, 000h
    db  018h, 030h, 060h, 000h, 0feh, 066h, 060h, 07ch, 060h, 066h, 0feh, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0cch, 076h, 036h, 07eh, 0d8h, 0d8h, 06eh, 000h, 000h, 000h, 000h, 000h, 03eh, 06ch
    db  0cch, 0cch, 0feh, 0cch, 0cch, 0cch, 0ceh, 000h, 000h, 000h, 000h, 010h, 038h, 06ch, 000h, 07ch
    db  0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 000h, 07ch, 0c6h, 0c6h
    db  0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 060h, 030h, 018h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h
    db  07ch, 000h, 000h, 000h, 000h, 030h, 078h, 0cch, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h
    db  000h, 000h, 000h, 060h, 030h, 018h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 07eh, 006h, 00ch, 078h, 000h, 000h, 0c6h
    db  0c6h, 038h, 06ch, 0c6h, 0c6h, 0c6h, 0c6h, 06ch, 038h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 000h
    db  0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 018h, 018h, 03ch, 066h, 060h
    db  060h, 066h, 03ch, 018h, 018h, 000h, 000h, 000h, 000h, 038h, 06ch, 064h, 060h, 0f0h, 060h, 060h
    db  060h, 0e6h, 0fch, 000h, 000h, 000h, 000h, 000h, 066h, 066h, 03ch, 018h, 07eh, 018h, 07eh, 018h
    db  018h, 000h, 000h, 000h, 000h, 0f8h, 0cch, 0cch, 0f8h, 0c4h, 0cch, 0deh, 0cch, 0cch, 0c6h, 000h
    db  000h, 000h, 000h, 00eh, 01bh, 018h, 018h, 018h, 07eh, 018h, 018h, 018h, 018h, 0d8h, 070h, 000h
    db  000h, 018h, 030h, 060h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 00ch
    db  018h, 030h, 000h, 038h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h, 018h, 030h, 060h
    db  000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 018h, 030h, 060h, 000h, 0cch
    db  0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h, 000h, 076h, 0dch, 000h, 0dch, 066h, 066h
    db  066h, 066h, 066h, 000h, 000h, 000h, 076h, 0dch, 000h, 0c6h, 0e6h, 0f6h, 0feh, 0deh, 0ceh, 0c6h
    db  0c6h, 000h, 000h, 000h, 000h, 03ch, 06ch, 06ch, 03eh, 000h, 07eh, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 038h, 06ch, 06ch, 038h, 000h, 07ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 030h, 030h, 000h, 030h, 030h, 060h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 0feh, 0c0h, 0c0h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 006h, 006h, 006h, 000h, 000h, 000h, 000h, 000h, 0c0h, 0c0h, 0c6h, 0cch, 0d8h
    db  030h, 060h, 0dch, 086h, 00ch, 018h, 03eh, 000h, 000h, 0c0h, 0c0h, 0c6h, 0cch, 0d8h, 030h, 066h
    db  0ceh, 09eh, 03eh, 006h, 006h, 000h, 000h, 000h, 018h, 018h, 000h, 018h, 018h, 03ch, 03ch, 03ch
    db  018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 036h, 06ch, 0d8h, 06ch, 036h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 0d8h, 06ch, 036h, 06ch, 0d8h, 000h, 000h, 000h, 000h, 000h
    db  011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 055h, 0aah
    db  055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 0ddh, 077h, 0ddh, 077h
    db  0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0f8h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0f8h, 018h, 0f8h, 018h, 018h
    db  018h, 018h, 018h, 018h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 0f6h, 036h, 036h, 036h, 036h
    db  036h, 036h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 036h, 036h, 036h, 036h, 036h, 036h
    db  000h, 000h, 000h, 000h, 000h, 0f8h, 018h, 0f8h, 018h, 018h, 018h, 018h, 018h, 018h, 036h, 036h
    db  036h, 036h, 036h, 0f6h, 006h, 0f6h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 000h, 000h, 000h, 000h, 000h, 0feh
    db  006h, 0f6h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 0f6h, 006h, 0feh
    db  000h, 000h, 000h, 000h, 000h, 000h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 0feh, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 018h, 018h, 018h, 018h, 0f8h, 018h, 0f8h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0f8h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 01fh, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 01fh, 018h, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh
    db  000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0ffh, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 01fh, 018h, 01fh, 018h, 018h, 018h, 018h
    db  018h, 018h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 037h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 037h, 030h, 03fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 03fh, 030h, 037h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 0f7h, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh
    db  000h, 0f7h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 037h, 030h, 037h
    db  036h, 036h, 036h, 036h, 036h, 036h, 000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 0ffh, 000h, 000h
    db  000h, 000h, 000h, 000h, 036h, 036h, 036h, 036h, 036h, 0f7h, 000h, 0f7h, 036h, 036h, 036h, 036h
    db  036h, 036h, 018h, 018h, 018h, 018h, 018h, 0ffh, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 0ffh, 000h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 0ffh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 03fh, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 018h, 018h, 018h, 01fh, 018h, 01fh
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 018h, 01fh, 018h, 018h
    db  018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 03fh, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 0ffh, 036h, 036h, 036h, 036h, 036h, 036h
    db  018h, 018h, 018h, 018h, 018h, 0ffh, 018h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 01fh, 018h, 018h, 018h, 018h, 018h, 018h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h
    db  0f0h, 0f0h, 0f0h, 0f0h, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh
    db  00fh, 00fh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 076h, 0dch, 0d8h, 0d8h, 0dch, 076h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0fch, 0c6h, 0c6h, 0fch, 0c0h, 0c0h, 040h, 000h, 000h, 000h, 0feh, 0c6h
    db  0c6h, 0c0h, 0c0h, 0c0h, 0c0h, 0c0h, 0c0h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 06ch
    db  06ch, 06ch, 06ch, 06ch, 06ch, 000h, 000h, 000h, 000h, 000h, 0feh, 0c6h, 060h, 030h, 018h, 030h
    db  060h, 0c6h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07eh, 0d8h, 0d8h, 0d8h, 0d8h
    db  070h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 066h, 066h, 066h, 066h, 07ch, 060h, 060h, 0c0h
    db  000h, 000h, 000h, 000h, 000h, 000h, 076h, 0dch, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h
    db  000h, 000h, 07eh, 018h, 03ch, 066h, 066h, 066h, 03ch, 018h, 07eh, 000h, 000h, 000h, 000h, 000h
    db  038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 06ch, 038h, 000h, 000h, 000h, 000h, 000h, 038h, 06ch
    db  0c6h, 0c6h, 0c6h, 06ch, 06ch, 06ch, 0eeh, 000h, 000h, 000h, 000h, 000h, 01eh, 030h, 018h, 00ch
    db  03eh, 066h, 066h, 066h, 03ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07eh, 0dbh, 0dbh
    db  07eh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 003h, 006h, 07eh, 0dbh, 0dbh, 0f3h, 07eh, 060h
    db  0c0h, 000h, 000h, 000h, 000h, 000h, 01ch, 030h, 060h, 060h, 07ch, 060h, 060h, 030h, 01ch, 000h
    db  000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h
    db  000h, 000h, 000h, 0feh, 000h, 000h, 0feh, 000h, 000h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 018h, 018h, 07eh, 018h, 018h, 000h, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 030h, 018h
    db  00ch, 006h, 00ch, 018h, 030h, 000h, 07eh, 000h, 000h, 000h, 000h, 000h, 00ch, 018h, 030h, 060h
    db  030h, 018h, 00ch, 000h, 07eh, 000h, 000h, 000h, 000h, 000h, 00eh, 01bh, 01bh, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0d8h, 0d8h
    db  070h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 000h, 07eh, 000h, 018h, 018h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 076h, 0dch, 000h, 076h, 0dch, 000h, 000h, 000h, 000h, 000h
    db  000h, 038h, 06ch, 06ch, 038h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 00fh, 00ch, 00ch, 00ch, 00ch
    db  00ch, 0ech, 06ch, 03ch, 01ch, 000h, 000h, 000h, 000h, 0d8h, 06ch, 06ch, 06ch, 06ch, 06ch, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 070h, 0d8h, 030h, 060h, 0c8h, 0f8h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 07ch, 07ch, 07ch, 07ch, 07ch, 07ch, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc6b6a LB 0x135b -> off=0x0 cb=0000000000001000 uValue=00000000000c23ea 'vgafont16'
vgafont16:                                   ; 0xc6b6a LB 0x1000
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07eh, 081h, 0a5h, 081h, 081h, 0bdh, 099h, 081h, 081h, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 07eh, 0ffh, 0dbh, 0ffh, 0ffh, 0c3h, 0e7h, 0ffh, 0ffh, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 06ch, 0feh, 0feh, 0feh, 0feh, 07ch, 038h, 010h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 010h, 038h, 07ch, 0feh, 07ch, 038h, 010h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 018h, 03ch, 03ch, 0e7h, 0e7h, 0e7h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 018h, 03ch, 07eh, 0ffh, 0ffh, 07eh, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 018h, 03ch, 03ch, 018h, 000h, 000h, 000h, 000h, 000h, 000h
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0e7h, 0c3h, 0c3h, 0e7h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
    db  000h, 000h, 000h, 000h, 000h, 03ch, 066h, 042h, 042h, 066h, 03ch, 000h, 000h, 000h, 000h, 000h
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0c3h, 099h, 0bdh, 0bdh, 099h, 0c3h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
    db  000h, 000h, 01eh, 00eh, 01ah, 032h, 078h, 0cch, 0cch, 0cch, 0cch, 078h, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 066h, 066h, 066h, 066h, 03ch, 018h, 07eh, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 03fh, 033h, 03fh, 030h, 030h, 030h, 030h, 070h, 0f0h, 0e0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07fh, 063h, 07fh, 063h, 063h, 063h, 063h, 067h, 0e7h, 0e6h, 0c0h, 000h, 000h, 000h
    db  000h, 000h, 000h, 018h, 018h, 0dbh, 03ch, 0e7h, 03ch, 0dbh, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 080h, 0c0h, 0e0h, 0f0h, 0f8h, 0feh, 0f8h, 0f0h, 0e0h, 0c0h, 080h, 000h, 000h, 000h, 000h
    db  000h, 002h, 006h, 00eh, 01eh, 03eh, 0feh, 03eh, 01eh, 00eh, 006h, 002h, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 03ch, 07eh, 018h, 018h, 018h, 07eh, 03ch, 018h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 066h, 066h, 066h, 066h, 066h, 066h, 066h, 000h, 066h, 066h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07fh, 0dbh, 0dbh, 0dbh, 07bh, 01bh, 01bh, 01bh, 01bh, 01bh, 000h, 000h, 000h, 000h
    db  000h, 07ch, 0c6h, 060h, 038h, 06ch, 0c6h, 0c6h, 06ch, 038h, 00ch, 0c6h, 07ch, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 0feh, 0feh, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 03ch, 07eh, 018h, 018h, 018h, 07eh, 03ch, 018h, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 03ch, 07eh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 07eh, 03ch, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 018h, 00ch, 0feh, 00ch, 018h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 030h, 060h, 0feh, 060h, 030h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 0c0h, 0c0h, 0c0h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 028h, 06ch, 0feh, 06ch, 028h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 010h, 038h, 038h, 07ch, 07ch, 0feh, 0feh, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 0feh, 0feh, 07ch, 07ch, 038h, 038h, 010h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 03ch, 03ch, 03ch, 018h, 018h, 018h, 000h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 066h, 066h, 066h, 024h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 06ch, 06ch, 0feh, 06ch, 06ch, 06ch, 0feh, 06ch, 06ch, 000h, 000h, 000h, 000h
    db  018h, 018h, 07ch, 0c6h, 0c2h, 0c0h, 07ch, 006h, 006h, 086h, 0c6h, 07ch, 018h, 018h, 000h, 000h
    db  000h, 000h, 000h, 000h, 0c2h, 0c6h, 00ch, 018h, 030h, 060h, 0c6h, 086h, 000h, 000h, 000h, 000h
    db  000h, 000h, 038h, 06ch, 06ch, 038h, 076h, 0dch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 030h, 030h, 030h, 060h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 00ch, 018h, 030h, 030h, 030h, 030h, 030h, 030h, 018h, 00ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 030h, 018h, 00ch, 00ch, 00ch, 00ch, 00ch, 00ch, 018h, 030h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 066h, 03ch, 0ffh, 03ch, 066h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 018h, 018h, 07eh, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 018h, 030h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 002h, 006h, 00ch, 018h, 030h, 060h, 0c0h, 080h, 000h, 000h, 000h, 000h
    db  000h, 000h, 038h, 06ch, 0c6h, 0c6h, 0d6h, 0d6h, 0c6h, 0c6h, 06ch, 038h, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 038h, 078h, 018h, 018h, 018h, 018h, 018h, 018h, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 006h, 00ch, 018h, 030h, 060h, 0c0h, 0c6h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 006h, 006h, 03ch, 006h, 006h, 006h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 00ch, 01ch, 03ch, 06ch, 0cch, 0feh, 00ch, 00ch, 00ch, 01eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 0c0h, 0c0h, 0c0h, 0fch, 006h, 006h, 006h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 038h, 060h, 0c0h, 0c0h, 0fch, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 0c6h, 006h, 006h, 00ch, 018h, 030h, 030h, 030h, 030h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 07eh, 006h, 006h, 006h, 00ch, 078h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 018h, 018h, 030h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 006h, 00ch, 018h, 030h, 060h, 030h, 018h, 00ch, 006h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07eh, 000h, 000h, 07eh, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 060h, 030h, 018h, 00ch, 006h, 00ch, 018h, 030h, 060h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 00ch, 018h, 018h, 018h, 000h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 07ch, 0c6h, 0c6h, 0deh, 0deh, 0deh, 0dch, 0c0h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 010h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0fch, 066h, 066h, 066h, 07ch, 066h, 066h, 066h, 066h, 0fch, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 066h, 0c2h, 0c0h, 0c0h, 0c0h, 0c0h, 0c2h, 066h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0f8h, 06ch, 066h, 066h, 066h, 066h, 066h, 066h, 06ch, 0f8h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 066h, 062h, 068h, 078h, 068h, 060h, 062h, 066h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 066h, 062h, 068h, 078h, 068h, 060h, 060h, 060h, 0f0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 066h, 0c2h, 0c0h, 0c0h, 0deh, 0c6h, 0c6h, 066h, 03ah, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 01eh, 00ch, 00ch, 00ch, 00ch, 00ch, 0cch, 0cch, 0cch, 078h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0e6h, 066h, 066h, 06ch, 078h, 078h, 06ch, 066h, 066h, 0e6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0f0h, 060h, 060h, 060h, 060h, 060h, 060h, 062h, 066h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0eeh, 0feh, 0feh, 0d6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0e6h, 0f6h, 0feh, 0deh, 0ceh, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0fch, 066h, 066h, 066h, 07ch, 060h, 060h, 060h, 060h, 0f0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0d6h, 0deh, 07ch, 00ch, 00eh, 000h, 000h
    db  000h, 000h, 0fch, 066h, 066h, 066h, 07ch, 06ch, 066h, 066h, 066h, 0e6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 07ch, 0c6h, 0c6h, 060h, 038h, 00ch, 006h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 07eh, 07eh, 05ah, 018h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 06ch, 038h, 010h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0d6h, 0d6h, 0d6h, 0feh, 0eeh, 06ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 0c6h, 06ch, 07ch, 038h, 038h, 07ch, 06ch, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 066h, 066h, 066h, 066h, 03ch, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 0c6h, 086h, 00ch, 018h, 030h, 060h, 0c2h, 0c6h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 030h, 030h, 030h, 030h, 030h, 030h, 030h, 030h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 080h, 0c0h, 0e0h, 070h, 038h, 01ch, 00eh, 006h, 002h, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 00ch, 00ch, 00ch, 00ch, 00ch, 00ch, 00ch, 00ch, 03ch, 000h, 000h, 000h, 000h
    db  010h, 038h, 06ch, 0c6h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 000h
    db  030h, 030h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0e0h, 060h, 060h, 078h, 06ch, 066h, 066h, 066h, 066h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0c0h, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 01ch, 00ch, 00ch, 03ch, 06ch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 038h, 06ch, 064h, 060h, 0f0h, 060h, 060h, 060h, 060h, 0f0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 076h, 0cch, 0cch, 0cch, 0cch, 0cch, 07ch, 00ch, 0cch, 078h, 000h
    db  000h, 000h, 0e0h, 060h, 060h, 06ch, 076h, 066h, 066h, 066h, 066h, 0e6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 018h, 000h, 038h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 006h, 006h, 000h, 00eh, 006h, 006h, 006h, 006h, 006h, 006h, 066h, 066h, 03ch, 000h
    db  000h, 000h, 0e0h, 060h, 060h, 066h, 06ch, 078h, 078h, 06ch, 066h, 0e6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 038h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0ech, 0feh, 0d6h, 0d6h, 0d6h, 0d6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0dch, 066h, 066h, 066h, 066h, 066h, 066h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0dch, 066h, 066h, 066h, 066h, 066h, 07ch, 060h, 060h, 0f0h, 000h
    db  000h, 000h, 000h, 000h, 000h, 076h, 0cch, 0cch, 0cch, 0cch, 0cch, 07ch, 00ch, 00ch, 01eh, 000h
    db  000h, 000h, 000h, 000h, 000h, 0dch, 076h, 066h, 060h, 060h, 060h, 0f0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07ch, 0c6h, 060h, 038h, 00ch, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 010h, 030h, 030h, 0fch, 030h, 030h, 030h, 030h, 036h, 01ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 066h, 066h, 066h, 066h, 066h, 03ch, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 0d6h, 0d6h, 0d6h, 0feh, 06ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0c6h, 06ch, 038h, 038h, 038h, 06ch, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07eh, 006h, 00ch, 0f8h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0feh, 0cch, 018h, 030h, 060h, 0c6h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 00eh, 018h, 018h, 018h, 070h, 018h, 018h, 018h, 018h, 00eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 018h, 018h, 018h, 018h, 000h, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 070h, 018h, 018h, 018h, 00eh, 018h, 018h, 018h, 018h, 070h, 000h, 000h, 000h, 000h
    db  000h, 000h, 076h, 0dch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 010h, 038h, 06ch, 0c6h, 0c6h, 0c6h, 0feh, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 03ch, 066h, 0c2h, 0c0h, 0c0h, 0c0h, 0c2h, 066h, 03ch, 00ch, 006h, 07ch, 000h, 000h
    db  000h, 000h, 0cch, 000h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 00ch, 018h, 030h, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 010h, 038h, 06ch, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0cch, 000h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 060h, 030h, 018h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 038h, 06ch, 038h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 03ch, 066h, 060h, 060h, 066h, 03ch, 00ch, 006h, 03ch, 000h, 000h, 000h
    db  000h, 010h, 038h, 06ch, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 000h, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 060h, 030h, 018h, 000h, 07ch, 0c6h, 0feh, 0c0h, 0c0h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 066h, 000h, 000h, 038h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 018h, 03ch, 066h, 000h, 038h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 060h, 030h, 018h, 000h, 038h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 0c6h, 000h, 010h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  038h, 06ch, 038h, 000h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  018h, 030h, 060h, 000h, 0feh, 066h, 060h, 07ch, 060h, 060h, 066h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0cch, 076h, 036h, 07eh, 0d8h, 0d8h, 06eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 03eh, 06ch, 0cch, 0cch, 0feh, 0cch, 0cch, 0cch, 0cch, 0ceh, 000h, 000h, 000h, 000h
    db  000h, 010h, 038h, 06ch, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 060h, 030h, 018h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 030h, 078h, 0cch, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 060h, 030h, 018h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 0c6h, 000h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07eh, 006h, 00ch, 078h, 000h
    db  000h, 0c6h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 0c6h, 000h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 018h, 018h, 03ch, 066h, 060h, 060h, 060h, 066h, 03ch, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 038h, 06ch, 064h, 060h, 0f0h, 060h, 060h, 060h, 060h, 0e6h, 0fch, 000h, 000h, 000h, 000h
    db  000h, 000h, 066h, 066h, 03ch, 018h, 07eh, 018h, 07eh, 018h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 0f8h, 0cch, 0cch, 0f8h, 0c4h, 0cch, 0deh, 0cch, 0cch, 0cch, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 00eh, 01bh, 018h, 018h, 018h, 07eh, 018h, 018h, 018h, 018h, 018h, 0d8h, 070h, 000h, 000h
    db  000h, 018h, 030h, 060h, 000h, 078h, 00ch, 07ch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 00ch, 018h, 030h, 000h, 038h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 018h, 030h, 060h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 018h, 030h, 060h, 000h, 0cch, 0cch, 0cch, 0cch, 0cch, 0cch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 076h, 0dch, 000h, 0dch, 066h, 066h, 066h, 066h, 066h, 066h, 000h, 000h, 000h, 000h
    db  076h, 0dch, 000h, 0c6h, 0e6h, 0f6h, 0feh, 0deh, 0ceh, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 03ch, 06ch, 06ch, 03eh, 000h, 07eh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 038h, 06ch, 06ch, 038h, 000h, 07ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 030h, 030h, 000h, 030h, 030h, 060h, 0c0h, 0c6h, 0c6h, 07ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 0feh, 0c0h, 0c0h, 0c0h, 0c0h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 0feh, 006h, 006h, 006h, 006h, 000h, 000h, 000h, 000h, 000h
    db  000h, 0c0h, 0c0h, 0c2h, 0c6h, 0cch, 018h, 030h, 060h, 0dch, 086h, 00ch, 018h, 03eh, 000h, 000h
    db  000h, 0c0h, 0c0h, 0c2h, 0c6h, 0cch, 018h, 030h, 066h, 0ceh, 09eh, 03eh, 006h, 006h, 000h, 000h
    db  000h, 000h, 018h, 018h, 000h, 018h, 018h, 018h, 03ch, 03ch, 03ch, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 036h, 06ch, 0d8h, 06ch, 036h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0d8h, 06ch, 036h, 06ch, 0d8h, 000h, 000h, 000h, 000h, 000h, 000h
    db  011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h, 011h, 044h
    db  055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah, 055h, 0aah
    db  0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h, 0ddh, 077h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 0f8h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 0f8h, 018h, 0f8h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 0f6h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0feh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  000h, 000h, 000h, 000h, 000h, 0f8h, 018h, 0f8h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  036h, 036h, 036h, 036h, 036h, 0f6h, 006h, 0f6h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  000h, 000h, 000h, 000h, 000h, 0feh, 006h, 0f6h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 0f6h, 006h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 0feh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 018h, 018h, 018h, 0f8h, 018h, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0f8h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 01fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 01fh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 01fh, 018h, 01fh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 037h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 037h, 030h, 03fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 03fh, 030h, 037h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 0f7h, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 0f7h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 037h, 030h, 037h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  036h, 036h, 036h, 036h, 036h, 0f7h, 000h, 0f7h, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  018h, 018h, 018h, 018h, 018h, 0ffh, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 0ffh, 000h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 03fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  018h, 018h, 018h, 018h, 018h, 01fh, 018h, 01fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 01fh, 018h, 01fh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 03fh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  036h, 036h, 036h, 036h, 036h, 036h, 036h, 0ffh, 036h, 036h, 036h, 036h, 036h, 036h, 036h, 036h
    db  018h, 018h, 018h, 018h, 018h, 0ffh, 018h, 0ffh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 01fh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
    db  0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f0h
    db  00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh, 00fh
    db  0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 076h, 0dch, 0d8h, 0d8h, 0d8h, 0dch, 076h, 000h, 000h, 000h, 000h
    db  000h, 000h, 078h, 0cch, 0cch, 0cch, 0d8h, 0cch, 0c6h, 0c6h, 0c6h, 0cch, 000h, 000h, 000h, 000h
    db  000h, 000h, 0feh, 0c6h, 0c6h, 0c0h, 0c0h, 0c0h, 0c0h, 0c0h, 0c0h, 0c0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 0feh, 06ch, 06ch, 06ch, 06ch, 06ch, 06ch, 06ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 0feh, 0c6h, 060h, 030h, 018h, 030h, 060h, 0c6h, 0feh, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07eh, 0d8h, 0d8h, 0d8h, 0d8h, 0d8h, 070h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 066h, 066h, 066h, 066h, 066h, 07ch, 060h, 060h, 0c0h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 076h, 0dch, 018h, 018h, 018h, 018h, 018h, 018h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 07eh, 018h, 03ch, 066h, 066h, 066h, 03ch, 018h, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 038h, 06ch, 0c6h, 0c6h, 0feh, 0c6h, 0c6h, 06ch, 038h, 000h, 000h, 000h, 000h
    db  000h, 000h, 038h, 06ch, 0c6h, 0c6h, 0c6h, 06ch, 06ch, 06ch, 06ch, 0eeh, 000h, 000h, 000h, 000h
    db  000h, 000h, 01eh, 030h, 018h, 00ch, 03eh, 066h, 066h, 066h, 066h, 03ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 07eh, 0dbh, 0dbh, 0dbh, 07eh, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 003h, 006h, 07eh, 0dbh, 0dbh, 0f3h, 07eh, 060h, 0c0h, 000h, 000h, 000h, 000h
    db  000h, 000h, 01ch, 030h, 060h, 060h, 07ch, 060h, 060h, 060h, 030h, 01ch, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 07ch, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 0c6h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 0feh, 000h, 000h, 0feh, 000h, 000h, 0feh, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 018h, 07eh, 018h, 018h, 000h, 000h, 0ffh, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 030h, 018h, 00ch, 006h, 00ch, 018h, 030h, 000h, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 00ch, 018h, 030h, 060h, 030h, 018h, 00ch, 000h, 07eh, 000h, 000h, 000h, 000h
    db  000h, 000h, 00eh, 01bh, 01bh, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h
    db  018h, 018h, 018h, 018h, 018h, 018h, 018h, 018h, 0d8h, 0d8h, 0d8h, 070h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 018h, 018h, 000h, 07eh, 000h, 018h, 018h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 076h, 0dch, 000h, 076h, 0dch, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 038h, 06ch, 06ch, 038h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 018h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 00fh, 00ch, 00ch, 00ch, 00ch, 00ch, 0ech, 06ch, 06ch, 03ch, 01ch, 000h, 000h, 000h, 000h
    db  000h, 0d8h, 06ch, 06ch, 06ch, 06ch, 06ch, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 070h, 0d8h, 030h, 060h, 0c8h, 0f8h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 07ch, 07ch, 07ch, 07ch, 07ch, 07ch, 07ch, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc7b6a LB 0x35b -> off=0x0 cb=000000000000012d uValue=00000000000c33ea 'vgafont14alt'
vgafont14alt:                                ; 0xc7b6a LB 0x12d
    db  01dh, 000h, 000h, 000h, 000h, 024h, 066h, 0ffh, 066h, 024h, 000h, 000h, 000h, 000h, 000h, 022h
    db  000h, 063h, 063h, 063h, 022h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 02bh, 000h
    db  000h, 000h, 018h, 018h, 018h, 0ffh, 018h, 018h, 018h, 000h, 000h, 000h, 000h, 02dh, 000h, 000h
    db  000h, 000h, 000h, 000h, 0ffh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 04dh, 000h, 000h, 0c3h
    db  0e7h, 0ffh, 0dbh, 0c3h, 0c3h, 0c3h, 0c3h, 0c3h, 000h, 000h, 000h, 054h, 000h, 000h, 0ffh, 0dbh
    db  099h, 018h, 018h, 018h, 018h, 018h, 03ch, 000h, 000h, 000h, 056h, 000h, 000h, 0c3h, 0c3h, 0c3h
    db  0c3h, 0c3h, 0c3h, 066h, 03ch, 018h, 000h, 000h, 000h, 057h, 000h, 000h, 0c3h, 0c3h, 0c3h, 0c3h
    db  0dbh, 0dbh, 0ffh, 066h, 066h, 000h, 000h, 000h, 058h, 000h, 000h, 0c3h, 0c3h, 066h, 03ch, 018h
    db  03ch, 066h, 0c3h, 0c3h, 000h, 000h, 000h, 059h, 000h, 000h, 0c3h, 0c3h, 0c3h, 066h, 03ch, 018h
    db  018h, 018h, 03ch, 000h, 000h, 000h, 05ah, 000h, 000h, 0ffh, 0c3h, 086h, 00ch, 018h, 030h, 061h
    db  0c3h, 0ffh, 000h, 000h, 000h, 06dh, 000h, 000h, 000h, 000h, 000h, 0e6h, 0ffh, 0dbh, 0dbh, 0dbh
    db  0dbh, 000h, 000h, 000h, 076h, 000h, 000h, 000h, 000h, 000h, 0c3h, 0c3h, 0c3h, 066h, 03ch, 018h
    db  000h, 000h, 000h, 077h, 000h, 000h, 000h, 000h, 000h, 0c3h, 0c3h, 0dbh, 0dbh, 0ffh, 066h, 000h
    db  000h, 000h, 091h, 000h, 000h, 000h, 000h, 06eh, 03bh, 01bh, 07eh, 0d8h, 0dch, 077h, 000h, 000h
    db  000h, 09bh, 000h, 018h, 018h, 07eh, 0c3h, 0c0h, 0c0h, 0c3h, 07eh, 018h, 018h, 000h, 000h, 000h
    db  09dh, 000h, 000h, 0c3h, 066h, 03ch, 018h, 0ffh, 018h, 0ffh, 018h, 018h, 000h, 000h, 000h, 09eh
    db  000h, 0fch, 066h, 066h, 07ch, 062h, 066h, 06fh, 066h, 066h, 0f3h, 000h, 000h, 000h, 0f1h, 000h
    db  000h, 018h, 018h, 018h, 0ffh, 018h, 018h, 018h, 000h, 0ffh, 000h, 000h, 000h, 0f6h, 000h, 000h
    db  018h, 018h, 000h, 000h, 0ffh, 000h, 000h, 018h, 018h, 000h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc7c97 LB 0x22e -> off=0x0 cb=0000000000000144 uValue=00000000000c3517 'vgafont16alt'
vgafont16alt:                                ; 0xc7c97 LB 0x144
    db  01dh, 000h, 000h, 000h, 000h, 000h, 024h, 066h, 0ffh, 066h, 024h, 000h, 000h, 000h, 000h, 000h
    db  000h, 030h, 000h, 000h, 03ch, 066h, 0c3h, 0c3h, 0dbh, 0dbh, 0c3h, 0c3h, 066h, 03ch, 000h, 000h
    db  000h, 000h, 04dh, 000h, 000h, 0c3h, 0e7h, 0ffh, 0ffh, 0dbh, 0c3h, 0c3h, 0c3h, 0c3h, 0c3h, 000h
    db  000h, 000h, 000h, 054h, 000h, 000h, 0ffh, 0dbh, 099h, 018h, 018h, 018h, 018h, 018h, 018h, 03ch
    db  000h, 000h, 000h, 000h, 056h, 000h, 000h, 0c3h, 0c3h, 0c3h, 0c3h, 0c3h, 0c3h, 0c3h, 066h, 03ch
    db  018h, 000h, 000h, 000h, 000h, 057h, 000h, 000h, 0c3h, 0c3h, 0c3h, 0c3h, 0c3h, 0dbh, 0dbh, 0ffh
    db  066h, 066h, 000h, 000h, 000h, 000h, 058h, 000h, 000h, 0c3h, 0c3h, 066h, 03ch, 018h, 018h, 03ch
    db  066h, 0c3h, 0c3h, 000h, 000h, 000h, 000h, 059h, 000h, 000h, 0c3h, 0c3h, 0c3h, 066h, 03ch, 018h
    db  018h, 018h, 018h, 03ch, 000h, 000h, 000h, 000h, 05ah, 000h, 000h, 0ffh, 0c3h, 086h, 00ch, 018h
    db  030h, 060h, 0c1h, 0c3h, 0ffh, 000h, 000h, 000h, 000h, 06dh, 000h, 000h, 000h, 000h, 000h, 0e6h
    db  0ffh, 0dbh, 0dbh, 0dbh, 0dbh, 0dbh, 000h, 000h, 000h, 000h, 076h, 000h, 000h, 000h, 000h, 000h
    db  0c3h, 0c3h, 0c3h, 0c3h, 066h, 03ch, 018h, 000h, 000h, 000h, 000h, 077h, 000h, 000h, 000h, 000h
    db  000h, 0c3h, 0c3h, 0c3h, 0dbh, 0dbh, 0ffh, 066h, 000h, 000h, 000h, 000h, 078h, 000h, 000h, 000h
    db  000h, 000h, 0c3h, 066h, 03ch, 018h, 03ch, 066h, 0c3h, 000h, 000h, 000h, 000h, 091h, 000h, 000h
    db  000h, 000h, 000h, 06eh, 03bh, 01bh, 07eh, 0d8h, 0dch, 077h, 000h, 000h, 000h, 000h, 09bh, 000h
    db  018h, 018h, 07eh, 0c3h, 0c0h, 0c0h, 0c0h, 0c3h, 07eh, 018h, 018h, 000h, 000h, 000h, 000h, 09dh
    db  000h, 000h, 0c3h, 066h, 03ch, 018h, 0ffh, 018h, 0ffh, 018h, 018h, 018h, 000h, 000h, 000h, 000h
    db  09eh, 000h, 0fch, 066h, 066h, 07ch, 062h, 066h, 06fh, 066h, 066h, 066h, 0f3h, 000h, 000h, 000h
    db  000h, 0abh, 000h, 0c0h, 0c0h, 0c2h, 0c6h, 0cch, 018h, 030h, 060h, 0ceh, 09bh, 006h, 00ch, 01fh
    db  000h, 000h, 0ach, 000h, 0c0h, 0c0h, 0c2h, 0c6h, 0cch, 018h, 030h, 066h, 0ceh, 096h, 03eh, 006h
    db  006h, 000h, 000h, 000h
  ; disGetNextSymbol 0xc7ddb LB 0xea -> off=0x0 cb=0000000000000008 uValue=00000000000c365b '_cga_msr'
_cga_msr:                                    ; 0xc7ddb LB 0x8
    db  02ch, 028h, 02dh, 029h, 02ah, 02eh, 01eh, 029h
  ; disGetNextSymbol 0xc7de3 LB 0xe2 -> off=0x0 cb=0000000000000008 uValue=00000000000c3663 'line_to_vpti_200'
line_to_vpti_200:                            ; 0xc7de3 LB 0x8
    db  000h, 001h, 002h, 003h, 0ffh, 0ffh, 0ffh, 007h
  ; disGetNextSymbol 0xc7deb LB 0xda -> off=0x0 cb=0000000000000008 uValue=00000000000c366b 'line_to_vpti_350'
line_to_vpti_350:                            ; 0xc7deb LB 0x8
    db  013h, 014h, 015h, 016h, 0ffh, 0ffh, 0ffh, 007h
  ; disGetNextSymbol 0xc7df3 LB 0xd2 -> off=0x0 cb=0000000000000008 uValue=00000000000c3673 'line_to_vpti_400'
line_to_vpti_400:                            ; 0xc7df3 LB 0x8
    db  017h, 017h, 018h, 018h, 0ffh, 0ffh, 0ffh, 019h
  ; disGetNextSymbol 0xc7dfb LB 0xca -> off=0x0 cb=0000000000000005 uValue=00000000000c367b 'row_tbl'
row_tbl:                                     ; 0xc7dfb LB 0x5
    db  000h, 00eh, 019h, 02bh, 000h
  ; disGetNextSymbol 0xc7e00 LB 0xc5 -> off=0x0 cb=0000000000000015 uValue=00000000000c3680 '_vbebios_copyright'
_vbebios_copyright:                          ; 0xc7e00 LB 0x15
    db  'VirtualBox VESA BIOS', 000h
  ; disGetNextSymbol 0xc7e15 LB 0xb0 -> off=0x0 cb=000000000000001d uValue=00000000000c3695 '_vbebios_vendor_name'
_vbebios_vendor_name:                        ; 0xc7e15 LB 0x1d
    db  'Oracle and/or its affiliates', 000h
  ; disGetNextSymbol 0xc7e32 LB 0x93 -> off=0x0 cb=000000000000001e uValue=00000000000c36b2 '_vbebios_product_name'
_vbebios_product_name:                       ; 0xc7e32 LB 0x1e
    db  'Oracle VirtualBox VBE Adapter', 000h
  ; disGetNextSymbol 0xc7e50 LB 0x75 -> off=0x0 cb=0000000000000021 uValue=00000000000c36d0 '_vbebios_product_revision'
_vbebios_product_revision:                   ; 0xc7e50 LB 0x21
    db  'Oracle VirtualBox Version 7.2.97', 000h
  ; disGetNextSymbol 0xc7e71 LB 0x54 -> off=0x0 cb=000000000000002b uValue=00000000000c36f1 '_vbebios_info_string'
_vbebios_info_string:                        ; 0xc7e71 LB 0x2b
    db  'VirtualBox VBE Display Adapter enabled', 00dh, 00ah, 00dh, 00ah, 000h
  ; disGetNextSymbol 0xc7e9c LB 0x29 -> off=0x0 cb=0000000000000029 uValue=00000000000c371c '_no_vbebios_info_string'
_no_vbebios_info_string:                     ; 0xc7e9c LB 0x29
    db  'No VirtualBox VBE support available!', 00dh, 00ah, 00dh, 00ah, 000h

  ; Padding 0x1 bytes at 0xc7ec5
    db  001h

section CONST progbits vstart=0x7ec6 align=1 ; size=0x0 class=DATA group=DGROUP

section CONST2 progbits vstart=0x7ec6 align=1 ; size=0x0 class=DATA group=DGROUP

  ; Padding 0x13a bytes at 0xc7ec6
    db  000h, 000h, 000h, 000h, 001h, 000h, 000h, 000h, 000h, 000h, 000h, 02fh, 068h, 06fh, 06dh, 065h
    db  02fh, 06bh, 06ch, 061h, 075h, 073h, 02fh, 070h, 072h, 06fh, 06ah, 065h, 063h, 074h, 073h, 02fh
    db  076h, 062h, 06fh, 078h, 02fh, 074h, 072h, 075h, 06eh, 06bh, 02fh, 06fh, 075h, 074h, 02fh, 06ch
    db  069h, 06eh, 075h, 078h, 02eh, 061h, 06dh, 064h, 036h, 034h, 02fh, 072h, 065h, 06ch, 065h, 061h
    db  073h, 065h, 02fh, 06fh, 062h, 06ah, 02fh, 056h, 042h, 06fh, 078h, 056h, 067h, 061h, 042h, 069h
    db  06fh, 073h, 033h, 038h, 036h, 02fh, 056h, 042h, 06fh, 078h, 056h, 067h, 061h, 042h, 069h, 06fh
    db  073h, 033h, 038h, 036h, 02eh, 073h, 079h, 06dh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 0ceh
