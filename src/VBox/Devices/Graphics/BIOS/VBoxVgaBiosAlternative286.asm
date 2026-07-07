; $Id: VBoxVgaBiosAlternative286.asm 114642 2026-07-07 18:33:04Z klaus.espenlaub@oracle.com $
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





section VGAROM progbits vstart=0x0 align=1 ; size=0x903 class=CODE group=AUTO
  ; disGetNextSymbol 0xc0000 LB 0x903 -> off=0x28 cb=0000000000000548 uValue=00000000000c0028 'vgabios_int10_handler'
    db  055h, 0aah, 040h, 0ebh, 01dh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 049h, 042h
    db  04dh, 000h, 00eh, 01fh, 0fch, 0e9h, 03dh, 00ah
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
    call 008efh                               ; e8 10 08                    ; 0xc00dc vgarom.asm:197
    jmp short 000edh                          ; eb 0c                       ; 0xc00df vgarom.asm:198
    push ES                                   ; 06                          ; 0xc00e1 vgarom.asm:202
    push DS                                   ; 1e                          ; 0xc00e2 vgarom.asm:203
    pushaw                                    ; 60                          ; 0xc00e3 vgarom.asm:107
    push CS                                   ; 0e                          ; 0xc00e4 vgarom.asm:207
    pop DS                                    ; 1f                          ; 0xc00e5 vgarom.asm:208
    cld                                       ; fc                          ; 0xc00e6 vgarom.asm:209
    call 0385eh                               ; e8 74 37                    ; 0xc00e7 vgarom.asm:210
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
  ; disGetNextSymbol 0xc0570 LB 0x393 -> off=0x0 cb=0000000000000007 uValue=00000000000c0570 'do_out_dx_ax'
do_out_dx_ax:                                ; 0xc0570 LB 0x7
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0570 vberom.asm:69
    out DX, AL                                ; ee                          ; 0xc0572 vberom.asm:70
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0573 vberom.asm:71
    out DX, AL                                ; ee                          ; 0xc0575 vberom.asm:72
    retn                                      ; c3                          ; 0xc0576 vberom.asm:73
  ; disGetNextSymbol 0xc0577 LB 0x38c -> off=0x0 cb=0000000000000040 uValue=00000000000c0577 'do_in_ax_dx'
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
  ; disGetNextSymbol 0xc05b7 LB 0x34c -> off=0x0 cb=0000000000000026 uValue=00000000000c05b7 '_dispi_get_max_bpp'
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
  ; disGetNextSymbol 0xc05dd LB 0x326 -> off=0x0 cb=0000000000000026 uValue=00000000000c05dd 'dispi_set_enable_'
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
  ; disGetNextSymbol 0xc0603 LB 0x300 -> off=0x0 cb=0000000000000026 uValue=00000000000c0603 'dispi_set_bank_'
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
  ; disGetNextSymbol 0xc0629 LB 0x2da -> off=0x0 cb=00000000000000a9 uValue=00000000000c0629 '_dispi_set_bank_farcall'
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
  ; disGetNextSymbol 0xc06d2 LB 0x231 -> off=0x0 cb=00000000000000f6 uValue=00000000000c06d2 '_vga_compat_setup'
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
  ; disGetNextSymbol 0xc07c8 LB 0x13b -> off=0x0 cb=0000000000000013 uValue=00000000000c07c8 '_vbe_has_vbe_display'
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
  ; disGetNextSymbol 0xc07db LB 0x128 -> off=0x0 cb=0000000000000025 uValue=00000000000c07db 'vbe_biosfn_return_current_mode'
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
  ; disGetNextSymbol 0xc0800 LB 0x103 -> off=0x0 cb=000000000000002d uValue=00000000000c0800 'vbe_biosfn_display_window_control'
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
  ; disGetNextSymbol 0xc082d LB 0xd6 -> off=0x0 cb=0000000000000034 uValue=00000000000c082d 'vbe_biosfn_set_get_display_start'
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
  ; disGetNextSymbol 0xc0861 LB 0xa2 -> off=0x0 cb=0000000000000037 uValue=00000000000c0861 'vbe_biosfn_set_get_dac_palette_format'
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
  ; disGetNextSymbol 0xc0898 LB 0x6b -> off=0x0 cb=0000000000000057 uValue=00000000000c0898 'vbe_biosfn_set_get_palette_data'
vbe_biosfn_set_get_palette_data:             ; 0xc0898 LB 0x57
    test bl, bl                               ; 84 db                       ; 0xc0898 vberom.asm:691
    je short 008abh                           ; 74 0f                       ; 0xc089a vberom.asm:692
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc089c vberom.asm:693
    je short 008cbh                           ; 74 2a                       ; 0xc089f vberom.asm:694
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc08a1 vberom.asm:695
    jbe short 008ebh                          ; 76 45                       ; 0xc08a4 vberom.asm:696
    cmp bl, 080h                              ; 80 fb 80                    ; 0xc08a6 vberom.asm:697
    jne short 008e7h                          ; 75 3c                       ; 0xc08a9 vberom.asm:698
    pushaw                                    ; 60                          ; 0xc08ab vberom.asm:143
    push DS                                   ; 1e                          ; 0xc08ac vberom.asm:704
    push ES                                   ; 06                          ; 0xc08ad vberom.asm:705
    pop DS                                    ; 1f                          ; 0xc08ae vberom.asm:706
    db  08ah, 0c2h
    ; mov al, dl                                ; 8a c2                     ; 0xc08af vberom.asm:707
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc08b1 vberom.asm:708
    out DX, AL                                ; ee                          ; 0xc08b4 vberom.asm:709
    inc dx                                    ; 42                          ; 0xc08b5 vberom.asm:710
    db  08bh, 0f7h
    ; mov si, di                                ; 8b f7                     ; 0xc08b6 vberom.asm:711
    lodsw                                     ; ad                          ; 0xc08b8 vberom.asm:722
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc08b9 vberom.asm:723
    lodsw                                     ; ad                          ; 0xc08bb vberom.asm:724
    out DX, AL                                ; ee                          ; 0xc08bc vberom.asm:725
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc08bd vberom.asm:726
    out DX, AL                                ; ee                          ; 0xc08bf vberom.asm:727
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc08c0 vberom.asm:728
    out DX, AL                                ; ee                          ; 0xc08c2 vberom.asm:729
    loop 008b8h                               ; e2 f3                       ; 0xc08c3 vberom.asm:731
    pop DS                                    ; 1f                          ; 0xc08c5 vberom.asm:732
    popaw                                     ; 61                          ; 0xc08c6 vberom.asm:162
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc08c7 vberom.asm:735
    retn                                      ; c3                          ; 0xc08ca vberom.asm:736
    pushaw                                    ; 60                          ; 0xc08cb vberom.asm:143
    db  08ah, 0c2h
    ; mov al, dl                                ; 8a c2                     ; 0xc08cc vberom.asm:740
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc08ce vberom.asm:741
    out DX, AL                                ; ee                          ; 0xc08d1 vberom.asm:742
    add dl, 002h                              ; 80 c2 02                    ; 0xc08d2 vberom.asm:743
    db  033h, 0dbh
    ; xor bx, bx                                ; 33 db                     ; 0xc08d5 vberom.asm:754
    in AL, DX                                 ; ec                          ; 0xc08d7 vberom.asm:756
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc08d8 vberom.asm:757
    in AL, DX                                 ; ec                          ; 0xc08da vberom.asm:758
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc08db vberom.asm:759
    in AL, DX                                 ; ec                          ; 0xc08dd vberom.asm:760
    stosw                                     ; ab                          ; 0xc08de vberom.asm:761
    db  08bh, 0c3h
    ; mov ax, bx                                ; 8b c3                     ; 0xc08df vberom.asm:762
    stosw                                     ; ab                          ; 0xc08e1 vberom.asm:763
    loop 008d7h                               ; e2 f3                       ; 0xc08e2 vberom.asm:765
    popaw                                     ; 61                          ; 0xc08e4 vberom.asm:162
    jmp short 008c7h                          ; eb e0                       ; 0xc08e5 vberom.asm:767
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc08e7 vberom.asm:770
    retn                                      ; c3                          ; 0xc08ea vberom.asm:771
    mov ax, 0024fh                            ; b8 4f 02                    ; 0xc08eb vberom.asm:773
    retn                                      ; c3                          ; 0xc08ee vberom.asm:774
  ; disGetNextSymbol 0xc08ef LB 0x14 -> off=0x0 cb=0000000000000014 uValue=00000000000c08ef 'vbe_biosfn_return_protected_mode_interface'
vbe_biosfn_return_protected_mode_interface: ; 0xc08ef LB 0x14
    test bl, bl                               ; 84 db                       ; 0xc08ef vberom.asm:788
    jne short 008ffh                          ; 75 0c                       ; 0xc08f1 vberom.asm:789
    push CS                                   ; 0e                          ; 0xc08f3 vberom.asm:790
    pop ES                                    ; 07                          ; 0xc08f4 vberom.asm:791
    mov di, 04640h                            ; bf 40 46                    ; 0xc08f5 vberom.asm:792
    mov cx, 00115h                            ; b9 15 01                    ; 0xc08f8 vberom.asm:793
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc08fb vberom.asm:794
    retn                                      ; c3                          ; 0xc08fe vberom.asm:795
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc08ff vberom.asm:797
    retn                                      ; c3                          ; 0xc0902 vberom.asm:798

  ; Padding 0xed bytes at 0xc0903
  times 237 db 0

section _TEXT progbits vstart=0x9f0 align=1 ; size=0x3ad1 class=CODE group=AUTO
  ; disGetNextSymbol 0xc09f0 LB 0x3ad1 -> off=0x0 cb=000000000000001b uValue=00000000000c09f0 'set_int_vector'
set_int_vector:                              ; 0xc09f0 LB 0x1b
    push dx                                   ; 52                          ; 0xc09f0 vgabios.c:87
    push bp                                   ; 55                          ; 0xc09f1
    mov bp, sp                                ; 89 e5                       ; 0xc09f2
    mov dx, bx                                ; 89 da                       ; 0xc09f4
    mov bl, al                                ; 88 c3                       ; 0xc09f6 vgabios.c:91
    xor bh, bh                                ; 30 ff                       ; 0xc09f8
    sal bx, 002h                              ; c1 e3 02                    ; 0xc09fa
    xor ax, ax                                ; 31 c0                       ; 0xc09fd
    mov es, ax                                ; 8e c0                       ; 0xc09ff
    mov word [es:bx], dx                      ; 26 89 17                    ; 0xc0a01
    mov word [es:bx+002h], cx                 ; 26 89 4f 02                 ; 0xc0a04
    pop bp                                    ; 5d                          ; 0xc0a08 vgabios.c:92
    pop dx                                    ; 5a                          ; 0xc0a09
    retn                                      ; c3                          ; 0xc0a0a
  ; disGetNextSymbol 0xc0a0b LB 0x3ab6 -> off=0x0 cb=000000000000001c uValue=00000000000c0a0b 'init_vga_card'
init_vga_card:                               ; 0xc0a0b LB 0x1c
    push bp                                   ; 55                          ; 0xc0a0b vgabios.c:143
    mov bp, sp                                ; 89 e5                       ; 0xc0a0c
    push dx                                   ; 52                          ; 0xc0a0e
    mov AL, strict byte 0c3h                  ; b0 c3                       ; 0xc0a0f vgabios.c:146
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc0a11
    out DX, AL                                ; ee                          ; 0xc0a14
    mov AL, strict byte 004h                  ; b0 04                       ; 0xc0a15 vgabios.c:149
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc0a17
    out DX, AL                                ; ee                          ; 0xc0a1a
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc0a1b vgabios.c:150
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc0a1d
    out DX, AL                                ; ee                          ; 0xc0a20
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc0a21 vgabios.c:155
    pop dx                                    ; 5a                          ; 0xc0a24
    pop bp                                    ; 5d                          ; 0xc0a25
    retn                                      ; c3                          ; 0xc0a26
  ; disGetNextSymbol 0xc0a27 LB 0x3a9a -> off=0x0 cb=000000000000003e uValue=00000000000c0a27 'init_bios_area'
init_bios_area:                              ; 0xc0a27 LB 0x3e
    push bx                                   ; 53                          ; 0xc0a27 vgabios.c:221
    push bp                                   ; 55                          ; 0xc0a28
    mov bp, sp                                ; 89 e5                       ; 0xc0a29
    xor bx, bx                                ; 31 db                       ; 0xc0a2b vgabios.c:225
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0a2d
    mov es, ax                                ; 8e c0                       ; 0xc0a30
    mov al, byte [es:bx+010h]                 ; 26 8a 47 10                 ; 0xc0a32 vgabios.c:228
    and AL, strict byte 0cfh                  ; 24 cf                       ; 0xc0a36
    or AL, strict byte 020h                   ; 0c 20                       ; 0xc0a38
    mov byte [es:bx+010h], al                 ; 26 88 47 10                 ; 0xc0a3a
    mov byte [es:bx+00085h], 010h             ; 26 c6 87 85 00 10           ; 0xc0a3e vgabios.c:232
    mov word [es:bx+00087h], 0f960h           ; 26 c7 87 87 00 60 f9        ; 0xc0a44 vgabios.c:234
    mov byte [es:bx+00089h], 051h             ; 26 c6 87 89 00 51           ; 0xc0a4b vgabios.c:238
    mov byte [es:bx+065h], 009h               ; 26 c6 47 65 09              ; 0xc0a51 vgabios.c:240
    mov word [es:bx+000a8h], 0554eh           ; 26 c7 87 a8 00 4e 55        ; 0xc0a56 vgabios.c:242
    mov [es:bx+000aah], ds                    ; 26 8c 9f aa 00              ; 0xc0a5d
    pop bp                                    ; 5d                          ; 0xc0a62 vgabios.c:243
    pop bx                                    ; 5b                          ; 0xc0a63
    retn                                      ; c3                          ; 0xc0a64
  ; disGetNextSymbol 0xc0a65 LB 0x3a5c -> off=0x0 cb=0000000000000031 uValue=00000000000c0a65 'vgabios_init_func'
vgabios_init_func:                           ; 0xc0a65 LB 0x31
    inc bp                                    ; 45                          ; 0xc0a65 vgabios.c:250
    push bp                                   ; 55                          ; 0xc0a66
    mov bp, sp                                ; 89 e5                       ; 0xc0a67
    call 00a0bh                               ; e8 9f ff                    ; 0xc0a69 vgabios.c:252
    call 00a27h                               ; e8 b8 ff                    ; 0xc0a6c vgabios.c:253
    call 03e31h                               ; e8 bf 33                    ; 0xc0a6f vgabios.c:255
    mov bx, strict word 00028h                ; bb 28 00                    ; 0xc0a72 vgabios.c:257
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0a75
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc0a78
    call 009f0h                               ; e8 72 ff                    ; 0xc0a7b
    mov bx, strict word 00028h                ; bb 28 00                    ; 0xc0a7e vgabios.c:258
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0a81
    mov ax, strict word 0006dh                ; b8 6d 00                    ; 0xc0a84
    call 009f0h                               ; e8 66 ff                    ; 0xc0a87
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc0a8a vgabios.c:284
    db  032h, 0e4h
    ; xor ah, ah                                ; 32 e4                     ; 0xc0a8d
    int 010h                                  ; cd 10                       ; 0xc0a8f
    mov sp, bp                                ; 89 ec                       ; 0xc0a91 vgabios.c:287
    pop bp                                    ; 5d                          ; 0xc0a93
    dec bp                                    ; 4d                          ; 0xc0a94
    retf                                      ; cb                          ; 0xc0a95
  ; disGetNextSymbol 0xc0a96 LB 0x3a2b -> off=0x0 cb=000000000000002e uValue=00000000000c0a96 'vga_get_cursor_pos'
vga_get_cursor_pos:                          ; 0xc0a96 LB 0x2e
    push si                                   ; 56                          ; 0xc0a96 vgabios.c:356
    push di                                   ; 57                          ; 0xc0a97
    push bp                                   ; 55                          ; 0xc0a98
    mov bp, sp                                ; 89 e5                       ; 0xc0a99
    mov si, dx                                ; 89 d6                       ; 0xc0a9b
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc0a9d vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc0aa0
    mov es, dx                                ; 8e c2                       ; 0xc0aa3
    mov di, word [es:di]                      ; 26 8b 3d                    ; 0xc0aa5
    push SS                                   ; 16                          ; 0xc0aa8 vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0aa9
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc0aaa
    xor ah, ah                                ; 30 e4                       ; 0xc0aad vgabios.c:360
    mov si, ax                                ; 89 c6                       ; 0xc0aaf
    add si, ax                                ; 01 c6                       ; 0xc0ab1
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc0ab3
    mov es, dx                                ; 8e c2                       ; 0xc0ab6 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc0ab8
    push SS                                   ; 16                          ; 0xc0abb vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0abc
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0abd
    pop bp                                    ; 5d                          ; 0xc0ac0 vgabios.c:361
    pop di                                    ; 5f                          ; 0xc0ac1
    pop si                                    ; 5e                          ; 0xc0ac2
    retn                                      ; c3                          ; 0xc0ac3
  ; disGetNextSymbol 0xc0ac4 LB 0x39fd -> off=0x0 cb=000000000000005e uValue=00000000000c0ac4 'vga_find_glyph'
vga_find_glyph:                              ; 0xc0ac4 LB 0x5e
    push bp                                   ; 55                          ; 0xc0ac4 vgabios.c:364
    mov bp, sp                                ; 89 e5                       ; 0xc0ac5
    push si                                   ; 56                          ; 0xc0ac7
    push di                                   ; 57                          ; 0xc0ac8
    push ax                                   ; 50                          ; 0xc0ac9
    push ax                                   ; 50                          ; 0xc0aca
    push dx                                   ; 52                          ; 0xc0acb
    push bx                                   ; 53                          ; 0xc0acc
    mov bl, cl                                ; 88 cb                       ; 0xc0acd
    mov word [bp-006h], strict word 00000h    ; c7 46 fa 00 00              ; 0xc0acf vgabios.c:366
    dec word [bp+004h]                        ; ff 4e 04                    ; 0xc0ad4 vgabios.c:368
    cmp word [bp+004h], strict byte 0ffffh    ; 83 7e 04 ff                 ; 0xc0ad7
    je short 00b16h                           ; 74 39                       ; 0xc0adb
    mov cl, byte [bp+006h]                    ; 8a 4e 06                    ; 0xc0add vgabios.c:369
    xor ch, ch                                ; 30 ed                       ; 0xc0ae0
    mov dx, ss                                ; 8c d2                       ; 0xc0ae2
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc0ae4
    mov di, word [bp-008h]                    ; 8b 7e f8                    ; 0xc0ae7
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc0aea
    push DS                                   ; 1e                          ; 0xc0aed
    mov ds, dx                                ; 8e da                       ; 0xc0aee
    rep cmpsb                                 ; f3 a6                       ; 0xc0af0
    pop DS                                    ; 1f                          ; 0xc0af2
    mov ax, strict word 00000h                ; b8 00 00                    ; 0xc0af3
    je short 00afah                           ; 74 02                       ; 0xc0af6
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc0af8
    test ax, ax                               ; 85 c0                       ; 0xc0afa
    jne short 00b0ah                          ; 75 0c                       ; 0xc0afc
    mov al, bl                                ; 88 d8                       ; 0xc0afe vgabios.c:370
    xor ah, ah                                ; 30 e4                       ; 0xc0b00
    or ah, 080h                               ; 80 cc 80                    ; 0xc0b02
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0b05
    jmp short 00b16h                          ; eb 0c                       ; 0xc0b08 vgabios.c:371
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc0b0a vgabios.c:373
    xor ah, ah                                ; 30 e4                       ; 0xc0b0d
    add word [bp-008h], ax                    ; 01 46 f8                    ; 0xc0b0f
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc0b12 vgabios.c:374
    jmp short 00ad4h                          ; eb be                       ; 0xc0b14 vgabios.c:375
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc0b16 vgabios.c:377
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0b19
    pop di                                    ; 5f                          ; 0xc0b1c
    pop si                                    ; 5e                          ; 0xc0b1d
    pop bp                                    ; 5d                          ; 0xc0b1e
    retn 00004h                               ; c2 04 00                    ; 0xc0b1f
  ; disGetNextSymbol 0xc0b22 LB 0x399f -> off=0x0 cb=0000000000000046 uValue=00000000000c0b22 'vga_read_glyph_planar'
vga_read_glyph_planar:                       ; 0xc0b22 LB 0x46
    push bp                                   ; 55                          ; 0xc0b22 vgabios.c:379
    mov bp, sp                                ; 89 e5                       ; 0xc0b23
    push si                                   ; 56                          ; 0xc0b25
    push di                                   ; 57                          ; 0xc0b26
    push ax                                   ; 50                          ; 0xc0b27
    push ax                                   ; 50                          ; 0xc0b28
    mov si, ax                                ; 89 c6                       ; 0xc0b29
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc0b2b
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc0b2e
    mov bx, cx                                ; 89 cb                       ; 0xc0b31
    mov ax, 00805h                            ; b8 05 08                    ; 0xc0b33 vgabios.c:386
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0b36
    out DX, ax                                ; ef                          ; 0xc0b39
    dec byte [bp+004h]                        ; fe 4e 04                    ; 0xc0b3a vgabios.c:388
    cmp byte [bp+004h], 0ffh                  ; 80 7e 04 ff                 ; 0xc0b3d
    je short 00b58h                           ; 74 15                       ; 0xc0b41
    mov es, [bp-006h]                         ; 8e 46 fa                    ; 0xc0b43 vgabios.c:389
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc0b46
    not al                                    ; f6 d0                       ; 0xc0b49
    mov di, bx                                ; 89 df                       ; 0xc0b4b
    inc bx                                    ; 43                          ; 0xc0b4d
    push SS                                   ; 16                          ; 0xc0b4e
    pop ES                                    ; 07                          ; 0xc0b4f
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0b50
    add si, word [bp-008h]                    ; 03 76 f8                    ; 0xc0b53 vgabios.c:390
    jmp short 00b3ah                          ; eb e2                       ; 0xc0b56 vgabios.c:391
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0b58 vgabios.c:394
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0b5b
    out DX, ax                                ; ef                          ; 0xc0b5e
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0b5f vgabios.c:395
    pop di                                    ; 5f                          ; 0xc0b62
    pop si                                    ; 5e                          ; 0xc0b63
    pop bp                                    ; 5d                          ; 0xc0b64
    retn 00002h                               ; c2 02 00                    ; 0xc0b65
  ; disGetNextSymbol 0xc0b68 LB 0x3959 -> off=0x0 cb=000000000000002f uValue=00000000000c0b68 'vga_char_ofs_planar'
vga_char_ofs_planar:                         ; 0xc0b68 LB 0x2f
    push si                                   ; 56                          ; 0xc0b68 vgabios.c:397
    push bp                                   ; 55                          ; 0xc0b69
    mov bp, sp                                ; 89 e5                       ; 0xc0b6a
    mov ch, al                                ; 88 c5                       ; 0xc0b6c
    mov al, dl                                ; 88 d0                       ; 0xc0b6e
    xor ah, ah                                ; 30 e4                       ; 0xc0b70 vgabios.c:401
    mul bx                                    ; f7 e3                       ; 0xc0b72
    mov bl, byte [bp+006h]                    ; 8a 5e 06                    ; 0xc0b74
    xor bh, bh                                ; 30 ff                       ; 0xc0b77
    mul bx                                    ; f7 e3                       ; 0xc0b79
    mov bl, ch                                ; 88 eb                       ; 0xc0b7b
    add bx, ax                                ; 01 c3                       ; 0xc0b7d
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc0b7f vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0b82
    mov es, ax                                ; 8e c0                       ; 0xc0b85
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc0b87
    mov al, cl                                ; 88 c8                       ; 0xc0b8a vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc0b8c
    mul si                                    ; f7 e6                       ; 0xc0b8e
    add ax, bx                                ; 01 d8                       ; 0xc0b90
    pop bp                                    ; 5d                          ; 0xc0b92 vgabios.c:405
    pop si                                    ; 5e                          ; 0xc0b93
    retn 00002h                               ; c2 02 00                    ; 0xc0b94
  ; disGetNextSymbol 0xc0b97 LB 0x392a -> off=0x0 cb=0000000000000040 uValue=00000000000c0b97 'vga_read_char_planar'
vga_read_char_planar:                        ; 0xc0b97 LB 0x40
    push bp                                   ; 55                          ; 0xc0b97 vgabios.c:407
    mov bp, sp                                ; 89 e5                       ; 0xc0b98
    push cx                                   ; 51                          ; 0xc0b9a
    sub sp, strict byte 00012h                ; 83 ec 12                    ; 0xc0b9b
    mov byte [bp-004h], bl                    ; 88 5e fc                    ; 0xc0b9e vgabios.c:411
    mov byte [bp-003h], 000h                  ; c6 46 fd 00                 ; 0xc0ba1
    push word [bp-004h]                       ; ff 76 fc                    ; 0xc0ba5
    lea cx, [bp-014h]                         ; 8d 4e ec                    ; 0xc0ba8
    mov bx, ax                                ; 89 c3                       ; 0xc0bab
    mov ax, dx                                ; 89 d0                       ; 0xc0bad
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc0baf
    call 00b22h                               ; e8 6d ff                    ; 0xc0bb2
    push word [bp-004h]                       ; ff 76 fc                    ; 0xc0bb5 vgabios.c:414
    push 00100h                               ; 68 00 01                    ; 0xc0bb8
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0bbb vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0bbe
    mov es, ax                                ; 8e c0                       ; 0xc0bc0
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0bc2
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0bc5
    xor cx, cx                                ; 31 c9                       ; 0xc0bc9 vgabios.c:68
    lea bx, [bp-014h]                         ; 8d 5e ec                    ; 0xc0bcb
    call 00ac4h                               ; e8 f3 fe                    ; 0xc0bce
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc0bd1 vgabios.c:415
    pop cx                                    ; 59                          ; 0xc0bd4
    pop bp                                    ; 5d                          ; 0xc0bd5
    retn                                      ; c3                          ; 0xc0bd6
  ; disGetNextSymbol 0xc0bd7 LB 0x38ea -> off=0x0 cb=0000000000000024 uValue=00000000000c0bd7 'vga_char_ofs_linear'
vga_char_ofs_linear:                         ; 0xc0bd7 LB 0x24
    enter 00002h, 000h                        ; c8 02 00 00                 ; 0xc0bd7 vgabios.c:417
    mov byte [bp-002h], al                    ; 88 46 fe                    ; 0xc0bdb
    mov al, dl                                ; 88 d0                       ; 0xc0bde vgabios.c:421
    xor ah, ah                                ; 30 e4                       ; 0xc0be0
    mul bx                                    ; f7 e3                       ; 0xc0be2
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc0be4
    xor dh, dh                                ; 30 f6                       ; 0xc0be7
    mul dx                                    ; f7 e2                       ; 0xc0be9
    mov dx, ax                                ; 89 c2                       ; 0xc0beb
    mov al, byte [bp-002h]                    ; 8a 46 fe                    ; 0xc0bed
    xor ah, ah                                ; 30 e4                       ; 0xc0bf0
    add ax, dx                                ; 01 d0                       ; 0xc0bf2
    sal ax, 003h                              ; c1 e0 03                    ; 0xc0bf4 vgabios.c:422
    leave                                     ; c9                          ; 0xc0bf7 vgabios.c:424
    retn 00002h                               ; c2 02 00                    ; 0xc0bf8
  ; disGetNextSymbol 0xc0bfb LB 0x38c6 -> off=0x0 cb=000000000000004b uValue=00000000000c0bfb 'vga_read_glyph_linear'
vga_read_glyph_linear:                       ; 0xc0bfb LB 0x4b
    push si                                   ; 56                          ; 0xc0bfb vgabios.c:426
    push di                                   ; 57                          ; 0xc0bfc
    enter 00004h, 000h                        ; c8 04 00 00                 ; 0xc0bfd
    mov si, ax                                ; 89 c6                       ; 0xc0c01
    mov word [bp-002h], dx                    ; 89 56 fe                    ; 0xc0c03
    mov word [bp-004h], bx                    ; 89 5e fc                    ; 0xc0c06
    mov bx, cx                                ; 89 cb                       ; 0xc0c09
    dec byte [bp+008h]                        ; fe 4e 08                    ; 0xc0c0b vgabios.c:432
    cmp byte [bp+008h], 0ffh                  ; 80 7e 08 ff                 ; 0xc0c0e
    je short 00c40h                           ; 74 2c                       ; 0xc0c12
    xor dh, dh                                ; 30 f6                       ; 0xc0c14 vgabios.c:433
    mov DL, strict byte 080h                  ; b2 80                       ; 0xc0c16 vgabios.c:434
    xor ax, ax                                ; 31 c0                       ; 0xc0c18 vgabios.c:435
    jmp short 00c21h                          ; eb 05                       ; 0xc0c1a
    cmp ax, strict word 00008h                ; 3d 08 00                    ; 0xc0c1c
    jnl short 00c35h                          ; 7d 14                       ; 0xc0c1f
    mov es, [bp-002h]                         ; 8e 46 fe                    ; 0xc0c21 vgabios.c:436
    mov di, si                                ; 89 f7                       ; 0xc0c24
    add di, ax                                ; 01 c7                       ; 0xc0c26
    cmp byte [es:di], 000h                    ; 26 80 3d 00                 ; 0xc0c28
    je short 00c30h                           ; 74 02                       ; 0xc0c2c
    or dh, dl                                 ; 08 d6                       ; 0xc0c2e vgabios.c:437
    shr dl, 1                                 ; d0 ea                       ; 0xc0c30 vgabios.c:438
    inc ax                                    ; 40                          ; 0xc0c32 vgabios.c:439
    jmp short 00c1ch                          ; eb e7                       ; 0xc0c33
    mov di, bx                                ; 89 df                       ; 0xc0c35 vgabios.c:440
    inc bx                                    ; 43                          ; 0xc0c37
    mov byte [ss:di], dh                      ; 36 88 35                    ; 0xc0c38
    add si, word [bp-004h]                    ; 03 76 fc                    ; 0xc0c3b vgabios.c:441
    jmp short 00c0bh                          ; eb cb                       ; 0xc0c3e vgabios.c:442
    leave                                     ; c9                          ; 0xc0c40 vgabios.c:443
    pop di                                    ; 5f                          ; 0xc0c41
    pop si                                    ; 5e                          ; 0xc0c42
    retn 00002h                               ; c2 02 00                    ; 0xc0c43
  ; disGetNextSymbol 0xc0c46 LB 0x387b -> off=0x0 cb=0000000000000045 uValue=00000000000c0c46 'vga_read_char_linear'
vga_read_char_linear:                        ; 0xc0c46 LB 0x45
    push bp                                   ; 55                          ; 0xc0c46 vgabios.c:445
    mov bp, sp                                ; 89 e5                       ; 0xc0c47
    push cx                                   ; 51                          ; 0xc0c49
    sub sp, strict byte 00012h                ; 83 ec 12                    ; 0xc0c4a
    mov cx, ax                                ; 89 c1                       ; 0xc0c4d
    mov ax, dx                                ; 89 d0                       ; 0xc0c4f
    mov byte [bp-004h], bl                    ; 88 5e fc                    ; 0xc0c51 vgabios.c:449
    mov byte [bp-003h], 000h                  ; c6 46 fd 00                 ; 0xc0c54
    push word [bp-004h]                       ; ff 76 fc                    ; 0xc0c58
    mov bx, cx                                ; 89 cb                       ; 0xc0c5b
    sal bx, 003h                              ; c1 e3 03                    ; 0xc0c5d
    lea cx, [bp-014h]                         ; 8d 4e ec                    ; 0xc0c60
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc0c63
    call 00bfbh                               ; e8 92 ff                    ; 0xc0c66
    push word [bp-004h]                       ; ff 76 fc                    ; 0xc0c69 vgabios.c:452
    push 00100h                               ; 68 00 01                    ; 0xc0c6c
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0c6f vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0c72
    mov es, ax                                ; 8e c0                       ; 0xc0c74
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0c76
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0c79
    xor cx, cx                                ; 31 c9                       ; 0xc0c7d vgabios.c:68
    lea bx, [bp-014h]                         ; 8d 5e ec                    ; 0xc0c7f
    call 00ac4h                               ; e8 3f fe                    ; 0xc0c82
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc0c85 vgabios.c:453
    pop cx                                    ; 59                          ; 0xc0c88
    pop bp                                    ; 5d                          ; 0xc0c89
    retn                                      ; c3                          ; 0xc0c8a
  ; disGetNextSymbol 0xc0c8b LB 0x3836 -> off=0x0 cb=0000000000000035 uValue=00000000000c0c8b 'vga_read_2bpp_char'
vga_read_2bpp_char:                          ; 0xc0c8b LB 0x35
    push bp                                   ; 55                          ; 0xc0c8b vgabios.c:455
    mov bp, sp                                ; 89 e5                       ; 0xc0c8c
    push bx                                   ; 53                          ; 0xc0c8e
    push cx                                   ; 51                          ; 0xc0c8f
    mov bx, ax                                ; 89 c3                       ; 0xc0c90
    mov es, dx                                ; 8e c2                       ; 0xc0c92
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0c94 vgabios.c:461
    mov DH, strict byte 080h                  ; b6 80                       ; 0xc0c97 vgabios.c:462
    xor dl, dl                                ; 30 d2                       ; 0xc0c99 vgabios.c:463
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0c9b vgabios.c:464
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0c9e
    xor bx, bx                                ; 31 db                       ; 0xc0ca0 vgabios.c:466
    jmp short 00ca9h                          ; eb 05                       ; 0xc0ca2
    cmp bx, strict byte 00008h                ; 83 fb 08                    ; 0xc0ca4
    jnl short 00cb7h                          ; 7d 0e                       ; 0xc0ca7
    test ax, cx                               ; 85 c8                       ; 0xc0ca9 vgabios.c:467
    je short 00cafh                           ; 74 02                       ; 0xc0cab
    or dl, dh                                 ; 08 f2                       ; 0xc0cad vgabios.c:468
    shr dh, 1                                 ; d0 ee                       ; 0xc0caf vgabios.c:469
    shr cx, 002h                              ; c1 e9 02                    ; 0xc0cb1 vgabios.c:470
    inc bx                                    ; 43                          ; 0xc0cb4 vgabios.c:471
    jmp short 00ca4h                          ; eb ed                       ; 0xc0cb5
    mov al, dl                                ; 88 d0                       ; 0xc0cb7 vgabios.c:473
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0cb9
    pop cx                                    ; 59                          ; 0xc0cbc
    pop bx                                    ; 5b                          ; 0xc0cbd
    pop bp                                    ; 5d                          ; 0xc0cbe
    retn                                      ; c3                          ; 0xc0cbf
  ; disGetNextSymbol 0xc0cc0 LB 0x3801 -> off=0x0 cb=0000000000000084 uValue=00000000000c0cc0 'vga_read_glyph_cga'
vga_read_glyph_cga:                          ; 0xc0cc0 LB 0x84
    push bp                                   ; 55                          ; 0xc0cc0 vgabios.c:475
    mov bp, sp                                ; 89 e5                       ; 0xc0cc1
    push cx                                   ; 51                          ; 0xc0cc3
    push si                                   ; 56                          ; 0xc0cc4
    push di                                   ; 57                          ; 0xc0cc5
    push ax                                   ; 50                          ; 0xc0cc6
    mov si, dx                                ; 89 d6                       ; 0xc0cc7
    cmp bl, 006h                              ; 80 fb 06                    ; 0xc0cc9 vgabios.c:483
    je short 00d08h                           ; 74 3a                       ; 0xc0ccc
    mov bx, ax                                ; 89 c3                       ; 0xc0cce vgabios.c:485
    add bx, ax                                ; 01 c3                       ; 0xc0cd0
    mov word [bp-008h], 0b800h                ; c7 46 f8 00 b8              ; 0xc0cd2
    xor cx, cx                                ; 31 c9                       ; 0xc0cd7 vgabios.c:487
    jmp short 00ce0h                          ; eb 05                       ; 0xc0cd9
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc0cdb
    jnl short 00d3ch                          ; 7d 5c                       ; 0xc0cde
    mov ax, bx                                ; 89 d8                       ; 0xc0ce0 vgabios.c:488
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc0ce2
    call 00c8bh                               ; e8 a3 ff                    ; 0xc0ce5
    mov di, si                                ; 89 f7                       ; 0xc0ce8
    inc si                                    ; 46                          ; 0xc0cea
    push SS                                   ; 16                          ; 0xc0ceb
    pop ES                                    ; 07                          ; 0xc0cec
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0ced
    lea ax, [bx+02000h]                       ; 8d 87 00 20                 ; 0xc0cf0 vgabios.c:489
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc0cf4
    call 00c8bh                               ; e8 91 ff                    ; 0xc0cf7
    mov di, si                                ; 89 f7                       ; 0xc0cfa
    inc si                                    ; 46                          ; 0xc0cfc
    push SS                                   ; 16                          ; 0xc0cfd
    pop ES                                    ; 07                          ; 0xc0cfe
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0cff
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc0d02 vgabios.c:490
    inc cx                                    ; 41                          ; 0xc0d05 vgabios.c:491
    jmp short 00cdbh                          ; eb d3                       ; 0xc0d06
    mov bx, ax                                ; 89 c3                       ; 0xc0d08 vgabios.c:493
    mov word [bp-008h], 0b800h                ; c7 46 f8 00 b8              ; 0xc0d0a
    xor cx, cx                                ; 31 c9                       ; 0xc0d0f vgabios.c:494
    jmp short 00d18h                          ; eb 05                       ; 0xc0d11
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc0d13
    jnl short 00d3ch                          ; 7d 24                       ; 0xc0d16
    mov di, si                                ; 89 f7                       ; 0xc0d18 vgabios.c:495
    inc si                                    ; 46                          ; 0xc0d1a
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc0d1b
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0d1e
    push SS                                   ; 16                          ; 0xc0d21
    pop ES                                    ; 07                          ; 0xc0d22
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d23
    mov di, si                                ; 89 f7                       ; 0xc0d26 vgabios.c:496
    inc si                                    ; 46                          ; 0xc0d28
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc0d29
    mov al, byte [es:bx+02000h]               ; 26 8a 87 00 20              ; 0xc0d2c
    push SS                                   ; 16                          ; 0xc0d31
    pop ES                                    ; 07                          ; 0xc0d32
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d33
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc0d36 vgabios.c:497
    inc cx                                    ; 41                          ; 0xc0d39 vgabios.c:498
    jmp short 00d13h                          ; eb d7                       ; 0xc0d3a
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc0d3c vgabios.c:500
    pop di                                    ; 5f                          ; 0xc0d3f
    pop si                                    ; 5e                          ; 0xc0d40
    pop cx                                    ; 59                          ; 0xc0d41
    pop bp                                    ; 5d                          ; 0xc0d42
    retn                                      ; c3                          ; 0xc0d43
  ; disGetNextSymbol 0xc0d44 LB 0x377d -> off=0x0 cb=000000000000001a uValue=00000000000c0d44 'vga_char_ofs_cga'
vga_char_ofs_cga:                            ; 0xc0d44 LB 0x1a
    push cx                                   ; 51                          ; 0xc0d44 vgabios.c:502
    push bp                                   ; 55                          ; 0xc0d45
    mov bp, sp                                ; 89 e5                       ; 0xc0d46
    mov cl, al                                ; 88 c1                       ; 0xc0d48
    mov al, dl                                ; 88 d0                       ; 0xc0d4a
    xor ah, ah                                ; 30 e4                       ; 0xc0d4c vgabios.c:507
    mul bx                                    ; f7 e3                       ; 0xc0d4e
    mov bx, ax                                ; 89 c3                       ; 0xc0d50
    sal bx, 002h                              ; c1 e3 02                    ; 0xc0d52
    mov al, cl                                ; 88 c8                       ; 0xc0d55
    xor ah, ah                                ; 30 e4                       ; 0xc0d57
    add ax, bx                                ; 01 d8                       ; 0xc0d59
    pop bp                                    ; 5d                          ; 0xc0d5b vgabios.c:508
    pop cx                                    ; 59                          ; 0xc0d5c
    retn                                      ; c3                          ; 0xc0d5d
  ; disGetNextSymbol 0xc0d5e LB 0x3763 -> off=0x0 cb=0000000000000066 uValue=00000000000c0d5e 'vga_read_char_cga'
vga_read_char_cga:                           ; 0xc0d5e LB 0x66
    push bp                                   ; 55                          ; 0xc0d5e vgabios.c:510
    mov bp, sp                                ; 89 e5                       ; 0xc0d5f
    push bx                                   ; 53                          ; 0xc0d61
    push cx                                   ; 51                          ; 0xc0d62
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc0d63
    mov bl, dl                                ; 88 d3                       ; 0xc0d66 vgabios.c:516
    xor bh, bh                                ; 30 ff                       ; 0xc0d68
    lea dx, [bp-00eh]                         ; 8d 56 f2                    ; 0xc0d6a
    call 00cc0h                               ; e8 50 ff                    ; 0xc0d6d
    push strict byte 00008h                   ; 6a 08                       ; 0xc0d70 vgabios.c:519
    push 00080h                               ; 68 80 00                    ; 0xc0d72
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0d75 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0d78
    mov es, ax                                ; 8e c0                       ; 0xc0d7a
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0d7c
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0d7f
    xor cx, cx                                ; 31 c9                       ; 0xc0d83 vgabios.c:68
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc0d85
    call 00ac4h                               ; e8 39 fd                    ; 0xc0d88
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0d8b
    test ah, 080h                             ; f6 c4 80                    ; 0xc0d8e vgabios.c:521
    jne short 00dbah                          ; 75 27                       ; 0xc0d91
    mov bx, strict word 0007ch                ; bb 7c 00                    ; 0xc0d93 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0d96
    mov es, ax                                ; 8e c0                       ; 0xc0d98
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0d9a
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0d9d
    test dx, dx                               ; 85 d2                       ; 0xc0da1 vgabios.c:525
    jne short 00da9h                          ; 75 04                       ; 0xc0da3
    test ax, ax                               ; 85 c0                       ; 0xc0da5
    je short 00dbah                           ; 74 11                       ; 0xc0da7
    push strict byte 00008h                   ; 6a 08                       ; 0xc0da9 vgabios.c:526
    push 00080h                               ; 68 80 00                    ; 0xc0dab
    mov cx, 00080h                            ; b9 80 00                    ; 0xc0dae
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc0db1
    call 00ac4h                               ; e8 0d fd                    ; 0xc0db4
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0db7
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc0dba vgabios.c:529
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0dbd
    pop cx                                    ; 59                          ; 0xc0dc0
    pop bx                                    ; 5b                          ; 0xc0dc1
    pop bp                                    ; 5d                          ; 0xc0dc2
    retn                                      ; c3                          ; 0xc0dc3
  ; disGetNextSymbol 0xc0dc4 LB 0x36fd -> off=0x0 cb=0000000000000127 uValue=00000000000c0dc4 'vga_read_char_attr'
vga_read_char_attr:                          ; 0xc0dc4 LB 0x127
    push bp                                   ; 55                          ; 0xc0dc4 vgabios.c:531
    mov bp, sp                                ; 89 e5                       ; 0xc0dc5
    push bx                                   ; 53                          ; 0xc0dc7
    push cx                                   ; 51                          ; 0xc0dc8
    push si                                   ; 56                          ; 0xc0dc9
    push di                                   ; 57                          ; 0xc0dca
    sub sp, strict byte 00014h                ; 83 ec 14                    ; 0xc0dcb
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc0dce
    mov si, dx                                ; 89 d6                       ; 0xc0dd1
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0dd3 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0dd6
    mov es, ax                                ; 8e c0                       ; 0xc0dd9
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0ddb
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc0dde vgabios.c:48
    xor ah, ah                                ; 30 e4                       ; 0xc0de1 vgabios.c:539
    call 0379eh                               ; e8 b8 29                    ; 0xc0de3
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc0de6
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc0de9 vgabios.c:540
    je short 00e64h                           ; 74 77                       ; 0xc0deb
    mov cl, byte [bp-00eh]                    ; 8a 4e f2                    ; 0xc0ded vgabios.c:544
    xor ch, ch                                ; 30 ed                       ; 0xc0df0
    lea bx, [bp-01ah]                         ; 8d 5e e6                    ; 0xc0df2
    lea dx, [bp-01ch]                         ; 8d 56 e4                    ; 0xc0df5
    mov ax, cx                                ; 89 c8                       ; 0xc0df8
    call 00a96h                               ; e8 99 fc                    ; 0xc0dfa
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc0dfd vgabios.c:545
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc0e00
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc0e03 vgabios.c:546
    xor al, al                                ; 30 c0                       ; 0xc0e06
    shr ax, 008h                              ; c1 e8 08                    ; 0xc0e08
    mov word [bp-016h], ax                    ; 89 46 ea                    ; 0xc0e0b
    mov dl, byte [bp-016h]                    ; 8a 56 ea                    ; 0xc0e0e
    mov di, strict word 0004ah                ; bf 4a 00                    ; 0xc0e11 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0e14
    mov es, ax                                ; 8e c0                       ; 0xc0e17
    mov di, word [es:di]                      ; 26 8b 3d                    ; 0xc0e19
    mov word [bp-018h], di                    ; 89 7e e8                    ; 0xc0e1c vgabios.c:58
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc0e1f vgabios.c:552
    xor ah, ah                                ; 30 e4                       ; 0xc0e22
    sal ax, 003h                              ; c1 e0 03                    ; 0xc0e24
    mov word [bp-012h], ax                    ; 89 46 ee                    ; 0xc0e27
    mov bx, ax                                ; 89 c3                       ; 0xc0e2a
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc0e2c
    jne short 00e67h                          ; 75 34                       ; 0xc0e31
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc0e33 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0e36
    mov al, cl                                ; 88 c8                       ; 0xc0e39 vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc0e3b
    mul dx                                    ; f7 e2                       ; 0xc0e3d
    mov bx, ax                                ; 89 c3                       ; 0xc0e3f
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc0e41 vgabios.c:555
    xor ah, ah                                ; 30 e4                       ; 0xc0e44
    mul di                                    ; f7 e7                       ; 0xc0e46
    mov dx, ax                                ; 89 c2                       ; 0xc0e48
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc0e4a
    xor ah, ah                                ; 30 e4                       ; 0xc0e4d
    add ax, dx                                ; 01 d0                       ; 0xc0e4f
    add ax, ax                                ; 01 c0                       ; 0xc0e51
    add bx, ax                                ; 01 c3                       ; 0xc0e53
    mov di, word [bp-012h]                    ; 8b 7e ee                    ; 0xc0e55 vgabios.c:55
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc0e58
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0e5c
    push SS                                   ; 16                          ; 0xc0e5f vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0e60
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc0e61
    jmp near 00ee2h                           ; e9 7b 00                    ; 0xc0e64 vgabios.c:558
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc0e67 vgabios.c:559
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc0e6b
    je short 00ebbh                           ; 74 4c                       ; 0xc0e6d
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc0e6f
    jc short 00ee2h                           ; 72 6f                       ; 0xc0e71
    jbe short 00e7bh                          ; 76 06                       ; 0xc0e73
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc0e75
    jbe short 00e94h                          ; 76 1b                       ; 0xc0e77
    jmp short 00ee2h                          ; eb 67                       ; 0xc0e79
    xor dh, dh                                ; 30 f6                       ; 0xc0e7b vgabios.c:562
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc0e7d
    xor ah, ah                                ; 30 e4                       ; 0xc0e80
    mov bx, word [bp-018h]                    ; 8b 5e e8                    ; 0xc0e82
    call 00d44h                               ; e8 bc fe                    ; 0xc0e85
    mov dl, byte [bp-010h]                    ; 8a 56 f0                    ; 0xc0e88 vgabios.c:563
    xor dh, dh                                ; 30 f6                       ; 0xc0e8b
    call 00d5eh                               ; e8 ce fe                    ; 0xc0e8d
    xor ah, ah                                ; 30 e4                       ; 0xc0e90
    jmp short 00e5fh                          ; eb cb                       ; 0xc0e92
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0e94 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0e97
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc0e9a vgabios.c:568
    mov byte [bp-013h], ch                    ; 88 6e ed                    ; 0xc0e9d
    push word [bp-014h]                       ; ff 76 ec                    ; 0xc0ea0
    xor dh, dh                                ; 30 f6                       ; 0xc0ea3
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc0ea5
    xor ah, ah                                ; 30 e4                       ; 0xc0ea8
    mov bx, di                                ; 89 fb                       ; 0xc0eaa
    call 00b68h                               ; e8 b9 fc                    ; 0xc0eac
    mov bx, word [bp-014h]                    ; 8b 5e ec                    ; 0xc0eaf vgabios.c:569
    mov dx, ax                                ; 89 c2                       ; 0xc0eb2
    mov ax, di                                ; 89 f8                       ; 0xc0eb4
    call 00b97h                               ; e8 de fc                    ; 0xc0eb6
    jmp short 00e90h                          ; eb d5                       ; 0xc0eb9
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0ebb vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0ebe
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc0ec1 vgabios.c:573
    mov byte [bp-013h], ch                    ; 88 6e ed                    ; 0xc0ec4
    push word [bp-014h]                       ; ff 76 ec                    ; 0xc0ec7
    xor dh, dh                                ; 30 f6                       ; 0xc0eca
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc0ecc
    xor ah, ah                                ; 30 e4                       ; 0xc0ecf
    mov bx, di                                ; 89 fb                       ; 0xc0ed1
    call 00bd7h                               ; e8 01 fd                    ; 0xc0ed3
    mov bx, word [bp-014h]                    ; 8b 5e ec                    ; 0xc0ed6 vgabios.c:574
    mov dx, ax                                ; 89 c2                       ; 0xc0ed9
    mov ax, di                                ; 89 f8                       ; 0xc0edb
    call 00c46h                               ; e8 66 fd                    ; 0xc0edd
    jmp short 00e90h                          ; eb ae                       ; 0xc0ee0
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc0ee2 vgabios.c:583
    pop di                                    ; 5f                          ; 0xc0ee5
    pop si                                    ; 5e                          ; 0xc0ee6
    pop cx                                    ; 59                          ; 0xc0ee7
    pop bx                                    ; 5b                          ; 0xc0ee8
    pop bp                                    ; 5d                          ; 0xc0ee9
    retn                                      ; c3                          ; 0xc0eea
  ; disGetNextSymbol 0xc0eeb LB 0x35d6 -> off=0x10 cb=0000000000000083 uValue=00000000000c0efb 'vga_get_font_info'
    db  012h, 00fh, 057h, 00fh, 05ch, 00fh, 063h, 00fh, 068h, 00fh, 06dh, 00fh, 072h, 00fh, 077h, 00fh
vga_get_font_info:                           ; 0xc0efb LB 0x83
    push si                                   ; 56                          ; 0xc0efb vgabios.c:585
    push di                                   ; 57                          ; 0xc0efc
    push bp                                   ; 55                          ; 0xc0efd
    mov bp, sp                                ; 89 e5                       ; 0xc0efe
    mov si, dx                                ; 89 d6                       ; 0xc0f00
    mov di, bx                                ; 89 df                       ; 0xc0f02
    cmp ax, strict word 00007h                ; 3d 07 00                    ; 0xc0f04 vgabios.c:590
    jnbe short 00f51h                         ; 77 48                       ; 0xc0f07
    mov bx, ax                                ; 89 c3                       ; 0xc0f09
    add bx, ax                                ; 01 c3                       ; 0xc0f0b
    jmp word [cs:bx+00eebh]                   ; 2e ff a7 eb 0e              ; 0xc0f0d
    mov bx, strict word 0007ch                ; bb 7c 00                    ; 0xc0f12 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0f15
    mov es, ax                                ; 8e c0                       ; 0xc0f17
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0f19
    mov ax, word [es:bx+002h]                 ; 26 8b 47 02                 ; 0xc0f1c
    push SS                                   ; 16                          ; 0xc0f20 vgabios.c:593
    pop ES                                    ; 07                          ; 0xc0f21
    mov word [es:di], dx                      ; 26 89 15                    ; 0xc0f22
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc0f25
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0f28
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f2b
    mov es, ax                                ; 8e c0                       ; 0xc0f2e
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f30
    xor ah, ah                                ; 30 e4                       ; 0xc0f33
    push SS                                   ; 16                          ; 0xc0f35
    pop ES                                    ; 07                          ; 0xc0f36
    mov bx, cx                                ; 89 cb                       ; 0xc0f37
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0f39
    mov bx, 00084h                            ; bb 84 00                    ; 0xc0f3c
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f3f
    mov es, ax                                ; 8e c0                       ; 0xc0f42
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f44
    xor ah, ah                                ; 30 e4                       ; 0xc0f47
    push SS                                   ; 16                          ; 0xc0f49
    pop ES                                    ; 07                          ; 0xc0f4a
    mov bx, word [bp+008h]                    ; 8b 5e 08                    ; 0xc0f4b
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0f4e
    pop bp                                    ; 5d                          ; 0xc0f51
    pop di                                    ; 5f                          ; 0xc0f52
    pop si                                    ; 5e                          ; 0xc0f53
    retn 00002h                               ; c2 02 00                    ; 0xc0f54
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0f57 vgabios.c:67
    jmp short 00f15h                          ; eb b9                       ; 0xc0f5a
    mov dx, 05d6ah                            ; ba 6a 5d                    ; 0xc0f5c vgabios.c:598
    mov ax, ds                                ; 8c d8                       ; 0xc0f5f
    jmp short 00f20h                          ; eb bd                       ; 0xc0f61 vgabios.c:599
    mov dx, 0556ah                            ; ba 6a 55                    ; 0xc0f63 vgabios.c:601
    jmp short 00f5fh                          ; eb f7                       ; 0xc0f66
    mov dx, 0596ah                            ; ba 6a 59                    ; 0xc0f68 vgabios.c:604
    jmp short 00f5fh                          ; eb f2                       ; 0xc0f6b
    mov dx, 07b6ah                            ; ba 6a 7b                    ; 0xc0f6d vgabios.c:607
    jmp short 00f5fh                          ; eb ed                       ; 0xc0f70
    mov dx, 06b6ah                            ; ba 6a 6b                    ; 0xc0f72 vgabios.c:610
    jmp short 00f5fh                          ; eb e8                       ; 0xc0f75
    mov dx, 07c97h                            ; ba 97 7c                    ; 0xc0f77 vgabios.c:613
    jmp short 00f5fh                          ; eb e3                       ; 0xc0f7a
    jmp short 00f51h                          ; eb d3                       ; 0xc0f7c vgabios.c:619
  ; disGetNextSymbol 0xc0f7e LB 0x3543 -> off=0x0 cb=0000000000000166 uValue=00000000000c0f7e 'vga_read_pixel'
vga_read_pixel:                              ; 0xc0f7e LB 0x166
    push bp                                   ; 55                          ; 0xc0f7e vgabios.c:632
    mov bp, sp                                ; 89 e5                       ; 0xc0f7f
    push si                                   ; 56                          ; 0xc0f81
    push di                                   ; 57                          ; 0xc0f82
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc0f83
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc0f86
    mov si, dx                                ; 89 d6                       ; 0xc0f89
    mov dx, bx                                ; 89 da                       ; 0xc0f8b
    mov word [bp-00ch], cx                    ; 89 4e f4                    ; 0xc0f8d
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0f90 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f93
    mov es, ax                                ; 8e c0                       ; 0xc0f96
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f98
    xor ah, ah                                ; 30 e4                       ; 0xc0f9b vgabios.c:639
    call 0379eh                               ; e8 fe 27                    ; 0xc0f9d
    mov ah, al                                ; 88 c4                       ; 0xc0fa0
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc0fa2 vgabios.c:640
    je short 00fb4h                           ; 74 0e                       ; 0xc0fa4
    mov bl, al                                ; 88 c3                       ; 0xc0fa6 vgabios.c:642
    xor bh, bh                                ; 30 ff                       ; 0xc0fa8
    sal bx, 003h                              ; c1 e3 03                    ; 0xc0faa
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc0fad
    jne short 00fb7h                          ; 75 03                       ; 0xc0fb2
    jmp near 010ddh                           ; e9 26 01                    ; 0xc0fb4 vgabios.c:643
    mov ch, byte [bx+047aeh]                  ; 8a af ae 47                 ; 0xc0fb7 vgabios.c:646
    cmp ch, 003h                              ; 80 fd 03                    ; 0xc0fbb
    jc short 00fcfh                           ; 72 0f                       ; 0xc0fbe
    jbe short 00fd7h                          ; 76 15                       ; 0xc0fc0
    cmp ch, 005h                              ; 80 fd 05                    ; 0xc0fc2
    je short 0100eh                           ; 74 47                       ; 0xc0fc5
    cmp ch, 004h                              ; 80 fd 04                    ; 0xc0fc7
    je short 00fd7h                           ; 74 0b                       ; 0xc0fca
    jmp near 010d3h                           ; e9 04 01                    ; 0xc0fcc
    cmp ch, 002h                              ; 80 fd 02                    ; 0xc0fcf
    je short 01045h                           ; 74 71                       ; 0xc0fd2
    jmp near 010d3h                           ; e9 fc 00                    ; 0xc0fd4
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc0fd7 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0fda
    mov es, ax                                ; 8e c0                       ; 0xc0fdd
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc0fdf
    mov ax, dx                                ; 89 d0                       ; 0xc0fe2 vgabios.c:58
    mul bx                                    ; f7 e3                       ; 0xc0fe4
    mov bx, si                                ; 89 f3                       ; 0xc0fe6
    shr bx, 003h                              ; c1 eb 03                    ; 0xc0fe8
    add bx, ax                                ; 01 c3                       ; 0xc0feb
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc0fed vgabios.c:57
    mov ax, word [es:di]                      ; 26 8b 05                    ; 0xc0ff0
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc0ff3 vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc0ff6
    mul dx                                    ; f7 e2                       ; 0xc0ff8
    add bx, ax                                ; 01 c3                       ; 0xc0ffa
    mov cx, si                                ; 89 f1                       ; 0xc0ffc vgabios.c:651
    and cx, strict byte 00007h                ; 83 e1 07                    ; 0xc0ffe
    mov ax, 00080h                            ; b8 80 00                    ; 0xc1001
    sar ax, CL                                ; d3 f8                       ; 0xc1004
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc1006
    mov byte [bp-006h], ch                    ; 88 6e fa                    ; 0xc1009 vgabios.c:653
    jmp short 01017h                          ; eb 09                       ; 0xc100c
    jmp near 010b3h                           ; e9 a2 00                    ; 0xc100e
    cmp byte [bp-006h], 004h                  ; 80 7e fa 04                 ; 0xc1011
    jnc short 01042h                          ; 73 2b                       ; 0xc1015
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1017 vgabios.c:654
    xor ah, ah                                ; 30 e4                       ; 0xc101a
    sal ax, 008h                              ; c1 e0 08                    ; 0xc101c
    or AL, strict byte 004h                   ; 0c 04                       ; 0xc101f
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1021
    out DX, ax                                ; ef                          ; 0xc1024
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc1025 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc1028
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc102a
    and al, byte [bp-008h]                    ; 22 46 f8                    ; 0xc102d vgabios.c:48
    test al, al                               ; 84 c0                       ; 0xc1030 vgabios.c:656
    jbe short 0103dh                          ; 76 09                       ; 0xc1032
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc1034 vgabios.c:657
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc1037
    sal al, CL                                ; d2 e0                       ; 0xc1039
    or ch, al                                 ; 08 c5                       ; 0xc103b
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc103d vgabios.c:658
    jmp short 01011h                          ; eb cf                       ; 0xc1040
    jmp near 010d5h                           ; e9 90 00                    ; 0xc1042
    mov cl, byte [bx+047afh]                  ; 8a 8f af 47                 ; 0xc1045 vgabios.c:661
    xor ch, ch                                ; 30 ed                       ; 0xc1049
    mov bx, strict word 00004h                ; bb 04 00                    ; 0xc104b
    sub bx, cx                                ; 29 cb                       ; 0xc104e
    mov cx, bx                                ; 89 d9                       ; 0xc1050
    mov bx, si                                ; 89 f3                       ; 0xc1052
    shr bx, CL                                ; d3 eb                       ; 0xc1054
    mov cx, bx                                ; 89 d9                       ; 0xc1056
    mov bx, dx                                ; 89 d3                       ; 0xc1058
    shr bx, 1                                 ; d1 eb                       ; 0xc105a
    imul bx, bx, strict byte 00050h           ; 6b db 50                    ; 0xc105c
    add bx, cx                                ; 01 cb                       ; 0xc105f
    test dl, 001h                             ; f6 c2 01                    ; 0xc1061 vgabios.c:662
    je short 01069h                           ; 74 03                       ; 0xc1064
    add bh, 020h                              ; 80 c7 20                    ; 0xc1066 vgabios.c:663
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1069 vgabios.c:47
    mov es, dx                                ; 8e c2                       ; 0xc106c
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc106e
    mov bl, ah                                ; 88 e3                       ; 0xc1071 vgabios.c:665
    xor bh, bh                                ; 30 ff                       ; 0xc1073
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1075
    cmp byte [bx+047afh], 002h                ; 80 bf af 47 02              ; 0xc1078
    jne short 0109ah                          ; 75 1b                       ; 0xc107d
    mov cx, si                                ; 89 f1                       ; 0xc107f vgabios.c:666
    xor ch, ch                                ; 30 ed                       ; 0xc1081
    and cl, 003h                              ; 80 e1 03                    ; 0xc1083
    mov dx, strict word 00003h                ; ba 03 00                    ; 0xc1086
    sub dx, cx                                ; 29 ca                       ; 0xc1089
    mov cx, dx                                ; 89 d1                       ; 0xc108b
    add cx, dx                                ; 01 d1                       ; 0xc108d
    xor ah, ah                                ; 30 e4                       ; 0xc108f
    sar ax, CL                                ; d3 f8                       ; 0xc1091
    mov ch, al                                ; 88 c5                       ; 0xc1093
    and ch, 003h                              ; 80 e5 03                    ; 0xc1095
    jmp short 010d5h                          ; eb 3b                       ; 0xc1098 vgabios.c:667
    mov cx, si                                ; 89 f1                       ; 0xc109a vgabios.c:668
    xor ch, ch                                ; 30 ed                       ; 0xc109c
    and cl, 007h                              ; 80 e1 07                    ; 0xc109e
    mov dx, strict word 00007h                ; ba 07 00                    ; 0xc10a1
    sub dx, cx                                ; 29 ca                       ; 0xc10a4
    mov cx, dx                                ; 89 d1                       ; 0xc10a6
    xor ah, ah                                ; 30 e4                       ; 0xc10a8
    sar ax, CL                                ; d3 f8                       ; 0xc10aa
    mov ch, al                                ; 88 c5                       ; 0xc10ac
    and ch, 001h                              ; 80 e5 01                    ; 0xc10ae
    jmp short 010d5h                          ; eb 22                       ; 0xc10b1 vgabios.c:669
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc10b3 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc10b6
    mov es, ax                                ; 8e c0                       ; 0xc10b9
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc10bb
    sal bx, 003h                              ; c1 e3 03                    ; 0xc10be vgabios.c:58
    mov ax, dx                                ; 89 d0                       ; 0xc10c1
    mul bx                                    ; f7 e3                       ; 0xc10c3
    mov bx, si                                ; 89 f3                       ; 0xc10c5
    add bx, ax                                ; 01 c3                       ; 0xc10c7
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc10c9 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc10cc
    mov ch, byte [es:bx]                      ; 26 8a 2f                    ; 0xc10ce
    jmp short 010d5h                          ; eb 02                       ; 0xc10d1 vgabios.c:673
    xor ch, ch                                ; 30 ed                       ; 0xc10d3 vgabios.c:678
    push SS                                   ; 16                          ; 0xc10d5 vgabios.c:680
    pop ES                                    ; 07                          ; 0xc10d6
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc10d7
    mov byte [es:bx], ch                      ; 26 88 2f                    ; 0xc10da
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc10dd vgabios.c:681
    pop di                                    ; 5f                          ; 0xc10e0
    pop si                                    ; 5e                          ; 0xc10e1
    pop bp                                    ; 5d                          ; 0xc10e2
    retn                                      ; c3                          ; 0xc10e3
  ; disGetNextSymbol 0xc10e4 LB 0x33dd -> off=0x0 cb=000000000000008d uValue=00000000000c10e4 'biosfn_perform_gray_scale_summing'
biosfn_perform_gray_scale_summing:           ; 0xc10e4 LB 0x8d
    push bp                                   ; 55                          ; 0xc10e4 vgabios.c:686
    mov bp, sp                                ; 89 e5                       ; 0xc10e5
    push bx                                   ; 53                          ; 0xc10e7
    push cx                                   ; 51                          ; 0xc10e8
    push si                                   ; 56                          ; 0xc10e9
    push di                                   ; 57                          ; 0xc10ea
    push ax                                   ; 50                          ; 0xc10eb
    push ax                                   ; 50                          ; 0xc10ec
    mov bx, ax                                ; 89 c3                       ; 0xc10ed
    mov di, dx                                ; 89 d7                       ; 0xc10ef
    mov dx, 003dah                            ; ba da 03                    ; 0xc10f1 vgabios.c:691
    in AL, DX                                 ; ec                          ; 0xc10f4
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc10f5
    xor al, al                                ; 30 c0                       ; 0xc10f7 vgabios.c:692
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc10f9
    out DX, AL                                ; ee                          ; 0xc10fc
    xor si, si                                ; 31 f6                       ; 0xc10fd vgabios.c:694
    cmp si, di                                ; 39 fe                       ; 0xc10ff
    jnc short 01156h                          ; 73 53                       ; 0xc1101
    mov al, bl                                ; 88 d8                       ; 0xc1103 vgabios.c:697
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc1105
    out DX, AL                                ; ee                          ; 0xc1108
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc1109 vgabios.c:699
    in AL, DX                                 ; ec                          ; 0xc110c
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc110d
    mov cx, ax                                ; 89 c1                       ; 0xc110f
    in AL, DX                                 ; ec                          ; 0xc1111 vgabios.c:700
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1112
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc1114
    in AL, DX                                 ; ec                          ; 0xc1117 vgabios.c:701
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1118
    xor ch, ch                                ; 30 ed                       ; 0xc111a vgabios.c:704
    imul cx, cx, strict byte 0004dh           ; 6b c9 4d                    ; 0xc111c
    mov word [bp-00ah], cx                    ; 89 4e f6                    ; 0xc111f
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc1122
    xor ch, ch                                ; 30 ed                       ; 0xc1125
    imul cx, cx, 00097h                       ; 69 c9 97 00                 ; 0xc1127
    add cx, word [bp-00ah]                    ; 03 4e f6                    ; 0xc112b
    xor ah, ah                                ; 30 e4                       ; 0xc112e
    imul ax, ax, strict byte 0001ch           ; 6b c0 1c                    ; 0xc1130
    add cx, ax                                ; 01 c1                       ; 0xc1133
    add cx, 00080h                            ; 81 c1 80 00                 ; 0xc1135
    sar cx, 008h                              ; c1 f9 08                    ; 0xc1139
    cmp cx, strict byte 0003fh                ; 83 f9 3f                    ; 0xc113c vgabios.c:706
    jbe short 01144h                          ; 76 03                       ; 0xc113f
    mov cx, strict word 0003fh                ; b9 3f 00                    ; 0xc1141
    mov al, bl                                ; 88 d8                       ; 0xc1144 vgabios.c:709
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc1146
    out DX, AL                                ; ee                          ; 0xc1149
    mov al, cl                                ; 88 c8                       ; 0xc114a vgabios.c:711
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc114c
    out DX, AL                                ; ee                          ; 0xc114f
    out DX, AL                                ; ee                          ; 0xc1150 vgabios.c:712
    out DX, AL                                ; ee                          ; 0xc1151 vgabios.c:713
    inc bx                                    ; 43                          ; 0xc1152 vgabios.c:714
    inc si                                    ; 46                          ; 0xc1153 vgabios.c:715
    jmp short 010ffh                          ; eb a9                       ; 0xc1154
    mov dx, 003dah                            ; ba da 03                    ; 0xc1156 vgabios.c:716
    in AL, DX                                 ; ec                          ; 0xc1159
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc115a
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc115c vgabios.c:717
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc115e
    out DX, AL                                ; ee                          ; 0xc1161
    mov dx, 003dah                            ; ba da 03                    ; 0xc1162 vgabios.c:719
    in AL, DX                                 ; ec                          ; 0xc1165
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1166
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc1168 vgabios.c:721
    pop di                                    ; 5f                          ; 0xc116b
    pop si                                    ; 5e                          ; 0xc116c
    pop cx                                    ; 59                          ; 0xc116d
    pop bx                                    ; 5b                          ; 0xc116e
    pop bp                                    ; 5d                          ; 0xc116f
    retn                                      ; c3                          ; 0xc1170
  ; disGetNextSymbol 0xc1171 LB 0x3350 -> off=0x0 cb=0000000000000107 uValue=00000000000c1171 'biosfn_set_cursor_shape'
biosfn_set_cursor_shape:                     ; 0xc1171 LB 0x107
    push bp                                   ; 55                          ; 0xc1171 vgabios.c:724
    mov bp, sp                                ; 89 e5                       ; 0xc1172
    push bx                                   ; 53                          ; 0xc1174
    push cx                                   ; 51                          ; 0xc1175
    push si                                   ; 56                          ; 0xc1176
    push ax                                   ; 50                          ; 0xc1177
    push ax                                   ; 50                          ; 0xc1178
    mov bl, al                                ; 88 c3                       ; 0xc1179
    mov ah, dl                                ; 88 d4                       ; 0xc117b
    mov dl, al                                ; 88 c2                       ; 0xc117d vgabios.c:730
    xor dh, dh                                ; 30 f6                       ; 0xc117f
    mov cx, dx                                ; 89 d1                       ; 0xc1181
    sal cx, 008h                              ; c1 e1 08                    ; 0xc1183
    mov dl, ah                                ; 88 e2                       ; 0xc1186
    add dx, cx                                ; 01 ca                       ; 0xc1188
    mov si, strict word 00060h                ; be 60 00                    ; 0xc118a vgabios.c:62
    mov cx, strict word 00040h                ; b9 40 00                    ; 0xc118d
    mov es, cx                                ; 8e c1                       ; 0xc1190
    mov word [es:si], dx                      ; 26 89 14                    ; 0xc1192
    mov si, 00087h                            ; be 87 00                    ; 0xc1195 vgabios.c:47
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc1198
    test dl, 008h                             ; f6 c2 08                    ; 0xc119b vgabios.c:48
    jne short 011ddh                          ; 75 3d                       ; 0xc119e
    mov dl, al                                ; 88 c2                       ; 0xc11a0 vgabios.c:736
    and dl, 060h                              ; 80 e2 60                    ; 0xc11a2
    cmp dl, 020h                              ; 80 fa 20                    ; 0xc11a5
    jne short 011b0h                          ; 75 06                       ; 0xc11a8
    mov BL, strict byte 01eh                  ; b3 1e                       ; 0xc11aa vgabios.c:738
    xor ah, ah                                ; 30 e4                       ; 0xc11ac vgabios.c:739
    jmp short 011ddh                          ; eb 2d                       ; 0xc11ae vgabios.c:740
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc11b0 vgabios.c:47
    test dl, 001h                             ; f6 c2 01                    ; 0xc11b3 vgabios.c:48
    jne short 01212h                          ; 75 5a                       ; 0xc11b6
    cmp bl, 020h                              ; 80 fb 20                    ; 0xc11b8
    jnc short 01212h                          ; 73 55                       ; 0xc11bb
    cmp ah, 020h                              ; 80 fc 20                    ; 0xc11bd
    jnc short 01212h                          ; 73 50                       ; 0xc11c0
    mov si, 00085h                            ; be 85 00                    ; 0xc11c2 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc11c5
    mov es, dx                                ; 8e c2                       ; 0xc11c8
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc11ca
    mov dx, cx                                ; 89 ca                       ; 0xc11cd vgabios.c:58
    cmp ah, bl                                ; 38 dc                       ; 0xc11cf vgabios.c:751
    jnc short 011dfh                          ; 73 0c                       ; 0xc11d1
    test ah, ah                               ; 84 e4                       ; 0xc11d3 vgabios.c:753
    je short 01212h                           ; 74 3b                       ; 0xc11d5
    xor bl, bl                                ; 30 db                       ; 0xc11d7 vgabios.c:754
    mov ah, cl                                ; 88 cc                       ; 0xc11d9 vgabios.c:755
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc11db
    jmp short 01212h                          ; eb 33                       ; 0xc11dd vgabios.c:757
    mov byte [bp-008h], ah                    ; 88 66 f8                    ; 0xc11df vgabios.c:758
    xor al, al                                ; 30 c0                       ; 0xc11e2
    mov byte [bp-007h], al                    ; 88 46 f9                    ; 0xc11e4
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc11e7
    mov byte [bp-009h], al                    ; 88 46 f7                    ; 0xc11ea
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc11ed
    or si, word [bp-00ah]                     ; 0b 76 f6                    ; 0xc11f0
    cmp si, cx                                ; 39 ce                       ; 0xc11f3
    jnc short 01214h                          ; 73 1d                       ; 0xc11f5
    mov byte [bp-00ah], ah                    ; 88 66 f6                    ; 0xc11f7
    mov byte [bp-009h], al                    ; 88 46 f7                    ; 0xc11fa
    mov si, cx                                ; 89 ce                       ; 0xc11fd
    dec si                                    ; 4e                          ; 0xc11ff
    cmp si, word [bp-00ah]                    ; 3b 76 f6                    ; 0xc1200
    je short 0124eh                           ; 74 49                       ; 0xc1203
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc1205
    mov byte [bp-007h], al                    ; 88 46 f9                    ; 0xc1208
    dec cx                                    ; 49                          ; 0xc120b
    dec cx                                    ; 49                          ; 0xc120c
    cmp cx, word [bp-008h]                    ; 3b 4e f8                    ; 0xc120d
    jne short 01214h                          ; 75 02                       ; 0xc1210
    jmp short 0124eh                          ; eb 3a                       ; 0xc1212
    cmp ah, 003h                              ; 80 fc 03                    ; 0xc1214 vgabios.c:760
    jbe short 0124eh                          ; 76 35                       ; 0xc1217
    mov cl, bl                                ; 88 d9                       ; 0xc1219 vgabios.c:761
    xor ch, ch                                ; 30 ed                       ; 0xc121b
    mov byte [bp-00ah], ah                    ; 88 66 f6                    ; 0xc121d
    mov byte [bp-009h], ch                    ; 88 6e f7                    ; 0xc1220
    mov si, cx                                ; 89 ce                       ; 0xc1223
    inc si                                    ; 46                          ; 0xc1225
    inc si                                    ; 46                          ; 0xc1226
    mov cl, dl                                ; 88 d1                       ; 0xc1227
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc1229
    cmp si, word [bp-00ah]                    ; 3b 76 f6                    ; 0xc122b
    jl short 01243h                           ; 7c 13                       ; 0xc122e
    sub bl, ah                                ; 28 e3                       ; 0xc1230 vgabios.c:763
    add bl, dl                                ; 00 d3                       ; 0xc1232
    db  0feh, 0cbh
    ; dec bl                                    ; fe cb                     ; 0xc1234
    mov ah, cl                                ; 88 cc                       ; 0xc1236 vgabios.c:764
    cmp dx, strict byte 0000eh                ; 83 fa 0e                    ; 0xc1238 vgabios.c:765
    jc short 0124eh                           ; 72 11                       ; 0xc123b
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc123d vgabios.c:767
    db  0feh, 0cbh
    ; dec bl                                    ; fe cb                     ; 0xc123f vgabios.c:768
    jmp short 0124eh                          ; eb 0b                       ; 0xc1241 vgabios.c:770
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc1243
    jbe short 0124ch                          ; 76 04                       ; 0xc1246
    shr dx, 1                                 ; d1 ea                       ; 0xc1248 vgabios.c:772
    mov bl, dl                                ; 88 d3                       ; 0xc124a
    mov ah, cl                                ; 88 cc                       ; 0xc124c vgabios.c:776
    mov si, strict word 00063h                ; be 63 00                    ; 0xc124e vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1251
    mov es, dx                                ; 8e c2                       ; 0xc1254
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc1256
    mov AL, strict byte 00ah                  ; b0 0a                       ; 0xc1259 vgabios.c:787
    mov dx, cx                                ; 89 ca                       ; 0xc125b
    out DX, AL                                ; ee                          ; 0xc125d
    mov si, cx                                ; 89 ce                       ; 0xc125e vgabios.c:788
    inc si                                    ; 46                          ; 0xc1260
    mov al, bl                                ; 88 d8                       ; 0xc1261
    mov dx, si                                ; 89 f2                       ; 0xc1263
    out DX, AL                                ; ee                          ; 0xc1265
    mov AL, strict byte 00bh                  ; b0 0b                       ; 0xc1266 vgabios.c:789
    mov dx, cx                                ; 89 ca                       ; 0xc1268
    out DX, AL                                ; ee                          ; 0xc126a
    mov al, ah                                ; 88 e0                       ; 0xc126b vgabios.c:790
    mov dx, si                                ; 89 f2                       ; 0xc126d
    out DX, AL                                ; ee                          ; 0xc126f
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc1270 vgabios.c:791
    pop si                                    ; 5e                          ; 0xc1273
    pop cx                                    ; 59                          ; 0xc1274
    pop bx                                    ; 5b                          ; 0xc1275
    pop bp                                    ; 5d                          ; 0xc1276
    retn                                      ; c3                          ; 0xc1277
  ; disGetNextSymbol 0xc1278 LB 0x3249 -> off=0x0 cb=0000000000000078 uValue=00000000000c1278 'biosfn_set_cursor_pos'
biosfn_set_cursor_pos:                       ; 0xc1278 LB 0x78
    push bp                                   ; 55                          ; 0xc1278 vgabios.c:794
    mov bp, sp                                ; 89 e5                       ; 0xc1279
    push bx                                   ; 53                          ; 0xc127b
    push cx                                   ; 51                          ; 0xc127c
    push si                                   ; 56                          ; 0xc127d
    mov bx, dx                                ; 89 d3                       ; 0xc127e
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc1280 vgabios.c:800
    jnbe short 012e8h                         ; 77 64                       ; 0xc1282
    mov cl, al                                ; 88 c1                       ; 0xc1284 vgabios.c:803
    xor ch, ch                                ; 30 ed                       ; 0xc1286
    mov si, cx                                ; 89 ce                       ; 0xc1288
    add si, cx                                ; 01 ce                       ; 0xc128a
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc128c
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc128f vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc1292
    mov word [es:si], bx                      ; 26 89 1c                    ; 0xc1294
    mov si, strict word 00062h                ; be 62 00                    ; 0xc1297 vgabios.c:47
    mov ah, byte [es:si]                      ; 26 8a 24                    ; 0xc129a
    cmp al, ah                                ; 38 e0                       ; 0xc129d vgabios.c:807
    jne short 012e8h                          ; 75 47                       ; 0xc129f
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc12a1 vgabios.c:57
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc12a4
    mov ax, bx                                ; 89 d8                       ; 0xc12a7 vgabios.c:812
    xor al, al                                ; 30 c0                       ; 0xc12a9
    shr ax, 008h                              ; c1 e8 08                    ; 0xc12ab
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc12ae vgabios.c:57
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc12b1
    shr cx, 1                                 ; d1 e9                       ; 0xc12b4 vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc12b6 vgabios.c:817
    mul dx                                    ; f7 e2                       ; 0xc12b8
    mov si, ax                                ; 89 c6                       ; 0xc12ba
    mov al, bl                                ; 88 d8                       ; 0xc12bc
    xor ah, ah                                ; 30 e4                       ; 0xc12be
    add ax, si                                ; 01 f0                       ; 0xc12c0
    add cx, ax                                ; 01 c1                       ; 0xc12c2
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc12c4 vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc12c7
    mov AL, strict byte 00eh                  ; b0 0e                       ; 0xc12ca vgabios.c:821
    mov dx, bx                                ; 89 da                       ; 0xc12cc
    out DX, AL                                ; ee                          ; 0xc12ce
    mov ax, cx                                ; 89 c8                       ; 0xc12cf vgabios.c:822
    xor al, cl                                ; 30 c8                       ; 0xc12d1
    shr ax, 008h                              ; c1 e8 08                    ; 0xc12d3
    lea si, [bx+001h]                         ; 8d 77 01                    ; 0xc12d6
    mov dx, si                                ; 89 f2                       ; 0xc12d9
    out DX, AL                                ; ee                          ; 0xc12db
    mov AL, strict byte 00fh                  ; b0 0f                       ; 0xc12dc vgabios.c:823
    mov dx, bx                                ; 89 da                       ; 0xc12de
    out DX, AL                                ; ee                          ; 0xc12e0
    xor ch, ch                                ; 30 ed                       ; 0xc12e1 vgabios.c:824
    mov ax, cx                                ; 89 c8                       ; 0xc12e3
    mov dx, si                                ; 89 f2                       ; 0xc12e5
    out DX, AL                                ; ee                          ; 0xc12e7
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc12e8 vgabios.c:826
    pop si                                    ; 5e                          ; 0xc12eb
    pop cx                                    ; 59                          ; 0xc12ec
    pop bx                                    ; 5b                          ; 0xc12ed
    pop bp                                    ; 5d                          ; 0xc12ee
    retn                                      ; c3                          ; 0xc12ef
  ; disGetNextSymbol 0xc12f0 LB 0x31d1 -> off=0x0 cb=00000000000000a1 uValue=00000000000c12f0 'biosfn_set_active_page'
biosfn_set_active_page:                      ; 0xc12f0 LB 0xa1
    push bp                                   ; 55                          ; 0xc12f0 vgabios.c:829
    mov bp, sp                                ; 89 e5                       ; 0xc12f1
    push bx                                   ; 53                          ; 0xc12f3
    push cx                                   ; 51                          ; 0xc12f4
    push dx                                   ; 52                          ; 0xc12f5
    push si                                   ; 56                          ; 0xc12f6
    push di                                   ; 57                          ; 0xc12f7
    push ax                                   ; 50                          ; 0xc12f8
    push ax                                   ; 50                          ; 0xc12f9
    mov cl, al                                ; 88 c1                       ; 0xc12fa
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc12fc vgabios.c:835
    jnbe short 01316h                         ; 77 16                       ; 0xc12fe
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc1300 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1303
    mov es, ax                                ; 8e c0                       ; 0xc1306
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1308
    xor ah, ah                                ; 30 e4                       ; 0xc130b vgabios.c:839
    call 0379eh                               ; e8 8e 24                    ; 0xc130d
    mov ch, al                                ; 88 c5                       ; 0xc1310
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc1312 vgabios.c:840
    jne short 01318h                          ; 75 02                       ; 0xc1314
    jmp short 01387h                          ; eb 6f                       ; 0xc1316
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc1318 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc131b
    mov es, ax                                ; 8e c0                       ; 0xc131e
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc1320
    mov dl, cl                                ; 88 ca                       ; 0xc1323 vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc1325
    mul dx                                    ; f7 e2                       ; 0xc1327
    mov bx, ax                                ; 89 c3                       ; 0xc1329
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc132b vgabios.c:62
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc132e
    mov al, ch                                ; 88 e8                       ; 0xc1331 vgabios.c:845
    xor ah, ah                                ; 30 e4                       ; 0xc1333
    mov si, ax                                ; 89 c6                       ; 0xc1335
    sal si, 003h                              ; c1 e6 03                    ; 0xc1337
    cmp byte [si+047adh], 000h                ; 80 bc ad 47 00              ; 0xc133a
    jne short 01343h                          ; 75 02                       ; 0xc133f
    shr bx, 1                                 ; d1 eb                       ; 0xc1341 vgabios.c:846
    mov si, strict word 00063h                ; be 63 00                    ; 0xc1343 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1346
    mov es, ax                                ; 8e c0                       ; 0xc1349
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc134b
    mov AL, strict byte 00ch                  ; b0 0c                       ; 0xc134e vgabios.c:850
    mov dx, si                                ; 89 f2                       ; 0xc1350
    out DX, AL                                ; ee                          ; 0xc1352
    mov ax, bx                                ; 89 d8                       ; 0xc1353 vgabios.c:851
    xor al, bl                                ; 30 d8                       ; 0xc1355
    shr ax, 008h                              ; c1 e8 08                    ; 0xc1357
    lea di, [si+001h]                         ; 8d 7c 01                    ; 0xc135a
    mov dx, di                                ; 89 fa                       ; 0xc135d
    out DX, AL                                ; ee                          ; 0xc135f
    mov AL, strict byte 00dh                  ; b0 0d                       ; 0xc1360 vgabios.c:852
    mov dx, si                                ; 89 f2                       ; 0xc1362
    out DX, AL                                ; ee                          ; 0xc1364
    xor bh, bh                                ; 30 ff                       ; 0xc1365 vgabios.c:853
    mov ax, bx                                ; 89 d8                       ; 0xc1367
    mov dx, di                                ; 89 fa                       ; 0xc1369
    out DX, AL                                ; ee                          ; 0xc136b
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc136c vgabios.c:52
    mov byte [es:bx], cl                      ; 26 88 0f                    ; 0xc136f
    xor ch, ch                                ; 30 ed                       ; 0xc1372 vgabios.c:863
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc1374
    lea dx, [bp-00ch]                         ; 8d 56 f4                    ; 0xc1377
    mov ax, cx                                ; 89 c8                       ; 0xc137a
    call 00a96h                               ; e8 17 f7                    ; 0xc137c
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc137f vgabios.c:865
    mov ax, cx                                ; 89 c8                       ; 0xc1382
    call 01278h                               ; e8 f1 fe                    ; 0xc1384
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc1387 vgabios.c:866
    pop di                                    ; 5f                          ; 0xc138a
    pop si                                    ; 5e                          ; 0xc138b
    pop dx                                    ; 5a                          ; 0xc138c
    pop cx                                    ; 59                          ; 0xc138d
    pop bx                                    ; 5b                          ; 0xc138e
    pop bp                                    ; 5d                          ; 0xc138f
    retn                                      ; c3                          ; 0xc1390
  ; disGetNextSymbol 0xc1391 LB 0x3130 -> off=0x0 cb=0000000000000045 uValue=00000000000c1391 'find_vpti'
find_vpti:                                   ; 0xc1391 LB 0x45
    push bx                                   ; 53                          ; 0xc1391 vgabios.c:901
    push si                                   ; 56                          ; 0xc1392
    push bp                                   ; 55                          ; 0xc1393
    mov bp, sp                                ; 89 e5                       ; 0xc1394
    mov bl, al                                ; 88 c3                       ; 0xc1396 vgabios.c:906
    xor bh, bh                                ; 30 ff                       ; 0xc1398
    mov si, bx                                ; 89 de                       ; 0xc139a
    sal si, 003h                              ; c1 e6 03                    ; 0xc139c
    cmp byte [si+047adh], 000h                ; 80 bc ad 47 00              ; 0xc139f
    jne short 013cch                          ; 75 26                       ; 0xc13a4
    mov si, 00089h                            ; be 89 00                    ; 0xc13a6 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc13a9
    mov es, ax                                ; 8e c0                       ; 0xc13ac
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc13ae
    test AL, strict byte 010h                 ; a8 10                       ; 0xc13b1 vgabios.c:908
    je short 013bbh                           ; 74 06                       ; 0xc13b3
    mov al, byte [bx+07df3h]                  ; 8a 87 f3 7d                 ; 0xc13b5 vgabios.c:909
    jmp short 013c9h                          ; eb 0e                       ; 0xc13b9 vgabios.c:910
    test AL, strict byte 080h                 ; a8 80                       ; 0xc13bb
    je short 013c5h                           ; 74 06                       ; 0xc13bd
    mov al, byte [bx+07de3h]                  ; 8a 87 e3 7d                 ; 0xc13bf vgabios.c:911
    jmp short 013c9h                          ; eb 04                       ; 0xc13c3 vgabios.c:912
    mov al, byte [bx+07debh]                  ; 8a 87 eb 7d                 ; 0xc13c5 vgabios.c:913
    cbw                                       ; 98                          ; 0xc13c9
    jmp short 013d2h                          ; eb 06                       ; 0xc13ca vgabios.c:914
    mov al, byte [bx+0482ch]                  ; 8a 87 2c 48                 ; 0xc13cc vgabios.c:915
    xor ah, ah                                ; 30 e4                       ; 0xc13d0
    pop bp                                    ; 5d                          ; 0xc13d2 vgabios.c:918
    pop si                                    ; 5e                          ; 0xc13d3
    pop bx                                    ; 5b                          ; 0xc13d4
    retn                                      ; c3                          ; 0xc13d5
  ; disGetNextSymbol 0xc13d6 LB 0x30eb -> off=0x0 cb=00000000000004da uValue=00000000000c13d6 'biosfn_set_video_mode'
biosfn_set_video_mode:                       ; 0xc13d6 LB 0x4da
    push bp                                   ; 55                          ; 0xc13d6 vgabios.c:923
    mov bp, sp                                ; 89 e5                       ; 0xc13d7
    push bx                                   ; 53                          ; 0xc13d9
    push cx                                   ; 51                          ; 0xc13da
    push dx                                   ; 52                          ; 0xc13db
    push si                                   ; 56                          ; 0xc13dc
    push di                                   ; 57                          ; 0xc13dd
    sub sp, strict byte 00018h                ; 83 ec 18                    ; 0xc13de
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc13e1
    and AL, strict byte 080h                  ; 24 80                       ; 0xc13e4 vgabios.c:927
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc13e6
    call 007c8h                               ; e8 dc f3                    ; 0xc13e9 vgabios.c:937
    test ax, ax                               ; 85 c0                       ; 0xc13ec
    je short 013fch                           ; 74 0c                       ; 0xc13ee
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc13f0 vgabios.c:939
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc13f2
    out DX, AL                                ; ee                          ; 0xc13f5
    xor al, al                                ; 30 c0                       ; 0xc13f6 vgabios.c:940
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc13f8
    out DX, AL                                ; ee                          ; 0xc13fb
    and byte [bp-00ch], 07fh                  ; 80 66 f4 7f                 ; 0xc13fc vgabios.c:945
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1400 vgabios.c:951
    xor ah, ah                                ; 30 e4                       ; 0xc1403
    call 0379eh                               ; e8 96 23                    ; 0xc1405
    mov cl, al                                ; 88 c1                       ; 0xc1408
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc140a
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc140d vgabios.c:957
    je short 0147ch                           ; 74 6b                       ; 0xc140f
    mov bx, 000a8h                            ; bb a8 00                    ; 0xc1411 vgabios.c:67
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1414
    mov es, ax                                ; 8e c0                       ; 0xc1417
    mov di, word [es:bx]                      ; 26 8b 3f                    ; 0xc1419
    mov ax, word [es:bx+002h]                 ; 26 8b 47 02                 ; 0xc141c
    mov bx, di                                ; 89 fb                       ; 0xc1420 vgabios.c:68
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc1422
    xor ch, ch                                ; 30 ed                       ; 0xc1425 vgabios.c:963
    mov ax, cx                                ; 89 c8                       ; 0xc1427
    call 01391h                               ; e8 65 ff                    ; 0xc1429
    mov es, [bp-01eh]                         ; 8e 46 e2                    ; 0xc142c vgabios.c:964
    mov si, word [es:di]                      ; 26 8b 35                    ; 0xc142f
    mov dx, word [es:di+002h]                 ; 26 8b 55 02                 ; 0xc1432
    mov word [bp-016h], dx                    ; 89 56 ea                    ; 0xc1436
    xor ah, ah                                ; 30 e4                       ; 0xc1439 vgabios.c:965
    sal ax, 006h                              ; c1 e0 06                    ; 0xc143b
    add si, ax                                ; 01 c6                       ; 0xc143e
    mov di, 00089h                            ; bf 89 00                    ; 0xc1440 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1443
    mov es, ax                                ; 8e c0                       ; 0xc1446
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc1448
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc144b vgabios.c:48
    test AL, strict byte 008h                 ; a8 08                       ; 0xc144e vgabios.c:982
    jne short 01498h                          ; 75 46                       ; 0xc1450
    mov di, cx                                ; 89 cf                       ; 0xc1452 vgabios.c:984
    sal di, 003h                              ; c1 e7 03                    ; 0xc1454
    mov al, byte [di+047b2h]                  ; 8a 85 b2 47                 ; 0xc1457
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc145b
    out DX, AL                                ; ee                          ; 0xc145e
    xor al, al                                ; 30 c0                       ; 0xc145f vgabios.c:987
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc1461
    out DX, AL                                ; ee                          ; 0xc1464
    mov cl, byte [di+047b3h]                  ; 8a 8d b3 47                 ; 0xc1465 vgabios.c:990
    cmp cl, 001h                              ; 80 f9 01                    ; 0xc1469
    jc short 0147fh                           ; 72 11                       ; 0xc146c
    jbe short 0148ah                          ; 76 1a                       ; 0xc146e
    cmp cl, 003h                              ; 80 f9 03                    ; 0xc1470
    je short 0149bh                           ; 74 26                       ; 0xc1473
    cmp cl, 002h                              ; 80 f9 02                    ; 0xc1475
    je short 01491h                           ; 74 17                       ; 0xc1478
    jmp short 014a0h                          ; eb 24                       ; 0xc147a
    jmp near 018a6h                           ; e9 27 04                    ; 0xc147c
    test cl, cl                               ; 84 c9                       ; 0xc147f
    jne short 014a0h                          ; 75 1d                       ; 0xc1481
    mov word [bp-01ah], 04fc0h                ; c7 46 e6 c0 4f              ; 0xc1483 vgabios.c:992
    jmp short 014a0h                          ; eb 16                       ; 0xc1488 vgabios.c:993
    mov word [bp-01ah], 05080h                ; c7 46 e6 80 50              ; 0xc148a vgabios.c:995
    jmp short 014a0h                          ; eb 0f                       ; 0xc148f vgabios.c:996
    mov word [bp-01ah], 05140h                ; c7 46 e6 40 51              ; 0xc1491 vgabios.c:998
    jmp short 014a0h                          ; eb 08                       ; 0xc1496 vgabios.c:999
    jmp near 0158ch                           ; e9 f1 00                    ; 0xc1498
    mov word [bp-01ah], 05200h                ; c7 46 e6 00 52              ; 0xc149b vgabios.c:1001
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc14a0 vgabios.c:1005
    xor ah, ah                                ; 30 e4                       ; 0xc14a3
    mov di, ax                                ; 89 c7                       ; 0xc14a5
    sal di, 003h                              ; c1 e7 03                    ; 0xc14a7
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc14aa
    jne short 014c0h                          ; 75 0f                       ; 0xc14af
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc14b1 vgabios.c:1007
    cmp byte [es:si+002h], 008h               ; 26 80 7c 02 08              ; 0xc14b4
    jne short 014c0h                          ; 75 05                       ; 0xc14b9
    mov word [bp-01ah], 05080h                ; c7 46 e6 80 50              ; 0xc14bb vgabios.c:1008
    xor cx, cx                                ; 31 c9                       ; 0xc14c0 vgabios.c:1011
    jmp short 014d3h                          ; eb 0f                       ; 0xc14c2
    xor al, al                                ; 30 c0                       ; 0xc14c4 vgabios.c:1018
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc14c6
    out DX, AL                                ; ee                          ; 0xc14c9
    out DX, AL                                ; ee                          ; 0xc14ca vgabios.c:1019
    out DX, AL                                ; ee                          ; 0xc14cb vgabios.c:1020
    inc cx                                    ; 41                          ; 0xc14cc vgabios.c:1022
    cmp cx, 00100h                            ; 81 f9 00 01                 ; 0xc14cd
    jnc short 01501h                          ; 73 2e                       ; 0xc14d1
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc14d3
    xor ah, ah                                ; 30 e4                       ; 0xc14d6
    mov di, ax                                ; 89 c7                       ; 0xc14d8
    sal di, 003h                              ; c1 e7 03                    ; 0xc14da
    mov al, byte [di+047b3h]                  ; 8a 85 b3 47                 ; 0xc14dd
    mov di, ax                                ; 89 c7                       ; 0xc14e1
    mov al, byte [di+0483ch]                  ; 8a 85 3c 48                 ; 0xc14e3
    cmp cx, ax                                ; 39 c1                       ; 0xc14e7
    jnbe short 014c4h                         ; 77 d9                       ; 0xc14e9
    imul di, cx, strict byte 00003h           ; 6b f9 03                    ; 0xc14eb
    add di, word [bp-01ah]                    ; 03 7e e6                    ; 0xc14ee
    mov al, byte [di]                         ; 8a 05                       ; 0xc14f1
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc14f3
    out DX, AL                                ; ee                          ; 0xc14f6
    mov al, byte [di+001h]                    ; 8a 45 01                    ; 0xc14f7
    out DX, AL                                ; ee                          ; 0xc14fa
    mov al, byte [di+002h]                    ; 8a 45 02                    ; 0xc14fb
    out DX, AL                                ; ee                          ; 0xc14fe
    jmp short 014cch                          ; eb cb                       ; 0xc14ff
    test byte [bp-010h], 002h                 ; f6 46 f0 02                 ; 0xc1501 vgabios.c:1023
    je short 0150fh                           ; 74 08                       ; 0xc1505
    mov dx, 00100h                            ; ba 00 01                    ; 0xc1507 vgabios.c:1025
    xor ax, ax                                ; 31 c0                       ; 0xc150a
    call 010e4h                               ; e8 d5 fb                    ; 0xc150c
    mov dx, 003dah                            ; ba da 03                    ; 0xc150f vgabios.c:1029
    in AL, DX                                 ; ec                          ; 0xc1512
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1513
    xor cx, cx                                ; 31 c9                       ; 0xc1515 vgabios.c:1032
    jmp short 0151eh                          ; eb 05                       ; 0xc1517
    cmp cx, strict byte 00013h                ; 83 f9 13                    ; 0xc1519
    jnbe short 01533h                         ; 77 15                       ; 0xc151c
    mov al, cl                                ; 88 c8                       ; 0xc151e vgabios.c:1033
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc1520
    out DX, AL                                ; ee                          ; 0xc1523
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc1524 vgabios.c:1034
    mov di, si                                ; 89 f7                       ; 0xc1527
    add di, cx                                ; 01 cf                       ; 0xc1529
    mov al, byte [es:di+023h]                 ; 26 8a 45 23                 ; 0xc152b
    out DX, AL                                ; ee                          ; 0xc152f
    inc cx                                    ; 41                          ; 0xc1530 vgabios.c:1035
    jmp short 01519h                          ; eb e6                       ; 0xc1531
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc1533 vgabios.c:1036
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc1535
    out DX, AL                                ; ee                          ; 0xc1538
    xor al, al                                ; 30 c0                       ; 0xc1539 vgabios.c:1037
    out DX, AL                                ; ee                          ; 0xc153b
    mov es, [bp-01eh]                         ; 8e 46 e2                    ; 0xc153c vgabios.c:1040
    mov dx, word [es:bx+004h]                 ; 26 8b 57 04                 ; 0xc153f
    mov ax, word [es:bx+006h]                 ; 26 8b 47 06                 ; 0xc1543
    test ax, ax                               ; 85 c0                       ; 0xc1547
    jne short 0154fh                          ; 75 04                       ; 0xc1549
    test dx, dx                               ; 85 d2                       ; 0xc154b
    je short 0158ch                           ; 74 3d                       ; 0xc154d
    mov word [bp-01ch], ax                    ; 89 46 e4                    ; 0xc154f vgabios.c:1044
    xor cx, cx                                ; 31 c9                       ; 0xc1552 vgabios.c:1045
    jmp short 0155bh                          ; eb 05                       ; 0xc1554
    cmp cx, strict byte 00010h                ; 83 f9 10                    ; 0xc1556
    jnc short 0157ch                          ; 73 21                       ; 0xc1559
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc155b vgabios.c:1046
    mov di, si                                ; 89 f7                       ; 0xc155e
    add di, cx                                ; 01 cf                       ; 0xc1560
    mov ax, word [bp-01ch]                    ; 8b 46 e4                    ; 0xc1562
    mov word [bp-020h], ax                    ; 89 46 e0                    ; 0xc1565
    mov ax, dx                                ; 89 d0                       ; 0xc1568
    add ax, cx                                ; 01 c8                       ; 0xc156a
    mov word [bp-022h], ax                    ; 89 46 de                    ; 0xc156c
    mov al, byte [es:di+023h]                 ; 26 8a 45 23                 ; 0xc156f
    les di, [bp-022h]                         ; c4 7e de                    ; 0xc1573
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc1576
    inc cx                                    ; 41                          ; 0xc1579
    jmp short 01556h                          ; eb da                       ; 0xc157a
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc157c vgabios.c:1047
    mov al, byte [es:si+034h]                 ; 26 8a 44 34                 ; 0xc157f
    mov es, [bp-01ch]                         ; 8e 46 e4                    ; 0xc1583
    mov di, dx                                ; 89 d7                       ; 0xc1586
    mov byte [es:di+010h], al                 ; 26 88 45 10                 ; 0xc1588
    xor al, al                                ; 30 c0                       ; 0xc158c vgabios.c:1052
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc158e
    out DX, AL                                ; ee                          ; 0xc1591
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc1592 vgabios.c:1053
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc1594
    out DX, AL                                ; ee                          ; 0xc1597
    mov cx, strict word 00001h                ; b9 01 00                    ; 0xc1598 vgabios.c:1054
    jmp short 015a2h                          ; eb 05                       ; 0xc159b
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc159d
    jnbe short 015bah                         ; 77 18                       ; 0xc15a0
    mov al, cl                                ; 88 c8                       ; 0xc15a2 vgabios.c:1055
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc15a4
    out DX, AL                                ; ee                          ; 0xc15a7
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc15a8 vgabios.c:1056
    mov di, si                                ; 89 f7                       ; 0xc15ab
    add di, cx                                ; 01 cf                       ; 0xc15ad
    mov al, byte [es:di+004h]                 ; 26 8a 45 04                 ; 0xc15af
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc15b3
    out DX, AL                                ; ee                          ; 0xc15b6
    inc cx                                    ; 41                          ; 0xc15b7 vgabios.c:1057
    jmp short 0159dh                          ; eb e3                       ; 0xc15b8
    xor cx, cx                                ; 31 c9                       ; 0xc15ba vgabios.c:1060
    jmp short 015c3h                          ; eb 05                       ; 0xc15bc
    cmp cx, strict byte 00008h                ; 83 f9 08                    ; 0xc15be
    jnbe short 015dbh                         ; 77 18                       ; 0xc15c1
    mov al, cl                                ; 88 c8                       ; 0xc15c3 vgabios.c:1061
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc15c5
    out DX, AL                                ; ee                          ; 0xc15c8
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc15c9 vgabios.c:1062
    mov di, si                                ; 89 f7                       ; 0xc15cc
    add di, cx                                ; 01 cf                       ; 0xc15ce
    mov al, byte [es:di+037h]                 ; 26 8a 45 37                 ; 0xc15d0
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc15d4
    out DX, AL                                ; ee                          ; 0xc15d7
    inc cx                                    ; 41                          ; 0xc15d8 vgabios.c:1063
    jmp short 015beh                          ; eb e3                       ; 0xc15d9
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc15db vgabios.c:1066
    xor ah, ah                                ; 30 e4                       ; 0xc15de
    mov di, ax                                ; 89 c7                       ; 0xc15e0
    sal di, 003h                              ; c1 e7 03                    ; 0xc15e2
    cmp byte [di+047aeh], 001h                ; 80 bd ae 47 01              ; 0xc15e5
    jne short 015f1h                          ; 75 05                       ; 0xc15ea
    mov cx, 003b4h                            ; b9 b4 03                    ; 0xc15ec
    jmp short 015f4h                          ; eb 03                       ; 0xc15ef
    mov cx, 003d4h                            ; b9 d4 03                    ; 0xc15f1
    mov word [bp-014h], cx                    ; 89 4e ec                    ; 0xc15f4
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc15f7 vgabios.c:1069
    mov al, byte [es:si+009h]                 ; 26 8a 44 09                 ; 0xc15fa
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc15fe
    out DX, AL                                ; ee                          ; 0xc1601
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc1602 vgabios.c:1072
    mov dx, cx                                ; 89 ca                       ; 0xc1605
    out DX, ax                                ; ef                          ; 0xc1607
    xor cx, cx                                ; 31 c9                       ; 0xc1608 vgabios.c:1074
    jmp short 01611h                          ; eb 05                       ; 0xc160a
    cmp cx, strict byte 00018h                ; 83 f9 18                    ; 0xc160c
    jnbe short 01627h                         ; 77 16                       ; 0xc160f
    mov al, cl                                ; 88 c8                       ; 0xc1611 vgabios.c:1075
    mov dx, word [bp-014h]                    ; 8b 56 ec                    ; 0xc1613
    out DX, AL                                ; ee                          ; 0xc1616
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc1617 vgabios.c:1076
    mov di, si                                ; 89 f7                       ; 0xc161a
    add di, cx                                ; 01 cf                       ; 0xc161c
    inc dx                                    ; 42                          ; 0xc161e
    mov al, byte [es:di+00ah]                 ; 26 8a 45 0a                 ; 0xc161f
    out DX, AL                                ; ee                          ; 0xc1623
    inc cx                                    ; 41                          ; 0xc1624 vgabios.c:1077
    jmp short 0160ch                          ; eb e5                       ; 0xc1625
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc1627 vgabios.c:1080
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc1629
    out DX, AL                                ; ee                          ; 0xc162c
    mov dx, word [bp-014h]                    ; 8b 56 ec                    ; 0xc162d vgabios.c:1081
    add dx, strict byte 00006h                ; 83 c2 06                    ; 0xc1630
    in AL, DX                                 ; ec                          ; 0xc1633
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1634
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1636 vgabios.c:1083
    jne short 0169bh                          ; 75 5f                       ; 0xc163a
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc163c vgabios.c:1085
    xor ah, ah                                ; 30 e4                       ; 0xc163f
    mov di, ax                                ; 89 c7                       ; 0xc1641
    sal di, 003h                              ; c1 e7 03                    ; 0xc1643
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc1646
    jne short 0165fh                          ; 75 12                       ; 0xc164b
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc164d vgabios.c:1087
    mov cx, 04000h                            ; b9 00 40                    ; 0xc1651
    mov ax, 00720h                            ; b8 20 07                    ; 0xc1654
    xor di, di                                ; 31 ff                       ; 0xc1657
    jcxz 0165dh                               ; e3 02                       ; 0xc1659
    rep stosw                                 ; f3 ab                       ; 0xc165b
    jmp short 0169bh                          ; eb 3c                       ; 0xc165d vgabios.c:1089
    cmp byte [bp-00ch], 00dh                  ; 80 7e f4 0d                 ; 0xc165f vgabios.c:1091
    jnc short 01676h                          ; 73 11                       ; 0xc1663
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc1665 vgabios.c:1093
    mov cx, 04000h                            ; b9 00 40                    ; 0xc1669
    xor al, al                                ; 30 c0                       ; 0xc166c
    xor di, di                                ; 31 ff                       ; 0xc166e
    jcxz 01674h                               ; e3 02                       ; 0xc1670
    rep stosw                                 ; f3 ab                       ; 0xc1672
    jmp short 0169bh                          ; eb 25                       ; 0xc1674 vgabios.c:1095
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc1676 vgabios.c:1097
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc1678
    out DX, AL                                ; ee                          ; 0xc167b
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc167c vgabios.c:1098
    in AL, DX                                 ; ec                          ; 0xc167f
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1680
    mov word [bp-020h], ax                    ; 89 46 e0                    ; 0xc1682
    mov AL, strict byte 00fh                  ; b0 0f                       ; 0xc1685 vgabios.c:1099
    out DX, AL                                ; ee                          ; 0xc1687
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc1688 vgabios.c:1100
    mov cx, 08000h                            ; b9 00 80                    ; 0xc168c
    xor ax, ax                                ; 31 c0                       ; 0xc168f
    xor di, di                                ; 31 ff                       ; 0xc1691
    jcxz 01697h                               ; e3 02                       ; 0xc1693
    rep stosw                                 ; f3 ab                       ; 0xc1695
    mov al, byte [bp-020h]                    ; 8a 46 e0                    ; 0xc1697 vgabios.c:1101
    out DX, AL                                ; ee                          ; 0xc169a
    mov di, strict word 00049h                ; bf 49 00                    ; 0xc169b vgabios.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc169e
    mov es, ax                                ; 8e c0                       ; 0xc16a1
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc16a3
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc16a6
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc16a9 vgabios.c:1108
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc16ac
    xor ah, ah                                ; 30 e4                       ; 0xc16af
    mov di, strict word 0004ah                ; bf 4a 00                    ; 0xc16b1 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc16b4
    mov es, dx                                ; 8e c2                       ; 0xc16b7
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc16b9
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc16bc vgabios.c:60
    mov ax, word [es:si+003h]                 ; 26 8b 44 03                 ; 0xc16bf
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc16c3 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc16c6
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc16c8
    mov di, strict word 00063h                ; bf 63 00                    ; 0xc16cb vgabios.c:62
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc16ce
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc16d1
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc16d4 vgabios.c:50
    mov al, byte [es:si+001h]                 ; 26 8a 44 01                 ; 0xc16d7
    mov di, 00084h                            ; bf 84 00                    ; 0xc16db vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc16de
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc16e0
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc16e3 vgabios.c:1112
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc16e6
    xor ah, ah                                ; 30 e4                       ; 0xc16ea
    mov di, 00085h                            ; bf 85 00                    ; 0xc16ec vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc16ef
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc16f1
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc16f4 vgabios.c:1113
    mov al, byte [es:si+014h]                 ; 26 8a 44 14                 ; 0xc16f7
    mov dx, ax                                ; 89 c2                       ; 0xc16fb
    sal dx, 008h                              ; c1 e2 08                    ; 0xc16fd
    mov al, byte [es:si+015h]                 ; 26 8a 44 15                 ; 0xc1700
    or ax, dx                                 ; 09 d0                       ; 0xc1704
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc1706 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1709
    mov es, dx                                ; 8e c2                       ; 0xc170c
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc170e
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1711 vgabios.c:1114
    or AL, strict byte 060h                   ; 0c 60                       ; 0xc1714
    mov di, 00087h                            ; bf 87 00                    ; 0xc1716 vgabios.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc1719
    mov di, 00088h                            ; bf 88 00                    ; 0xc171c vgabios.c:52
    mov byte [es:di], 0f9h                    ; 26 c6 05 f9                 ; 0xc171f
    mov di, 0008ah                            ; bf 8a 00                    ; 0xc1723 vgabios.c:52
    mov byte [es:di], 008h                    ; 26 c6 05 08                 ; 0xc1726
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc172a vgabios.c:1120
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc172d
    jnbe short 01758h                         ; 77 27                       ; 0xc172f
    xor ah, ah                                ; 30 e4                       ; 0xc1731 vgabios.c:1122
    mov di, ax                                ; 89 c7                       ; 0xc1733 vgabios.c:50
    mov al, byte [di+07ddbh]                  ; 8a 85 db 7d                 ; 0xc1735
    mov di, strict word 00065h                ; bf 65 00                    ; 0xc1739 vgabios.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc173c
    cmp byte [bp-00ch], 006h                  ; 80 7e f4 06                 ; 0xc173f vgabios.c:1123
    jne short 0174ah                          ; 75 05                       ; 0xc1743
    mov ax, strict word 0003fh                ; b8 3f 00                    ; 0xc1745
    jmp short 0174dh                          ; eb 03                       ; 0xc1748
    mov ax, strict word 00030h                ; b8 30 00                    ; 0xc174a
    mov di, strict word 00066h                ; bf 66 00                    ; 0xc174d vgabios.c:52
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1750
    mov es, dx                                ; 8e c2                       ; 0xc1753
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc1755
    xor cx, cx                                ; 31 c9                       ; 0xc1758 vgabios.c:1128
    jmp short 01761h                          ; eb 05                       ; 0xc175a
    cmp cx, strict byte 00008h                ; 83 f9 08                    ; 0xc175c
    jnc short 0176dh                          ; 73 0c                       ; 0xc175f
    mov al, cl                                ; 88 c8                       ; 0xc1761 vgabios.c:1129
    xor ah, ah                                ; 30 e4                       ; 0xc1763
    xor dx, dx                                ; 31 d2                       ; 0xc1765
    call 01278h                               ; e8 0e fb                    ; 0xc1767
    inc cx                                    ; 41                          ; 0xc176a
    jmp short 0175ch                          ; eb ef                       ; 0xc176b
    xor ax, ax                                ; 31 c0                       ; 0xc176d vgabios.c:1132
    call 012f0h                               ; e8 7e fb                    ; 0xc176f
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc1772 vgabios.c:1135
    xor ah, ah                                ; 30 e4                       ; 0xc1775
    mov di, ax                                ; 89 c7                       ; 0xc1777
    sal di, 003h                              ; c1 e7 03                    ; 0xc1779
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc177c
    jne short 017edh                          ; 75 6a                       ; 0xc1781
    mov es, [bp-01eh]                         ; 8e 46 e2                    ; 0xc1783 vgabios.c:1137
    mov di, word [es:bx+008h]                 ; 26 8b 7f 08                 ; 0xc1786
    mov ax, word [es:bx+00ah]                 ; 26 8b 47 0a                 ; 0xc178a
    mov word [bp-018h], ax                    ; 89 46 e8                    ; 0xc178e
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc1791 vgabios.c:1139
    mov bl, byte [es:si+002h]                 ; 26 8a 5c 02                 ; 0xc1794
    cmp bl, 00eh                              ; 80 fb 0e                    ; 0xc1798
    je short 017c0h                           ; 74 23                       ; 0xc179b
    cmp bl, 008h                              ; 80 fb 08                    ; 0xc179d
    jne short 017f0h                          ; 75 4e                       ; 0xc17a0
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc17a2 vgabios.c:1141
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc17a5
    xor ah, ah                                ; 30 e4                       ; 0xc17a9
    push ax                                   ; 50                          ; 0xc17ab
    push strict byte 00000h                   ; 6a 00                       ; 0xc17ac
    push strict byte 00000h                   ; 6a 00                       ; 0xc17ae
    mov cx, 00100h                            ; b9 00 01                    ; 0xc17b0
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc17b3
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc17b6
    xor al, al                                ; 30 c0                       ; 0xc17b9
    call 02d9fh                               ; e8 e1 15                    ; 0xc17bb
    jmp short 01815h                          ; eb 55                       ; 0xc17be vgabios.c:1142
    mov al, bl                                ; 88 d8                       ; 0xc17c0 vgabios.c:1144
    xor ah, ah                                ; 30 e4                       ; 0xc17c2
    push ax                                   ; 50                          ; 0xc17c4
    push strict byte 00000h                   ; 6a 00                       ; 0xc17c5
    push strict byte 00000h                   ; 6a 00                       ; 0xc17c7
    mov cx, 00100h                            ; b9 00 01                    ; 0xc17c9
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc17cc
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc17cf
    xor al, al                                ; 30 c0                       ; 0xc17d2
    call 02d9fh                               ; e8 c8 15                    ; 0xc17d4
    cmp byte [bp-00ch], 007h                  ; 80 7e f4 07                 ; 0xc17d7 vgabios.c:1145
    jne short 01815h                          ; 75 38                       ; 0xc17db
    mov cx, strict word 0000eh                ; b9 0e 00                    ; 0xc17dd vgabios.c:1146
    xor bx, bx                                ; 31 db                       ; 0xc17e0
    mov dx, 07b6ah                            ; ba 6a 7b                    ; 0xc17e2
    mov ax, 0c000h                            ; b8 00 c0                    ; 0xc17e5
    call 02d2ah                               ; e8 3f 15                    ; 0xc17e8
    jmp short 01815h                          ; eb 28                       ; 0xc17eb vgabios.c:1147
    jmp near 01871h                           ; e9 81 00                    ; 0xc17ed
    mov al, bl                                ; 88 d8                       ; 0xc17f0 vgabios.c:1149
    xor ah, ah                                ; 30 e4                       ; 0xc17f2
    push ax                                   ; 50                          ; 0xc17f4
    push strict byte 00000h                   ; 6a 00                       ; 0xc17f5
    push strict byte 00000h                   ; 6a 00                       ; 0xc17f7
    mov cx, 00100h                            ; b9 00 01                    ; 0xc17f9
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc17fc
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc17ff
    xor al, al                                ; 30 c0                       ; 0xc1802
    call 02d9fh                               ; e8 98 15                    ; 0xc1804
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc1807 vgabios.c:1150
    xor bx, bx                                ; 31 db                       ; 0xc180a
    mov dx, 07c97h                            ; ba 97 7c                    ; 0xc180c
    mov ax, 0c000h                            ; b8 00 c0                    ; 0xc180f
    call 02d2ah                               ; e8 15 15                    ; 0xc1812
    cmp word [bp-018h], strict byte 00000h    ; 83 7e e8 00                 ; 0xc1815 vgabios.c:1152
    jne short 0181fh                          ; 75 04                       ; 0xc1819
    test di, di                               ; 85 ff                       ; 0xc181b
    je short 01869h                           ; 74 4a                       ; 0xc181d
    xor cx, cx                                ; 31 c9                       ; 0xc181f vgabios.c:1157
    mov es, [bp-018h]                         ; 8e 46 e8                    ; 0xc1821 vgabios.c:1159
    mov bx, di                                ; 89 fb                       ; 0xc1824
    add bx, cx                                ; 01 cb                       ; 0xc1826
    mov al, byte [es:bx+00bh]                 ; 26 8a 47 0b                 ; 0xc1828
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc182c
    je short 01838h                           ; 74 08                       ; 0xc182e
    cmp al, byte [bp-00ch]                    ; 3a 46 f4                    ; 0xc1830 vgabios.c:1161
    je short 01838h                           ; 74 03                       ; 0xc1833
    inc cx                                    ; 41                          ; 0xc1835 vgabios.c:1163
    jmp short 01821h                          ; eb e9                       ; 0xc1836 vgabios.c:1164
    mov es, [bp-018h]                         ; 8e 46 e8                    ; 0xc1838 vgabios.c:1166
    mov bx, di                                ; 89 fb                       ; 0xc183b
    add bx, cx                                ; 01 cb                       ; 0xc183d
    mov al, byte [es:bx+00bh]                 ; 26 8a 47 0b                 ; 0xc183f
    cmp al, byte [bp-00ch]                    ; 3a 46 f4                    ; 0xc1843
    jne short 01869h                          ; 75 21                       ; 0xc1846
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc1848 vgabios.c:1171
    xor ah, ah                                ; 30 e4                       ; 0xc184b
    push ax                                   ; 50                          ; 0xc184d
    mov al, byte [es:di+001h]                 ; 26 8a 45 01                 ; 0xc184e
    push ax                                   ; 50                          ; 0xc1852
    push word [es:di+004h]                    ; 26 ff 75 04                 ; 0xc1853
    mov cx, word [es:di+002h]                 ; 26 8b 4d 02                 ; 0xc1857
    mov bx, word [es:di+006h]                 ; 26 8b 5d 06                 ; 0xc185b
    mov dx, word [es:di+008h]                 ; 26 8b 55 08                 ; 0xc185f
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc1863
    call 02d9fh                               ; e8 36 15                    ; 0xc1866
    xor bl, bl                                ; 30 db                       ; 0xc1869 vgabios.c:1175
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc186b
    mov AH, strict byte 011h                  ; b4 11                       ; 0xc186d
    int 06dh                                  ; cd 6d                       ; 0xc186f
    mov bx, 0596ah                            ; bb 6a 59                    ; 0xc1871 vgabios.c:1179
    mov cx, ds                                ; 8c d9                       ; 0xc1874
    mov ax, strict word 0001fh                ; b8 1f 00                    ; 0xc1876
    call 009f0h                               ; e8 74 f1                    ; 0xc1879
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc187c vgabios.c:1181
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc187f
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc1883
    je short 018a1h                           ; 74 1a                       ; 0xc1885
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc1887
    je short 0189ch                           ; 74 11                       ; 0xc1889
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc188b
    jne short 018a6h                          ; 75 17                       ; 0xc188d
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc188f vgabios.c:1183
    mov cx, ds                                ; 8c d9                       ; 0xc1892
    mov ax, strict word 00043h                ; b8 43 00                    ; 0xc1894
    call 009f0h                               ; e8 56 f1                    ; 0xc1897
    jmp short 018a6h                          ; eb 0a                       ; 0xc189a vgabios.c:1184
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc189c vgabios.c:1186
    jmp short 01892h                          ; eb f1                       ; 0xc189f
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc18a1 vgabios.c:1189
    jmp short 01892h                          ; eb ec                       ; 0xc18a4
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc18a6 vgabios.c:1192
    pop di                                    ; 5f                          ; 0xc18a9
    pop si                                    ; 5e                          ; 0xc18aa
    pop dx                                    ; 5a                          ; 0xc18ab
    pop cx                                    ; 59                          ; 0xc18ac
    pop bx                                    ; 5b                          ; 0xc18ad
    pop bp                                    ; 5d                          ; 0xc18ae
    retn                                      ; c3                          ; 0xc18af
  ; disGetNextSymbol 0xc18b0 LB 0x2c11 -> off=0x0 cb=000000000000008e uValue=00000000000c18b0 'vgamem_copy_pl4'
vgamem_copy_pl4:                             ; 0xc18b0 LB 0x8e
    push bp                                   ; 55                          ; 0xc18b0 vgabios.c:1195
    mov bp, sp                                ; 89 e5                       ; 0xc18b1
    push si                                   ; 56                          ; 0xc18b3
    push di                                   ; 57                          ; 0xc18b4
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc18b5
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc18b8
    mov al, dl                                ; 88 d0                       ; 0xc18bb
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc18bd
    mov byte [bp-006h], cl                    ; 88 4e fa                    ; 0xc18c0
    xor ah, ah                                ; 30 e4                       ; 0xc18c3 vgabios.c:1201
    mov dl, byte [bp+006h]                    ; 8a 56 06                    ; 0xc18c5
    xor dh, dh                                ; 30 f6                       ; 0xc18c8
    mov cx, dx                                ; 89 d1                       ; 0xc18ca
    imul dx                                   ; f7 ea                       ; 0xc18cc
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc18ce
    xor dh, dh                                ; 30 f6                       ; 0xc18d1
    mov si, dx                                ; 89 d6                       ; 0xc18d3
    imul dx                                   ; f7 ea                       ; 0xc18d5
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc18d7
    xor dh, dh                                ; 30 f6                       ; 0xc18da
    mov bx, dx                                ; 89 d3                       ; 0xc18dc
    add ax, dx                                ; 01 d0                       ; 0xc18de
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc18e0
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc18e3 vgabios.c:1202
    xor ah, ah                                ; 30 e4                       ; 0xc18e6
    imul cx                                   ; f7 e9                       ; 0xc18e8
    imul si                                   ; f7 ee                       ; 0xc18ea
    add ax, bx                                ; 01 d8                       ; 0xc18ec
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc18ee
    mov ax, 00105h                            ; b8 05 01                    ; 0xc18f1 vgabios.c:1203
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc18f4
    out DX, ax                                ; ef                          ; 0xc18f7
    xor bl, bl                                ; 30 db                       ; 0xc18f8 vgabios.c:1204
    cmp bl, byte [bp+006h]                    ; 3a 5e 06                    ; 0xc18fa
    jnc short 0192eh                          ; 73 2f                       ; 0xc18fd
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc18ff vgabios.c:1206
    xor ah, ah                                ; 30 e4                       ; 0xc1902
    mov cx, ax                                ; 89 c1                       ; 0xc1904
    mov al, bl                                ; 88 d8                       ; 0xc1906
    mov dx, ax                                ; 89 c2                       ; 0xc1908
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc190a
    mov si, ax                                ; 89 c6                       ; 0xc190d
    mov ax, dx                                ; 89 d0                       ; 0xc190f
    imul si                                   ; f7 ee                       ; 0xc1911
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc1913
    add si, ax                                ; 01 c6                       ; 0xc1916
    mov di, word [bp-00ch]                    ; 8b 7e f4                    ; 0xc1918
    add di, ax                                ; 01 c7                       ; 0xc191b
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc191d
    mov es, dx                                ; 8e c2                       ; 0xc1920
    jcxz 0192ah                               ; e3 06                       ; 0xc1922
    push DS                                   ; 1e                          ; 0xc1924
    mov ds, dx                                ; 8e da                       ; 0xc1925
    rep movsb                                 ; f3 a4                       ; 0xc1927
    pop DS                                    ; 1f                          ; 0xc1929
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc192a vgabios.c:1207
    jmp short 018fah                          ; eb cc                       ; 0xc192c
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc192e vgabios.c:1208
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1931
    out DX, ax                                ; ef                          ; 0xc1934
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1935 vgabios.c:1209
    pop di                                    ; 5f                          ; 0xc1938
    pop si                                    ; 5e                          ; 0xc1939
    pop bp                                    ; 5d                          ; 0xc193a
    retn 00004h                               ; c2 04 00                    ; 0xc193b
  ; disGetNextSymbol 0xc193e LB 0x2b83 -> off=0x0 cb=000000000000007b uValue=00000000000c193e 'vgamem_fill_pl4'
vgamem_fill_pl4:                             ; 0xc193e LB 0x7b
    push bp                                   ; 55                          ; 0xc193e vgabios.c:1212
    mov bp, sp                                ; 89 e5                       ; 0xc193f
    push si                                   ; 56                          ; 0xc1941
    push di                                   ; 57                          ; 0xc1942
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc1943
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc1946
    mov al, dl                                ; 88 d0                       ; 0xc1949
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc194b
    mov bh, cl                                ; 88 cf                       ; 0xc194e
    xor ah, ah                                ; 30 e4                       ; 0xc1950 vgabios.c:1218
    mov dx, ax                                ; 89 c2                       ; 0xc1952
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1954
    mov cx, ax                                ; 89 c1                       ; 0xc1957
    mov ax, dx                                ; 89 d0                       ; 0xc1959
    imul cx                                   ; f7 e9                       ; 0xc195b
    mov dl, bh                                ; 88 fa                       ; 0xc195d
    xor dh, dh                                ; 30 f6                       ; 0xc195f
    imul dx                                   ; f7 ea                       ; 0xc1961
    mov dx, ax                                ; 89 c2                       ; 0xc1963
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1965
    xor ah, ah                                ; 30 e4                       ; 0xc1968
    add dx, ax                                ; 01 c2                       ; 0xc196a
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc196c
    mov ax, 00205h                            ; b8 05 02                    ; 0xc196f vgabios.c:1219
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1972
    out DX, ax                                ; ef                          ; 0xc1975
    xor bl, bl                                ; 30 db                       ; 0xc1976 vgabios.c:1220
    cmp bl, byte [bp+004h]                    ; 3a 5e 04                    ; 0xc1978
    jnc short 019a9h                          ; 73 2c                       ; 0xc197b
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc197d vgabios.c:1222
    xor ch, ch                                ; 30 ed                       ; 0xc1980
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1982
    xor ah, ah                                ; 30 e4                       ; 0xc1985
    mov si, ax                                ; 89 c6                       ; 0xc1987
    mov al, bl                                ; 88 d8                       ; 0xc1989
    mov dx, ax                                ; 89 c2                       ; 0xc198b
    mov al, bh                                ; 88 f8                       ; 0xc198d
    mov di, ax                                ; 89 c7                       ; 0xc198f
    mov ax, dx                                ; 89 d0                       ; 0xc1991
    imul di                                   ; f7 ef                       ; 0xc1993
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc1995
    add di, ax                                ; 01 c7                       ; 0xc1998
    mov ax, si                                ; 89 f0                       ; 0xc199a
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc199c
    mov es, dx                                ; 8e c2                       ; 0xc199f
    jcxz 019a5h                               ; e3 02                       ; 0xc19a1
    rep stosb                                 ; f3 aa                       ; 0xc19a3
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc19a5 vgabios.c:1223
    jmp short 01978h                          ; eb cf                       ; 0xc19a7
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc19a9 vgabios.c:1224
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc19ac
    out DX, ax                                ; ef                          ; 0xc19af
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc19b0 vgabios.c:1225
    pop di                                    ; 5f                          ; 0xc19b3
    pop si                                    ; 5e                          ; 0xc19b4
    pop bp                                    ; 5d                          ; 0xc19b5
    retn 00004h                               ; c2 04 00                    ; 0xc19b6
  ; disGetNextSymbol 0xc19b9 LB 0x2b08 -> off=0x0 cb=00000000000000b6 uValue=00000000000c19b9 'vgamem_copy_cga'
vgamem_copy_cga:                             ; 0xc19b9 LB 0xb6
    push bp                                   ; 55                          ; 0xc19b9 vgabios.c:1228
    mov bp, sp                                ; 89 e5                       ; 0xc19ba
    push si                                   ; 56                          ; 0xc19bc
    push di                                   ; 57                          ; 0xc19bd
    sub sp, strict byte 0000eh                ; 83 ec 0e                    ; 0xc19be
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc19c1
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc19c4
    mov byte [bp-00ah], cl                    ; 88 4e f6                    ; 0xc19c7
    mov al, dl                                ; 88 d0                       ; 0xc19ca vgabios.c:1234
    xor ah, ah                                ; 30 e4                       ; 0xc19cc
    mov bx, ax                                ; 89 c3                       ; 0xc19ce
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc19d0
    mov si, ax                                ; 89 c6                       ; 0xc19d3
    mov ax, bx                                ; 89 d8                       ; 0xc19d5
    imul si                                   ; f7 ee                       ; 0xc19d7
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc19d9
    mov di, bx                                ; 89 df                       ; 0xc19dc
    imul bx                                   ; f7 eb                       ; 0xc19de
    mov dx, ax                                ; 89 c2                       ; 0xc19e0
    sar dx, 1                                 ; d1 fa                       ; 0xc19e2
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc19e4
    xor ah, ah                                ; 30 e4                       ; 0xc19e7
    mov bx, ax                                ; 89 c3                       ; 0xc19e9
    add dx, ax                                ; 01 c2                       ; 0xc19eb
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc19ed
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc19f0 vgabios.c:1235
    imul si                                   ; f7 ee                       ; 0xc19f3
    imul di                                   ; f7 ef                       ; 0xc19f5
    sar ax, 1                                 ; d1 f8                       ; 0xc19f7
    add ax, bx                                ; 01 d8                       ; 0xc19f9
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc19fb
    mov byte [bp-006h], bh                    ; 88 7e fa                    ; 0xc19fe vgabios.c:1236
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1a01
    xor ah, ah                                ; 30 e4                       ; 0xc1a04
    cwd                                       ; 99                          ; 0xc1a06
    db  02bh, 0c2h
    ; sub ax, dx                                ; 2b c2                     ; 0xc1a07
    sar ax, 1                                 ; d1 f8                       ; 0xc1a09
    mov bx, ax                                ; 89 c3                       ; 0xc1a0b
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1a0d
    xor ah, ah                                ; 30 e4                       ; 0xc1a10
    cmp ax, bx                                ; 39 d8                       ; 0xc1a12
    jnl short 01a66h                          ; 7d 50                       ; 0xc1a14
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1a16 vgabios.c:1238
    xor bh, bh                                ; 30 ff                       ; 0xc1a19
    mov word [bp-012h], bx                    ; 89 5e ee                    ; 0xc1a1b
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc1a1e
    imul bx                                   ; f7 eb                       ; 0xc1a21
    mov bx, ax                                ; 89 c3                       ; 0xc1a23
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc1a25
    add si, ax                                ; 01 c6                       ; 0xc1a28
    mov di, word [bp-010h]                    ; 8b 7e f0                    ; 0xc1a2a
    add di, ax                                ; 01 c7                       ; 0xc1a2d
    mov cx, word [bp-012h]                    ; 8b 4e ee                    ; 0xc1a2f
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1a32
    mov es, dx                                ; 8e c2                       ; 0xc1a35
    jcxz 01a3fh                               ; e3 06                       ; 0xc1a37
    push DS                                   ; 1e                          ; 0xc1a39
    mov ds, dx                                ; 8e da                       ; 0xc1a3a
    rep movsb                                 ; f3 a4                       ; 0xc1a3c
    pop DS                                    ; 1f                          ; 0xc1a3e
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc1a3f vgabios.c:1239
    add si, 02000h                            ; 81 c6 00 20                 ; 0xc1a42
    add si, bx                                ; 01 de                       ; 0xc1a46
    mov di, word [bp-010h]                    ; 8b 7e f0                    ; 0xc1a48
    add di, 02000h                            ; 81 c7 00 20                 ; 0xc1a4b
    add di, bx                                ; 01 df                       ; 0xc1a4f
    mov cx, word [bp-012h]                    ; 8b 4e ee                    ; 0xc1a51
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1a54
    mov es, dx                                ; 8e c2                       ; 0xc1a57
    jcxz 01a61h                               ; e3 06                       ; 0xc1a59
    push DS                                   ; 1e                          ; 0xc1a5b
    mov ds, dx                                ; 8e da                       ; 0xc1a5c
    rep movsb                                 ; f3 a4                       ; 0xc1a5e
    pop DS                                    ; 1f                          ; 0xc1a60
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1a61 vgabios.c:1240
    jmp short 01a01h                          ; eb 9b                       ; 0xc1a64
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1a66 vgabios.c:1241
    pop di                                    ; 5f                          ; 0xc1a69
    pop si                                    ; 5e                          ; 0xc1a6a
    pop bp                                    ; 5d                          ; 0xc1a6b
    retn 00004h                               ; c2 04 00                    ; 0xc1a6c
  ; disGetNextSymbol 0xc1a6f LB 0x2a52 -> off=0x0 cb=0000000000000094 uValue=00000000000c1a6f 'vgamem_fill_cga'
vgamem_fill_cga:                             ; 0xc1a6f LB 0x94
    push bp                                   ; 55                          ; 0xc1a6f vgabios.c:1244
    mov bp, sp                                ; 89 e5                       ; 0xc1a70
    push si                                   ; 56                          ; 0xc1a72
    push di                                   ; 57                          ; 0xc1a73
    sub sp, strict byte 0000ch                ; 83 ec 0c                    ; 0xc1a74
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc1a77
    mov al, dl                                ; 88 d0                       ; 0xc1a7a
    mov byte [bp-00ch], bl                    ; 88 5e f4                    ; 0xc1a7c
    mov byte [bp-008h], cl                    ; 88 4e f8                    ; 0xc1a7f
    xor ah, ah                                ; 30 e4                       ; 0xc1a82 vgabios.c:1250
    mov dx, ax                                ; 89 c2                       ; 0xc1a84
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1a86
    mov bx, ax                                ; 89 c3                       ; 0xc1a89
    mov ax, dx                                ; 89 d0                       ; 0xc1a8b
    imul bx                                   ; f7 eb                       ; 0xc1a8d
    mov dl, cl                                ; 88 ca                       ; 0xc1a8f
    xor dh, dh                                ; 30 f6                       ; 0xc1a91
    imul dx                                   ; f7 ea                       ; 0xc1a93
    mov dx, ax                                ; 89 c2                       ; 0xc1a95
    sar dx, 1                                 ; d1 fa                       ; 0xc1a97
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1a99
    xor ah, ah                                ; 30 e4                       ; 0xc1a9c
    add dx, ax                                ; 01 c2                       ; 0xc1a9e
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc1aa0
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc1aa3 vgabios.c:1251
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1aa6
    xor ah, ah                                ; 30 e4                       ; 0xc1aa9
    cwd                                       ; 99                          ; 0xc1aab
    db  02bh, 0c2h
    ; sub ax, dx                                ; 2b c2                     ; 0xc1aac
    sar ax, 1                                 ; d1 f8                       ; 0xc1aae
    mov dx, ax                                ; 89 c2                       ; 0xc1ab0
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1ab2
    xor ah, ah                                ; 30 e4                       ; 0xc1ab5
    cmp ax, dx                                ; 39 d0                       ; 0xc1ab7
    jnl short 01afah                          ; 7d 3f                       ; 0xc1ab9
    mov bl, byte [bp-00ch]                    ; 8a 5e f4                    ; 0xc1abb vgabios.c:1253
    xor bh, bh                                ; 30 ff                       ; 0xc1abe
    mov dl, byte [bp+006h]                    ; 8a 56 06                    ; 0xc1ac0
    xor dh, dh                                ; 30 f6                       ; 0xc1ac3
    mov si, dx                                ; 89 d6                       ; 0xc1ac5
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc1ac7
    imul dx                                   ; f7 ea                       ; 0xc1aca
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc1acc
    mov di, word [bp-00eh]                    ; 8b 7e f2                    ; 0xc1acf
    add di, ax                                ; 01 c7                       ; 0xc1ad2
    mov cx, bx                                ; 89 d9                       ; 0xc1ad4
    mov ax, si                                ; 89 f0                       ; 0xc1ad6
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1ad8
    mov es, dx                                ; 8e c2                       ; 0xc1adb
    jcxz 01ae1h                               ; e3 02                       ; 0xc1add
    rep stosb                                 ; f3 aa                       ; 0xc1adf
    mov di, word [bp-00eh]                    ; 8b 7e f2                    ; 0xc1ae1 vgabios.c:1254
    add di, 02000h                            ; 81 c7 00 20                 ; 0xc1ae4
    add di, word [bp-010h]                    ; 03 7e f0                    ; 0xc1ae8
    mov cx, bx                                ; 89 d9                       ; 0xc1aeb
    mov ax, si                                ; 89 f0                       ; 0xc1aed
    mov es, dx                                ; 8e c2                       ; 0xc1aef
    jcxz 01af5h                               ; e3 02                       ; 0xc1af1
    rep stosb                                 ; f3 aa                       ; 0xc1af3
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1af5 vgabios.c:1255
    jmp short 01aa6h                          ; eb ac                       ; 0xc1af8
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1afa vgabios.c:1256
    pop di                                    ; 5f                          ; 0xc1afd
    pop si                                    ; 5e                          ; 0xc1afe
    pop bp                                    ; 5d                          ; 0xc1aff
    retn 00004h                               ; c2 04 00                    ; 0xc1b00
  ; disGetNextSymbol 0xc1b03 LB 0x29be -> off=0x0 cb=0000000000000081 uValue=00000000000c1b03 'vgamem_copy_linear'
vgamem_copy_linear:                          ; 0xc1b03 LB 0x81
    push bp                                   ; 55                          ; 0xc1b03 vgabios.c:1259
    mov bp, sp                                ; 89 e5                       ; 0xc1b04
    push si                                   ; 56                          ; 0xc1b06
    push di                                   ; 57                          ; 0xc1b07
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc1b08
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc1b0b
    mov al, dl                                ; 88 d0                       ; 0xc1b0e
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc1b10
    mov bx, cx                                ; 89 cb                       ; 0xc1b13
    xor ah, ah                                ; 30 e4                       ; 0xc1b15 vgabios.c:1265
    mov si, ax                                ; 89 c6                       ; 0xc1b17
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1b19
    mov di, ax                                ; 89 c7                       ; 0xc1b1c
    mov ax, si                                ; 89 f0                       ; 0xc1b1e
    imul di                                   ; f7 ef                       ; 0xc1b20
    mul word [bp+004h]                        ; f7 66 04                    ; 0xc1b22
    mov si, ax                                ; 89 c6                       ; 0xc1b25
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1b27
    xor ah, ah                                ; 30 e4                       ; 0xc1b2a
    mov cx, ax                                ; 89 c1                       ; 0xc1b2c
    add si, ax                                ; 01 c6                       ; 0xc1b2e
    sal si, 003h                              ; c1 e6 03                    ; 0xc1b30
    mov word [bp-00ch], si                    ; 89 76 f4                    ; 0xc1b33
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1b36 vgabios.c:1266
    imul di                                   ; f7 ef                       ; 0xc1b39
    mul word [bp+004h]                        ; f7 66 04                    ; 0xc1b3b
    add ax, cx                                ; 01 c8                       ; 0xc1b3e
    sal ax, 003h                              ; c1 e0 03                    ; 0xc1b40
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc1b43
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1b46 vgabios.c:1267
    sal word [bp+004h], 003h                  ; c1 66 04 03                 ; 0xc1b49 vgabios.c:1268
    mov byte [bp-006h], ch                    ; 88 6e fa                    ; 0xc1b4d vgabios.c:1269
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1b50
    cmp al, byte [bp+006h]                    ; 3a 46 06                    ; 0xc1b53
    jnc short 01b7bh                          ; 73 23                       ; 0xc1b56
    xor ah, ah                                ; 30 e4                       ; 0xc1b58 vgabios.c:1271
    mul word [bp+004h]                        ; f7 66 04                    ; 0xc1b5a
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc1b5d
    add si, ax                                ; 01 c6                       ; 0xc1b60
    mov di, word [bp-00eh]                    ; 8b 7e f2                    ; 0xc1b62
    add di, ax                                ; 01 c7                       ; 0xc1b65
    mov cx, bx                                ; 89 d9                       ; 0xc1b67
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1b69
    mov es, dx                                ; 8e c2                       ; 0xc1b6c
    jcxz 01b76h                               ; e3 06                       ; 0xc1b6e
    push DS                                   ; 1e                          ; 0xc1b70
    mov ds, dx                                ; 8e da                       ; 0xc1b71
    rep movsb                                 ; f3 a4                       ; 0xc1b73
    pop DS                                    ; 1f                          ; 0xc1b75
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1b76 vgabios.c:1272
    jmp short 01b50h                          ; eb d5                       ; 0xc1b79
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1b7b vgabios.c:1273
    pop di                                    ; 5f                          ; 0xc1b7e
    pop si                                    ; 5e                          ; 0xc1b7f
    pop bp                                    ; 5d                          ; 0xc1b80
    retn 00004h                               ; c2 04 00                    ; 0xc1b81
  ; disGetNextSymbol 0xc1b84 LB 0x293d -> off=0x0 cb=000000000000006d uValue=00000000000c1b84 'vgamem_fill_linear'
vgamem_fill_linear:                          ; 0xc1b84 LB 0x6d
    push bp                                   ; 55                          ; 0xc1b84 vgabios.c:1276
    mov bp, sp                                ; 89 e5                       ; 0xc1b85
    push si                                   ; 56                          ; 0xc1b87
    push di                                   ; 57                          ; 0xc1b88
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc1b89
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc1b8c
    mov al, dl                                ; 88 d0                       ; 0xc1b8f
    mov si, cx                                ; 89 ce                       ; 0xc1b91
    xor ah, ah                                ; 30 e4                       ; 0xc1b93 vgabios.c:1282
    mov dx, ax                                ; 89 c2                       ; 0xc1b95
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1b97
    mov di, ax                                ; 89 c7                       ; 0xc1b9a
    mov ax, dx                                ; 89 d0                       ; 0xc1b9c
    imul di                                   ; f7 ef                       ; 0xc1b9e
    mul cx                                    ; f7 e1                       ; 0xc1ba0
    mov dx, ax                                ; 89 c2                       ; 0xc1ba2
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1ba4
    xor ah, ah                                ; 30 e4                       ; 0xc1ba7
    add ax, dx                                ; 01 d0                       ; 0xc1ba9
    sal ax, 003h                              ; c1 e0 03                    ; 0xc1bab
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc1bae
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1bb1 vgabios.c:1283
    sal si, 003h                              ; c1 e6 03                    ; 0xc1bb4 vgabios.c:1284
    mov byte [bp-008h], 000h                  ; c6 46 f8 00                 ; 0xc1bb7 vgabios.c:1285
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1bbb
    cmp al, byte [bp+004h]                    ; 3a 46 04                    ; 0xc1bbe
    jnc short 01be8h                          ; 73 25                       ; 0xc1bc1
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1bc3 vgabios.c:1287
    xor ah, ah                                ; 30 e4                       ; 0xc1bc6
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc1bc8
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1bcb
    mul si                                    ; f7 e6                       ; 0xc1bce
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc1bd0
    add di, ax                                ; 01 c7                       ; 0xc1bd3
    mov cx, bx                                ; 89 d9                       ; 0xc1bd5
    mov ax, word [bp-00ch]                    ; 8b 46 f4                    ; 0xc1bd7
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1bda
    mov es, dx                                ; 8e c2                       ; 0xc1bdd
    jcxz 01be3h                               ; e3 02                       ; 0xc1bdf
    rep stosb                                 ; f3 aa                       ; 0xc1be1
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc1be3 vgabios.c:1288
    jmp short 01bbbh                          ; eb d3                       ; 0xc1be6
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1be8 vgabios.c:1289
    pop di                                    ; 5f                          ; 0xc1beb
    pop si                                    ; 5e                          ; 0xc1bec
    pop bp                                    ; 5d                          ; 0xc1bed
    retn 00004h                               ; c2 04 00                    ; 0xc1bee
  ; disGetNextSymbol 0xc1bf1 LB 0x28d0 -> off=0x0 cb=0000000000000686 uValue=00000000000c1bf1 'biosfn_scroll'
biosfn_scroll:                               ; 0xc1bf1 LB 0x686
    push bp                                   ; 55                          ; 0xc1bf1 vgabios.c:1292
    mov bp, sp                                ; 89 e5                       ; 0xc1bf2
    push si                                   ; 56                          ; 0xc1bf4
    push di                                   ; 57                          ; 0xc1bf5
    sub sp, strict byte 0001ch                ; 83 ec 1c                    ; 0xc1bf6
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc1bf9
    mov byte [bp-010h], dl                    ; 88 56 f0                    ; 0xc1bfc
    mov byte [bp-00ch], bl                    ; 88 5e f4                    ; 0xc1bff
    mov byte [bp-008h], cl                    ; 88 4e f8                    ; 0xc1c02
    cmp bl, byte [bp+004h]                    ; 3a 5e 04                    ; 0xc1c05 vgabios.c:1301
    jnbe short 01c26h                         ; 77 1c                       ; 0xc1c08
    cmp cl, byte [bp+006h]                    ; 3a 4e 06                    ; 0xc1c0a vgabios.c:1302
    jnbe short 01c26h                         ; 77 17                       ; 0xc1c0d
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc1c0f vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1c12
    mov es, ax                                ; 8e c0                       ; 0xc1c15
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1c17
    xor ah, ah                                ; 30 e4                       ; 0xc1c1a vgabios.c:1306
    call 0379eh                               ; e8 7f 1b                    ; 0xc1c1c
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc1c1f
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc1c22 vgabios.c:1307
    jne short 01c29h                          ; 75 03                       ; 0xc1c24
    jmp near 0226eh                           ; e9 45 06                    ; 0xc1c26
    mov bx, 00084h                            ; bb 84 00                    ; 0xc1c29 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1c2c
    mov es, ax                                ; 8e c0                       ; 0xc1c2f
    mov cl, byte [es:bx]                      ; 26 8a 0f                    ; 0xc1c31
    xor ch, ch                                ; 30 ed                       ; 0xc1c34 vgabios.c:48
    inc cx                                    ; 41                          ; 0xc1c36
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc1c37 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc1c3a
    mov word [bp-018h], ax                    ; 89 46 e8                    ; 0xc1c3d vgabios.c:58
    cmp byte [bp+008h], 0ffh                  ; 80 7e 08 ff                 ; 0xc1c40 vgabios.c:1314
    jne short 01c4fh                          ; 75 09                       ; 0xc1c44
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc1c46 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1c49
    mov byte [bp+008h], al                    ; 88 46 08                    ; 0xc1c4c vgabios.c:48
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1c4f vgabios.c:1317
    xor ah, ah                                ; 30 e4                       ; 0xc1c52
    cmp ax, cx                                ; 39 c8                       ; 0xc1c54
    jc short 01c5fh                           ; 72 07                       ; 0xc1c56
    mov al, cl                                ; 88 c8                       ; 0xc1c58
    db  0feh, 0c8h
    ; dec al                                    ; fe c8                     ; 0xc1c5a
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc1c5c
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1c5f vgabios.c:1318
    xor ah, ah                                ; 30 e4                       ; 0xc1c62
    cmp ax, word [bp-018h]                    ; 3b 46 e8                    ; 0xc1c64
    jc short 01c71h                           ; 72 08                       ; 0xc1c67
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc1c69
    db  0feh, 0c8h
    ; dec al                                    ; fe c8                     ; 0xc1c6c
    mov byte [bp+006h], al                    ; 88 46 06                    ; 0xc1c6e
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1c71 vgabios.c:1319
    xor ah, ah                                ; 30 e4                       ; 0xc1c74
    cmp ax, cx                                ; 39 c8                       ; 0xc1c76
    jbe short 01c7dh                          ; 76 03                       ; 0xc1c78
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc1c7a
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1c7d vgabios.c:1320
    sub al, byte [bp-008h]                    ; 2a 46 f8                    ; 0xc1c80
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc1c83
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc1c85
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc1c88 vgabios.c:1322
    mov byte [bp-01ah], al                    ; 88 46 e6                    ; 0xc1c8b
    mov byte [bp-019h], 000h                  ; c6 46 e7 00                 ; 0xc1c8e
    mov bx, word [bp-01ah]                    ; 8b 5e e6                    ; 0xc1c92
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1c95
    mov ax, word [bp-018h]                    ; 8b 46 e8                    ; 0xc1c98
    dec ax                                    ; 48                          ; 0xc1c9b
    mov word [bp-020h], ax                    ; 89 46 e0                    ; 0xc1c9c
    mov ax, cx                                ; 89 c8                       ; 0xc1c9f
    dec ax                                    ; 48                          ; 0xc1ca1
    mov word [bp-01ch], ax                    ; 89 46 e4                    ; 0xc1ca2
    mov ax, cx                                ; 89 c8                       ; 0xc1ca5
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1ca7
    mov di, ax                                ; 89 c7                       ; 0xc1caa
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc1cac
    jne short 01d05h                          ; 75 52                       ; 0xc1cb1
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc1cb3 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1cb6
    mov es, ax                                ; 8e c0                       ; 0xc1cb9
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc1cbb
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc1cbe vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc1cc1
    mul dx                                    ; f7 e2                       ; 0xc1cc3
    mov word [bp-016h], ax                    ; 89 46 ea                    ; 0xc1cc5
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1cc8 vgabios.c:1330
    jne short 01d08h                          ; 75 3a                       ; 0xc1ccc
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc1cce
    jne short 01d08h                          ; 75 34                       ; 0xc1cd2
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1cd4
    jne short 01d08h                          ; 75 2e                       ; 0xc1cd8
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1cda
    xor ah, ah                                ; 30 e4                       ; 0xc1cdd
    cmp ax, word [bp-01ch]                    ; 3b 46 e4                    ; 0xc1cdf
    jne short 01d08h                          ; 75 24                       ; 0xc1ce2
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1ce4
    cmp ax, word [bp-020h]                    ; 3b 46 e0                    ; 0xc1ce7
    jne short 01d08h                          ; 75 1c                       ; 0xc1cea
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1cec vgabios.c:1332
    sal ax, 008h                              ; c1 e0 08                    ; 0xc1cef
    add ax, strict word 00020h                ; 05 20 00                    ; 0xc1cf2
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1cf5
    mov cx, di                                ; 89 f9                       ; 0xc1cf9
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1cfb
    jcxz 01d02h                               ; e3 02                       ; 0xc1cfe
    rep stosw                                 ; f3 ab                       ; 0xc1d00
    jmp near 0226eh                           ; e9 69 05                    ; 0xc1d02 vgabios.c:1334
    jmp near 01e80h                           ; e9 78 01                    ; 0xc1d05
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1d08 vgabios.c:1336
    jne short 01d6eh                          ; 75 60                       ; 0xc1d0c
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1d0e vgabios.c:1337
    xor ah, ah                                ; 30 e4                       ; 0xc1d11
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc1d13
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1d16
    xor ah, ah                                ; 30 e4                       ; 0xc1d19
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1d1b
    jc short 01d70h                           ; 72 50                       ; 0xc1d1e
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc1d20 vgabios.c:1339
    xor dh, dh                                ; 30 f6                       ; 0xc1d23
    mov di, word [bp-01eh]                    ; 8b 7e e2                    ; 0xc1d25
    add di, dx                                ; 01 d7                       ; 0xc1d28
    cmp di, ax                                ; 39 c7                       ; 0xc1d2a
    jnbe short 01d32h                         ; 77 04                       ; 0xc1d2c
    test dl, dl                               ; 84 d2                       ; 0xc1d2e
    jne short 01d73h                          ; 75 41                       ; 0xc1d30
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc1d32 vgabios.c:1340
    xor ch, ch                                ; 30 ed                       ; 0xc1d35
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1d37
    xor ah, ah                                ; 30 e4                       ; 0xc1d3a
    mov si, ax                                ; 89 c6                       ; 0xc1d3c
    sal si, 008h                              ; c1 e6 08                    ; 0xc1d3e
    add si, strict byte 00020h                ; 83 c6 20                    ; 0xc1d41
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc1d44
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1d47
    mov dx, ax                                ; 89 c2                       ; 0xc1d4a
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1d4c
    xor ah, ah                                ; 30 e4                       ; 0xc1d4f
    mov di, ax                                ; 89 c7                       ; 0xc1d51
    add di, dx                                ; 01 d7                       ; 0xc1d53
    add di, di                                ; 01 ff                       ; 0xc1d55
    add di, word [bp-016h]                    ; 03 7e ea                    ; 0xc1d57
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1d5a
    xor bh, bh                                ; 30 ff                       ; 0xc1d5d
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1d5f
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1d62
    mov ax, si                                ; 89 f0                       ; 0xc1d66
    jcxz 01d6ch                               ; e3 02                       ; 0xc1d68
    rep stosw                                 ; f3 ab                       ; 0xc1d6a
    jmp short 01db8h                          ; eb 4a                       ; 0xc1d6c vgabios.c:1341
    jmp short 01dbeh                          ; eb 4e                       ; 0xc1d6e
    jmp near 0226eh                           ; e9 fb 04                    ; 0xc1d70
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc1d73 vgabios.c:1342
    xor ch, ch                                ; 30 ed                       ; 0xc1d76
    mov ax, di                                ; 89 f8                       ; 0xc1d78
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1d7a
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc1d7d
    mov byte [bp-014h], dl                    ; 88 56 ec                    ; 0xc1d80
    mov byte [bp-013h], ch                    ; 88 6e ed                    ; 0xc1d83
    add ax, word [bp-014h]                    ; 03 46 ec                    ; 0xc1d86
    add ax, ax                                ; 01 c0                       ; 0xc1d89
    mov si, word [bp-016h]                    ; 8b 76 ea                    ; 0xc1d8b
    add si, ax                                ; 01 c6                       ; 0xc1d8e
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1d90
    xor bh, bh                                ; 30 ff                       ; 0xc1d93
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1d95
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1d98
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc1d9c
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1d9f
    add ax, word [bp-014h]                    ; 03 46 ec                    ; 0xc1da2
    add ax, ax                                ; 01 c0                       ; 0xc1da5
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1da7
    add di, ax                                ; 01 c7                       ; 0xc1daa
    mov dx, bx                                ; 89 da                       ; 0xc1dac
    mov es, bx                                ; 8e c3                       ; 0xc1dae
    jcxz 01db8h                               ; e3 06                       ; 0xc1db0
    push DS                                   ; 1e                          ; 0xc1db2
    mov ds, dx                                ; 8e da                       ; 0xc1db3
    rep movsw                                 ; f3 a5                       ; 0xc1db5
    pop DS                                    ; 1f                          ; 0xc1db7
    inc word [bp-01eh]                        ; ff 46 e2                    ; 0xc1db8 vgabios.c:1343
    jmp near 01d16h                           ; e9 58 ff                    ; 0xc1dbb
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1dbe vgabios.c:1346
    xor ah, ah                                ; 30 e4                       ; 0xc1dc1
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc1dc3
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1dc6
    xor ah, ah                                ; 30 e4                       ; 0xc1dc9
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1dcb
    jnbe short 01d70h                         ; 77 a0                       ; 0xc1dce
    mov dl, al                                ; 88 c2                       ; 0xc1dd0 vgabios.c:1348
    xor dh, dh                                ; 30 f6                       ; 0xc1dd2
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1dd4
    add ax, dx                                ; 01 d0                       ; 0xc1dd7
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1dd9
    jnbe short 01de4h                         ; 77 06                       ; 0xc1ddc
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1dde
    jne short 01e20h                          ; 75 3c                       ; 0xc1de2
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc1de4 vgabios.c:1349
    xor ch, ch                                ; 30 ed                       ; 0xc1de7
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1de9
    xor ah, ah                                ; 30 e4                       ; 0xc1dec
    mov si, ax                                ; 89 c6                       ; 0xc1dee
    sal si, 008h                              ; c1 e6 08                    ; 0xc1df0
    add si, strict byte 00020h                ; 83 c6 20                    ; 0xc1df3
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc1df6
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1df9
    mov dx, ax                                ; 89 c2                       ; 0xc1dfc
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1dfe
    xor ah, ah                                ; 30 e4                       ; 0xc1e01
    add ax, dx                                ; 01 d0                       ; 0xc1e03
    add ax, ax                                ; 01 c0                       ; 0xc1e05
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1e07
    add di, ax                                ; 01 c7                       ; 0xc1e0a
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1e0c
    xor bh, bh                                ; 30 ff                       ; 0xc1e0f
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1e11
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1e14
    mov ax, si                                ; 89 f0                       ; 0xc1e18
    jcxz 01e1eh                               ; e3 02                       ; 0xc1e1a
    rep stosw                                 ; f3 ab                       ; 0xc1e1c
    jmp short 01e70h                          ; eb 50                       ; 0xc1e1e vgabios.c:1350
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1e20 vgabios.c:1351
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc1e23
    mov byte [bp-013h], dh                    ; 88 76 ed                    ; 0xc1e26
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1e29
    xor ah, ah                                ; 30 e4                       ; 0xc1e2c
    mov dx, word [bp-01eh]                    ; 8b 56 e2                    ; 0xc1e2e
    sub dx, ax                                ; 29 c2                       ; 0xc1e31
    mov ax, dx                                ; 89 d0                       ; 0xc1e33
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1e35
    mov cl, byte [bp-008h]                    ; 8a 4e f8                    ; 0xc1e38
    xor ch, ch                                ; 30 ed                       ; 0xc1e3b
    add ax, cx                                ; 01 c8                       ; 0xc1e3d
    add ax, ax                                ; 01 c0                       ; 0xc1e3f
    mov si, word [bp-016h]                    ; 8b 76 ea                    ; 0xc1e41
    add si, ax                                ; 01 c6                       ; 0xc1e44
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1e46
    xor bh, bh                                ; 30 ff                       ; 0xc1e49
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1e4b
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1e4e
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc1e52
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1e55
    add ax, cx                                ; 01 c8                       ; 0xc1e58
    add ax, ax                                ; 01 c0                       ; 0xc1e5a
    mov di, word [bp-016h]                    ; 8b 7e ea                    ; 0xc1e5c
    add di, ax                                ; 01 c7                       ; 0xc1e5f
    mov cx, word [bp-014h]                    ; 8b 4e ec                    ; 0xc1e61
    mov dx, bx                                ; 89 da                       ; 0xc1e64
    mov es, bx                                ; 8e c3                       ; 0xc1e66
    jcxz 01e70h                               ; e3 06                       ; 0xc1e68
    push DS                                   ; 1e                          ; 0xc1e6a
    mov ds, dx                                ; 8e da                       ; 0xc1e6b
    rep movsw                                 ; f3 a5                       ; 0xc1e6d
    pop DS                                    ; 1f                          ; 0xc1e6f
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1e70 vgabios.c:1352
    xor ah, ah                                ; 30 e4                       ; 0xc1e73
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1e75
    jc short 01eadh                           ; 72 33                       ; 0xc1e78
    dec word [bp-01eh]                        ; ff 4e e2                    ; 0xc1e7a vgabios.c:1353
    jmp near 01dc6h                           ; e9 46 ff                    ; 0xc1e7d
    mov si, word [bp-01ah]                    ; 8b 76 e6                    ; 0xc1e80 vgabios.c:1359
    mov al, byte [si+0482ch]                  ; 8a 84 2c 48                 ; 0xc1e83
    xor ah, ah                                ; 30 e4                       ; 0xc1e87
    mov si, ax                                ; 89 c6                       ; 0xc1e89
    sal si, 006h                              ; c1 e6 06                    ; 0xc1e8b
    mov al, byte [si+04842h]                  ; 8a 84 42 48                 ; 0xc1e8e
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc1e92
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc1e95 vgabios.c:1360
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc1e99
    jc short 01ea9h                           ; 72 0c                       ; 0xc1e9b
    jbe short 01eb0h                          ; 76 11                       ; 0xc1e9d
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc1e9f
    je short 01eddh                           ; 74 3a                       ; 0xc1ea1
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc1ea3
    je short 01eb0h                           ; 74 09                       ; 0xc1ea5
    jmp short 01eadh                          ; eb 04                       ; 0xc1ea7
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc1ea9
    je short 01ee0h                           ; 74 33                       ; 0xc1eab
    jmp near 0226eh                           ; e9 be 03                    ; 0xc1ead
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1eb0 vgabios.c:1364
    jne short 01f1ch                          ; 75 66                       ; 0xc1eb4
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc1eb6
    jne short 01f1ch                          ; 75 60                       ; 0xc1eba
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1ebc
    jne short 01f1ch                          ; 75 5a                       ; 0xc1ec0
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1ec2
    xor ah, ah                                ; 30 e4                       ; 0xc1ec5
    mov dx, cx                                ; 89 ca                       ; 0xc1ec7
    dec dx                                    ; 4a                          ; 0xc1ec9
    cmp ax, dx                                ; 39 d0                       ; 0xc1eca
    jne short 01f1ch                          ; 75 4e                       ; 0xc1ecc
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1ece
    xor ah, dh                                ; 30 f4                       ; 0xc1ed1
    mov dx, word [bp-018h]                    ; 8b 56 e8                    ; 0xc1ed3
    dec dx                                    ; 4a                          ; 0xc1ed6
    cmp ax, dx                                ; 39 d0                       ; 0xc1ed7
    je short 01ee3h                           ; 74 08                       ; 0xc1ed9
    jmp short 01f1ch                          ; eb 3f                       ; 0xc1edb
    jmp near 02152h                           ; e9 72 02                    ; 0xc1edd
    jmp near 0200ch                           ; e9 29 01                    ; 0xc1ee0
    mov ax, 00205h                            ; b8 05 02                    ; 0xc1ee3 vgabios.c:1366
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1ee6
    out DX, ax                                ; ef                          ; 0xc1ee9
    mov ax, cx                                ; 89 c8                       ; 0xc1eea vgabios.c:1367
    mul word [bp-018h]                        ; f7 66 e8                    ; 0xc1eec
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc1eef
    xor dh, dh                                ; 30 f6                       ; 0xc1ef2
    mul dx                                    ; f7 e2                       ; 0xc1ef4
    mov dl, byte [bp-010h]                    ; 8a 56 f0                    ; 0xc1ef6
    xor dh, dh                                ; 30 f6                       ; 0xc1ef9
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1efb
    xor bh, bh                                ; 30 ff                       ; 0xc1efe
    sal bx, 003h                              ; c1 e3 03                    ; 0xc1f00
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1f03
    mov cx, ax                                ; 89 c1                       ; 0xc1f07
    mov ax, dx                                ; 89 d0                       ; 0xc1f09
    xor di, di                                ; 31 ff                       ; 0xc1f0b
    mov es, bx                                ; 8e c3                       ; 0xc1f0d
    jcxz 01f13h                               ; e3 02                       ; 0xc1f0f
    rep stosb                                 ; f3 aa                       ; 0xc1f11
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc1f13 vgabios.c:1368
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1f16
    out DX, ax                                ; ef                          ; 0xc1f19
    jmp short 01eadh                          ; eb 91                       ; 0xc1f1a vgabios.c:1370
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1f1c vgabios.c:1372
    jne short 01f8eh                          ; 75 6c                       ; 0xc1f20
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1f22 vgabios.c:1373
    xor ah, ah                                ; 30 e4                       ; 0xc1f25
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc1f27
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1f2a
    xor ah, ah                                ; 30 e4                       ; 0xc1f2d
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1f2f
    jc short 01f8bh                           ; 72 57                       ; 0xc1f32
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc1f34 vgabios.c:1375
    xor dh, dh                                ; 30 f6                       ; 0xc1f37
    add dx, word [bp-01eh]                    ; 03 56 e2                    ; 0xc1f39
    cmp dx, ax                                ; 39 c2                       ; 0xc1f3c
    jnbe short 01f46h                         ; 77 06                       ; 0xc1f3e
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1f40
    jne short 01f67h                          ; 75 21                       ; 0xc1f44
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1f46 vgabios.c:1376
    xor ah, ah                                ; 30 e4                       ; 0xc1f49
    push ax                                   ; 50                          ; 0xc1f4b
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1f4c
    push ax                                   ; 50                          ; 0xc1f4f
    mov cl, byte [bp-018h]                    ; 8a 4e e8                    ; 0xc1f50
    xor ch, ch                                ; 30 ed                       ; 0xc1f53
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1f55
    xor bh, bh                                ; 30 ff                       ; 0xc1f58
    mov dl, byte [bp-01eh]                    ; 8a 56 e2                    ; 0xc1f5a
    xor dh, dh                                ; 30 f6                       ; 0xc1f5d
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1f5f
    call 0193eh                               ; e8 d9 f9                    ; 0xc1f62
    jmp short 01f86h                          ; eb 1f                       ; 0xc1f65 vgabios.c:1377
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1f67 vgabios.c:1378
    push ax                                   ; 50                          ; 0xc1f6a
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc1f6b
    push ax                                   ; 50                          ; 0xc1f6e
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc1f6f
    xor ch, ch                                ; 30 ed                       ; 0xc1f72
    mov bl, byte [bp-01eh]                    ; 8a 5e e2                    ; 0xc1f74
    xor bh, bh                                ; 30 ff                       ; 0xc1f77
    mov dl, bl                                ; 88 da                       ; 0xc1f79
    add dl, byte [bp-006h]                    ; 02 56 fa                    ; 0xc1f7b
    xor dh, dh                                ; 30 f6                       ; 0xc1f7e
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1f80
    call 018b0h                               ; e8 2a f9                    ; 0xc1f83
    inc word [bp-01eh]                        ; ff 46 e2                    ; 0xc1f86 vgabios.c:1379
    jmp short 01f2ah                          ; eb 9f                       ; 0xc1f89
    jmp near 0226eh                           ; e9 e0 02                    ; 0xc1f8b
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1f8e vgabios.c:1382
    xor ah, ah                                ; 30 e4                       ; 0xc1f91
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc1f93
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1f96
    xor ah, ah                                ; 30 e4                       ; 0xc1f99
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1f9b
    jnbe short 01f8bh                         ; 77 eb                       ; 0xc1f9e
    mov dl, al                                ; 88 c2                       ; 0xc1fa0 vgabios.c:1384
    xor dh, dh                                ; 30 f6                       ; 0xc1fa2
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1fa4
    add ax, dx                                ; 01 d0                       ; 0xc1fa7
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc1fa9
    jnbe short 01fb4h                         ; 77 06                       ; 0xc1fac
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1fae
    jne short 01fd5h                          ; 75 21                       ; 0xc1fb2
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1fb4 vgabios.c:1385
    xor ah, ah                                ; 30 e4                       ; 0xc1fb7
    push ax                                   ; 50                          ; 0xc1fb9
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1fba
    push ax                                   ; 50                          ; 0xc1fbd
    mov cl, byte [bp-018h]                    ; 8a 4e e8                    ; 0xc1fbe
    xor ch, ch                                ; 30 ed                       ; 0xc1fc1
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1fc3
    xor bh, bh                                ; 30 ff                       ; 0xc1fc6
    mov dl, byte [bp-01eh]                    ; 8a 56 e2                    ; 0xc1fc8
    xor dh, dh                                ; 30 f6                       ; 0xc1fcb
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1fcd
    call 0193eh                               ; e8 6b f9                    ; 0xc1fd0
    jmp short 01ffdh                          ; eb 28                       ; 0xc1fd3 vgabios.c:1386
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1fd5 vgabios.c:1387
    xor ah, ah                                ; 30 e4                       ; 0xc1fd8
    push ax                                   ; 50                          ; 0xc1fda
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc1fdb
    push ax                                   ; 50                          ; 0xc1fde
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc1fdf
    xor ch, ch                                ; 30 ed                       ; 0xc1fe2
    mov bl, byte [bp-01eh]                    ; 8a 5e e2                    ; 0xc1fe4
    xor bh, bh                                ; 30 ff                       ; 0xc1fe7
    mov dl, bl                                ; 88 da                       ; 0xc1fe9
    sub dl, byte [bp-006h]                    ; 2a 56 fa                    ; 0xc1feb
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1fee
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc1ff1
    mov byte [bp-013h], dh                    ; 88 76 ed                    ; 0xc1ff4
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc1ff7
    call 018b0h                               ; e8 b3 f8                    ; 0xc1ffa
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1ffd vgabios.c:1388
    xor ah, ah                                ; 30 e4                       ; 0xc2000
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc2002
    jc short 02056h                           ; 72 4f                       ; 0xc2005
    dec word [bp-01eh]                        ; ff 4e e2                    ; 0xc2007 vgabios.c:1389
    jmp short 01f96h                          ; eb 8a                       ; 0xc200a
    mov cl, byte [bx+047afh]                  ; 8a 8f af 47                 ; 0xc200c vgabios.c:1394
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc2010 vgabios.c:1395
    jne short 02059h                          ; 75 43                       ; 0xc2014
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc2016
    jne short 02059h                          ; 75 3d                       ; 0xc201a
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc201c
    jne short 02059h                          ; 75 37                       ; 0xc2020
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2022
    cmp ax, word [bp-01ch]                    ; 3b 46 e4                    ; 0xc2025
    jne short 02059h                          ; 75 2f                       ; 0xc2028
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc202a
    cmp ax, word [bp-020h]                    ; 3b 46 e0                    ; 0xc202d
    jne short 02059h                          ; 75 27                       ; 0xc2030
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc2032 vgabios.c:1397
    xor dh, dh                                ; 30 f6                       ; 0xc2035
    mov ax, di                                ; 89 f8                       ; 0xc2037
    mul dx                                    ; f7 e2                       ; 0xc2039
    mov dl, cl                                ; 88 ca                       ; 0xc203b
    xor dh, dh                                ; 30 f6                       ; 0xc203d
    mul dx                                    ; f7 e2                       ; 0xc203f
    mov dl, byte [bp-010h]                    ; 8a 56 f0                    ; 0xc2041
    xor dh, dh                                ; 30 f6                       ; 0xc2044
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc2046
    mov cx, ax                                ; 89 c1                       ; 0xc204a
    mov ax, dx                                ; 89 d0                       ; 0xc204c
    xor di, di                                ; 31 ff                       ; 0xc204e
    mov es, bx                                ; 8e c3                       ; 0xc2050
    jcxz 02056h                               ; e3 02                       ; 0xc2052
    rep stosb                                 ; f3 aa                       ; 0xc2054
    jmp near 0226eh                           ; e9 15 02                    ; 0xc2056 vgabios.c:1399
    cmp cl, 002h                              ; 80 f9 02                    ; 0xc2059 vgabios.c:1401
    jne short 02067h                          ; 75 09                       ; 0xc205c
    sal byte [bp-008h], 1                     ; d0 66 f8                    ; 0xc205e vgabios.c:1403
    sal byte [bp-00ah], 1                     ; d0 66 f6                    ; 0xc2061 vgabios.c:1404
    sal word [bp-018h], 1                     ; d1 66 e8                    ; 0xc2064 vgabios.c:1405
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc2067 vgabios.c:1408
    jne short 020d6h                          ; 75 69                       ; 0xc206b
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc206d vgabios.c:1409
    xor ah, ah                                ; 30 e4                       ; 0xc2070
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc2072
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2075
    xor ah, ah                                ; 30 e4                       ; 0xc2078
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc207a
    jc short 02056h                           ; 72 d7                       ; 0xc207d
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc207f vgabios.c:1411
    xor dh, dh                                ; 30 f6                       ; 0xc2082
    add dx, word [bp-01eh]                    ; 03 56 e2                    ; 0xc2084
    cmp dx, ax                                ; 39 c2                       ; 0xc2087
    jnbe short 02091h                         ; 77 06                       ; 0xc2089
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc208b
    jne short 020b2h                          ; 75 21                       ; 0xc208f
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc2091 vgabios.c:1412
    xor ah, ah                                ; 30 e4                       ; 0xc2094
    push ax                                   ; 50                          ; 0xc2096
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2097
    push ax                                   ; 50                          ; 0xc209a
    mov cl, byte [bp-018h]                    ; 8a 4e e8                    ; 0xc209b
    xor ch, ch                                ; 30 ed                       ; 0xc209e
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc20a0
    xor bh, bh                                ; 30 ff                       ; 0xc20a3
    mov dl, byte [bp-01eh]                    ; 8a 56 e2                    ; 0xc20a5
    xor dh, dh                                ; 30 f6                       ; 0xc20a8
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc20aa
    call 01a6fh                               ; e8 bf f9                    ; 0xc20ad
    jmp short 020d1h                          ; eb 1f                       ; 0xc20b0 vgabios.c:1413
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc20b2 vgabios.c:1414
    push ax                                   ; 50                          ; 0xc20b5
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc20b6
    push ax                                   ; 50                          ; 0xc20b9
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc20ba
    xor ch, ch                                ; 30 ed                       ; 0xc20bd
    mov bl, byte [bp-01eh]                    ; 8a 5e e2                    ; 0xc20bf
    xor bh, bh                                ; 30 ff                       ; 0xc20c2
    mov dl, bl                                ; 88 da                       ; 0xc20c4
    add dl, byte [bp-006h]                    ; 02 56 fa                    ; 0xc20c6
    xor dh, dh                                ; 30 f6                       ; 0xc20c9
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc20cb
    call 019b9h                               ; e8 e8 f8                    ; 0xc20ce
    inc word [bp-01eh]                        ; ff 46 e2                    ; 0xc20d1 vgabios.c:1415
    jmp short 02075h                          ; eb 9f                       ; 0xc20d4
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc20d6 vgabios.c:1418
    xor ah, ah                                ; 30 e4                       ; 0xc20d9
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc20db
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc20de
    xor ah, ah                                ; 30 e4                       ; 0xc20e1
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc20e3
    jnbe short 02150h                         ; 77 68                       ; 0xc20e6
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc20e8 vgabios.c:1420
    xor dh, dh                                ; 30 f6                       ; 0xc20eb
    add ax, dx                                ; 01 d0                       ; 0xc20ed
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc20ef
    jnbe short 020f8h                         ; 77 04                       ; 0xc20f2
    test dl, dl                               ; 84 d2                       ; 0xc20f4
    jne short 02122h                          ; 75 2a                       ; 0xc20f6
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc20f8 vgabios.c:1421
    xor ah, ah                                ; 30 e4                       ; 0xc20fb
    push ax                                   ; 50                          ; 0xc20fd
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc20fe
    push ax                                   ; 50                          ; 0xc2101
    mov cl, byte [bp-018h]                    ; 8a 4e e8                    ; 0xc2102
    xor ch, ch                                ; 30 ed                       ; 0xc2105
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc2107
    xor bh, bh                                ; 30 ff                       ; 0xc210a
    mov dl, byte [bp-01eh]                    ; 8a 56 e2                    ; 0xc210c
    xor dh, dh                                ; 30 f6                       ; 0xc210f
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2111
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc2114
    mov byte [bp-013h], ah                    ; 88 66 ed                    ; 0xc2117
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc211a
    call 01a6fh                               ; e8 4f f9                    ; 0xc211d
    jmp short 02141h                          ; eb 1f                       ; 0xc2120 vgabios.c:1422
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2122 vgabios.c:1423
    xor ah, ah                                ; 30 e4                       ; 0xc2125
    push ax                                   ; 50                          ; 0xc2127
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc2128
    push ax                                   ; 50                          ; 0xc212b
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc212c
    xor ch, ch                                ; 30 ed                       ; 0xc212f
    mov bl, byte [bp-01eh]                    ; 8a 5e e2                    ; 0xc2131
    xor bh, bh                                ; 30 ff                       ; 0xc2134
    mov dl, bl                                ; 88 da                       ; 0xc2136
    sub dl, byte [bp-006h]                    ; 2a 56 fa                    ; 0xc2138
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc213b
    call 019b9h                               ; e8 78 f8                    ; 0xc213e
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2141 vgabios.c:1424
    xor ah, ah                                ; 30 e4                       ; 0xc2144
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc2146
    jc short 02191h                           ; 72 46                       ; 0xc2149
    dec word [bp-01eh]                        ; ff 4e e2                    ; 0xc214b vgabios.c:1425
    jmp short 020deh                          ; eb 8e                       ; 0xc214e
    jmp short 02191h                          ; eb 3f                       ; 0xc2150
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc2152 vgabios.c:1430
    jne short 02194h                          ; 75 3c                       ; 0xc2156
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc2158
    jne short 02194h                          ; 75 36                       ; 0xc215c
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc215e
    jne short 02194h                          ; 75 30                       ; 0xc2162
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2164
    cmp ax, word [bp-01ch]                    ; 3b 46 e4                    ; 0xc2167
    jne short 02194h                          ; 75 28                       ; 0xc216a
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc216c
    cmp ax, word [bp-020h]                    ; 3b 46 e0                    ; 0xc216f
    jne short 02194h                          ; 75 20                       ; 0xc2172
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc2174 vgabios.c:1432
    xor dh, dh                                ; 30 f6                       ; 0xc2177
    mov ax, di                                ; 89 f8                       ; 0xc2179
    mul dx                                    ; f7 e2                       ; 0xc217b
    mov cx, ax                                ; 89 c1                       ; 0xc217d
    sal cx, 003h                              ; c1 e1 03                    ; 0xc217f
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc2182
    xor ah, ah                                ; 30 e4                       ; 0xc2185
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2187
    xor di, di                                ; 31 ff                       ; 0xc218b
    jcxz 02191h                               ; e3 02                       ; 0xc218d
    rep stosb                                 ; f3 aa                       ; 0xc218f
    jmp near 0226eh                           ; e9 da 00                    ; 0xc2191 vgabios.c:1434
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc2194 vgabios.c:1437
    jne short 02200h                          ; 75 66                       ; 0xc2198
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc219a vgabios.c:1438
    xor ah, ah                                ; 30 e4                       ; 0xc219d
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc219f
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc21a2
    xor ah, ah                                ; 30 e4                       ; 0xc21a5
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc21a7
    jc short 02191h                           ; 72 e5                       ; 0xc21aa
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc21ac vgabios.c:1440
    xor dh, dh                                ; 30 f6                       ; 0xc21af
    add dx, word [bp-01eh]                    ; 03 56 e2                    ; 0xc21b1
    cmp dx, ax                                ; 39 c2                       ; 0xc21b4
    jnbe short 021beh                         ; 77 06                       ; 0xc21b6
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc21b8
    jne short 021ddh                          ; 75 1f                       ; 0xc21bc
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc21be vgabios.c:1441
    xor ah, ah                                ; 30 e4                       ; 0xc21c1
    push ax                                   ; 50                          ; 0xc21c3
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc21c4
    push ax                                   ; 50                          ; 0xc21c7
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc21c8
    xor bh, bh                                ; 30 ff                       ; 0xc21cb
    mov dl, byte [bp-01eh]                    ; 8a 56 e2                    ; 0xc21cd
    xor dh, dh                                ; 30 f6                       ; 0xc21d0
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc21d2
    mov cx, word [bp-018h]                    ; 8b 4e e8                    ; 0xc21d5
    call 01b84h                               ; e8 a9 f9                    ; 0xc21d8
    jmp short 021fbh                          ; eb 1e                       ; 0xc21db vgabios.c:1442
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc21dd vgabios.c:1443
    push ax                                   ; 50                          ; 0xc21e0
    push word [bp-018h]                       ; ff 76 e8                    ; 0xc21e1
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc21e4
    xor ch, ch                                ; 30 ed                       ; 0xc21e7
    mov bl, byte [bp-01eh]                    ; 8a 5e e2                    ; 0xc21e9
    xor bh, bh                                ; 30 ff                       ; 0xc21ec
    mov dl, bl                                ; 88 da                       ; 0xc21ee
    add dl, byte [bp-006h]                    ; 02 56 fa                    ; 0xc21f0
    xor dh, dh                                ; 30 f6                       ; 0xc21f3
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc21f5
    call 01b03h                               ; e8 08 f9                    ; 0xc21f8
    inc word [bp-01eh]                        ; ff 46 e2                    ; 0xc21fb vgabios.c:1444
    jmp short 021a2h                          ; eb a2                       ; 0xc21fe
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2200 vgabios.c:1447
    xor ah, ah                                ; 30 e4                       ; 0xc2203
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc2205
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2208
    xor ah, ah                                ; 30 e4                       ; 0xc220b
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc220d
    jnbe short 0226eh                         ; 77 5c                       ; 0xc2210
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc2212 vgabios.c:1449
    xor dh, dh                                ; 30 f6                       ; 0xc2215
    add ax, dx                                ; 01 d0                       ; 0xc2217
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc2219
    jnbe short 02222h                         ; 77 04                       ; 0xc221c
    test dl, dl                               ; 84 d2                       ; 0xc221e
    jne short 02241h                          ; 75 1f                       ; 0xc2220
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc2222 vgabios.c:1450
    xor ah, ah                                ; 30 e4                       ; 0xc2225
    push ax                                   ; 50                          ; 0xc2227
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2228
    push ax                                   ; 50                          ; 0xc222b
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc222c
    xor bh, bh                                ; 30 ff                       ; 0xc222f
    mov dl, byte [bp-01eh]                    ; 8a 56 e2                    ; 0xc2231
    xor dh, dh                                ; 30 f6                       ; 0xc2234
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2236
    mov cx, word [bp-018h]                    ; 8b 4e e8                    ; 0xc2239
    call 01b84h                               ; e8 45 f9                    ; 0xc223c
    jmp short 0225fh                          ; eb 1e                       ; 0xc223f vgabios.c:1451
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2241 vgabios.c:1452
    xor ah, ah                                ; 30 e4                       ; 0xc2244
    push ax                                   ; 50                          ; 0xc2246
    push word [bp-018h]                       ; ff 76 e8                    ; 0xc2247
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc224a
    xor ch, ch                                ; 30 ed                       ; 0xc224d
    mov bl, byte [bp-01eh]                    ; 8a 5e e2                    ; 0xc224f
    xor bh, bh                                ; 30 ff                       ; 0xc2252
    mov dl, bl                                ; 88 da                       ; 0xc2254
    sub dl, byte [bp-006h]                    ; 2a 56 fa                    ; 0xc2256
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2259
    call 01b03h                               ; e8 a4 f8                    ; 0xc225c
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc225f vgabios.c:1453
    xor ah, ah                                ; 30 e4                       ; 0xc2262
    cmp ax, word [bp-01eh]                    ; 3b 46 e2                    ; 0xc2264
    jc short 0226eh                           ; 72 05                       ; 0xc2267
    dec word [bp-01eh]                        ; ff 4e e2                    ; 0xc2269 vgabios.c:1454
    jmp short 02208h                          ; eb 9a                       ; 0xc226c
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc226e vgabios.c:1465
    pop di                                    ; 5f                          ; 0xc2271
    pop si                                    ; 5e                          ; 0xc2272
    pop bp                                    ; 5d                          ; 0xc2273
    retn 00008h                               ; c2 08 00                    ; 0xc2274
  ; disGetNextSymbol 0xc2277 LB 0x224a -> off=0x0 cb=0000000000000111 uValue=00000000000c2277 'write_gfx_char_pl4'
write_gfx_char_pl4:                          ; 0xc2277 LB 0x111
    push bp                                   ; 55                          ; 0xc2277 vgabios.c:1468
    mov bp, sp                                ; 89 e5                       ; 0xc2278
    push si                                   ; 56                          ; 0xc227a
    push di                                   ; 57                          ; 0xc227b
    sub sp, strict byte 0000eh                ; 83 ec 0e                    ; 0xc227c
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc227f
    mov byte [bp-008h], dl                    ; 88 56 f8                    ; 0xc2282
    mov ch, bl                                ; 88 dd                       ; 0xc2285
    mov al, cl                                ; 88 c8                       ; 0xc2287
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc2289 vgabios.c:67
    xor dx, dx                                ; 31 d2                       ; 0xc228c
    mov es, dx                                ; 8e c2                       ; 0xc228e
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc2290
    mov bx, word [es:bx+002h]                 ; 26 8b 5f 02                 ; 0xc2293
    mov word [bp-012h], dx                    ; 89 56 ee                    ; 0xc2297 vgabios.c:68
    mov word [bp-00ch], bx                    ; 89 5e f4                    ; 0xc229a
    xor ah, ah                                ; 30 e4                       ; 0xc229d vgabios.c:1477
    mov bl, byte [bp+006h]                    ; 8a 5e 06                    ; 0xc229f
    xor bh, bh                                ; 30 ff                       ; 0xc22a2
    imul bx                                   ; f7 eb                       ; 0xc22a4
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc22a6
    xor dh, dh                                ; 30 f6                       ; 0xc22a9
    imul dx                                   ; f7 ea                       ; 0xc22ab
    mov si, ax                                ; 89 c6                       ; 0xc22ad
    mov al, ch                                ; 88 e8                       ; 0xc22af
    xor ah, ah                                ; 30 e4                       ; 0xc22b1
    add si, ax                                ; 01 c6                       ; 0xc22b3
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc22b5 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc22b8
    mov es, ax                                ; 8e c0                       ; 0xc22bb
    mov ax, word [es:di]                      ; 26 8b 05                    ; 0xc22bd
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc22c0 vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc22c3
    mul dx                                    ; f7 e2                       ; 0xc22c5
    add si, ax                                ; 01 c6                       ; 0xc22c7
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc22c9 vgabios.c:1479
    xor ah, ah                                ; 30 e4                       ; 0xc22cc
    imul bx                                   ; f7 eb                       ; 0xc22ce
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc22d0
    mov ax, 00f02h                            ; b8 02 0f                    ; 0xc22d3 vgabios.c:1480
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc22d6
    out DX, ax                                ; ef                          ; 0xc22d9
    mov ax, 00205h                            ; b8 05 02                    ; 0xc22da vgabios.c:1481
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc22dd
    out DX, ax                                ; ef                          ; 0xc22e0
    test byte [bp-008h], 080h                 ; f6 46 f8 80                 ; 0xc22e1 vgabios.c:1482
    je short 022edh                           ; 74 06                       ; 0xc22e5
    mov ax, 01803h                            ; b8 03 18                    ; 0xc22e7 vgabios.c:1484
    out DX, ax                                ; ef                          ; 0xc22ea
    jmp short 022f1h                          ; eb 04                       ; 0xc22eb vgabios.c:1486
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc22ed vgabios.c:1488
    out DX, ax                                ; ef                          ; 0xc22f0
    xor ch, ch                                ; 30 ed                       ; 0xc22f1 vgabios.c:1490
    cmp ch, byte [bp+006h]                    ; 3a 6e 06                    ; 0xc22f3
    jnc short 0236ah                          ; 73 72                       ; 0xc22f6
    mov al, ch                                ; 88 e8                       ; 0xc22f8 vgabios.c:1492
    xor ah, ah                                ; 30 e4                       ; 0xc22fa
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc22fc
    xor bh, bh                                ; 30 ff                       ; 0xc22ff
    imul bx                                   ; f7 eb                       ; 0xc2301
    mov bx, si                                ; 89 f3                       ; 0xc2303
    add bx, ax                                ; 01 c3                       ; 0xc2305
    mov byte [bp-006h], 000h                  ; c6 46 fa 00                 ; 0xc2307 vgabios.c:1493
    jmp short 0231fh                          ; eb 12                       ; 0xc230b
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc230d vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc2310
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc2312
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc2316 vgabios.c:1506
    cmp byte [bp-006h], 008h                  ; 80 7e fa 08                 ; 0xc2319
    jnc short 0236ch                          ; 73 4d                       ; 0xc231d
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc231f
    mov ax, 00080h                            ; b8 80 00                    ; 0xc2322
    sar ax, CL                                ; d3 f8                       ; 0xc2325
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc2327
    mov byte [bp-00dh], 000h                  ; c6 46 f3 00                 ; 0xc232a
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc232e
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2331
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc2334
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2336
    out DX, ax                                ; ef                          ; 0xc2339
    mov dx, bx                                ; 89 da                       ; 0xc233a
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc233c
    call 037c6h                               ; e8 84 14                    ; 0xc233f
    mov al, ch                                ; 88 e8                       ; 0xc2342
    xor ah, ah                                ; 30 e4                       ; 0xc2344
    add ax, word [bp-010h]                    ; 03 46 f0                    ; 0xc2346
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc2349
    mov di, word [bp-012h]                    ; 8b 7e ee                    ; 0xc234c
    add di, ax                                ; 01 c7                       ; 0xc234f
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc2351
    xor ah, ah                                ; 30 e4                       ; 0xc2354
    test word [bp-00eh], ax                   ; 85 46 f2                    ; 0xc2356
    je short 0230dh                           ; 74 b2                       ; 0xc2359
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc235b
    and AL, strict byte 00fh                  ; 24 0f                       ; 0xc235e
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc2360
    mov es, dx                                ; 8e c2                       ; 0xc2363
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2365
    jmp short 02316h                          ; eb ac                       ; 0xc2368
    jmp short 02370h                          ; eb 04                       ; 0xc236a
    db  0feh, 0c5h
    ; inc ch                                    ; fe c5                     ; 0xc236c vgabios.c:1507
    jmp short 022f3h                          ; eb 83                       ; 0xc236e
    mov ax, 0ff08h                            ; b8 08 ff                    ; 0xc2370 vgabios.c:1508
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2373
    out DX, ax                                ; ef                          ; 0xc2376
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc2377 vgabios.c:1509
    out DX, ax                                ; ef                          ; 0xc237a
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc237b vgabios.c:1510
    out DX, ax                                ; ef                          ; 0xc237e
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc237f vgabios.c:1511
    pop di                                    ; 5f                          ; 0xc2382
    pop si                                    ; 5e                          ; 0xc2383
    pop bp                                    ; 5d                          ; 0xc2384
    retn 00006h                               ; c2 06 00                    ; 0xc2385
  ; disGetNextSymbol 0xc2388 LB 0x2139 -> off=0x0 cb=0000000000000112 uValue=00000000000c2388 'write_gfx_char_cga'
write_gfx_char_cga:                          ; 0xc2388 LB 0x112
    push si                                   ; 56                          ; 0xc2388 vgabios.c:1514
    push di                                   ; 57                          ; 0xc2389
    enter 0000ch, 000h                        ; c8 0c 00 00                 ; 0xc238a
    mov bh, al                                ; 88 c7                       ; 0xc238e
    mov ch, dl                                ; 88 d5                       ; 0xc2390
    mov al, bl                                ; 88 d8                       ; 0xc2392
    mov di, 0556ah                            ; bf 6a 55                    ; 0xc2394 vgabios.c:1521
    xor ah, ah                                ; 30 e4                       ; 0xc2397 vgabios.c:1522
    mov dl, byte [bp+00ah]                    ; 8a 56 0a                    ; 0xc2399
    xor dh, dh                                ; 30 f6                       ; 0xc239c
    imul dx                                   ; f7 ea                       ; 0xc239e
    mov dl, cl                                ; 88 ca                       ; 0xc23a0
    xor dh, dh                                ; 30 f6                       ; 0xc23a2
    imul dx, dx, 00140h                       ; 69 d2 40 01                 ; 0xc23a4
    add ax, dx                                ; 01 d0                       ; 0xc23a8
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc23aa
    mov al, bh                                ; 88 f8                       ; 0xc23ad vgabios.c:1523
    xor ah, ah                                ; 30 e4                       ; 0xc23af
    sal ax, 003h                              ; c1 e0 03                    ; 0xc23b1
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc23b4
    xor ah, ah                                ; 30 e4                       ; 0xc23b7 vgabios.c:1524
    jmp near 023d8h                           ; e9 1c 00                    ; 0xc23b9
    mov dl, ah                                ; 88 e2                       ; 0xc23bc vgabios.c:1539
    xor dh, dh                                ; 30 f6                       ; 0xc23be
    add dx, word [bp-00ch]                    ; 03 56 f4                    ; 0xc23c0
    mov si, di                                ; 89 fe                       ; 0xc23c3
    add si, dx                                ; 01 d6                       ; 0xc23c5
    mov al, byte [si]                         ; 8a 04                       ; 0xc23c7
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc23c9 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc23cc
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc23ce
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc23d1 vgabios.c:1543
    cmp ah, 008h                              ; 80 fc 08                    ; 0xc23d3
    jnc short 0242fh                          ; 73 57                       ; 0xc23d6
    mov dl, ah                                ; 88 e2                       ; 0xc23d8
    xor dh, dh                                ; 30 f6                       ; 0xc23da
    sar dx, 1                                 ; d1 fa                       ; 0xc23dc
    imul dx, dx, strict byte 00050h           ; 6b d2 50                    ; 0xc23de
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc23e1
    add bx, dx                                ; 01 d3                       ; 0xc23e4
    test ah, 001h                             ; f6 c4 01                    ; 0xc23e6
    je short 023eeh                           ; 74 03                       ; 0xc23e9
    add bh, 020h                              ; 80 c7 20                    ; 0xc23eb
    mov byte [bp-002h], 080h                  ; c6 46 fe 80                 ; 0xc23ee
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc23f2
    jne short 02414h                          ; 75 1c                       ; 0xc23f6
    test ch, 080h                             ; f6 c5 80                    ; 0xc23f8
    je short 023bch                           ; 74 bf                       ; 0xc23fb
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc23fd
    mov es, dx                                ; 8e c2                       ; 0xc2400
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2402
    mov dl, ah                                ; 88 e2                       ; 0xc2405
    xor dh, dh                                ; 30 f6                       ; 0xc2407
    add dx, word [bp-00ch]                    ; 03 56 f4                    ; 0xc2409
    mov si, di                                ; 89 fe                       ; 0xc240c
    add si, dx                                ; 01 d6                       ; 0xc240e
    xor al, byte [si]                         ; 32 04                       ; 0xc2410
    jmp short 023c9h                          ; eb b5                       ; 0xc2412
    cmp byte [bp-002h], 000h                  ; 80 7e fe 00                 ; 0xc2414 vgabios.c:1545
    jbe short 023d1h                          ; 76 b7                       ; 0xc2418
    test ch, 080h                             ; f6 c5 80                    ; 0xc241a vgabios.c:1547
    je short 02429h                           ; 74 0a                       ; 0xc241d
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc241f vgabios.c:47
    mov es, dx                                ; 8e c2                       ; 0xc2422
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2424
    jmp short 0242bh                          ; eb 02                       ; 0xc2427 vgabios.c:1551
    xor al, al                                ; 30 c0                       ; 0xc2429 vgabios.c:1553
    xor dl, dl                                ; 30 d2                       ; 0xc242b vgabios.c:1555
    jmp short 02436h                          ; eb 07                       ; 0xc242d
    jmp short 02494h                          ; eb 63                       ; 0xc242f
    cmp dl, 004h                              ; 80 fa 04                    ; 0xc2431
    jnc short 02489h                          ; 73 53                       ; 0xc2434
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc2436 vgabios.c:1557
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc2439
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc243d
    add si, word [bp-006h]                    ; 03 76 fa                    ; 0xc2440
    add si, di                                ; 01 fe                       ; 0xc2443
    mov dh, byte [si]                         ; 8a 34                       ; 0xc2445
    mov byte [bp-006h], dh                    ; 88 76 fa                    ; 0xc2447
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc244a
    mov dh, byte [bp-002h]                    ; 8a 76 fe                    ; 0xc244e
    mov byte [bp-00ah], dh                    ; 88 76 f6                    ; 0xc2451
    mov byte [bp-009h], 000h                  ; c6 46 f7 00                 ; 0xc2454
    mov si, word [bp-006h]                    ; 8b 76 fa                    ; 0xc2458
    test word [bp-00ah], si                   ; 85 76 f6                    ; 0xc245b
    je short 02482h                           ; 74 22                       ; 0xc245e
    mov DH, strict byte 003h                  ; b6 03                       ; 0xc2460 vgabios.c:1558
    sub dh, dl                                ; 28 d6                       ; 0xc2462
    mov cl, ch                                ; 88 e9                       ; 0xc2464
    and cl, 003h                              ; 80 e1 03                    ; 0xc2466
    mov byte [bp-004h], cl                    ; 88 4e fc                    ; 0xc2469
    mov cl, dh                                ; 88 f1                       ; 0xc246c
    add cl, dh                                ; 00 f1                       ; 0xc246e
    mov dh, byte [bp-004h]                    ; 8a 76 fc                    ; 0xc2470
    sal dh, CL                                ; d2 e6                       ; 0xc2473
    mov cl, dh                                ; 88 f1                       ; 0xc2475
    test ch, 080h                             ; f6 c5 80                    ; 0xc2477 vgabios.c:1559
    je short 02480h                           ; 74 04                       ; 0xc247a
    xor al, dh                                ; 30 f0                       ; 0xc247c vgabios.c:1561
    jmp short 02482h                          ; eb 02                       ; 0xc247e vgabios.c:1563
    or al, dh                                 ; 08 f0                       ; 0xc2480 vgabios.c:1565
    shr byte [bp-002h], 1                     ; d0 6e fe                    ; 0xc2482 vgabios.c:1568
    db  0feh, 0c2h
    ; inc dl                                    ; fe c2                     ; 0xc2485 vgabios.c:1569
    jmp short 02431h                          ; eb a8                       ; 0xc2487
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc2489 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc248c
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc248e
    inc bx                                    ; 43                          ; 0xc2491 vgabios.c:1571
    jmp short 02414h                          ; eb 80                       ; 0xc2492 vgabios.c:1572
    leave                                     ; c9                          ; 0xc2494 vgabios.c:1575
    pop di                                    ; 5f                          ; 0xc2495
    pop si                                    ; 5e                          ; 0xc2496
    retn 00004h                               ; c2 04 00                    ; 0xc2497
  ; disGetNextSymbol 0xc249a LB 0x2027 -> off=0x0 cb=000000000000009b uValue=00000000000c249a 'write_gfx_char_lin'
write_gfx_char_lin:                          ; 0xc249a LB 0x9b
    push si                                   ; 56                          ; 0xc249a vgabios.c:1578
    push di                                   ; 57                          ; 0xc249b
    enter 00008h, 000h                        ; c8 08 00 00                 ; 0xc249c
    mov bh, al                                ; 88 c7                       ; 0xc24a0
    mov ch, dl                                ; 88 d5                       ; 0xc24a2
    mov al, cl                                ; 88 c8                       ; 0xc24a4
    mov di, 0556ah                            ; bf 6a 55                    ; 0xc24a6 vgabios.c:1585
    xor ah, ah                                ; 30 e4                       ; 0xc24a9 vgabios.c:1586
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc24ab
    xor dh, dh                                ; 30 f6                       ; 0xc24ae
    imul dx                                   ; f7 ea                       ; 0xc24b0
    mov dx, ax                                ; 89 c2                       ; 0xc24b2
    sal dx, 006h                              ; c1 e2 06                    ; 0xc24b4
    mov al, bl                                ; 88 d8                       ; 0xc24b7
    xor ah, ah                                ; 30 e4                       ; 0xc24b9
    sal ax, 003h                              ; c1 e0 03                    ; 0xc24bb
    add ax, dx                                ; 01 d0                       ; 0xc24be
    mov word [bp-002h], ax                    ; 89 46 fe                    ; 0xc24c0
    mov al, bh                                ; 88 f8                       ; 0xc24c3 vgabios.c:1587
    xor ah, ah                                ; 30 e4                       ; 0xc24c5
    sal ax, 003h                              ; c1 e0 03                    ; 0xc24c7
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc24ca
    xor bl, bl                                ; 30 db                       ; 0xc24cd vgabios.c:1588
    jmp short 02513h                          ; eb 42                       ; 0xc24cf
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc24d1 vgabios.c:1592
    jnc short 0250ch                          ; 73 37                       ; 0xc24d3
    xor bh, bh                                ; 30 ff                       ; 0xc24d5 vgabios.c:1594
    mov dl, bl                                ; 88 da                       ; 0xc24d7 vgabios.c:1595
    xor dh, dh                                ; 30 f6                       ; 0xc24d9
    add dx, word [bp-006h]                    ; 03 56 fa                    ; 0xc24db
    mov si, di                                ; 89 fe                       ; 0xc24de
    add si, dx                                ; 01 d6                       ; 0xc24e0
    mov dl, byte [si]                         ; 8a 14                       ; 0xc24e2
    mov byte [bp-004h], dl                    ; 88 56 fc                    ; 0xc24e4
    mov byte [bp-003h], bh                    ; 88 7e fd                    ; 0xc24e7
    mov dl, ah                                ; 88 e2                       ; 0xc24ea
    xor dh, dh                                ; 30 f6                       ; 0xc24ec
    test word [bp-004h], dx                   ; 85 56 fc                    ; 0xc24ee
    je short 024f5h                           ; 74 02                       ; 0xc24f1
    mov bh, ch                                ; 88 ef                       ; 0xc24f3 vgabios.c:1597
    mov dl, al                                ; 88 c2                       ; 0xc24f5 vgabios.c:1599
    xor dh, dh                                ; 30 f6                       ; 0xc24f7
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc24f9
    add si, dx                                ; 01 d6                       ; 0xc24fc
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc24fe vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc2501
    mov byte [es:si], bh                      ; 26 88 3c                    ; 0xc2503
    shr ah, 1                                 ; d0 ec                       ; 0xc2506 vgabios.c:1600
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc2508 vgabios.c:1601
    jmp short 024d1h                          ; eb c5                       ; 0xc250a
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc250c vgabios.c:1602
    cmp bl, 008h                              ; 80 fb 08                    ; 0xc250e
    jnc short 0252fh                          ; 73 1c                       ; 0xc2511
    mov al, bl                                ; 88 d8                       ; 0xc2513
    xor ah, ah                                ; 30 e4                       ; 0xc2515
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc2517
    xor dh, dh                                ; 30 f6                       ; 0xc251a
    imul dx                                   ; f7 ea                       ; 0xc251c
    sal ax, 003h                              ; c1 e0 03                    ; 0xc251e
    mov dx, word [bp-002h]                    ; 8b 56 fe                    ; 0xc2521
    add dx, ax                                ; 01 c2                       ; 0xc2524
    mov word [bp-008h], dx                    ; 89 56 f8                    ; 0xc2526
    mov AH, strict byte 080h                  ; b4 80                       ; 0xc2529
    xor al, al                                ; 30 c0                       ; 0xc252b
    jmp short 024d5h                          ; eb a6                       ; 0xc252d
    leave                                     ; c9                          ; 0xc252f vgabios.c:1603
    pop di                                    ; 5f                          ; 0xc2530
    pop si                                    ; 5e                          ; 0xc2531
    retn 00002h                               ; c2 02 00                    ; 0xc2532
  ; disGetNextSymbol 0xc2535 LB 0x1f8c -> off=0x0 cb=0000000000000176 uValue=00000000000c2535 'biosfn_write_char_attr'
biosfn_write_char_attr:                      ; 0xc2535 LB 0x176
    push bp                                   ; 55                          ; 0xc2535 vgabios.c:1606
    mov bp, sp                                ; 89 e5                       ; 0xc2536
    push si                                   ; 56                          ; 0xc2538
    push di                                   ; 57                          ; 0xc2539
    sub sp, strict byte 0001ch                ; 83 ec 1c                    ; 0xc253a
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc253d
    mov byte [bp-006h], dl                    ; 88 56 fa                    ; 0xc2540
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc2543
    mov si, cx                                ; 89 ce                       ; 0xc2546
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2548 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc254b
    mov es, ax                                ; 8e c0                       ; 0xc254e
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2550
    xor ah, ah                                ; 30 e4                       ; 0xc2553 vgabios.c:1614
    call 0379eh                               ; e8 46 12                    ; 0xc2555
    mov cl, al                                ; 88 c1                       ; 0xc2558
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc255a
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc255d vgabios.c:1615
    jne short 02564h                          ; 75 03                       ; 0xc255f
    jmp near 026a4h                           ; e9 40 01                    ; 0xc2561
    mov al, dl                                ; 88 d0                       ; 0xc2564 vgabios.c:1618
    xor ah, ah                                ; 30 e4                       ; 0xc2566
    lea bx, [bp-01eh]                         ; 8d 5e e2                    ; 0xc2568
    lea dx, [bp-020h]                         ; 8d 56 e0                    ; 0xc256b
    call 00a96h                               ; e8 25 e5                    ; 0xc256e
    mov al, byte [bp-01eh]                    ; 8a 46 e2                    ; 0xc2571 vgabios.c:1619
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc2574
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc2577
    xor al, al                                ; 30 c0                       ; 0xc257a
    shr ax, 008h                              ; c1 e8 08                    ; 0xc257c
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc257f
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc2582
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc2585
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2588 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc258b
    mov es, ax                                ; 8e c0                       ; 0xc258e
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc2590
    mov word [bp-01ch], ax                    ; 89 46 e4                    ; 0xc2593
    mov word [bp-016h], ax                    ; 89 46 ea                    ; 0xc2596 vgabios.c:58
    mov al, cl                                ; 88 c8                       ; 0xc2599 vgabios.c:1625
    xor ah, ah                                ; 30 e4                       ; 0xc259b
    mov di, ax                                ; 89 c7                       ; 0xc259d
    sal di, 003h                              ; c1 e7 03                    ; 0xc259f
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc25a2
    jne short 025edh                          ; 75 44                       ; 0xc25a7
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc25a9 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc25ac
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc25af vgabios.c:58
    mul dx                                    ; f7 e2                       ; 0xc25b2
    mov bx, ax                                ; 89 c3                       ; 0xc25b4
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc25b6 vgabios.c:1629
    xor ah, ah                                ; 30 e4                       ; 0xc25b9
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc25bb
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc25be
    xor dh, dh                                ; 30 f6                       ; 0xc25c1
    add ax, dx                                ; 01 d0                       ; 0xc25c3
    add ax, ax                                ; 01 c0                       ; 0xc25c5
    add bx, ax                                ; 01 c3                       ; 0xc25c7
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc25c9 vgabios.c:1631
    xor ah, ah                                ; 30 e4                       ; 0xc25cc
    mov dx, ax                                ; 89 c2                       ; 0xc25ce
    sal dx, 008h                              ; c1 e2 08                    ; 0xc25d0
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc25d3
    add dx, ax                                ; 01 c2                       ; 0xc25d6
    mov word [bp-020h], dx                    ; 89 56 e0                    ; 0xc25d8
    mov ax, word [bp-020h]                    ; 8b 46 e0                    ; 0xc25db vgabios.c:1632
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc25de
    mov cx, si                                ; 89 f1                       ; 0xc25e2
    mov di, bx                                ; 89 df                       ; 0xc25e4
    jcxz 025eah                               ; e3 02                       ; 0xc25e6
    rep stosw                                 ; f3 ab                       ; 0xc25e8
    jmp near 026a4h                           ; e9 b7 00                    ; 0xc25ea vgabios.c:1634
    mov bx, ax                                ; 89 c3                       ; 0xc25ed vgabios.c:1637
    mov al, byte [bx+0482ch]                  ; 8a 87 2c 48                 ; 0xc25ef
    mov bx, ax                                ; 89 c3                       ; 0xc25f3
    sal bx, 006h                              ; c1 e3 06                    ; 0xc25f5
    mov al, byte [bx+04842h]                  ; 8a 87 42 48                 ; 0xc25f8
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc25fc
    mov al, byte [di+047afh]                  ; 8a 85 af 47                 ; 0xc25ff vgabios.c:1638
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc2603
    dec si                                    ; 4e                          ; 0xc2606 vgabios.c:1639
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2607
    je short 02657h                           ; 74 4b                       ; 0xc260a
    mov bl, byte [bp-010h]                    ; 8a 5e f0                    ; 0xc260c vgabios.c:1641
    xor bh, bh                                ; 30 ff                       ; 0xc260f
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2611
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc2614
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc2618
    jc short 02628h                           ; 72 0c                       ; 0xc261a
    jbe short 0262eh                          ; 76 10                       ; 0xc261c
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc261e
    je short 0267ah                           ; 74 58                       ; 0xc2620
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc2622
    je short 02632h                           ; 74 0c                       ; 0xc2624
    jmp short 0269eh                          ; eb 76                       ; 0xc2626
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc2628
    je short 02659h                           ; 74 2d                       ; 0xc262a
    jmp short 0269eh                          ; eb 70                       ; 0xc262c
    or byte [bp-008h], 001h                   ; 80 4e f8 01                 ; 0xc262e vgabios.c:1644
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2632 vgabios.c:1646
    xor ah, ah                                ; 30 e4                       ; 0xc2635
    push ax                                   ; 50                          ; 0xc2637
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc2638
    push ax                                   ; 50                          ; 0xc263b
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc263c
    push ax                                   ; 50                          ; 0xc263f
    mov cl, byte [bp-00eh]                    ; 8a 4e f2                    ; 0xc2640
    xor ch, ch                                ; 30 ed                       ; 0xc2643
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc2645
    xor bh, bh                                ; 30 ff                       ; 0xc2648
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc264a
    xor dh, dh                                ; 30 f6                       ; 0xc264d
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc264f
    call 02277h                               ; e8 22 fc                    ; 0xc2652
    jmp short 0269eh                          ; eb 47                       ; 0xc2655 vgabios.c:1647
    jmp short 026a4h                          ; eb 4b                       ; 0xc2657
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc2659 vgabios.c:1649
    xor ah, ah                                ; 30 e4                       ; 0xc265c
    push ax                                   ; 50                          ; 0xc265e
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc265f
    push ax                                   ; 50                          ; 0xc2662
    mov cl, byte [bp-00eh]                    ; 8a 4e f2                    ; 0xc2663
    xor ch, ch                                ; 30 ed                       ; 0xc2666
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc2668
    xor bh, bh                                ; 30 ff                       ; 0xc266b
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc266d
    xor dh, dh                                ; 30 f6                       ; 0xc2670
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2672
    call 02388h                               ; e8 10 fd                    ; 0xc2675
    jmp short 0269eh                          ; eb 24                       ; 0xc2678 vgabios.c:1650
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc267a vgabios.c:1652
    xor ah, ah                                ; 30 e4                       ; 0xc267d
    push ax                                   ; 50                          ; 0xc267f
    mov cl, byte [bp-00eh]                    ; 8a 4e f2                    ; 0xc2680
    xor ch, ch                                ; 30 ed                       ; 0xc2683
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc2685
    xor bh, bh                                ; 30 ff                       ; 0xc2688
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc268a
    xor dh, dh                                ; 30 f6                       ; 0xc268d
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc268f
    mov byte [bp-018h], al                    ; 88 46 e8                    ; 0xc2692
    mov byte [bp-017h], ah                    ; 88 66 e9                    ; 0xc2695
    mov ax, word [bp-018h]                    ; 8b 46 e8                    ; 0xc2698
    call 0249ah                               ; e8 fc fd                    ; 0xc269b
    inc byte [bp-00ah]                        ; fe 46 f6                    ; 0xc269e vgabios.c:1659
    jmp near 02606h                           ; e9 62 ff                    ; 0xc26a1 vgabios.c:1660
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc26a4 vgabios.c:1662
    pop di                                    ; 5f                          ; 0xc26a7
    pop si                                    ; 5e                          ; 0xc26a8
    pop bp                                    ; 5d                          ; 0xc26a9
    retn                                      ; c3                          ; 0xc26aa
  ; disGetNextSymbol 0xc26ab LB 0x1e16 -> off=0x0 cb=0000000000000171 uValue=00000000000c26ab 'biosfn_write_char_only'
biosfn_write_char_only:                      ; 0xc26ab LB 0x171
    push bp                                   ; 55                          ; 0xc26ab vgabios.c:1665
    mov bp, sp                                ; 89 e5                       ; 0xc26ac
    push si                                   ; 56                          ; 0xc26ae
    push di                                   ; 57                          ; 0xc26af
    sub sp, strict byte 0001ah                ; 83 ec 1a                    ; 0xc26b0
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc26b3
    mov byte [bp-00eh], dl                    ; 88 56 f2                    ; 0xc26b6
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc26b9
    mov si, cx                                ; 89 ce                       ; 0xc26bc
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc26be vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc26c1
    mov es, ax                                ; 8e c0                       ; 0xc26c4
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc26c6
    xor ah, ah                                ; 30 e4                       ; 0xc26c9 vgabios.c:1673
    call 0379eh                               ; e8 d0 10                    ; 0xc26cb
    mov cl, al                                ; 88 c1                       ; 0xc26ce
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc26d0
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc26d3 vgabios.c:1674
    jne short 026dah                          ; 75 03                       ; 0xc26d5
    jmp near 02815h                           ; e9 3b 01                    ; 0xc26d7
    mov al, dl                                ; 88 d0                       ; 0xc26da vgabios.c:1677
    xor ah, ah                                ; 30 e4                       ; 0xc26dc
    lea bx, [bp-01ch]                         ; 8d 5e e4                    ; 0xc26de
    lea dx, [bp-01eh]                         ; 8d 56 e2                    ; 0xc26e1
    call 00a96h                               ; e8 af e3                    ; 0xc26e4
    mov al, byte [bp-01ch]                    ; 8a 46 e4                    ; 0xc26e7 vgabios.c:1678
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc26ea
    mov ax, word [bp-01ch]                    ; 8b 46 e4                    ; 0xc26ed
    xor al, al                                ; 30 c0                       ; 0xc26f0
    shr ax, 008h                              ; c1 e8 08                    ; 0xc26f2
    mov word [bp-018h], ax                    ; 89 46 e8                    ; 0xc26f5
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc26f8
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc26fb
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc26fe vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2701
    mov es, ax                                ; 8e c0                       ; 0xc2704
    mov di, word [es:bx]                      ; 26 8b 3f                    ; 0xc2706
    mov word [bp-01ah], di                    ; 89 7e e6                    ; 0xc2709 vgabios.c:58
    mov al, cl                                ; 88 c8                       ; 0xc270c vgabios.c:1684
    xor ah, ah                                ; 30 e4                       ; 0xc270e
    mov bx, ax                                ; 89 c3                       ; 0xc2710
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2712
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2715
    jne short 02759h                          ; 75 3d                       ; 0xc271a
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc271c vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc271f
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2722 vgabios.c:58
    mul dx                                    ; f7 e2                       ; 0xc2725
    mov bx, ax                                ; 89 c3                       ; 0xc2727
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc2729 vgabios.c:1688
    xor ah, ah                                ; 30 e4                       ; 0xc272c
    mul di                                    ; f7 e7                       ; 0xc272e
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc2730
    xor dh, dh                                ; 30 f6                       ; 0xc2733
    add ax, dx                                ; 01 d0                       ; 0xc2735
    add ax, ax                                ; 01 c0                       ; 0xc2737
    add bx, ax                                ; 01 c3                       ; 0xc2739
    dec si                                    ; 4e                          ; 0xc273b vgabios.c:1690
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc273c
    je short 026d7h                           ; 74 96                       ; 0xc273f
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc2741 vgabios.c:1691
    xor ah, ah                                ; 30 e4                       ; 0xc2744
    mov di, ax                                ; 89 c7                       ; 0xc2746
    sal di, 003h                              ; c1 e7 03                    ; 0xc2748
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc274b vgabios.c:50
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc274f
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2752
    inc bx                                    ; 43                          ; 0xc2755 vgabios.c:1692
    inc bx                                    ; 43                          ; 0xc2756
    jmp short 0273bh                          ; eb e2                       ; 0xc2757 vgabios.c:1693
    mov di, ax                                ; 89 c7                       ; 0xc2759 vgabios.c:1698
    mov al, byte [di+0482ch]                  ; 8a 85 2c 48                 ; 0xc275b
    mov di, ax                                ; 89 c7                       ; 0xc275f
    sal di, 006h                              ; c1 e7 06                    ; 0xc2761
    mov al, byte [di+04842h]                  ; 8a 85 42 48                 ; 0xc2764
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc2768
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc276b vgabios.c:1699
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc276f
    dec si                                    ; 4e                          ; 0xc2772 vgabios.c:1700
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2773
    je short 027c8h                           ; 74 50                       ; 0xc2776
    mov bl, byte [bp-010h]                    ; 8a 5e f0                    ; 0xc2778 vgabios.c:1702
    xor bh, bh                                ; 30 ff                       ; 0xc277b
    sal bx, 003h                              ; c1 e3 03                    ; 0xc277d
    mov bl, byte [bx+047aeh]                  ; 8a 9f ae 47                 ; 0xc2780
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc2784
    jc short 02798h                           ; 72 0f                       ; 0xc2787
    jbe short 0279fh                          ; 76 14                       ; 0xc2789
    cmp bl, 005h                              ; 80 fb 05                    ; 0xc278b
    je short 027ebh                           ; 74 5b                       ; 0xc278e
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc2790
    je short 027a3h                           ; 74 0e                       ; 0xc2793
    jmp near 0280fh                           ; e9 77 00                    ; 0xc2795
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc2798
    je short 027cah                           ; 74 2d                       ; 0xc279b
    jmp short 0280fh                          ; eb 70                       ; 0xc279d
    or byte [bp-008h], 001h                   ; 80 4e f8 01                 ; 0xc279f vgabios.c:1705
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc27a3 vgabios.c:1707
    xor ah, ah                                ; 30 e4                       ; 0xc27a6
    push ax                                   ; 50                          ; 0xc27a8
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc27a9
    push ax                                   ; 50                          ; 0xc27ac
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc27ad
    push ax                                   ; 50                          ; 0xc27b0
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc27b1
    xor ch, ch                                ; 30 ed                       ; 0xc27b4
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc27b6
    xor bh, bh                                ; 30 ff                       ; 0xc27b9
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc27bb
    xor dh, dh                                ; 30 f6                       ; 0xc27be
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc27c0
    call 02277h                               ; e8 b1 fa                    ; 0xc27c3
    jmp short 0280fh                          ; eb 47                       ; 0xc27c6 vgabios.c:1708
    jmp short 02815h                          ; eb 4b                       ; 0xc27c8
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc27ca vgabios.c:1710
    xor ah, ah                                ; 30 e4                       ; 0xc27cd
    push ax                                   ; 50                          ; 0xc27cf
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc27d0
    push ax                                   ; 50                          ; 0xc27d3
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc27d4
    xor ch, ch                                ; 30 ed                       ; 0xc27d7
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc27d9
    xor bh, bh                                ; 30 ff                       ; 0xc27dc
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc27de
    xor dh, dh                                ; 30 f6                       ; 0xc27e1
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc27e3
    call 02388h                               ; e8 9f fb                    ; 0xc27e6
    jmp short 0280fh                          ; eb 24                       ; 0xc27e9 vgabios.c:1711
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc27eb vgabios.c:1713
    xor ah, ah                                ; 30 e4                       ; 0xc27ee
    push ax                                   ; 50                          ; 0xc27f0
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc27f1
    xor ch, ch                                ; 30 ed                       ; 0xc27f4
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc27f6
    xor bh, bh                                ; 30 ff                       ; 0xc27f9
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc27fb
    xor dh, dh                                ; 30 f6                       ; 0xc27fe
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2800
    mov byte [bp-016h], al                    ; 88 46 ea                    ; 0xc2803
    mov byte [bp-015h], ah                    ; 88 66 eb                    ; 0xc2806
    mov ax, word [bp-016h]                    ; 8b 46 ea                    ; 0xc2809
    call 0249ah                               ; e8 8b fc                    ; 0xc280c
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc280f vgabios.c:1720
    jmp near 02772h                           ; e9 5d ff                    ; 0xc2812 vgabios.c:1721
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2815 vgabios.c:1723
    pop di                                    ; 5f                          ; 0xc2818
    pop si                                    ; 5e                          ; 0xc2819
    pop bp                                    ; 5d                          ; 0xc281a
    retn                                      ; c3                          ; 0xc281b
  ; disGetNextSymbol 0xc281c LB 0x1ca5 -> off=0x0 cb=0000000000000173 uValue=00000000000c281c 'biosfn_write_pixel'
biosfn_write_pixel:                          ; 0xc281c LB 0x173
    push bp                                   ; 55                          ; 0xc281c vgabios.c:1726
    mov bp, sp                                ; 89 e5                       ; 0xc281d
    push si                                   ; 56                          ; 0xc281f
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc2820
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2823
    mov byte [bp-004h], dl                    ; 88 56 fc                    ; 0xc2826
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc2829
    mov dx, cx                                ; 89 ca                       ; 0xc282c
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc282e vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2831
    mov es, ax                                ; 8e c0                       ; 0xc2834
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2836
    xor ah, ah                                ; 30 e4                       ; 0xc2839 vgabios.c:1733
    call 0379eh                               ; e8 60 0f                    ; 0xc283b
    mov cl, al                                ; 88 c1                       ; 0xc283e
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc2840 vgabios.c:1734
    je short 0286ah                           ; 74 26                       ; 0xc2842
    mov bl, al                                ; 88 c3                       ; 0xc2844 vgabios.c:1735
    xor bh, bh                                ; 30 ff                       ; 0xc2846
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2848
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc284b
    je short 0286ah                           ; 74 18                       ; 0xc2850
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc2852 vgabios.c:1737
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc2856
    jc short 02866h                           ; 72 0c                       ; 0xc2858
    jbe short 02870h                          ; 76 14                       ; 0xc285a
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc285c
    je short 0286dh                           ; 74 0d                       ; 0xc285e
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc2860
    je short 02870h                           ; 74 0c                       ; 0xc2862
    jmp short 0286ah                          ; eb 04                       ; 0xc2864
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc2866
    je short 028e1h                           ; 74 77                       ; 0xc2868
    jmp near 02989h                           ; e9 1c 01                    ; 0xc286a
    jmp near 02967h                           ; e9 f7 00                    ; 0xc286d
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2870 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2873
    mov es, ax                                ; 8e c0                       ; 0xc2876
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc2878
    mov ax, dx                                ; 89 d0                       ; 0xc287b vgabios.c:58
    mul bx                                    ; f7 e3                       ; 0xc287d
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc287f
    shr bx, 003h                              ; c1 eb 03                    ; 0xc2882
    add bx, ax                                ; 01 c3                       ; 0xc2885
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2887 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc288a
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc288d vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc2890
    mul dx                                    ; f7 e2                       ; 0xc2892
    add bx, ax                                ; 01 c3                       ; 0xc2894
    mov cx, word [bp-008h]                    ; 8b 4e f8                    ; 0xc2896 vgabios.c:1743
    and cl, 007h                              ; 80 e1 07                    ; 0xc2899
    mov ax, 00080h                            ; b8 80 00                    ; 0xc289c
    sar ax, CL                                ; d3 f8                       ; 0xc289f
    xor ah, ah                                ; 30 e4                       ; 0xc28a1 vgabios.c:1744
    sal ax, 008h                              ; c1 e0 08                    ; 0xc28a3
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc28a6
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc28a8
    out DX, ax                                ; ef                          ; 0xc28ab
    mov ax, 00205h                            ; b8 05 02                    ; 0xc28ac vgabios.c:1745
    out DX, ax                                ; ef                          ; 0xc28af
    mov dx, bx                                ; 89 da                       ; 0xc28b0 vgabios.c:1746
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc28b2
    call 037c6h                               ; e8 0e 0f                    ; 0xc28b5
    test byte [bp-004h], 080h                 ; f6 46 fc 80                 ; 0xc28b8 vgabios.c:1747
    je short 028c5h                           ; 74 07                       ; 0xc28bc
    mov ax, 01803h                            ; b8 03 18                    ; 0xc28be vgabios.c:1749
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc28c1
    out DX, ax                                ; ef                          ; 0xc28c4
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc28c5 vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc28c8
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc28ca
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc28cd
    mov ax, 0ff08h                            ; b8 08 ff                    ; 0xc28d0 vgabios.c:1752
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc28d3
    out DX, ax                                ; ef                          ; 0xc28d6
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc28d7 vgabios.c:1753
    out DX, ax                                ; ef                          ; 0xc28da
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc28db vgabios.c:1754
    out DX, ax                                ; ef                          ; 0xc28de
    jmp short 0286ah                          ; eb 89                       ; 0xc28df vgabios.c:1755
    mov ax, dx                                ; 89 d0                       ; 0xc28e1 vgabios.c:1757
    shr ax, 1                                 ; d1 e8                       ; 0xc28e3
    imul ax, ax, strict byte 00050h           ; 6b c0 50                    ; 0xc28e5
    cmp byte [bx+047afh], 002h                ; 80 bf af 47 02              ; 0xc28e8
    jne short 028f7h                          ; 75 08                       ; 0xc28ed
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc28ef vgabios.c:1759
    shr bx, 002h                              ; c1 eb 02                    ; 0xc28f2
    jmp short 028fdh                          ; eb 06                       ; 0xc28f5 vgabios.c:1761
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc28f7 vgabios.c:1763
    shr bx, 003h                              ; c1 eb 03                    ; 0xc28fa
    add bx, ax                                ; 01 c3                       ; 0xc28fd
    test dl, 001h                             ; f6 c2 01                    ; 0xc28ff vgabios.c:1765
    je short 02907h                           ; 74 03                       ; 0xc2902
    add bh, 020h                              ; 80 c7 20                    ; 0xc2904
    mov ax, 0b800h                            ; b8 00 b8                    ; 0xc2907 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc290a
    mov dl, byte [es:bx]                      ; 26 8a 17                    ; 0xc290c
    mov al, cl                                ; 88 c8                       ; 0xc290f vgabios.c:1767
    xor ah, ah                                ; 30 e4                       ; 0xc2911
    mov si, ax                                ; 89 c6                       ; 0xc2913
    sal si, 003h                              ; c1 e6 03                    ; 0xc2915
    cmp byte [si+047afh], 002h                ; 80 bc af 47 02              ; 0xc2918
    jne short 02938h                          ; 75 19                       ; 0xc291d
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc291f vgabios.c:1769
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2922
    mov AH, strict byte 003h                  ; b4 03                       ; 0xc2924
    sub ah, al                                ; 28 c4                       ; 0xc2926
    mov cl, ah                                ; 88 e1                       ; 0xc2928
    add cl, ah                                ; 00 e1                       ; 0xc292a
    mov dh, byte [bp-004h]                    ; 8a 76 fc                    ; 0xc292c
    and dh, 003h                              ; 80 e6 03                    ; 0xc292f
    sal dh, CL                                ; d2 e6                       ; 0xc2932
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc2934 vgabios.c:1770
    jmp short 0294bh                          ; eb 13                       ; 0xc2936 vgabios.c:1772
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2938 vgabios.c:1774
    and AL, strict byte 007h                  ; 24 07                       ; 0xc293b
    mov CL, strict byte 007h                  ; b1 07                       ; 0xc293d
    sub cl, al                                ; 28 c1                       ; 0xc293f
    mov dh, byte [bp-004h]                    ; 8a 76 fc                    ; 0xc2941
    and dh, 001h                              ; 80 e6 01                    ; 0xc2944
    sal dh, CL                                ; d2 e6                       ; 0xc2947
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc2949 vgabios.c:1775
    sal al, CL                                ; d2 e0                       ; 0xc294b
    test byte [bp-004h], 080h                 ; f6 46 fc 80                 ; 0xc294d vgabios.c:1777
    je short 02957h                           ; 74 04                       ; 0xc2951
    xor dl, dh                                ; 30 f2                       ; 0xc2953 vgabios.c:1779
    jmp short 0295dh                          ; eb 06                       ; 0xc2955 vgabios.c:1781
    not al                                    ; f6 d0                       ; 0xc2957 vgabios.c:1783
    and dl, al                                ; 20 c2                       ; 0xc2959
    or dl, dh                                 ; 08 f2                       ; 0xc295b vgabios.c:1784
    mov ax, 0b800h                            ; b8 00 b8                    ; 0xc295d vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc2960
    mov byte [es:bx], dl                      ; 26 88 17                    ; 0xc2962
    jmp short 02989h                          ; eb 22                       ; 0xc2965 vgabios.c:1787
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2967 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc296a
    mov es, ax                                ; 8e c0                       ; 0xc296d
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc296f
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2972 vgabios.c:58
    mov ax, dx                                ; 89 d0                       ; 0xc2975
    mul bx                                    ; f7 e3                       ; 0xc2977
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc2979
    add bx, ax                                ; 01 c3                       ; 0xc297c
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc297e vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc2981
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc2983
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2986
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2989 vgabios.c:1797
    pop si                                    ; 5e                          ; 0xc298c
    pop bp                                    ; 5d                          ; 0xc298d
    retn                                      ; c3                          ; 0xc298e
  ; disGetNextSymbol 0xc298f LB 0x1b32 -> off=0x0 cb=0000000000000254 uValue=00000000000c298f 'biosfn_write_teletype'
biosfn_write_teletype:                       ; 0xc298f LB 0x254
    push bp                                   ; 55                          ; 0xc298f vgabios.c:1800
    mov bp, sp                                ; 89 e5                       ; 0xc2990
    push si                                   ; 56                          ; 0xc2992
    sub sp, strict byte 00014h                ; 83 ec 14                    ; 0xc2993
    mov ch, al                                ; 88 c5                       ; 0xc2996
    mov byte [bp-008h], dl                    ; 88 56 f8                    ; 0xc2998
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc299b
    cmp dl, 0ffh                              ; 80 fa ff                    ; 0xc299e vgabios.c:1808
    jne short 029b1h                          ; 75 0e                       ; 0xc29a1
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc29a3 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc29a6
    mov es, ax                                ; 8e c0                       ; 0xc29a9
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc29ab
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc29ae vgabios.c:48
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc29b1 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc29b4
    mov es, ax                                ; 8e c0                       ; 0xc29b7
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc29b9
    xor ah, ah                                ; 30 e4                       ; 0xc29bc vgabios.c:1813
    call 0379eh                               ; e8 dd 0d                    ; 0xc29be
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc29c1
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc29c4 vgabios.c:1814
    je short 02a2eh                           ; 74 66                       ; 0xc29c6
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc29c8 vgabios.c:1817
    xor ah, ah                                ; 30 e4                       ; 0xc29cb
    lea bx, [bp-014h]                         ; 8d 5e ec                    ; 0xc29cd
    lea dx, [bp-016h]                         ; 8d 56 ea                    ; 0xc29d0
    call 00a96h                               ; e8 c0 e0                    ; 0xc29d3
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc29d6 vgabios.c:1818
    mov byte [bp-004h], al                    ; 88 46 fc                    ; 0xc29d9
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc29dc
    xor al, al                                ; 30 c0                       ; 0xc29df
    shr ax, 008h                              ; c1 e8 08                    ; 0xc29e1
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc29e4
    mov bx, 00084h                            ; bb 84 00                    ; 0xc29e7 vgabios.c:47
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc29ea
    mov es, dx                                ; 8e c2                       ; 0xc29ed
    mov dl, byte [es:bx]                      ; 26 8a 17                    ; 0xc29ef
    xor dh, dh                                ; 30 f6                       ; 0xc29f2 vgabios.c:48
    inc dx                                    ; 42                          ; 0xc29f4
    mov word [bp-010h], dx                    ; 89 56 f0                    ; 0xc29f5
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc29f8 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc29fb
    mov word [bp-012h], dx                    ; 89 56 ee                    ; 0xc29fe vgabios.c:58
    cmp ch, 008h                              ; 80 fd 08                    ; 0xc2a01 vgabios.c:1824
    jc short 02a14h                           ; 72 0e                       ; 0xc2a04
    jbe short 02a1ch                          ; 76 14                       ; 0xc2a06
    cmp ch, 00dh                              ; 80 fd 0d                    ; 0xc2a08
    je short 02a31h                           ; 74 24                       ; 0xc2a0b
    cmp ch, 00ah                              ; 80 fd 0a                    ; 0xc2a0d
    je short 02a27h                           ; 74 15                       ; 0xc2a10
    jmp short 02a38h                          ; eb 24                       ; 0xc2a12
    cmp ch, 007h                              ; 80 fd 07                    ; 0xc2a14
    jne short 02a38h                          ; 75 1f                       ; 0xc2a17
    jmp near 02b40h                           ; e9 24 01                    ; 0xc2a19
    cmp byte [bp-004h], 000h                  ; 80 7e fc 00                 ; 0xc2a1c vgabios.c:1831
    jbe short 02a35h                          ; 76 13                       ; 0xc2a20
    dec byte [bp-004h]                        ; fe 4e fc                    ; 0xc2a22
    jmp short 02a35h                          ; eb 0e                       ; 0xc2a25 vgabios.c:1832
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc2a27 vgabios.c:1835
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2a29
    jmp short 02a35h                          ; eb 07                       ; 0xc2a2c vgabios.c:1836
    jmp near 02bddh                           ; e9 ac 01                    ; 0xc2a2e
    mov byte [bp-004h], 000h                  ; c6 46 fc 00                 ; 0xc2a31 vgabios.c:1839
    jmp near 02b40h                           ; e9 08 01                    ; 0xc2a35 vgabios.c:1840
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2a38 vgabios.c:1844
    xor ah, ah                                ; 30 e4                       ; 0xc2a3b
    mov bx, ax                                ; 89 c3                       ; 0xc2a3d
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2a3f
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2a42
    jne short 02a8bh                          ; 75 42                       ; 0xc2a47
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2a49 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2a4c
    mov es, ax                                ; 8e c0                       ; 0xc2a4f
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc2a51
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2a54 vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc2a57
    mul dx                                    ; f7 e2                       ; 0xc2a59
    mov si, ax                                ; 89 c6                       ; 0xc2a5b
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2a5d vgabios.c:1848
    xor ah, ah                                ; 30 e4                       ; 0xc2a60
    mul word [bp-012h]                        ; f7 66 ee                    ; 0xc2a62
    mov dx, ax                                ; 89 c2                       ; 0xc2a65
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc2a67
    xor ah, ah                                ; 30 e4                       ; 0xc2a6a
    add ax, dx                                ; 01 d0                       ; 0xc2a6c
    add ax, ax                                ; 01 c0                       ; 0xc2a6e
    add si, ax                                ; 01 c6                       ; 0xc2a70
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2a72 vgabios.c:50
    mov byte [es:si], ch                      ; 26 88 2c                    ; 0xc2a76 vgabios.c:52
    cmp cl, 003h                              ; 80 f9 03                    ; 0xc2a79 vgabios.c:1853
    jne short 02abah                          ; 75 3c                       ; 0xc2a7c
    inc si                                    ; 46                          ; 0xc2a7e vgabios.c:1854
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2a7f vgabios.c:50
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2a83
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2a86
    jmp short 02abah                          ; eb 2f                       ; 0xc2a89 vgabios.c:1856
    mov si, ax                                ; 89 c6                       ; 0xc2a8b vgabios.c:1859
    mov al, byte [si+0482ch]                  ; 8a 84 2c 48                 ; 0xc2a8d
    mov si, ax                                ; 89 c6                       ; 0xc2a91
    sal si, 006h                              ; c1 e6 06                    ; 0xc2a93
    mov dl, byte [si+04842h]                  ; 8a 94 42 48                 ; 0xc2a96
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc2a9a vgabios.c:1860
    mov bl, byte [bx+047aeh]                  ; 8a 9f ae 47                 ; 0xc2a9e vgabios.c:1861
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc2aa2
    jc short 02ab5h                           ; 72 0e                       ; 0xc2aa5
    jbe short 02abch                          ; 76 13                       ; 0xc2aa7
    cmp bl, 005h                              ; 80 fb 05                    ; 0xc2aa9
    je short 02b0eh                           ; 74 60                       ; 0xc2aac
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc2aae
    je short 02ac0h                           ; 74 0d                       ; 0xc2ab1
    jmp short 02abah                          ; eb 05                       ; 0xc2ab3
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc2ab5
    je short 02aech                           ; 74 32                       ; 0xc2ab8
    jmp short 02b2dh                          ; eb 71                       ; 0xc2aba
    or byte [bp-00ah], 001h                   ; 80 4e f6 01                 ; 0xc2abc vgabios.c:1864
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2ac0 vgabios.c:1866
    xor ah, ah                                ; 30 e4                       ; 0xc2ac3
    push ax                                   ; 50                          ; 0xc2ac5
    mov al, dl                                ; 88 d0                       ; 0xc2ac6
    push ax                                   ; 50                          ; 0xc2ac8
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc2ac9
    push ax                                   ; 50                          ; 0xc2acc
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc2acd
    xor dh, dh                                ; 30 f6                       ; 0xc2ad0
    mov bl, byte [bp-004h]                    ; 8a 5e fc                    ; 0xc2ad2
    xor bh, bh                                ; 30 ff                       ; 0xc2ad5
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2ad7
    mov byte [bp-00eh], ch                    ; 88 6e f2                    ; 0xc2ada
    mov byte [bp-00dh], ah                    ; 88 66 f3                    ; 0xc2add
    mov cx, dx                                ; 89 d1                       ; 0xc2ae0
    mov dx, ax                                ; 89 c2                       ; 0xc2ae2
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2ae4
    call 02277h                               ; e8 8d f7                    ; 0xc2ae7
    jmp short 02b2dh                          ; eb 41                       ; 0xc2aea vgabios.c:1867
    push ax                                   ; 50                          ; 0xc2aec vgabios.c:1869
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc2aed
    push ax                                   ; 50                          ; 0xc2af0
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2af1
    mov bl, byte [bp-004h]                    ; 8a 5e fc                    ; 0xc2af4
    xor bh, bh                                ; 30 ff                       ; 0xc2af7
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc2af9
    xor dh, dh                                ; 30 f6                       ; 0xc2afc
    mov byte [bp-00eh], ch                    ; 88 6e f2                    ; 0xc2afe
    mov byte [bp-00dh], ah                    ; 88 66 f3                    ; 0xc2b01
    mov cx, ax                                ; 89 c1                       ; 0xc2b04
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2b06
    call 02388h                               ; e8 7c f8                    ; 0xc2b09
    jmp short 02b2dh                          ; eb 1f                       ; 0xc2b0c vgabios.c:1870
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc2b0e vgabios.c:1872
    push ax                                   ; 50                          ; 0xc2b11
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2b12
    mov bl, byte [bp-004h]                    ; 8a 5e fc                    ; 0xc2b15
    xor bh, bh                                ; 30 ff                       ; 0xc2b18
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc2b1a
    xor dh, dh                                ; 30 f6                       ; 0xc2b1d
    mov byte [bp-00eh], ch                    ; 88 6e f2                    ; 0xc2b1f
    mov byte [bp-00dh], ah                    ; 88 66 f3                    ; 0xc2b22
    mov cx, ax                                ; 89 c1                       ; 0xc2b25
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2b27
    call 0249ah                               ; e8 6d f9                    ; 0xc2b2a
    inc byte [bp-004h]                        ; fe 46 fc                    ; 0xc2b2d vgabios.c:1880
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc2b30 vgabios.c:1882
    xor ah, ah                                ; 30 e4                       ; 0xc2b33
    cmp ax, word [bp-012h]                    ; 3b 46 ee                    ; 0xc2b35
    jne short 02b40h                          ; 75 06                       ; 0xc2b38
    mov byte [bp-004h], ah                    ; 88 66 fc                    ; 0xc2b3a vgabios.c:1883
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc2b3d vgabios.c:1884
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2b40 vgabios.c:1889
    xor ah, ah                                ; 30 e4                       ; 0xc2b43
    cmp ax, word [bp-010h]                    ; 3b 46 f0                    ; 0xc2b45
    jne short 02bc2h                          ; 75 78                       ; 0xc2b48
    mov bl, byte [bp-00ch]                    ; 8a 5e f4                    ; 0xc2b4a vgabios.c:1891
    xor bh, bh                                ; 30 ff                       ; 0xc2b4d
    sal bx, 003h                              ; c1 e3 03                    ; 0xc2b4f
    mov cl, byte [bp-010h]                    ; 8a 4e f0                    ; 0xc2b52
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc2b55
    mov ch, byte [bp-012h]                    ; 8a 6e ee                    ; 0xc2b57
    db  0feh, 0cdh
    ; dec ch                                    ; fe cd                     ; 0xc2b5a
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2b5c
    jne short 02ba7h                          ; 75 44                       ; 0xc2b61
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2b63 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2b66
    mov es, ax                                ; 8e c0                       ; 0xc2b69
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc2b6b
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2b6e vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc2b71
    mul dx                                    ; f7 e2                       ; 0xc2b73
    mov si, ax                                ; 89 c6                       ; 0xc2b75
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2b77 vgabios.c:1894
    xor ah, ah                                ; 30 e4                       ; 0xc2b7a
    dec ax                                    ; 48                          ; 0xc2b7c
    mul word [bp-012h]                        ; f7 66 ee                    ; 0xc2b7d
    mov dl, byte [bp-004h]                    ; 8a 56 fc                    ; 0xc2b80
    xor dh, dh                                ; 30 f6                       ; 0xc2b83
    add ax, dx                                ; 01 d0                       ; 0xc2b85
    add ax, ax                                ; 01 c0                       ; 0xc2b87
    add si, ax                                ; 01 c6                       ; 0xc2b89
    inc si                                    ; 46                          ; 0xc2b8b vgabios.c:1895
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2b8c vgabios.c:45
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc2b90
    push strict byte 00001h                   ; 6a 01                       ; 0xc2b93 vgabios.c:1896
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2b95
    xor ah, ah                                ; 30 e4                       ; 0xc2b98
    push ax                                   ; 50                          ; 0xc2b9a
    mov al, ch                                ; 88 e8                       ; 0xc2b9b
    push ax                                   ; 50                          ; 0xc2b9d
    mov al, cl                                ; 88 c8                       ; 0xc2b9e
    push ax                                   ; 50                          ; 0xc2ba0
    xor cx, cx                                ; 31 c9                       ; 0xc2ba1
    xor bx, bx                                ; 31 db                       ; 0xc2ba3
    jmp short 02bb9h                          ; eb 12                       ; 0xc2ba5 vgabios.c:1898
    push strict byte 00001h                   ; 6a 01                       ; 0xc2ba7 vgabios.c:1900
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2ba9
    push ax                                   ; 50                          ; 0xc2bac
    mov al, ch                                ; 88 e8                       ; 0xc2bad
    push ax                                   ; 50                          ; 0xc2baf
    mov al, cl                                ; 88 c8                       ; 0xc2bb0
    push ax                                   ; 50                          ; 0xc2bb2
    xor cx, cx                                ; 31 c9                       ; 0xc2bb3
    xor bx, bx                                ; 31 db                       ; 0xc2bb5
    xor dx, dx                                ; 31 d2                       ; 0xc2bb7
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc2bb9
    call 01bf1h                               ; e8 32 f0                    ; 0xc2bbc
    dec byte [bp-006h]                        ; fe 4e fa                    ; 0xc2bbf vgabios.c:1902
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2bc2 vgabios.c:1906
    xor ah, ah                                ; 30 e4                       ; 0xc2bc5
    mov word [bp-014h], ax                    ; 89 46 ec                    ; 0xc2bc7
    sal word [bp-014h], 008h                  ; c1 66 ec 08                 ; 0xc2bca
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc2bce
    add word [bp-014h], ax                    ; 01 46 ec                    ; 0xc2bd1
    mov dx, word [bp-014h]                    ; 8b 56 ec                    ; 0xc2bd4 vgabios.c:1907
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2bd7
    call 01278h                               ; e8 9b e6                    ; 0xc2bda
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2bdd vgabios.c:1908
    pop si                                    ; 5e                          ; 0xc2be0
    pop bp                                    ; 5d                          ; 0xc2be1
    retn                                      ; c3                          ; 0xc2be2
  ; disGetNextSymbol 0xc2be3 LB 0x18de -> off=0x0 cb=0000000000000033 uValue=00000000000c2be3 'get_font_access'
get_font_access:                             ; 0xc2be3 LB 0x33
    push bp                                   ; 55                          ; 0xc2be3 vgabios.c:1911
    mov bp, sp                                ; 89 e5                       ; 0xc2be4
    push dx                                   ; 52                          ; 0xc2be6
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc2be7 vgabios.c:1913
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2bea
    out DX, ax                                ; ef                          ; 0xc2bed
    mov AL, strict byte 006h                  ; b0 06                       ; 0xc2bee vgabios.c:1914
    out DX, AL                                ; ee                          ; 0xc2bf0
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc2bf1 vgabios.c:1915
    in AL, DX                                 ; ec                          ; 0xc2bf4
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2bf5
    and ax, strict word 00001h                ; 25 01 00                    ; 0xc2bf7
    or AL, strict byte 004h                   ; 0c 04                       ; 0xc2bfa
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2bfc
    or AL, strict byte 006h                   ; 0c 06                       ; 0xc2bff
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2c01
    out DX, ax                                ; ef                          ; 0xc2c04
    mov ax, 00402h                            ; b8 02 04                    ; 0xc2c05 vgabios.c:1916
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2c08
    out DX, ax                                ; ef                          ; 0xc2c0b
    mov ax, 00604h                            ; b8 04 06                    ; 0xc2c0c vgabios.c:1917
    out DX, ax                                ; ef                          ; 0xc2c0f
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2c10 vgabios.c:1918
    pop dx                                    ; 5a                          ; 0xc2c13
    pop bp                                    ; 5d                          ; 0xc2c14
    retn                                      ; c3                          ; 0xc2c15
  ; disGetNextSymbol 0xc2c16 LB 0x18ab -> off=0x0 cb=0000000000000030 uValue=00000000000c2c16 'release_font_access'
release_font_access:                         ; 0xc2c16 LB 0x30
    push bp                                   ; 55                          ; 0xc2c16 vgabios.c:1920
    mov bp, sp                                ; 89 e5                       ; 0xc2c17
    push dx                                   ; 52                          ; 0xc2c19
    mov dx, 003cch                            ; ba cc 03                    ; 0xc2c1a vgabios.c:1922
    in AL, DX                                 ; ec                          ; 0xc2c1d
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2c1e
    and ax, strict word 00001h                ; 25 01 00                    ; 0xc2c20
    sal ax, 002h                              ; c1 e0 02                    ; 0xc2c23
    or AL, strict byte 00ah                   ; 0c 0a                       ; 0xc2c26
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2c28
    or AL, strict byte 006h                   ; 0c 06                       ; 0xc2c2b
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2c2d
    out DX, ax                                ; ef                          ; 0xc2c30
    mov ax, 01005h                            ; b8 05 10                    ; 0xc2c31 vgabios.c:1923
    out DX, ax                                ; ef                          ; 0xc2c34
    mov ax, 00302h                            ; b8 02 03                    ; 0xc2c35 vgabios.c:1924
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2c38
    out DX, ax                                ; ef                          ; 0xc2c3b
    mov ax, 00204h                            ; b8 04 02                    ; 0xc2c3c vgabios.c:1925
    out DX, ax                                ; ef                          ; 0xc2c3f
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2c40 vgabios.c:1926
    pop dx                                    ; 5a                          ; 0xc2c43
    pop bp                                    ; 5d                          ; 0xc2c44
    retn                                      ; c3                          ; 0xc2c45
  ; disGetNextSymbol 0xc2c46 LB 0x187b -> off=0x0 cb=00000000000000c1 uValue=00000000000c2c46 'set_scan_lines'
set_scan_lines:                              ; 0xc2c46 LB 0xc1
    push bp                                   ; 55                          ; 0xc2c46 vgabios.c:1928
    mov bp, sp                                ; 89 e5                       ; 0xc2c47
    push bx                                   ; 53                          ; 0xc2c49
    push cx                                   ; 51                          ; 0xc2c4a
    push dx                                   ; 52                          ; 0xc2c4b
    push si                                   ; 56                          ; 0xc2c4c
    push di                                   ; 57                          ; 0xc2c4d
    mov cl, al                                ; 88 c1                       ; 0xc2c4e
    mov si, strict word 00063h                ; be 63 00                    ; 0xc2c50 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2c53
    mov es, ax                                ; 8e c0                       ; 0xc2c56
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc2c58
    mov bx, si                                ; 89 f3                       ; 0xc2c5b vgabios.c:58
    mov AL, strict byte 009h                  ; b0 09                       ; 0xc2c5d vgabios.c:1934
    mov dx, si                                ; 89 f2                       ; 0xc2c5f
    out DX, AL                                ; ee                          ; 0xc2c61
    lea dx, [si+001h]                         ; 8d 54 01                    ; 0xc2c62 vgabios.c:1935
    in AL, DX                                 ; ec                          ; 0xc2c65
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2c66
    and AL, strict byte 0e0h                  ; 24 e0                       ; 0xc2c68 vgabios.c:1936
    mov ah, cl                                ; 88 cc                       ; 0xc2c6a
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc2c6c
    or al, ah                                 ; 08 e0                       ; 0xc2c6e
    out DX, AL                                ; ee                          ; 0xc2c70 vgabios.c:1937
    mov al, cl                                ; 88 c8                       ; 0xc2c71 vgabios.c:1942
    xor ah, ah                                ; 30 e4                       ; 0xc2c73
    mov si, ax                                ; 89 c6                       ; 0xc2c75
    sal si, 008h                              ; c1 e6 08                    ; 0xc2c77
    dec ax                                    ; 48                          ; 0xc2c7a
    sub si, 00200h                            ; 81 ee 00 02                 ; 0xc2c7b
    or si, ax                                 ; 09 c6                       ; 0xc2c7f
    cmp cl, 00eh                              ; 80 f9 0e                    ; 0xc2c81 vgabios.c:1943
    jc short 02c8ah                           ; 72 04                       ; 0xc2c84
    sub si, 00101h                            ; 81 ee 01 01                 ; 0xc2c86 vgabios.c:1944
    mov ax, si                                ; 89 f0                       ; 0xc2c8a vgabios.c:1946
    xor al, al                                ; 30 c0                       ; 0xc2c8c
    or AL, strict byte 00ah                   ; 0c 0a                       ; 0xc2c8e
    mov dx, bx                                ; 89 da                       ; 0xc2c90
    out DX, ax                                ; ef                          ; 0xc2c92
    mov ax, si                                ; 89 f0                       ; 0xc2c93 vgabios.c:1947
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2c95
    or AL, strict byte 00bh                   ; 0c 0b                       ; 0xc2c98
    out DX, ax                                ; ef                          ; 0xc2c9a
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc2c9b vgabios.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2c9e
    mov es, ax                                ; 8e c0                       ; 0xc2ca1
    mov word [es:di], si                      ; 26 89 35                    ; 0xc2ca3
    xor ch, ch                                ; 30 ed                       ; 0xc2ca6 vgabios.c:1950
    mov si, 00085h                            ; be 85 00                    ; 0xc2ca8 vgabios.c:62
    mov word [es:si], cx                      ; 26 89 0c                    ; 0xc2cab
    mov AL, strict byte 012h                  ; b0 12                       ; 0xc2cae vgabios.c:1951
    out DX, AL                                ; ee                          ; 0xc2cb0
    lea si, [bx+001h]                         ; 8d 77 01                    ; 0xc2cb1 vgabios.c:1952
    mov dx, si                                ; 89 f2                       ; 0xc2cb4
    in AL, DX                                 ; ec                          ; 0xc2cb6
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2cb7
    mov di, ax                                ; 89 c7                       ; 0xc2cb9
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc2cbb vgabios.c:1953
    mov dx, bx                                ; 89 da                       ; 0xc2cbd
    out DX, AL                                ; ee                          ; 0xc2cbf
    mov dx, si                                ; 89 f2                       ; 0xc2cc0 vgabios.c:1954
    in AL, DX                                 ; ec                          ; 0xc2cc2
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2cc3
    mov bl, al                                ; 88 c3                       ; 0xc2cc5 vgabios.c:1955
    and bl, 002h                              ; 80 e3 02                    ; 0xc2cc7
    xor bh, bh                                ; 30 ff                       ; 0xc2cca
    sal bx, 007h                              ; c1 e3 07                    ; 0xc2ccc
    and AL, strict byte 040h                  ; 24 40                       ; 0xc2ccf
    xor ah, ah                                ; 30 e4                       ; 0xc2cd1
    sal ax, 003h                              ; c1 e0 03                    ; 0xc2cd3
    add ax, bx                                ; 01 d8                       ; 0xc2cd6
    inc ax                                    ; 40                          ; 0xc2cd8
    add ax, di                                ; 01 f8                       ; 0xc2cd9
    xor dx, si                                ; 31 f2                       ; 0xc2cdb vgabios.c:1956
    div cx                                    ; f7 f1                       ; 0xc2cdd
    mov cl, al                                ; 88 c1                       ; 0xc2cdf vgabios.c:1957
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc2ce1
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2ce3 vgabios.c:52
    mov byte [es:bx], cl                      ; 26 88 0f                    ; 0xc2ce6
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2ce9 vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc2cec
    xor ah, ah                                ; 30 e4                       ; 0xc2cef vgabios.c:1963
    mul bx                                    ; f7 e3                       ; 0xc2cf1
    add ax, ax                                ; 01 c0                       ; 0xc2cf3
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc2cf5
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc2cf7 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc2cfa
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc2cfd vgabios.c:1964
    pop di                                    ; 5f                          ; 0xc2d00
    pop si                                    ; 5e                          ; 0xc2d01
    pop dx                                    ; 5a                          ; 0xc2d02
    pop cx                                    ; 59                          ; 0xc2d03
    pop bx                                    ; 5b                          ; 0xc2d04
    pop bp                                    ; 5d                          ; 0xc2d05
    retn                                      ; c3                          ; 0xc2d06
  ; disGetNextSymbol 0xc2d07 LB 0x17ba -> off=0x0 cb=0000000000000023 uValue=00000000000c2d07 'biosfn_set_font_block'
biosfn_set_font_block:                       ; 0xc2d07 LB 0x23
    push bp                                   ; 55                          ; 0xc2d07 vgabios.c:1966
    mov bp, sp                                ; 89 e5                       ; 0xc2d08
    push bx                                   ; 53                          ; 0xc2d0a
    push dx                                   ; 52                          ; 0xc2d0b
    mov bl, al                                ; 88 c3                       ; 0xc2d0c
    mov ax, 00100h                            ; b8 00 01                    ; 0xc2d0e vgabios.c:1968
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2d11
    out DX, ax                                ; ef                          ; 0xc2d14
    mov al, bl                                ; 88 d8                       ; 0xc2d15 vgabios.c:1969
    xor ah, ah                                ; 30 e4                       ; 0xc2d17
    sal ax, 008h                              ; c1 e0 08                    ; 0xc2d19
    or AL, strict byte 003h                   ; 0c 03                       ; 0xc2d1c
    out DX, ax                                ; ef                          ; 0xc2d1e
    mov ax, 00300h                            ; b8 00 03                    ; 0xc2d1f vgabios.c:1970
    out DX, ax                                ; ef                          ; 0xc2d22
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2d23 vgabios.c:1971
    pop dx                                    ; 5a                          ; 0xc2d26
    pop bx                                    ; 5b                          ; 0xc2d27
    pop bp                                    ; 5d                          ; 0xc2d28
    retn                                      ; c3                          ; 0xc2d29
  ; disGetNextSymbol 0xc2d2a LB 0x1797 -> off=0x0 cb=0000000000000075 uValue=00000000000c2d2a 'load_text_patch'
load_text_patch:                             ; 0xc2d2a LB 0x75
    push bp                                   ; 55                          ; 0xc2d2a vgabios.c:1973
    mov bp, sp                                ; 89 e5                       ; 0xc2d2b
    push si                                   ; 56                          ; 0xc2d2d
    push di                                   ; 57                          ; 0xc2d2e
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc2d2f
    push ax                                   ; 50                          ; 0xc2d32
    mov byte [bp-006h], cl                    ; 88 4e fa                    ; 0xc2d33
    call 02be3h                               ; e8 aa fe                    ; 0xc2d36 vgabios.c:1978
    mov al, bl                                ; 88 d8                       ; 0xc2d39 vgabios.c:1980
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2d3b
    xor ah, ah                                ; 30 e4                       ; 0xc2d3d
    mov cx, ax                                ; 89 c1                       ; 0xc2d3f
    sal cx, 00eh                              ; c1 e1 0e                    ; 0xc2d41
    mov al, bl                                ; 88 d8                       ; 0xc2d44
    and AL, strict byte 004h                  ; 24 04                       ; 0xc2d46
    sal ax, 00bh                              ; c1 e0 0b                    ; 0xc2d48
    add cx, ax                                ; 01 c1                       ; 0xc2d4b
    mov word [bp-00ah], cx                    ; 89 4e f6                    ; 0xc2d4d
    mov bx, dx                                ; 89 d3                       ; 0xc2d50 vgabios.c:1981
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2d52
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc2d55
    inc dx                                    ; 42                          ; 0xc2d58 vgabios.c:1982
    mov word [bp-00ch], dx                    ; 89 56 f4                    ; 0xc2d59
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc2d5c vgabios.c:1983
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2d5f
    test al, al                               ; 84 c0                       ; 0xc2d62
    je short 02d95h                           ; 74 2f                       ; 0xc2d64
    xor ah, ah                                ; 30 e4                       ; 0xc2d66 vgabios.c:1984
    sal ax, 005h                              ; c1 e0 05                    ; 0xc2d68
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc2d6b
    add di, ax                                ; 01 c7                       ; 0xc2d6e
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc2d70 vgabios.c:1985
    xor ch, ch                                ; 30 ed                       ; 0xc2d73
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc2d75
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc2d78
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2d7b
    mov es, ax                                ; 8e c0                       ; 0xc2d7e
    jcxz 02d88h                               ; e3 06                       ; 0xc2d80
    push DS                                   ; 1e                          ; 0xc2d82
    mov ds, dx                                ; 8e da                       ; 0xc2d83
    rep movsb                                 ; f3 a4                       ; 0xc2d85
    pop DS                                    ; 1f                          ; 0xc2d87
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2d88 vgabios.c:1986
    xor ah, ah                                ; 30 e4                       ; 0xc2d8b
    inc ax                                    ; 40                          ; 0xc2d8d
    add word [bp-00ch], ax                    ; 01 46 f4                    ; 0xc2d8e
    add bx, ax                                ; 01 c3                       ; 0xc2d91 vgabios.c:1987
    jmp short 02d5ch                          ; eb c7                       ; 0xc2d93 vgabios.c:1988
    call 02c16h                               ; e8 7e fe                    ; 0xc2d95 vgabios.c:1990
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2d98 vgabios.c:1991
    pop di                                    ; 5f                          ; 0xc2d9b
    pop si                                    ; 5e                          ; 0xc2d9c
    pop bp                                    ; 5d                          ; 0xc2d9d
    retn                                      ; c3                          ; 0xc2d9e
  ; disGetNextSymbol 0xc2d9f LB 0x1722 -> off=0x0 cb=000000000000007f uValue=00000000000c2d9f 'biosfn_load_text_user_pat'
biosfn_load_text_user_pat:                   ; 0xc2d9f LB 0x7f
    push bp                                   ; 55                          ; 0xc2d9f vgabios.c:1993
    mov bp, sp                                ; 89 e5                       ; 0xc2da0
    push si                                   ; 56                          ; 0xc2da2
    push di                                   ; 57                          ; 0xc2da3
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc2da4
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2da7
    mov word [bp-00ch], dx                    ; 89 56 f4                    ; 0xc2daa
    mov word [bp-00ah], bx                    ; 89 5e f6                    ; 0xc2dad
    mov word [bp-00eh], cx                    ; 89 4e f2                    ; 0xc2db0
    call 02be3h                               ; e8 2d fe                    ; 0xc2db3 vgabios.c:1998
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2db6 vgabios.c:1999
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2db9
    xor ah, ah                                ; 30 e4                       ; 0xc2dbb
    mov bx, ax                                ; 89 c3                       ; 0xc2dbd
    sal bx, 00eh                              ; c1 e3 0e                    ; 0xc2dbf
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2dc2
    and AL, strict byte 004h                  ; 24 04                       ; 0xc2dc5
    sal ax, 00bh                              ; c1 e0 0b                    ; 0xc2dc7
    add bx, ax                                ; 01 c3                       ; 0xc2dca
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc2dcc
    xor bx, bx                                ; 31 db                       ; 0xc2dcf vgabios.c:2000
    cmp bx, word [bp-00eh]                    ; 3b 5e f2                    ; 0xc2dd1
    jnc short 02e04h                          ; 73 2e                       ; 0xc2dd4
    mov cl, byte [bp+008h]                    ; 8a 4e 08                    ; 0xc2dd6 vgabios.c:2002
    xor ch, ch                                ; 30 ed                       ; 0xc2dd9
    mov ax, bx                                ; 89 d8                       ; 0xc2ddb
    mul cx                                    ; f7 e1                       ; 0xc2ddd
    mov si, word [bp-00ah]                    ; 8b 76 f6                    ; 0xc2ddf
    add si, ax                                ; 01 c6                       ; 0xc2de2
    mov ax, word [bp+004h]                    ; 8b 46 04                    ; 0xc2de4 vgabios.c:2003
    add ax, bx                                ; 01 d8                       ; 0xc2de7
    sal ax, 005h                              ; c1 e0 05                    ; 0xc2de9
    mov di, word [bp-008h]                    ; 8b 7e f8                    ; 0xc2dec
    add di, ax                                ; 01 c7                       ; 0xc2def
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc2df1 vgabios.c:2004
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2df4
    mov es, ax                                ; 8e c0                       ; 0xc2df7
    jcxz 02e01h                               ; e3 06                       ; 0xc2df9
    push DS                                   ; 1e                          ; 0xc2dfb
    mov ds, dx                                ; 8e da                       ; 0xc2dfc
    rep movsb                                 ; f3 a4                       ; 0xc2dfe
    pop DS                                    ; 1f                          ; 0xc2e00
    inc bx                                    ; 43                          ; 0xc2e01 vgabios.c:2005
    jmp short 02dd1h                          ; eb cd                       ; 0xc2e02
    call 02c16h                               ; e8 0f fe                    ; 0xc2e04 vgabios.c:2006
    cmp byte [bp-006h], 010h                  ; 80 7e fa 10                 ; 0xc2e07 vgabios.c:2007
    jc short 02e15h                           ; 72 08                       ; 0xc2e0b
    mov al, byte [bp+008h]                    ; 8a 46 08                    ; 0xc2e0d vgabios.c:2009
    xor ah, ah                                ; 30 e4                       ; 0xc2e10
    call 02c46h                               ; e8 31 fe                    ; 0xc2e12
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2e15 vgabios.c:2011
    pop di                                    ; 5f                          ; 0xc2e18
    pop si                                    ; 5e                          ; 0xc2e19
    pop bp                                    ; 5d                          ; 0xc2e1a
    retn 00006h                               ; c2 06 00                    ; 0xc2e1b
  ; disGetNextSymbol 0xc2e1e LB 0x16a3 -> off=0x0 cb=0000000000000016 uValue=00000000000c2e1e 'biosfn_load_gfx_8_8_chars'
biosfn_load_gfx_8_8_chars:                   ; 0xc2e1e LB 0x16
    push bp                                   ; 55                          ; 0xc2e1e vgabios.c:2013
    mov bp, sp                                ; 89 e5                       ; 0xc2e1f
    push bx                                   ; 53                          ; 0xc2e21
    push cx                                   ; 51                          ; 0xc2e22
    mov bx, dx                                ; 89 d3                       ; 0xc2e23 vgabios.c:2015
    mov cx, ax                                ; 89 c1                       ; 0xc2e25
    mov ax, strict word 0001fh                ; b8 1f 00                    ; 0xc2e27
    call 009f0h                               ; e8 c3 db                    ; 0xc2e2a
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2e2d vgabios.c:2016
    pop cx                                    ; 59                          ; 0xc2e30
    pop bx                                    ; 5b                          ; 0xc2e31
    pop bp                                    ; 5d                          ; 0xc2e32
    retn                                      ; c3                          ; 0xc2e33
  ; disGetNextSymbol 0xc2e34 LB 0x168d -> off=0x0 cb=000000000000004d uValue=00000000000c2e34 'set_gfx_font'
set_gfx_font:                                ; 0xc2e34 LB 0x4d
    push bp                                   ; 55                          ; 0xc2e34 vgabios.c:2018
    mov bp, sp                                ; 89 e5                       ; 0xc2e35
    push si                                   ; 56                          ; 0xc2e37
    push di                                   ; 57                          ; 0xc2e38
    mov si, ax                                ; 89 c6                       ; 0xc2e39
    mov ax, dx                                ; 89 d0                       ; 0xc2e3b
    mov di, bx                                ; 89 df                       ; 0xc2e3d
    mov dl, cl                                ; 88 ca                       ; 0xc2e3f
    mov bx, si                                ; 89 f3                       ; 0xc2e41 vgabios.c:2022
    mov cx, ax                                ; 89 c1                       ; 0xc2e43
    mov ax, strict word 00043h                ; b8 43 00                    ; 0xc2e45
    call 009f0h                               ; e8 a5 db                    ; 0xc2e48
    test dl, dl                               ; 84 d2                       ; 0xc2e4b vgabios.c:2023
    je short 02e61h                           ; 74 12                       ; 0xc2e4d
    cmp dl, 003h                              ; 80 fa 03                    ; 0xc2e4f vgabios.c:2024
    jbe short 02e56h                          ; 76 02                       ; 0xc2e52
    mov DL, strict byte 002h                  ; b2 02                       ; 0xc2e54 vgabios.c:2025
    mov bl, dl                                ; 88 d3                       ; 0xc2e56 vgabios.c:2026
    xor bh, bh                                ; 30 ff                       ; 0xc2e58
    mov al, byte [bx+07dfbh]                  ; 8a 87 fb 7d                 ; 0xc2e5a
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc2e5e
    mov bx, 00085h                            ; bb 85 00                    ; 0xc2e61 vgabios.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2e64
    mov es, ax                                ; 8e c0                       ; 0xc2e67
    mov word [es:bx], di                      ; 26 89 3f                    ; 0xc2e69
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2e6c vgabios.c:2031
    xor ah, ah                                ; 30 e4                       ; 0xc2e6f
    dec ax                                    ; 48                          ; 0xc2e71
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2e72 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc2e75
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2e78 vgabios.c:2032
    pop di                                    ; 5f                          ; 0xc2e7b
    pop si                                    ; 5e                          ; 0xc2e7c
    pop bp                                    ; 5d                          ; 0xc2e7d
    retn 00002h                               ; c2 02 00                    ; 0xc2e7e
  ; disGetNextSymbol 0xc2e81 LB 0x1640 -> off=0x0 cb=000000000000001d uValue=00000000000c2e81 'biosfn_load_gfx_user_chars'
biosfn_load_gfx_user_chars:                  ; 0xc2e81 LB 0x1d
    push bp                                   ; 55                          ; 0xc2e81 vgabios.c:2034
    mov bp, sp                                ; 89 e5                       ; 0xc2e82
    push si                                   ; 56                          ; 0xc2e84
    mov si, ax                                ; 89 c6                       ; 0xc2e85
    mov ax, dx                                ; 89 d0                       ; 0xc2e87
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc2e89 vgabios.c:2037
    xor dh, dh                                ; 30 f6                       ; 0xc2e8c
    push dx                                   ; 52                          ; 0xc2e8e
    xor ch, ch                                ; 30 ed                       ; 0xc2e8f
    mov dx, si                                ; 89 f2                       ; 0xc2e91
    call 02e34h                               ; e8 9e ff                    ; 0xc2e93
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2e96 vgabios.c:2038
    pop si                                    ; 5e                          ; 0xc2e99
    pop bp                                    ; 5d                          ; 0xc2e9a
    retn 00002h                               ; c2 02 00                    ; 0xc2e9b
  ; disGetNextSymbol 0xc2e9e LB 0x1623 -> off=0x0 cb=0000000000000022 uValue=00000000000c2e9e 'biosfn_load_gfx_8_14_chars'
biosfn_load_gfx_8_14_chars:                  ; 0xc2e9e LB 0x22
    push bp                                   ; 55                          ; 0xc2e9e vgabios.c:2043
    mov bp, sp                                ; 89 e5                       ; 0xc2e9f
    push bx                                   ; 53                          ; 0xc2ea1
    push cx                                   ; 51                          ; 0xc2ea2
    mov bl, al                                ; 88 c3                       ; 0xc2ea3
    mov al, dl                                ; 88 d0                       ; 0xc2ea5
    xor ah, ah                                ; 30 e4                       ; 0xc2ea7 vgabios.c:2045
    push ax                                   ; 50                          ; 0xc2ea9
    mov al, bl                                ; 88 d8                       ; 0xc2eaa
    mov cx, ax                                ; 89 c1                       ; 0xc2eac
    mov bx, strict word 0000eh                ; bb 0e 00                    ; 0xc2eae
    mov ax, 05d6ah                            ; b8 6a 5d                    ; 0xc2eb1
    mov dx, ds                                ; 8c da                       ; 0xc2eb4
    call 02e34h                               ; e8 7b ff                    ; 0xc2eb6
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2eb9 vgabios.c:2046
    pop cx                                    ; 59                          ; 0xc2ebc
    pop bx                                    ; 5b                          ; 0xc2ebd
    pop bp                                    ; 5d                          ; 0xc2ebe
    retn                                      ; c3                          ; 0xc2ebf
  ; disGetNextSymbol 0xc2ec0 LB 0x1601 -> off=0x0 cb=0000000000000022 uValue=00000000000c2ec0 'biosfn_load_gfx_8_8_dd_chars'
biosfn_load_gfx_8_8_dd_chars:                ; 0xc2ec0 LB 0x22
    push bp                                   ; 55                          ; 0xc2ec0 vgabios.c:2047
    mov bp, sp                                ; 89 e5                       ; 0xc2ec1
    push bx                                   ; 53                          ; 0xc2ec3
    push cx                                   ; 51                          ; 0xc2ec4
    mov bl, al                                ; 88 c3                       ; 0xc2ec5
    mov al, dl                                ; 88 d0                       ; 0xc2ec7
    xor ah, ah                                ; 30 e4                       ; 0xc2ec9 vgabios.c:2049
    push ax                                   ; 50                          ; 0xc2ecb
    mov al, bl                                ; 88 d8                       ; 0xc2ecc
    mov cx, ax                                ; 89 c1                       ; 0xc2ece
    mov bx, strict word 00008h                ; bb 08 00                    ; 0xc2ed0
    mov ax, 0556ah                            ; b8 6a 55                    ; 0xc2ed3
    mov dx, ds                                ; 8c da                       ; 0xc2ed6
    call 02e34h                               ; e8 59 ff                    ; 0xc2ed8
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2edb vgabios.c:2050
    pop cx                                    ; 59                          ; 0xc2ede
    pop bx                                    ; 5b                          ; 0xc2edf
    pop bp                                    ; 5d                          ; 0xc2ee0
    retn                                      ; c3                          ; 0xc2ee1
  ; disGetNextSymbol 0xc2ee2 LB 0x15df -> off=0x0 cb=0000000000000022 uValue=00000000000c2ee2 'biosfn_load_gfx_8_16_chars'
biosfn_load_gfx_8_16_chars:                  ; 0xc2ee2 LB 0x22
    push bp                                   ; 55                          ; 0xc2ee2 vgabios.c:2051
    mov bp, sp                                ; 89 e5                       ; 0xc2ee3
    push bx                                   ; 53                          ; 0xc2ee5
    push cx                                   ; 51                          ; 0xc2ee6
    mov bl, al                                ; 88 c3                       ; 0xc2ee7
    mov al, dl                                ; 88 d0                       ; 0xc2ee9
    xor ah, ah                                ; 30 e4                       ; 0xc2eeb vgabios.c:2053
    push ax                                   ; 50                          ; 0xc2eed
    mov al, bl                                ; 88 d8                       ; 0xc2eee
    mov cx, ax                                ; 89 c1                       ; 0xc2ef0
    mov bx, strict word 00010h                ; bb 10 00                    ; 0xc2ef2
    mov ax, 06b6ah                            ; b8 6a 6b                    ; 0xc2ef5
    mov dx, ds                                ; 8c da                       ; 0xc2ef8
    call 02e34h                               ; e8 37 ff                    ; 0xc2efa
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2efd vgabios.c:2054
    pop cx                                    ; 59                          ; 0xc2f00
    pop bx                                    ; 5b                          ; 0xc2f01
    pop bp                                    ; 5d                          ; 0xc2f02
    retn                                      ; c3                          ; 0xc2f03
  ; disGetNextSymbol 0xc2f04 LB 0x15bd -> off=0x0 cb=0000000000000005 uValue=00000000000c2f04 'biosfn_alternate_prtsc'
biosfn_alternate_prtsc:                      ; 0xc2f04 LB 0x5
    push bp                                   ; 55                          ; 0xc2f04 vgabios.c:2056
    mov bp, sp                                ; 89 e5                       ; 0xc2f05
    pop bp                                    ; 5d                          ; 0xc2f07 vgabios.c:2061
    retn                                      ; c3                          ; 0xc2f08
  ; disGetNextSymbol 0xc2f09 LB 0x15b8 -> off=0x0 cb=0000000000000032 uValue=00000000000c2f09 'biosfn_set_txt_lines'
biosfn_set_txt_lines:                        ; 0xc2f09 LB 0x32
    push bx                                   ; 53                          ; 0xc2f09 vgabios.c:2063
    push si                                   ; 56                          ; 0xc2f0a
    push bp                                   ; 55                          ; 0xc2f0b
    mov bp, sp                                ; 89 e5                       ; 0xc2f0c
    mov bl, al                                ; 88 c3                       ; 0xc2f0e
    mov si, 00089h                            ; be 89 00                    ; 0xc2f10 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2f13
    mov es, ax                                ; 8e c0                       ; 0xc2f16
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2f18
    and AL, strict byte 06fh                  ; 24 6f                       ; 0xc2f1b vgabios.c:2069
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc2f1d vgabios.c:2071
    je short 02f2ah                           ; 74 08                       ; 0xc2f20
    test bl, bl                               ; 84 db                       ; 0xc2f22
    jne short 02f2ch                          ; 75 06                       ; 0xc2f24
    or AL, strict byte 080h                   ; 0c 80                       ; 0xc2f26 vgabios.c:2074
    jmp short 02f2ch                          ; eb 02                       ; 0xc2f28 vgabios.c:2075
    or AL, strict byte 010h                   ; 0c 10                       ; 0xc2f2a vgabios.c:2077
    mov bx, 00089h                            ; bb 89 00                    ; 0xc2f2c vgabios.c:52
    mov si, strict word 00040h                ; be 40 00                    ; 0xc2f2f
    mov es, si                                ; 8e c6                       ; 0xc2f32
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2f34
    pop bp                                    ; 5d                          ; 0xc2f37 vgabios.c:2081
    pop si                                    ; 5e                          ; 0xc2f38
    pop bx                                    ; 5b                          ; 0xc2f39
    retn                                      ; c3                          ; 0xc2f3a
  ; disGetNextSymbol 0xc2f3b LB 0x1586 -> off=0x0 cb=0000000000000005 uValue=00000000000c2f3b 'biosfn_switch_video_interface'
biosfn_switch_video_interface:               ; 0xc2f3b LB 0x5
    push bp                                   ; 55                          ; 0xc2f3b vgabios.c:2084
    mov bp, sp                                ; 89 e5                       ; 0xc2f3c
    pop bp                                    ; 5d                          ; 0xc2f3e vgabios.c:2089
    retn                                      ; c3                          ; 0xc2f3f
  ; disGetNextSymbol 0xc2f40 LB 0x1581 -> off=0x0 cb=0000000000000005 uValue=00000000000c2f40 'biosfn_enable_video_refresh_control'
biosfn_enable_video_refresh_control:         ; 0xc2f40 LB 0x5
    push bp                                   ; 55                          ; 0xc2f40 vgabios.c:2090
    mov bp, sp                                ; 89 e5                       ; 0xc2f41
    pop bp                                    ; 5d                          ; 0xc2f43 vgabios.c:2095
    retn                                      ; c3                          ; 0xc2f44
  ; disGetNextSymbol 0xc2f45 LB 0x157c -> off=0x0 cb=000000000000009d uValue=00000000000c2f45 'biosfn_write_string'
biosfn_write_string:                         ; 0xc2f45 LB 0x9d
    push bp                                   ; 55                          ; 0xc2f45 vgabios.c:2098
    mov bp, sp                                ; 89 e5                       ; 0xc2f46
    push si                                   ; 56                          ; 0xc2f48
    push di                                   ; 57                          ; 0xc2f49
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc2f4a
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2f4d
    mov byte [bp-008h], dl                    ; 88 56 f8                    ; 0xc2f50
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc2f53
    mov si, cx                                ; 89 ce                       ; 0xc2f56
    mov di, word [bp+00ah]                    ; 8b 7e 0a                    ; 0xc2f58
    mov al, dl                                ; 88 d0                       ; 0xc2f5b vgabios.c:2105
    xor ah, ah                                ; 30 e4                       ; 0xc2f5d
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc2f5f
    lea dx, [bp-00ch]                         ; 8d 56 f4                    ; 0xc2f62
    call 00a96h                               ; e8 2e db                    ; 0xc2f65
    cmp byte [bp+004h], 0ffh                  ; 80 7e 04 ff                 ; 0xc2f68 vgabios.c:2108
    jne short 02f7fh                          ; 75 11                       ; 0xc2f6c
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2f6e vgabios.c:2109
    mov byte [bp+006h], al                    ; 88 46 06                    ; 0xc2f71
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2f74 vgabios.c:2110
    xor al, al                                ; 30 c0                       ; 0xc2f77
    shr ax, 008h                              ; c1 e8 08                    ; 0xc2f79
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc2f7c
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc2f7f vgabios.c:2113
    xor dh, dh                                ; 30 f6                       ; 0xc2f82
    sal dx, 008h                              ; c1 e2 08                    ; 0xc2f84
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2f87
    xor ah, ah                                ; 30 e4                       ; 0xc2f8a
    add dx, ax                                ; 01 c2                       ; 0xc2f8c
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2f8e vgabios.c:2114
    call 01278h                               ; e8 e4 e2                    ; 0xc2f91
    dec si                                    ; 4e                          ; 0xc2f94 vgabios.c:2116
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2f95
    je short 02fc8h                           ; 74 2e                       ; 0xc2f98
    mov bx, di                                ; 89 fb                       ; 0xc2f9a vgabios.c:2118
    inc di                                    ; 47                          ; 0xc2f9c
    mov es, [bp+008h]                         ; 8e 46 08                    ; 0xc2f9d vgabios.c:47
    mov ah, byte [es:bx]                      ; 26 8a 27                    ; 0xc2fa0
    test byte [bp-006h], 002h                 ; f6 46 fa 02                 ; 0xc2fa3 vgabios.c:2119
    je short 02fb2h                           ; 74 09                       ; 0xc2fa7
    mov bx, di                                ; 89 fb                       ; 0xc2fa9 vgabios.c:2120
    inc di                                    ; 47                          ; 0xc2fab
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2fac vgabios.c:47
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc2faf vgabios.c:48
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc2fb2 vgabios.c:2122
    xor bh, bh                                ; 30 ff                       ; 0xc2fb5
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc2fb7
    xor dh, dh                                ; 30 f6                       ; 0xc2fba
    mov al, ah                                ; 88 e0                       ; 0xc2fbc
    xor ah, ah                                ; 30 e4                       ; 0xc2fbe
    mov cx, strict word 00003h                ; b9 03 00                    ; 0xc2fc0
    call 0298fh                               ; e8 c9 f9                    ; 0xc2fc3
    jmp short 02f94h                          ; eb cc                       ; 0xc2fc6 vgabios.c:2123
    test byte [bp-006h], 001h                 ; f6 46 fa 01                 ; 0xc2fc8 vgabios.c:2126
    jne short 02fd9h                          ; 75 0b                       ; 0xc2fcc
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc2fce vgabios.c:2127
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2fd1
    xor ah, ah                                ; 30 e4                       ; 0xc2fd4
    call 01278h                               ; e8 9f e2                    ; 0xc2fd6
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2fd9 vgabios.c:2128
    pop di                                    ; 5f                          ; 0xc2fdc
    pop si                                    ; 5e                          ; 0xc2fdd
    pop bp                                    ; 5d                          ; 0xc2fde
    retn 00008h                               ; c2 08 00                    ; 0xc2fdf
  ; disGetNextSymbol 0xc2fe2 LB 0x14df -> off=0x0 cb=00000000000001ef uValue=00000000000c2fe2 'biosfn_read_state_info'
biosfn_read_state_info:                      ; 0xc2fe2 LB 0x1ef
    push bp                                   ; 55                          ; 0xc2fe2 vgabios.c:2131
    mov bp, sp                                ; 89 e5                       ; 0xc2fe3
    push cx                                   ; 51                          ; 0xc2fe5
    push si                                   ; 56                          ; 0xc2fe6
    push di                                   ; 57                          ; 0xc2fe7
    push ax                                   ; 50                          ; 0xc2fe8
    push ax                                   ; 50                          ; 0xc2fe9
    push dx                                   ; 52                          ; 0xc2fea
    mov si, strict word 00049h                ; be 49 00                    ; 0xc2feb vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2fee
    mov es, ax                                ; 8e c0                       ; 0xc2ff1
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2ff3
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2ff6 vgabios.c:48
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2ff9 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc2ffc
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc2fff vgabios.c:58
    mov ax, ds                                ; 8c d8                       ; 0xc3002 vgabios.c:2142
    mov es, dx                                ; 8e c2                       ; 0xc3004 vgabios.c:72
    mov word [es:bx], 05500h                  ; 26 c7 07 00 55              ; 0xc3006
    mov [es:bx+002h], ds                      ; 26 8c 5f 02                 ; 0xc300b
    lea di, [bx+004h]                         ; 8d 7f 04                    ; 0xc300f vgabios.c:2147
    mov cx, strict word 0001eh                ; b9 1e 00                    ; 0xc3012
    mov si, strict word 00049h                ; be 49 00                    ; 0xc3015
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc3018
    jcxz 03023h                               ; e3 06                       ; 0xc301b
    push DS                                   ; 1e                          ; 0xc301d
    mov ds, dx                                ; 8e da                       ; 0xc301e
    rep movsb                                 ; f3 a4                       ; 0xc3020
    pop DS                                    ; 1f                          ; 0xc3022
    mov si, 00084h                            ; be 84 00                    ; 0xc3023 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3026
    mov es, ax                                ; 8e c0                       ; 0xc3029
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc302b
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc302e vgabios.c:48
    lea si, [bx+022h]                         ; 8d 77 22                    ; 0xc3030
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc3033 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3036
    lea di, [bx+023h]                         ; 8d 7f 23                    ; 0xc3039 vgabios.c:2149
    mov cx, strict word 00002h                ; b9 02 00                    ; 0xc303c
    mov si, 00085h                            ; be 85 00                    ; 0xc303f
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc3042
    jcxz 0304dh                               ; e3 06                       ; 0xc3045
    push DS                                   ; 1e                          ; 0xc3047
    mov ds, dx                                ; 8e da                       ; 0xc3048
    rep movsb                                 ; f3 a4                       ; 0xc304a
    pop DS                                    ; 1f                          ; 0xc304c
    mov si, 0008ah                            ; be 8a 00                    ; 0xc304d vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3050
    mov es, ax                                ; 8e c0                       ; 0xc3053
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3055
    lea si, [bx+025h]                         ; 8d 77 25                    ; 0xc3058 vgabios.c:48
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc305b vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc305e
    lea si, [bx+026h]                         ; 8d 77 26                    ; 0xc3061 vgabios.c:2152
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc3064 vgabios.c:52
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc3068 vgabios.c:2153
    mov word [es:si], strict word 00010h      ; 26 c7 04 10 00              ; 0xc306b vgabios.c:62
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc3070 vgabios.c:2154
    mov byte [es:si], 008h                    ; 26 c6 04 08                 ; 0xc3073 vgabios.c:52
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc3077 vgabios.c:2155
    mov byte [es:si], 002h                    ; 26 c6 04 02                 ; 0xc307a vgabios.c:52
    lea si, [bx+02bh]                         ; 8d 77 2b                    ; 0xc307e vgabios.c:2156
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc3081 vgabios.c:52
    lea si, [bx+02ch]                         ; 8d 77 2c                    ; 0xc3085 vgabios.c:2157
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc3088 vgabios.c:52
    lea si, [bx+02dh]                         ; 8d 77 2d                    ; 0xc308c vgabios.c:2158
    mov byte [es:si], 021h                    ; 26 c6 04 21                 ; 0xc308f vgabios.c:52
    lea si, [bx+031h]                         ; 8d 77 31                    ; 0xc3093 vgabios.c:2159
    mov byte [es:si], 003h                    ; 26 c6 04 03                 ; 0xc3096 vgabios.c:52
    lea si, [bx+032h]                         ; 8d 77 32                    ; 0xc309a vgabios.c:2160
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc309d vgabios.c:52
    mov si, 00089h                            ; be 89 00                    ; 0xc30a1 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc30a4
    mov es, ax                                ; 8e c0                       ; 0xc30a7
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc30a9
    mov dl, al                                ; 88 c2                       ; 0xc30ac vgabios.c:2165
    and dl, 080h                              ; 80 e2 80                    ; 0xc30ae
    xor dh, dh                                ; 30 f6                       ; 0xc30b1
    sar dx, 006h                              ; c1 fa 06                    ; 0xc30b3
    and AL, strict byte 010h                  ; 24 10                       ; 0xc30b6
    xor ah, ah                                ; 30 e4                       ; 0xc30b8
    sar ax, 004h                              ; c1 f8 04                    ; 0xc30ba
    or ax, dx                                 ; 09 d0                       ; 0xc30bd
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc30bf vgabios.c:2166
    je short 030d5h                           ; 74 11                       ; 0xc30c2
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc30c4
    je short 030d1h                           ; 74 08                       ; 0xc30c7
    test ax, ax                               ; 85 c0                       ; 0xc30c9
    jne short 030d5h                          ; 75 08                       ; 0xc30cb
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc30cd vgabios.c:2167
    jmp short 030d7h                          ; eb 06                       ; 0xc30cf
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc30d1 vgabios.c:2168
    jmp short 030d7h                          ; eb 02                       ; 0xc30d3
    xor al, al                                ; 30 c0                       ; 0xc30d5 vgabios.c:2170
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc30d7 vgabios.c:2172
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc30da vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc30dd
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc30e0 vgabios.c:2175
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc30e3
    jc short 03106h                           ; 72 1f                       ; 0xc30e5
    cmp AL, strict byte 012h                  ; 3c 12                       ; 0xc30e7
    jnbe short 03106h                         ; 77 1b                       ; 0xc30e9
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc30eb vgabios.c:2176
    test ax, ax                               ; 85 c0                       ; 0xc30ee
    je short 03148h                           ; 74 56                       ; 0xc30f0
    mov si, ax                                ; 89 c6                       ; 0xc30f2 vgabios.c:2177
    shr si, 002h                              ; c1 ee 02                    ; 0xc30f4
    mov ax, 04000h                            ; b8 00 40                    ; 0xc30f7
    xor dx, dx                                ; 31 d2                       ; 0xc30fa
    div si                                    ; f7 f6                       ; 0xc30fc
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc30fe
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3101 vgabios.c:52
    jmp short 03148h                          ; eb 42                       ; 0xc3104 vgabios.c:2178
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc3106
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3109
    cmp AL, strict byte 013h                  ; 3c 13                       ; 0xc310c
    jne short 03121h                          ; 75 11                       ; 0xc310e
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc3110 vgabios.c:52
    mov byte [es:si], 001h                    ; 26 c6 04 01                 ; 0xc3113
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc3117 vgabios.c:2180
    mov word [es:si], 00100h                  ; 26 c7 04 00 01              ; 0xc311a vgabios.c:62
    jmp short 03148h                          ; eb 27                       ; 0xc311f vgabios.c:2181
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc3121
    jc short 03148h                           ; 72 23                       ; 0xc3123
    cmp AL, strict byte 006h                  ; 3c 06                       ; 0xc3125
    jnbe short 03148h                         ; 77 1f                       ; 0xc3127
    cmp word [bp-00ah], strict byte 00000h    ; 83 7e f6 00                 ; 0xc3129 vgabios.c:2183
    je short 0313dh                           ; 74 0e                       ; 0xc312d
    mov ax, 04000h                            ; b8 00 40                    ; 0xc312f vgabios.c:2184
    xor dx, dx                                ; 31 d2                       ; 0xc3132
    div word [bp-00ah]                        ; f7 76 f6                    ; 0xc3134
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc3137 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc313a
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc313d vgabios.c:2185
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc3140 vgabios.c:62
    mov word [es:si], strict word 00004h      ; 26 c7 04 04 00              ; 0xc3143
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3148 vgabios.c:2187
    cmp AL, strict byte 006h                  ; 3c 06                       ; 0xc314b
    je short 03153h                           ; 74 04                       ; 0xc314d
    cmp AL, strict byte 011h                  ; 3c 11                       ; 0xc314f
    jne short 0315eh                          ; 75 0b                       ; 0xc3151
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc3153 vgabios.c:2188
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc3156 vgabios.c:62
    mov word [es:si], strict word 00002h      ; 26 c7 04 02 00              ; 0xc3159
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc315e vgabios.c:2190
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc3161
    jc short 031bah                           ; 72 55                       ; 0xc3163
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc3165
    je short 031bah                           ; 74 51                       ; 0xc3167
    lea si, [bx+02dh]                         ; 8d 77 2d                    ; 0xc3169 vgabios.c:2191
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc316c vgabios.c:52
    mov byte [es:si], 001h                    ; 26 c6 04 01                 ; 0xc316f
    mov si, 00084h                            ; be 84 00                    ; 0xc3173 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3176
    mov es, ax                                ; 8e c0                       ; 0xc3179
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc317b
    xor ah, ah                                ; 30 e4                       ; 0xc317e vgabios.c:48
    inc ax                                    ; 40                          ; 0xc3180
    mov si, 00085h                            ; be 85 00                    ; 0xc3181 vgabios.c:47
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc3184
    xor dh, dh                                ; 30 f6                       ; 0xc3187 vgabios.c:48
    imul dx                                   ; f7 ea                       ; 0xc3189
    cmp ax, 0015eh                            ; 3d 5e 01                    ; 0xc318b vgabios.c:2193
    jc short 0319eh                           ; 72 0e                       ; 0xc318e
    jbe short 031a7h                          ; 76 15                       ; 0xc3190
    cmp ax, 001e0h                            ; 3d e0 01                    ; 0xc3192
    je short 031afh                           ; 74 18                       ; 0xc3195
    cmp ax, 00190h                            ; 3d 90 01                    ; 0xc3197
    je short 031abh                           ; 74 0f                       ; 0xc319a
    jmp short 031afh                          ; eb 11                       ; 0xc319c
    cmp ax, 000c8h                            ; 3d c8 00                    ; 0xc319e
    jne short 031afh                          ; 75 0c                       ; 0xc31a1
    xor al, al                                ; 30 c0                       ; 0xc31a3 vgabios.c:2194
    jmp short 031b1h                          ; eb 0a                       ; 0xc31a5
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc31a7 vgabios.c:2195
    jmp short 031b1h                          ; eb 06                       ; 0xc31a9
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc31ab vgabios.c:2196
    jmp short 031b1h                          ; eb 02                       ; 0xc31ad
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc31af vgabios.c:2198
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc31b1 vgabios.c:2200
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc31b4 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc31b7
    lea di, [bx+033h]                         ; 8d 7f 33                    ; 0xc31ba vgabios.c:2203
    mov cx, strict word 0000dh                ; b9 0d 00                    ; 0xc31bd
    xor ax, ax                                ; 31 c0                       ; 0xc31c0
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc31c2
    jcxz 031c9h                               ; e3 02                       ; 0xc31c5
    rep stosb                                 ; f3 aa                       ; 0xc31c7
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc31c9 vgabios.c:2204
    pop di                                    ; 5f                          ; 0xc31cc
    pop si                                    ; 5e                          ; 0xc31cd
    pop cx                                    ; 59                          ; 0xc31ce
    pop bp                                    ; 5d                          ; 0xc31cf
    retn                                      ; c3                          ; 0xc31d0
  ; disGetNextSymbol 0xc31d1 LB 0x12f0 -> off=0x0 cb=0000000000000023 uValue=00000000000c31d1 'biosfn_read_video_state_size2'
biosfn_read_video_state_size2:               ; 0xc31d1 LB 0x23
    push dx                                   ; 52                          ; 0xc31d1 vgabios.c:2207
    push bp                                   ; 55                          ; 0xc31d2
    mov bp, sp                                ; 89 e5                       ; 0xc31d3
    mov dx, ax                                ; 89 c2                       ; 0xc31d5
    xor ax, ax                                ; 31 c0                       ; 0xc31d7 vgabios.c:2211
    test dl, 001h                             ; f6 c2 01                    ; 0xc31d9 vgabios.c:2212
    je short 031e1h                           ; 74 03                       ; 0xc31dc
    mov ax, strict word 00046h                ; b8 46 00                    ; 0xc31de vgabios.c:2213
    test dl, 002h                             ; f6 c2 02                    ; 0xc31e1 vgabios.c:2215
    je short 031e9h                           ; 74 03                       ; 0xc31e4
    add ax, strict word 0002ah                ; 05 2a 00                    ; 0xc31e6 vgabios.c:2216
    test dl, 004h                             ; f6 c2 04                    ; 0xc31e9 vgabios.c:2218
    je short 031f1h                           ; 74 03                       ; 0xc31ec
    add ax, 00304h                            ; 05 04 03                    ; 0xc31ee vgabios.c:2219
    pop bp                                    ; 5d                          ; 0xc31f1 vgabios.c:2222
    pop dx                                    ; 5a                          ; 0xc31f2
    retn                                      ; c3                          ; 0xc31f3
  ; disGetNextSymbol 0xc31f4 LB 0x12cd -> off=0x0 cb=0000000000000018 uValue=00000000000c31f4 'vga_get_video_state_size'
vga_get_video_state_size:                    ; 0xc31f4 LB 0x18
    push bp                                   ; 55                          ; 0xc31f4 vgabios.c:2224
    mov bp, sp                                ; 89 e5                       ; 0xc31f5
    push bx                                   ; 53                          ; 0xc31f7
    mov bx, dx                                ; 89 d3                       ; 0xc31f8
    call 031d1h                               ; e8 d4 ff                    ; 0xc31fa vgabios.c:2227
    add ax, strict word 0003fh                ; 05 3f 00                    ; 0xc31fd
    shr ax, 006h                              ; c1 e8 06                    ; 0xc3200
    mov word [ss:bx], ax                      ; 36 89 07                    ; 0xc3203
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3206 vgabios.c:2228
    pop bx                                    ; 5b                          ; 0xc3209
    pop bp                                    ; 5d                          ; 0xc320a
    retn                                      ; c3                          ; 0xc320b
  ; disGetNextSymbol 0xc320c LB 0x12b5 -> off=0x0 cb=00000000000002d8 uValue=00000000000c320c 'biosfn_save_video_state'
biosfn_save_video_state:                     ; 0xc320c LB 0x2d8
    push bp                                   ; 55                          ; 0xc320c vgabios.c:2230
    mov bp, sp                                ; 89 e5                       ; 0xc320d
    push cx                                   ; 51                          ; 0xc320f
    push si                                   ; 56                          ; 0xc3210
    push di                                   ; 57                          ; 0xc3211
    push ax                                   ; 50                          ; 0xc3212
    push ax                                   ; 50                          ; 0xc3213
    push ax                                   ; 50                          ; 0xc3214
    mov cx, dx                                ; 89 d1                       ; 0xc3215
    mov si, strict word 00063h                ; be 63 00                    ; 0xc3217 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc321a
    mov es, ax                                ; 8e c0                       ; 0xc321d
    mov di, word [es:si]                      ; 26 8b 3c                    ; 0xc321f
    mov si, di                                ; 89 fe                       ; 0xc3222 vgabios.c:58
    test byte [bp-00ch], 001h                 ; f6 46 f4 01                 ; 0xc3224 vgabios.c:2235
    je short 03290h                           ; 74 66                       ; 0xc3228
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc322a vgabios.c:2236
    in AL, DX                                 ; ec                          ; 0xc322d
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc322e
    mov es, cx                                ; 8e c1                       ; 0xc3230 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3232
    inc bx                                    ; 43                          ; 0xc3235 vgabios.c:2236
    mov dx, di                                ; 89 fa                       ; 0xc3236
    in AL, DX                                 ; ec                          ; 0xc3238
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3239
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc323b vgabios.c:52
    inc bx                                    ; 43                          ; 0xc323e vgabios.c:2237
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc323f
    in AL, DX                                 ; ec                          ; 0xc3242
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3243
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3245 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3248 vgabios.c:2238
    mov dx, 003dah                            ; ba da 03                    ; 0xc3249
    in AL, DX                                 ; ec                          ; 0xc324c
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc324d
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc324f vgabios.c:2240
    in AL, DX                                 ; ec                          ; 0xc3252
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3253
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc3255
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc3258 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc325b
    inc bx                                    ; 43                          ; 0xc325e vgabios.c:2241
    mov dx, 003cah                            ; ba ca 03                    ; 0xc325f
    in AL, DX                                 ; ec                          ; 0xc3262
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3263
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3265 vgabios.c:52
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc3268 vgabios.c:2244
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc326b
    add bx, ax                                ; 01 c3                       ; 0xc326e vgabios.c:2242
    jmp short 03278h                          ; eb 06                       ; 0xc3270
    cmp word [bp-008h], strict byte 00004h    ; 83 7e f8 04                 ; 0xc3272
    jnbe short 03293h                         ; 77 1b                       ; 0xc3276
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3278 vgabios.c:2245
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc327b
    out DX, AL                                ; ee                          ; 0xc327e
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc327f vgabios.c:2246
    in AL, DX                                 ; ec                          ; 0xc3282
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3283
    mov es, cx                                ; 8e c1                       ; 0xc3285 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3287
    inc bx                                    ; 43                          ; 0xc328a vgabios.c:2246
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc328b vgabios.c:2247
    jmp short 03272h                          ; eb e2                       ; 0xc328e
    jmp near 03340h                           ; e9 ad 00                    ; 0xc3290
    xor al, al                                ; 30 c0                       ; 0xc3293 vgabios.c:2248
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3295
    out DX, AL                                ; ee                          ; 0xc3298
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc3299 vgabios.c:2249
    in AL, DX                                 ; ec                          ; 0xc329c
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc329d
    mov es, cx                                ; 8e c1                       ; 0xc329f vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32a1
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc32a4 vgabios.c:2251
    inc bx                                    ; 43                          ; 0xc32a9 vgabios.c:2249
    jmp short 032b2h                          ; eb 06                       ; 0xc32aa
    cmp word [bp-008h], strict byte 00018h    ; 83 7e f8 18                 ; 0xc32ac
    jnbe short 032c9h                         ; 77 17                       ; 0xc32b0
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc32b2 vgabios.c:2252
    mov dx, si                                ; 89 f2                       ; 0xc32b5
    out DX, AL                                ; ee                          ; 0xc32b7
    lea dx, [si+001h]                         ; 8d 54 01                    ; 0xc32b8 vgabios.c:2253
    in AL, DX                                 ; ec                          ; 0xc32bb
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32bc
    mov es, cx                                ; 8e c1                       ; 0xc32be vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32c0
    inc bx                                    ; 43                          ; 0xc32c3 vgabios.c:2253
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc32c4 vgabios.c:2254
    jmp short 032ach                          ; eb e3                       ; 0xc32c7
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc32c9 vgabios.c:2256
    jmp short 032d6h                          ; eb 06                       ; 0xc32ce
    cmp word [bp-008h], strict byte 00013h    ; 83 7e f8 13                 ; 0xc32d0
    jnbe short 032fah                         ; 77 24                       ; 0xc32d4
    mov dx, 003dah                            ; ba da 03                    ; 0xc32d6 vgabios.c:2257
    in AL, DX                                 ; ec                          ; 0xc32d9
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32da
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc32dc vgabios.c:2258
    and ax, strict word 00020h                ; 25 20 00                    ; 0xc32df
    or ax, word [bp-008h]                     ; 0b 46 f8                    ; 0xc32e2
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc32e5
    out DX, AL                                ; ee                          ; 0xc32e8
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc32e9 vgabios.c:2259
    in AL, DX                                 ; ec                          ; 0xc32ec
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32ed
    mov es, cx                                ; 8e c1                       ; 0xc32ef vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32f1
    inc bx                                    ; 43                          ; 0xc32f4 vgabios.c:2259
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc32f5 vgabios.c:2260
    jmp short 032d0h                          ; eb d6                       ; 0xc32f8
    mov dx, 003dah                            ; ba da 03                    ; 0xc32fa vgabios.c:2261
    in AL, DX                                 ; ec                          ; 0xc32fd
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32fe
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3300 vgabios.c:2263
    jmp short 0330dh                          ; eb 06                       ; 0xc3305
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc3307
    jnbe short 03325h                         ; 77 18                       ; 0xc330b
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc330d vgabios.c:2264
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc3310
    out DX, AL                                ; ee                          ; 0xc3313
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc3314 vgabios.c:2265
    in AL, DX                                 ; ec                          ; 0xc3317
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3318
    mov es, cx                                ; 8e c1                       ; 0xc331a vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc331c
    inc bx                                    ; 43                          ; 0xc331f vgabios.c:2265
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3320 vgabios.c:2266
    jmp short 03307h                          ; eb e2                       ; 0xc3323
    mov es, cx                                ; 8e c1                       ; 0xc3325 vgabios.c:62
    mov word [es:bx], si                      ; 26 89 37                    ; 0xc3327
    inc bx                                    ; 43                          ; 0xc332a vgabios.c:2268
    inc bx                                    ; 43                          ; 0xc332b
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc332c vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3330 vgabios.c:2271
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc3331 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3335 vgabios.c:2272
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc3336 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc333a vgabios.c:2273
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc333b vgabios.c:52
    inc bx                                    ; 43                          ; 0xc333f vgabios.c:2274
    test byte [bp-00ch], 002h                 ; f6 46 f4 02                 ; 0xc3340 vgabios.c:2276
    jne short 03349h                          ; 75 03                       ; 0xc3344
    jmp near 03488h                           ; e9 3f 01                    ; 0xc3346
    mov si, strict word 00049h                ; be 49 00                    ; 0xc3349 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc334c
    mov es, ax                                ; 8e c0                       ; 0xc334f
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3351
    mov es, cx                                ; 8e c1                       ; 0xc3354 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3356
    inc bx                                    ; 43                          ; 0xc3359 vgabios.c:2277
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc335a vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc335d
    mov es, ax                                ; 8e c0                       ; 0xc3360
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3362
    mov es, cx                                ; 8e c1                       ; 0xc3365 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3367
    inc bx                                    ; 43                          ; 0xc336a vgabios.c:2278
    inc bx                                    ; 43                          ; 0xc336b
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc336c vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc336f
    mov es, ax                                ; 8e c0                       ; 0xc3372
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3374
    mov es, cx                                ; 8e c1                       ; 0xc3377 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3379
    inc bx                                    ; 43                          ; 0xc337c vgabios.c:2279
    inc bx                                    ; 43                          ; 0xc337d
    mov si, strict word 00063h                ; be 63 00                    ; 0xc337e vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3381
    mov es, ax                                ; 8e c0                       ; 0xc3384
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3386
    mov es, cx                                ; 8e c1                       ; 0xc3389 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc338b
    inc bx                                    ; 43                          ; 0xc338e vgabios.c:2280
    inc bx                                    ; 43                          ; 0xc338f
    mov si, 00084h                            ; be 84 00                    ; 0xc3390 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3393
    mov es, ax                                ; 8e c0                       ; 0xc3396
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3398
    mov es, cx                                ; 8e c1                       ; 0xc339b vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc339d
    inc bx                                    ; 43                          ; 0xc33a0 vgabios.c:2281
    mov si, 00085h                            ; be 85 00                    ; 0xc33a1 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33a4
    mov es, ax                                ; 8e c0                       ; 0xc33a7
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc33a9
    mov es, cx                                ; 8e c1                       ; 0xc33ac vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc33ae
    inc bx                                    ; 43                          ; 0xc33b1 vgabios.c:2282
    inc bx                                    ; 43                          ; 0xc33b2
    mov si, 00087h                            ; be 87 00                    ; 0xc33b3 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33b6
    mov es, ax                                ; 8e c0                       ; 0xc33b9
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33bb
    mov es, cx                                ; 8e c1                       ; 0xc33be vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc33c0
    inc bx                                    ; 43                          ; 0xc33c3 vgabios.c:2283
    mov si, 00088h                            ; be 88 00                    ; 0xc33c4 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33c7
    mov es, ax                                ; 8e c0                       ; 0xc33ca
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33cc
    mov es, cx                                ; 8e c1                       ; 0xc33cf vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc33d1
    inc bx                                    ; 43                          ; 0xc33d4 vgabios.c:2284
    mov si, 00089h                            ; be 89 00                    ; 0xc33d5 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33d8
    mov es, ax                                ; 8e c0                       ; 0xc33db
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33dd
    mov es, cx                                ; 8e c1                       ; 0xc33e0 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc33e2
    inc bx                                    ; 43                          ; 0xc33e5 vgabios.c:2285
    mov si, strict word 00060h                ; be 60 00                    ; 0xc33e6 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33e9
    mov es, ax                                ; 8e c0                       ; 0xc33ec
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc33ee
    mov es, cx                                ; 8e c1                       ; 0xc33f1 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc33f3
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc33f6 vgabios.c:2287
    inc bx                                    ; 43                          ; 0xc33fb vgabios.c:2286
    inc bx                                    ; 43                          ; 0xc33fc
    jmp short 03405h                          ; eb 06                       ; 0xc33fd
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc33ff
    jnc short 03421h                          ; 73 1c                       ; 0xc3403
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc3405 vgabios.c:2288
    add si, si                                ; 01 f6                       ; 0xc3408
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc340a
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc340d vgabios.c:57
    mov es, ax                                ; 8e c0                       ; 0xc3410
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3412
    mov es, cx                                ; 8e c1                       ; 0xc3415 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3417
    inc bx                                    ; 43                          ; 0xc341a vgabios.c:2289
    inc bx                                    ; 43                          ; 0xc341b
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc341c vgabios.c:2290
    jmp short 033ffh                          ; eb de                       ; 0xc341f
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc3421 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3424
    mov es, ax                                ; 8e c0                       ; 0xc3427
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3429
    mov es, cx                                ; 8e c1                       ; 0xc342c vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc342e
    inc bx                                    ; 43                          ; 0xc3431 vgabios.c:2291
    inc bx                                    ; 43                          ; 0xc3432
    mov si, strict word 00062h                ; be 62 00                    ; 0xc3433 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3436
    mov es, ax                                ; 8e c0                       ; 0xc3439
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc343b
    mov es, cx                                ; 8e c1                       ; 0xc343e vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3440
    inc bx                                    ; 43                          ; 0xc3443 vgabios.c:2292
    mov si, strict word 0007ch                ; be 7c 00                    ; 0xc3444 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc3447
    mov es, ax                                ; 8e c0                       ; 0xc3449
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc344b
    mov es, cx                                ; 8e c1                       ; 0xc344e vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3450
    inc bx                                    ; 43                          ; 0xc3453 vgabios.c:2294
    inc bx                                    ; 43                          ; 0xc3454
    mov si, strict word 0007eh                ; be 7e 00                    ; 0xc3455 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc3458
    mov es, ax                                ; 8e c0                       ; 0xc345a
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc345c
    mov es, cx                                ; 8e c1                       ; 0xc345f vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3461
    inc bx                                    ; 43                          ; 0xc3464 vgabios.c:2295
    inc bx                                    ; 43                          ; 0xc3465
    mov si, 0010ch                            ; be 0c 01                    ; 0xc3466 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc3469
    mov es, ax                                ; 8e c0                       ; 0xc346b
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc346d
    mov es, cx                                ; 8e c1                       ; 0xc3470 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3472
    inc bx                                    ; 43                          ; 0xc3475 vgabios.c:2296
    inc bx                                    ; 43                          ; 0xc3476
    mov si, 0010eh                            ; be 0e 01                    ; 0xc3477 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc347a
    mov es, ax                                ; 8e c0                       ; 0xc347c
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc347e
    mov es, cx                                ; 8e c1                       ; 0xc3481 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3483
    inc bx                                    ; 43                          ; 0xc3486 vgabios.c:2297
    inc bx                                    ; 43                          ; 0xc3487
    test byte [bp-00ch], 004h                 ; f6 46 f4 04                 ; 0xc3488 vgabios.c:2299
    je short 034dah                           ; 74 4c                       ; 0xc348c
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc348e vgabios.c:2301
    in AL, DX                                 ; ec                          ; 0xc3491
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3492
    mov es, cx                                ; 8e c1                       ; 0xc3494 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3496
    inc bx                                    ; 43                          ; 0xc3499 vgabios.c:2301
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc349a
    in AL, DX                                 ; ec                          ; 0xc349d
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc349e
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc34a0 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc34a3 vgabios.c:2302
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc34a4
    in AL, DX                                 ; ec                          ; 0xc34a7
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc34a8
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc34aa vgabios.c:52
    inc bx                                    ; 43                          ; 0xc34ad vgabios.c:2303
    xor al, al                                ; 30 c0                       ; 0xc34ae
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc34b0
    out DX, AL                                ; ee                          ; 0xc34b3
    xor ah, ah                                ; 30 e4                       ; 0xc34b4 vgabios.c:2306
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc34b6
    jmp short 034c2h                          ; eb 07                       ; 0xc34b9
    cmp word [bp-008h], 00300h                ; 81 7e f8 00 03              ; 0xc34bb
    jnc short 034d3h                          ; 73 11                       ; 0xc34c0
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc34c2 vgabios.c:2307
    in AL, DX                                 ; ec                          ; 0xc34c5
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc34c6
    mov es, cx                                ; 8e c1                       ; 0xc34c8 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc34ca
    inc bx                                    ; 43                          ; 0xc34cd vgabios.c:2307
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc34ce vgabios.c:2308
    jmp short 034bbh                          ; eb e8                       ; 0xc34d1
    mov es, cx                                ; 8e c1                       ; 0xc34d3 vgabios.c:52
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc34d5
    inc bx                                    ; 43                          ; 0xc34d9 vgabios.c:2309
    mov ax, bx                                ; 89 d8                       ; 0xc34da vgabios.c:2312
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc34dc
    pop di                                    ; 5f                          ; 0xc34df
    pop si                                    ; 5e                          ; 0xc34e0
    pop cx                                    ; 59                          ; 0xc34e1
    pop bp                                    ; 5d                          ; 0xc34e2
    retn                                      ; c3                          ; 0xc34e3
  ; disGetNextSymbol 0xc34e4 LB 0xfdd -> off=0x0 cb=00000000000002ba uValue=00000000000c34e4 'biosfn_restore_video_state'
biosfn_restore_video_state:                  ; 0xc34e4 LB 0x2ba
    push bp                                   ; 55                          ; 0xc34e4 vgabios.c:2314
    mov bp, sp                                ; 89 e5                       ; 0xc34e5
    push cx                                   ; 51                          ; 0xc34e7
    push si                                   ; 56                          ; 0xc34e8
    push di                                   ; 57                          ; 0xc34e9
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc34ea
    push ax                                   ; 50                          ; 0xc34ed
    mov cx, dx                                ; 89 d1                       ; 0xc34ee
    test byte [bp-010h], 001h                 ; f6 46 f0 01                 ; 0xc34f0 vgabios.c:2318
    je short 0356ah                           ; 74 74                       ; 0xc34f4
    mov dx, 003dah                            ; ba da 03                    ; 0xc34f6 vgabios.c:2320
    in AL, DX                                 ; ec                          ; 0xc34f9
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc34fa
    lea si, [bx+040h]                         ; 8d 77 40                    ; 0xc34fc vgabios.c:2322
    mov es, cx                                ; 8e c1                       ; 0xc34ff vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3501
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc3504 vgabios.c:58
    mov si, bx                                ; 89 de                       ; 0xc3507 vgabios.c:2323
    mov word [bp-008h], strict word 00001h    ; c7 46 f8 01 00              ; 0xc3509 vgabios.c:2326
    add bx, strict byte 00005h                ; 83 c3 05                    ; 0xc350e vgabios.c:2324
    jmp short 03519h                          ; eb 06                       ; 0xc3511
    cmp word [bp-008h], strict byte 00004h    ; 83 7e f8 04                 ; 0xc3513
    jnbe short 0352fh                         ; 77 16                       ; 0xc3517
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3519 vgabios.c:2327
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc351c
    out DX, AL                                ; ee                          ; 0xc351f
    mov es, cx                                ; 8e c1                       ; 0xc3520 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3522
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc3525 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3528
    inc bx                                    ; 43                          ; 0xc3529 vgabios.c:2328
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc352a vgabios.c:2329
    jmp short 03513h                          ; eb e4                       ; 0xc352d
    xor al, al                                ; 30 c0                       ; 0xc352f vgabios.c:2330
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3531
    out DX, AL                                ; ee                          ; 0xc3534
    mov es, cx                                ; 8e c1                       ; 0xc3535 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3537
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc353a vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc353d
    inc bx                                    ; 43                          ; 0xc353e vgabios.c:2331
    mov dx, 003cch                            ; ba cc 03                    ; 0xc353f
    in AL, DX                                 ; ec                          ; 0xc3542
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3543
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc3545
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc3547
    cmp word [bp-00ch], 003d4h                ; 81 7e f4 d4 03              ; 0xc354a vgabios.c:2335
    jne short 03555h                          ; 75 04                       ; 0xc354f
    or byte [bp-00eh], 001h                   ; 80 4e f2 01                 ; 0xc3551 vgabios.c:2336
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc3555 vgabios.c:2337
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc3558
    out DX, AL                                ; ee                          ; 0xc355b
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc355c vgabios.c:2340
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc355f
    out DX, ax                                ; ef                          ; 0xc3562
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3563 vgabios.c:2342
    jmp short 03573h                          ; eb 09                       ; 0xc3568
    jmp near 0362dh                           ; e9 c0 00                    ; 0xc356a
    cmp word [bp-008h], strict byte 00018h    ; 83 7e f8 18                 ; 0xc356d
    jnbe short 0358dh                         ; 77 1a                       ; 0xc3571
    cmp word [bp-008h], strict byte 00011h    ; 83 7e f8 11                 ; 0xc3573 vgabios.c:2343
    je short 03587h                           ; 74 0e                       ; 0xc3577
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3579 vgabios.c:2344
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc357c
    out DX, AL                                ; ee                          ; 0xc357f
    mov es, cx                                ; 8e c1                       ; 0xc3580 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3582
    inc dx                                    ; 42                          ; 0xc3585 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3586
    inc bx                                    ; 43                          ; 0xc3587 vgabios.c:2347
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3588 vgabios.c:2348
    jmp short 0356dh                          ; eb e0                       ; 0xc358b
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc358d vgabios.c:2350
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc358f
    out DX, AL                                ; ee                          ; 0xc3592
    lea di, [word bx-00007h]                  ; 8d bf f9 ff                 ; 0xc3593 vgabios.c:2351
    mov es, cx                                ; 8e c1                       ; 0xc3597 vgabios.c:47
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc3599
    inc dx                                    ; 42                          ; 0xc359c vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc359d
    lea di, [si+003h]                         ; 8d 7c 03                    ; 0xc359e vgabios.c:2354
    mov dl, byte [es:di]                      ; 26 8a 15                    ; 0xc35a1 vgabios.c:47
    xor dh, dh                                ; 30 f6                       ; 0xc35a4 vgabios.c:48
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc35a6
    mov dx, 003dah                            ; ba da 03                    ; 0xc35a9 vgabios.c:2355
    in AL, DX                                 ; ec                          ; 0xc35ac
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc35ad
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc35af vgabios.c:2356
    jmp short 035bch                          ; eb 06                       ; 0xc35b4
    cmp word [bp-008h], strict byte 00013h    ; 83 7e f8 13                 ; 0xc35b6
    jnbe short 035d5h                         ; 77 19                       ; 0xc35ba
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc35bc vgabios.c:2357
    and ax, strict word 00020h                ; 25 20 00                    ; 0xc35bf
    or ax, word [bp-008h]                     ; 0b 46 f8                    ; 0xc35c2
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc35c5
    out DX, AL                                ; ee                          ; 0xc35c8
    mov es, cx                                ; 8e c1                       ; 0xc35c9 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc35cb
    out DX, AL                                ; ee                          ; 0xc35ce vgabios.c:48
    inc bx                                    ; 43                          ; 0xc35cf vgabios.c:2358
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc35d0 vgabios.c:2359
    jmp short 035b6h                          ; eb e1                       ; 0xc35d3
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc35d5 vgabios.c:2360
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc35d8
    out DX, AL                                ; ee                          ; 0xc35db
    mov dx, 003dah                            ; ba da 03                    ; 0xc35dc vgabios.c:2361
    in AL, DX                                 ; ec                          ; 0xc35df
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc35e0
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc35e2 vgabios.c:2363
    jmp short 035efh                          ; eb 06                       ; 0xc35e7
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc35e9
    jnbe short 03605h                         ; 77 16                       ; 0xc35ed
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc35ef vgabios.c:2364
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc35f2
    out DX, AL                                ; ee                          ; 0xc35f5
    mov es, cx                                ; 8e c1                       ; 0xc35f6 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc35f8
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc35fb vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc35fe
    inc bx                                    ; 43                          ; 0xc35ff vgabios.c:2365
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3600 vgabios.c:2366
    jmp short 035e9h                          ; eb e4                       ; 0xc3603
    add bx, strict byte 00006h                ; 83 c3 06                    ; 0xc3605 vgabios.c:2367
    mov es, cx                                ; 8e c1                       ; 0xc3608 vgabios.c:47
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc360a
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc360d vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3610
    inc si                                    ; 46                          ; 0xc3611 vgabios.c:2370
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3612 vgabios.c:47
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc3615 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3618
    inc si                                    ; 46                          ; 0xc3619 vgabios.c:2371
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc361a vgabios.c:47
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc361d vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3620
    inc si                                    ; 46                          ; 0xc3621 vgabios.c:2372
    inc si                                    ; 46                          ; 0xc3622
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3623 vgabios.c:47
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc3626 vgabios.c:48
    add dx, strict byte 00006h                ; 83 c2 06                    ; 0xc3629
    out DX, AL                                ; ee                          ; 0xc362c
    test byte [bp-010h], 002h                 ; f6 46 f0 02                 ; 0xc362d vgabios.c:2376
    jne short 03636h                          ; 75 03                       ; 0xc3631
    jmp near 03751h                           ; e9 1b 01                    ; 0xc3633
    mov es, cx                                ; 8e c1                       ; 0xc3636 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3638
    mov si, strict word 00049h                ; be 49 00                    ; 0xc363b vgabios.c:52
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc363e
    mov es, dx                                ; 8e c2                       ; 0xc3641
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3643
    inc bx                                    ; 43                          ; 0xc3646 vgabios.c:2377
    mov es, cx                                ; 8e c1                       ; 0xc3647 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3649
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc364c vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc364f
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3651
    inc bx                                    ; 43                          ; 0xc3654 vgabios.c:2378
    inc bx                                    ; 43                          ; 0xc3655
    mov es, cx                                ; 8e c1                       ; 0xc3656 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3658
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc365b vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc365e
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3660
    inc bx                                    ; 43                          ; 0xc3663 vgabios.c:2379
    inc bx                                    ; 43                          ; 0xc3664
    mov es, cx                                ; 8e c1                       ; 0xc3665 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3667
    mov si, strict word 00063h                ; be 63 00                    ; 0xc366a vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc366d
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc366f
    inc bx                                    ; 43                          ; 0xc3672 vgabios.c:2380
    inc bx                                    ; 43                          ; 0xc3673
    mov es, cx                                ; 8e c1                       ; 0xc3674 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3676
    mov si, 00084h                            ; be 84 00                    ; 0xc3679 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc367c
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc367e
    inc bx                                    ; 43                          ; 0xc3681 vgabios.c:2381
    mov es, cx                                ; 8e c1                       ; 0xc3682 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3684
    mov si, 00085h                            ; be 85 00                    ; 0xc3687 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc368a
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc368c
    inc bx                                    ; 43                          ; 0xc368f vgabios.c:2382
    inc bx                                    ; 43                          ; 0xc3690
    mov es, cx                                ; 8e c1                       ; 0xc3691 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3693
    mov si, 00087h                            ; be 87 00                    ; 0xc3696 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc3699
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc369b
    inc bx                                    ; 43                          ; 0xc369e vgabios.c:2383
    mov es, cx                                ; 8e c1                       ; 0xc369f vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc36a1
    mov si, 00088h                            ; be 88 00                    ; 0xc36a4 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc36a7
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc36a9
    inc bx                                    ; 43                          ; 0xc36ac vgabios.c:2384
    mov es, cx                                ; 8e c1                       ; 0xc36ad vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc36af
    mov si, 00089h                            ; be 89 00                    ; 0xc36b2 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc36b5
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc36b7
    inc bx                                    ; 43                          ; 0xc36ba vgabios.c:2385
    mov es, cx                                ; 8e c1                       ; 0xc36bb vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36bd
    mov si, strict word 00060h                ; be 60 00                    ; 0xc36c0 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc36c3
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc36c5
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc36c8 vgabios.c:2387
    inc bx                                    ; 43                          ; 0xc36cd vgabios.c:2386
    inc bx                                    ; 43                          ; 0xc36ce
    jmp short 036d7h                          ; eb 06                       ; 0xc36cf
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc36d1
    jnc short 036f3h                          ; 73 1c                       ; 0xc36d5
    mov es, cx                                ; 8e c1                       ; 0xc36d7 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36d9
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc36dc vgabios.c:58
    add si, si                                ; 01 f6                       ; 0xc36df
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc36e1
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc36e4 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc36e7
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc36e9
    inc bx                                    ; 43                          ; 0xc36ec vgabios.c:2389
    inc bx                                    ; 43                          ; 0xc36ed
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc36ee vgabios.c:2390
    jmp short 036d1h                          ; eb de                       ; 0xc36f1
    mov es, cx                                ; 8e c1                       ; 0xc36f3 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36f5
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc36f8 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc36fb
    mov es, dx                                ; 8e c2                       ; 0xc36fe
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3700
    inc bx                                    ; 43                          ; 0xc3703 vgabios.c:2391
    inc bx                                    ; 43                          ; 0xc3704
    mov es, cx                                ; 8e c1                       ; 0xc3705 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3707
    mov si, strict word 00062h                ; be 62 00                    ; 0xc370a vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc370d
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc370f
    inc bx                                    ; 43                          ; 0xc3712 vgabios.c:2392
    mov es, cx                                ; 8e c1                       ; 0xc3713 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3715
    mov si, strict word 0007ch                ; be 7c 00                    ; 0xc3718 vgabios.c:62
    xor dx, dx                                ; 31 d2                       ; 0xc371b
    mov es, dx                                ; 8e c2                       ; 0xc371d
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc371f
    inc bx                                    ; 43                          ; 0xc3722 vgabios.c:2394
    inc bx                                    ; 43                          ; 0xc3723
    mov es, cx                                ; 8e c1                       ; 0xc3724 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3726
    mov si, strict word 0007eh                ; be 7e 00                    ; 0xc3729 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc372c
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc372e
    inc bx                                    ; 43                          ; 0xc3731 vgabios.c:2395
    inc bx                                    ; 43                          ; 0xc3732
    mov es, cx                                ; 8e c1                       ; 0xc3733 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3735
    mov si, 0010ch                            ; be 0c 01                    ; 0xc3738 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc373b
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc373d
    inc bx                                    ; 43                          ; 0xc3740 vgabios.c:2396
    inc bx                                    ; 43                          ; 0xc3741
    mov es, cx                                ; 8e c1                       ; 0xc3742 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3744
    mov si, 0010eh                            ; be 0e 01                    ; 0xc3747 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc374a
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc374c
    inc bx                                    ; 43                          ; 0xc374f vgabios.c:2397
    inc bx                                    ; 43                          ; 0xc3750
    test byte [bp-010h], 004h                 ; f6 46 f0 04                 ; 0xc3751 vgabios.c:2399
    je short 03794h                           ; 74 3d                       ; 0xc3755
    inc bx                                    ; 43                          ; 0xc3757 vgabios.c:2400
    mov es, cx                                ; 8e c1                       ; 0xc3758 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc375a
    xor ah, ah                                ; 30 e4                       ; 0xc375d vgabios.c:48
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc375f
    inc bx                                    ; 43                          ; 0xc3762 vgabios.c:2401
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3763 vgabios.c:47
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc3766 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3769
    inc bx                                    ; 43                          ; 0xc376a vgabios.c:2402
    xor al, al                                ; 30 c0                       ; 0xc376b
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc376d
    out DX, AL                                ; ee                          ; 0xc3770
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3771 vgabios.c:2405
    jmp short 0377dh                          ; eb 07                       ; 0xc3774
    cmp word [bp-008h], 00300h                ; 81 7e f8 00 03              ; 0xc3776
    jnc short 0378ch                          ; 73 0f                       ; 0xc377b
    mov es, cx                                ; 8e c1                       ; 0xc377d vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc377f
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc3782 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3785
    inc bx                                    ; 43                          ; 0xc3786 vgabios.c:2406
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3787 vgabios.c:2407
    jmp short 03776h                          ; eb ea                       ; 0xc378a
    inc bx                                    ; 43                          ; 0xc378c vgabios.c:2408
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc378d
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc3790
    out DX, AL                                ; ee                          ; 0xc3793
    mov ax, bx                                ; 89 d8                       ; 0xc3794 vgabios.c:2412
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3796
    pop di                                    ; 5f                          ; 0xc3799
    pop si                                    ; 5e                          ; 0xc379a
    pop cx                                    ; 59                          ; 0xc379b
    pop bp                                    ; 5d                          ; 0xc379c
    retn                                      ; c3                          ; 0xc379d
  ; disGetNextSymbol 0xc379e LB 0xd23 -> off=0x0 cb=0000000000000028 uValue=00000000000c379e 'find_vga_entry'
find_vga_entry:                              ; 0xc379e LB 0x28
    push bx                                   ; 53                          ; 0xc379e vgabios.c:2421
    push dx                                   ; 52                          ; 0xc379f
    push bp                                   ; 55                          ; 0xc37a0
    mov bp, sp                                ; 89 e5                       ; 0xc37a1
    mov dl, al                                ; 88 c2                       ; 0xc37a3
    mov AH, strict byte 0ffh                  ; b4 ff                       ; 0xc37a5 vgabios.c:2423
    xor al, al                                ; 30 c0                       ; 0xc37a7 vgabios.c:2424
    jmp short 037b1h                          ; eb 06                       ; 0xc37a9
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc37ab vgabios.c:2425
    cmp AL, strict byte 00fh                  ; 3c 0f                       ; 0xc37ad
    jnbe short 037c0h                         ; 77 0f                       ; 0xc37af
    mov bl, al                                ; 88 c3                       ; 0xc37b1
    xor bh, bh                                ; 30 ff                       ; 0xc37b3
    sal bx, 003h                              ; c1 e3 03                    ; 0xc37b5
    cmp dl, byte [bx+047ach]                  ; 3a 97 ac 47                 ; 0xc37b8
    jne short 037abh                          ; 75 ed                       ; 0xc37bc
    mov ah, al                                ; 88 c4                       ; 0xc37be
    mov al, ah                                ; 88 e0                       ; 0xc37c0 vgabios.c:2430
    pop bp                                    ; 5d                          ; 0xc37c2
    pop dx                                    ; 5a                          ; 0xc37c3
    pop bx                                    ; 5b                          ; 0xc37c4
    retn                                      ; c3                          ; 0xc37c5
  ; disGetNextSymbol 0xc37c6 LB 0xcfb -> off=0x0 cb=000000000000000e uValue=00000000000c37c6 'readx_byte'
readx_byte:                                  ; 0xc37c6 LB 0xe
    push bx                                   ; 53                          ; 0xc37c6 vgabios.c:2442
    push bp                                   ; 55                          ; 0xc37c7
    mov bp, sp                                ; 89 e5                       ; 0xc37c8
    mov bx, dx                                ; 89 d3                       ; 0xc37ca
    mov es, ax                                ; 8e c0                       ; 0xc37cc vgabios.c:2444
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc37ce
    pop bp                                    ; 5d                          ; 0xc37d1 vgabios.c:2445
    pop bx                                    ; 5b                          ; 0xc37d2
    retn                                      ; c3                          ; 0xc37d3
  ; disGetNextSymbol 0xc37d4 LB 0xced -> off=0x8a cb=000000000000049f uValue=00000000000c385e 'int10_func'
    db  056h, 04fh, 01ch, 01bh, 013h, 012h, 011h, 010h, 00eh, 00dh, 00ch, 00ah, 009h, 008h, 007h, 006h
    db  005h, 004h, 003h, 002h, 001h, 000h, 0f6h, 03ch, 087h, 038h, 0c4h, 038h, 0d9h, 038h, 0e9h, 038h
    db  0fch, 038h, 00ch, 039h, 016h, 039h, 058h, 039h, 08ch, 039h, 09dh, 039h, 0c3h, 039h, 0deh, 039h
    db  0fdh, 039h, 01ah, 03ah, 030h, 03ah, 03ch, 03ah, 035h, 03bh, 0b9h, 03bh, 0e6h, 03bh, 0fbh, 03bh
    db  03dh, 03ch, 0c8h, 03ch, 030h, 024h, 023h, 022h, 021h, 020h, 014h, 012h, 011h, 010h, 004h, 003h
    db  002h, 001h, 000h, 0f6h, 03ch, 05bh, 03ah, 079h, 03ah, 094h, 03ah, 0a9h, 03ah, 0b4h, 03ah, 05bh
    db  03ah, 079h, 03ah, 094h, 03ah, 0b4h, 03ah, 0c9h, 03ah, 0d4h, 03ah, 0efh, 03ah, 0feh, 03ah, 00dh
    db  03bh, 01ch, 03bh, 00ah, 009h, 006h, 004h, 002h, 001h, 000h, 0bah, 03ch, 063h, 03ch, 071h, 03ch
    db  082h, 03ch, 092h, 03ch, 0a7h, 03ch, 0bah, 03ch, 0bah, 03ch
int10_func:                                  ; 0xc385e LB 0x49f
    push bp                                   ; 55                          ; 0xc385e vgabios.c:2523
    mov bp, sp                                ; 89 e5                       ; 0xc385f
    push si                                   ; 56                          ; 0xc3861
    push di                                   ; 57                          ; 0xc3862
    push ax                                   ; 50                          ; 0xc3863
    mov si, word [bp+004h]                    ; 8b 76 04                    ; 0xc3864
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3867 vgabios.c:2528
    shr ax, 008h                              ; c1 e8 08                    ; 0xc386a
    cmp ax, strict word 00056h                ; 3d 56 00                    ; 0xc386d
    jnbe short 038d6h                         ; 77 64                       ; 0xc3870
    push CS                                   ; 0e                          ; 0xc3872
    pop ES                                    ; 07                          ; 0xc3873
    mov cx, strict word 00017h                ; b9 17 00                    ; 0xc3874
    mov di, 037d4h                            ; bf d4 37                    ; 0xc3877
    repne scasb                               ; f2 ae                       ; 0xc387a
    sal cx, 1                                 ; d1 e1                       ; 0xc387c
    mov di, cx                                ; 89 cf                       ; 0xc387e
    mov ax, word [cs:di+037eah]               ; 2e 8b 85 ea 37              ; 0xc3880
    jmp ax                                    ; ff e0                       ; 0xc3885
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3887 vgabios.c:2531
    xor ah, ah                                ; 30 e4                       ; 0xc388a
    call 013d6h                               ; e8 47 db                    ; 0xc388c
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc388f vgabios.c:2532
    and ax, strict word 0007fh                ; 25 7f 00                    ; 0xc3892
    cmp ax, strict word 00007h                ; 3d 07 00                    ; 0xc3895
    je short 038afh                           ; 74 15                       ; 0xc3898
    cmp ax, strict word 00006h                ; 3d 06 00                    ; 0xc389a
    je short 038a6h                           ; 74 07                       ; 0xc389d
    cmp ax, strict word 00005h                ; 3d 05 00                    ; 0xc389f
    jbe short 038afh                          ; 76 0b                       ; 0xc38a2
    jmp short 038b8h                          ; eb 12                       ; 0xc38a4
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc38a6 vgabios.c:2534
    xor al, al                                ; 30 c0                       ; 0xc38a9
    or AL, strict byte 03fh                   ; 0c 3f                       ; 0xc38ab
    jmp short 038bfh                          ; eb 10                       ; 0xc38ad vgabios.c:2535
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc38af vgabios.c:2543
    xor al, al                                ; 30 c0                       ; 0xc38b2
    or AL, strict byte 030h                   ; 0c 30                       ; 0xc38b4
    jmp short 038bfh                          ; eb 07                       ; 0xc38b6
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc38b8 vgabios.c:2546
    xor al, al                                ; 30 c0                       ; 0xc38bb
    or AL, strict byte 020h                   ; 0c 20                       ; 0xc38bd
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc38bf
    jmp short 038d6h                          ; eb 12                       ; 0xc38c2 vgabios.c:2548
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc38c4 vgabios.c:2550
    xor ah, ah                                ; 30 e4                       ; 0xc38c7
    mov dx, ax                                ; 89 c2                       ; 0xc38c9
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc38cb
    shr ax, 008h                              ; c1 e8 08                    ; 0xc38ce
    xor ah, ah                                ; 30 e4                       ; 0xc38d1
    call 01171h                               ; e8 9b d8                    ; 0xc38d3
    jmp near 03cf6h                           ; e9 1d 04                    ; 0xc38d6 vgabios.c:2551
    mov dx, word [bp+00eh]                    ; 8b 56 0e                    ; 0xc38d9 vgabios.c:2553
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc38dc
    shr ax, 008h                              ; c1 e8 08                    ; 0xc38df
    xor ah, ah                                ; 30 e4                       ; 0xc38e2
    call 01278h                               ; e8 91 d9                    ; 0xc38e4
    jmp short 038d6h                          ; eb ed                       ; 0xc38e7 vgabios.c:2554
    lea bx, [bp+00eh]                         ; 8d 5e 0e                    ; 0xc38e9 vgabios.c:2556
    lea dx, [bp+010h]                         ; 8d 56 10                    ; 0xc38ec
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc38ef
    shr ax, 008h                              ; c1 e8 08                    ; 0xc38f2
    xor ah, ah                                ; 30 e4                       ; 0xc38f5
    call 00a96h                               ; e8 9c d1                    ; 0xc38f7
    jmp short 038d6h                          ; eb da                       ; 0xc38fa vgabios.c:2557
    xor ax, ax                                ; 31 c0                       ; 0xc38fc vgabios.c:2563
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc38fe
    mov word [bp+00ch], ax                    ; 89 46 0c                    ; 0xc3901 vgabios.c:2564
    mov word [bp+010h], ax                    ; 89 46 10                    ; 0xc3904 vgabios.c:2565
    mov word [bp+00eh], ax                    ; 89 46 0e                    ; 0xc3907 vgabios.c:2566
    jmp short 038d6h                          ; eb ca                       ; 0xc390a vgabios.c:2567
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc390c vgabios.c:2569
    xor ah, ah                                ; 30 e4                       ; 0xc390f
    call 012f0h                               ; e8 dc d9                    ; 0xc3911
    jmp short 038d6h                          ; eb c0                       ; 0xc3914 vgabios.c:2570
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc3916 vgabios.c:2572
    push ax                                   ; 50                          ; 0xc3919
    mov ax, 000ffh                            ; b8 ff 00                    ; 0xc391a
    push ax                                   ; 50                          ; 0xc391d
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc391e
    xor ah, ah                                ; 30 e4                       ; 0xc3921
    push ax                                   ; 50                          ; 0xc3923
    mov ax, word [bp+00eh]                    ; 8b 46 0e                    ; 0xc3924
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3927
    xor ah, ah                                ; 30 e4                       ; 0xc392a
    push ax                                   ; 50                          ; 0xc392c
    mov cl, byte [bp+010h]                    ; 8a 4e 10                    ; 0xc392d
    xor ch, ch                                ; 30 ed                       ; 0xc3930
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3932
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3935
    xor ah, ah                                ; 30 e4                       ; 0xc3938
    mov bx, ax                                ; 89 c3                       ; 0xc393a
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc393c
    shr ax, 008h                              ; c1 e8 08                    ; 0xc393f
    xor ah, ah                                ; 30 e4                       ; 0xc3942
    mov dx, ax                                ; 89 c2                       ; 0xc3944
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3946
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc3949
    mov byte [bp-005h], ch                    ; 88 6e fb                    ; 0xc394c
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc394f
    call 01bf1h                               ; e8 9c e2                    ; 0xc3952
    jmp near 03cf6h                           ; e9 9e 03                    ; 0xc3955 vgabios.c:2573
    xor ax, ax                                ; 31 c0                       ; 0xc3958 vgabios.c:2575
    push ax                                   ; 50                          ; 0xc395a
    mov ax, 000ffh                            ; b8 ff 00                    ; 0xc395b
    push ax                                   ; 50                          ; 0xc395e
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc395f
    xor ah, ah                                ; 30 e4                       ; 0xc3962
    push ax                                   ; 50                          ; 0xc3964
    mov ax, word [bp+00eh]                    ; 8b 46 0e                    ; 0xc3965
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3968
    xor ah, ah                                ; 30 e4                       ; 0xc396b
    push ax                                   ; 50                          ; 0xc396d
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc396e
    mov cx, ax                                ; 89 c1                       ; 0xc3971
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3973
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3976
    xor ah, ah                                ; 30 e4                       ; 0xc3979
    mov bx, ax                                ; 89 c3                       ; 0xc397b
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc397d
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3980
    xor ah, ah                                ; 30 e4                       ; 0xc3983
    mov dx, ax                                ; 89 c2                       ; 0xc3985
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3987
    jmp short 03952h                          ; eb c6                       ; 0xc398a
    lea dx, [bp+012h]                         ; 8d 56 12                    ; 0xc398c vgabios.c:2578
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc398f
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3992
    xor ah, ah                                ; 30 e4                       ; 0xc3995
    call 00dc4h                               ; e8 2a d4                    ; 0xc3997
    jmp near 03cf6h                           ; e9 59 03                    ; 0xc399a vgabios.c:2579
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc399d vgabios.c:2581
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc39a0
    xor ah, ah                                ; 30 e4                       ; 0xc39a3
    mov bx, ax                                ; 89 c3                       ; 0xc39a5
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc39a7
    shr ax, 008h                              ; c1 e8 08                    ; 0xc39aa
    xor ah, ah                                ; 30 e4                       ; 0xc39ad
    mov dx, ax                                ; 89 c2                       ; 0xc39af
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc39b1
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc39b4
    mov byte [bp-005h], bh                    ; 88 7e fb                    ; 0xc39b7
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc39ba
    call 02535h                               ; e8 75 eb                    ; 0xc39bd
    jmp near 03cf6h                           ; e9 33 03                    ; 0xc39c0 vgabios.c:2582
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc39c3 vgabios.c:2584
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc39c6
    xor ah, ah                                ; 30 e4                       ; 0xc39c9
    mov bx, ax                                ; 89 c3                       ; 0xc39cb
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc39cd
    shr dx, 008h                              ; c1 ea 08                    ; 0xc39d0
    xor dh, dh                                ; 30 f6                       ; 0xc39d3
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc39d5
    call 026abh                               ; e8 d0 ec                    ; 0xc39d8
    jmp near 03cf6h                           ; e9 18 03                    ; 0xc39db vgabios.c:2585
    mov cx, word [bp+00eh]                    ; 8b 4e 0e                    ; 0xc39de vgabios.c:2587
    mov bx, word [bp+010h]                    ; 8b 5e 10                    ; 0xc39e1
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc39e4
    xor ah, ah                                ; 30 e4                       ; 0xc39e7
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc39e9
    shr dx, 008h                              ; c1 ea 08                    ; 0xc39ec
    xor dh, dh                                ; 30 f6                       ; 0xc39ef
    mov si, dx                                ; 89 d6                       ; 0xc39f1
    mov dx, ax                                ; 89 c2                       ; 0xc39f3
    mov ax, si                                ; 89 f0                       ; 0xc39f5
    call 0281ch                               ; e8 22 ee                    ; 0xc39f7
    jmp near 03cf6h                           ; e9 f9 02                    ; 0xc39fa vgabios.c:2588
    lea cx, [bp+012h]                         ; 8d 4e 12                    ; 0xc39fd vgabios.c:2590
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3a00
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3a03
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3a06
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3a09
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc3a0c
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc3a0f
    xor ah, ah                                ; 30 e4                       ; 0xc3a12
    call 00f7eh                               ; e8 67 d5                    ; 0xc3a14
    jmp near 03cf6h                           ; e9 dc 02                    ; 0xc3a17 vgabios.c:2591
    mov cx, strict word 00002h                ; b9 02 00                    ; 0xc3a1a vgabios.c:2599
    mov bl, byte [bp+00ch]                    ; 8a 5e 0c                    ; 0xc3a1d
    xor bh, bh                                ; 30 ff                       ; 0xc3a20
    mov dx, 000ffh                            ; ba ff 00                    ; 0xc3a22
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a25
    xor ah, ah                                ; 30 e4                       ; 0xc3a28
    call 0298fh                               ; e8 62 ef                    ; 0xc3a2a
    jmp near 03cf6h                           ; e9 c6 02                    ; 0xc3a2d vgabios.c:2600
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3a30 vgabios.c:2603
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3a33
    call 010e4h                               ; e8 ab d6                    ; 0xc3a36
    jmp near 03cf6h                           ; e9 ba 02                    ; 0xc3a39 vgabios.c:2604
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3a3c vgabios.c:2606
    xor ah, ah                                ; 30 e4                       ; 0xc3a3f
    cmp ax, strict word 00030h                ; 3d 30 00                    ; 0xc3a41
    jnbe short 03ab1h                         ; 77 6b                       ; 0xc3a44
    push CS                                   ; 0e                          ; 0xc3a46
    pop ES                                    ; 07                          ; 0xc3a47
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc3a48
    mov di, 03818h                            ; bf 18 38                    ; 0xc3a4b
    repne scasb                               ; f2 ae                       ; 0xc3a4e
    sal cx, 1                                 ; d1 e1                       ; 0xc3a50
    mov di, cx                                ; 89 cf                       ; 0xc3a52
    mov ax, word [cs:di+03827h]               ; 2e 8b 85 27 38              ; 0xc3a54
    jmp ax                                    ; ff e0                       ; 0xc3a59
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3a5b vgabios.c:2610
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3a5e
    xor ah, ah                                ; 30 e4                       ; 0xc3a61
    push ax                                   ; 50                          ; 0xc3a63
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3a64
    push ax                                   ; 50                          ; 0xc3a67
    push word [bp+00eh]                       ; ff 76 0e                    ; 0xc3a68
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a6b
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc3a6e
    mov bx, word [bp+008h]                    ; 8b 5e 08                    ; 0xc3a71
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3a74
    jmp short 03a8fh                          ; eb 16                       ; 0xc3a77
    push strict byte 0000eh                   ; 6a 0e                       ; 0xc3a79 vgabios.c:2614
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3a7b
    xor ah, ah                                ; 30 e4                       ; 0xc3a7e
    push ax                                   ; 50                          ; 0xc3a80
    push strict byte 00000h                   ; 6a 00                       ; 0xc3a81
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a83
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3a86
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc3a89
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc3a8c
    call 02d9fh                               ; e8 0d f3                    ; 0xc3a8f
    jmp short 03ab1h                          ; eb 1d                       ; 0xc3a92
    push strict byte 00008h                   ; 6a 08                       ; 0xc3a94 vgabios.c:2618
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3a96
    xor ah, ah                                ; 30 e4                       ; 0xc3a99
    push ax                                   ; 50                          ; 0xc3a9b
    push strict byte 00000h                   ; 6a 00                       ; 0xc3a9c
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a9e
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3aa1
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc3aa4
    jmp short 03a8ch                          ; eb e3                       ; 0xc3aa7
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3aa9 vgabios.c:2621
    xor ah, ah                                ; 30 e4                       ; 0xc3aac
    call 02d07h                               ; e8 56 f2                    ; 0xc3aae
    jmp near 03cf6h                           ; e9 42 02                    ; 0xc3ab1 vgabios.c:2622
    push strict byte 00010h                   ; 6a 10                       ; 0xc3ab4 vgabios.c:2625
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3ab6
    xor ah, ah                                ; 30 e4                       ; 0xc3ab9
    push ax                                   ; 50                          ; 0xc3abb
    push strict byte 00000h                   ; 6a 00                       ; 0xc3abc
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3abe
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3ac1
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc3ac4
    jmp short 03a8ch                          ; eb c3                       ; 0xc3ac7
    mov dx, word [bp+008h]                    ; 8b 56 08                    ; 0xc3ac9 vgabios.c:2628
    mov ax, word [bp+016h]                    ; 8b 46 16                    ; 0xc3acc
    call 02e1eh                               ; e8 4c f3                    ; 0xc3acf
    jmp short 03ab1h                          ; eb dd                       ; 0xc3ad2 vgabios.c:2629
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3ad4 vgabios.c:2631
    xor ah, ah                                ; 30 e4                       ; 0xc3ad7
    push ax                                   ; 50                          ; 0xc3ad9
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3ada
    mov bx, word [bp+010h]                    ; 8b 5e 10                    ; 0xc3add
    mov dx, word [bp+008h]                    ; 8b 56 08                    ; 0xc3ae0
    mov si, word [bp+016h]                    ; 8b 76 16                    ; 0xc3ae3
    mov cx, ax                                ; 89 c1                       ; 0xc3ae6
    mov ax, si                                ; 89 f0                       ; 0xc3ae8
    call 02e81h                               ; e8 94 f3                    ; 0xc3aea
    jmp short 03ab1h                          ; eb c2                       ; 0xc3aed vgabios.c:2632
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3aef vgabios.c:2634
    xor ah, ah                                ; 30 e4                       ; 0xc3af2
    mov dx, ax                                ; 89 c2                       ; 0xc3af4
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3af6
    call 02e9eh                               ; e8 a2 f3                    ; 0xc3af9
    jmp short 03ab1h                          ; eb b3                       ; 0xc3afc vgabios.c:2635
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3afe vgabios.c:2637
    xor ah, ah                                ; 30 e4                       ; 0xc3b01
    mov dx, ax                                ; 89 c2                       ; 0xc3b03
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3b05
    call 02ec0h                               ; e8 b5 f3                    ; 0xc3b08
    jmp short 03ab1h                          ; eb a4                       ; 0xc3b0b vgabios.c:2638
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3b0d vgabios.c:2640
    xor ah, ah                                ; 30 e4                       ; 0xc3b10
    mov dx, ax                                ; 89 c2                       ; 0xc3b12
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3b14
    call 02ee2h                               ; e8 c8 f3                    ; 0xc3b17
    jmp short 03ab1h                          ; eb 95                       ; 0xc3b1a vgabios.c:2641
    lea ax, [bp+00eh]                         ; 8d 46 0e                    ; 0xc3b1c vgabios.c:2643
    push ax                                   ; 50                          ; 0xc3b1f
    lea cx, [bp+010h]                         ; 8d 4e 10                    ; 0xc3b20
    lea bx, [bp+008h]                         ; 8d 5e 08                    ; 0xc3b23
    lea dx, [bp+016h]                         ; 8d 56 16                    ; 0xc3b26
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3b29
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3b2c
    call 00efbh                               ; e8 c9 d3                    ; 0xc3b2f
    jmp near 03cf6h                           ; e9 c1 01                    ; 0xc3b32 vgabios.c:2651
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3b35 vgabios.c:2653
    xor ah, ah                                ; 30 e4                       ; 0xc3b38
    cmp ax, strict word 00034h                ; 3d 34 00                    ; 0xc3b3a
    jc short 03b4eh                           ; 72 0f                       ; 0xc3b3d
    jbe short 03b79h                          ; 76 38                       ; 0xc3b3f
    cmp ax, strict word 00036h                ; 3d 36 00                    ; 0xc3b41
    je short 03ba1h                           ; 74 5b                       ; 0xc3b44
    cmp ax, strict word 00035h                ; 3d 35 00                    ; 0xc3b46
    je short 03ba3h                           ; 74 58                       ; 0xc3b49
    jmp near 03cf6h                           ; e9 a8 01                    ; 0xc3b4b
    cmp ax, strict word 00030h                ; 3d 30 00                    ; 0xc3b4e
    je short 03b5dh                           ; 74 0a                       ; 0xc3b51
    cmp ax, strict word 00020h                ; 3d 20 00                    ; 0xc3b53
    jne short 03b9eh                          ; 75 46                       ; 0xc3b56
    call 02f04h                               ; e8 a9 f3                    ; 0xc3b58 vgabios.c:2656
    jmp short 03b9eh                          ; eb 41                       ; 0xc3b5b vgabios.c:2657
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3b5d vgabios.c:2659
    xor ah, ah                                ; 30 e4                       ; 0xc3b60
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3b62
    jnbe short 03b9eh                         ; 77 37                       ; 0xc3b65
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3b67 vgabios.c:2660
    call 02f09h                               ; e8 9c f3                    ; 0xc3b6a
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3b6d vgabios.c:2661
    xor al, al                                ; 30 c0                       ; 0xc3b70
    or AL, strict byte 012h                   ; 0c 12                       ; 0xc3b72
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc3b74
    jmp short 03b9eh                          ; eb 25                       ; 0xc3b77 vgabios.c:2663
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3b79 vgabios.c:2665
    xor ah, ah                                ; 30 e4                       ; 0xc3b7c
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3b7e
    jnc short 03b9bh                          ; 73 18                       ; 0xc3b81
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3b83 vgabios.c:45
    mov es, ax                                ; 8e c0                       ; 0xc3b86
    mov si, 00087h                            ; be 87 00                    ; 0xc3b88
    mov ah, byte [es:si]                      ; 26 8a 24                    ; 0xc3b8b vgabios.c:47
    and ah, 0feh                              ; 80 e4 fe                    ; 0xc3b8e vgabios.c:48
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3b91
    or al, ah                                 ; 08 e0                       ; 0xc3b94
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3b96 vgabios.c:52
    jmp short 03b6dh                          ; eb d2                       ; 0xc3b99
    mov byte [bp+012h], ah                    ; 88 66 12                    ; 0xc3b9b vgabios.c:2671
    jmp near 03cf6h                           ; e9 55 01                    ; 0xc3b9e vgabios.c:2672
    jmp short 03bb1h                          ; eb 0e                       ; 0xc3ba1
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3ba3 vgabios.c:2674
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3ba6
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3ba9
    call 02f3bh                               ; e8 8c f3                    ; 0xc3bac
    jmp short 03b6dh                          ; eb bc                       ; 0xc3baf
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3bb1 vgabios.c:2678
    call 02f40h                               ; e8 89 f3                    ; 0xc3bb4
    jmp short 03b6dh                          ; eb b4                       ; 0xc3bb7
    push word [bp+008h]                       ; ff 76 08                    ; 0xc3bb9 vgabios.c:2688
    push word [bp+016h]                       ; ff 76 16                    ; 0xc3bbc
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3bbf
    xor ah, ah                                ; 30 e4                       ; 0xc3bc2
    push ax                                   ; 50                          ; 0xc3bc4
    mov ax, word [bp+00eh]                    ; 8b 46 0e                    ; 0xc3bc5
    shr ax, 008h                              ; c1 e8 08                    ; 0xc3bc8
    xor ah, ah                                ; 30 e4                       ; 0xc3bcb
    push ax                                   ; 50                          ; 0xc3bcd
    mov bl, byte [bp+00ch]                    ; 8a 5e 0c                    ; 0xc3bce
    xor bh, bh                                ; 30 ff                       ; 0xc3bd1
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc3bd3
    shr dx, 008h                              ; c1 ea 08                    ; 0xc3bd6
    xor dh, dh                                ; 30 f6                       ; 0xc3bd9
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3bdb
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc3bde
    call 02f45h                               ; e8 61 f3                    ; 0xc3be1
    jmp short 03b9eh                          ; eb b8                       ; 0xc3be4 vgabios.c:2689
    mov bx, si                                ; 89 f3                       ; 0xc3be6 vgabios.c:2691
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3be8
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3beb
    call 02fe2h                               ; e8 f1 f3                    ; 0xc3bee
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3bf1 vgabios.c:2692
    xor al, al                                ; 30 c0                       ; 0xc3bf4
    or AL, strict byte 01bh                   ; 0c 1b                       ; 0xc3bf6
    jmp near 03b74h                           ; e9 79 ff                    ; 0xc3bf8
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3bfb vgabios.c:2695
    xor ah, ah                                ; 30 e4                       ; 0xc3bfe
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3c00
    je short 03c27h                           ; 74 22                       ; 0xc3c03
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc3c05
    je short 03c19h                           ; 74 0f                       ; 0xc3c08
    test ax, ax                               ; 85 c0                       ; 0xc3c0a
    jne short 03c33h                          ; 75 25                       ; 0xc3c0c
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3c0e vgabios.c:2698
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3c11
    call 031f4h                               ; e8 dd f5                    ; 0xc3c14
    jmp short 03c33h                          ; eb 1a                       ; 0xc3c17 vgabios.c:2699
    mov bx, word [bp+00ch]                    ; 8b 5e 0c                    ; 0xc3c19 vgabios.c:2701
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c1c
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3c1f
    call 0320ch                               ; e8 e7 f5                    ; 0xc3c22
    jmp short 03c33h                          ; eb 0c                       ; 0xc3c25 vgabios.c:2702
    mov bx, word [bp+00ch]                    ; 8b 5e 0c                    ; 0xc3c27 vgabios.c:2704
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c2a
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3c2d
    call 034e4h                               ; e8 b1 f8                    ; 0xc3c30
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3c33 vgabios.c:2711
    xor al, al                                ; 30 c0                       ; 0xc3c36
    or AL, strict byte 01ch                   ; 0c 1c                       ; 0xc3c38
    jmp near 03b74h                           ; e9 37 ff                    ; 0xc3c3a
    call 007c8h                               ; e8 88 cb                    ; 0xc3c3d vgabios.c:2716
    test ax, ax                               ; 85 c0                       ; 0xc3c40
    je short 03cb8h                           ; 74 74                       ; 0xc3c42
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3c44 vgabios.c:2717
    xor ah, ah                                ; 30 e4                       ; 0xc3c47
    cmp ax, strict word 0000ah                ; 3d 0a 00                    ; 0xc3c49
    jnbe short 03cbah                         ; 77 6c                       ; 0xc3c4c
    push CS                                   ; 0e                          ; 0xc3c4e
    pop ES                                    ; 07                          ; 0xc3c4f
    mov cx, strict word 00008h                ; b9 08 00                    ; 0xc3c50
    mov di, 03847h                            ; bf 47 38                    ; 0xc3c53
    repne scasb                               ; f2 ae                       ; 0xc3c56
    sal cx, 1                                 ; d1 e1                       ; 0xc3c58
    mov di, cx                                ; 89 cf                       ; 0xc3c5a
    mov ax, word [cs:di+0384eh]               ; 2e 8b 85 4e 38              ; 0xc3c5c
    jmp ax                                    ; ff e0                       ; 0xc3c61
    mov bx, si                                ; 89 f3                       ; 0xc3c63 vgabios.c:2720
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c65
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3c68
    call 03ec7h                               ; e8 59 02                    ; 0xc3c6b
    jmp near 03cf6h                           ; e9 85 00                    ; 0xc3c6e vgabios.c:2721
    mov cx, si                                ; 89 f1                       ; 0xc3c71 vgabios.c:2723
    mov bx, word [bp+016h]                    ; 8b 5e 16                    ; 0xc3c73
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3c76
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3c79
    call 03ff2h                               ; e8 73 03                    ; 0xc3c7c
    jmp near 03cf6h                           ; e9 74 00                    ; 0xc3c7f vgabios.c:2724
    mov cx, si                                ; 89 f1                       ; 0xc3c82 vgabios.c:2726
    mov bx, word [bp+016h]                    ; 8b 5e 16                    ; 0xc3c84
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc3c87
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3c8a
    call 04091h                               ; e8 01 04                    ; 0xc3c8d
    jmp short 03cf6h                          ; eb 64                       ; 0xc3c90 vgabios.c:2727
    lea ax, [bp+00ch]                         ; 8d 46 0c                    ; 0xc3c92 vgabios.c:2729
    push ax                                   ; 50                          ; 0xc3c95
    mov cx, word [bp+016h]                    ; 8b 4e 16                    ; 0xc3c96
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3c99
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3c9c
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3c9f
    call 04264h                               ; e8 bf 05                    ; 0xc3ca2
    jmp short 03cf6h                          ; eb 4f                       ; 0xc3ca5 vgabios.c:2730
    lea cx, [bp+00eh]                         ; 8d 4e 0e                    ; 0xc3ca7 vgabios.c:2732
    lea bx, [bp+010h]                         ; 8d 5e 10                    ; 0xc3caa
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3cad
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3cb0
    call 042f0h                               ; e8 3a 06                    ; 0xc3cb3
    jmp short 03cf6h                          ; eb 3e                       ; 0xc3cb6 vgabios.c:2733
    jmp short 03cc1h                          ; eb 07                       ; 0xc3cb8
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3cba vgabios.c:2755
    jmp short 03cf6h                          ; eb 35                       ; 0xc3cbf vgabios.c:2758
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3cc1 vgabios.c:2760
    jmp short 03cf6h                          ; eb 2e                       ; 0xc3cc6 vgabios.c:2762
    call 007c8h                               ; e8 fd ca                    ; 0xc3cc8 vgabios.c:2764
    test ax, ax                               ; 85 c0                       ; 0xc3ccb
    je short 03cf1h                           ; 74 22                       ; 0xc3ccd
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3ccf vgabios.c:2765
    xor ah, ah                                ; 30 e4                       ; 0xc3cd2
    cmp ax, strict word 00042h                ; 3d 42 00                    ; 0xc3cd4
    jne short 03ceah                          ; 75 11                       ; 0xc3cd7
    lea cx, [bp+00eh]                         ; 8d 4e 0e                    ; 0xc3cd9 vgabios.c:2768
    lea bx, [bp+010h]                         ; 8d 5e 10                    ; 0xc3cdc
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3cdf
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3ce2
    call 043cfh                               ; e8 e7 06                    ; 0xc3ce5
    jmp short 03cf6h                          ; eb 0c                       ; 0xc3ce8 vgabios.c:2769
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3cea vgabios.c:2771
    jmp short 03cf6h                          ; eb 05                       ; 0xc3cef vgabios.c:2774
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3cf1 vgabios.c:2776
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3cf6 vgabios.c:2786
    pop di                                    ; 5f                          ; 0xc3cf9
    pop si                                    ; 5e                          ; 0xc3cfa
    pop bp                                    ; 5d                          ; 0xc3cfb
    retn                                      ; c3                          ; 0xc3cfc
  ; disGetNextSymbol 0xc3cfd LB 0x7c4 -> off=0x0 cb=000000000000001f uValue=00000000000c3cfd 'dispi_set_xres'
dispi_set_xres:                              ; 0xc3cfd LB 0x1f
    push bp                                   ; 55                          ; 0xc3cfd vbe.c:100
    mov bp, sp                                ; 89 e5                       ; 0xc3cfe
    push bx                                   ; 53                          ; 0xc3d00
    push dx                                   ; 52                          ; 0xc3d01
    mov bx, ax                                ; 89 c3                       ; 0xc3d02
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc3d04 vbe.c:105
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d07
    call 00570h                               ; e8 63 c8                    ; 0xc3d0a
    mov ax, bx                                ; 89 d8                       ; 0xc3d0d vbe.c:106
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d0f
    call 00570h                               ; e8 5b c8                    ; 0xc3d12
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d15 vbe.c:107
    pop dx                                    ; 5a                          ; 0xc3d18
    pop bx                                    ; 5b                          ; 0xc3d19
    pop bp                                    ; 5d                          ; 0xc3d1a
    retn                                      ; c3                          ; 0xc3d1b
  ; disGetNextSymbol 0xc3d1c LB 0x7a5 -> off=0x0 cb=000000000000001f uValue=00000000000c3d1c 'dispi_set_yres'
dispi_set_yres:                              ; 0xc3d1c LB 0x1f
    push bp                                   ; 55                          ; 0xc3d1c vbe.c:109
    mov bp, sp                                ; 89 e5                       ; 0xc3d1d
    push bx                                   ; 53                          ; 0xc3d1f
    push dx                                   ; 52                          ; 0xc3d20
    mov bx, ax                                ; 89 c3                       ; 0xc3d21
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3d23 vbe.c:114
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d26
    call 00570h                               ; e8 44 c8                    ; 0xc3d29
    mov ax, bx                                ; 89 d8                       ; 0xc3d2c vbe.c:115
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d2e
    call 00570h                               ; e8 3c c8                    ; 0xc3d31
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d34 vbe.c:116
    pop dx                                    ; 5a                          ; 0xc3d37
    pop bx                                    ; 5b                          ; 0xc3d38
    pop bp                                    ; 5d                          ; 0xc3d39
    retn                                      ; c3                          ; 0xc3d3a
  ; disGetNextSymbol 0xc3d3b LB 0x786 -> off=0x0 cb=0000000000000019 uValue=00000000000c3d3b 'dispi_get_yres'
dispi_get_yres:                              ; 0xc3d3b LB 0x19
    push bp                                   ; 55                          ; 0xc3d3b vbe.c:118
    mov bp, sp                                ; 89 e5                       ; 0xc3d3c
    push dx                                   ; 52                          ; 0xc3d3e
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3d3f vbe.c:120
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d42
    call 00570h                               ; e8 28 c8                    ; 0xc3d45
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d48 vbe.c:121
    call 00577h                               ; e8 29 c8                    ; 0xc3d4b
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3d4e vbe.c:122
    pop dx                                    ; 5a                          ; 0xc3d51
    pop bp                                    ; 5d                          ; 0xc3d52
    retn                                      ; c3                          ; 0xc3d53
  ; disGetNextSymbol 0xc3d54 LB 0x76d -> off=0x0 cb=000000000000001f uValue=00000000000c3d54 'dispi_set_bpp'
dispi_set_bpp:                               ; 0xc3d54 LB 0x1f
    push bp                                   ; 55                          ; 0xc3d54 vbe.c:124
    mov bp, sp                                ; 89 e5                       ; 0xc3d55
    push bx                                   ; 53                          ; 0xc3d57
    push dx                                   ; 52                          ; 0xc3d58
    mov bx, ax                                ; 89 c3                       ; 0xc3d59
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3d5b vbe.c:129
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d5e
    call 00570h                               ; e8 0c c8                    ; 0xc3d61
    mov ax, bx                                ; 89 d8                       ; 0xc3d64 vbe.c:130
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d66
    call 00570h                               ; e8 04 c8                    ; 0xc3d69
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d6c vbe.c:131
    pop dx                                    ; 5a                          ; 0xc3d6f
    pop bx                                    ; 5b                          ; 0xc3d70
    pop bp                                    ; 5d                          ; 0xc3d71
    retn                                      ; c3                          ; 0xc3d72
  ; disGetNextSymbol 0xc3d73 LB 0x74e -> off=0x0 cb=0000000000000019 uValue=00000000000c3d73 'dispi_get_bpp'
dispi_get_bpp:                               ; 0xc3d73 LB 0x19
    push bp                                   ; 55                          ; 0xc3d73 vbe.c:133
    mov bp, sp                                ; 89 e5                       ; 0xc3d74
    push dx                                   ; 52                          ; 0xc3d76
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3d77 vbe.c:135
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d7a
    call 00570h                               ; e8 f0 c7                    ; 0xc3d7d
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d80 vbe.c:136
    call 00577h                               ; e8 f1 c7                    ; 0xc3d83
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3d86 vbe.c:137
    pop dx                                    ; 5a                          ; 0xc3d89
    pop bp                                    ; 5d                          ; 0xc3d8a
    retn                                      ; c3                          ; 0xc3d8b
  ; disGetNextSymbol 0xc3d8c LB 0x735 -> off=0x0 cb=000000000000001f uValue=00000000000c3d8c 'dispi_set_virt_width'
dispi_set_virt_width:                        ; 0xc3d8c LB 0x1f
    push bp                                   ; 55                          ; 0xc3d8c vbe.c:139
    mov bp, sp                                ; 89 e5                       ; 0xc3d8d
    push bx                                   ; 53                          ; 0xc3d8f
    push dx                                   ; 52                          ; 0xc3d90
    mov bx, ax                                ; 89 c3                       ; 0xc3d91
    mov ax, strict word 00006h                ; b8 06 00                    ; 0xc3d93 vbe.c:144
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d96
    call 00570h                               ; e8 d4 c7                    ; 0xc3d99
    mov ax, bx                                ; 89 d8                       ; 0xc3d9c vbe.c:145
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d9e
    call 00570h                               ; e8 cc c7                    ; 0xc3da1
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3da4 vbe.c:146
    pop dx                                    ; 5a                          ; 0xc3da7
    pop bx                                    ; 5b                          ; 0xc3da8
    pop bp                                    ; 5d                          ; 0xc3da9
    retn                                      ; c3                          ; 0xc3daa
  ; disGetNextSymbol 0xc3dab LB 0x716 -> off=0x0 cb=0000000000000019 uValue=00000000000c3dab 'dispi_get_virt_width'
dispi_get_virt_width:                        ; 0xc3dab LB 0x19
    push bp                                   ; 55                          ; 0xc3dab vbe.c:148
    mov bp, sp                                ; 89 e5                       ; 0xc3dac
    push dx                                   ; 52                          ; 0xc3dae
    mov ax, strict word 00006h                ; b8 06 00                    ; 0xc3daf vbe.c:150
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3db2
    call 00570h                               ; e8 b8 c7                    ; 0xc3db5
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3db8 vbe.c:151
    call 00577h                               ; e8 b9 c7                    ; 0xc3dbb
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3dbe vbe.c:152
    pop dx                                    ; 5a                          ; 0xc3dc1
    pop bp                                    ; 5d                          ; 0xc3dc2
    retn                                      ; c3                          ; 0xc3dc3
  ; disGetNextSymbol 0xc3dc4 LB 0x6fd -> off=0x0 cb=0000000000000019 uValue=00000000000c3dc4 'dispi_get_virt_height'
dispi_get_virt_height:                       ; 0xc3dc4 LB 0x19
    push bp                                   ; 55                          ; 0xc3dc4 vbe.c:154
    mov bp, sp                                ; 89 e5                       ; 0xc3dc5
    push dx                                   ; 52                          ; 0xc3dc7
    mov ax, strict word 00007h                ; b8 07 00                    ; 0xc3dc8 vbe.c:156
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3dcb
    call 00570h                               ; e8 9f c7                    ; 0xc3dce
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3dd1 vbe.c:157
    call 00577h                               ; e8 a0 c7                    ; 0xc3dd4
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3dd7 vbe.c:158
    pop dx                                    ; 5a                          ; 0xc3dda
    pop bp                                    ; 5d                          ; 0xc3ddb
    retn                                      ; c3                          ; 0xc3ddc
  ; disGetNextSymbol 0xc3ddd LB 0x6e4 -> off=0x0 cb=0000000000000012 uValue=00000000000c3ddd 'in_word'
in_word:                                     ; 0xc3ddd LB 0x12
    push bp                                   ; 55                          ; 0xc3ddd vbe.c:160
    mov bp, sp                                ; 89 e5                       ; 0xc3dde
    push bx                                   ; 53                          ; 0xc3de0
    mov bx, ax                                ; 89 c3                       ; 0xc3de1
    mov ax, dx                                ; 89 d0                       ; 0xc3de3
    mov dx, bx                                ; 89 da                       ; 0xc3de5 vbe.c:162
    out DX, ax                                ; ef                          ; 0xc3de7
    in ax, DX                                 ; ed                          ; 0xc3de8 vbe.c:163
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3de9 vbe.c:164
    pop bx                                    ; 5b                          ; 0xc3dec
    pop bp                                    ; 5d                          ; 0xc3ded
    retn                                      ; c3                          ; 0xc3dee
  ; disGetNextSymbol 0xc3def LB 0x6d2 -> off=0x0 cb=0000000000000014 uValue=00000000000c3def 'in_byte'
in_byte:                                     ; 0xc3def LB 0x14
    push bp                                   ; 55                          ; 0xc3def vbe.c:166
    mov bp, sp                                ; 89 e5                       ; 0xc3df0
    push bx                                   ; 53                          ; 0xc3df2
    mov bx, ax                                ; 89 c3                       ; 0xc3df3
    mov ax, dx                                ; 89 d0                       ; 0xc3df5
    mov dx, bx                                ; 89 da                       ; 0xc3df7 vbe.c:168
    out DX, ax                                ; ef                          ; 0xc3df9
    in AL, DX                                 ; ec                          ; 0xc3dfa vbe.c:169
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3dfb
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3dfd vbe.c:170
    pop bx                                    ; 5b                          ; 0xc3e00
    pop bp                                    ; 5d                          ; 0xc3e01
    retn                                      ; c3                          ; 0xc3e02
  ; disGetNextSymbol 0xc3e03 LB 0x6be -> off=0x0 cb=0000000000000014 uValue=00000000000c3e03 'dispi_get_id'
dispi_get_id:                                ; 0xc3e03 LB 0x14
    push bp                                   ; 55                          ; 0xc3e03 vbe.c:173
    mov bp, sp                                ; 89 e5                       ; 0xc3e04
    push dx                                   ; 52                          ; 0xc3e06
    xor ax, ax                                ; 31 c0                       ; 0xc3e07 vbe.c:175
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3e09
    out DX, ax                                ; ef                          ; 0xc3e0c
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3e0d vbe.c:176
    in ax, DX                                 ; ed                          ; 0xc3e10
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3e11 vbe.c:177
    pop dx                                    ; 5a                          ; 0xc3e14
    pop bp                                    ; 5d                          ; 0xc3e15
    retn                                      ; c3                          ; 0xc3e16
  ; disGetNextSymbol 0xc3e17 LB 0x6aa -> off=0x0 cb=000000000000001a uValue=00000000000c3e17 'dispi_set_id'
dispi_set_id:                                ; 0xc3e17 LB 0x1a
    push bp                                   ; 55                          ; 0xc3e17 vbe.c:179
    mov bp, sp                                ; 89 e5                       ; 0xc3e18
    push bx                                   ; 53                          ; 0xc3e1a
    push dx                                   ; 52                          ; 0xc3e1b
    mov bx, ax                                ; 89 c3                       ; 0xc3e1c
    xor ax, ax                                ; 31 c0                       ; 0xc3e1e vbe.c:181
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3e20
    out DX, ax                                ; ef                          ; 0xc3e23
    mov ax, bx                                ; 89 d8                       ; 0xc3e24 vbe.c:182
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3e26
    out DX, ax                                ; ef                          ; 0xc3e29
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3e2a vbe.c:183
    pop dx                                    ; 5a                          ; 0xc3e2d
    pop bx                                    ; 5b                          ; 0xc3e2e
    pop bp                                    ; 5d                          ; 0xc3e2f
    retn                                      ; c3                          ; 0xc3e30
  ; disGetNextSymbol 0xc3e31 LB 0x690 -> off=0x0 cb=000000000000002a uValue=00000000000c3e31 'vbe_init'
vbe_init:                                    ; 0xc3e31 LB 0x2a
    push bp                                   ; 55                          ; 0xc3e31 vbe.c:188
    mov bp, sp                                ; 89 e5                       ; 0xc3e32
    push bx                                   ; 53                          ; 0xc3e34
    mov ax, 0b0c0h                            ; b8 c0 b0                    ; 0xc3e35 vbe.c:190
    call 03e17h                               ; e8 dc ff                    ; 0xc3e38
    call 03e03h                               ; e8 c5 ff                    ; 0xc3e3b vbe.c:191
    cmp ax, 0b0c0h                            ; 3d c0 b0                    ; 0xc3e3e
    jne short 03e55h                          ; 75 12                       ; 0xc3e41
    mov bx, 000b9h                            ; bb b9 00                    ; 0xc3e43 vbe.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3e46
    mov es, ax                                ; 8e c0                       ; 0xc3e49
    mov byte [es:bx], 001h                    ; 26 c6 07 01                 ; 0xc3e4b
    mov ax, 0b0c4h                            ; b8 c4 b0                    ; 0xc3e4f vbe.c:194
    call 03e17h                               ; e8 c2 ff                    ; 0xc3e52
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3e55 vbe.c:199
    pop bx                                    ; 5b                          ; 0xc3e58
    pop bp                                    ; 5d                          ; 0xc3e59
    retn                                      ; c3                          ; 0xc3e5a
  ; disGetNextSymbol 0xc3e5b LB 0x666 -> off=0x0 cb=000000000000006c uValue=00000000000c3e5b 'mode_info_find_mode'
mode_info_find_mode:                         ; 0xc3e5b LB 0x6c
    push bp                                   ; 55                          ; 0xc3e5b vbe.c:202
    mov bp, sp                                ; 89 e5                       ; 0xc3e5c
    push bx                                   ; 53                          ; 0xc3e5e
    push cx                                   ; 51                          ; 0xc3e5f
    push si                                   ; 56                          ; 0xc3e60
    push di                                   ; 57                          ; 0xc3e61
    mov di, ax                                ; 89 c7                       ; 0xc3e62
    mov si, dx                                ; 89 d6                       ; 0xc3e64
    xor dx, dx                                ; 31 d2                       ; 0xc3e66 vbe.c:208
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3e68
    call 03dddh                               ; e8 6f ff                    ; 0xc3e6b
    cmp ax, 077cch                            ; 3d cc 77                    ; 0xc3e6e vbe.c:209
    jne short 03ebch                          ; 75 49                       ; 0xc3e71
    test si, si                               ; 85 f6                       ; 0xc3e73 vbe.c:213
    je short 03e8ah                           ; 74 13                       ; 0xc3e75
    mov ax, strict word 0000bh                ; b8 0b 00                    ; 0xc3e77 vbe.c:220
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3e7a
    call 00570h                               ; e8 f0 c6                    ; 0xc3e7d
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3e80 vbe.c:221
    call 00577h                               ; e8 f1 c6                    ; 0xc3e83
    test ax, ax                               ; 85 c0                       ; 0xc3e86 vbe.c:222
    je short 03ebeh                           ; 74 34                       ; 0xc3e88
    mov bx, strict word 00004h                ; bb 04 00                    ; 0xc3e8a vbe.c:226
    mov dx, bx                                ; 89 da                       ; 0xc3e8d vbe.c:232
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3e8f
    call 03dddh                               ; e8 48 ff                    ; 0xc3e92
    mov cx, ax                                ; 89 c1                       ; 0xc3e95
    cmp cx, strict byte 0ffffh                ; 83 f9 ff                    ; 0xc3e97 vbe.c:233
    je short 03ebch                           ; 74 20                       ; 0xc3e9a
    lea dx, [bx+002h]                         ; 8d 57 02                    ; 0xc3e9c vbe.c:235
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3e9f
    call 03dddh                               ; e8 38 ff                    ; 0xc3ea2
    lea dx, [bx+044h]                         ; 8d 57 44                    ; 0xc3ea5
    cmp cx, di                                ; 39 f9                       ; 0xc3ea8 vbe.c:237
    jne short 03eb8h                          ; 75 0c                       ; 0xc3eaa
    test si, si                               ; 85 f6                       ; 0xc3eac vbe.c:239
    jne short 03eb4h                          ; 75 04                       ; 0xc3eae
    mov ax, bx                                ; 89 d8                       ; 0xc3eb0 vbe.c:240
    jmp short 03ebeh                          ; eb 0a                       ; 0xc3eb2
    test AL, strict byte 080h                 ; a8 80                       ; 0xc3eb4 vbe.c:241
    jne short 03eb0h                          ; 75 f8                       ; 0xc3eb6
    mov bx, dx                                ; 89 d3                       ; 0xc3eb8 vbe.c:244
    jmp short 03e8fh                          ; eb d3                       ; 0xc3eba vbe.c:249
    xor ax, ax                                ; 31 c0                       ; 0xc3ebc vbe.c:252
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc3ebe vbe.c:253
    pop di                                    ; 5f                          ; 0xc3ec1
    pop si                                    ; 5e                          ; 0xc3ec2
    pop cx                                    ; 59                          ; 0xc3ec3
    pop bx                                    ; 5b                          ; 0xc3ec4
    pop bp                                    ; 5d                          ; 0xc3ec5
    retn                                      ; c3                          ; 0xc3ec6
  ; disGetNextSymbol 0xc3ec7 LB 0x5fa -> off=0x0 cb=000000000000012b uValue=00000000000c3ec7 'vbe_biosfn_return_controller_information'
vbe_biosfn_return_controller_information: ; 0xc3ec7 LB 0x12b
    push bp                                   ; 55                          ; 0xc3ec7 vbe.c:284
    mov bp, sp                                ; 89 e5                       ; 0xc3ec8
    push cx                                   ; 51                          ; 0xc3eca
    push si                                   ; 56                          ; 0xc3ecb
    push di                                   ; 57                          ; 0xc3ecc
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc3ecd
    mov si, ax                                ; 89 c6                       ; 0xc3ed0
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc3ed2
    mov di, bx                                ; 89 df                       ; 0xc3ed5
    mov word [bp-00ch], strict word 00022h    ; c7 46 f4 22 00              ; 0xc3ed7 vbe.c:289
    call 005b7h                               ; e8 d8 c6                    ; 0xc3edc vbe.c:292
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc3edf
    mov bx, di                                ; 89 fb                       ; 0xc3ee2 vbe.c:295
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3ee4
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3ee7
    xor dx, dx                                ; 31 d2                       ; 0xc3eea vbe.c:298
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3eec
    call 03dddh                               ; e8 eb fe                    ; 0xc3eef
    cmp ax, 077cch                            ; 3d cc 77                    ; 0xc3ef2 vbe.c:299
    je short 03f01h                           ; 74 0a                       ; 0xc3ef5
    push SS                                   ; 16                          ; 0xc3ef7 vbe.c:301
    pop ES                                    ; 07                          ; 0xc3ef8
    mov word [es:si], 00100h                  ; 26 c7 04 00 01              ; 0xc3ef9
    jmp near 03feah                           ; e9 e9 00                    ; 0xc3efe vbe.c:305
    mov cx, strict word 00004h                ; b9 04 00                    ; 0xc3f01 vbe.c:307
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc3f04 vbe.c:314
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3f09 vbe.c:322
    cmp word [es:bx+002h], 03245h             ; 26 81 7f 02 45 32           ; 0xc3f0c
    jne short 03f1bh                          ; 75 07                       ; 0xc3f12
    cmp word [es:bx], 04256h                  ; 26 81 3f 56 42              ; 0xc3f14
    je short 03f2ah                           ; 74 0f                       ; 0xc3f19
    cmp word [es:bx+002h], 04153h             ; 26 81 7f 02 53 41           ; 0xc3f1b
    jne short 03f2fh                          ; 75 0c                       ; 0xc3f21
    cmp word [es:bx], 04556h                  ; 26 81 3f 56 45              ; 0xc3f23
    jne short 03f2fh                          ; 75 05                       ; 0xc3f28
    mov word [bp-00eh], strict word 00001h    ; c7 46 f2 01 00              ; 0xc3f2a vbe.c:324
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3f2f vbe.c:332
    mov word [es:bx], 04556h                  ; 26 c7 07 56 45              ; 0xc3f32
    mov word [es:bx+002h], 04153h             ; 26 c7 47 02 53 41           ; 0xc3f37 vbe.c:334
    mov word [es:bx+004h], 00200h             ; 26 c7 47 04 00 02           ; 0xc3f3d vbe.c:338
    mov word [es:bx+006h], 07e00h             ; 26 c7 47 06 00 7e           ; 0xc3f43 vbe.c:341
    mov [es:bx+008h], ds                      ; 26 8c 5f 08                 ; 0xc3f49
    mov word [es:bx+00ah], strict word 00001h ; 26 c7 47 0a 01 00           ; 0xc3f4d vbe.c:344
    mov word [es:bx+00ch], strict word 00000h ; 26 c7 47 0c 00 00           ; 0xc3f53 vbe.c:346
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3f59 vbe.c:350
    mov word [es:bx+010h], ax                 ; 26 89 47 10                 ; 0xc3f5c
    lea ax, [di+022h]                         ; 8d 45 22                    ; 0xc3f60 vbe.c:351
    mov word [es:bx+00eh], ax                 ; 26 89 47 0e                 ; 0xc3f63
    mov dx, strict word 0ffffh                ; ba ff ff                    ; 0xc3f67 vbe.c:354
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3f6a
    call 03dddh                               ; e8 6d fe                    ; 0xc3f6d
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3f70
    mov word [es:bx+012h], ax                 ; 26 89 47 12                 ; 0xc3f73
    cmp word [bp-00eh], strict byte 00000h    ; 83 7e f2 00                 ; 0xc3f77 vbe.c:356
    je short 03fa1h                           ; 74 24                       ; 0xc3f7b
    mov word [es:bx+014h], strict word 00003h ; 26 c7 47 14 03 00           ; 0xc3f7d vbe.c:359
    mov word [es:bx+016h], 07e15h             ; 26 c7 47 16 15 7e           ; 0xc3f83 vbe.c:360
    mov [es:bx+018h], ds                      ; 26 8c 5f 18                 ; 0xc3f89
    mov word [es:bx+01ah], 07e32h             ; 26 c7 47 1a 32 7e           ; 0xc3f8d vbe.c:361
    mov [es:bx+01ch], ds                      ; 26 8c 5f 1c                 ; 0xc3f93
    mov word [es:bx+01eh], 07e50h             ; 26 c7 47 1e 50 7e           ; 0xc3f97 vbe.c:362
    mov [es:bx+020h], ds                      ; 26 8c 5f 20                 ; 0xc3f9d
    mov dx, cx                                ; 89 ca                       ; 0xc3fa1 vbe.c:369
    add dx, strict byte 0001bh                ; 83 c2 1b                    ; 0xc3fa3
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3fa6
    call 03defh                               ; e8 43 fe                    ; 0xc3fa9
    xor ah, ah                                ; 30 e4                       ; 0xc3fac vbe.c:370
    cmp ax, word [bp-010h]                    ; 3b 46 f0                    ; 0xc3fae
    jnbe short 03fcah                         ; 77 17                       ; 0xc3fb1
    mov dx, cx                                ; 89 ca                       ; 0xc3fb3 vbe.c:372
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3fb5
    call 03dddh                               ; e8 22 fe                    ; 0xc3fb8
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc3fbb vbe.c:376
    add bx, di                                ; 01 fb                       ; 0xc3fbe
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc3fc0 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3fc3
    add word [bp-00ch], strict byte 00002h    ; 83 46 f4 02                 ; 0xc3fc6 vbe.c:378
    add cx, strict byte 00044h                ; 83 c1 44                    ; 0xc3fca vbe.c:380
    mov dx, cx                                ; 89 ca                       ; 0xc3fcd vbe.c:381
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3fcf
    call 03dddh                               ; e8 08 fe                    ; 0xc3fd2
    cmp ax, strict word 0ffffh                ; 3d ff ff                    ; 0xc3fd5 vbe.c:382
    jne short 03fa1h                          ; 75 c7                       ; 0xc3fd8
    add di, word [bp-00ch]                    ; 03 7e f4                    ; 0xc3fda vbe.c:385
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc3fdd vbe.c:62
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc3fe0
    push SS                                   ; 16                          ; 0xc3fe3 vbe.c:386
    pop ES                                    ; 07                          ; 0xc3fe4
    mov word [es:si], strict word 0004fh      ; 26 c7 04 4f 00              ; 0xc3fe5
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3fea vbe.c:387
    pop di                                    ; 5f                          ; 0xc3fed
    pop si                                    ; 5e                          ; 0xc3fee
    pop cx                                    ; 59                          ; 0xc3fef
    pop bp                                    ; 5d                          ; 0xc3ff0
    retn                                      ; c3                          ; 0xc3ff1
  ; disGetNextSymbol 0xc3ff2 LB 0x4cf -> off=0x0 cb=000000000000009f uValue=00000000000c3ff2 'vbe_biosfn_return_mode_information'
vbe_biosfn_return_mode_information:          ; 0xc3ff2 LB 0x9f
    push bp                                   ; 55                          ; 0xc3ff2 vbe.c:399
    mov bp, sp                                ; 89 e5                       ; 0xc3ff3
    push si                                   ; 56                          ; 0xc3ff5
    push di                                   ; 57                          ; 0xc3ff6
    push ax                                   ; 50                          ; 0xc3ff7
    push ax                                   ; 50                          ; 0xc3ff8
    mov ax, dx                                ; 89 d0                       ; 0xc3ff9
    mov si, bx                                ; 89 de                       ; 0xc3ffb
    mov bx, cx                                ; 89 cb                       ; 0xc3ffd
    test dh, 040h                             ; f6 c6 40                    ; 0xc3fff vbe.c:410
    je short 04009h                           ; 74 05                       ; 0xc4002
    mov dx, strict word 00001h                ; ba 01 00                    ; 0xc4004
    jmp short 0400bh                          ; eb 02                       ; 0xc4007
    xor dx, dx                                ; 31 d2                       ; 0xc4009
    and ah, 001h                              ; 80 e4 01                    ; 0xc400b vbe.c:411
    call 03e5bh                               ; e8 4a fe                    ; 0xc400e vbe.c:413
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc4011
    test ax, ax                               ; 85 c0                       ; 0xc4014 vbe.c:415
    je short 0407fh                           ; 74 67                       ; 0xc4016
    mov cx, 00100h                            ; b9 00 01                    ; 0xc4018 vbe.c:420
    xor ax, ax                                ; 31 c0                       ; 0xc401b
    mov di, bx                                ; 89 df                       ; 0xc401d
    mov es, si                                ; 8e c6                       ; 0xc401f
    jcxz 04025h                               ; e3 02                       ; 0xc4021
    rep stosb                                 ; f3 aa                       ; 0xc4023
    xor cx, cx                                ; 31 c9                       ; 0xc4025 vbe.c:421
    jmp short 0402eh                          ; eb 05                       ; 0xc4027
    cmp cx, strict byte 00042h                ; 83 f9 42                    ; 0xc4029
    jnc short 04047h                          ; 73 19                       ; 0xc402c
    mov dx, word [bp-006h]                    ; 8b 56 fa                    ; 0xc402e vbe.c:424
    inc dx                                    ; 42                          ; 0xc4031
    inc dx                                    ; 42                          ; 0xc4032
    add dx, cx                                ; 01 ca                       ; 0xc4033
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc4035
    call 03defh                               ; e8 b4 fd                    ; 0xc4038
    mov di, bx                                ; 89 df                       ; 0xc403b vbe.c:425
    add di, cx                                ; 01 cf                       ; 0xc403d
    mov es, si                                ; 8e c6                       ; 0xc403f vbe.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc4041
    inc cx                                    ; 41                          ; 0xc4044 vbe.c:426
    jmp short 04029h                          ; eb e2                       ; 0xc4045
    lea di, [bx+002h]                         ; 8d 7f 02                    ; 0xc4047 vbe.c:427
    mov es, si                                ; 8e c6                       ; 0xc404a vbe.c:47
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc404c
    test AL, strict byte 001h                 ; a8 01                       ; 0xc404f vbe.c:428
    je short 04063h                           ; 74 10                       ; 0xc4051
    lea di, [bx+00ch]                         ; 8d 7f 0c                    ; 0xc4053 vbe.c:429
    mov word [es:di], 00629h                  ; 26 c7 05 29 06              ; 0xc4056 vbe.c:62
    lea di, [bx+00eh]                         ; 8d 7f 0e                    ; 0xc405b vbe.c:431
    mov word [es:di], 0c000h                  ; 26 c7 05 00 c0              ; 0xc405e vbe.c:62
    mov ax, strict word 0000bh                ; b8 0b 00                    ; 0xc4063 vbe.c:434
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4066
    call 00570h                               ; e8 04 c5                    ; 0xc4069
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc406c vbe.c:435
    call 00577h                               ; e8 05 c5                    ; 0xc406f
    add bx, strict byte 0002ah                ; 83 c3 2a                    ; 0xc4072
    mov es, si                                ; 8e c6                       ; 0xc4075 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc4077
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc407a vbe.c:437
    jmp short 04082h                          ; eb 03                       ; 0xc407d vbe.c:438
    mov ax, 00100h                            ; b8 00 01                    ; 0xc407f vbe.c:442
    push SS                                   ; 16                          ; 0xc4082 vbe.c:445
    pop ES                                    ; 07                          ; 0xc4083
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc4084
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc4087
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc408a vbe.c:446
    pop di                                    ; 5f                          ; 0xc408d
    pop si                                    ; 5e                          ; 0xc408e
    pop bp                                    ; 5d                          ; 0xc408f
    retn                                      ; c3                          ; 0xc4090
  ; disGetNextSymbol 0xc4091 LB 0x430 -> off=0x0 cb=00000000000000f1 uValue=00000000000c4091 'vbe_biosfn_set_mode'
vbe_biosfn_set_mode:                         ; 0xc4091 LB 0xf1
    push bp                                   ; 55                          ; 0xc4091 vbe.c:458
    mov bp, sp                                ; 89 e5                       ; 0xc4092
    push si                                   ; 56                          ; 0xc4094
    push di                                   ; 57                          ; 0xc4095
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc4096
    mov si, ax                                ; 89 c6                       ; 0xc4099
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc409b
    test byte [bp-009h], 040h                 ; f6 46 f7 40                 ; 0xc409e vbe.c:466
    je short 040a9h                           ; 74 05                       ; 0xc40a2
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc40a4
    jmp short 040abh                          ; eb 02                       ; 0xc40a7
    xor ax, ax                                ; 31 c0                       ; 0xc40a9
    mov dx, ax                                ; 89 c2                       ; 0xc40ab
    test ax, ax                               ; 85 c0                       ; 0xc40ad vbe.c:467
    je short 040b4h                           ; 74 03                       ; 0xc40af
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc40b1
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc40b4
    test byte [bp-009h], 080h                 ; f6 46 f7 80                 ; 0xc40b7 vbe.c:468
    je short 040c2h                           ; 74 05                       ; 0xc40bb
    mov ax, 00080h                            ; b8 80 00                    ; 0xc40bd
    jmp short 040c4h                          ; eb 02                       ; 0xc40c0
    xor ax, ax                                ; 31 c0                       ; 0xc40c2
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc40c4
    and byte [bp-009h], 001h                  ; 80 66 f7 01                 ; 0xc40c7 vbe.c:470
    cmp word [bp-00ah], 00100h                ; 81 7e f6 00 01              ; 0xc40cb vbe.c:473
    jnc short 040e5h                          ; 73 13                       ; 0xc40d0
    xor ax, ax                                ; 31 c0                       ; 0xc40d2 vbe.c:477
    call 005ddh                               ; e8 06 c5                    ; 0xc40d4
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc40d7 vbe.c:481
    xor ah, ah                                ; 30 e4                       ; 0xc40da
    call 013d6h                               ; e8 f7 d2                    ; 0xc40dc
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc40df vbe.c:482
    jmp near 04176h                           ; e9 91 00                    ; 0xc40e2 vbe.c:483
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc40e5 vbe.c:486
    call 03e5bh                               ; e8 70 fd                    ; 0xc40e8
    mov bx, ax                                ; 89 c3                       ; 0xc40eb
    test ax, ax                               ; 85 c0                       ; 0xc40ed vbe.c:488
    jne short 040f4h                          ; 75 03                       ; 0xc40ef
    jmp near 04173h                           ; e9 7f 00                    ; 0xc40f1
    lea dx, [bx+014h]                         ; 8d 57 14                    ; 0xc40f4 vbe.c:493
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc40f7
    call 03dddh                               ; e8 e0 fc                    ; 0xc40fa
    mov cx, ax                                ; 89 c1                       ; 0xc40fd
    lea dx, [bx+016h]                         ; 8d 57 16                    ; 0xc40ff vbe.c:494
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc4102
    call 03dddh                               ; e8 d5 fc                    ; 0xc4105
    mov di, ax                                ; 89 c7                       ; 0xc4108
    lea dx, [bx+01bh]                         ; 8d 57 1b                    ; 0xc410a vbe.c:495
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc410d
    call 03defh                               ; e8 dc fc                    ; 0xc4110
    mov bl, al                                ; 88 c3                       ; 0xc4113
    mov bh, al                                ; 88 c7                       ; 0xc4115
    xor ax, ax                                ; 31 c0                       ; 0xc4117 vbe.c:503
    call 005ddh                               ; e8 c1 c4                    ; 0xc4119
    mov ax, strict word 00007h                ; b8 07 00                    ; 0xc411c vbe.c:505
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc411f
    out DX, ax                                ; ef                          ; 0xc4122
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc4123 vbe.c:507
    jne short 0412eh                          ; 75 06                       ; 0xc4126
    mov ax, strict word 0006ah                ; b8 6a 00                    ; 0xc4128 vbe.c:509
    call 013d6h                               ; e8 a8 d2                    ; 0xc412b
    mov al, bh                                ; 88 f8                       ; 0xc412e vbe.c:512
    xor ah, ah                                ; 30 e4                       ; 0xc4130
    call 03d54h                               ; e8 1f fc                    ; 0xc4132
    mov ax, cx                                ; 89 c8                       ; 0xc4135 vbe.c:513
    call 03cfdh                               ; e8 c3 fb                    ; 0xc4137
    mov ax, di                                ; 89 f8                       ; 0xc413a vbe.c:514
    call 03d1ch                               ; e8 dd fb                    ; 0xc413c
    xor ax, ax                                ; 31 c0                       ; 0xc413f vbe.c:515
    call 00603h                               ; e8 bf c4                    ; 0xc4141
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc4144 vbe.c:516
    or dl, 001h                               ; 80 ca 01                    ; 0xc4147
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc414a
    xor ah, ah                                ; 30 e4                       ; 0xc414d
    or al, dl                                 ; 08 d0                       ; 0xc414f
    call 005ddh                               ; e8 89 c4                    ; 0xc4151
    call 006d2h                               ; e8 7b c5                    ; 0xc4154 vbe.c:517
    mov bx, 000bah                            ; bb ba 00                    ; 0xc4157 vbe.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc415a
    mov es, ax                                ; 8e c0                       ; 0xc415d
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc415f
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc4162
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc4165 vbe.c:520
    or AL, strict byte 060h                   ; 0c 60                       ; 0xc4168
    mov bx, 00087h                            ; bb 87 00                    ; 0xc416a vbe.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc416d
    jmp near 040dfh                           ; e9 6c ff                    ; 0xc4170
    mov ax, 00100h                            ; b8 00 01                    ; 0xc4173 vbe.c:529
    push SS                                   ; 16                          ; 0xc4176 vbe.c:533
    pop ES                                    ; 07                          ; 0xc4177
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc4178
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc417b vbe.c:534
    pop di                                    ; 5f                          ; 0xc417e
    pop si                                    ; 5e                          ; 0xc417f
    pop bp                                    ; 5d                          ; 0xc4180
    retn                                      ; c3                          ; 0xc4181
  ; disGetNextSymbol 0xc4182 LB 0x33f -> off=0x0 cb=0000000000000008 uValue=00000000000c4182 'vbe_biosfn_read_video_state_size'
vbe_biosfn_read_video_state_size:            ; 0xc4182 LB 0x8
    push bp                                   ; 55                          ; 0xc4182 vbe.c:536
    mov bp, sp                                ; 89 e5                       ; 0xc4183
    mov ax, strict word 00012h                ; b8 12 00                    ; 0xc4185 vbe.c:539
    pop bp                                    ; 5d                          ; 0xc4188
    retn                                      ; c3                          ; 0xc4189
  ; disGetNextSymbol 0xc418a LB 0x337 -> off=0x0 cb=000000000000004b uValue=00000000000c418a 'vbe_biosfn_save_video_state'
vbe_biosfn_save_video_state:                 ; 0xc418a LB 0x4b
    push bp                                   ; 55                          ; 0xc418a vbe.c:541
    mov bp, sp                                ; 89 e5                       ; 0xc418b
    push bx                                   ; 53                          ; 0xc418d
    push cx                                   ; 51                          ; 0xc418e
    push si                                   ; 56                          ; 0xc418f
    mov si, ax                                ; 89 c6                       ; 0xc4190
    mov bx, dx                                ; 89 d3                       ; 0xc4192
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc4194 vbe.c:545
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4197
    out DX, ax                                ; ef                          ; 0xc419a
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc419b vbe.c:546
    in ax, DX                                 ; ed                          ; 0xc419e
    mov es, si                                ; 8e c6                       ; 0xc419f vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc41a1
    inc bx                                    ; 43                          ; 0xc41a4 vbe.c:548
    inc bx                                    ; 43                          ; 0xc41a5
    test AL, strict byte 001h                 ; a8 01                       ; 0xc41a6 vbe.c:549
    je short 041cdh                           ; 74 23                       ; 0xc41a8
    mov cx, strict word 00001h                ; b9 01 00                    ; 0xc41aa vbe.c:551
    jmp short 041b4h                          ; eb 05                       ; 0xc41ad
    cmp cx, strict byte 00009h                ; 83 f9 09                    ; 0xc41af
    jnbe short 041cdh                         ; 77 19                       ; 0xc41b2
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc41b4 vbe.c:552
    je short 041cah                           ; 74 11                       ; 0xc41b7
    mov ax, cx                                ; 89 c8                       ; 0xc41b9 vbe.c:553
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc41bb
    out DX, ax                                ; ef                          ; 0xc41be
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc41bf vbe.c:554
    in ax, DX                                 ; ed                          ; 0xc41c2
    mov es, si                                ; 8e c6                       ; 0xc41c3 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc41c5
    inc bx                                    ; 43                          ; 0xc41c8 vbe.c:555
    inc bx                                    ; 43                          ; 0xc41c9
    inc cx                                    ; 41                          ; 0xc41ca vbe.c:557
    jmp short 041afh                          ; eb e2                       ; 0xc41cb
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc41cd vbe.c:558
    pop si                                    ; 5e                          ; 0xc41d0
    pop cx                                    ; 59                          ; 0xc41d1
    pop bx                                    ; 5b                          ; 0xc41d2
    pop bp                                    ; 5d                          ; 0xc41d3
    retn                                      ; c3                          ; 0xc41d4
  ; disGetNextSymbol 0xc41d5 LB 0x2ec -> off=0x0 cb=000000000000008f uValue=00000000000c41d5 'vbe_biosfn_restore_video_state'
vbe_biosfn_restore_video_state:              ; 0xc41d5 LB 0x8f
    push bp                                   ; 55                          ; 0xc41d5 vbe.c:561
    mov bp, sp                                ; 89 e5                       ; 0xc41d6
    push bx                                   ; 53                          ; 0xc41d8
    push cx                                   ; 51                          ; 0xc41d9
    push si                                   ; 56                          ; 0xc41da
    push ax                                   ; 50                          ; 0xc41db
    mov cx, ax                                ; 89 c1                       ; 0xc41dc
    mov bx, dx                                ; 89 d3                       ; 0xc41de
    mov es, ax                                ; 8e c0                       ; 0xc41e0 vbe.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc41e2
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc41e5
    inc bx                                    ; 43                          ; 0xc41e8 vbe.c:566
    inc bx                                    ; 43                          ; 0xc41e9
    test byte [bp-008h], 001h                 ; f6 46 f8 01                 ; 0xc41ea vbe.c:568
    jne short 04200h                          ; 75 10                       ; 0xc41ee
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc41f0 vbe.c:569
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc41f3
    out DX, ax                                ; ef                          ; 0xc41f6
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc41f7 vbe.c:570
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc41fa
    out DX, ax                                ; ef                          ; 0xc41fd
    jmp short 0425ch                          ; eb 5c                       ; 0xc41fe vbe.c:571
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc4200 vbe.c:572
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4203
    out DX, ax                                ; ef                          ; 0xc4206
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc4207 vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc420a vbe.c:58
    out DX, ax                                ; ef                          ; 0xc420d
    inc bx                                    ; 43                          ; 0xc420e vbe.c:574
    inc bx                                    ; 43                          ; 0xc420f
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc4210
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4213
    out DX, ax                                ; ef                          ; 0xc4216
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc4217 vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc421a vbe.c:58
    out DX, ax                                ; ef                          ; 0xc421d
    inc bx                                    ; 43                          ; 0xc421e vbe.c:577
    inc bx                                    ; 43                          ; 0xc421f
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc4220
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4223
    out DX, ax                                ; ef                          ; 0xc4226
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc4227 vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc422a vbe.c:58
    out DX, ax                                ; ef                          ; 0xc422d
    inc bx                                    ; 43                          ; 0xc422e vbe.c:580
    inc bx                                    ; 43                          ; 0xc422f
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc4230
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4233
    out DX, ax                                ; ef                          ; 0xc4236
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc4237 vbe.c:582
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc423a
    out DX, ax                                ; ef                          ; 0xc423d
    mov si, strict word 00005h                ; be 05 00                    ; 0xc423e vbe.c:584
    jmp short 04248h                          ; eb 05                       ; 0xc4241
    cmp si, strict byte 00009h                ; 83 fe 09                    ; 0xc4243
    jnbe short 0425ch                         ; 77 14                       ; 0xc4246
    mov ax, si                                ; 89 f0                       ; 0xc4248 vbe.c:585
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc424a
    out DX, ax                                ; ef                          ; 0xc424d
    mov es, cx                                ; 8e c1                       ; 0xc424e vbe.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc4250
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4253 vbe.c:58
    out DX, ax                                ; ef                          ; 0xc4256
    inc bx                                    ; 43                          ; 0xc4257 vbe.c:587
    inc bx                                    ; 43                          ; 0xc4258
    inc si                                    ; 46                          ; 0xc4259 vbe.c:588
    jmp short 04243h                          ; eb e7                       ; 0xc425a
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc425c vbe.c:590
    pop si                                    ; 5e                          ; 0xc425f
    pop cx                                    ; 59                          ; 0xc4260
    pop bx                                    ; 5b                          ; 0xc4261
    pop bp                                    ; 5d                          ; 0xc4262
    retn                                      ; c3                          ; 0xc4263
  ; disGetNextSymbol 0xc4264 LB 0x25d -> off=0x0 cb=000000000000008c uValue=00000000000c4264 'vbe_biosfn_save_restore_state'
vbe_biosfn_save_restore_state:               ; 0xc4264 LB 0x8c
    push bp                                   ; 55                          ; 0xc4264 vbe.c:606
    mov bp, sp                                ; 89 e5                       ; 0xc4265
    push si                                   ; 56                          ; 0xc4267
    push di                                   ; 57                          ; 0xc4268
    push ax                                   ; 50                          ; 0xc4269
    mov si, ax                                ; 89 c6                       ; 0xc426a
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc426c
    mov ax, bx                                ; 89 d8                       ; 0xc426f
    mov bx, word [bp+004h]                    ; 8b 5e 04                    ; 0xc4271
    mov di, strict word 0004fh                ; bf 4f 00                    ; 0xc4274 vbe.c:611
    xor ah, ah                                ; 30 e4                       ; 0xc4277 vbe.c:612
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc4279
    je short 042c3h                           ; 74 45                       ; 0xc427c
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc427e
    je short 042a7h                           ; 74 24                       ; 0xc4281
    test ax, ax                               ; 85 c0                       ; 0xc4283
    jne short 042dfh                          ; 75 58                       ; 0xc4285
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc4287 vbe.c:614
    call 031d1h                               ; e8 44 ef                    ; 0xc428a
    mov cx, ax                                ; 89 c1                       ; 0xc428d
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc428f vbe.c:618
    je short 0429ah                           ; 74 05                       ; 0xc4293
    call 04182h                               ; e8 ea fe                    ; 0xc4295 vbe.c:619
    add ax, cx                                ; 01 c8                       ; 0xc4298
    add ax, strict word 0003fh                ; 05 3f 00                    ; 0xc429a vbe.c:620
    shr ax, 006h                              ; c1 e8 06                    ; 0xc429d
    push SS                                   ; 16                          ; 0xc42a0
    pop ES                                    ; 07                          ; 0xc42a1
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc42a2
    jmp short 042e2h                          ; eb 3b                       ; 0xc42a5 vbe.c:621
    push SS                                   ; 16                          ; 0xc42a7 vbe.c:623
    pop ES                                    ; 07                          ; 0xc42a8
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc42a9
    mov dx, cx                                ; 89 ca                       ; 0xc42ac vbe.c:624
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc42ae
    call 0320ch                               ; e8 58 ef                    ; 0xc42b1
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc42b4 vbe.c:628
    je short 042e2h                           ; 74 28                       ; 0xc42b8
    mov dx, ax                                ; 89 c2                       ; 0xc42ba vbe.c:629
    mov ax, cx                                ; 89 c8                       ; 0xc42bc
    call 0418ah                               ; e8 c9 fe                    ; 0xc42be
    jmp short 042e2h                          ; eb 1f                       ; 0xc42c1 vbe.c:630
    push SS                                   ; 16                          ; 0xc42c3 vbe.c:632
    pop ES                                    ; 07                          ; 0xc42c4
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc42c5
    mov dx, cx                                ; 89 ca                       ; 0xc42c8 vbe.c:633
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc42ca
    call 034e4h                               ; e8 14 f2                    ; 0xc42cd
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc42d0 vbe.c:637
    je short 042e2h                           ; 74 0c                       ; 0xc42d4
    mov dx, ax                                ; 89 c2                       ; 0xc42d6 vbe.c:638
    mov ax, cx                                ; 89 c8                       ; 0xc42d8
    call 041d5h                               ; e8 f8 fe                    ; 0xc42da
    jmp short 042e2h                          ; eb 03                       ; 0xc42dd vbe.c:639
    mov di, 00100h                            ; bf 00 01                    ; 0xc42df vbe.c:642
    push SS                                   ; 16                          ; 0xc42e2 vbe.c:645
    pop ES                                    ; 07                          ; 0xc42e3
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc42e4
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc42e7 vbe.c:646
    pop di                                    ; 5f                          ; 0xc42ea
    pop si                                    ; 5e                          ; 0xc42eb
    pop bp                                    ; 5d                          ; 0xc42ec
    retn 00002h                               ; c2 02 00                    ; 0xc42ed
  ; disGetNextSymbol 0xc42f0 LB 0x1d1 -> off=0x0 cb=00000000000000df uValue=00000000000c42f0 'vbe_biosfn_get_set_scanline_length'
vbe_biosfn_get_set_scanline_length:          ; 0xc42f0 LB 0xdf
    push bp                                   ; 55                          ; 0xc42f0 vbe.c:667
    mov bp, sp                                ; 89 e5                       ; 0xc42f1
    push si                                   ; 56                          ; 0xc42f3
    push di                                   ; 57                          ; 0xc42f4
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc42f5
    push ax                                   ; 50                          ; 0xc42f8
    mov di, dx                                ; 89 d7                       ; 0xc42f9
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc42fb
    mov si, cx                                ; 89 ce                       ; 0xc42fe
    call 03d73h                               ; e8 70 fa                    ; 0xc4300 vbe.c:676
    cmp AL, strict byte 00fh                  ; 3c 0f                       ; 0xc4303 vbe.c:677
    jne short 0430ch                          ; 75 05                       ; 0xc4305
    mov bx, strict word 00010h                ; bb 10 00                    ; 0xc4307
    jmp short 04310h                          ; eb 04                       ; 0xc430a
    xor ah, ah                                ; 30 e4                       ; 0xc430c
    mov bx, ax                                ; 89 c3                       ; 0xc430e
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc4310
    call 03dabh                               ; e8 95 fa                    ; 0xc4313 vbe.c:678
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc4316
    mov word [bp-00ch], strict word 0004fh    ; c7 46 f4 4f 00              ; 0xc4319 vbe.c:679
    push SS                                   ; 16                          ; 0xc431e vbe.c:680
    pop ES                                    ; 07                          ; 0xc431f
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc4320
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc4323
    mov cl, byte [es:di]                      ; 26 8a 0d                    ; 0xc4326 vbe.c:681
    cmp cl, 002h                              ; 80 f9 02                    ; 0xc4329 vbe.c:685
    je short 0433ah                           ; 74 0c                       ; 0xc432c
    cmp cl, 001h                              ; 80 f9 01                    ; 0xc432e
    je short 04360h                           ; 74 2d                       ; 0xc4331
    test cl, cl                               ; 84 c9                       ; 0xc4333
    je short 0435bh                           ; 74 24                       ; 0xc4335
    jmp near 043b8h                           ; e9 7e 00                    ; 0xc4337
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc433a vbe.c:687
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc433d
    jne short 04346h                          ; 75 05                       ; 0xc433f
    sal bx, 003h                              ; c1 e3 03                    ; 0xc4341 vbe.c:688
    jmp short 0435bh                          ; eb 15                       ; 0xc4344 vbe.c:689
    xor ah, ah                                ; 30 e4                       ; 0xc4346 vbe.c:690
    cwd                                       ; 99                          ; 0xc4348
    sal dx, 003h                              ; c1 e2 03                    ; 0xc4349
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc434c
    sar ax, 003h                              ; c1 f8 03                    ; 0xc434e
    mov cx, ax                                ; 89 c1                       ; 0xc4351
    mov ax, bx                                ; 89 d8                       ; 0xc4353
    xor dx, dx                                ; 31 d2                       ; 0xc4355
    div cx                                    ; f7 f1                       ; 0xc4357
    mov bx, ax                                ; 89 c3                       ; 0xc4359
    mov ax, bx                                ; 89 d8                       ; 0xc435b vbe.c:693
    call 03d8ch                               ; e8 2c fa                    ; 0xc435d
    call 03dabh                               ; e8 48 fa                    ; 0xc4360 vbe.c:696
    mov cx, ax                                ; 89 c1                       ; 0xc4363
    push SS                                   ; 16                          ; 0xc4365 vbe.c:697
    pop ES                                    ; 07                          ; 0xc4366
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc4367
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc436a
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc436d vbe.c:698
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc4370
    jne short 0437bh                          ; 75 07                       ; 0xc4372
    mov bx, cx                                ; 89 cb                       ; 0xc4374 vbe.c:699
    shr bx, 003h                              ; c1 eb 03                    ; 0xc4376
    jmp short 0438eh                          ; eb 13                       ; 0xc4379 vbe.c:700
    xor ah, ah                                ; 30 e4                       ; 0xc437b vbe.c:701
    cwd                                       ; 99                          ; 0xc437d
    sal dx, 003h                              ; c1 e2 03                    ; 0xc437e
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc4381
    sar ax, 003h                              ; c1 f8 03                    ; 0xc4383
    mov bx, ax                                ; 89 c3                       ; 0xc4386
    mov ax, cx                                ; 89 c8                       ; 0xc4388
    mul bx                                    ; f7 e3                       ; 0xc438a
    mov bx, ax                                ; 89 c3                       ; 0xc438c
    add bx, strict byte 00003h                ; 83 c3 03                    ; 0xc438e vbe.c:702
    and bl, 0fch                              ; 80 e3 fc                    ; 0xc4391
    push SS                                   ; 16                          ; 0xc4394 vbe.c:703
    pop ES                                    ; 07                          ; 0xc4395
    mov word [es:di], bx                      ; 26 89 1d                    ; 0xc4396
    call 03dc4h                               ; e8 28 fa                    ; 0xc4399 vbe.c:704
    push SS                                   ; 16                          ; 0xc439c
    pop ES                                    ; 07                          ; 0xc439d
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc439e
    call 03d3bh                               ; e8 97 f9                    ; 0xc43a1 vbe.c:705
    push SS                                   ; 16                          ; 0xc43a4
    pop ES                                    ; 07                          ; 0xc43a5
    cmp ax, word [es:si]                      ; 26 3b 04                    ; 0xc43a6
    jbe short 043bdh                          ; 76 12                       ; 0xc43a9
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc43ab vbe.c:706
    call 03d8ch                               ; e8 db f9                    ; 0xc43ae
    mov word [bp-00ch], 00200h                ; c7 46 f4 00 02              ; 0xc43b1 vbe.c:707
    jmp short 043bdh                          ; eb 05                       ; 0xc43b6 vbe.c:709
    mov word [bp-00ch], 00100h                ; c7 46 f4 00 01              ; 0xc43b8 vbe.c:712
    push SS                                   ; 16                          ; 0xc43bd vbe.c:715
    pop ES                                    ; 07                          ; 0xc43be
    mov ax, word [bp-00ch]                    ; 8b 46 f4                    ; 0xc43bf
    mov bx, word [bp-00eh]                    ; 8b 5e f2                    ; 0xc43c2
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc43c5
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc43c8 vbe.c:716
    pop di                                    ; 5f                          ; 0xc43cb
    pop si                                    ; 5e                          ; 0xc43cc
    pop bp                                    ; 5d                          ; 0xc43cd
    retn                                      ; c3                          ; 0xc43ce
  ; disGetNextSymbol 0xc43cf LB 0xf2 -> off=0x0 cb=00000000000000f2 uValue=00000000000c43cf 'private_biosfn_custom_mode'
private_biosfn_custom_mode:                  ; 0xc43cf LB 0xf2
    push bp                                   ; 55                          ; 0xc43cf vbe.c:742
    mov bp, sp                                ; 89 e5                       ; 0xc43d0
    push si                                   ; 56                          ; 0xc43d2
    push di                                   ; 57                          ; 0xc43d3
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc43d4
    mov di, ax                                ; 89 c7                       ; 0xc43d7
    mov si, dx                                ; 89 d6                       ; 0xc43d9
    mov dx, cx                                ; 89 ca                       ; 0xc43db
    mov word [bp-00ah], strict word 0004fh    ; c7 46 f6 4f 00              ; 0xc43dd vbe.c:755
    push SS                                   ; 16                          ; 0xc43e2 vbe.c:756
    pop ES                                    ; 07                          ; 0xc43e3
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc43e4
    test al, al                               ; 84 c0                       ; 0xc43e7 vbe.c:757
    jne short 0440dh                          ; 75 22                       ; 0xc43e9
    push SS                                   ; 16                          ; 0xc43eb vbe.c:759
    pop ES                                    ; 07                          ; 0xc43ec
    mov cx, word [es:bx]                      ; 26 8b 0f                    ; 0xc43ed
    mov bx, dx                                ; 89 d3                       ; 0xc43f0 vbe.c:760
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc43f2
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc43f5 vbe.c:761
    shr ax, 008h                              ; c1 e8 08                    ; 0xc43f8
    and ax, strict word 0007fh                ; 25 7f 00                    ; 0xc43fb
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc43fe
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc4401 vbe.c:766
    je short 04415h                           ; 74 10                       ; 0xc4403
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc4405
    je short 04415h                           ; 74 0c                       ; 0xc4407
    cmp AL, strict byte 020h                  ; 3c 20                       ; 0xc4409
    je short 04415h                           ; 74 08                       ; 0xc440b
    mov word [bp-00ah], 00100h                ; c7 46 f6 00 01              ; 0xc440d vbe.c:767
    jmp near 044b2h                           ; e9 9d 00                    ; 0xc4412 vbe.c:768
    push SS                                   ; 16                          ; 0xc4415 vbe.c:772
    pop ES                                    ; 07                          ; 0xc4416
    test byte [es:si+001h], 080h              ; 26 f6 44 01 80              ; 0xc4417
    je short 04423h                           ; 74 05                       ; 0xc441c
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc441e
    jmp short 04425h                          ; eb 02                       ; 0xc4421
    xor ax, ax                                ; 31 c0                       ; 0xc4423
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc4425
    cmp cx, 00280h                            ; 81 f9 80 02                 ; 0xc4428 vbe.c:775
    jnc short 04433h                          ; 73 05                       ; 0xc442c
    mov cx, 00280h                            ; b9 80 02                    ; 0xc442e vbe.c:776
    jmp short 0443ch                          ; eb 09                       ; 0xc4431 vbe.c:777
    cmp cx, 00a00h                            ; 81 f9 00 0a                 ; 0xc4433
    jbe short 0443ch                          ; 76 03                       ; 0xc4437
    mov cx, 00a00h                            ; b9 00 0a                    ; 0xc4439 vbe.c:778
    cmp bx, 001e0h                            ; 81 fb e0 01                 ; 0xc443c vbe.c:779
    jnc short 04447h                          ; 73 05                       ; 0xc4440
    mov bx, 001e0h                            ; bb e0 01                    ; 0xc4442 vbe.c:780
    jmp short 04450h                          ; eb 09                       ; 0xc4445 vbe.c:781
    cmp bx, 00780h                            ; 81 fb 80 07                 ; 0xc4447
    jbe short 04450h                          ; 76 03                       ; 0xc444b
    mov bx, 00780h                            ; bb 80 07                    ; 0xc444d vbe.c:782
    mov dx, strict word 0ffffh                ; ba ff ff                    ; 0xc4450 vbe.c:788
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc4453
    call 03dddh                               ; e8 84 f9                    ; 0xc4456
    mov si, ax                                ; 89 c6                       ; 0xc4459
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc445b vbe.c:791
    xor ah, ah                                ; 30 e4                       ; 0xc445e
    cwd                                       ; 99                          ; 0xc4460
    sal dx, 003h                              ; c1 e2 03                    ; 0xc4461
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc4464
    sar ax, 003h                              ; c1 f8 03                    ; 0xc4466
    mov dx, ax                                ; 89 c2                       ; 0xc4469
    mov ax, cx                                ; 89 c8                       ; 0xc446b
    mul dx                                    ; f7 e2                       ; 0xc446d
    add ax, strict word 00003h                ; 05 03 00                    ; 0xc446f vbe.c:792
    and AL, strict byte 0fch                  ; 24 fc                       ; 0xc4472
    mov dx, bx                                ; 89 da                       ; 0xc4474 vbe.c:794
    mul dx                                    ; f7 e2                       ; 0xc4476
    cmp dx, si                                ; 39 f2                       ; 0xc4478 vbe.c:796
    jnbe short 04482h                         ; 77 06                       ; 0xc447a
    jne short 04489h                          ; 75 0b                       ; 0xc447c
    test ax, ax                               ; 85 c0                       ; 0xc447e
    jbe short 04489h                          ; 76 07                       ; 0xc4480
    mov word [bp-00ah], 00200h                ; c7 46 f6 00 02              ; 0xc4482 vbe.c:798
    jmp short 044b2h                          ; eb 29                       ; 0xc4487 vbe.c:799
    xor ax, ax                                ; 31 c0                       ; 0xc4489 vbe.c:803
    call 005ddh                               ; e8 4f c1                    ; 0xc448b
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc448e vbe.c:804
    xor ah, ah                                ; 30 e4                       ; 0xc4491
    call 03d54h                               ; e8 be f8                    ; 0xc4493
    mov ax, cx                                ; 89 c8                       ; 0xc4496 vbe.c:805
    call 03cfdh                               ; e8 62 f8                    ; 0xc4498
    mov ax, bx                                ; 89 d8                       ; 0xc449b vbe.c:806
    call 03d1ch                               ; e8 7c f8                    ; 0xc449d
    xor ax, ax                                ; 31 c0                       ; 0xc44a0 vbe.c:807
    call 00603h                               ; e8 5e c1                    ; 0xc44a2
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc44a5 vbe.c:808
    or AL, strict byte 001h                   ; 0c 01                       ; 0xc44a8
    xor ah, ah                                ; 30 e4                       ; 0xc44aa
    call 005ddh                               ; e8 2e c1                    ; 0xc44ac
    call 006d2h                               ; e8 20 c2                    ; 0xc44af vbe.c:809
    push SS                                   ; 16                          ; 0xc44b2 vbe.c:817
    pop ES                                    ; 07                          ; 0xc44b3
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc44b4
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc44b7
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc44ba vbe.c:818
    pop di                                    ; 5f                          ; 0xc44bd
    pop si                                    ; 5e                          ; 0xc44be
    pop bp                                    ; 5d                          ; 0xc44bf
    retn                                      ; c3                          ; 0xc44c0

  ; Padding 0x17f bytes at 0xc44c1
  times 383 db 0

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
    db  06fh, 073h, 032h, 038h, 036h, 02fh, 056h, 042h, 06fh, 078h, 056h, 067h, 061h, 042h, 069h, 06fh
    db  073h, 032h, 038h, 036h, 02eh, 073h, 079h, 06dh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
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
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 06eh
