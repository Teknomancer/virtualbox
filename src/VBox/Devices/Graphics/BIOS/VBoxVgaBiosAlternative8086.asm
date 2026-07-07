; $Id: VBoxVgaBiosAlternative8086.asm 114642 2026-07-07 18:33:04Z klaus.espenlaub@oracle.com $
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





section VGAROM progbits vstart=0x0 align=1 ; size=0x958 class=CODE group=AUTO
  ; disGetNextSymbol 0xc0000 LB 0x958 -> off=0x28 cb=0000000000000578 uValue=00000000000c0028 'vgabios_int10_handler'
    db  055h, 0aah, 040h, 0ebh, 01dh, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 049h, 042h
    db  04dh, 000h, 00eh, 01fh, 0fch, 0e9h, 03eh, 00ah
vgabios_int10_handler:                       ; 0xc0028 LB 0x578
    pushfw                                    ; 9c                          ; 0xc0028 vgarom.asm:91
    cmp ah, 00fh                              ; 80 fc 0f                    ; 0xc0029 vgarom.asm:104
    jne short 00034h                          ; 75 06                       ; 0xc002c vgarom.asm:105
    call 0018dh                               ; e8 5c 01                    ; 0xc002e vgarom.asm:106
    jmp near 000fdh                           ; e9 c9 00                    ; 0xc0031 vgarom.asm:107
    cmp ah, 01ah                              ; 80 fc 1a                    ; 0xc0034 vgarom.asm:109
    jne short 0003fh                          ; 75 06                       ; 0xc0037 vgarom.asm:110
    call 00560h                               ; e8 24 05                    ; 0xc0039 vgarom.asm:111
    jmp near 000fdh                           ; e9 be 00                    ; 0xc003c vgarom.asm:112
    cmp ah, 00bh                              ; 80 fc 0b                    ; 0xc003f vgarom.asm:114
    jne short 0004ah                          ; 75 06                       ; 0xc0042 vgarom.asm:115
    call 000ffh                               ; e8 b8 00                    ; 0xc0044 vgarom.asm:116
    jmp near 000fdh                           ; e9 b3 00                    ; 0xc0047 vgarom.asm:117
    cmp ax, 01103h                            ; 3d 03 11                    ; 0xc004a vgarom.asm:119
    jne short 00055h                          ; 75 06                       ; 0xc004d vgarom.asm:120
    call 00454h                               ; e8 02 04                    ; 0xc004f vgarom.asm:121
    jmp near 000fdh                           ; e9 a8 00                    ; 0xc0052 vgarom.asm:122
    cmp ah, 012h                              ; 80 fc 12                    ; 0xc0055 vgarom.asm:124
    jne short 00099h                          ; 75 3f                       ; 0xc0058 vgarom.asm:125
    cmp bl, 010h                              ; 80 fb 10                    ; 0xc005a vgarom.asm:126
    jne short 00065h                          ; 75 06                       ; 0xc005d vgarom.asm:127
    call 00461h                               ; e8 ff 03                    ; 0xc005f vgarom.asm:128
    jmp near 000fdh                           ; e9 98 00                    ; 0xc0062 vgarom.asm:129
    cmp bl, 030h                              ; 80 fb 30                    ; 0xc0065 vgarom.asm:131
    jne short 00070h                          ; 75 06                       ; 0xc0068 vgarom.asm:132
    call 00484h                               ; e8 17 04                    ; 0xc006a vgarom.asm:133
    jmp near 000fdh                           ; e9 8d 00                    ; 0xc006d vgarom.asm:134
    cmp bl, 031h                              ; 80 fb 31                    ; 0xc0070 vgarom.asm:136
    jne short 0007bh                          ; 75 06                       ; 0xc0073 vgarom.asm:137
    call 004d7h                               ; e8 5f 04                    ; 0xc0075 vgarom.asm:138
    jmp near 000fdh                           ; e9 82 00                    ; 0xc0078 vgarom.asm:139
    cmp bl, 032h                              ; 80 fb 32                    ; 0xc007b vgarom.asm:141
    jne short 00085h                          ; 75 05                       ; 0xc007e vgarom.asm:142
    call 004fch                               ; e8 79 04                    ; 0xc0080 vgarom.asm:143
    jmp short 000fdh                          ; eb 78                       ; 0xc0083 vgarom.asm:144
    cmp bl, 033h                              ; 80 fb 33                    ; 0xc0085 vgarom.asm:146
    jne short 0008fh                          ; 75 05                       ; 0xc0088 vgarom.asm:147
    call 0051ah                               ; e8 8d 04                    ; 0xc008a vgarom.asm:148
    jmp short 000fdh                          ; eb 6e                       ; 0xc008d vgarom.asm:149
    cmp bl, 034h                              ; 80 fb 34                    ; 0xc008f vgarom.asm:151
    jne short 000e3h                          ; 75 4f                       ; 0xc0092 vgarom.asm:152
    call 0053eh                               ; e8 a7 04                    ; 0xc0094 vgarom.asm:153
    jmp short 000fdh                          ; eb 64                       ; 0xc0097 vgarom.asm:154
    cmp ax, 0101bh                            ; 3d 1b 10                    ; 0xc0099 vgarom.asm:156
    je short 000e3h                           ; 74 45                       ; 0xc009c vgarom.asm:157
    cmp ah, 010h                              ; 80 fc 10                    ; 0xc009e vgarom.asm:158
    jne short 000a8h                          ; 75 05                       ; 0xc00a1 vgarom.asm:162
    call 001b4h                               ; e8 0e 01                    ; 0xc00a3 vgarom.asm:164
    jmp short 000fdh                          ; eb 55                       ; 0xc00a6 vgarom.asm:165
    cmp ah, 04fh                              ; 80 fc 4f                    ; 0xc00a8 vgarom.asm:168
    jne short 000e3h                          ; 75 36                       ; 0xc00ab vgarom.asm:169
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc00ad vgarom.asm:170
    jne short 000b6h                          ; 75 05                       ; 0xc00af vgarom.asm:171
    call 00814h                               ; e8 60 07                    ; 0xc00b1 vgarom.asm:172
    jmp short 000fdh                          ; eb 47                       ; 0xc00b4 vgarom.asm:173
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc00b6 vgarom.asm:175
    jne short 000bfh                          ; 75 05                       ; 0xc00b8 vgarom.asm:176
    call 00839h                               ; e8 7c 07                    ; 0xc00ba vgarom.asm:177
    jmp short 000fdh                          ; eb 3e                       ; 0xc00bd vgarom.asm:178
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc00bf vgarom.asm:180
    jne short 000c8h                          ; 75 05                       ; 0xc00c1 vgarom.asm:181
    call 00866h                               ; e8 a0 07                    ; 0xc00c3 vgarom.asm:182
    jmp short 000fdh                          ; eb 35                       ; 0xc00c6 vgarom.asm:183
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc00c8 vgarom.asm:185
    jne short 000d1h                          ; 75 05                       ; 0xc00ca vgarom.asm:186
    call 0089ah                               ; e8 cb 07                    ; 0xc00cc vgarom.asm:187
    jmp short 000fdh                          ; eb 2c                       ; 0xc00cf vgarom.asm:188
    cmp AL, strict byte 009h                  ; 3c 09                       ; 0xc00d1 vgarom.asm:190
    jne short 000dah                          ; 75 05                       ; 0xc00d3 vgarom.asm:191
    call 008d1h                               ; e8 f9 07                    ; 0xc00d5 vgarom.asm:192
    jmp short 000fdh                          ; eb 23                       ; 0xc00d8 vgarom.asm:193
    cmp AL, strict byte 00ah                  ; 3c 0a                       ; 0xc00da vgarom.asm:195
    jne short 000e3h                          ; 75 05                       ; 0xc00dc vgarom.asm:196
    call 00944h                               ; e8 63 08                    ; 0xc00de vgarom.asm:197
    jmp short 000fdh                          ; eb 1a                       ; 0xc00e1 vgarom.asm:198
    push ES                                   ; 06                          ; 0xc00e3 vgarom.asm:202
    push DS                                   ; 1e                          ; 0xc00e4 vgarom.asm:203
    push ax                                   ; 50                          ; 0xc00e5 vgarom.asm:109
    push cx                                   ; 51                          ; 0xc00e6 vgarom.asm:110
    push dx                                   ; 52                          ; 0xc00e7 vgarom.asm:111
    push bx                                   ; 53                          ; 0xc00e8 vgarom.asm:112
    push sp                                   ; 54                          ; 0xc00e9 vgarom.asm:113
    push bp                                   ; 55                          ; 0xc00ea vgarom.asm:114
    push si                                   ; 56                          ; 0xc00eb vgarom.asm:115
    push di                                   ; 57                          ; 0xc00ec vgarom.asm:116
    push CS                                   ; 0e                          ; 0xc00ed vgarom.asm:207
    pop DS                                    ; 1f                          ; 0xc00ee vgarom.asm:208
    cld                                       ; fc                          ; 0xc00ef vgarom.asm:209
    call 038cfh                               ; e8 dc 37                    ; 0xc00f0 vgarom.asm:210
    pop di                                    ; 5f                          ; 0xc00f3 vgarom.asm:126
    pop si                                    ; 5e                          ; 0xc00f4 vgarom.asm:127
    pop bp                                    ; 5d                          ; 0xc00f5 vgarom.asm:128
    pop bx                                    ; 5b                          ; 0xc00f6 vgarom.asm:129
    pop bx                                    ; 5b                          ; 0xc00f7 vgarom.asm:130
    pop dx                                    ; 5a                          ; 0xc00f8 vgarom.asm:131
    pop cx                                    ; 59                          ; 0xc00f9 vgarom.asm:132
    pop ax                                    ; 58                          ; 0xc00fa vgarom.asm:133
    pop DS                                    ; 1f                          ; 0xc00fb vgarom.asm:213
    pop ES                                    ; 07                          ; 0xc00fc vgarom.asm:214
    popfw                                     ; 9d                          ; 0xc00fd vgarom.asm:216
    iret                                      ; cf                          ; 0xc00fe vgarom.asm:217
    cmp bh, 000h                              ; 80 ff 00                    ; 0xc00ff vgarom.asm:222
    je short 0010ah                           ; 74 06                       ; 0xc0102 vgarom.asm:223
    cmp bh, 001h                              ; 80 ff 01                    ; 0xc0104 vgarom.asm:224
    je short 0015bh                           ; 74 52                       ; 0xc0107 vgarom.asm:225
    retn                                      ; c3                          ; 0xc0109 vgarom.asm:229
    push ax                                   ; 50                          ; 0xc010a vgarom.asm:231
    push bx                                   ; 53                          ; 0xc010b vgarom.asm:232
    push cx                                   ; 51                          ; 0xc010c vgarom.asm:233
    push dx                                   ; 52                          ; 0xc010d vgarom.asm:234
    push DS                                   ; 1e                          ; 0xc010e vgarom.asm:235
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc010f vgarom.asm:236
    mov ds, dx                                ; 8e da                       ; 0xc0112 vgarom.asm:237
    mov dx, 003dah                            ; ba da 03                    ; 0xc0114 vgarom.asm:238
    in AL, DX                                 ; ec                          ; 0xc0117 vgarom.asm:239
    cmp byte [word 00049h], 003h              ; 80 3e 49 00 03              ; 0xc0118 vgarom.asm:240
    jbe short 0014eh                          ; 76 2f                       ; 0xc011d vgarom.asm:241
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc011f vgarom.asm:242
    mov AL, strict byte 000h                  ; b0 00                       ; 0xc0122 vgarom.asm:243
    out DX, AL                                ; ee                          ; 0xc0124 vgarom.asm:244
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0125 vgarom.asm:245
    and AL, strict byte 00fh                  ; 24 0f                       ; 0xc0127 vgarom.asm:246
    test AL, strict byte 008h                 ; a8 08                       ; 0xc0129 vgarom.asm:247
    je short 0012fh                           ; 74 02                       ; 0xc012b vgarom.asm:248
    add AL, strict byte 008h                  ; 04 08                       ; 0xc012d vgarom.asm:249
    out DX, AL                                ; ee                          ; 0xc012f vgarom.asm:251
    mov CL, strict byte 001h                  ; b1 01                       ; 0xc0130 vgarom.asm:252
    and bl, 010h                              ; 80 e3 10                    ; 0xc0132 vgarom.asm:253
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0135 vgarom.asm:255
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc0138 vgarom.asm:256
    out DX, AL                                ; ee                          ; 0xc013a vgarom.asm:257
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc013b vgarom.asm:258
    in AL, DX                                 ; ec                          ; 0xc013e vgarom.asm:259
    and AL, strict byte 0efh                  ; 24 ef                       ; 0xc013f vgarom.asm:260
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc0141 vgarom.asm:261
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0143 vgarom.asm:262
    out DX, AL                                ; ee                          ; 0xc0146 vgarom.asm:263
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc0147 vgarom.asm:264
    cmp cl, 004h                              ; 80 f9 04                    ; 0xc0149 vgarom.asm:265
    jne short 00135h                          ; 75 e7                       ; 0xc014c vgarom.asm:266
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc014e vgarom.asm:268
    out DX, AL                                ; ee                          ; 0xc0150 vgarom.asm:269
    mov dx, 003dah                            ; ba da 03                    ; 0xc0151 vgarom.asm:271
    in AL, DX                                 ; ec                          ; 0xc0154 vgarom.asm:272
    pop DS                                    ; 1f                          ; 0xc0155 vgarom.asm:274
    pop dx                                    ; 5a                          ; 0xc0156 vgarom.asm:275
    pop cx                                    ; 59                          ; 0xc0157 vgarom.asm:276
    pop bx                                    ; 5b                          ; 0xc0158 vgarom.asm:277
    pop ax                                    ; 58                          ; 0xc0159 vgarom.asm:278
    retn                                      ; c3                          ; 0xc015a vgarom.asm:279
    push ax                                   ; 50                          ; 0xc015b vgarom.asm:281
    push bx                                   ; 53                          ; 0xc015c vgarom.asm:282
    push cx                                   ; 51                          ; 0xc015d vgarom.asm:283
    push dx                                   ; 52                          ; 0xc015e vgarom.asm:284
    mov dx, 003dah                            ; ba da 03                    ; 0xc015f vgarom.asm:285
    in AL, DX                                 ; ec                          ; 0xc0162 vgarom.asm:286
    mov CL, strict byte 001h                  ; b1 01                       ; 0xc0163 vgarom.asm:287
    and bl, 001h                              ; 80 e3 01                    ; 0xc0165 vgarom.asm:288
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0168 vgarom.asm:290
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc016b vgarom.asm:291
    out DX, AL                                ; ee                          ; 0xc016d vgarom.asm:292
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc016e vgarom.asm:293
    in AL, DX                                 ; ec                          ; 0xc0171 vgarom.asm:294
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc0172 vgarom.asm:295
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc0174 vgarom.asm:296
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0176 vgarom.asm:297
    out DX, AL                                ; ee                          ; 0xc0179 vgarom.asm:298
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc017a vgarom.asm:299
    cmp cl, 004h                              ; 80 f9 04                    ; 0xc017c vgarom.asm:300
    jne short 00168h                          ; 75 e7                       ; 0xc017f vgarom.asm:301
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0181 vgarom.asm:302
    out DX, AL                                ; ee                          ; 0xc0183 vgarom.asm:303
    mov dx, 003dah                            ; ba da 03                    ; 0xc0184 vgarom.asm:305
    in AL, DX                                 ; ec                          ; 0xc0187 vgarom.asm:306
    pop dx                                    ; 5a                          ; 0xc0188 vgarom.asm:308
    pop cx                                    ; 59                          ; 0xc0189 vgarom.asm:309
    pop bx                                    ; 5b                          ; 0xc018a vgarom.asm:310
    pop ax                                    ; 58                          ; 0xc018b vgarom.asm:311
    retn                                      ; c3                          ; 0xc018c vgarom.asm:312
    push DS                                   ; 1e                          ; 0xc018d vgarom.asm:317
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc018e vgarom.asm:318
    mov ds, ax                                ; 8e d8                       ; 0xc0191 vgarom.asm:319
    push bx                                   ; 53                          ; 0xc0193 vgarom.asm:320
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc0194 vgarom.asm:321
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0197 vgarom.asm:322
    pop bx                                    ; 5b                          ; 0xc0199 vgarom.asm:323
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc019a vgarom.asm:324
    push bx                                   ; 53                          ; 0xc019c vgarom.asm:325
    mov bx, 00087h                            ; bb 87 00                    ; 0xc019d vgarom.asm:326
    mov ah, byte [bx]                         ; 8a 27                       ; 0xc01a0 vgarom.asm:327
    and ah, 080h                              ; 80 e4 80                    ; 0xc01a2 vgarom.asm:328
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc01a5 vgarom.asm:329
    mov al, byte [bx]                         ; 8a 07                       ; 0xc01a8 vgarom.asm:330
    db  00ah, 0c4h
    ; or al, ah                                 ; 0a c4                     ; 0xc01aa vgarom.asm:331
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc01ac vgarom.asm:332
    mov ah, byte [bx]                         ; 8a 27                       ; 0xc01af vgarom.asm:333
    pop bx                                    ; 5b                          ; 0xc01b1 vgarom.asm:334
    pop DS                                    ; 1f                          ; 0xc01b2 vgarom.asm:335
    retn                                      ; c3                          ; 0xc01b3 vgarom.asm:336
    cmp AL, strict byte 000h                  ; 3c 00                       ; 0xc01b4 vgarom.asm:341
    jne short 001bah                          ; 75 02                       ; 0xc01b6 vgarom.asm:342
    jmp short 0021bh                          ; eb 61                       ; 0xc01b8 vgarom.asm:343
    cmp AL, strict byte 001h                  ; 3c 01                       ; 0xc01ba vgarom.asm:345
    jne short 001c0h                          ; 75 02                       ; 0xc01bc vgarom.asm:346
    jmp short 00239h                          ; eb 79                       ; 0xc01be vgarom.asm:347
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc01c0 vgarom.asm:349
    jne short 001c6h                          ; 75 02                       ; 0xc01c2 vgarom.asm:350
    jmp short 00241h                          ; eb 7b                       ; 0xc01c4 vgarom.asm:351
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc01c6 vgarom.asm:353
    jne short 001cdh                          ; 75 03                       ; 0xc01c8 vgarom.asm:354
    jmp near 00272h                           ; e9 a5 00                    ; 0xc01ca vgarom.asm:355
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc01cd vgarom.asm:357
    jne short 001d4h                          ; 75 03                       ; 0xc01cf vgarom.asm:358
    jmp near 0029fh                           ; e9 cb 00                    ; 0xc01d1 vgarom.asm:359
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc01d4 vgarom.asm:361
    jne short 001dbh                          ; 75 03                       ; 0xc01d6 vgarom.asm:362
    jmp near 002c7h                           ; e9 ec 00                    ; 0xc01d8 vgarom.asm:363
    cmp AL, strict byte 009h                  ; 3c 09                       ; 0xc01db vgarom.asm:365
    jne short 001e2h                          ; 75 03                       ; 0xc01dd vgarom.asm:366
    jmp near 002d5h                           ; e9 f3 00                    ; 0xc01df vgarom.asm:367
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc01e2 vgarom.asm:369
    jne short 001e9h                          ; 75 03                       ; 0xc01e4 vgarom.asm:370
    jmp near 0031ah                           ; e9 31 01                    ; 0xc01e6 vgarom.asm:371
    cmp AL, strict byte 012h                  ; 3c 12                       ; 0xc01e9 vgarom.asm:373
    jne short 001f0h                          ; 75 03                       ; 0xc01eb vgarom.asm:374
    jmp near 00333h                           ; e9 43 01                    ; 0xc01ed vgarom.asm:375
    cmp AL, strict byte 013h                  ; 3c 13                       ; 0xc01f0 vgarom.asm:377
    jne short 001f7h                          ; 75 03                       ; 0xc01f2 vgarom.asm:378
    jmp near 0035bh                           ; e9 64 01                    ; 0xc01f4 vgarom.asm:379
    cmp AL, strict byte 015h                  ; 3c 15                       ; 0xc01f7 vgarom.asm:381
    jne short 001feh                          ; 75 03                       ; 0xc01f9 vgarom.asm:382
    jmp near 003aeh                           ; e9 b0 01                    ; 0xc01fb vgarom.asm:383
    cmp AL, strict byte 017h                  ; 3c 17                       ; 0xc01fe vgarom.asm:385
    jne short 00205h                          ; 75 03                       ; 0xc0200 vgarom.asm:386
    jmp near 003c9h                           ; e9 c4 01                    ; 0xc0202 vgarom.asm:387
    cmp AL, strict byte 018h                  ; 3c 18                       ; 0xc0205 vgarom.asm:389
    jne short 0020ch                          ; 75 03                       ; 0xc0207 vgarom.asm:390
    jmp near 003f1h                           ; e9 e5 01                    ; 0xc0209 vgarom.asm:391
    cmp AL, strict byte 019h                  ; 3c 19                       ; 0xc020c vgarom.asm:393
    jne short 00213h                          ; 75 03                       ; 0xc020e vgarom.asm:394
    jmp near 003fch                           ; e9 e9 01                    ; 0xc0210 vgarom.asm:395
    cmp AL, strict byte 01ah                  ; 3c 1a                       ; 0xc0213 vgarom.asm:397
    jne short 0021ah                          ; 75 03                       ; 0xc0215 vgarom.asm:398
    jmp near 00407h                           ; e9 ed 01                    ; 0xc0217 vgarom.asm:399
    retn                                      ; c3                          ; 0xc021a vgarom.asm:404
    cmp bl, 014h                              ; 80 fb 14                    ; 0xc021b vgarom.asm:407
    jnbe short 00238h                         ; 77 18                       ; 0xc021e vgarom.asm:408
    push ax                                   ; 50                          ; 0xc0220 vgarom.asm:409
    push dx                                   ; 52                          ; 0xc0221 vgarom.asm:410
    mov dx, 003dah                            ; ba da 03                    ; 0xc0222 vgarom.asm:411
    in AL, DX                                 ; ec                          ; 0xc0225 vgarom.asm:412
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0226 vgarom.asm:413
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0229 vgarom.asm:414
    out DX, AL                                ; ee                          ; 0xc022b vgarom.asm:415
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc022c vgarom.asm:416
    out DX, AL                                ; ee                          ; 0xc022e vgarom.asm:417
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc022f vgarom.asm:418
    out DX, AL                                ; ee                          ; 0xc0231 vgarom.asm:419
    mov dx, 003dah                            ; ba da 03                    ; 0xc0232 vgarom.asm:421
    in AL, DX                                 ; ec                          ; 0xc0235 vgarom.asm:422
    pop dx                                    ; 5a                          ; 0xc0236 vgarom.asm:424
    pop ax                                    ; 58                          ; 0xc0237 vgarom.asm:425
    retn                                      ; c3                          ; 0xc0238 vgarom.asm:427
    push bx                                   ; 53                          ; 0xc0239 vgarom.asm:432
    mov BL, strict byte 011h                  ; b3 11                       ; 0xc023a vgarom.asm:433
    call 0021bh                               ; e8 dc ff                    ; 0xc023c vgarom.asm:434
    pop bx                                    ; 5b                          ; 0xc023f vgarom.asm:435
    retn                                      ; c3                          ; 0xc0240 vgarom.asm:436
    push ax                                   ; 50                          ; 0xc0241 vgarom.asm:441
    push bx                                   ; 53                          ; 0xc0242 vgarom.asm:442
    push cx                                   ; 51                          ; 0xc0243 vgarom.asm:443
    push dx                                   ; 52                          ; 0xc0244 vgarom.asm:444
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc0245 vgarom.asm:445
    mov dx, 003dah                            ; ba da 03                    ; 0xc0247 vgarom.asm:446
    in AL, DX                                 ; ec                          ; 0xc024a vgarom.asm:447
    mov CL, strict byte 000h                  ; b1 00                       ; 0xc024b vgarom.asm:448
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc024d vgarom.asm:449
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc0250 vgarom.asm:451
    out DX, AL                                ; ee                          ; 0xc0252 vgarom.asm:452
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0253 vgarom.asm:453
    out DX, AL                                ; ee                          ; 0xc0256 vgarom.asm:454
    inc bx                                    ; 43                          ; 0xc0257 vgarom.asm:455
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc0258 vgarom.asm:456
    cmp cl, 010h                              ; 80 f9 10                    ; 0xc025a vgarom.asm:457
    jne short 00250h                          ; 75 f1                       ; 0xc025d vgarom.asm:458
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc025f vgarom.asm:459
    out DX, AL                                ; ee                          ; 0xc0261 vgarom.asm:460
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0262 vgarom.asm:461
    out DX, AL                                ; ee                          ; 0xc0265 vgarom.asm:462
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0266 vgarom.asm:463
    out DX, AL                                ; ee                          ; 0xc0268 vgarom.asm:464
    mov dx, 003dah                            ; ba da 03                    ; 0xc0269 vgarom.asm:466
    in AL, DX                                 ; ec                          ; 0xc026c vgarom.asm:467
    pop dx                                    ; 5a                          ; 0xc026d vgarom.asm:469
    pop cx                                    ; 59                          ; 0xc026e vgarom.asm:470
    pop bx                                    ; 5b                          ; 0xc026f vgarom.asm:471
    pop ax                                    ; 58                          ; 0xc0270 vgarom.asm:472
    retn                                      ; c3                          ; 0xc0271 vgarom.asm:473
    push ax                                   ; 50                          ; 0xc0272 vgarom.asm:478
    push bx                                   ; 53                          ; 0xc0273 vgarom.asm:479
    push dx                                   ; 52                          ; 0xc0274 vgarom.asm:480
    mov dx, 003dah                            ; ba da 03                    ; 0xc0275 vgarom.asm:481
    in AL, DX                                 ; ec                          ; 0xc0278 vgarom.asm:482
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0279 vgarom.asm:483
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc027c vgarom.asm:484
    out DX, AL                                ; ee                          ; 0xc027e vgarom.asm:485
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc027f vgarom.asm:486
    in AL, DX                                 ; ec                          ; 0xc0282 vgarom.asm:487
    and AL, strict byte 0f7h                  ; 24 f7                       ; 0xc0283 vgarom.asm:488
    and bl, 001h                              ; 80 e3 01                    ; 0xc0285 vgarom.asm:489
    sal bl, 1                                 ; d0 e3                       ; 0xc0288 vgarom.asm:493
    sal bl, 1                                 ; d0 e3                       ; 0xc028a vgarom.asm:494
    sal bl, 1                                 ; d0 e3                       ; 0xc028c vgarom.asm:495
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc028e vgarom.asm:497
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0290 vgarom.asm:498
    out DX, AL                                ; ee                          ; 0xc0293 vgarom.asm:499
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0294 vgarom.asm:500
    out DX, AL                                ; ee                          ; 0xc0296 vgarom.asm:501
    mov dx, 003dah                            ; ba da 03                    ; 0xc0297 vgarom.asm:503
    in AL, DX                                 ; ec                          ; 0xc029a vgarom.asm:504
    pop dx                                    ; 5a                          ; 0xc029b vgarom.asm:506
    pop bx                                    ; 5b                          ; 0xc029c vgarom.asm:507
    pop ax                                    ; 58                          ; 0xc029d vgarom.asm:508
    retn                                      ; c3                          ; 0xc029e vgarom.asm:509
    cmp bl, 014h                              ; 80 fb 14                    ; 0xc029f vgarom.asm:514
    jnbe short 002c6h                         ; 77 22                       ; 0xc02a2 vgarom.asm:515
    push ax                                   ; 50                          ; 0xc02a4 vgarom.asm:516
    push dx                                   ; 52                          ; 0xc02a5 vgarom.asm:517
    mov dx, 003dah                            ; ba da 03                    ; 0xc02a6 vgarom.asm:518
    in AL, DX                                 ; ec                          ; 0xc02a9 vgarom.asm:519
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02aa vgarom.asm:520
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc02ad vgarom.asm:521
    out DX, AL                                ; ee                          ; 0xc02af vgarom.asm:522
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc02b0 vgarom.asm:523
    in AL, DX                                 ; ec                          ; 0xc02b3 vgarom.asm:524
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc02b4 vgarom.asm:525
    mov dx, 003dah                            ; ba da 03                    ; 0xc02b6 vgarom.asm:526
    in AL, DX                                 ; ec                          ; 0xc02b9 vgarom.asm:527
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02ba vgarom.asm:528
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc02bd vgarom.asm:529
    out DX, AL                                ; ee                          ; 0xc02bf vgarom.asm:530
    mov dx, 003dah                            ; ba da 03                    ; 0xc02c0 vgarom.asm:532
    in AL, DX                                 ; ec                          ; 0xc02c3 vgarom.asm:533
    pop dx                                    ; 5a                          ; 0xc02c4 vgarom.asm:535
    pop ax                                    ; 58                          ; 0xc02c5 vgarom.asm:536
    retn                                      ; c3                          ; 0xc02c6 vgarom.asm:538
    push ax                                   ; 50                          ; 0xc02c7 vgarom.asm:543
    push bx                                   ; 53                          ; 0xc02c8 vgarom.asm:544
    mov BL, strict byte 011h                  ; b3 11                       ; 0xc02c9 vgarom.asm:545
    call 0029fh                               ; e8 d1 ff                    ; 0xc02cb vgarom.asm:546
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc02ce vgarom.asm:547
    pop bx                                    ; 5b                          ; 0xc02d0 vgarom.asm:548
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc02d1 vgarom.asm:549
    pop ax                                    ; 58                          ; 0xc02d3 vgarom.asm:550
    retn                                      ; c3                          ; 0xc02d4 vgarom.asm:551
    push ax                                   ; 50                          ; 0xc02d5 vgarom.asm:556
    push bx                                   ; 53                          ; 0xc02d6 vgarom.asm:557
    push cx                                   ; 51                          ; 0xc02d7 vgarom.asm:558
    push dx                                   ; 52                          ; 0xc02d8 vgarom.asm:559
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc02d9 vgarom.asm:560
    mov CL, strict byte 000h                  ; b1 00                       ; 0xc02db vgarom.asm:561
    mov dx, 003dah                            ; ba da 03                    ; 0xc02dd vgarom.asm:563
    in AL, DX                                 ; ec                          ; 0xc02e0 vgarom.asm:564
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02e1 vgarom.asm:565
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc02e4 vgarom.asm:566
    out DX, AL                                ; ee                          ; 0xc02e6 vgarom.asm:567
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc02e7 vgarom.asm:568
    in AL, DX                                 ; ec                          ; 0xc02ea vgarom.asm:569
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc02eb vgarom.asm:570
    inc bx                                    ; 43                          ; 0xc02ee vgarom.asm:571
    db  0feh, 0c1h
    ; inc cl                                    ; fe c1                     ; 0xc02ef vgarom.asm:572
    cmp cl, 010h                              ; 80 f9 10                    ; 0xc02f1 vgarom.asm:573
    jne short 002ddh                          ; 75 e7                       ; 0xc02f4 vgarom.asm:574
    mov dx, 003dah                            ; ba da 03                    ; 0xc02f6 vgarom.asm:575
    in AL, DX                                 ; ec                          ; 0xc02f9 vgarom.asm:576
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc02fa vgarom.asm:577
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc02fd vgarom.asm:578
    out DX, AL                                ; ee                          ; 0xc02ff vgarom.asm:579
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0300 vgarom.asm:580
    in AL, DX                                 ; ec                          ; 0xc0303 vgarom.asm:581
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc0304 vgarom.asm:582
    mov dx, 003dah                            ; ba da 03                    ; 0xc0307 vgarom.asm:583
    in AL, DX                                 ; ec                          ; 0xc030a vgarom.asm:584
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc030b vgarom.asm:585
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc030e vgarom.asm:586
    out DX, AL                                ; ee                          ; 0xc0310 vgarom.asm:587
    mov dx, 003dah                            ; ba da 03                    ; 0xc0311 vgarom.asm:589
    in AL, DX                                 ; ec                          ; 0xc0314 vgarom.asm:590
    pop dx                                    ; 5a                          ; 0xc0315 vgarom.asm:592
    pop cx                                    ; 59                          ; 0xc0316 vgarom.asm:593
    pop bx                                    ; 5b                          ; 0xc0317 vgarom.asm:594
    pop ax                                    ; 58                          ; 0xc0318 vgarom.asm:595
    retn                                      ; c3                          ; 0xc0319 vgarom.asm:596
    push ax                                   ; 50                          ; 0xc031a vgarom.asm:601
    push dx                                   ; 52                          ; 0xc031b vgarom.asm:602
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc031c vgarom.asm:603
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc031f vgarom.asm:604
    out DX, AL                                ; ee                          ; 0xc0321 vgarom.asm:605
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc0322 vgarom.asm:606
    pop ax                                    ; 58                          ; 0xc0325 vgarom.asm:607
    push ax                                   ; 50                          ; 0xc0326 vgarom.asm:608
    db  08ah, 0c4h
    ; mov al, ah                                ; 8a c4                     ; 0xc0327 vgarom.asm:609
    out DX, AL                                ; ee                          ; 0xc0329 vgarom.asm:610
    db  08ah, 0c5h
    ; mov al, ch                                ; 8a c5                     ; 0xc032a vgarom.asm:611
    out DX, AL                                ; ee                          ; 0xc032c vgarom.asm:612
    db  08ah, 0c1h
    ; mov al, cl                                ; 8a c1                     ; 0xc032d vgarom.asm:613
    out DX, AL                                ; ee                          ; 0xc032f vgarom.asm:614
    pop dx                                    ; 5a                          ; 0xc0330 vgarom.asm:615
    pop ax                                    ; 58                          ; 0xc0331 vgarom.asm:616
    retn                                      ; c3                          ; 0xc0332 vgarom.asm:617
    push ax                                   ; 50                          ; 0xc0333 vgarom.asm:622
    push bx                                   ; 53                          ; 0xc0334 vgarom.asm:623
    push cx                                   ; 51                          ; 0xc0335 vgarom.asm:624
    push dx                                   ; 52                          ; 0xc0336 vgarom.asm:625
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc0337 vgarom.asm:626
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc033a vgarom.asm:627
    out DX, AL                                ; ee                          ; 0xc033c vgarom.asm:628
    pop dx                                    ; 5a                          ; 0xc033d vgarom.asm:629
    push dx                                   ; 52                          ; 0xc033e vgarom.asm:630
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc033f vgarom.asm:631
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc0341 vgarom.asm:632
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0344 vgarom.asm:634
    out DX, AL                                ; ee                          ; 0xc0347 vgarom.asm:635
    inc bx                                    ; 43                          ; 0xc0348 vgarom.asm:636
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0349 vgarom.asm:637
    out DX, AL                                ; ee                          ; 0xc034c vgarom.asm:638
    inc bx                                    ; 43                          ; 0xc034d vgarom.asm:639
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc034e vgarom.asm:640
    out DX, AL                                ; ee                          ; 0xc0351 vgarom.asm:641
    inc bx                                    ; 43                          ; 0xc0352 vgarom.asm:642
    dec cx                                    ; 49                          ; 0xc0353 vgarom.asm:643
    jne short 00344h                          ; 75 ee                       ; 0xc0354 vgarom.asm:644
    pop dx                                    ; 5a                          ; 0xc0356 vgarom.asm:645
    pop cx                                    ; 59                          ; 0xc0357 vgarom.asm:646
    pop bx                                    ; 5b                          ; 0xc0358 vgarom.asm:647
    pop ax                                    ; 58                          ; 0xc0359 vgarom.asm:648
    retn                                      ; c3                          ; 0xc035a vgarom.asm:649
    push ax                                   ; 50                          ; 0xc035b vgarom.asm:654
    push bx                                   ; 53                          ; 0xc035c vgarom.asm:655
    push dx                                   ; 52                          ; 0xc035d vgarom.asm:656
    mov dx, 003dah                            ; ba da 03                    ; 0xc035e vgarom.asm:657
    in AL, DX                                 ; ec                          ; 0xc0361 vgarom.asm:658
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0362 vgarom.asm:659
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc0365 vgarom.asm:660
    out DX, AL                                ; ee                          ; 0xc0367 vgarom.asm:661
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0368 vgarom.asm:662
    in AL, DX                                 ; ec                          ; 0xc036b vgarom.asm:663
    and bl, 001h                              ; 80 e3 01                    ; 0xc036c vgarom.asm:664
    jne short 00389h                          ; 75 18                       ; 0xc036f vgarom.asm:665
    and AL, strict byte 07fh                  ; 24 7f                       ; 0xc0371 vgarom.asm:666
    sal bh, 1                                 ; d0 e7                       ; 0xc0373 vgarom.asm:670
    sal bh, 1                                 ; d0 e7                       ; 0xc0375 vgarom.asm:671
    sal bh, 1                                 ; d0 e7                       ; 0xc0377 vgarom.asm:672
    sal bh, 1                                 ; d0 e7                       ; 0xc0379 vgarom.asm:673
    sal bh, 1                                 ; d0 e7                       ; 0xc037b vgarom.asm:674
    sal bh, 1                                 ; d0 e7                       ; 0xc037d vgarom.asm:675
    sal bh, 1                                 ; d0 e7                       ; 0xc037f vgarom.asm:676
    db  00ah, 0c7h
    ; or al, bh                                 ; 0a c7                     ; 0xc0381 vgarom.asm:678
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0383 vgarom.asm:679
    out DX, AL                                ; ee                          ; 0xc0386 vgarom.asm:680
    jmp short 003a3h                          ; eb 1a                       ; 0xc0387 vgarom.asm:681
    push ax                                   ; 50                          ; 0xc0389 vgarom.asm:683
    mov dx, 003dah                            ; ba da 03                    ; 0xc038a vgarom.asm:684
    in AL, DX                                 ; ec                          ; 0xc038d vgarom.asm:685
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc038e vgarom.asm:686
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc0391 vgarom.asm:687
    out DX, AL                                ; ee                          ; 0xc0393 vgarom.asm:688
    pop ax                                    ; 58                          ; 0xc0394 vgarom.asm:689
    and AL, strict byte 080h                  ; 24 80                       ; 0xc0395 vgarom.asm:690
    jne short 0039dh                          ; 75 04                       ; 0xc0397 vgarom.asm:691
    sal bh, 1                                 ; d0 e7                       ; 0xc0399 vgarom.asm:695
    sal bh, 1                                 ; d0 e7                       ; 0xc039b vgarom.asm:696
    and bh, 00fh                              ; 80 e7 0f                    ; 0xc039d vgarom.asm:699
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc03a0 vgarom.asm:700
    out DX, AL                                ; ee                          ; 0xc03a2 vgarom.asm:701
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc03a3 vgarom.asm:703
    out DX, AL                                ; ee                          ; 0xc03a5 vgarom.asm:704
    mov dx, 003dah                            ; ba da 03                    ; 0xc03a6 vgarom.asm:706
    in AL, DX                                 ; ec                          ; 0xc03a9 vgarom.asm:707
    pop dx                                    ; 5a                          ; 0xc03aa vgarom.asm:709
    pop bx                                    ; 5b                          ; 0xc03ab vgarom.asm:710
    pop ax                                    ; 58                          ; 0xc03ac vgarom.asm:711
    retn                                      ; c3                          ; 0xc03ad vgarom.asm:712
    push ax                                   ; 50                          ; 0xc03ae vgarom.asm:717
    push dx                                   ; 52                          ; 0xc03af vgarom.asm:718
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc03b0 vgarom.asm:719
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc03b3 vgarom.asm:720
    out DX, AL                                ; ee                          ; 0xc03b5 vgarom.asm:721
    pop ax                                    ; 58                          ; 0xc03b6 vgarom.asm:722
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc03b7 vgarom.asm:723
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc03b9 vgarom.asm:724
    in AL, DX                                 ; ec                          ; 0xc03bc vgarom.asm:725
    db  086h, 0e0h
    ; xchg al, ah                               ; 86 e0                     ; 0xc03bd vgarom.asm:726
    push ax                                   ; 50                          ; 0xc03bf vgarom.asm:727
    in AL, DX                                 ; ec                          ; 0xc03c0 vgarom.asm:728
    db  08ah, 0e8h
    ; mov ch, al                                ; 8a e8                     ; 0xc03c1 vgarom.asm:729
    in AL, DX                                 ; ec                          ; 0xc03c3 vgarom.asm:730
    db  08ah, 0c8h
    ; mov cl, al                                ; 8a c8                     ; 0xc03c4 vgarom.asm:731
    pop dx                                    ; 5a                          ; 0xc03c6 vgarom.asm:732
    pop ax                                    ; 58                          ; 0xc03c7 vgarom.asm:733
    retn                                      ; c3                          ; 0xc03c8 vgarom.asm:734
    push ax                                   ; 50                          ; 0xc03c9 vgarom.asm:739
    push bx                                   ; 53                          ; 0xc03ca vgarom.asm:740
    push cx                                   ; 51                          ; 0xc03cb vgarom.asm:741
    push dx                                   ; 52                          ; 0xc03cc vgarom.asm:742
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc03cd vgarom.asm:743
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc03d0 vgarom.asm:744
    out DX, AL                                ; ee                          ; 0xc03d2 vgarom.asm:745
    pop dx                                    ; 5a                          ; 0xc03d3 vgarom.asm:746
    push dx                                   ; 52                          ; 0xc03d4 vgarom.asm:747
    db  08bh, 0dah
    ; mov bx, dx                                ; 8b da                     ; 0xc03d5 vgarom.asm:748
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc03d7 vgarom.asm:749
    in AL, DX                                 ; ec                          ; 0xc03da vgarom.asm:751
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc03db vgarom.asm:752
    inc bx                                    ; 43                          ; 0xc03de vgarom.asm:753
    in AL, DX                                 ; ec                          ; 0xc03df vgarom.asm:754
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc03e0 vgarom.asm:755
    inc bx                                    ; 43                          ; 0xc03e3 vgarom.asm:756
    in AL, DX                                 ; ec                          ; 0xc03e4 vgarom.asm:757
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc03e5 vgarom.asm:758
    inc bx                                    ; 43                          ; 0xc03e8 vgarom.asm:759
    dec cx                                    ; 49                          ; 0xc03e9 vgarom.asm:760
    jne short 003dah                          ; 75 ee                       ; 0xc03ea vgarom.asm:761
    pop dx                                    ; 5a                          ; 0xc03ec vgarom.asm:762
    pop cx                                    ; 59                          ; 0xc03ed vgarom.asm:763
    pop bx                                    ; 5b                          ; 0xc03ee vgarom.asm:764
    pop ax                                    ; 58                          ; 0xc03ef vgarom.asm:765
    retn                                      ; c3                          ; 0xc03f0 vgarom.asm:766
    push ax                                   ; 50                          ; 0xc03f1 vgarom.asm:771
    push dx                                   ; 52                          ; 0xc03f2 vgarom.asm:772
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc03f3 vgarom.asm:773
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc03f6 vgarom.asm:774
    out DX, AL                                ; ee                          ; 0xc03f8 vgarom.asm:775
    pop dx                                    ; 5a                          ; 0xc03f9 vgarom.asm:776
    pop ax                                    ; 58                          ; 0xc03fa vgarom.asm:777
    retn                                      ; c3                          ; 0xc03fb vgarom.asm:778
    push ax                                   ; 50                          ; 0xc03fc vgarom.asm:783
    push dx                                   ; 52                          ; 0xc03fd vgarom.asm:784
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc03fe vgarom.asm:785
    in AL, DX                                 ; ec                          ; 0xc0401 vgarom.asm:786
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc0402 vgarom.asm:787
    pop dx                                    ; 5a                          ; 0xc0404 vgarom.asm:788
    pop ax                                    ; 58                          ; 0xc0405 vgarom.asm:789
    retn                                      ; c3                          ; 0xc0406 vgarom.asm:790
    push ax                                   ; 50                          ; 0xc0407 vgarom.asm:795
    push dx                                   ; 52                          ; 0xc0408 vgarom.asm:796
    mov dx, 003dah                            ; ba da 03                    ; 0xc0409 vgarom.asm:797
    in AL, DX                                 ; ec                          ; 0xc040c vgarom.asm:798
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc040d vgarom.asm:799
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc0410 vgarom.asm:800
    out DX, AL                                ; ee                          ; 0xc0412 vgarom.asm:801
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0413 vgarom.asm:802
    in AL, DX                                 ; ec                          ; 0xc0416 vgarom.asm:803
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc0417 vgarom.asm:804
    shr bl, 1                                 ; d0 eb                       ; 0xc0419 vgarom.asm:808
    shr bl, 1                                 ; d0 eb                       ; 0xc041b vgarom.asm:809
    shr bl, 1                                 ; d0 eb                       ; 0xc041d vgarom.asm:810
    shr bl, 1                                 ; d0 eb                       ; 0xc041f vgarom.asm:811
    shr bl, 1                                 ; d0 eb                       ; 0xc0421 vgarom.asm:812
    shr bl, 1                                 ; d0 eb                       ; 0xc0423 vgarom.asm:813
    shr bl, 1                                 ; d0 eb                       ; 0xc0425 vgarom.asm:814
    mov dx, 003dah                            ; ba da 03                    ; 0xc0427 vgarom.asm:816
    in AL, DX                                 ; ec                          ; 0xc042a vgarom.asm:817
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc042b vgarom.asm:818
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc042e vgarom.asm:819
    out DX, AL                                ; ee                          ; 0xc0430 vgarom.asm:820
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0431 vgarom.asm:821
    in AL, DX                                 ; ec                          ; 0xc0434 vgarom.asm:822
    db  08ah, 0f8h
    ; mov bh, al                                ; 8a f8                     ; 0xc0435 vgarom.asm:823
    and bh, 00fh                              ; 80 e7 0f                    ; 0xc0437 vgarom.asm:824
    test bl, 001h                             ; f6 c3 01                    ; 0xc043a vgarom.asm:825
    jne short 00443h                          ; 75 04                       ; 0xc043d vgarom.asm:826
    shr bh, 1                                 ; d0 ef                       ; 0xc043f vgarom.asm:830
    shr bh, 1                                 ; d0 ef                       ; 0xc0441 vgarom.asm:831
    mov dx, 003dah                            ; ba da 03                    ; 0xc0443 vgarom.asm:834
    in AL, DX                                 ; ec                          ; 0xc0446 vgarom.asm:835
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0447 vgarom.asm:836
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc044a vgarom.asm:837
    out DX, AL                                ; ee                          ; 0xc044c vgarom.asm:838
    mov dx, 003dah                            ; ba da 03                    ; 0xc044d vgarom.asm:840
    in AL, DX                                 ; ec                          ; 0xc0450 vgarom.asm:841
    pop dx                                    ; 5a                          ; 0xc0451 vgarom.asm:843
    pop ax                                    ; 58                          ; 0xc0452 vgarom.asm:844
    retn                                      ; c3                          ; 0xc0453 vgarom.asm:845
    push ax                                   ; 50                          ; 0xc0454 vgarom.asm:850
    push dx                                   ; 52                          ; 0xc0455 vgarom.asm:851
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc0456 vgarom.asm:852
    db  08ah, 0e3h
    ; mov ah, bl                                ; 8a e3                     ; 0xc0459 vgarom.asm:853
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc045b vgarom.asm:854
    out DX, ax                                ; ef                          ; 0xc045d vgarom.asm:855
    pop dx                                    ; 5a                          ; 0xc045e vgarom.asm:856
    pop ax                                    ; 58                          ; 0xc045f vgarom.asm:857
    retn                                      ; c3                          ; 0xc0460 vgarom.asm:858
    push DS                                   ; 1e                          ; 0xc0461 vgarom.asm:863
    push ax                                   ; 50                          ; 0xc0462 vgarom.asm:864
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0463 vgarom.asm:865
    mov ds, ax                                ; 8e d8                       ; 0xc0466 vgarom.asm:866
    db  032h, 0edh
    ; xor ch, ch                                ; 32 ed                     ; 0xc0468 vgarom.asm:867
    mov bx, 00088h                            ; bb 88 00                    ; 0xc046a vgarom.asm:868
    mov cl, byte [bx]                         ; 8a 0f                       ; 0xc046d vgarom.asm:869
    and cl, 00fh                              ; 80 e1 0f                    ; 0xc046f vgarom.asm:870
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc0472 vgarom.asm:871
    mov ax, word [bx]                         ; 8b 07                       ; 0xc0475 vgarom.asm:872
    mov bx, strict word 00003h                ; bb 03 00                    ; 0xc0477 vgarom.asm:873
    cmp ax, 003b4h                            ; 3d b4 03                    ; 0xc047a vgarom.asm:874
    jne short 00481h                          ; 75 02                       ; 0xc047d vgarom.asm:875
    mov BH, strict byte 001h                  ; b7 01                       ; 0xc047f vgarom.asm:876
    pop ax                                    ; 58                          ; 0xc0481 vgarom.asm:878
    pop DS                                    ; 1f                          ; 0xc0482 vgarom.asm:879
    retn                                      ; c3                          ; 0xc0483 vgarom.asm:880
    push DS                                   ; 1e                          ; 0xc0484 vgarom.asm:888
    push bx                                   ; 53                          ; 0xc0485 vgarom.asm:889
    push dx                                   ; 52                          ; 0xc0486 vgarom.asm:890
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc0487 vgarom.asm:891
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0489 vgarom.asm:892
    mov ds, ax                                ; 8e d8                       ; 0xc048c vgarom.asm:893
    mov bx, 00089h                            ; bb 89 00                    ; 0xc048e vgarom.asm:894
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0491 vgarom.asm:895
    mov bx, 00088h                            ; bb 88 00                    ; 0xc0493 vgarom.asm:896
    mov ah, byte [bx]                         ; 8a 27                       ; 0xc0496 vgarom.asm:897
    cmp dl, 001h                              ; 80 fa 01                    ; 0xc0498 vgarom.asm:898
    je short 004b2h                           ; 74 15                       ; 0xc049b vgarom.asm:899
    jc short 004bch                           ; 72 1d                       ; 0xc049d vgarom.asm:900
    cmp dl, 002h                              ; 80 fa 02                    ; 0xc049f vgarom.asm:901
    je short 004a6h                           ; 74 02                       ; 0xc04a2 vgarom.asm:902
    jmp short 004d0h                          ; eb 2a                       ; 0xc04a4 vgarom.asm:912
    and AL, strict byte 07fh                  ; 24 7f                       ; 0xc04a6 vgarom.asm:918
    or AL, strict byte 010h                   ; 0c 10                       ; 0xc04a8 vgarom.asm:919
    and ah, 0f0h                              ; 80 e4 f0                    ; 0xc04aa vgarom.asm:920
    or ah, 009h                               ; 80 cc 09                    ; 0xc04ad vgarom.asm:921
    jne short 004c6h                          ; 75 14                       ; 0xc04b0 vgarom.asm:922
    and AL, strict byte 06fh                  ; 24 6f                       ; 0xc04b2 vgarom.asm:928
    and ah, 0f0h                              ; 80 e4 f0                    ; 0xc04b4 vgarom.asm:929
    or ah, 009h                               ; 80 cc 09                    ; 0xc04b7 vgarom.asm:930
    jne short 004c6h                          ; 75 0a                       ; 0xc04ba vgarom.asm:931
    and AL, strict byte 0efh                  ; 24 ef                       ; 0xc04bc vgarom.asm:937
    or AL, strict byte 080h                   ; 0c 80                       ; 0xc04be vgarom.asm:938
    and ah, 0f0h                              ; 80 e4 f0                    ; 0xc04c0 vgarom.asm:939
    or ah, 008h                               ; 80 cc 08                    ; 0xc04c3 vgarom.asm:940
    mov bx, 00089h                            ; bb 89 00                    ; 0xc04c6 vgarom.asm:942
    mov byte [bx], al                         ; 88 07                       ; 0xc04c9 vgarom.asm:943
    mov bx, 00088h                            ; bb 88 00                    ; 0xc04cb vgarom.asm:944
    mov byte [bx], ah                         ; 88 27                       ; 0xc04ce vgarom.asm:945
    mov ax, 01212h                            ; b8 12 12                    ; 0xc04d0 vgarom.asm:947
    pop dx                                    ; 5a                          ; 0xc04d3 vgarom.asm:948
    pop bx                                    ; 5b                          ; 0xc04d4 vgarom.asm:949
    pop DS                                    ; 1f                          ; 0xc04d5 vgarom.asm:950
    retn                                      ; c3                          ; 0xc04d6 vgarom.asm:951
    push DS                                   ; 1e                          ; 0xc04d7 vgarom.asm:960
    push bx                                   ; 53                          ; 0xc04d8 vgarom.asm:961
    push dx                                   ; 52                          ; 0xc04d9 vgarom.asm:962
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc04da vgarom.asm:963
    and dl, 001h                              ; 80 e2 01                    ; 0xc04dc vgarom.asm:964
    sal dl, 1                                 ; d0 e2                       ; 0xc04df vgarom.asm:968
    sal dl, 1                                 ; d0 e2                       ; 0xc04e1 vgarom.asm:969
    sal dl, 1                                 ; d0 e2                       ; 0xc04e3 vgarom.asm:970
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc04e5 vgarom.asm:972
    mov ds, ax                                ; 8e d8                       ; 0xc04e8 vgarom.asm:973
    mov bx, 00089h                            ; bb 89 00                    ; 0xc04ea vgarom.asm:974
    mov al, byte [bx]                         ; 8a 07                       ; 0xc04ed vgarom.asm:975
    and AL, strict byte 0f7h                  ; 24 f7                       ; 0xc04ef vgarom.asm:976
    db  00ah, 0c2h
    ; or al, dl                                 ; 0a c2                     ; 0xc04f1 vgarom.asm:977
    mov byte [bx], al                         ; 88 07                       ; 0xc04f3 vgarom.asm:978
    mov ax, 01212h                            ; b8 12 12                    ; 0xc04f5 vgarom.asm:979
    pop dx                                    ; 5a                          ; 0xc04f8 vgarom.asm:980
    pop bx                                    ; 5b                          ; 0xc04f9 vgarom.asm:981
    pop DS                                    ; 1f                          ; 0xc04fa vgarom.asm:982
    retn                                      ; c3                          ; 0xc04fb vgarom.asm:983
    push bx                                   ; 53                          ; 0xc04fc vgarom.asm:987
    push dx                                   ; 52                          ; 0xc04fd vgarom.asm:988
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc04fe vgarom.asm:989
    and bl, 001h                              ; 80 e3 01                    ; 0xc0500 vgarom.asm:990
    xor bl, 001h                              ; 80 f3 01                    ; 0xc0503 vgarom.asm:991
    sal bl, 1                                 ; d0 e3                       ; 0xc0506 vgarom.asm:992
    mov dx, 003cch                            ; ba cc 03                    ; 0xc0508 vgarom.asm:993
    in AL, DX                                 ; ec                          ; 0xc050b vgarom.asm:994
    and AL, strict byte 0fdh                  ; 24 fd                       ; 0xc050c vgarom.asm:995
    db  00ah, 0c3h
    ; or al, bl                                 ; 0a c3                     ; 0xc050e vgarom.asm:996
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc0510 vgarom.asm:997
    out DX, AL                                ; ee                          ; 0xc0513 vgarom.asm:998
    mov ax, 01212h                            ; b8 12 12                    ; 0xc0514 vgarom.asm:999
    pop dx                                    ; 5a                          ; 0xc0517 vgarom.asm:1000
    pop bx                                    ; 5b                          ; 0xc0518 vgarom.asm:1001
    retn                                      ; c3                          ; 0xc0519 vgarom.asm:1002
    push DS                                   ; 1e                          ; 0xc051a vgarom.asm:1006
    push bx                                   ; 53                          ; 0xc051b vgarom.asm:1007
    push dx                                   ; 52                          ; 0xc051c vgarom.asm:1008
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc051d vgarom.asm:1009
    and dl, 001h                              ; 80 e2 01                    ; 0xc051f vgarom.asm:1010
    xor dl, 001h                              ; 80 f2 01                    ; 0xc0522 vgarom.asm:1011
    sal dl, 1                                 ; d0 e2                       ; 0xc0525 vgarom.asm:1012
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0527 vgarom.asm:1013
    mov ds, ax                                ; 8e d8                       ; 0xc052a vgarom.asm:1014
    mov bx, 00089h                            ; bb 89 00                    ; 0xc052c vgarom.asm:1015
    mov al, byte [bx]                         ; 8a 07                       ; 0xc052f vgarom.asm:1016
    and AL, strict byte 0fdh                  ; 24 fd                       ; 0xc0531 vgarom.asm:1017
    db  00ah, 0c2h
    ; or al, dl                                 ; 0a c2                     ; 0xc0533 vgarom.asm:1018
    mov byte [bx], al                         ; 88 07                       ; 0xc0535 vgarom.asm:1019
    mov ax, 01212h                            ; b8 12 12                    ; 0xc0537 vgarom.asm:1020
    pop dx                                    ; 5a                          ; 0xc053a vgarom.asm:1021
    pop bx                                    ; 5b                          ; 0xc053b vgarom.asm:1022
    pop DS                                    ; 1f                          ; 0xc053c vgarom.asm:1023
    retn                                      ; c3                          ; 0xc053d vgarom.asm:1024
    push DS                                   ; 1e                          ; 0xc053e vgarom.asm:1028
    push bx                                   ; 53                          ; 0xc053f vgarom.asm:1029
    push dx                                   ; 52                          ; 0xc0540 vgarom.asm:1030
    db  08ah, 0d0h
    ; mov dl, al                                ; 8a d0                     ; 0xc0541 vgarom.asm:1031
    and dl, 001h                              ; 80 e2 01                    ; 0xc0543 vgarom.asm:1032
    xor dl, 001h                              ; 80 f2 01                    ; 0xc0546 vgarom.asm:1033
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0549 vgarom.asm:1034
    mov ds, ax                                ; 8e d8                       ; 0xc054c vgarom.asm:1035
    mov bx, 00089h                            ; bb 89 00                    ; 0xc054e vgarom.asm:1036
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0551 vgarom.asm:1037
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc0553 vgarom.asm:1038
    db  00ah, 0c2h
    ; or al, dl                                 ; 0a c2                     ; 0xc0555 vgarom.asm:1039
    mov byte [bx], al                         ; 88 07                       ; 0xc0557 vgarom.asm:1040
    mov ax, 01212h                            ; b8 12 12                    ; 0xc0559 vgarom.asm:1041
    pop dx                                    ; 5a                          ; 0xc055c vgarom.asm:1042
    pop bx                                    ; 5b                          ; 0xc055d vgarom.asm:1043
    pop DS                                    ; 1f                          ; 0xc055e vgarom.asm:1044
    retn                                      ; c3                          ; 0xc055f vgarom.asm:1045
    cmp AL, strict byte 000h                  ; 3c 00                       ; 0xc0560 vgarom.asm:1050
    je short 00569h                           ; 74 05                       ; 0xc0562 vgarom.asm:1051
    cmp AL, strict byte 001h                  ; 3c 01                       ; 0xc0564 vgarom.asm:1052
    je short 0057eh                           ; 74 16                       ; 0xc0566 vgarom.asm:1053
    retn                                      ; c3                          ; 0xc0568 vgarom.asm:1057
    push DS                                   ; 1e                          ; 0xc0569 vgarom.asm:1059
    push ax                                   ; 50                          ; 0xc056a vgarom.asm:1060
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc056b vgarom.asm:1061
    mov ds, ax                                ; 8e d8                       ; 0xc056e vgarom.asm:1062
    mov bx, 0008ah                            ; bb 8a 00                    ; 0xc0570 vgarom.asm:1063
    mov al, byte [bx]                         ; 8a 07                       ; 0xc0573 vgarom.asm:1064
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc0575 vgarom.asm:1065
    db  032h, 0ffh
    ; xor bh, bh                                ; 32 ff                     ; 0xc0577 vgarom.asm:1066
    pop ax                                    ; 58                          ; 0xc0579 vgarom.asm:1067
    db  08ah, 0c4h
    ; mov al, ah                                ; 8a c4                     ; 0xc057a vgarom.asm:1068
    pop DS                                    ; 1f                          ; 0xc057c vgarom.asm:1069
    retn                                      ; c3                          ; 0xc057d vgarom.asm:1070
    push DS                                   ; 1e                          ; 0xc057e vgarom.asm:1072
    push ax                                   ; 50                          ; 0xc057f vgarom.asm:1073
    push bx                                   ; 53                          ; 0xc0580 vgarom.asm:1074
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0581 vgarom.asm:1075
    mov ds, ax                                ; 8e d8                       ; 0xc0584 vgarom.asm:1076
    db  08bh, 0c3h
    ; mov ax, bx                                ; 8b c3                     ; 0xc0586 vgarom.asm:1077
    mov bx, 0008ah                            ; bb 8a 00                    ; 0xc0588 vgarom.asm:1078
    mov byte [bx], al                         ; 88 07                       ; 0xc058b vgarom.asm:1079
    pop bx                                    ; 5b                          ; 0xc058d vgarom.asm:1089
    pop ax                                    ; 58                          ; 0xc058e vgarom.asm:1090
    db  08ah, 0c4h
    ; mov al, ah                                ; 8a c4                     ; 0xc058f vgarom.asm:1091
    pop DS                                    ; 1f                          ; 0xc0591 vgarom.asm:1092
    retn                                      ; c3                          ; 0xc0592 vgarom.asm:1093
    times 0xd db 0
  ; disGetNextSymbol 0xc05a0 LB 0x3b8 -> off=0x0 cb=0000000000000007 uValue=00000000000c05a0 'do_out_dx_ax'
do_out_dx_ax:                                ; 0xc05a0 LB 0x7
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc05a0 vberom.asm:69
    out DX, AL                                ; ee                          ; 0xc05a2 vberom.asm:70
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc05a3 vberom.asm:71
    out DX, AL                                ; ee                          ; 0xc05a5 vberom.asm:72
    retn                                      ; c3                          ; 0xc05a6 vberom.asm:73
  ; disGetNextSymbol 0xc05a7 LB 0x3b1 -> off=0x0 cb=0000000000000043 uValue=00000000000c05a7 'do_in_ax_dx'
do_in_ax_dx:                                 ; 0xc05a7 LB 0x43
    in AL, DX                                 ; ec                          ; 0xc05a7 vberom.asm:76
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc05a8 vberom.asm:77
    in AL, DX                                 ; ec                          ; 0xc05aa vberom.asm:78
    retn                                      ; c3                          ; 0xc05ab vberom.asm:79
    push ax                                   ; 50                          ; 0xc05ac vberom.asm:90
    push dx                                   ; 52                          ; 0xc05ad vberom.asm:91
    mov dx, 003dah                            ; ba da 03                    ; 0xc05ae vberom.asm:92
    in AL, DX                                 ; ec                          ; 0xc05b1 vberom.asm:94
    test AL, strict byte 008h                 ; a8 08                       ; 0xc05b2 vberom.asm:95
    je short 005b1h                           ; 74 fb                       ; 0xc05b4 vberom.asm:96
    pop dx                                    ; 5a                          ; 0xc05b6 vberom.asm:97
    pop ax                                    ; 58                          ; 0xc05b7 vberom.asm:98
    retn                                      ; c3                          ; 0xc05b8 vberom.asm:99
    push ax                                   ; 50                          ; 0xc05b9 vberom.asm:102
    push dx                                   ; 52                          ; 0xc05ba vberom.asm:103
    mov dx, 003dah                            ; ba da 03                    ; 0xc05bb vberom.asm:104
    in AL, DX                                 ; ec                          ; 0xc05be vberom.asm:106
    test AL, strict byte 008h                 ; a8 08                       ; 0xc05bf vberom.asm:107
    jne short 005beh                          ; 75 fb                       ; 0xc05c1 vberom.asm:108
    pop dx                                    ; 5a                          ; 0xc05c3 vberom.asm:109
    pop ax                                    ; 58                          ; 0xc05c4 vberom.asm:110
    retn                                      ; c3                          ; 0xc05c5 vberom.asm:111
    push dx                                   ; 52                          ; 0xc05c6 vberom.asm:116
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc05c7 vberom.asm:117
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc05ca vberom.asm:118
    call 005a0h                               ; e8 d0 ff                    ; 0xc05cd vberom.asm:119
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc05d0 vberom.asm:120
    call 005a7h                               ; e8 d1 ff                    ; 0xc05d3 vberom.asm:121
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc05d6 vberom.asm:122
    jbe short 005e8h                          ; 76 0e                       ; 0xc05d8 vberom.asm:123
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc05da vberom.asm:124
    shr ah, 1                                 ; d0 ec                       ; 0xc05dc vberom.asm:128
    shr ah, 1                                 ; d0 ec                       ; 0xc05de vberom.asm:129
    shr ah, 1                                 ; d0 ec                       ; 0xc05e0 vberom.asm:130
    test AL, strict byte 007h                 ; a8 07                       ; 0xc05e2 vberom.asm:132
    je short 005e8h                           ; 74 02                       ; 0xc05e4 vberom.asm:133
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc05e6 vberom.asm:134
    pop dx                                    ; 5a                          ; 0xc05e8 vberom.asm:136
    retn                                      ; c3                          ; 0xc05e9 vberom.asm:137
  ; disGetNextSymbol 0xc05ea LB 0x36e -> off=0x0 cb=0000000000000026 uValue=00000000000c05ea '_dispi_get_max_bpp'
_dispi_get_max_bpp:                          ; 0xc05ea LB 0x26
    push dx                                   ; 52                          ; 0xc05ea vberom.asm:142
    push bx                                   ; 53                          ; 0xc05eb vberom.asm:143
    call 00624h                               ; e8 35 00                    ; 0xc05ec vberom.asm:144
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc05ef vberom.asm:145
    or ax, strict byte 00002h                 ; 83 c8 02                    ; 0xc05f1 vberom.asm:146
    call 00610h                               ; e8 19 00                    ; 0xc05f4 vberom.asm:147
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc05f7 vberom.asm:148
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc05fa vberom.asm:149
    call 005a0h                               ; e8 a0 ff                    ; 0xc05fd vberom.asm:150
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0600 vberom.asm:151
    call 005a7h                               ; e8 a1 ff                    ; 0xc0603 vberom.asm:152
    push ax                                   ; 50                          ; 0xc0606 vberom.asm:153
    db  08bh, 0c3h
    ; mov ax, bx                                ; 8b c3                     ; 0xc0607 vberom.asm:154
    call 00610h                               ; e8 04 00                    ; 0xc0609 vberom.asm:155
    pop ax                                    ; 58                          ; 0xc060c vberom.asm:156
    pop bx                                    ; 5b                          ; 0xc060d vberom.asm:157
    pop dx                                    ; 5a                          ; 0xc060e vberom.asm:158
    retn                                      ; c3                          ; 0xc060f vberom.asm:159
  ; disGetNextSymbol 0xc0610 LB 0x348 -> off=0x0 cb=0000000000000026 uValue=00000000000c0610 'dispi_set_enable_'
dispi_set_enable_:                           ; 0xc0610 LB 0x26
    push dx                                   ; 52                          ; 0xc0610 vberom.asm:162
    push ax                                   ; 50                          ; 0xc0611 vberom.asm:163
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0612 vberom.asm:164
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc0615 vberom.asm:165
    call 005a0h                               ; e8 85 ff                    ; 0xc0618 vberom.asm:166
    pop ax                                    ; 58                          ; 0xc061b vberom.asm:167
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc061c vberom.asm:168
    call 005a0h                               ; e8 7e ff                    ; 0xc061f vberom.asm:169
    pop dx                                    ; 5a                          ; 0xc0622 vberom.asm:170
    retn                                      ; c3                          ; 0xc0623 vberom.asm:171
    push dx                                   ; 52                          ; 0xc0624 vberom.asm:174
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0625 vberom.asm:175
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc0628 vberom.asm:176
    call 005a0h                               ; e8 72 ff                    ; 0xc062b vberom.asm:177
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc062e vberom.asm:178
    call 005a7h                               ; e8 73 ff                    ; 0xc0631 vberom.asm:179
    pop dx                                    ; 5a                          ; 0xc0634 vberom.asm:180
    retn                                      ; c3                          ; 0xc0635 vberom.asm:181
  ; disGetNextSymbol 0xc0636 LB 0x322 -> off=0x0 cb=0000000000000026 uValue=00000000000c0636 'dispi_set_bank_'
dispi_set_bank_:                             ; 0xc0636 LB 0x26
    push dx                                   ; 52                          ; 0xc0636 vberom.asm:184
    push ax                                   ; 50                          ; 0xc0637 vberom.asm:185
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0638 vberom.asm:186
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc063b vberom.asm:187
    call 005a0h                               ; e8 5f ff                    ; 0xc063e vberom.asm:188
    pop ax                                    ; 58                          ; 0xc0641 vberom.asm:189
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0642 vberom.asm:190
    call 005a0h                               ; e8 58 ff                    ; 0xc0645 vberom.asm:191
    pop dx                                    ; 5a                          ; 0xc0648 vberom.asm:192
    retn                                      ; c3                          ; 0xc0649 vberom.asm:193
    push dx                                   ; 52                          ; 0xc064a vberom.asm:196
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc064b vberom.asm:197
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc064e vberom.asm:198
    call 005a0h                               ; e8 4c ff                    ; 0xc0651 vberom.asm:199
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0654 vberom.asm:200
    call 005a7h                               ; e8 4d ff                    ; 0xc0657 vberom.asm:201
    pop dx                                    ; 5a                          ; 0xc065a vberom.asm:202
    retn                                      ; c3                          ; 0xc065b vberom.asm:203
  ; disGetNextSymbol 0xc065c LB 0x2fc -> off=0x0 cb=00000000000000ac uValue=00000000000c065c '_dispi_set_bank_farcall'
_dispi_set_bank_farcall:                     ; 0xc065c LB 0xac
    cmp bx, 00100h                            ; 81 fb 00 01                 ; 0xc065c vberom.asm:206
    je short 00686h                           ; 74 24                       ; 0xc0660 vberom.asm:207
    db  00bh, 0dbh
    ; or bx, bx                                 ; 0b db                     ; 0xc0662 vberom.asm:208
    jne short 00698h                          ; 75 32                       ; 0xc0664 vberom.asm:209
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc0666 vberom.asm:210
    push dx                                   ; 52                          ; 0xc0668 vberom.asm:211
    push ax                                   ; 50                          ; 0xc0669 vberom.asm:212
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc066a vberom.asm:213
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc066d vberom.asm:214
    call 005a0h                               ; e8 2d ff                    ; 0xc0670 vberom.asm:215
    pop ax                                    ; 58                          ; 0xc0673 vberom.asm:216
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0674 vberom.asm:217
    call 005a0h                               ; e8 26 ff                    ; 0xc0677 vberom.asm:218
    call 005a7h                               ; e8 2a ff                    ; 0xc067a vberom.asm:219
    pop dx                                    ; 5a                          ; 0xc067d vberom.asm:220
    db  03bh, 0d0h
    ; cmp dx, ax                                ; 3b d0                     ; 0xc067e vberom.asm:221
    jne short 00698h                          ; 75 16                       ; 0xc0680 vberom.asm:222
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0682 vberom.asm:223
    retf                                      ; cb                          ; 0xc0685 vberom.asm:224
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0686 vberom.asm:226
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0689 vberom.asm:227
    call 005a0h                               ; e8 11 ff                    ; 0xc068c vberom.asm:228
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc068f vberom.asm:229
    call 005a7h                               ; e8 12 ff                    ; 0xc0692 vberom.asm:230
    db  08bh, 0d0h
    ; mov dx, ax                                ; 8b d0                     ; 0xc0695 vberom.asm:231
    retf                                      ; cb                          ; 0xc0697 vberom.asm:232
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc0698 vberom.asm:234
    retf                                      ; cb                          ; 0xc069b vberom.asm:235
    push dx                                   ; 52                          ; 0xc069c vberom.asm:238
    push ax                                   ; 50                          ; 0xc069d vberom.asm:239
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc069e vberom.asm:240
    mov ax, strict word 00008h                ; b8 08 00                    ; 0xc06a1 vberom.asm:241
    call 005a0h                               ; e8 f9 fe                    ; 0xc06a4 vberom.asm:242
    pop ax                                    ; 58                          ; 0xc06a7 vberom.asm:243
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc06a8 vberom.asm:244
    call 005a0h                               ; e8 f2 fe                    ; 0xc06ab vberom.asm:245
    pop dx                                    ; 5a                          ; 0xc06ae vberom.asm:246
    retn                                      ; c3                          ; 0xc06af vberom.asm:247
    push dx                                   ; 52                          ; 0xc06b0 vberom.asm:250
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc06b1 vberom.asm:251
    mov ax, strict word 00008h                ; b8 08 00                    ; 0xc06b4 vberom.asm:252
    call 005a0h                               ; e8 e6 fe                    ; 0xc06b7 vberom.asm:253
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc06ba vberom.asm:254
    call 005a7h                               ; e8 e7 fe                    ; 0xc06bd vberom.asm:255
    pop dx                                    ; 5a                          ; 0xc06c0 vberom.asm:256
    retn                                      ; c3                          ; 0xc06c1 vberom.asm:257
    push dx                                   ; 52                          ; 0xc06c2 vberom.asm:260
    push ax                                   ; 50                          ; 0xc06c3 vberom.asm:261
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc06c4 vberom.asm:262
    mov ax, strict word 00009h                ; b8 09 00                    ; 0xc06c7 vberom.asm:263
    call 005a0h                               ; e8 d3 fe                    ; 0xc06ca vberom.asm:264
    pop ax                                    ; 58                          ; 0xc06cd vberom.asm:265
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc06ce vberom.asm:266
    call 005a0h                               ; e8 cc fe                    ; 0xc06d1 vberom.asm:267
    pop dx                                    ; 5a                          ; 0xc06d4 vberom.asm:268
    retn                                      ; c3                          ; 0xc06d5 vberom.asm:269
    push dx                                   ; 52                          ; 0xc06d6 vberom.asm:272
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc06d7 vberom.asm:273
    mov ax, strict word 00009h                ; b8 09 00                    ; 0xc06da vberom.asm:274
    call 005a0h                               ; e8 c0 fe                    ; 0xc06dd vberom.asm:275
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc06e0 vberom.asm:276
    call 005a7h                               ; e8 c1 fe                    ; 0xc06e3 vberom.asm:277
    pop dx                                    ; 5a                          ; 0xc06e6 vberom.asm:278
    retn                                      ; c3                          ; 0xc06e7 vberom.asm:279
    push ax                                   ; 50                          ; 0xc06e8 vberom.asm:282
    push bx                                   ; 53                          ; 0xc06e9 vberom.asm:283
    push dx                                   ; 52                          ; 0xc06ea vberom.asm:284
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc06eb vberom.asm:285
    call 005c6h                               ; e8 d6 fe                    ; 0xc06ed vberom.asm:286
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc06f0 vberom.asm:287
    jnbe short 006f6h                         ; 77 02                       ; 0xc06f2 vberom.asm:288
    shr bx, 1                                 ; d1 eb                       ; 0xc06f4 vberom.asm:289
    shr bx, 1                                 ; d1 eb                       ; 0xc06f6 vberom.asm:294
    shr bx, 1                                 ; d1 eb                       ; 0xc06f8 vberom.asm:295
    shr bx, 1                                 ; d1 eb                       ; 0xc06fa vberom.asm:296
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc06fc vberom.asm:298
    db  08ah, 0e3h
    ; mov ah, bl                                ; 8a e3                     ; 0xc06ff vberom.asm:299
    mov AL, strict byte 013h                  ; b0 13                       ; 0xc0701 vberom.asm:300
    out DX, ax                                ; ef                          ; 0xc0703 vberom.asm:301
    pop dx                                    ; 5a                          ; 0xc0704 vberom.asm:302
    pop bx                                    ; 5b                          ; 0xc0705 vberom.asm:303
    pop ax                                    ; 58                          ; 0xc0706 vberom.asm:304
    retn                                      ; c3                          ; 0xc0707 vberom.asm:305
  ; disGetNextSymbol 0xc0708 LB 0x250 -> off=0x0 cb=00000000000000f9 uValue=00000000000c0708 '_vga_compat_setup'
_vga_compat_setup:                           ; 0xc0708 LB 0xf9
    push ax                                   ; 50                          ; 0xc0708 vberom.asm:308
    push dx                                   ; 52                          ; 0xc0709 vberom.asm:309
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc070a vberom.asm:312
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc070d vberom.asm:313
    call 005a0h                               ; e8 8d fe                    ; 0xc0710 vberom.asm:314
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc0713 vberom.asm:315
    call 005a7h                               ; e8 8e fe                    ; 0xc0716 vberom.asm:316
    push ax                                   ; 50                          ; 0xc0719 vberom.asm:317
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc071a vberom.asm:318
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc071d vberom.asm:319
    out DX, ax                                ; ef                          ; 0xc0720 vberom.asm:320
    pop ax                                    ; 58                          ; 0xc0721 vberom.asm:321
    push ax                                   ; 50                          ; 0xc0722 vberom.asm:322
    shr ax, 1                                 ; d1 e8                       ; 0xc0723 vberom.asm:326
    shr ax, 1                                 ; d1 e8                       ; 0xc0725 vberom.asm:327
    shr ax, 1                                 ; d1 e8                       ; 0xc0727 vberom.asm:328
    dec ax                                    ; 48                          ; 0xc0729 vberom.asm:330
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc072a vberom.asm:331
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc072c vberom.asm:332
    out DX, ax                                ; ef                          ; 0xc072e vberom.asm:333
    pop ax                                    ; 58                          ; 0xc072f vberom.asm:334
    call 006e8h                               ; e8 b5 ff                    ; 0xc0730 vberom.asm:335
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc0733 vberom.asm:338
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc0736 vberom.asm:339
    call 005a0h                               ; e8 64 fe                    ; 0xc0739 vberom.asm:340
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc073c vberom.asm:341
    call 005a7h                               ; e8 65 fe                    ; 0xc073f vberom.asm:342
    dec ax                                    ; 48                          ; 0xc0742 vberom.asm:343
    push ax                                   ; 50                          ; 0xc0743 vberom.asm:344
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc0744 vberom.asm:345
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc0747 vberom.asm:346
    mov AL, strict byte 012h                  ; b0 12                       ; 0xc0749 vberom.asm:347
    out DX, ax                                ; ef                          ; 0xc074b vberom.asm:348
    pop ax                                    ; 58                          ; 0xc074c vberom.asm:349
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc074d vberom.asm:350
    out DX, AL                                ; ee                          ; 0xc074f vberom.asm:351
    inc dx                                    ; 42                          ; 0xc0750 vberom.asm:352
    in AL, DX                                 ; ec                          ; 0xc0751 vberom.asm:353
    and AL, strict byte 0bdh                  ; 24 bd                       ; 0xc0752 vberom.asm:354
    test ah, 001h                             ; f6 c4 01                    ; 0xc0754 vberom.asm:355
    je short 0075bh                           ; 74 02                       ; 0xc0757 vberom.asm:356
    or AL, strict byte 002h                   ; 0c 02                       ; 0xc0759 vberom.asm:357
    test ah, 002h                             ; f6 c4 02                    ; 0xc075b vberom.asm:359
    je short 00762h                           ; 74 02                       ; 0xc075e vberom.asm:360
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc0760 vberom.asm:361
    out DX, AL                                ; ee                          ; 0xc0762 vberom.asm:363
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc0763 vberom.asm:366
    mov ax, strict word 00009h                ; b8 09 00                    ; 0xc0766 vberom.asm:367
    out DX, AL                                ; ee                          ; 0xc0769 vberom.asm:368
    mov dx, 003d5h                            ; ba d5 03                    ; 0xc076a vberom.asm:369
    in AL, DX                                 ; ec                          ; 0xc076d vberom.asm:370
    and AL, strict byte 060h                  ; 24 60                       ; 0xc076e vberom.asm:371
    out DX, AL                                ; ee                          ; 0xc0770 vberom.asm:372
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc0771 vberom.asm:373
    mov AL, strict byte 017h                  ; b0 17                       ; 0xc0774 vberom.asm:374
    out DX, AL                                ; ee                          ; 0xc0776 vberom.asm:375
    mov dx, 003d5h                            ; ba d5 03                    ; 0xc0777 vberom.asm:376
    in AL, DX                                 ; ec                          ; 0xc077a vberom.asm:377
    or AL, strict byte 003h                   ; 0c 03                       ; 0xc077b vberom.asm:378
    out DX, AL                                ; ee                          ; 0xc077d vberom.asm:379
    mov dx, 003dah                            ; ba da 03                    ; 0xc077e vberom.asm:380
    in AL, DX                                 ; ec                          ; 0xc0781 vberom.asm:381
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc0782 vberom.asm:382
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc0785 vberom.asm:383
    out DX, AL                                ; ee                          ; 0xc0787 vberom.asm:384
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc0788 vberom.asm:385
    in AL, DX                                 ; ec                          ; 0xc078b vberom.asm:386
    or AL, strict byte 001h                   ; 0c 01                       ; 0xc078c vberom.asm:387
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc078e vberom.asm:388
    out DX, AL                                ; ee                          ; 0xc0791 vberom.asm:389
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc0792 vberom.asm:390
    out DX, AL                                ; ee                          ; 0xc0794 vberom.asm:391
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0795 vberom.asm:392
    mov ax, 00506h                            ; b8 06 05                    ; 0xc0798 vberom.asm:393
    out DX, ax                                ; ef                          ; 0xc079b vberom.asm:394
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc079c vberom.asm:395
    mov ax, 00f02h                            ; b8 02 0f                    ; 0xc079f vberom.asm:396
    out DX, ax                                ; ef                          ; 0xc07a2 vberom.asm:397
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc07a3 vberom.asm:400
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc07a6 vberom.asm:401
    call 005a0h                               ; e8 f4 fd                    ; 0xc07a9 vberom.asm:402
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc07ac vberom.asm:403
    call 005a7h                               ; e8 f5 fd                    ; 0xc07af vberom.asm:404
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc07b2 vberom.asm:405
    jc short 007f8h                           ; 72 42                       ; 0xc07b4 vberom.asm:406
    mov dx, 003d4h                            ; ba d4 03                    ; 0xc07b6 vberom.asm:407
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc07b9 vberom.asm:408
    out DX, AL                                ; ee                          ; 0xc07bb vberom.asm:409
    mov dx, 003d5h                            ; ba d5 03                    ; 0xc07bc vberom.asm:410
    in AL, DX                                 ; ec                          ; 0xc07bf vberom.asm:411
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc07c0 vberom.asm:412
    out DX, AL                                ; ee                          ; 0xc07c2 vberom.asm:413
    mov dx, 003dah                            ; ba da 03                    ; 0xc07c3 vberom.asm:414
    in AL, DX                                 ; ec                          ; 0xc07c6 vberom.asm:415
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc07c7 vberom.asm:416
    mov AL, strict byte 010h                  ; b0 10                       ; 0xc07ca vberom.asm:417
    out DX, AL                                ; ee                          ; 0xc07cc vberom.asm:418
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc07cd vberom.asm:419
    in AL, DX                                 ; ec                          ; 0xc07d0 vberom.asm:420
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc07d1 vberom.asm:421
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc07d3 vberom.asm:422
    out DX, AL                                ; ee                          ; 0xc07d6 vberom.asm:423
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc07d7 vberom.asm:424
    out DX, AL                                ; ee                          ; 0xc07d9 vberom.asm:425
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc07da vberom.asm:426
    mov AL, strict byte 004h                  ; b0 04                       ; 0xc07dd vberom.asm:427
    out DX, AL                                ; ee                          ; 0xc07df vberom.asm:428
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc07e0 vberom.asm:429
    in AL, DX                                 ; ec                          ; 0xc07e3 vberom.asm:430
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc07e4 vberom.asm:431
    out DX, AL                                ; ee                          ; 0xc07e6 vberom.asm:432
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc07e7 vberom.asm:433
    mov AL, strict byte 005h                  ; b0 05                       ; 0xc07ea vberom.asm:434
    out DX, AL                                ; ee                          ; 0xc07ec vberom.asm:435
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc07ed vberom.asm:436
    in AL, DX                                 ; ec                          ; 0xc07f0 vberom.asm:437
    and AL, strict byte 09fh                  ; 24 9f                       ; 0xc07f1 vberom.asm:438
    or AL, strict byte 040h                   ; 0c 40                       ; 0xc07f3 vberom.asm:439
    out DX, AL                                ; ee                          ; 0xc07f5 vberom.asm:440
    jmp short 007ffh                          ; eb 07                       ; 0xc07f6 vberom.asm:441
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc07f8 vberom.asm:446
    mov ax, 00107h                            ; b8 07 01                    ; 0xc07fb vberom.asm:447
    out DX, ax                                ; ef                          ; 0xc07fe vberom.asm:448
    pop dx                                    ; 5a                          ; 0xc07ff vberom.asm:451
    pop ax                                    ; 58                          ; 0xc0800 vberom.asm:452
  ; disGetNextSymbol 0xc0801 LB 0x157 -> off=0x0 cb=0000000000000013 uValue=00000000000c0801 '_vbe_has_vbe_display'
_vbe_has_vbe_display:                        ; 0xc0801 LB 0x13
    push DS                                   ; 1e                          ; 0xc0801 vberom.asm:458
    push bx                                   ; 53                          ; 0xc0802 vberom.asm:459
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0803 vberom.asm:460
    mov ds, ax                                ; 8e d8                       ; 0xc0806 vberom.asm:461
    mov bx, 000b9h                            ; bb b9 00                    ; 0xc0808 vberom.asm:462
    mov al, byte [bx]                         ; 8a 07                       ; 0xc080b vberom.asm:463
    and AL, strict byte 001h                  ; 24 01                       ; 0xc080d vberom.asm:464
    db  032h, 0e4h
    ; xor ah, ah                                ; 32 e4                     ; 0xc080f vberom.asm:465
    pop bx                                    ; 5b                          ; 0xc0811 vberom.asm:466
    pop DS                                    ; 1f                          ; 0xc0812 vberom.asm:467
    retn                                      ; c3                          ; 0xc0813 vberom.asm:468
  ; disGetNextSymbol 0xc0814 LB 0x144 -> off=0x0 cb=0000000000000025 uValue=00000000000c0814 'vbe_biosfn_return_current_mode'
vbe_biosfn_return_current_mode:              ; 0xc0814 LB 0x25
    push DS                                   ; 1e                          ; 0xc0814 vberom.asm:481
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0815 vberom.asm:482
    mov ds, ax                                ; 8e d8                       ; 0xc0818 vberom.asm:483
    call 00624h                               ; e8 07 fe                    ; 0xc081a vberom.asm:484
    and ax, strict byte 00001h                ; 83 e0 01                    ; 0xc081d vberom.asm:485
    je short 0082bh                           ; 74 09                       ; 0xc0820 vberom.asm:486
    mov bx, 000bah                            ; bb ba 00                    ; 0xc0822 vberom.asm:487
    mov ax, word [bx]                         ; 8b 07                       ; 0xc0825 vberom.asm:488
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc0827 vberom.asm:489
    jne short 00834h                          ; 75 09                       ; 0xc0829 vberom.asm:490
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc082b vberom.asm:492
    mov al, byte [bx]                         ; 8a 07                       ; 0xc082e vberom.asm:493
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc0830 vberom.asm:494
    db  032h, 0ffh
    ; xor bh, bh                                ; 32 ff                     ; 0xc0832 vberom.asm:495
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0834 vberom.asm:497
    pop DS                                    ; 1f                          ; 0xc0837 vberom.asm:498
    retn                                      ; c3                          ; 0xc0838 vberom.asm:499
  ; disGetNextSymbol 0xc0839 LB 0x11f -> off=0x0 cb=000000000000002d uValue=00000000000c0839 'vbe_biosfn_display_window_control'
vbe_biosfn_display_window_control:           ; 0xc0839 LB 0x2d
    cmp bl, 000h                              ; 80 fb 00                    ; 0xc0839 vberom.asm:523
    jne short 00862h                          ; 75 24                       ; 0xc083c vberom.asm:524
    cmp bh, 001h                              ; 80 ff 01                    ; 0xc083e vberom.asm:525
    je short 00859h                           ; 74 16                       ; 0xc0841 vberom.asm:526
    jc short 00849h                           ; 72 04                       ; 0xc0843 vberom.asm:527
    mov ax, 00100h                            ; b8 00 01                    ; 0xc0845 vberom.asm:528
    retn                                      ; c3                          ; 0xc0848 vberom.asm:529
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc0849 vberom.asm:531
    call 00636h                               ; e8 e8 fd                    ; 0xc084b vberom.asm:532
    call 0064ah                               ; e8 f9 fd                    ; 0xc084e vberom.asm:533
    db  03bh, 0c2h
    ; cmp ax, dx                                ; 3b c2                     ; 0xc0851 vberom.asm:534
    jne short 00862h                          ; 75 0d                       ; 0xc0853 vberom.asm:535
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0855 vberom.asm:536
    retn                                      ; c3                          ; 0xc0858 vberom.asm:537
    call 0064ah                               ; e8 ee fd                    ; 0xc0859 vberom.asm:539
    db  08bh, 0d0h
    ; mov dx, ax                                ; 8b d0                     ; 0xc085c vberom.asm:540
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc085e vberom.asm:541
    retn                                      ; c3                          ; 0xc0861 vberom.asm:542
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc0862 vberom.asm:544
    retn                                      ; c3                          ; 0xc0865 vberom.asm:545
  ; disGetNextSymbol 0xc0866 LB 0xf2 -> off=0x0 cb=0000000000000034 uValue=00000000000c0866 'vbe_biosfn_set_get_display_start'
vbe_biosfn_set_get_display_start:            ; 0xc0866 LB 0x34
    cmp bl, 080h                              ; 80 fb 80                    ; 0xc0866 vberom.asm:585
    je short 00876h                           ; 74 0b                       ; 0xc0869 vberom.asm:586
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc086b vberom.asm:587
    je short 0088ah                           ; 74 1a                       ; 0xc086e vberom.asm:588
    jc short 0087ch                           ; 72 0a                       ; 0xc0870 vberom.asm:589
    mov ax, 00100h                            ; b8 00 01                    ; 0xc0872 vberom.asm:590
    retn                                      ; c3                          ; 0xc0875 vberom.asm:591
    call 005b9h                               ; e8 40 fd                    ; 0xc0876 vberom.asm:593
    call 005ach                               ; e8 30 fd                    ; 0xc0879 vberom.asm:594
    db  08bh, 0c1h
    ; mov ax, cx                                ; 8b c1                     ; 0xc087c vberom.asm:596
    call 0069ch                               ; e8 1b fe                    ; 0xc087e vberom.asm:597
    db  08bh, 0c2h
    ; mov ax, dx                                ; 8b c2                     ; 0xc0881 vberom.asm:598
    call 006c2h                               ; e8 3c fe                    ; 0xc0883 vberom.asm:599
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0886 vberom.asm:600
    retn                                      ; c3                          ; 0xc0889 vberom.asm:601
    call 006b0h                               ; e8 23 fe                    ; 0xc088a vberom.asm:603
    db  08bh, 0c8h
    ; mov cx, ax                                ; 8b c8                     ; 0xc088d vberom.asm:604
    call 006d6h                               ; e8 44 fe                    ; 0xc088f vberom.asm:605
    db  08bh, 0d0h
    ; mov dx, ax                                ; 8b d0                     ; 0xc0892 vberom.asm:606
    db  032h, 0ffh
    ; xor bh, bh                                ; 32 ff                     ; 0xc0894 vberom.asm:607
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0896 vberom.asm:608
    retn                                      ; c3                          ; 0xc0899 vberom.asm:609
  ; disGetNextSymbol 0xc089a LB 0xbe -> off=0x0 cb=0000000000000037 uValue=00000000000c089a 'vbe_biosfn_set_get_dac_palette_format'
vbe_biosfn_set_get_dac_palette_format:       ; 0xc089a LB 0x37
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc089a vberom.asm:624
    je short 008bdh                           ; 74 1e                       ; 0xc089d vberom.asm:625
    jc short 008a5h                           ; 72 04                       ; 0xc089f vberom.asm:626
    mov ax, 00100h                            ; b8 00 01                    ; 0xc08a1 vberom.asm:627
    retn                                      ; c3                          ; 0xc08a4 vberom.asm:628
    call 00624h                               ; e8 7c fd                    ; 0xc08a5 vberom.asm:630
    cmp bh, 006h                              ; 80 ff 06                    ; 0xc08a8 vberom.asm:631
    je short 008b7h                           ; 74 0a                       ; 0xc08ab vberom.asm:632
    cmp bh, 008h                              ; 80 ff 08                    ; 0xc08ad vberom.asm:633
    jne short 008cdh                          ; 75 1b                       ; 0xc08b0 vberom.asm:634
    or ax, strict byte 00020h                 ; 83 c8 20                    ; 0xc08b2 vberom.asm:635
    jne short 008bah                          ; 75 03                       ; 0xc08b5 vberom.asm:636
    and ax, strict byte 0ffdfh                ; 83 e0 df                    ; 0xc08b7 vberom.asm:638
    call 00610h                               ; e8 53 fd                    ; 0xc08ba vberom.asm:640
    mov BH, strict byte 006h                  ; b7 06                       ; 0xc08bd vberom.asm:642
    call 00624h                               ; e8 62 fd                    ; 0xc08bf vberom.asm:643
    and ax, strict byte 00020h                ; 83 e0 20                    ; 0xc08c2 vberom.asm:644
    je short 008c9h                           ; 74 02                       ; 0xc08c5 vberom.asm:645
    mov BH, strict byte 008h                  ; b7 08                       ; 0xc08c7 vberom.asm:646
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc08c9 vberom.asm:648
    retn                                      ; c3                          ; 0xc08cc vberom.asm:649
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc08cd vberom.asm:651
    retn                                      ; c3                          ; 0xc08d0 vberom.asm:652
  ; disGetNextSymbol 0xc08d1 LB 0x87 -> off=0x0 cb=0000000000000073 uValue=00000000000c08d1 'vbe_biosfn_set_get_palette_data'
vbe_biosfn_set_get_palette_data:             ; 0xc08d1 LB 0x73
    test bl, bl                               ; 84 db                       ; 0xc08d1 vberom.asm:691
    je short 008e4h                           ; 74 0f                       ; 0xc08d3 vberom.asm:692
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc08d5 vberom.asm:693
    je short 00912h                           ; 74 38                       ; 0xc08d8 vberom.asm:694
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc08da vberom.asm:695
    jbe short 00940h                          ; 76 61                       ; 0xc08dd vberom.asm:696
    cmp bl, 080h                              ; 80 fb 80                    ; 0xc08df vberom.asm:697
    jne short 0093ch                          ; 75 58                       ; 0xc08e2 vberom.asm:698
    push ax                                   ; 50                          ; 0xc08e4 vberom.asm:145
    push cx                                   ; 51                          ; 0xc08e5 vberom.asm:146
    push dx                                   ; 52                          ; 0xc08e6 vberom.asm:147
    push bx                                   ; 53                          ; 0xc08e7 vberom.asm:148
    push sp                                   ; 54                          ; 0xc08e8 vberom.asm:149
    push bp                                   ; 55                          ; 0xc08e9 vberom.asm:150
    push si                                   ; 56                          ; 0xc08ea vberom.asm:151
    push di                                   ; 57                          ; 0xc08eb vberom.asm:152
    push DS                                   ; 1e                          ; 0xc08ec vberom.asm:704
    push ES                                   ; 06                          ; 0xc08ed vberom.asm:705
    pop DS                                    ; 1f                          ; 0xc08ee vberom.asm:706
    db  08ah, 0c2h
    ; mov al, dl                                ; 8a c2                     ; 0xc08ef vberom.asm:707
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc08f1 vberom.asm:708
    out DX, AL                                ; ee                          ; 0xc08f4 vberom.asm:709
    inc dx                                    ; 42                          ; 0xc08f5 vberom.asm:710
    db  08bh, 0f7h
    ; mov si, di                                ; 8b f7                     ; 0xc08f6 vberom.asm:711
    lodsw                                     ; ad                          ; 0xc08f8 vberom.asm:722
    db  08bh, 0d8h
    ; mov bx, ax                                ; 8b d8                     ; 0xc08f9 vberom.asm:723
    lodsw                                     ; ad                          ; 0xc08fb vberom.asm:724
    out DX, AL                                ; ee                          ; 0xc08fc vberom.asm:725
    db  08ah, 0c7h
    ; mov al, bh                                ; 8a c7                     ; 0xc08fd vberom.asm:726
    out DX, AL                                ; ee                          ; 0xc08ff vberom.asm:727
    db  08ah, 0c3h
    ; mov al, bl                                ; 8a c3                     ; 0xc0900 vberom.asm:728
    out DX, AL                                ; ee                          ; 0xc0902 vberom.asm:729
    loop 008f8h                               ; e2 f3                       ; 0xc0903 vberom.asm:731
    pop DS                                    ; 1f                          ; 0xc0905 vberom.asm:732
    pop di                                    ; 5f                          ; 0xc0906 vberom.asm:164
    pop si                                    ; 5e                          ; 0xc0907 vberom.asm:165
    pop bp                                    ; 5d                          ; 0xc0908 vberom.asm:166
    pop bx                                    ; 5b                          ; 0xc0909 vberom.asm:167
    pop bx                                    ; 5b                          ; 0xc090a vberom.asm:168
    pop dx                                    ; 5a                          ; 0xc090b vberom.asm:169
    pop cx                                    ; 59                          ; 0xc090c vberom.asm:170
    pop ax                                    ; 58                          ; 0xc090d vberom.asm:171
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc090e vberom.asm:735
    retn                                      ; c3                          ; 0xc0911 vberom.asm:736
    push ax                                   ; 50                          ; 0xc0912 vberom.asm:145
    push cx                                   ; 51                          ; 0xc0913 vberom.asm:146
    push dx                                   ; 52                          ; 0xc0914 vberom.asm:147
    push bx                                   ; 53                          ; 0xc0915 vberom.asm:148
    push sp                                   ; 54                          ; 0xc0916 vberom.asm:149
    push bp                                   ; 55                          ; 0xc0917 vberom.asm:150
    push si                                   ; 56                          ; 0xc0918 vberom.asm:151
    push di                                   ; 57                          ; 0xc0919 vberom.asm:152
    db  08ah, 0c2h
    ; mov al, dl                                ; 8a c2                     ; 0xc091a vberom.asm:740
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc091c vberom.asm:741
    out DX, AL                                ; ee                          ; 0xc091f vberom.asm:742
    add dl, 002h                              ; 80 c2 02                    ; 0xc0920 vberom.asm:743
    db  033h, 0dbh
    ; xor bx, bx                                ; 33 db                     ; 0xc0923 vberom.asm:754
    in AL, DX                                 ; ec                          ; 0xc0925 vberom.asm:756
    db  08ah, 0d8h
    ; mov bl, al                                ; 8a d8                     ; 0xc0926 vberom.asm:757
    in AL, DX                                 ; ec                          ; 0xc0928 vberom.asm:758
    db  08ah, 0e0h
    ; mov ah, al                                ; 8a e0                     ; 0xc0929 vberom.asm:759
    in AL, DX                                 ; ec                          ; 0xc092b vberom.asm:760
    stosw                                     ; ab                          ; 0xc092c vberom.asm:761
    db  08bh, 0c3h
    ; mov ax, bx                                ; 8b c3                     ; 0xc092d vberom.asm:762
    stosw                                     ; ab                          ; 0xc092f vberom.asm:763
    loop 00925h                               ; e2 f3                       ; 0xc0930 vberom.asm:765
    pop di                                    ; 5f                          ; 0xc0932 vberom.asm:164
    pop si                                    ; 5e                          ; 0xc0933 vberom.asm:165
    pop bp                                    ; 5d                          ; 0xc0934 vberom.asm:166
    pop bx                                    ; 5b                          ; 0xc0935 vberom.asm:167
    pop bx                                    ; 5b                          ; 0xc0936 vberom.asm:168
    pop dx                                    ; 5a                          ; 0xc0937 vberom.asm:169
    pop cx                                    ; 59                          ; 0xc0938 vberom.asm:170
    pop ax                                    ; 58                          ; 0xc0939 vberom.asm:171
    jmp short 0090eh                          ; eb d2                       ; 0xc093a vberom.asm:767
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc093c vberom.asm:770
    retn                                      ; c3                          ; 0xc093f vberom.asm:771
    mov ax, 0024fh                            ; b8 4f 02                    ; 0xc0940 vberom.asm:773
    retn                                      ; c3                          ; 0xc0943 vberom.asm:774
  ; disGetNextSymbol 0xc0944 LB 0x14 -> off=0x0 cb=0000000000000014 uValue=00000000000c0944 'vbe_biosfn_return_protected_mode_interface'
vbe_biosfn_return_protected_mode_interface: ; 0xc0944 LB 0x14
    test bl, bl                               ; 84 db                       ; 0xc0944 vberom.asm:788
    jne short 00954h                          ; 75 0c                       ; 0xc0946 vberom.asm:789
    push CS                                   ; 0e                          ; 0xc0948 vberom.asm:790
    pop ES                                    ; 07                          ; 0xc0949 vberom.asm:791
    mov di, 04640h                            ; bf 40 46                    ; 0xc094a vberom.asm:792
    mov cx, 00115h                            ; b9 15 01                    ; 0xc094d vberom.asm:793
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc0950 vberom.asm:794
    retn                                      ; c3                          ; 0xc0953 vberom.asm:795
    mov ax, 0014fh                            ; b8 4f 01                    ; 0xc0954 vberom.asm:797
    retn                                      ; c3                          ; 0xc0957 vberom.asm:798

  ; Padding 0x98 bytes at 0xc0958
  times 152 db 0

section _TEXT progbits vstart=0x9f0 align=1 ; size=0x3b02 class=CODE group=AUTO
  ; disGetNextSymbol 0xc09f0 LB 0x3b02 -> off=0x0 cb=000000000000001c uValue=00000000000c09f0 'set_int_vector'
set_int_vector:                              ; 0xc09f0 LB 0x1c
    push dx                                   ; 52                          ; 0xc09f0 vgabios.c:87
    push bp                                   ; 55                          ; 0xc09f1
    mov bp, sp                                ; 89 e5                       ; 0xc09f2
    mov dx, bx                                ; 89 da                       ; 0xc09f4
    mov bl, al                                ; 88 c3                       ; 0xc09f6 vgabios.c:91
    xor bh, bh                                ; 30 ff                       ; 0xc09f8
    sal bx, 1                                 ; d1 e3                       ; 0xc09fa
    sal bx, 1                                 ; d1 e3                       ; 0xc09fc
    xor ax, ax                                ; 31 c0                       ; 0xc09fe
    mov es, ax                                ; 8e c0                       ; 0xc0a00
    mov word [es:bx], dx                      ; 26 89 17                    ; 0xc0a02
    mov word [es:bx+002h], cx                 ; 26 89 4f 02                 ; 0xc0a05
    pop bp                                    ; 5d                          ; 0xc0a09 vgabios.c:92
    pop dx                                    ; 5a                          ; 0xc0a0a
    retn                                      ; c3                          ; 0xc0a0b
  ; disGetNextSymbol 0xc0a0c LB 0x3ae6 -> off=0x0 cb=000000000000001c uValue=00000000000c0a0c 'init_vga_card'
init_vga_card:                               ; 0xc0a0c LB 0x1c
    push bp                                   ; 55                          ; 0xc0a0c vgabios.c:143
    mov bp, sp                                ; 89 e5                       ; 0xc0a0d
    push dx                                   ; 52                          ; 0xc0a0f
    mov AL, strict byte 0c3h                  ; b0 c3                       ; 0xc0a10 vgabios.c:146
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc0a12
    out DX, AL                                ; ee                          ; 0xc0a15
    mov AL, strict byte 004h                  ; b0 04                       ; 0xc0a16 vgabios.c:149
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc0a18
    out DX, AL                                ; ee                          ; 0xc0a1b
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc0a1c vgabios.c:150
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc0a1e
    out DX, AL                                ; ee                          ; 0xc0a21
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc0a22 vgabios.c:155
    pop dx                                    ; 5a                          ; 0xc0a25
    pop bp                                    ; 5d                          ; 0xc0a26
    retn                                      ; c3                          ; 0xc0a27
  ; disGetNextSymbol 0xc0a28 LB 0x3aca -> off=0x0 cb=000000000000003e uValue=00000000000c0a28 'init_bios_area'
init_bios_area:                              ; 0xc0a28 LB 0x3e
    push bx                                   ; 53                          ; 0xc0a28 vgabios.c:221
    push bp                                   ; 55                          ; 0xc0a29
    mov bp, sp                                ; 89 e5                       ; 0xc0a2a
    xor bx, bx                                ; 31 db                       ; 0xc0a2c vgabios.c:225
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0a2e
    mov es, ax                                ; 8e c0                       ; 0xc0a31
    mov al, byte [es:bx+010h]                 ; 26 8a 47 10                 ; 0xc0a33 vgabios.c:228
    and AL, strict byte 0cfh                  ; 24 cf                       ; 0xc0a37
    or AL, strict byte 020h                   ; 0c 20                       ; 0xc0a39
    mov byte [es:bx+010h], al                 ; 26 88 47 10                 ; 0xc0a3b
    mov byte [es:bx+00085h], 010h             ; 26 c6 87 85 00 10           ; 0xc0a3f vgabios.c:232
    mov word [es:bx+00087h], 0f960h           ; 26 c7 87 87 00 60 f9        ; 0xc0a45 vgabios.c:234
    mov byte [es:bx+00089h], 051h             ; 26 c6 87 89 00 51           ; 0xc0a4c vgabios.c:238
    mov byte [es:bx+065h], 009h               ; 26 c6 47 65 09              ; 0xc0a52 vgabios.c:240
    mov word [es:bx+000a8h], 0554eh           ; 26 c7 87 a8 00 4e 55        ; 0xc0a57 vgabios.c:242
    mov [es:bx+000aah], ds                    ; 26 8c 9f aa 00              ; 0xc0a5e
    pop bp                                    ; 5d                          ; 0xc0a63 vgabios.c:243
    pop bx                                    ; 5b                          ; 0xc0a64
    retn                                      ; c3                          ; 0xc0a65
  ; disGetNextSymbol 0xc0a66 LB 0x3a8c -> off=0x0 cb=0000000000000031 uValue=00000000000c0a66 'vgabios_init_func'
vgabios_init_func:                           ; 0xc0a66 LB 0x31
    inc bp                                    ; 45                          ; 0xc0a66 vgabios.c:250
    push bp                                   ; 55                          ; 0xc0a67
    mov bp, sp                                ; 89 e5                       ; 0xc0a68
    call 00a0ch                               ; e8 9f ff                    ; 0xc0a6a vgabios.c:252
    call 00a28h                               ; e8 b8 ff                    ; 0xc0a6d vgabios.c:253
    call 03e59h                               ; e8 e6 33                    ; 0xc0a70 vgabios.c:255
    mov bx, strict word 00028h                ; bb 28 00                    ; 0xc0a73 vgabios.c:257
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0a76
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc0a79
    call 009f0h                               ; e8 71 ff                    ; 0xc0a7c
    mov bx, strict word 00028h                ; bb 28 00                    ; 0xc0a7f vgabios.c:258
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0a82
    mov ax, strict word 0006dh                ; b8 6d 00                    ; 0xc0a85
    call 009f0h                               ; e8 65 ff                    ; 0xc0a88
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc0a8b vgabios.c:284
    db  032h, 0e4h
    ; xor ah, ah                                ; 32 e4                     ; 0xc0a8e
    int 010h                                  ; cd 10                       ; 0xc0a90
    mov sp, bp                                ; 89 ec                       ; 0xc0a92 vgabios.c:287
    pop bp                                    ; 5d                          ; 0xc0a94
    dec bp                                    ; 4d                          ; 0xc0a95
    retf                                      ; cb                          ; 0xc0a96
  ; disGetNextSymbol 0xc0a97 LB 0x3a5b -> off=0x0 cb=000000000000002e uValue=00000000000c0a97 'vga_get_cursor_pos'
vga_get_cursor_pos:                          ; 0xc0a97 LB 0x2e
    push si                                   ; 56                          ; 0xc0a97 vgabios.c:356
    push di                                   ; 57                          ; 0xc0a98
    push bp                                   ; 55                          ; 0xc0a99
    mov bp, sp                                ; 89 e5                       ; 0xc0a9a
    mov si, dx                                ; 89 d6                       ; 0xc0a9c
    mov di, strict word 00060h                ; bf 60 00                    ; 0xc0a9e vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc0aa1
    mov es, dx                                ; 8e c2                       ; 0xc0aa4
    mov di, word [es:di]                      ; 26 8b 3d                    ; 0xc0aa6
    push SS                                   ; 16                          ; 0xc0aa9 vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0aaa
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc0aab
    xor ah, ah                                ; 30 e4                       ; 0xc0aae vgabios.c:360
    mov si, ax                                ; 89 c6                       ; 0xc0ab0
    sal si, 1                                 ; d1 e6                       ; 0xc0ab2
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc0ab4
    mov es, dx                                ; 8e c2                       ; 0xc0ab7 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc0ab9
    push SS                                   ; 16                          ; 0xc0abc vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0abd
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0abe
    pop bp                                    ; 5d                          ; 0xc0ac1 vgabios.c:361
    pop di                                    ; 5f                          ; 0xc0ac2
    pop si                                    ; 5e                          ; 0xc0ac3
    retn                                      ; c3                          ; 0xc0ac4
  ; disGetNextSymbol 0xc0ac5 LB 0x3a2d -> off=0x0 cb=000000000000005e uValue=00000000000c0ac5 'vga_find_glyph'
vga_find_glyph:                              ; 0xc0ac5 LB 0x5e
    push bp                                   ; 55                          ; 0xc0ac5 vgabios.c:364
    mov bp, sp                                ; 89 e5                       ; 0xc0ac6
    push si                                   ; 56                          ; 0xc0ac8
    push di                                   ; 57                          ; 0xc0ac9
    push ax                                   ; 50                          ; 0xc0aca
    push ax                                   ; 50                          ; 0xc0acb
    push dx                                   ; 52                          ; 0xc0acc
    push bx                                   ; 53                          ; 0xc0acd
    mov bl, cl                                ; 88 cb                       ; 0xc0ace
    mov word [bp-006h], strict word 00000h    ; c7 46 fa 00 00              ; 0xc0ad0 vgabios.c:366
    dec word [bp+004h]                        ; ff 4e 04                    ; 0xc0ad5 vgabios.c:368
    cmp word [bp+004h], strict byte 0ffffh    ; 83 7e 04 ff                 ; 0xc0ad8
    je short 00b17h                           ; 74 39                       ; 0xc0adc
    mov cl, byte [bp+006h]                    ; 8a 4e 06                    ; 0xc0ade vgabios.c:369
    xor ch, ch                                ; 30 ed                       ; 0xc0ae1
    mov dx, ss                                ; 8c d2                       ; 0xc0ae3
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc0ae5
    mov di, word [bp-008h]                    ; 8b 7e f8                    ; 0xc0ae8
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc0aeb
    push DS                                   ; 1e                          ; 0xc0aee
    mov ds, dx                                ; 8e da                       ; 0xc0aef
    rep cmpsb                                 ; f3 a6                       ; 0xc0af1
    pop DS                                    ; 1f                          ; 0xc0af3
    mov ax, strict word 00000h                ; b8 00 00                    ; 0xc0af4
    je short 00afbh                           ; 74 02                       ; 0xc0af7
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc0af9
    test ax, ax                               ; 85 c0                       ; 0xc0afb
    jne short 00b0bh                          ; 75 0c                       ; 0xc0afd
    mov al, bl                                ; 88 d8                       ; 0xc0aff vgabios.c:370
    xor ah, ah                                ; 30 e4                       ; 0xc0b01
    or ah, 080h                               ; 80 cc 80                    ; 0xc0b03
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0b06
    jmp short 00b17h                          ; eb 0c                       ; 0xc0b09 vgabios.c:371
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc0b0b vgabios.c:373
    xor ah, ah                                ; 30 e4                       ; 0xc0b0e
    add word [bp-008h], ax                    ; 01 46 f8                    ; 0xc0b10
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc0b13 vgabios.c:374
    jmp short 00ad5h                          ; eb be                       ; 0xc0b15 vgabios.c:375
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc0b17 vgabios.c:377
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0b1a
    pop di                                    ; 5f                          ; 0xc0b1d
    pop si                                    ; 5e                          ; 0xc0b1e
    pop bp                                    ; 5d                          ; 0xc0b1f
    retn 00004h                               ; c2 04 00                    ; 0xc0b20
  ; disGetNextSymbol 0xc0b23 LB 0x39cf -> off=0x0 cb=0000000000000046 uValue=00000000000c0b23 'vga_read_glyph_planar'
vga_read_glyph_planar:                       ; 0xc0b23 LB 0x46
    push bp                                   ; 55                          ; 0xc0b23 vgabios.c:379
    mov bp, sp                                ; 89 e5                       ; 0xc0b24
    push si                                   ; 56                          ; 0xc0b26
    push di                                   ; 57                          ; 0xc0b27
    push ax                                   ; 50                          ; 0xc0b28
    push ax                                   ; 50                          ; 0xc0b29
    mov si, ax                                ; 89 c6                       ; 0xc0b2a
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc0b2c
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc0b2f
    mov bx, cx                                ; 89 cb                       ; 0xc0b32
    mov ax, 00805h                            ; b8 05 08                    ; 0xc0b34 vgabios.c:386
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0b37
    out DX, ax                                ; ef                          ; 0xc0b3a
    dec byte [bp+004h]                        ; fe 4e 04                    ; 0xc0b3b vgabios.c:388
    cmp byte [bp+004h], 0ffh                  ; 80 7e 04 ff                 ; 0xc0b3e
    je short 00b59h                           ; 74 15                       ; 0xc0b42
    mov es, [bp-006h]                         ; 8e 46 fa                    ; 0xc0b44 vgabios.c:389
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc0b47
    not al                                    ; f6 d0                       ; 0xc0b4a
    mov di, bx                                ; 89 df                       ; 0xc0b4c
    inc bx                                    ; 43                          ; 0xc0b4e
    push SS                                   ; 16                          ; 0xc0b4f
    pop ES                                    ; 07                          ; 0xc0b50
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0b51
    add si, word [bp-008h]                    ; 03 76 f8                    ; 0xc0b54 vgabios.c:390
    jmp short 00b3bh                          ; eb e2                       ; 0xc0b57 vgabios.c:391
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc0b59 vgabios.c:394
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc0b5c
    out DX, ax                                ; ef                          ; 0xc0b5f
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0b60 vgabios.c:395
    pop di                                    ; 5f                          ; 0xc0b63
    pop si                                    ; 5e                          ; 0xc0b64
    pop bp                                    ; 5d                          ; 0xc0b65
    retn 00002h                               ; c2 02 00                    ; 0xc0b66
  ; disGetNextSymbol 0xc0b69 LB 0x3989 -> off=0x0 cb=000000000000002f uValue=00000000000c0b69 'vga_char_ofs_planar'
vga_char_ofs_planar:                         ; 0xc0b69 LB 0x2f
    push si                                   ; 56                          ; 0xc0b69 vgabios.c:397
    push bp                                   ; 55                          ; 0xc0b6a
    mov bp, sp                                ; 89 e5                       ; 0xc0b6b
    mov ch, al                                ; 88 c5                       ; 0xc0b6d
    mov al, dl                                ; 88 d0                       ; 0xc0b6f
    xor ah, ah                                ; 30 e4                       ; 0xc0b71 vgabios.c:401
    mul bx                                    ; f7 e3                       ; 0xc0b73
    mov bl, byte [bp+006h]                    ; 8a 5e 06                    ; 0xc0b75
    xor bh, bh                                ; 30 ff                       ; 0xc0b78
    mul bx                                    ; f7 e3                       ; 0xc0b7a
    mov bl, ch                                ; 88 eb                       ; 0xc0b7c
    add bx, ax                                ; 01 c3                       ; 0xc0b7e
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc0b80 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0b83
    mov es, ax                                ; 8e c0                       ; 0xc0b86
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc0b88
    mov al, cl                                ; 88 c8                       ; 0xc0b8b vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc0b8d
    mul si                                    ; f7 e6                       ; 0xc0b8f
    add ax, bx                                ; 01 d8                       ; 0xc0b91
    pop bp                                    ; 5d                          ; 0xc0b93 vgabios.c:405
    pop si                                    ; 5e                          ; 0xc0b94
    retn 00002h                               ; c2 02 00                    ; 0xc0b95
  ; disGetNextSymbol 0xc0b98 LB 0x395a -> off=0x0 cb=0000000000000045 uValue=00000000000c0b98 'vga_read_char_planar'
vga_read_char_planar:                        ; 0xc0b98 LB 0x45
    push bp                                   ; 55                          ; 0xc0b98 vgabios.c:407
    mov bp, sp                                ; 89 e5                       ; 0xc0b99
    push cx                                   ; 51                          ; 0xc0b9b
    push si                                   ; 56                          ; 0xc0b9c
    sub sp, strict byte 00012h                ; 83 ec 12                    ; 0xc0b9d
    mov si, ax                                ; 89 c6                       ; 0xc0ba0
    mov ax, dx                                ; 89 d0                       ; 0xc0ba2
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc0ba4 vgabios.c:411
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc0ba7
    push word [bp-006h]                       ; ff 76 fa                    ; 0xc0bab
    lea cx, [bp-016h]                         ; 8d 4e ea                    ; 0xc0bae
    mov bx, si                                ; 89 f3                       ; 0xc0bb1
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc0bb3
    call 00b23h                               ; e8 6a ff                    ; 0xc0bb6
    push word [bp-006h]                       ; ff 76 fa                    ; 0xc0bb9 vgabios.c:414
    mov ax, 00100h                            ; b8 00 01                    ; 0xc0bbc
    push ax                                   ; 50                          ; 0xc0bbf
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0bc0 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0bc3
    mov es, ax                                ; 8e c0                       ; 0xc0bc5
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0bc7
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0bca
    xor cx, cx                                ; 31 c9                       ; 0xc0bce vgabios.c:68
    lea bx, [bp-016h]                         ; 8d 5e ea                    ; 0xc0bd0
    call 00ac5h                               ; e8 ef fe                    ; 0xc0bd3
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0bd6 vgabios.c:415
    pop si                                    ; 5e                          ; 0xc0bd9
    pop cx                                    ; 59                          ; 0xc0bda
    pop bp                                    ; 5d                          ; 0xc0bdb
    retn                                      ; c3                          ; 0xc0bdc
  ; disGetNextSymbol 0xc0bdd LB 0x3915 -> off=0x0 cb=0000000000000027 uValue=00000000000c0bdd 'vga_char_ofs_linear'
vga_char_ofs_linear:                         ; 0xc0bdd LB 0x27
    push bp                                   ; 55                          ; 0xc0bdd vgabios.c:417
    mov bp, sp                                ; 89 e5                       ; 0xc0bde
    push ax                                   ; 50                          ; 0xc0be0
    mov byte [bp-002h], al                    ; 88 46 fe                    ; 0xc0be1
    mov al, dl                                ; 88 d0                       ; 0xc0be4 vgabios.c:421
    xor ah, ah                                ; 30 e4                       ; 0xc0be6
    mul bx                                    ; f7 e3                       ; 0xc0be8
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc0bea
    xor dh, dh                                ; 30 f6                       ; 0xc0bed
    mul dx                                    ; f7 e2                       ; 0xc0bef
    mov dx, ax                                ; 89 c2                       ; 0xc0bf1
    mov al, byte [bp-002h]                    ; 8a 46 fe                    ; 0xc0bf3
    xor ah, ah                                ; 30 e4                       ; 0xc0bf6
    add ax, dx                                ; 01 d0                       ; 0xc0bf8
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc0bfa vgabios.c:422
    sal ax, CL                                ; d3 e0                       ; 0xc0bfc
    mov sp, bp                                ; 89 ec                       ; 0xc0bfe vgabios.c:424
    pop bp                                    ; 5d                          ; 0xc0c00
    retn 00002h                               ; c2 02 00                    ; 0xc0c01
  ; disGetNextSymbol 0xc0c04 LB 0x38ee -> off=0x0 cb=000000000000004e uValue=00000000000c0c04 'vga_read_glyph_linear'
vga_read_glyph_linear:                       ; 0xc0c04 LB 0x4e
    push si                                   ; 56                          ; 0xc0c04 vgabios.c:426
    push di                                   ; 57                          ; 0xc0c05
    push bp                                   ; 55                          ; 0xc0c06
    mov bp, sp                                ; 89 e5                       ; 0xc0c07
    push ax                                   ; 50                          ; 0xc0c09
    push ax                                   ; 50                          ; 0xc0c0a
    mov si, ax                                ; 89 c6                       ; 0xc0c0b
    mov word [bp-002h], dx                    ; 89 56 fe                    ; 0xc0c0d
    mov word [bp-004h], bx                    ; 89 5e fc                    ; 0xc0c10
    mov bx, cx                                ; 89 cb                       ; 0xc0c13
    dec byte [bp+008h]                        ; fe 4e 08                    ; 0xc0c15 vgabios.c:432
    cmp byte [bp+008h], 0ffh                  ; 80 7e 08 ff                 ; 0xc0c18
    je short 00c4ah                           ; 74 2c                       ; 0xc0c1c
    xor dh, dh                                ; 30 f6                       ; 0xc0c1e vgabios.c:433
    mov DL, strict byte 080h                  ; b2 80                       ; 0xc0c20 vgabios.c:434
    xor ax, ax                                ; 31 c0                       ; 0xc0c22 vgabios.c:435
    jmp short 00c2bh                          ; eb 05                       ; 0xc0c24
    cmp ax, strict word 00008h                ; 3d 08 00                    ; 0xc0c26
    jnl short 00c3fh                          ; 7d 14                       ; 0xc0c29
    mov es, [bp-002h]                         ; 8e 46 fe                    ; 0xc0c2b vgabios.c:436
    mov di, si                                ; 89 f7                       ; 0xc0c2e
    add di, ax                                ; 01 c7                       ; 0xc0c30
    cmp byte [es:di], 000h                    ; 26 80 3d 00                 ; 0xc0c32
    je short 00c3ah                           ; 74 02                       ; 0xc0c36
    or dh, dl                                 ; 08 d6                       ; 0xc0c38 vgabios.c:437
    shr dl, 1                                 ; d0 ea                       ; 0xc0c3a vgabios.c:438
    inc ax                                    ; 40                          ; 0xc0c3c vgabios.c:439
    jmp short 00c26h                          ; eb e7                       ; 0xc0c3d
    mov di, bx                                ; 89 df                       ; 0xc0c3f vgabios.c:440
    inc bx                                    ; 43                          ; 0xc0c41
    mov byte [ss:di], dh                      ; 36 88 35                    ; 0xc0c42
    add si, word [bp-004h]                    ; 03 76 fc                    ; 0xc0c45 vgabios.c:441
    jmp short 00c15h                          ; eb cb                       ; 0xc0c48 vgabios.c:442
    mov sp, bp                                ; 89 ec                       ; 0xc0c4a vgabios.c:443
    pop bp                                    ; 5d                          ; 0xc0c4c
    pop di                                    ; 5f                          ; 0xc0c4d
    pop si                                    ; 5e                          ; 0xc0c4e
    retn 00002h                               ; c2 02 00                    ; 0xc0c4f
  ; disGetNextSymbol 0xc0c52 LB 0x38a0 -> off=0x0 cb=0000000000000049 uValue=00000000000c0c52 'vga_read_char_linear'
vga_read_char_linear:                        ; 0xc0c52 LB 0x49
    push bp                                   ; 55                          ; 0xc0c52 vgabios.c:445
    mov bp, sp                                ; 89 e5                       ; 0xc0c53
    push cx                                   ; 51                          ; 0xc0c55
    push si                                   ; 56                          ; 0xc0c56
    sub sp, strict byte 00012h                ; 83 ec 12                    ; 0xc0c57
    mov si, ax                                ; 89 c6                       ; 0xc0c5a
    mov ax, dx                                ; 89 d0                       ; 0xc0c5c
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc0c5e vgabios.c:449
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc0c61
    push word [bp-006h]                       ; ff 76 fa                    ; 0xc0c65
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc0c68
    mov bx, si                                ; 89 f3                       ; 0xc0c6a
    sal bx, CL                                ; d3 e3                       ; 0xc0c6c
    lea cx, [bp-016h]                         ; 8d 4e ea                    ; 0xc0c6e
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc0c71
    call 00c04h                               ; e8 8d ff                    ; 0xc0c74
    push word [bp-006h]                       ; ff 76 fa                    ; 0xc0c77 vgabios.c:452
    mov ax, 00100h                            ; b8 00 01                    ; 0xc0c7a
    push ax                                   ; 50                          ; 0xc0c7d
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0c7e vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0c81
    mov es, ax                                ; 8e c0                       ; 0xc0c83
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0c85
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0c88
    xor cx, cx                                ; 31 c9                       ; 0xc0c8c vgabios.c:68
    lea bx, [bp-016h]                         ; 8d 5e ea                    ; 0xc0c8e
    call 00ac5h                               ; e8 31 fe                    ; 0xc0c91
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0c94 vgabios.c:453
    pop si                                    ; 5e                          ; 0xc0c97
    pop cx                                    ; 59                          ; 0xc0c98
    pop bp                                    ; 5d                          ; 0xc0c99
    retn                                      ; c3                          ; 0xc0c9a
  ; disGetNextSymbol 0xc0c9b LB 0x3857 -> off=0x0 cb=0000000000000036 uValue=00000000000c0c9b 'vga_read_2bpp_char'
vga_read_2bpp_char:                          ; 0xc0c9b LB 0x36
    push bp                                   ; 55                          ; 0xc0c9b vgabios.c:455
    mov bp, sp                                ; 89 e5                       ; 0xc0c9c
    push bx                                   ; 53                          ; 0xc0c9e
    push cx                                   ; 51                          ; 0xc0c9f
    mov bx, ax                                ; 89 c3                       ; 0xc0ca0
    mov es, dx                                ; 8e c2                       ; 0xc0ca2
    mov cx, 0c000h                            ; b9 00 c0                    ; 0xc0ca4 vgabios.c:461
    mov DH, strict byte 080h                  ; b6 80                       ; 0xc0ca7 vgabios.c:462
    xor dl, dl                                ; 30 d2                       ; 0xc0ca9 vgabios.c:463
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0cab vgabios.c:464
    db  086h, 0c4h
    ; xchg ah, al                               ; 86 c4                     ; 0xc0cae
    xor bx, bx                                ; 31 db                       ; 0xc0cb0 vgabios.c:466
    jmp short 00cb9h                          ; eb 05                       ; 0xc0cb2
    cmp bx, strict byte 00008h                ; 83 fb 08                    ; 0xc0cb4
    jnl short 00cc8h                          ; 7d 0f                       ; 0xc0cb7
    test ax, cx                               ; 85 c8                       ; 0xc0cb9 vgabios.c:467
    je short 00cbfh                           ; 74 02                       ; 0xc0cbb
    or dl, dh                                 ; 08 f2                       ; 0xc0cbd vgabios.c:468
    shr dh, 1                                 ; d0 ee                       ; 0xc0cbf vgabios.c:469
    shr cx, 1                                 ; d1 e9                       ; 0xc0cc1 vgabios.c:470
    shr cx, 1                                 ; d1 e9                       ; 0xc0cc3
    inc bx                                    ; 43                          ; 0xc0cc5 vgabios.c:471
    jmp short 00cb4h                          ; eb ec                       ; 0xc0cc6
    mov al, dl                                ; 88 d0                       ; 0xc0cc8 vgabios.c:473
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0cca
    pop cx                                    ; 59                          ; 0xc0ccd
    pop bx                                    ; 5b                          ; 0xc0cce
    pop bp                                    ; 5d                          ; 0xc0ccf
    retn                                      ; c3                          ; 0xc0cd0
  ; disGetNextSymbol 0xc0cd1 LB 0x3821 -> off=0x0 cb=0000000000000084 uValue=00000000000c0cd1 'vga_read_glyph_cga'
vga_read_glyph_cga:                          ; 0xc0cd1 LB 0x84
    push bp                                   ; 55                          ; 0xc0cd1 vgabios.c:475
    mov bp, sp                                ; 89 e5                       ; 0xc0cd2
    push cx                                   ; 51                          ; 0xc0cd4
    push si                                   ; 56                          ; 0xc0cd5
    push di                                   ; 57                          ; 0xc0cd6
    push ax                                   ; 50                          ; 0xc0cd7
    mov si, dx                                ; 89 d6                       ; 0xc0cd8
    cmp bl, 006h                              ; 80 fb 06                    ; 0xc0cda vgabios.c:483
    je short 00d19h                           ; 74 3a                       ; 0xc0cdd
    mov bx, ax                                ; 89 c3                       ; 0xc0cdf vgabios.c:485
    sal bx, 1                                 ; d1 e3                       ; 0xc0ce1
    mov word [bp-008h], 0b800h                ; c7 46 f8 00 b8              ; 0xc0ce3
    xor cx, cx                                ; 31 c9                       ; 0xc0ce8 vgabios.c:487
    jmp short 00cf1h                          ; eb 05                       ; 0xc0cea
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc0cec
    jnl short 00d4dh                          ; 7d 5c                       ; 0xc0cef
    mov ax, bx                                ; 89 d8                       ; 0xc0cf1 vgabios.c:488
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc0cf3
    call 00c9bh                               ; e8 a2 ff                    ; 0xc0cf6
    mov di, si                                ; 89 f7                       ; 0xc0cf9
    inc si                                    ; 46                          ; 0xc0cfb
    push SS                                   ; 16                          ; 0xc0cfc
    pop ES                                    ; 07                          ; 0xc0cfd
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0cfe
    lea ax, [bx+02000h]                       ; 8d 87 00 20                 ; 0xc0d01 vgabios.c:489
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc0d05
    call 00c9bh                               ; e8 90 ff                    ; 0xc0d08
    mov di, si                                ; 89 f7                       ; 0xc0d0b
    inc si                                    ; 46                          ; 0xc0d0d
    push SS                                   ; 16                          ; 0xc0d0e
    pop ES                                    ; 07                          ; 0xc0d0f
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d10
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc0d13 vgabios.c:490
    inc cx                                    ; 41                          ; 0xc0d16 vgabios.c:491
    jmp short 00cech                          ; eb d3                       ; 0xc0d17
    mov bx, ax                                ; 89 c3                       ; 0xc0d19 vgabios.c:493
    mov word [bp-008h], 0b800h                ; c7 46 f8 00 b8              ; 0xc0d1b
    xor cx, cx                                ; 31 c9                       ; 0xc0d20 vgabios.c:494
    jmp short 00d29h                          ; eb 05                       ; 0xc0d22
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc0d24
    jnl short 00d4dh                          ; 7d 24                       ; 0xc0d27
    mov di, si                                ; 89 f7                       ; 0xc0d29 vgabios.c:495
    inc si                                    ; 46                          ; 0xc0d2b
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc0d2c
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0d2f
    push SS                                   ; 16                          ; 0xc0d32
    pop ES                                    ; 07                          ; 0xc0d33
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d34
    mov di, si                                ; 89 f7                       ; 0xc0d37 vgabios.c:496
    inc si                                    ; 46                          ; 0xc0d39
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc0d3a
    mov al, byte [es:bx+02000h]               ; 26 8a 87 00 20              ; 0xc0d3d
    push SS                                   ; 16                          ; 0xc0d42
    pop ES                                    ; 07                          ; 0xc0d43
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc0d44
    add bx, strict byte 00050h                ; 83 c3 50                    ; 0xc0d47 vgabios.c:497
    inc cx                                    ; 41                          ; 0xc0d4a vgabios.c:498
    jmp short 00d24h                          ; eb d7                       ; 0xc0d4b
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc0d4d vgabios.c:500
    pop di                                    ; 5f                          ; 0xc0d50
    pop si                                    ; 5e                          ; 0xc0d51
    pop cx                                    ; 59                          ; 0xc0d52
    pop bp                                    ; 5d                          ; 0xc0d53
    retn                                      ; c3                          ; 0xc0d54
  ; disGetNextSymbol 0xc0d55 LB 0x379d -> off=0x0 cb=000000000000001b uValue=00000000000c0d55 'vga_char_ofs_cga'
vga_char_ofs_cga:                            ; 0xc0d55 LB 0x1b
    push cx                                   ; 51                          ; 0xc0d55 vgabios.c:502
    push bp                                   ; 55                          ; 0xc0d56
    mov bp, sp                                ; 89 e5                       ; 0xc0d57
    mov cl, al                                ; 88 c1                       ; 0xc0d59
    mov al, dl                                ; 88 d0                       ; 0xc0d5b
    xor ah, ah                                ; 30 e4                       ; 0xc0d5d vgabios.c:507
    mul bx                                    ; f7 e3                       ; 0xc0d5f
    mov bx, ax                                ; 89 c3                       ; 0xc0d61
    sal bx, 1                                 ; d1 e3                       ; 0xc0d63
    sal bx, 1                                 ; d1 e3                       ; 0xc0d65
    mov al, cl                                ; 88 c8                       ; 0xc0d67
    xor ah, ah                                ; 30 e4                       ; 0xc0d69
    add ax, bx                                ; 01 d8                       ; 0xc0d6b
    pop bp                                    ; 5d                          ; 0xc0d6d vgabios.c:508
    pop cx                                    ; 59                          ; 0xc0d6e
    retn                                      ; c3                          ; 0xc0d6f
  ; disGetNextSymbol 0xc0d70 LB 0x3782 -> off=0x0 cb=000000000000006b uValue=00000000000c0d70 'vga_read_char_cga'
vga_read_char_cga:                           ; 0xc0d70 LB 0x6b
    push bp                                   ; 55                          ; 0xc0d70 vgabios.c:510
    mov bp, sp                                ; 89 e5                       ; 0xc0d71
    push bx                                   ; 53                          ; 0xc0d73
    push cx                                   ; 51                          ; 0xc0d74
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc0d75
    mov bl, dl                                ; 88 d3                       ; 0xc0d78 vgabios.c:516
    xor bh, bh                                ; 30 ff                       ; 0xc0d7a
    lea dx, [bp-00eh]                         ; 8d 56 f2                    ; 0xc0d7c
    call 00cd1h                               ; e8 4f ff                    ; 0xc0d7f
    mov ax, strict word 00008h                ; b8 08 00                    ; 0xc0d82 vgabios.c:519
    push ax                                   ; 50                          ; 0xc0d85
    mov ax, 00080h                            ; b8 80 00                    ; 0xc0d86
    push ax                                   ; 50                          ; 0xc0d89
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0d8a vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0d8d
    mov es, ax                                ; 8e c0                       ; 0xc0d8f
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0d91
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0d94
    xor cx, cx                                ; 31 c9                       ; 0xc0d98 vgabios.c:68
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc0d9a
    call 00ac5h                               ; e8 25 fd                    ; 0xc0d9d
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0da0
    test ah, 080h                             ; f6 c4 80                    ; 0xc0da3 vgabios.c:521
    jne short 00dd1h                          ; 75 29                       ; 0xc0da6
    mov bx, strict word 0007ch                ; bb 7c 00                    ; 0xc0da8 vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0dab
    mov es, ax                                ; 8e c0                       ; 0xc0dad
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0daf
    mov dx, word [es:bx+002h]                 ; 26 8b 57 02                 ; 0xc0db2
    test dx, dx                               ; 85 d2                       ; 0xc0db6 vgabios.c:525
    jne short 00dbeh                          ; 75 04                       ; 0xc0db8
    test ax, ax                               ; 85 c0                       ; 0xc0dba
    je short 00dd1h                           ; 74 13                       ; 0xc0dbc
    mov bx, strict word 00008h                ; bb 08 00                    ; 0xc0dbe vgabios.c:526
    push bx                                   ; 53                          ; 0xc0dc1
    mov bx, 00080h                            ; bb 80 00                    ; 0xc0dc2
    push bx                                   ; 53                          ; 0xc0dc5
    mov cx, bx                                ; 89 d9                       ; 0xc0dc6
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc0dc8
    call 00ac5h                               ; e8 f7 fc                    ; 0xc0dcb
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc0dce
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc0dd1 vgabios.c:529
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc0dd4
    pop cx                                    ; 59                          ; 0xc0dd7
    pop bx                                    ; 5b                          ; 0xc0dd8
    pop bp                                    ; 5d                          ; 0xc0dd9
    retn                                      ; c3                          ; 0xc0dda
  ; disGetNextSymbol 0xc0ddb LB 0x3717 -> off=0x0 cb=000000000000012b uValue=00000000000c0ddb 'vga_read_char_attr'
vga_read_char_attr:                          ; 0xc0ddb LB 0x12b
    push bp                                   ; 55                          ; 0xc0ddb vgabios.c:531
    mov bp, sp                                ; 89 e5                       ; 0xc0ddc
    push bx                                   ; 53                          ; 0xc0dde
    push cx                                   ; 51                          ; 0xc0ddf
    push si                                   ; 56                          ; 0xc0de0
    push di                                   ; 57                          ; 0xc0de1
    sub sp, strict byte 00012h                ; 83 ec 12                    ; 0xc0de2
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc0de5
    mov si, dx                                ; 89 d6                       ; 0xc0de8
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0dea vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0ded
    mov es, ax                                ; 8e c0                       ; 0xc0df0
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0df2
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc0df5 vgabios.c:48
    xor ah, ah                                ; 30 e4                       ; 0xc0df8 vgabios.c:539
    call 0380ch                               ; e8 0f 2a                    ; 0xc0dfa
    mov cl, al                                ; 88 c1                       ; 0xc0dfd
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc0dff vgabios.c:540
    je short 00e7ah                           ; 74 77                       ; 0xc0e01
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc0e03 vgabios.c:544
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc0e06
    mov byte [bp-013h], 000h                  ; c6 46 ed 00                 ; 0xc0e09
    lea bx, [bp-018h]                         ; 8d 5e e8                    ; 0xc0e0d
    lea dx, [bp-01ah]                         ; 8d 56 e6                    ; 0xc0e10
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc0e13
    call 00a97h                               ; e8 7e fc                    ; 0xc0e16
    mov ch, byte [bp-018h]                    ; 8a 6e e8                    ; 0xc0e19 vgabios.c:545
    mov ax, word [bp-018h]                    ; 8b 46 e8                    ; 0xc0e1c vgabios.c:546
    mov al, ah                                ; 88 e0                       ; 0xc0e1f
    xor ah, ah                                ; 30 e4                       ; 0xc0e21
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc0e23
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc0e26
    mov di, strict word 0004ah                ; bf 4a 00                    ; 0xc0e29 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0e2c
    mov es, ax                                ; 8e c0                       ; 0xc0e2f
    mov di, word [es:di]                      ; 26 8b 3d                    ; 0xc0e31
    mov word [bp-016h], di                    ; 89 7e ea                    ; 0xc0e34 vgabios.c:58
    mov al, cl                                ; 88 c8                       ; 0xc0e37 vgabios.c:552
    xor ah, ah                                ; 30 e4                       ; 0xc0e39
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc0e3b
    sal ax, CL                                ; d3 e0                       ; 0xc0e3d
    mov word [bp-012h], ax                    ; 89 46 ee                    ; 0xc0e3f
    mov bx, ax                                ; 89 c3                       ; 0xc0e42
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc0e44
    jne short 00e7dh                          ; 75 32                       ; 0xc0e49
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc0e4b vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0e4e
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc0e51 vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc0e54
    mul dx                                    ; f7 e2                       ; 0xc0e56
    mov bx, ax                                ; 89 c3                       ; 0xc0e58
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc0e5a vgabios.c:555
    xor ah, ah                                ; 30 e4                       ; 0xc0e5d
    mul di                                    ; f7 e7                       ; 0xc0e5f
    mov dl, ch                                ; 88 ea                       ; 0xc0e61
    xor dh, dh                                ; 30 f6                       ; 0xc0e63
    add ax, dx                                ; 01 d0                       ; 0xc0e65
    sal ax, 1                                 ; d1 e0                       ; 0xc0e67
    add bx, ax                                ; 01 c3                       ; 0xc0e69
    mov di, word [bp-012h]                    ; 8b 7e ee                    ; 0xc0e6b vgabios.c:55
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc0e6e
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0e72
    push SS                                   ; 16                          ; 0xc0e75 vgabios.c:58
    pop ES                                    ; 07                          ; 0xc0e76
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc0e77
    jmp near 00efdh                           ; e9 80 00                    ; 0xc0e7a vgabios.c:558
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc0e7d vgabios.c:559
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc0e81
    je short 00ed3h                           ; 74 4e                       ; 0xc0e83
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc0e85
    jc short 00e8fh                           ; 72 06                       ; 0xc0e87
    jbe short 00e91h                          ; 76 06                       ; 0xc0e89
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc0e8b
    jbe short 00ea9h                          ; 76 1a                       ; 0xc0e8d
    jmp short 00efdh                          ; eb 6c                       ; 0xc0e8f
    xor dh, dh                                ; 30 f6                       ; 0xc0e91 vgabios.c:562
    mov al, ch                                ; 88 e8                       ; 0xc0e93
    xor ah, ah                                ; 30 e4                       ; 0xc0e95
    mov bx, word [bp-016h]                    ; 8b 5e ea                    ; 0xc0e97
    call 00d55h                               ; e8 b8 fe                    ; 0xc0e9a
    mov dl, byte [bp-00ch]                    ; 8a 56 f4                    ; 0xc0e9d vgabios.c:563
    xor dh, dh                                ; 30 f6                       ; 0xc0ea0
    call 00d70h                               ; e8 cb fe                    ; 0xc0ea2
    xor ah, ah                                ; 30 e4                       ; 0xc0ea5
    jmp short 00e75h                          ; eb cc                       ; 0xc0ea7
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0ea9 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0eac
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc0eaf vgabios.c:568
    mov byte [bp-00fh], 000h                  ; c6 46 f1 00                 ; 0xc0eb2
    push word [bp-010h]                       ; ff 76 f0                    ; 0xc0eb6
    xor dh, dh                                ; 30 f6                       ; 0xc0eb9
    mov al, ch                                ; 88 e8                       ; 0xc0ebb
    xor ah, ah                                ; 30 e4                       ; 0xc0ebd
    mov cx, word [bp-014h]                    ; 8b 4e ec                    ; 0xc0ebf
    mov bx, di                                ; 89 fb                       ; 0xc0ec2
    call 00b69h                               ; e8 a2 fc                    ; 0xc0ec4
    mov bx, word [bp-010h]                    ; 8b 5e f0                    ; 0xc0ec7 vgabios.c:569
    mov dx, ax                                ; 89 c2                       ; 0xc0eca
    mov ax, di                                ; 89 f8                       ; 0xc0ecc
    call 00b98h                               ; e8 c7 fc                    ; 0xc0ece
    jmp short 00ea5h                          ; eb d2                       ; 0xc0ed1
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0ed3 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc0ed6
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc0ed9 vgabios.c:573
    mov byte [bp-00fh], 000h                  ; c6 46 f1 00                 ; 0xc0edc
    push word [bp-010h]                       ; ff 76 f0                    ; 0xc0ee0
    xor dh, dh                                ; 30 f6                       ; 0xc0ee3
    mov al, ch                                ; 88 e8                       ; 0xc0ee5
    xor ah, ah                                ; 30 e4                       ; 0xc0ee7
    mov cx, word [bp-014h]                    ; 8b 4e ec                    ; 0xc0ee9
    mov bx, di                                ; 89 fb                       ; 0xc0eec
    call 00bddh                               ; e8 ec fc                    ; 0xc0eee
    mov bx, word [bp-010h]                    ; 8b 5e f0                    ; 0xc0ef1 vgabios.c:574
    mov dx, ax                                ; 89 c2                       ; 0xc0ef4
    mov ax, di                                ; 89 f8                       ; 0xc0ef6
    call 00c52h                               ; e8 57 fd                    ; 0xc0ef8
    jmp short 00ea5h                          ; eb a8                       ; 0xc0efb
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc0efd vgabios.c:583
    pop di                                    ; 5f                          ; 0xc0f00
    pop si                                    ; 5e                          ; 0xc0f01
    pop cx                                    ; 59                          ; 0xc0f02
    pop bx                                    ; 5b                          ; 0xc0f03
    pop bp                                    ; 5d                          ; 0xc0f04
    retn                                      ; c3                          ; 0xc0f05
  ; disGetNextSymbol 0xc0f06 LB 0x35ec -> off=0x10 cb=0000000000000083 uValue=00000000000c0f16 'vga_get_font_info'
    db  02dh, 00fh, 072h, 00fh, 077h, 00fh, 07eh, 00fh, 083h, 00fh, 088h, 00fh, 08dh, 00fh, 092h, 00fh
vga_get_font_info:                           ; 0xc0f16 LB 0x83
    push si                                   ; 56                          ; 0xc0f16 vgabios.c:585
    push di                                   ; 57                          ; 0xc0f17
    push bp                                   ; 55                          ; 0xc0f18
    mov bp, sp                                ; 89 e5                       ; 0xc0f19
    mov si, dx                                ; 89 d6                       ; 0xc0f1b
    mov di, bx                                ; 89 df                       ; 0xc0f1d
    cmp ax, strict word 00007h                ; 3d 07 00                    ; 0xc0f1f vgabios.c:590
    jnbe short 00f6ch                         ; 77 48                       ; 0xc0f22
    mov bx, ax                                ; 89 c3                       ; 0xc0f24
    sal bx, 1                                 ; d1 e3                       ; 0xc0f26
    jmp word [cs:bx+00f06h]                   ; 2e ff a7 06 0f              ; 0xc0f28
    mov bx, strict word 0007ch                ; bb 7c 00                    ; 0xc0f2d vgabios.c:67
    xor ax, ax                                ; 31 c0                       ; 0xc0f30
    mov es, ax                                ; 8e c0                       ; 0xc0f32
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc0f34
    mov ax, word [es:bx+002h]                 ; 26 8b 47 02                 ; 0xc0f37
    push SS                                   ; 16                          ; 0xc0f3b vgabios.c:593
    pop ES                                    ; 07                          ; 0xc0f3c
    mov word [es:di], dx                      ; 26 89 15                    ; 0xc0f3d
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc0f40
    mov bx, 00085h                            ; bb 85 00                    ; 0xc0f43
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f46
    mov es, ax                                ; 8e c0                       ; 0xc0f49
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f4b
    xor ah, ah                                ; 30 e4                       ; 0xc0f4e
    push SS                                   ; 16                          ; 0xc0f50
    pop ES                                    ; 07                          ; 0xc0f51
    mov bx, cx                                ; 89 cb                       ; 0xc0f52
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0f54
    mov bx, 00084h                            ; bb 84 00                    ; 0xc0f57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0f5a
    mov es, ax                                ; 8e c0                       ; 0xc0f5d
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0f5f
    xor ah, ah                                ; 30 e4                       ; 0xc0f62
    push SS                                   ; 16                          ; 0xc0f64
    pop ES                                    ; 07                          ; 0xc0f65
    mov bx, word [bp+008h]                    ; 8b 5e 08                    ; 0xc0f66
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc0f69
    pop bp                                    ; 5d                          ; 0xc0f6c
    pop di                                    ; 5f                          ; 0xc0f6d
    pop si                                    ; 5e                          ; 0xc0f6e
    retn 00002h                               ; c2 02 00                    ; 0xc0f6f
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc0f72 vgabios.c:67
    jmp short 00f30h                          ; eb b9                       ; 0xc0f75
    mov dx, 05d6ah                            ; ba 6a 5d                    ; 0xc0f77 vgabios.c:598
    mov ax, ds                                ; 8c d8                       ; 0xc0f7a
    jmp short 00f3bh                          ; eb bd                       ; 0xc0f7c vgabios.c:599
    mov dx, 0556ah                            ; ba 6a 55                    ; 0xc0f7e vgabios.c:601
    jmp short 00f7ah                          ; eb f7                       ; 0xc0f81
    mov dx, 0596ah                            ; ba 6a 59                    ; 0xc0f83 vgabios.c:604
    jmp short 00f7ah                          ; eb f2                       ; 0xc0f86
    mov dx, 07b6ah                            ; ba 6a 7b                    ; 0xc0f88 vgabios.c:607
    jmp short 00f7ah                          ; eb ed                       ; 0xc0f8b
    mov dx, 06b6ah                            ; ba 6a 6b                    ; 0xc0f8d vgabios.c:610
    jmp short 00f7ah                          ; eb e8                       ; 0xc0f90
    mov dx, 07c97h                            ; ba 97 7c                    ; 0xc0f92 vgabios.c:613
    jmp short 00f7ah                          ; eb e3                       ; 0xc0f95
    jmp short 00f6ch                          ; eb d3                       ; 0xc0f97 vgabios.c:619
  ; disGetNextSymbol 0xc0f99 LB 0x3559 -> off=0x0 cb=000000000000016d uValue=00000000000c0f99 'vga_read_pixel'
vga_read_pixel:                              ; 0xc0f99 LB 0x16d
    push bp                                   ; 55                          ; 0xc0f99 vgabios.c:632
    mov bp, sp                                ; 89 e5                       ; 0xc0f9a
    push si                                   ; 56                          ; 0xc0f9c
    push di                                   ; 57                          ; 0xc0f9d
    sub sp, strict byte 0000ch                ; 83 ec 0c                    ; 0xc0f9e
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc0fa1
    mov si, dx                                ; 89 d6                       ; 0xc0fa4
    mov word [bp-010h], bx                    ; 89 5e f0                    ; 0xc0fa6
    mov word [bp-00eh], cx                    ; 89 4e f2                    ; 0xc0fa9
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc0fac vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0faf
    mov es, ax                                ; 8e c0                       ; 0xc0fb2
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc0fb4
    xor ah, ah                                ; 30 e4                       ; 0xc0fb7 vgabios.c:639
    call 0380ch                               ; e8 50 28                    ; 0xc0fb9
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc0fbc
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc0fbf vgabios.c:640
    je short 00fd2h                           ; 74 0f                       ; 0xc0fc1
    mov bl, al                                ; 88 c3                       ; 0xc0fc3 vgabios.c:642
    xor bh, bh                                ; 30 ff                       ; 0xc0fc5
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc0fc7
    sal bx, CL                                ; d3 e3                       ; 0xc0fc9
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc0fcb
    jne short 00fd5h                          ; 75 03                       ; 0xc0fd0
    jmp near 010ffh                           ; e9 2a 01                    ; 0xc0fd2 vgabios.c:643
    mov ch, byte [bx+047aeh]                  ; 8a af ae 47                 ; 0xc0fd5 vgabios.c:646
    cmp ch, cl                                ; 38 cd                       ; 0xc0fd9
    jc short 00fech                           ; 72 0f                       ; 0xc0fdb
    jbe short 00ff4h                          ; 76 15                       ; 0xc0fdd
    cmp ch, 005h                              ; 80 fd 05                    ; 0xc0fdf
    je short 0102dh                           ; 74 49                       ; 0xc0fe2
    cmp ch, 004h                              ; 80 fd 04                    ; 0xc0fe4
    je short 00ff4h                           ; 74 0b                       ; 0xc0fe7
    jmp near 010f5h                           ; e9 09 01                    ; 0xc0fe9
    cmp ch, 002h                              ; 80 fd 02                    ; 0xc0fec
    je short 01061h                           ; 74 70                       ; 0xc0fef
    jmp near 010f5h                           ; e9 01 01                    ; 0xc0ff1
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc0ff4 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc0ff7
    mov es, ax                                ; 8e c0                       ; 0xc0ffa
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc0ffc
    mov ax, word [bp-010h]                    ; 8b 46 f0                    ; 0xc0fff vgabios.c:58
    mul bx                                    ; f7 e3                       ; 0xc1002
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1004
    mov bx, si                                ; 89 f3                       ; 0xc1006
    shr bx, CL                                ; d3 eb                       ; 0xc1008
    add bx, ax                                ; 01 c3                       ; 0xc100a
    mov di, strict word 0004ch                ; bf 4c 00                    ; 0xc100c vgabios.c:57
    mov ax, word [es:di]                      ; 26 8b 05                    ; 0xc100f
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc1012 vgabios.c:58
    xor ch, ch                                ; 30 ed                       ; 0xc1015
    mul cx                                    ; f7 e1                       ; 0xc1017
    add bx, ax                                ; 01 c3                       ; 0xc1019
    mov cx, si                                ; 89 f1                       ; 0xc101b vgabios.c:651
    and cx, strict byte 00007h                ; 83 e1 07                    ; 0xc101d
    mov ax, 00080h                            ; b8 80 00                    ; 0xc1020
    sar ax, CL                                ; d3 f8                       ; 0xc1023
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc1025
    mov byte [bp-008h], ch                    ; 88 6e f8                    ; 0xc1028 vgabios.c:653
    jmp short 01036h                          ; eb 09                       ; 0xc102b
    jmp near 010d5h                           ; e9 a5 00                    ; 0xc102d
    cmp byte [bp-008h], 004h                  ; 80 7e f8 04                 ; 0xc1030
    jnc short 0105eh                          ; 73 28                       ; 0xc1034
    mov ah, byte [bp-008h]                    ; 8a 66 f8                    ; 0xc1036 vgabios.c:654
    xor al, al                                ; 30 c0                       ; 0xc1039
    or AL, strict byte 004h                   ; 0c 04                       ; 0xc103b
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc103d
    out DX, ax                                ; ef                          ; 0xc1040
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc1041 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc1044
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1046
    and al, byte [bp-00ah]                    ; 22 46 f6                    ; 0xc1049 vgabios.c:48
    test al, al                               ; 84 c0                       ; 0xc104c vgabios.c:656
    jbe short 01059h                          ; 76 09                       ; 0xc104e
    mov cl, byte [bp-008h]                    ; 8a 4e f8                    ; 0xc1050 vgabios.c:657
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc1053
    sal al, CL                                ; d2 e0                       ; 0xc1055
    or ch, al                                 ; 08 c5                       ; 0xc1057
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc1059 vgabios.c:658
    jmp short 01030h                          ; eb d2                       ; 0xc105c
    jmp near 010f7h                           ; e9 96 00                    ; 0xc105e
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc1061 vgabios.c:661
    xor ah, ah                                ; 30 e4                       ; 0xc1065
    mov cx, strict word 00004h                ; b9 04 00                    ; 0xc1067
    sub cx, ax                                ; 29 c1                       ; 0xc106a
    mov ax, dx                                ; 89 d0                       ; 0xc106c
    shr ax, CL                                ; d3 e8                       ; 0xc106e
    mov cx, ax                                ; 89 c1                       ; 0xc1070
    mov ax, word [bp-010h]                    ; 8b 46 f0                    ; 0xc1072
    shr ax, 1                                 ; d1 e8                       ; 0xc1075
    mov bx, strict word 00050h                ; bb 50 00                    ; 0xc1077
    mul bx                                    ; f7 e3                       ; 0xc107a
    mov bx, cx                                ; 89 cb                       ; 0xc107c
    add bx, ax                                ; 01 c3                       ; 0xc107e
    test byte [bp-010h], 001h                 ; f6 46 f0 01                 ; 0xc1080 vgabios.c:662
    je short 01089h                           ; 74 03                       ; 0xc1084
    add bh, 020h                              ; 80 c7 20                    ; 0xc1086 vgabios.c:663
    mov ax, 0b800h                            ; b8 00 b8                    ; 0xc1089 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc108c
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc108e
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc1091 vgabios.c:665
    xor bh, bh                                ; 30 ff                       ; 0xc1094
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1096
    sal bx, CL                                ; d3 e3                       ; 0xc1098
    cmp byte [bx+047afh], 002h                ; 80 bf af 47 02              ; 0xc109a
    jne short 010bch                          ; 75 1b                       ; 0xc109f
    mov cx, si                                ; 89 f1                       ; 0xc10a1 vgabios.c:666
    xor ch, ch                                ; 30 ed                       ; 0xc10a3
    and cl, 003h                              ; 80 e1 03                    ; 0xc10a5
    mov bx, strict word 00003h                ; bb 03 00                    ; 0xc10a8
    sub bx, cx                                ; 29 cb                       ; 0xc10ab
    mov cx, bx                                ; 89 d9                       ; 0xc10ad
    sal cx, 1                                 ; d1 e1                       ; 0xc10af
    xor ah, ah                                ; 30 e4                       ; 0xc10b1
    sar ax, CL                                ; d3 f8                       ; 0xc10b3
    mov ch, al                                ; 88 c5                       ; 0xc10b5
    and ch, 003h                              ; 80 e5 03                    ; 0xc10b7
    jmp short 010f7h                          ; eb 3b                       ; 0xc10ba vgabios.c:667
    mov cx, si                                ; 89 f1                       ; 0xc10bc vgabios.c:668
    xor ch, ch                                ; 30 ed                       ; 0xc10be
    and cl, 007h                              ; 80 e1 07                    ; 0xc10c0
    mov bx, strict word 00007h                ; bb 07 00                    ; 0xc10c3
    sub bx, cx                                ; 29 cb                       ; 0xc10c6
    mov cx, bx                                ; 89 d9                       ; 0xc10c8
    xor ah, ah                                ; 30 e4                       ; 0xc10ca
    sar ax, CL                                ; d3 f8                       ; 0xc10cc
    mov ch, al                                ; 88 c5                       ; 0xc10ce
    and ch, 001h                              ; 80 e5 01                    ; 0xc10d0
    jmp short 010f7h                          ; eb 22                       ; 0xc10d3 vgabios.c:669
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc10d5 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc10d8
    mov es, ax                                ; 8e c0                       ; 0xc10db
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc10dd
    sal bx, CL                                ; d3 e3                       ; 0xc10e0 vgabios.c:58
    mov ax, word [bp-010h]                    ; 8b 46 f0                    ; 0xc10e2
    mul bx                                    ; f7 e3                       ; 0xc10e5
    mov bx, si                                ; 89 f3                       ; 0xc10e7
    add bx, ax                                ; 01 c3                       ; 0xc10e9
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc10eb vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc10ee
    mov ch, byte [es:bx]                      ; 26 8a 2f                    ; 0xc10f0
    jmp short 010f7h                          ; eb 02                       ; 0xc10f3 vgabios.c:673
    xor ch, ch                                ; 30 ed                       ; 0xc10f5 vgabios.c:678
    push SS                                   ; 16                          ; 0xc10f7 vgabios.c:680
    pop ES                                    ; 07                          ; 0xc10f8
    mov bx, word [bp-00eh]                    ; 8b 5e f2                    ; 0xc10f9
    mov byte [es:bx], ch                      ; 26 88 2f                    ; 0xc10fc
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc10ff vgabios.c:681
    pop di                                    ; 5f                          ; 0xc1102
    pop si                                    ; 5e                          ; 0xc1103
    pop bp                                    ; 5d                          ; 0xc1104
    retn                                      ; c3                          ; 0xc1105
  ; disGetNextSymbol 0xc1106 LB 0x33ec -> off=0x0 cb=000000000000009f uValue=00000000000c1106 'biosfn_perform_gray_scale_summing'
biosfn_perform_gray_scale_summing:           ; 0xc1106 LB 0x9f
    push bp                                   ; 55                          ; 0xc1106 vgabios.c:686
    mov bp, sp                                ; 89 e5                       ; 0xc1107
    push bx                                   ; 53                          ; 0xc1109
    push cx                                   ; 51                          ; 0xc110a
    push si                                   ; 56                          ; 0xc110b
    push di                                   ; 57                          ; 0xc110c
    push ax                                   ; 50                          ; 0xc110d
    push ax                                   ; 50                          ; 0xc110e
    mov bx, ax                                ; 89 c3                       ; 0xc110f
    mov di, dx                                ; 89 d7                       ; 0xc1111
    mov dx, 003dah                            ; ba da 03                    ; 0xc1113 vgabios.c:691
    in AL, DX                                 ; ec                          ; 0xc1116
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1117
    xor al, al                                ; 30 c0                       ; 0xc1119 vgabios.c:692
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc111b
    out DX, AL                                ; ee                          ; 0xc111e
    xor si, si                                ; 31 f6                       ; 0xc111f vgabios.c:694
    cmp si, di                                ; 39 fe                       ; 0xc1121
    jnc short 0118ah                          ; 73 65                       ; 0xc1123
    mov al, bl                                ; 88 d8                       ; 0xc1125 vgabios.c:697
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc1127
    out DX, AL                                ; ee                          ; 0xc112a
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc112b vgabios.c:699
    in AL, DX                                 ; ec                          ; 0xc112e
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc112f
    mov cx, ax                                ; 89 c1                       ; 0xc1131
    in AL, DX                                 ; ec                          ; 0xc1133 vgabios.c:700
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1134
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc1136
    in AL, DX                                 ; ec                          ; 0xc1139 vgabios.c:701
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc113a
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc113c
    mov al, cl                                ; 88 c8                       ; 0xc113f vgabios.c:704
    xor ah, ah                                ; 30 e4                       ; 0xc1141
    mov cx, strict word 0004dh                ; b9 4d 00                    ; 0xc1143
    imul cx                                   ; f7 e9                       ; 0xc1146
    mov cx, ax                                ; 89 c1                       ; 0xc1148
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc114a
    xor ah, ah                                ; 30 e4                       ; 0xc114d
    mov dx, 00097h                            ; ba 97 00                    ; 0xc114f
    imul dx                                   ; f7 ea                       ; 0xc1152
    add cx, ax                                ; 01 c1                       ; 0xc1154
    mov word [bp-00ah], cx                    ; 89 4e f6                    ; 0xc1156
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc1159
    xor ch, ch                                ; 30 ed                       ; 0xc115c
    mov ax, cx                                ; 89 c8                       ; 0xc115e
    mov dx, strict word 0001ch                ; ba 1c 00                    ; 0xc1160
    imul dx                                   ; f7 ea                       ; 0xc1163
    add ax, word [bp-00ah]                    ; 03 46 f6                    ; 0xc1165
    add ax, 00080h                            ; 05 80 00                    ; 0xc1168
    mov al, ah                                ; 88 e0                       ; 0xc116b
    cbw                                       ; 98                          ; 0xc116d
    mov cx, ax                                ; 89 c1                       ; 0xc116e
    cmp ax, strict word 0003fh                ; 3d 3f 00                    ; 0xc1170 vgabios.c:706
    jbe short 01178h                          ; 76 03                       ; 0xc1173
    mov cx, strict word 0003fh                ; b9 3f 00                    ; 0xc1175
    mov al, bl                                ; 88 d8                       ; 0xc1178 vgabios.c:709
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc117a
    out DX, AL                                ; ee                          ; 0xc117d
    mov al, cl                                ; 88 c8                       ; 0xc117e vgabios.c:711
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc1180
    out DX, AL                                ; ee                          ; 0xc1183
    out DX, AL                                ; ee                          ; 0xc1184 vgabios.c:712
    out DX, AL                                ; ee                          ; 0xc1185 vgabios.c:713
    inc bx                                    ; 43                          ; 0xc1186 vgabios.c:714
    inc si                                    ; 46                          ; 0xc1187 vgabios.c:715
    jmp short 01121h                          ; eb 97                       ; 0xc1188
    mov dx, 003dah                            ; ba da 03                    ; 0xc118a vgabios.c:716
    in AL, DX                                 ; ec                          ; 0xc118d
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc118e
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc1190 vgabios.c:717
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc1192
    out DX, AL                                ; ee                          ; 0xc1195
    mov dx, 003dah                            ; ba da 03                    ; 0xc1196 vgabios.c:719
    in AL, DX                                 ; ec                          ; 0xc1199
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc119a
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc119c vgabios.c:721
    pop di                                    ; 5f                          ; 0xc119f
    pop si                                    ; 5e                          ; 0xc11a0
    pop cx                                    ; 59                          ; 0xc11a1
    pop bx                                    ; 5b                          ; 0xc11a2
    pop bp                                    ; 5d                          ; 0xc11a3
    retn                                      ; c3                          ; 0xc11a4
  ; disGetNextSymbol 0xc11a5 LB 0x334d -> off=0x0 cb=00000000000000fc uValue=00000000000c11a5 'biosfn_set_cursor_shape'
biosfn_set_cursor_shape:                     ; 0xc11a5 LB 0xfc
    push bp                                   ; 55                          ; 0xc11a5 vgabios.c:724
    mov bp, sp                                ; 89 e5                       ; 0xc11a6
    push bx                                   ; 53                          ; 0xc11a8
    push cx                                   ; 51                          ; 0xc11a9
    push si                                   ; 56                          ; 0xc11aa
    push ax                                   ; 50                          ; 0xc11ab
    push ax                                   ; 50                          ; 0xc11ac
    mov ah, al                                ; 88 c4                       ; 0xc11ad
    mov bl, dl                                ; 88 d3                       ; 0xc11af
    mov dh, al                                ; 88 c6                       ; 0xc11b1 vgabios.c:730
    mov si, strict word 00060h                ; be 60 00                    ; 0xc11b3 vgabios.c:62
    mov cx, strict word 00040h                ; b9 40 00                    ; 0xc11b6
    mov es, cx                                ; 8e c1                       ; 0xc11b9
    mov word [es:si], dx                      ; 26 89 14                    ; 0xc11bb
    mov si, 00087h                            ; be 87 00                    ; 0xc11be vgabios.c:47
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc11c1
    test dl, 008h                             ; f6 c2 08                    ; 0xc11c4 vgabios.c:48
    jne short 01206h                          ; 75 3d                       ; 0xc11c7
    mov dl, al                                ; 88 c2                       ; 0xc11c9 vgabios.c:736
    and dl, 060h                              ; 80 e2 60                    ; 0xc11cb
    cmp dl, 020h                              ; 80 fa 20                    ; 0xc11ce
    jne short 011d9h                          ; 75 06                       ; 0xc11d1
    mov AH, strict byte 01eh                  ; b4 1e                       ; 0xc11d3 vgabios.c:738
    xor bl, bl                                ; 30 db                       ; 0xc11d5 vgabios.c:739
    jmp short 01206h                          ; eb 2d                       ; 0xc11d7 vgabios.c:740
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc11d9 vgabios.c:47
    test dl, 001h                             ; f6 c2 01                    ; 0xc11dc vgabios.c:48
    jne short 0123bh                          ; 75 5a                       ; 0xc11df
    cmp ah, 020h                              ; 80 fc 20                    ; 0xc11e1
    jnc short 0123bh                          ; 73 55                       ; 0xc11e4
    cmp bl, 020h                              ; 80 fb 20                    ; 0xc11e6
    jnc short 0123bh                          ; 73 50                       ; 0xc11e9
    mov si, 00085h                            ; be 85 00                    ; 0xc11eb vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc11ee
    mov es, dx                                ; 8e c2                       ; 0xc11f1
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc11f3
    mov dx, cx                                ; 89 ca                       ; 0xc11f6 vgabios.c:58
    cmp bl, ah                                ; 38 e3                       ; 0xc11f8 vgabios.c:751
    jnc short 01208h                          ; 73 0c                       ; 0xc11fa
    test bl, bl                               ; 84 db                       ; 0xc11fc vgabios.c:753
    je short 0123bh                           ; 74 3b                       ; 0xc11fe
    xor ah, ah                                ; 30 e4                       ; 0xc1200 vgabios.c:754
    mov bl, cl                                ; 88 cb                       ; 0xc1202 vgabios.c:755
    db  0feh, 0cbh
    ; dec bl                                    ; fe cb                     ; 0xc1204
    jmp short 0123bh                          ; eb 33                       ; 0xc1206 vgabios.c:757
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc1208 vgabios.c:758
    xor al, al                                ; 30 c0                       ; 0xc120b
    mov byte [bp-007h], al                    ; 88 46 f9                    ; 0xc120d
    mov byte [bp-00ah], ah                    ; 88 66 f6                    ; 0xc1210
    mov byte [bp-009h], al                    ; 88 46 f7                    ; 0xc1213
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc1216
    or si, word [bp-00ah]                     ; 0b 76 f6                    ; 0xc1219
    cmp si, cx                                ; 39 ce                       ; 0xc121c
    jnc short 0123dh                          ; 73 1d                       ; 0xc121e
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc1220
    mov byte [bp-007h], al                    ; 88 46 f9                    ; 0xc1223
    mov si, cx                                ; 89 ce                       ; 0xc1226
    dec si                                    ; 4e                          ; 0xc1228
    cmp si, word [bp-008h]                    ; 3b 76 f8                    ; 0xc1229
    je short 01277h                           ; 74 49                       ; 0xc122c
    mov byte [bp-008h], ah                    ; 88 66 f8                    ; 0xc122e
    mov byte [bp-007h], al                    ; 88 46 f9                    ; 0xc1231
    dec cx                                    ; 49                          ; 0xc1234
    dec cx                                    ; 49                          ; 0xc1235
    cmp cx, word [bp-008h]                    ; 3b 4e f8                    ; 0xc1236
    jne short 0123dh                          ; 75 02                       ; 0xc1239
    jmp short 01277h                          ; eb 3a                       ; 0xc123b
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc123d vgabios.c:760
    jbe short 01277h                          ; 76 35                       ; 0xc1240
    mov cl, ah                                ; 88 e1                       ; 0xc1242 vgabios.c:761
    xor ch, ch                                ; 30 ed                       ; 0xc1244
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc1246
    mov byte [bp-007h], ch                    ; 88 6e f9                    ; 0xc1249
    mov si, cx                                ; 89 ce                       ; 0xc124c
    inc si                                    ; 46                          ; 0xc124e
    inc si                                    ; 46                          ; 0xc124f
    mov cl, dl                                ; 88 d1                       ; 0xc1250
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc1252
    cmp si, word [bp-008h]                    ; 3b 76 f8                    ; 0xc1254
    jl short 0126ch                           ; 7c 13                       ; 0xc1257
    sub ah, bl                                ; 28 dc                       ; 0xc1259 vgabios.c:763
    add ah, dl                                ; 00 d4                       ; 0xc125b
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc125d
    mov bl, cl                                ; 88 cb                       ; 0xc125f vgabios.c:764
    cmp dx, strict byte 0000eh                ; 83 fa 0e                    ; 0xc1261 vgabios.c:765
    jc short 01277h                           ; 72 11                       ; 0xc1264
    db  0feh, 0cbh
    ; dec bl                                    ; fe cb                     ; 0xc1266 vgabios.c:767
    db  0feh, 0cch
    ; dec ah                                    ; fe cc                     ; 0xc1268 vgabios.c:768
    jmp short 01277h                          ; eb 0b                       ; 0xc126a vgabios.c:770
    cmp ah, 002h                              ; 80 fc 02                    ; 0xc126c
    jbe short 01275h                          ; 76 04                       ; 0xc126f
    shr dx, 1                                 ; d1 ea                       ; 0xc1271 vgabios.c:772
    mov ah, dl                                ; 88 d4                       ; 0xc1273
    mov bl, cl                                ; 88 cb                       ; 0xc1275 vgabios.c:776
    mov si, strict word 00063h                ; be 63 00                    ; 0xc1277 vgabios.c:57
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc127a
    mov es, dx                                ; 8e c2                       ; 0xc127d
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc127f
    mov AL, strict byte 00ah                  ; b0 0a                       ; 0xc1282 vgabios.c:787
    mov dx, cx                                ; 89 ca                       ; 0xc1284
    out DX, AL                                ; ee                          ; 0xc1286
    mov si, cx                                ; 89 ce                       ; 0xc1287 vgabios.c:788
    inc si                                    ; 46                          ; 0xc1289
    mov al, ah                                ; 88 e0                       ; 0xc128a
    mov dx, si                                ; 89 f2                       ; 0xc128c
    out DX, AL                                ; ee                          ; 0xc128e
    mov AL, strict byte 00bh                  ; b0 0b                       ; 0xc128f vgabios.c:789
    mov dx, cx                                ; 89 ca                       ; 0xc1291
    out DX, AL                                ; ee                          ; 0xc1293
    mov al, bl                                ; 88 d8                       ; 0xc1294 vgabios.c:790
    mov dx, si                                ; 89 f2                       ; 0xc1296
    out DX, AL                                ; ee                          ; 0xc1298
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc1299 vgabios.c:791
    pop si                                    ; 5e                          ; 0xc129c
    pop cx                                    ; 59                          ; 0xc129d
    pop bx                                    ; 5b                          ; 0xc129e
    pop bp                                    ; 5d                          ; 0xc129f
    retn                                      ; c3                          ; 0xc12a0
  ; disGetNextSymbol 0xc12a1 LB 0x3251 -> off=0x0 cb=000000000000006c uValue=00000000000c12a1 'biosfn_set_cursor_pos'
biosfn_set_cursor_pos:                       ; 0xc12a1 LB 0x6c
    push bp                                   ; 55                          ; 0xc12a1 vgabios.c:794
    mov bp, sp                                ; 89 e5                       ; 0xc12a2
    push bx                                   ; 53                          ; 0xc12a4
    push cx                                   ; 51                          ; 0xc12a5
    push si                                   ; 56                          ; 0xc12a6
    mov bx, dx                                ; 89 d3                       ; 0xc12a7
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc12a9 vgabios.c:800
    jnbe short 01305h                         ; 77 58                       ; 0xc12ab
    mov cl, al                                ; 88 c1                       ; 0xc12ad vgabios.c:803
    xor ch, ch                                ; 30 ed                       ; 0xc12af
    mov si, cx                                ; 89 ce                       ; 0xc12b1
    sal si, 1                                 ; d1 e6                       ; 0xc12b3
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc12b5
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc12b8 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc12bb
    mov word [es:si], bx                      ; 26 89 1c                    ; 0xc12bd
    mov si, strict word 00062h                ; be 62 00                    ; 0xc12c0 vgabios.c:47
    mov ah, byte [es:si]                      ; 26 8a 24                    ; 0xc12c3
    cmp al, ah                                ; 38 e0                       ; 0xc12c6 vgabios.c:807
    jne short 01305h                          ; 75 3b                       ; 0xc12c8
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc12ca vgabios.c:57
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc12cd
    mov ax, bx                                ; 89 d8                       ; 0xc12d0 vgabios.c:812
    mov al, ah                                ; 88 e0                       ; 0xc12d2
    xor ah, ah                                ; 30 e4                       ; 0xc12d4
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc12d6 vgabios.c:57
    mov cx, word [es:si]                      ; 26 8b 0c                    ; 0xc12d9
    shr cx, 1                                 ; d1 e9                       ; 0xc12dc vgabios.c:58
    mul dx                                    ; f7 e2                       ; 0xc12de vgabios.c:817
    xor bh, bh                                ; 30 ff                       ; 0xc12e0
    add ax, bx                                ; 01 d8                       ; 0xc12e2
    add cx, ax                                ; 01 c1                       ; 0xc12e4
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc12e6 vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc12e9
    mov AL, strict byte 00eh                  ; b0 0e                       ; 0xc12ec vgabios.c:821
    mov dx, bx                                ; 89 da                       ; 0xc12ee
    out DX, AL                                ; ee                          ; 0xc12f0
    mov al, ch                                ; 88 e8                       ; 0xc12f1 vgabios.c:822
    lea si, [bx+001h]                         ; 8d 77 01                    ; 0xc12f3
    mov dx, si                                ; 89 f2                       ; 0xc12f6
    out DX, AL                                ; ee                          ; 0xc12f8
    mov AL, strict byte 00fh                  ; b0 0f                       ; 0xc12f9 vgabios.c:823
    mov dx, bx                                ; 89 da                       ; 0xc12fb
    out DX, AL                                ; ee                          ; 0xc12fd
    xor ch, ch                                ; 30 ed                       ; 0xc12fe vgabios.c:824
    mov ax, cx                                ; 89 c8                       ; 0xc1300
    mov dx, si                                ; 89 f2                       ; 0xc1302
    out DX, AL                                ; ee                          ; 0xc1304
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc1305 vgabios.c:826
    pop si                                    ; 5e                          ; 0xc1308
    pop cx                                    ; 59                          ; 0xc1309
    pop bx                                    ; 5b                          ; 0xc130a
    pop bp                                    ; 5d                          ; 0xc130b
    retn                                      ; c3                          ; 0xc130c
  ; disGetNextSymbol 0xc130d LB 0x31e5 -> off=0x0 cb=000000000000009f uValue=00000000000c130d 'biosfn_set_active_page'
biosfn_set_active_page:                      ; 0xc130d LB 0x9f
    push bp                                   ; 55                          ; 0xc130d vgabios.c:829
    mov bp, sp                                ; 89 e5                       ; 0xc130e
    push bx                                   ; 53                          ; 0xc1310
    push cx                                   ; 51                          ; 0xc1311
    push dx                                   ; 52                          ; 0xc1312
    push si                                   ; 56                          ; 0xc1313
    push di                                   ; 57                          ; 0xc1314
    push ax                                   ; 50                          ; 0xc1315
    push ax                                   ; 50                          ; 0xc1316
    mov ch, al                                ; 88 c5                       ; 0xc1317
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc1319 vgabios.c:835
    jnbe short 01333h                         ; 77 16                       ; 0xc131b
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc131d vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1320
    mov es, ax                                ; 8e c0                       ; 0xc1323
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1325
    xor ah, ah                                ; 30 e4                       ; 0xc1328 vgabios.c:839
    call 0380ch                               ; e8 df 24                    ; 0xc132a
    mov cl, al                                ; 88 c1                       ; 0xc132d
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc132f vgabios.c:840
    jne short 01335h                          ; 75 02                       ; 0xc1331
    jmp short 013a2h                          ; eb 6d                       ; 0xc1333
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc1335 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1338
    mov es, ax                                ; 8e c0                       ; 0xc133b
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc133d
    mov dl, ch                                ; 88 ea                       ; 0xc1340 vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc1342
    mul dx                                    ; f7 e2                       ; 0xc1344
    mov bx, ax                                ; 89 c3                       ; 0xc1346
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc1348 vgabios.c:62
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc134b
    mov al, cl                                ; 88 c8                       ; 0xc134e vgabios.c:845
    xor ah, ah                                ; 30 e4                       ; 0xc1350
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1352
    mov si, ax                                ; 89 c6                       ; 0xc1354
    sal si, CL                                ; d3 e6                       ; 0xc1356
    cmp byte [si+047adh], 000h                ; 80 bc ad 47 00              ; 0xc1358
    jne short 01361h                          ; 75 02                       ; 0xc135d
    shr bx, 1                                 ; d1 eb                       ; 0xc135f vgabios.c:846
    mov si, strict word 00063h                ; be 63 00                    ; 0xc1361 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1364
    mov es, ax                                ; 8e c0                       ; 0xc1367
    mov si, word [es:si]                      ; 26 8b 34                    ; 0xc1369
    mov AL, strict byte 00ch                  ; b0 0c                       ; 0xc136c vgabios.c:850
    mov dx, si                                ; 89 f2                       ; 0xc136e
    out DX, AL                                ; ee                          ; 0xc1370
    mov al, bh                                ; 88 f8                       ; 0xc1371 vgabios.c:851
    lea di, [si+001h]                         ; 8d 7c 01                    ; 0xc1373
    mov dx, di                                ; 89 fa                       ; 0xc1376
    out DX, AL                                ; ee                          ; 0xc1378
    mov AL, strict byte 00dh                  ; b0 0d                       ; 0xc1379 vgabios.c:852
    mov dx, si                                ; 89 f2                       ; 0xc137b
    out DX, AL                                ; ee                          ; 0xc137d
    xor bh, bh                                ; 30 ff                       ; 0xc137e vgabios.c:853
    mov ax, bx                                ; 89 d8                       ; 0xc1380
    mov dx, di                                ; 89 fa                       ; 0xc1382
    out DX, AL                                ; ee                          ; 0xc1384
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc1385 vgabios.c:52
    mov byte [es:bx], ch                      ; 26 88 2f                    ; 0xc1388
    mov cl, ch                                ; 88 e9                       ; 0xc138b vgabios.c:863
    xor ch, ch                                ; 30 ed                       ; 0xc138d
    lea bx, [bp-00ch]                         ; 8d 5e f4                    ; 0xc138f
    lea dx, [bp-00eh]                         ; 8d 56 f2                    ; 0xc1392
    mov ax, cx                                ; 89 c8                       ; 0xc1395
    call 00a97h                               ; e8 fd f6                    ; 0xc1397
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc139a vgabios.c:865
    mov ax, cx                                ; 89 c8                       ; 0xc139d
    call 012a1h                               ; e8 ff fe                    ; 0xc139f
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc13a2 vgabios.c:866
    pop di                                    ; 5f                          ; 0xc13a5
    pop si                                    ; 5e                          ; 0xc13a6
    pop dx                                    ; 5a                          ; 0xc13a7
    pop cx                                    ; 59                          ; 0xc13a8
    pop bx                                    ; 5b                          ; 0xc13a9
    pop bp                                    ; 5d                          ; 0xc13aa
    retn                                      ; c3                          ; 0xc13ab
  ; disGetNextSymbol 0xc13ac LB 0x3146 -> off=0x0 cb=0000000000000048 uValue=00000000000c13ac 'find_vpti'
find_vpti:                                   ; 0xc13ac LB 0x48
    push bx                                   ; 53                          ; 0xc13ac vgabios.c:901
    push cx                                   ; 51                          ; 0xc13ad
    push si                                   ; 56                          ; 0xc13ae
    push bp                                   ; 55                          ; 0xc13af
    mov bp, sp                                ; 89 e5                       ; 0xc13b0
    mov bl, al                                ; 88 c3                       ; 0xc13b2 vgabios.c:906
    xor bh, bh                                ; 30 ff                       ; 0xc13b4
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc13b6
    mov si, bx                                ; 89 de                       ; 0xc13b8
    sal si, CL                                ; d3 e6                       ; 0xc13ba
    cmp byte [si+047adh], 000h                ; 80 bc ad 47 00              ; 0xc13bc
    jne short 013e9h                          ; 75 26                       ; 0xc13c1
    mov si, 00089h                            ; be 89 00                    ; 0xc13c3 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc13c6
    mov es, ax                                ; 8e c0                       ; 0xc13c9
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc13cb
    test AL, strict byte 010h                 ; a8 10                       ; 0xc13ce vgabios.c:908
    je short 013d8h                           ; 74 06                       ; 0xc13d0
    mov al, byte [bx+07df3h]                  ; 8a 87 f3 7d                 ; 0xc13d2 vgabios.c:909
    jmp short 013e6h                          ; eb 0e                       ; 0xc13d6 vgabios.c:910
    test AL, strict byte 080h                 ; a8 80                       ; 0xc13d8
    je short 013e2h                           ; 74 06                       ; 0xc13da
    mov al, byte [bx+07de3h]                  ; 8a 87 e3 7d                 ; 0xc13dc vgabios.c:911
    jmp short 013e6h                          ; eb 04                       ; 0xc13e0 vgabios.c:912
    mov al, byte [bx+07debh]                  ; 8a 87 eb 7d                 ; 0xc13e2 vgabios.c:913
    cbw                                       ; 98                          ; 0xc13e6
    jmp short 013efh                          ; eb 06                       ; 0xc13e7 vgabios.c:914
    mov al, byte [bx+0482ch]                  ; 8a 87 2c 48                 ; 0xc13e9 vgabios.c:915
    xor ah, ah                                ; 30 e4                       ; 0xc13ed
    pop bp                                    ; 5d                          ; 0xc13ef vgabios.c:918
    pop si                                    ; 5e                          ; 0xc13f0
    pop cx                                    ; 59                          ; 0xc13f1
    pop bx                                    ; 5b                          ; 0xc13f2
    retn                                      ; c3                          ; 0xc13f3
  ; disGetNextSymbol 0xc13f4 LB 0x30fe -> off=0x0 cb=00000000000004d4 uValue=00000000000c13f4 'biosfn_set_video_mode'
biosfn_set_video_mode:                       ; 0xc13f4 LB 0x4d4
    push bp                                   ; 55                          ; 0xc13f4 vgabios.c:923
    mov bp, sp                                ; 89 e5                       ; 0xc13f5
    push bx                                   ; 53                          ; 0xc13f7
    push cx                                   ; 51                          ; 0xc13f8
    push dx                                   ; 52                          ; 0xc13f9
    push si                                   ; 56                          ; 0xc13fa
    push di                                   ; 57                          ; 0xc13fb
    sub sp, strict byte 00018h                ; 83 ec 18                    ; 0xc13fc
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc13ff
    and AL, strict byte 080h                  ; 24 80                       ; 0xc1402 vgabios.c:927
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc1404
    call 00801h                               ; e8 f7 f3                    ; 0xc1407 vgabios.c:937
    test ax, ax                               ; 85 c0                       ; 0xc140a
    je short 0141ah                           ; 74 0c                       ; 0xc140c
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc140e vgabios.c:939
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc1410
    out DX, AL                                ; ee                          ; 0xc1413
    xor al, al                                ; 30 c0                       ; 0xc1414 vgabios.c:940
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc1416
    out DX, AL                                ; ee                          ; 0xc1419
    and byte [bp-00ch], 07fh                  ; 80 66 f4 7f                 ; 0xc141a vgabios.c:945
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc141e vgabios.c:951
    xor ah, ah                                ; 30 e4                       ; 0xc1421
    call 0380ch                               ; e8 e6 23                    ; 0xc1423
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc1426
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc1429 vgabios.c:957
    jne short 01430h                          ; 75 03                       ; 0xc142b
    jmp near 018beh                           ; e9 8e 04                    ; 0xc142d
    mov si, 000a8h                            ; be a8 00                    ; 0xc1430 vgabios.c:67
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1433
    mov es, dx                                ; 8e c2                       ; 0xc1436
    mov bx, word [es:si]                      ; 26 8b 1c                    ; 0xc1438
    mov dx, word [es:si+002h]                 ; 26 8b 54 02                 ; 0xc143b
    mov word [bp-018h], bx                    ; 89 5e e8                    ; 0xc143f vgabios.c:68
    mov word [bp-016h], dx                    ; 89 56 ea                    ; 0xc1442
    mov dl, al                                ; 88 c2                       ; 0xc1445 vgabios.c:963
    xor dh, dh                                ; 30 f6                       ; 0xc1447
    mov ax, dx                                ; 89 d0                       ; 0xc1449
    call 013ach                               ; e8 5e ff                    ; 0xc144b
    mov es, [bp-016h]                         ; 8e 46 ea                    ; 0xc144e vgabios.c:964
    mov si, word [es:bx]                      ; 26 8b 37                    ; 0xc1451
    mov bx, word [es:bx+002h]                 ; 26 8b 5f 02                 ; 0xc1454
    mov word [bp-012h], bx                    ; 89 5e ee                    ; 0xc1458
    xor ah, ah                                ; 30 e4                       ; 0xc145b vgabios.c:965
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc145d
    sal ax, CL                                ; d3 e0                       ; 0xc145f
    add si, ax                                ; 01 c6                       ; 0xc1461
    mov bx, 00089h                            ; bb 89 00                    ; 0xc1463 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1466
    mov es, ax                                ; 8e c0                       ; 0xc1469
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc146b
    mov ch, al                                ; 88 c5                       ; 0xc146e vgabios.c:48
    test AL, strict byte 008h                 ; a8 08                       ; 0xc1470 vgabios.c:982
    jne short 014b7h                          ; 75 43                       ; 0xc1472
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1474 vgabios.c:984
    mov bx, dx                                ; 89 d3                       ; 0xc1476
    sal bx, CL                                ; d3 e3                       ; 0xc1478
    mov al, byte [bx+047b2h]                  ; 8a 87 b2 47                 ; 0xc147a
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc147e
    out DX, AL                                ; ee                          ; 0xc1481
    xor al, al                                ; 30 c0                       ; 0xc1482 vgabios.c:987
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc1484
    out DX, AL                                ; ee                          ; 0xc1487
    mov bl, byte [bx+047b3h]                  ; 8a 9f b3 47                 ; 0xc1488 vgabios.c:990
    cmp bl, 001h                              ; 80 fb 01                    ; 0xc148c
    jc short 0149eh                           ; 72 0d                       ; 0xc148f
    jbe short 014a9h                          ; 76 16                       ; 0xc1491
    cmp bl, cl                                ; 38 cb                       ; 0xc1493
    je short 014bah                           ; 74 23                       ; 0xc1495
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc1497
    je short 014b0h                           ; 74 14                       ; 0xc149a
    jmp short 014bfh                          ; eb 21                       ; 0xc149c
    test bl, bl                               ; 84 db                       ; 0xc149e
    jne short 014bfh                          ; 75 1d                       ; 0xc14a0
    mov word [bp-01ch], 04fc0h                ; c7 46 e4 c0 4f              ; 0xc14a2 vgabios.c:992
    jmp short 014bfh                          ; eb 16                       ; 0xc14a7 vgabios.c:993
    mov word [bp-01ch], 05080h                ; c7 46 e4 80 50              ; 0xc14a9 vgabios.c:995
    jmp short 014bfh                          ; eb 0f                       ; 0xc14ae vgabios.c:996
    mov word [bp-01ch], 05140h                ; c7 46 e4 40 51              ; 0xc14b0 vgabios.c:998
    jmp short 014bfh                          ; eb 08                       ; 0xc14b5 vgabios.c:999
    jmp near 015afh                           ; e9 f5 00                    ; 0xc14b7
    mov word [bp-01ch], 05200h                ; c7 46 e4 00 52              ; 0xc14ba vgabios.c:1001
    mov bl, byte [bp-010h]                    ; 8a 5e f0                    ; 0xc14bf vgabios.c:1005
    xor bh, bh                                ; 30 ff                       ; 0xc14c2
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc14c4
    sal bx, CL                                ; d3 e3                       ; 0xc14c6
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc14c8
    jne short 014deh                          ; 75 0f                       ; 0xc14cd
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc14cf vgabios.c:1007
    cmp byte [es:si+002h], 008h               ; 26 80 7c 02 08              ; 0xc14d2
    jne short 014deh                          ; 75 05                       ; 0xc14d7
    mov word [bp-01ch], 05080h                ; c7 46 e4 80 50              ; 0xc14d9 vgabios.c:1008
    xor bx, bx                                ; 31 db                       ; 0xc14de vgabios.c:1011
    jmp short 014f1h                          ; eb 0f                       ; 0xc14e0
    xor al, al                                ; 30 c0                       ; 0xc14e2 vgabios.c:1018
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc14e4
    out DX, AL                                ; ee                          ; 0xc14e7
    out DX, AL                                ; ee                          ; 0xc14e8 vgabios.c:1019
    out DX, AL                                ; ee                          ; 0xc14e9 vgabios.c:1020
    inc bx                                    ; 43                          ; 0xc14ea vgabios.c:1022
    cmp bx, 00100h                            ; 81 fb 00 01                 ; 0xc14eb
    jnc short 01526h                          ; 73 35                       ; 0xc14ef
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc14f1
    xor ah, ah                                ; 30 e4                       ; 0xc14f4
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc14f6
    mov di, ax                                ; 89 c7                       ; 0xc14f8
    sal di, CL                                ; d3 e7                       ; 0xc14fa
    mov al, byte [di+047b3h]                  ; 8a 85 b3 47                 ; 0xc14fc
    mov di, ax                                ; 89 c7                       ; 0xc1500
    mov al, byte [di+0483ch]                  ; 8a 85 3c 48                 ; 0xc1502
    cmp bx, ax                                ; 39 c3                       ; 0xc1506
    jnbe short 014e2h                         ; 77 d8                       ; 0xc1508
    mov ax, bx                                ; 89 d8                       ; 0xc150a
    mov dx, strict word 00003h                ; ba 03 00                    ; 0xc150c
    mul dx                                    ; f7 e2                       ; 0xc150f
    mov di, word [bp-01ch]                    ; 8b 7e e4                    ; 0xc1511
    add di, ax                                ; 01 c7                       ; 0xc1514
    mov al, byte [di]                         ; 8a 05                       ; 0xc1516
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc1518
    out DX, AL                                ; ee                          ; 0xc151b
    mov al, byte [di+001h]                    ; 8a 45 01                    ; 0xc151c
    out DX, AL                                ; ee                          ; 0xc151f
    mov al, byte [di+002h]                    ; 8a 45 02                    ; 0xc1520
    out DX, AL                                ; ee                          ; 0xc1523
    jmp short 014eah                          ; eb c4                       ; 0xc1524
    test ch, 002h                             ; f6 c5 02                    ; 0xc1526 vgabios.c:1023
    je short 01533h                           ; 74 08                       ; 0xc1529
    mov dx, 00100h                            ; ba 00 01                    ; 0xc152b vgabios.c:1025
    xor ax, ax                                ; 31 c0                       ; 0xc152e
    call 01106h                               ; e8 d3 fb                    ; 0xc1530
    mov dx, 003dah                            ; ba da 03                    ; 0xc1533 vgabios.c:1029
    in AL, DX                                 ; ec                          ; 0xc1536
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1537
    xor bx, bx                                ; 31 db                       ; 0xc1539 vgabios.c:1032
    jmp short 01542h                          ; eb 05                       ; 0xc153b
    cmp bx, strict byte 00013h                ; 83 fb 13                    ; 0xc153d
    jnbe short 01557h                         ; 77 15                       ; 0xc1540
    mov al, bl                                ; 88 d8                       ; 0xc1542 vgabios.c:1033
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc1544
    out DX, AL                                ; ee                          ; 0xc1547
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1548 vgabios.c:1034
    mov di, si                                ; 89 f7                       ; 0xc154b
    add di, bx                                ; 01 df                       ; 0xc154d
    mov al, byte [es:di+023h]                 ; 26 8a 45 23                 ; 0xc154f
    out DX, AL                                ; ee                          ; 0xc1553
    inc bx                                    ; 43                          ; 0xc1554 vgabios.c:1035
    jmp short 0153dh                          ; eb e6                       ; 0xc1555
    mov AL, strict byte 014h                  ; b0 14                       ; 0xc1557 vgabios.c:1036
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc1559
    out DX, AL                                ; ee                          ; 0xc155c
    xor al, al                                ; 30 c0                       ; 0xc155d vgabios.c:1037
    out DX, AL                                ; ee                          ; 0xc155f
    les bx, [bp-018h]                         ; c4 5e e8                    ; 0xc1560 vgabios.c:1040
    mov dx, word [es:bx+004h]                 ; 26 8b 57 04                 ; 0xc1563
    mov ax, word [es:bx+006h]                 ; 26 8b 47 06                 ; 0xc1567
    test ax, ax                               ; 85 c0                       ; 0xc156b
    jne short 01573h                          ; 75 04                       ; 0xc156d
    test dx, dx                               ; 85 d2                       ; 0xc156f
    je short 015afh                           ; 74 3c                       ; 0xc1571
    mov word [bp-01eh], ax                    ; 89 46 e2                    ; 0xc1573 vgabios.c:1044
    xor bx, bx                                ; 31 db                       ; 0xc1576 vgabios.c:1045
    jmp short 0157fh                          ; eb 05                       ; 0xc1578
    cmp bx, strict byte 00010h                ; 83 fb 10                    ; 0xc157a
    jnc short 0159fh                          ; 73 20                       ; 0xc157d
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc157f vgabios.c:1046
    mov di, si                                ; 89 f7                       ; 0xc1582
    add di, bx                                ; 01 df                       ; 0xc1584
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc1586
    mov word [bp-022h], ax                    ; 89 46 de                    ; 0xc1589
    mov cx, dx                                ; 89 d1                       ; 0xc158c
    add cx, bx                                ; 01 d9                       ; 0xc158e
    mov al, byte [es:di+023h]                 ; 26 8a 45 23                 ; 0xc1590
    mov es, [bp-022h]                         ; 8e 46 de                    ; 0xc1594
    mov di, cx                                ; 89 cf                       ; 0xc1597
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc1599
    inc bx                                    ; 43                          ; 0xc159c
    jmp short 0157ah                          ; eb db                       ; 0xc159d
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc159f vgabios.c:1047
    mov al, byte [es:si+034h]                 ; 26 8a 44 34                 ; 0xc15a2
    mov es, [bp-01eh]                         ; 8e 46 e2                    ; 0xc15a6
    mov bx, dx                                ; 89 d3                       ; 0xc15a9
    mov byte [es:bx+010h], al                 ; 26 88 47 10                 ; 0xc15ab
    xor al, al                                ; 30 c0                       ; 0xc15af vgabios.c:1052
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc15b1
    out DX, AL                                ; ee                          ; 0xc15b4
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc15b5 vgabios.c:1053
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc15b7
    out DX, AL                                ; ee                          ; 0xc15ba
    mov bx, strict word 00001h                ; bb 01 00                    ; 0xc15bb vgabios.c:1054
    jmp short 015c5h                          ; eb 05                       ; 0xc15be
    cmp bx, strict byte 00004h                ; 83 fb 04                    ; 0xc15c0
    jnbe short 015ddh                         ; 77 18                       ; 0xc15c3
    mov al, bl                                ; 88 d8                       ; 0xc15c5 vgabios.c:1055
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc15c7
    out DX, AL                                ; ee                          ; 0xc15ca
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc15cb vgabios.c:1056
    mov di, si                                ; 89 f7                       ; 0xc15ce
    add di, bx                                ; 01 df                       ; 0xc15d0
    mov al, byte [es:di+004h]                 ; 26 8a 45 04                 ; 0xc15d2
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc15d6
    out DX, AL                                ; ee                          ; 0xc15d9
    inc bx                                    ; 43                          ; 0xc15da vgabios.c:1057
    jmp short 015c0h                          ; eb e3                       ; 0xc15db
    xor bx, bx                                ; 31 db                       ; 0xc15dd vgabios.c:1060
    jmp short 015e6h                          ; eb 05                       ; 0xc15df
    cmp bx, strict byte 00008h                ; 83 fb 08                    ; 0xc15e1
    jnbe short 015feh                         ; 77 18                       ; 0xc15e4
    mov al, bl                                ; 88 d8                       ; 0xc15e6 vgabios.c:1061
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc15e8
    out DX, AL                                ; ee                          ; 0xc15eb
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc15ec vgabios.c:1062
    mov di, si                                ; 89 f7                       ; 0xc15ef
    add di, bx                                ; 01 df                       ; 0xc15f1
    mov al, byte [es:di+037h]                 ; 26 8a 45 37                 ; 0xc15f3
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc15f7
    out DX, AL                                ; ee                          ; 0xc15fa
    inc bx                                    ; 43                          ; 0xc15fb vgabios.c:1063
    jmp short 015e1h                          ; eb e3                       ; 0xc15fc
    mov bl, byte [bp-010h]                    ; 8a 5e f0                    ; 0xc15fe vgabios.c:1066
    xor bh, bh                                ; 30 ff                       ; 0xc1601
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1603
    sal bx, CL                                ; d3 e3                       ; 0xc1605
    cmp byte [bx+047aeh], 001h                ; 80 bf ae 47 01              ; 0xc1607
    jne short 01613h                          ; 75 05                       ; 0xc160c
    mov bx, 003b4h                            ; bb b4 03                    ; 0xc160e
    jmp short 01616h                          ; eb 03                       ; 0xc1611
    mov bx, 003d4h                            ; bb d4 03                    ; 0xc1613
    mov word [bp-01ah], bx                    ; 89 5e e6                    ; 0xc1616
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1619 vgabios.c:1069
    mov al, byte [es:si+009h]                 ; 26 8a 44 09                 ; 0xc161c
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc1620
    out DX, AL                                ; ee                          ; 0xc1623
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc1624 vgabios.c:1072
    mov dx, bx                                ; 89 da                       ; 0xc1627
    out DX, ax                                ; ef                          ; 0xc1629
    xor bx, bx                                ; 31 db                       ; 0xc162a vgabios.c:1074
    jmp short 01633h                          ; eb 05                       ; 0xc162c
    cmp bx, strict byte 00018h                ; 83 fb 18                    ; 0xc162e
    jnbe short 01649h                         ; 77 16                       ; 0xc1631
    mov al, bl                                ; 88 d8                       ; 0xc1633 vgabios.c:1075
    mov dx, word [bp-01ah]                    ; 8b 56 e6                    ; 0xc1635
    out DX, AL                                ; ee                          ; 0xc1638
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1639 vgabios.c:1076
    mov di, si                                ; 89 f7                       ; 0xc163c
    add di, bx                                ; 01 df                       ; 0xc163e
    inc dx                                    ; 42                          ; 0xc1640
    mov al, byte [es:di+00ah]                 ; 26 8a 45 0a                 ; 0xc1641
    out DX, AL                                ; ee                          ; 0xc1645
    inc bx                                    ; 43                          ; 0xc1646 vgabios.c:1077
    jmp short 0162eh                          ; eb e5                       ; 0xc1647
    mov AL, strict byte 020h                  ; b0 20                       ; 0xc1649 vgabios.c:1080
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc164b
    out DX, AL                                ; ee                          ; 0xc164e
    mov dx, word [bp-01ah]                    ; 8b 56 e6                    ; 0xc164f vgabios.c:1081
    add dx, strict byte 00006h                ; 83 c2 06                    ; 0xc1652
    in AL, DX                                 ; ec                          ; 0xc1655
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc1656
    cmp byte [bp-00eh], 000h                  ; 80 7e f2 00                 ; 0xc1658 vgabios.c:1083
    jne short 016bch                          ; 75 5e                       ; 0xc165c
    mov bl, byte [bp-010h]                    ; 8a 5e f0                    ; 0xc165e vgabios.c:1085
    xor bh, bh                                ; 30 ff                       ; 0xc1661
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1663
    sal bx, CL                                ; d3 e3                       ; 0xc1665
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc1667
    jne short 01680h                          ; 75 12                       ; 0xc166c
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc166e vgabios.c:1087
    mov cx, 04000h                            ; b9 00 40                    ; 0xc1672
    mov ax, 00720h                            ; b8 20 07                    ; 0xc1675
    xor di, di                                ; 31 ff                       ; 0xc1678
    jcxz 0167eh                               ; e3 02                       ; 0xc167a
    rep stosw                                 ; f3 ab                       ; 0xc167c
    jmp short 016bch                          ; eb 3c                       ; 0xc167e vgabios.c:1089
    cmp byte [bp-00ch], 00dh                  ; 80 7e f4 0d                 ; 0xc1680 vgabios.c:1091
    jnc short 01697h                          ; 73 11                       ; 0xc1684
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1686 vgabios.c:1093
    mov cx, 04000h                            ; b9 00 40                    ; 0xc168a
    xor ax, ax                                ; 31 c0                       ; 0xc168d
    xor di, di                                ; 31 ff                       ; 0xc168f
    jcxz 01695h                               ; e3 02                       ; 0xc1691
    rep stosw                                 ; f3 ab                       ; 0xc1693
    jmp short 016bch                          ; eb 25                       ; 0xc1695 vgabios.c:1095
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc1697 vgabios.c:1097
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc1699
    out DX, AL                                ; ee                          ; 0xc169c
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc169d vgabios.c:1098
    in AL, DX                                 ; ec                          ; 0xc16a0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc16a1
    mov word [bp-022h], ax                    ; 89 46 de                    ; 0xc16a3
    mov AL, strict byte 00fh                  ; b0 0f                       ; 0xc16a6 vgabios.c:1099
    out DX, AL                                ; ee                          ; 0xc16a8
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc16a9 vgabios.c:1100
    mov cx, 08000h                            ; b9 00 80                    ; 0xc16ad
    xor ax, ax                                ; 31 c0                       ; 0xc16b0
    xor di, di                                ; 31 ff                       ; 0xc16b2
    jcxz 016b8h                               ; e3 02                       ; 0xc16b4
    rep stosw                                 ; f3 ab                       ; 0xc16b6
    mov al, byte [bp-022h]                    ; 8a 46 de                    ; 0xc16b8 vgabios.c:1101
    out DX, AL                                ; ee                          ; 0xc16bb
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc16bc vgabios.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc16bf
    mov es, ax                                ; 8e c0                       ; 0xc16c2
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc16c4
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc16c7
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc16ca vgabios.c:1108
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc16cd
    xor ah, ah                                ; 30 e4                       ; 0xc16d0
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc16d2 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc16d5
    mov es, dx                                ; 8e c2                       ; 0xc16d8
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc16da
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc16dd vgabios.c:60
    mov ax, word [es:si+003h]                 ; 26 8b 44 03                 ; 0xc16e0
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc16e4 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc16e7
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc16e9
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc16ec vgabios.c:62
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc16ef
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc16f2
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc16f5 vgabios.c:50
    mov al, byte [es:si+001h]                 ; 26 8a 44 01                 ; 0xc16f8
    mov bx, 00084h                            ; bb 84 00                    ; 0xc16fc vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc16ff
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc1701
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1704 vgabios.c:1112
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc1707
    xor ah, ah                                ; 30 e4                       ; 0xc170b
    mov bx, 00085h                            ; bb 85 00                    ; 0xc170d vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc1710
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc1712
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1715 vgabios.c:1113
    mov ah, byte [es:si+014h]                 ; 26 8a 64 14                 ; 0xc1718
    mov al, byte [es:si+015h]                 ; 26 8a 44 15                 ; 0xc171c
    mov bx, strict word 00060h                ; bb 60 00                    ; 0xc1720 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc1723
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc1725
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1728 vgabios.c:1114
    or AL, strict byte 060h                   ; 0c 60                       ; 0xc172b
    mov bx, 00087h                            ; bb 87 00                    ; 0xc172d vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc1730
    mov bx, 00088h                            ; bb 88 00                    ; 0xc1733 vgabios.c:52
    mov byte [es:bx], 0f9h                    ; 26 c6 07 f9                 ; 0xc1736
    mov bx, 0008ah                            ; bb 8a 00                    ; 0xc173a vgabios.c:52
    mov byte [es:bx], 008h                    ; 26 c6 07 08                 ; 0xc173d
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1741 vgabios.c:1120
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc1744
    jnbe short 0176fh                         ; 77 27                       ; 0xc1746
    mov bl, al                                ; 88 c3                       ; 0xc1748 vgabios.c:1122
    xor bh, bh                                ; 30 ff                       ; 0xc174a
    mov al, byte [bx+07ddbh]                  ; 8a 87 db 7d                 ; 0xc174c vgabios.c:50
    mov bx, strict word 00065h                ; bb 65 00                    ; 0xc1750 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc1753
    cmp byte [bp-00ch], 006h                  ; 80 7e f4 06                 ; 0xc1756 vgabios.c:1123
    jne short 01761h                          ; 75 05                       ; 0xc175a
    mov ax, strict word 0003fh                ; b8 3f 00                    ; 0xc175c
    jmp short 01764h                          ; eb 03                       ; 0xc175f
    mov ax, strict word 00030h                ; b8 30 00                    ; 0xc1761
    mov bx, strict word 00066h                ; bb 66 00                    ; 0xc1764 vgabios.c:52
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc1767
    mov es, dx                                ; 8e c2                       ; 0xc176a
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc176c
    xor bx, bx                                ; 31 db                       ; 0xc176f vgabios.c:1128
    jmp short 01778h                          ; eb 05                       ; 0xc1771
    cmp bx, strict byte 00008h                ; 83 fb 08                    ; 0xc1773
    jnc short 01784h                          ; 73 0c                       ; 0xc1776
    mov al, bl                                ; 88 d8                       ; 0xc1778 vgabios.c:1129
    xor ah, ah                                ; 30 e4                       ; 0xc177a
    xor dx, dx                                ; 31 d2                       ; 0xc177c
    call 012a1h                               ; e8 20 fb                    ; 0xc177e
    inc bx                                    ; 43                          ; 0xc1781
    jmp short 01773h                          ; eb ef                       ; 0xc1782
    xor ax, ax                                ; 31 c0                       ; 0xc1784 vgabios.c:1132
    call 0130dh                               ; e8 84 fb                    ; 0xc1786
    mov bl, byte [bp-010h]                    ; 8a 5e f0                    ; 0xc1789 vgabios.c:1135
    xor bh, bh                                ; 30 ff                       ; 0xc178c
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc178e
    sal bx, CL                                ; d3 e3                       ; 0xc1790
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc1792
    jne short 01801h                          ; 75 68                       ; 0xc1797
    les bx, [bp-018h]                         ; c4 5e e8                    ; 0xc1799 vgabios.c:1137
    mov bx, word [es:bx+008h]                 ; 26 8b 5f 08                 ; 0xc179c
    mov word [bp-020h], bx                    ; 89 5e e0                    ; 0xc17a0
    mov bx, word [bp-018h]                    ; 8b 5e e8                    ; 0xc17a3
    mov ax, word [es:bx+00ah]                 ; 26 8b 47 0a                 ; 0xc17a6
    mov word [bp-014h], ax                    ; 89 46 ec                    ; 0xc17aa
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc17ad vgabios.c:1139
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc17b0
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc17b4
    je short 017d8h                           ; 74 20                       ; 0xc17b6
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc17b8
    jne short 01804h                          ; 75 48                       ; 0xc17ba
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc17bc vgabios.c:1141
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc17bf
    xor ah, ah                                ; 30 e4                       ; 0xc17c3
    push ax                                   ; 50                          ; 0xc17c5
    xor al, al                                ; 30 c0                       ; 0xc17c6
    push ax                                   ; 50                          ; 0xc17c8
    push ax                                   ; 50                          ; 0xc17c9
    mov cx, 00100h                            ; b9 00 01                    ; 0xc17ca
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc17cd
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc17d0
    call 02e10h                               ; e8 3a 16                    ; 0xc17d3
    jmp short 01825h                          ; eb 4d                       ; 0xc17d6 vgabios.c:1142
    xor ah, ah                                ; 30 e4                       ; 0xc17d8 vgabios.c:1144
    push ax                                   ; 50                          ; 0xc17da
    xor al, al                                ; 30 c0                       ; 0xc17db
    push ax                                   ; 50                          ; 0xc17dd
    push ax                                   ; 50                          ; 0xc17de
    mov cx, 00100h                            ; b9 00 01                    ; 0xc17df
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc17e2
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc17e5
    call 02e10h                               ; e8 25 16                    ; 0xc17e8
    cmp byte [bp-00ch], 007h                  ; 80 7e f4 07                 ; 0xc17eb vgabios.c:1145
    jne short 01825h                          ; 75 34                       ; 0xc17ef
    mov cx, strict word 0000eh                ; b9 0e 00                    ; 0xc17f1 vgabios.c:1146
    xor bx, bx                                ; 31 db                       ; 0xc17f4
    mov dx, 07b6ah                            ; ba 6a 7b                    ; 0xc17f6
    mov ax, 0c000h                            ; b8 00 c0                    ; 0xc17f9
    call 02d98h                               ; e8 99 15                    ; 0xc17fc
    jmp short 01825h                          ; eb 24                       ; 0xc17ff vgabios.c:1147
    jmp near 01889h                           ; e9 85 00                    ; 0xc1801
    xor ah, ah                                ; 30 e4                       ; 0xc1804 vgabios.c:1149
    push ax                                   ; 50                          ; 0xc1806
    xor al, al                                ; 30 c0                       ; 0xc1807
    push ax                                   ; 50                          ; 0xc1809
    push ax                                   ; 50                          ; 0xc180a
    mov cx, 00100h                            ; b9 00 01                    ; 0xc180b
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc180e
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc1811
    call 02e10h                               ; e8 f9 15                    ; 0xc1814
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc1817 vgabios.c:1150
    xor bx, bx                                ; 31 db                       ; 0xc181a
    mov dx, 07c97h                            ; ba 97 7c                    ; 0xc181c
    mov ax, 0c000h                            ; b8 00 c0                    ; 0xc181f
    call 02d98h                               ; e8 73 15                    ; 0xc1822
    cmp word [bp-014h], strict byte 00000h    ; 83 7e ec 00                 ; 0xc1825 vgabios.c:1152
    jne short 01831h                          ; 75 06                       ; 0xc1829
    cmp word [bp-020h], strict byte 00000h    ; 83 7e e0 00                 ; 0xc182b
    je short 01881h                           ; 74 50                       ; 0xc182f
    xor bx, bx                                ; 31 db                       ; 0xc1831 vgabios.c:1157
    mov es, [bp-014h]                         ; 8e 46 ec                    ; 0xc1833 vgabios.c:1159
    mov di, word [bp-020h]                    ; 8b 7e e0                    ; 0xc1836
    add di, bx                                ; 01 df                       ; 0xc1839
    mov al, byte [es:di+00bh]                 ; 26 8a 45 0b                 ; 0xc183b
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc183f
    je short 0184bh                           ; 74 08                       ; 0xc1841
    cmp al, byte [bp-00ch]                    ; 3a 46 f4                    ; 0xc1843 vgabios.c:1161
    je short 0184bh                           ; 74 03                       ; 0xc1846
    inc bx                                    ; 43                          ; 0xc1848 vgabios.c:1163
    jmp short 01833h                          ; eb e8                       ; 0xc1849 vgabios.c:1164
    mov es, [bp-014h]                         ; 8e 46 ec                    ; 0xc184b vgabios.c:1166
    add bx, word [bp-020h]                    ; 03 5e e0                    ; 0xc184e
    mov al, byte [es:bx+00bh]                 ; 26 8a 47 0b                 ; 0xc1851
    cmp al, byte [bp-00ch]                    ; 3a 46 f4                    ; 0xc1855
    jne short 01881h                          ; 75 27                       ; 0xc1858
    mov bx, word [bp-020h]                    ; 8b 5e e0                    ; 0xc185a vgabios.c:1171
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc185d
    xor ah, ah                                ; 30 e4                       ; 0xc1860
    push ax                                   ; 50                          ; 0xc1862
    mov al, byte [es:bx+001h]                 ; 26 8a 47 01                 ; 0xc1863
    push ax                                   ; 50                          ; 0xc1867
    push word [es:bx+004h]                    ; 26 ff 77 04                 ; 0xc1868
    mov cx, word [es:bx+002h]                 ; 26 8b 4f 02                 ; 0xc186c
    mov bx, word [es:bx+006h]                 ; 26 8b 5f 06                 ; 0xc1870
    mov di, word [bp-020h]                    ; 8b 7e e0                    ; 0xc1874
    mov dx, word [es:di+008h]                 ; 26 8b 55 08                 ; 0xc1877
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc187b
    call 02e10h                               ; e8 8f 15                    ; 0xc187e
    xor bl, bl                                ; 30 db                       ; 0xc1881 vgabios.c:1175
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc1883
    mov AH, strict byte 011h                  ; b4 11                       ; 0xc1885
    int 06dh                                  ; cd 6d                       ; 0xc1887
    mov bx, 0596ah                            ; bb 6a 59                    ; 0xc1889 vgabios.c:1179
    mov cx, ds                                ; 8c d9                       ; 0xc188c
    mov ax, strict word 0001fh                ; b8 1f 00                    ; 0xc188e
    call 009f0h                               ; e8 5c f1                    ; 0xc1891
    mov es, [bp-012h]                         ; 8e 46 ee                    ; 0xc1894 vgabios.c:1181
    mov al, byte [es:si+002h]                 ; 26 8a 44 02                 ; 0xc1897
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc189b
    je short 018b9h                           ; 74 1a                       ; 0xc189d
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc189f
    je short 018b4h                           ; 74 11                       ; 0xc18a1
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc18a3
    jne short 018beh                          ; 75 17                       ; 0xc18a5
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc18a7 vgabios.c:1183
    mov cx, ds                                ; 8c d9                       ; 0xc18aa
    mov ax, strict word 00043h                ; b8 43 00                    ; 0xc18ac
    call 009f0h                               ; e8 3e f1                    ; 0xc18af
    jmp short 018beh                          ; eb 0a                       ; 0xc18b2 vgabios.c:1184
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc18b4 vgabios.c:1186
    jmp short 018aah                          ; eb f1                       ; 0xc18b7
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc18b9 vgabios.c:1189
    jmp short 018aah                          ; eb ec                       ; 0xc18bc
    lea sp, [bp-00ah]                         ; 8d 66 f6                    ; 0xc18be vgabios.c:1192
    pop di                                    ; 5f                          ; 0xc18c1
    pop si                                    ; 5e                          ; 0xc18c2
    pop dx                                    ; 5a                          ; 0xc18c3
    pop cx                                    ; 59                          ; 0xc18c4
    pop bx                                    ; 5b                          ; 0xc18c5
    pop bp                                    ; 5d                          ; 0xc18c6
    retn                                      ; c3                          ; 0xc18c7
  ; disGetNextSymbol 0xc18c8 LB 0x2c2a -> off=0x0 cb=000000000000008e uValue=00000000000c18c8 'vgamem_copy_pl4'
vgamem_copy_pl4:                             ; 0xc18c8 LB 0x8e
    push bp                                   ; 55                          ; 0xc18c8 vgabios.c:1195
    mov bp, sp                                ; 89 e5                       ; 0xc18c9
    push si                                   ; 56                          ; 0xc18cb
    push di                                   ; 57                          ; 0xc18cc
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc18cd
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc18d0
    mov al, dl                                ; 88 d0                       ; 0xc18d3
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc18d5
    mov byte [bp-006h], cl                    ; 88 4e fa                    ; 0xc18d8
    xor ah, ah                                ; 30 e4                       ; 0xc18db vgabios.c:1201
    mov dl, byte [bp+006h]                    ; 8a 56 06                    ; 0xc18dd
    xor dh, dh                                ; 30 f6                       ; 0xc18e0
    mov cx, dx                                ; 89 d1                       ; 0xc18e2
    imul dx                                   ; f7 ea                       ; 0xc18e4
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc18e6
    xor dh, dh                                ; 30 f6                       ; 0xc18e9
    mov si, dx                                ; 89 d6                       ; 0xc18eb
    imul dx                                   ; f7 ea                       ; 0xc18ed
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc18ef
    xor dh, dh                                ; 30 f6                       ; 0xc18f2
    mov bx, dx                                ; 89 d3                       ; 0xc18f4
    add ax, dx                                ; 01 d0                       ; 0xc18f6
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc18f8
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc18fb vgabios.c:1202
    xor ah, ah                                ; 30 e4                       ; 0xc18fe
    imul cx                                   ; f7 e9                       ; 0xc1900
    imul si                                   ; f7 ee                       ; 0xc1902
    add ax, bx                                ; 01 d8                       ; 0xc1904
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc1906
    mov ax, 00105h                            ; b8 05 01                    ; 0xc1909 vgabios.c:1203
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc190c
    out DX, ax                                ; ef                          ; 0xc190f
    xor bl, bl                                ; 30 db                       ; 0xc1910 vgabios.c:1204
    cmp bl, byte [bp+006h]                    ; 3a 5e 06                    ; 0xc1912
    jnc short 01946h                          ; 73 2f                       ; 0xc1915
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1917 vgabios.c:1206
    xor ah, ah                                ; 30 e4                       ; 0xc191a
    mov cx, ax                                ; 89 c1                       ; 0xc191c
    mov al, bl                                ; 88 d8                       ; 0xc191e
    mov dx, ax                                ; 89 c2                       ; 0xc1920
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1922
    mov si, ax                                ; 89 c6                       ; 0xc1925
    mov ax, dx                                ; 89 d0                       ; 0xc1927
    imul si                                   ; f7 ee                       ; 0xc1929
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc192b
    add si, ax                                ; 01 c6                       ; 0xc192e
    mov di, word [bp-00ch]                    ; 8b 7e f4                    ; 0xc1930
    add di, ax                                ; 01 c7                       ; 0xc1933
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1935
    mov es, dx                                ; 8e c2                       ; 0xc1938
    jcxz 01942h                               ; e3 06                       ; 0xc193a
    push DS                                   ; 1e                          ; 0xc193c
    mov ds, dx                                ; 8e da                       ; 0xc193d
    rep movsb                                 ; f3 a4                       ; 0xc193f
    pop DS                                    ; 1f                          ; 0xc1941
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc1942 vgabios.c:1207
    jmp short 01912h                          ; eb cc                       ; 0xc1944
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc1946 vgabios.c:1208
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1949
    out DX, ax                                ; ef                          ; 0xc194c
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc194d vgabios.c:1209
    pop di                                    ; 5f                          ; 0xc1950
    pop si                                    ; 5e                          ; 0xc1951
    pop bp                                    ; 5d                          ; 0xc1952
    retn 00004h                               ; c2 04 00                    ; 0xc1953
  ; disGetNextSymbol 0xc1956 LB 0x2b9c -> off=0x0 cb=000000000000007b uValue=00000000000c1956 'vgamem_fill_pl4'
vgamem_fill_pl4:                             ; 0xc1956 LB 0x7b
    push bp                                   ; 55                          ; 0xc1956 vgabios.c:1212
    mov bp, sp                                ; 89 e5                       ; 0xc1957
    push si                                   ; 56                          ; 0xc1959
    push di                                   ; 57                          ; 0xc195a
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc195b
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc195e
    mov al, dl                                ; 88 d0                       ; 0xc1961
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc1963
    mov bh, cl                                ; 88 cf                       ; 0xc1966
    xor ah, ah                                ; 30 e4                       ; 0xc1968 vgabios.c:1218
    mov dx, ax                                ; 89 c2                       ; 0xc196a
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc196c
    mov cx, ax                                ; 89 c1                       ; 0xc196f
    mov ax, dx                                ; 89 d0                       ; 0xc1971
    imul cx                                   ; f7 e9                       ; 0xc1973
    mov dl, bh                                ; 88 fa                       ; 0xc1975
    xor dh, dh                                ; 30 f6                       ; 0xc1977
    imul dx                                   ; f7 ea                       ; 0xc1979
    mov dx, ax                                ; 89 c2                       ; 0xc197b
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc197d
    xor ah, ah                                ; 30 e4                       ; 0xc1980
    add dx, ax                                ; 01 c2                       ; 0xc1982
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc1984
    mov ax, 00205h                            ; b8 05 02                    ; 0xc1987 vgabios.c:1219
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc198a
    out DX, ax                                ; ef                          ; 0xc198d
    xor bl, bl                                ; 30 db                       ; 0xc198e vgabios.c:1220
    cmp bl, byte [bp+004h]                    ; 3a 5e 04                    ; 0xc1990
    jnc short 019c1h                          ; 73 2c                       ; 0xc1993
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc1995 vgabios.c:1222
    xor ch, ch                                ; 30 ed                       ; 0xc1998
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc199a
    xor ah, ah                                ; 30 e4                       ; 0xc199d
    mov si, ax                                ; 89 c6                       ; 0xc199f
    mov al, bl                                ; 88 d8                       ; 0xc19a1
    mov dx, ax                                ; 89 c2                       ; 0xc19a3
    mov al, bh                                ; 88 f8                       ; 0xc19a5
    mov di, ax                                ; 89 c7                       ; 0xc19a7
    mov ax, dx                                ; 89 d0                       ; 0xc19a9
    imul di                                   ; f7 ef                       ; 0xc19ab
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc19ad
    add di, ax                                ; 01 c7                       ; 0xc19b0
    mov ax, si                                ; 89 f0                       ; 0xc19b2
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc19b4
    mov es, dx                                ; 8e c2                       ; 0xc19b7
    jcxz 019bdh                               ; e3 02                       ; 0xc19b9
    rep stosb                                 ; f3 aa                       ; 0xc19bb
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc19bd vgabios.c:1223
    jmp short 01990h                          ; eb cf                       ; 0xc19bf
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc19c1 vgabios.c:1224
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc19c4
    out DX, ax                                ; ef                          ; 0xc19c7
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc19c8 vgabios.c:1225
    pop di                                    ; 5f                          ; 0xc19cb
    pop si                                    ; 5e                          ; 0xc19cc
    pop bp                                    ; 5d                          ; 0xc19cd
    retn 00004h                               ; c2 04 00                    ; 0xc19ce
  ; disGetNextSymbol 0xc19d1 LB 0x2b21 -> off=0x0 cb=00000000000000b6 uValue=00000000000c19d1 'vgamem_copy_cga'
vgamem_copy_cga:                             ; 0xc19d1 LB 0xb6
    push bp                                   ; 55                          ; 0xc19d1 vgabios.c:1228
    mov bp, sp                                ; 89 e5                       ; 0xc19d2
    push si                                   ; 56                          ; 0xc19d4
    push di                                   ; 57                          ; 0xc19d5
    sub sp, strict byte 0000eh                ; 83 ec 0e                    ; 0xc19d6
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc19d9
    mov byte [bp-008h], bl                    ; 88 5e f8                    ; 0xc19dc
    mov byte [bp-00ah], cl                    ; 88 4e f6                    ; 0xc19df
    mov al, dl                                ; 88 d0                       ; 0xc19e2 vgabios.c:1234
    xor ah, ah                                ; 30 e4                       ; 0xc19e4
    mov bx, ax                                ; 89 c3                       ; 0xc19e6
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc19e8
    mov si, ax                                ; 89 c6                       ; 0xc19eb
    mov ax, bx                                ; 89 d8                       ; 0xc19ed
    imul si                                   ; f7 ee                       ; 0xc19ef
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc19f1
    mov di, bx                                ; 89 df                       ; 0xc19f4
    imul bx                                   ; f7 eb                       ; 0xc19f6
    mov dx, ax                                ; 89 c2                       ; 0xc19f8
    sar dx, 1                                 ; d1 fa                       ; 0xc19fa
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc19fc
    xor ah, ah                                ; 30 e4                       ; 0xc19ff
    mov bx, ax                                ; 89 c3                       ; 0xc1a01
    add dx, ax                                ; 01 c2                       ; 0xc1a03
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc1a05
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1a08 vgabios.c:1235
    imul si                                   ; f7 ee                       ; 0xc1a0b
    imul di                                   ; f7 ef                       ; 0xc1a0d
    sar ax, 1                                 ; d1 f8                       ; 0xc1a0f
    add ax, bx                                ; 01 d8                       ; 0xc1a11
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc1a13
    mov byte [bp-006h], bh                    ; 88 7e fa                    ; 0xc1a16 vgabios.c:1236
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1a19
    xor ah, ah                                ; 30 e4                       ; 0xc1a1c
    cwd                                       ; 99                          ; 0xc1a1e
    db  02bh, 0c2h
    ; sub ax, dx                                ; 2b c2                     ; 0xc1a1f
    sar ax, 1                                 ; d1 f8                       ; 0xc1a21
    mov bx, ax                                ; 89 c3                       ; 0xc1a23
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1a25
    xor ah, ah                                ; 30 e4                       ; 0xc1a28
    cmp ax, bx                                ; 39 d8                       ; 0xc1a2a
    jnl short 01a7eh                          ; 7d 50                       ; 0xc1a2c
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1a2e vgabios.c:1238
    xor bh, bh                                ; 30 ff                       ; 0xc1a31
    mov word [bp-012h], bx                    ; 89 5e ee                    ; 0xc1a33
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc1a36
    imul bx                                   ; f7 eb                       ; 0xc1a39
    mov bx, ax                                ; 89 c3                       ; 0xc1a3b
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc1a3d
    add si, ax                                ; 01 c6                       ; 0xc1a40
    mov di, word [bp-010h]                    ; 8b 7e f0                    ; 0xc1a42
    add di, ax                                ; 01 c7                       ; 0xc1a45
    mov cx, word [bp-012h]                    ; 8b 4e ee                    ; 0xc1a47
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1a4a
    mov es, dx                                ; 8e c2                       ; 0xc1a4d
    jcxz 01a57h                               ; e3 06                       ; 0xc1a4f
    push DS                                   ; 1e                          ; 0xc1a51
    mov ds, dx                                ; 8e da                       ; 0xc1a52
    rep movsb                                 ; f3 a4                       ; 0xc1a54
    pop DS                                    ; 1f                          ; 0xc1a56
    mov si, word [bp-00eh]                    ; 8b 76 f2                    ; 0xc1a57 vgabios.c:1239
    add si, 02000h                            ; 81 c6 00 20                 ; 0xc1a5a
    add si, bx                                ; 01 de                       ; 0xc1a5e
    mov di, word [bp-010h]                    ; 8b 7e f0                    ; 0xc1a60
    add di, 02000h                            ; 81 c7 00 20                 ; 0xc1a63
    add di, bx                                ; 01 df                       ; 0xc1a67
    mov cx, word [bp-012h]                    ; 8b 4e ee                    ; 0xc1a69
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1a6c
    mov es, dx                                ; 8e c2                       ; 0xc1a6f
    jcxz 01a79h                               ; e3 06                       ; 0xc1a71
    push DS                                   ; 1e                          ; 0xc1a73
    mov ds, dx                                ; 8e da                       ; 0xc1a74
    rep movsb                                 ; f3 a4                       ; 0xc1a76
    pop DS                                    ; 1f                          ; 0xc1a78
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1a79 vgabios.c:1240
    jmp short 01a19h                          ; eb 9b                       ; 0xc1a7c
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1a7e vgabios.c:1241
    pop di                                    ; 5f                          ; 0xc1a81
    pop si                                    ; 5e                          ; 0xc1a82
    pop bp                                    ; 5d                          ; 0xc1a83
    retn 00004h                               ; c2 04 00                    ; 0xc1a84
  ; disGetNextSymbol 0xc1a87 LB 0x2a6b -> off=0x0 cb=0000000000000094 uValue=00000000000c1a87 'vgamem_fill_cga'
vgamem_fill_cga:                             ; 0xc1a87 LB 0x94
    push bp                                   ; 55                          ; 0xc1a87 vgabios.c:1244
    mov bp, sp                                ; 89 e5                       ; 0xc1a88
    push si                                   ; 56                          ; 0xc1a8a
    push di                                   ; 57                          ; 0xc1a8b
    sub sp, strict byte 0000ch                ; 83 ec 0c                    ; 0xc1a8c
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc1a8f
    mov al, dl                                ; 88 d0                       ; 0xc1a92
    mov byte [bp-00ch], bl                    ; 88 5e f4                    ; 0xc1a94
    mov byte [bp-008h], cl                    ; 88 4e f8                    ; 0xc1a97
    xor ah, ah                                ; 30 e4                       ; 0xc1a9a vgabios.c:1250
    mov dx, ax                                ; 89 c2                       ; 0xc1a9c
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1a9e
    mov bx, ax                                ; 89 c3                       ; 0xc1aa1
    mov ax, dx                                ; 89 d0                       ; 0xc1aa3
    imul bx                                   ; f7 eb                       ; 0xc1aa5
    mov dl, cl                                ; 88 ca                       ; 0xc1aa7
    xor dh, dh                                ; 30 f6                       ; 0xc1aa9
    imul dx                                   ; f7 ea                       ; 0xc1aab
    mov dx, ax                                ; 89 c2                       ; 0xc1aad
    sar dx, 1                                 ; d1 fa                       ; 0xc1aaf
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1ab1
    xor ah, ah                                ; 30 e4                       ; 0xc1ab4
    add dx, ax                                ; 01 c2                       ; 0xc1ab6
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc1ab8
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc1abb vgabios.c:1251
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1abe
    xor ah, ah                                ; 30 e4                       ; 0xc1ac1
    cwd                                       ; 99                          ; 0xc1ac3
    db  02bh, 0c2h
    ; sub ax, dx                                ; 2b c2                     ; 0xc1ac4
    sar ax, 1                                 ; d1 f8                       ; 0xc1ac6
    mov dx, ax                                ; 89 c2                       ; 0xc1ac8
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1aca
    xor ah, ah                                ; 30 e4                       ; 0xc1acd
    cmp ax, dx                                ; 39 d0                       ; 0xc1acf
    jnl short 01b12h                          ; 7d 3f                       ; 0xc1ad1
    mov bl, byte [bp-00ch]                    ; 8a 5e f4                    ; 0xc1ad3 vgabios.c:1253
    xor bh, bh                                ; 30 ff                       ; 0xc1ad6
    mov dl, byte [bp+006h]                    ; 8a 56 06                    ; 0xc1ad8
    xor dh, dh                                ; 30 f6                       ; 0xc1adb
    mov si, dx                                ; 89 d6                       ; 0xc1add
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc1adf
    imul dx                                   ; f7 ea                       ; 0xc1ae2
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc1ae4
    mov di, word [bp-00eh]                    ; 8b 7e f2                    ; 0xc1ae7
    add di, ax                                ; 01 c7                       ; 0xc1aea
    mov cx, bx                                ; 89 d9                       ; 0xc1aec
    mov ax, si                                ; 89 f0                       ; 0xc1aee
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc1af0
    mov es, dx                                ; 8e c2                       ; 0xc1af3
    jcxz 01af9h                               ; e3 02                       ; 0xc1af5
    rep stosb                                 ; f3 aa                       ; 0xc1af7
    mov di, word [bp-00eh]                    ; 8b 7e f2                    ; 0xc1af9 vgabios.c:1254
    add di, 02000h                            ; 81 c7 00 20                 ; 0xc1afc
    add di, word [bp-010h]                    ; 03 7e f0                    ; 0xc1b00
    mov cx, bx                                ; 89 d9                       ; 0xc1b03
    mov ax, si                                ; 89 f0                       ; 0xc1b05
    mov es, dx                                ; 8e c2                       ; 0xc1b07
    jcxz 01b0dh                               ; e3 02                       ; 0xc1b09
    rep stosb                                 ; f3 aa                       ; 0xc1b0b
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1b0d vgabios.c:1255
    jmp short 01abeh                          ; eb ac                       ; 0xc1b10
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1b12 vgabios.c:1256
    pop di                                    ; 5f                          ; 0xc1b15
    pop si                                    ; 5e                          ; 0xc1b16
    pop bp                                    ; 5d                          ; 0xc1b17
    retn 00004h                               ; c2 04 00                    ; 0xc1b18
  ; disGetNextSymbol 0xc1b1b LB 0x29d7 -> off=0x0 cb=0000000000000083 uValue=00000000000c1b1b 'vgamem_copy_linear'
vgamem_copy_linear:                          ; 0xc1b1b LB 0x83
    push bp                                   ; 55                          ; 0xc1b1b vgabios.c:1259
    mov bp, sp                                ; 89 e5                       ; 0xc1b1c
    push si                                   ; 56                          ; 0xc1b1e
    push di                                   ; 57                          ; 0xc1b1f
    sub sp, strict byte 0000ch                ; 83 ec 0c                    ; 0xc1b20
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc1b23
    mov al, dl                                ; 88 d0                       ; 0xc1b26
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc1b28
    mov bx, cx                                ; 89 cb                       ; 0xc1b2b
    xor ah, ah                                ; 30 e4                       ; 0xc1b2d vgabios.c:1265
    mov si, ax                                ; 89 c6                       ; 0xc1b2f
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1b31
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc1b34
    mov ax, si                                ; 89 f0                       ; 0xc1b37
    imul word [bp-010h]                       ; f7 6e f0                    ; 0xc1b39
    mul word [bp+004h]                        ; f7 66 04                    ; 0xc1b3c
    mov si, ax                                ; 89 c6                       ; 0xc1b3f
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1b41
    xor ah, ah                                ; 30 e4                       ; 0xc1b44
    mov di, ax                                ; 89 c7                       ; 0xc1b46
    add si, ax                                ; 01 c6                       ; 0xc1b48
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1b4a
    sal si, CL                                ; d3 e6                       ; 0xc1b4c
    mov word [bp-00ch], si                    ; 89 76 f4                    ; 0xc1b4e
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1b51 vgabios.c:1266
    imul word [bp-010h]                       ; f7 6e f0                    ; 0xc1b54
    mul word [bp+004h]                        ; f7 66 04                    ; 0xc1b57
    add ax, di                                ; 01 f8                       ; 0xc1b5a
    sal ax, CL                                ; d3 e0                       ; 0xc1b5c
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc1b5e
    sal bx, CL                                ; d3 e3                       ; 0xc1b61 vgabios.c:1267
    sal word [bp+004h], CL                    ; d3 66 04                    ; 0xc1b63 vgabios.c:1268
    mov byte [bp-006h], 000h                  ; c6 46 fa 00                 ; 0xc1b66 vgabios.c:1269
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1b6a
    cmp al, byte [bp+006h]                    ; 3a 46 06                    ; 0xc1b6d
    jnc short 01b95h                          ; 73 23                       ; 0xc1b70
    xor ah, ah                                ; 30 e4                       ; 0xc1b72 vgabios.c:1271
    mul word [bp+004h]                        ; f7 66 04                    ; 0xc1b74
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc1b77
    add si, ax                                ; 01 c6                       ; 0xc1b7a
    mov di, word [bp-00eh]                    ; 8b 7e f2                    ; 0xc1b7c
    add di, ax                                ; 01 c7                       ; 0xc1b7f
    mov cx, bx                                ; 89 d9                       ; 0xc1b81
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1b83
    mov es, dx                                ; 8e c2                       ; 0xc1b86
    jcxz 01b90h                               ; e3 06                       ; 0xc1b88
    push DS                                   ; 1e                          ; 0xc1b8a
    mov ds, dx                                ; 8e da                       ; 0xc1b8b
    rep movsb                                 ; f3 a4                       ; 0xc1b8d
    pop DS                                    ; 1f                          ; 0xc1b8f
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc1b90 vgabios.c:1272
    jmp short 01b6ah                          ; eb d5                       ; 0xc1b93
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1b95 vgabios.c:1273
    pop di                                    ; 5f                          ; 0xc1b98
    pop si                                    ; 5e                          ; 0xc1b99
    pop bp                                    ; 5d                          ; 0xc1b9a
    retn 00004h                               ; c2 04 00                    ; 0xc1b9b
  ; disGetNextSymbol 0xc1b9e LB 0x2954 -> off=0x0 cb=000000000000006c uValue=00000000000c1b9e 'vgamem_fill_linear'
vgamem_fill_linear:                          ; 0xc1b9e LB 0x6c
    push bp                                   ; 55                          ; 0xc1b9e vgabios.c:1276
    mov bp, sp                                ; 89 e5                       ; 0xc1b9f
    push si                                   ; 56                          ; 0xc1ba1
    push di                                   ; 57                          ; 0xc1ba2
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc1ba3
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc1ba6
    mov al, dl                                ; 88 d0                       ; 0xc1ba9
    mov si, cx                                ; 89 ce                       ; 0xc1bab
    xor ah, ah                                ; 30 e4                       ; 0xc1bad vgabios.c:1282
    mov dx, ax                                ; 89 c2                       ; 0xc1baf
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1bb1
    mov di, ax                                ; 89 c7                       ; 0xc1bb4
    mov ax, dx                                ; 89 d0                       ; 0xc1bb6
    imul di                                   ; f7 ef                       ; 0xc1bb8
    mul cx                                    ; f7 e1                       ; 0xc1bba
    mov dx, ax                                ; 89 c2                       ; 0xc1bbc
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1bbe
    xor ah, ah                                ; 30 e4                       ; 0xc1bc1
    add ax, dx                                ; 01 d0                       ; 0xc1bc3
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1bc5
    sal ax, CL                                ; d3 e0                       ; 0xc1bc7
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc1bc9
    sal bx, CL                                ; d3 e3                       ; 0xc1bcc vgabios.c:1283
    sal si, CL                                ; d3 e6                       ; 0xc1bce vgabios.c:1284
    mov byte [bp-008h], 000h                  ; c6 46 f8 00                 ; 0xc1bd0 vgabios.c:1285
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1bd4
    cmp al, byte [bp+004h]                    ; 3a 46 04                    ; 0xc1bd7
    jnc short 01c01h                          ; 73 25                       ; 0xc1bda
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc1bdc vgabios.c:1287
    xor ah, ah                                ; 30 e4                       ; 0xc1bdf
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc1be1
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1be4
    mul si                                    ; f7 e6                       ; 0xc1be7
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc1be9
    add di, ax                                ; 01 c7                       ; 0xc1bec
    mov cx, bx                                ; 89 d9                       ; 0xc1bee
    mov ax, word [bp-00ch]                    ; 8b 46 f4                    ; 0xc1bf0
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc1bf3
    mov es, dx                                ; 8e c2                       ; 0xc1bf6
    jcxz 01bfch                               ; e3 02                       ; 0xc1bf8
    rep stosb                                 ; f3 aa                       ; 0xc1bfa
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc1bfc vgabios.c:1288
    jmp short 01bd4h                          ; eb d3                       ; 0xc1bff
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc1c01 vgabios.c:1289
    pop di                                    ; 5f                          ; 0xc1c04
    pop si                                    ; 5e                          ; 0xc1c05
    pop bp                                    ; 5d                          ; 0xc1c06
    retn 00004h                               ; c2 04 00                    ; 0xc1c07
  ; disGetNextSymbol 0xc1c0a LB 0x28e8 -> off=0x0 cb=00000000000006a4 uValue=00000000000c1c0a 'biosfn_scroll'
biosfn_scroll:                               ; 0xc1c0a LB 0x6a4
    push bp                                   ; 55                          ; 0xc1c0a vgabios.c:1292
    mov bp, sp                                ; 89 e5                       ; 0xc1c0b
    push si                                   ; 56                          ; 0xc1c0d
    push di                                   ; 57                          ; 0xc1c0e
    sub sp, strict byte 00020h                ; 83 ec 20                    ; 0xc1c0f
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc1c12
    mov byte [bp-010h], dl                    ; 88 56 f0                    ; 0xc1c15
    mov byte [bp-00ch], bl                    ; 88 5e f4                    ; 0xc1c18
    mov byte [bp-008h], cl                    ; 88 4e f8                    ; 0xc1c1b
    mov ch, byte [bp+006h]                    ; 8a 6e 06                    ; 0xc1c1e
    cmp bl, byte [bp+004h]                    ; 3a 5e 04                    ; 0xc1c21 vgabios.c:1301
    jnbe short 01c41h                         ; 77 1b                       ; 0xc1c24
    cmp ch, cl                                ; 38 cd                       ; 0xc1c26 vgabios.c:1302
    jc short 01c41h                           ; 72 17                       ; 0xc1c28
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc1c2a vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1c2d
    mov es, ax                                ; 8e c0                       ; 0xc1c30
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1c32
    xor ah, ah                                ; 30 e4                       ; 0xc1c35 vgabios.c:1306
    call 0380ch                               ; e8 d2 1b                    ; 0xc1c37
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc1c3a
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc1c3d vgabios.c:1307
    jne short 01c44h                          ; 75 03                       ; 0xc1c3f
    jmp near 022a5h                           ; e9 61 06                    ; 0xc1c41
    mov bx, 00084h                            ; bb 84 00                    ; 0xc1c44 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1c47
    mov es, ax                                ; 8e c0                       ; 0xc1c4a
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1c4c
    xor ah, ah                                ; 30 e4                       ; 0xc1c4f vgabios.c:48
    inc ax                                    ; 40                          ; 0xc1c51
    mov word [bp-014h], ax                    ; 89 46 ec                    ; 0xc1c52
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc1c55 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc1c58
    mov word [bp-01ch], ax                    ; 89 46 e4                    ; 0xc1c5b vgabios.c:58
    cmp byte [bp+008h], 0ffh                  ; 80 7e 08 ff                 ; 0xc1c5e vgabios.c:1314
    jne short 01c6dh                          ; 75 09                       ; 0xc1c62
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc1c64 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc1c67
    mov byte [bp+008h], al                    ; 88 46 08                    ; 0xc1c6a vgabios.c:48
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1c6d vgabios.c:1317
    xor ah, ah                                ; 30 e4                       ; 0xc1c70
    cmp ax, word [bp-014h]                    ; 3b 46 ec                    ; 0xc1c72
    jc short 01c7fh                           ; 72 08                       ; 0xc1c75
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc1c77
    db  0feh, 0c8h
    ; dec al                                    ; fe c8                     ; 0xc1c7a
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc1c7c
    mov al, ch                                ; 88 e8                       ; 0xc1c7f vgabios.c:1318
    xor ah, ah                                ; 30 e4                       ; 0xc1c81
    cmp ax, word [bp-01ch]                    ; 3b 46 e4                    ; 0xc1c83
    jc short 01c8dh                           ; 72 05                       ; 0xc1c86
    mov ch, byte [bp-01ch]                    ; 8a 6e e4                    ; 0xc1c88
    db  0feh, 0cdh
    ; dec ch                                    ; fe cd                     ; 0xc1c8b
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1c8d vgabios.c:1319
    xor ah, ah                                ; 30 e4                       ; 0xc1c90
    cmp ax, word [bp-014h]                    ; 3b 46 ec                    ; 0xc1c92
    jbe short 01c9ah                          ; 76 03                       ; 0xc1c95
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc1c97
    mov al, ch                                ; 88 e8                       ; 0xc1c9a vgabios.c:1320
    sub al, byte [bp-008h]                    ; 2a 46 f8                    ; 0xc1c9c
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc1c9f
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc1ca1
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc1ca4 vgabios.c:1322
    mov byte [bp-022h], al                    ; 88 46 de                    ; 0xc1ca7
    mov byte [bp-021h], 000h                  ; c6 46 df 00                 ; 0xc1caa
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1cae
    mov bx, word [bp-022h]                    ; 8b 5e de                    ; 0xc1cb0
    sal bx, CL                                ; d3 e3                       ; 0xc1cb3
    mov ax, word [bp-01ch]                    ; 8b 46 e4                    ; 0xc1cb5
    dec ax                                    ; 48                          ; 0xc1cb8
    mov word [bp-018h], ax                    ; 89 46 e8                    ; 0xc1cb9
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc1cbc
    dec ax                                    ; 48                          ; 0xc1cbf
    mov word [bp-024h], ax                    ; 89 46 dc                    ; 0xc1cc0
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc1cc3
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1cc6
    mov di, ax                                ; 89 c7                       ; 0xc1cc9
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc1ccb
    jne short 01d22h                          ; 75 50                       ; 0xc1cd0
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc1cd2 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc1cd5
    mov es, ax                                ; 8e c0                       ; 0xc1cd8
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc1cda
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc1cdd vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc1ce0
    mul dx                                    ; f7 e2                       ; 0xc1ce2
    mov word [bp-020h], ax                    ; 89 46 e0                    ; 0xc1ce4
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1ce7 vgabios.c:1330
    jne short 01d25h                          ; 75 38                       ; 0xc1ceb
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc1ced
    jne short 01d25h                          ; 75 32                       ; 0xc1cf1
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1cf3
    jne short 01d25h                          ; 75 2c                       ; 0xc1cf7
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1cf9
    xor ah, ah                                ; 30 e4                       ; 0xc1cfc
    cmp ax, word [bp-024h]                    ; 3b 46 dc                    ; 0xc1cfe
    jne short 01d25h                          ; 75 22                       ; 0xc1d01
    mov al, ch                                ; 88 e8                       ; 0xc1d03
    cmp ax, word [bp-018h]                    ; 3b 46 e8                    ; 0xc1d05
    jne short 01d25h                          ; 75 1b                       ; 0xc1d08
    mov ah, byte [bp-010h]                    ; 8a 66 f0                    ; 0xc1d0a vgabios.c:1332
    xor al, ch                                ; 30 e8                       ; 0xc1d0d
    add ax, strict word 00020h                ; 05 20 00                    ; 0xc1d0f
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1d12
    mov cx, di                                ; 89 f9                       ; 0xc1d16
    mov di, word [bp-020h]                    ; 8b 7e e0                    ; 0xc1d18
    jcxz 01d1fh                               ; e3 02                       ; 0xc1d1b
    rep stosw                                 ; f3 ab                       ; 0xc1d1d
    jmp near 022a5h                           ; e9 83 05                    ; 0xc1d1f vgabios.c:1334
    jmp near 01eb9h                           ; e9 94 01                    ; 0xc1d22
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1d25 vgabios.c:1336
    jne short 01d90h                          ; 75 65                       ; 0xc1d29
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1d2b vgabios.c:1337
    xor ah, ah                                ; 30 e4                       ; 0xc1d2e
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1d30
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1d33
    xor ah, ah                                ; 30 e4                       ; 0xc1d36
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1d38
    jc short 01d92h                           ; 72 55                       ; 0xc1d3b
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc1d3d vgabios.c:1339
    xor ch, ch                                ; 30 ed                       ; 0xc1d40
    add cx, word [bp-01ah]                    ; 03 4e e6                    ; 0xc1d42
    cmp cx, ax                                ; 39 c1                       ; 0xc1d45
    jnbe short 01d4fh                         ; 77 06                       ; 0xc1d47
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1d49
    jne short 01d95h                          ; 75 46                       ; 0xc1d4d
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1d4f vgabios.c:1340
    mov byte [bp-01eh], al                    ; 88 46 e2                    ; 0xc1d52
    xor al, al                                ; 30 c0                       ; 0xc1d55
    mov byte [bp-01dh], al                    ; 88 46 e3                    ; 0xc1d57
    mov ah, byte [bp-010h]                    ; 8a 66 f0                    ; 0xc1d5a
    mov si, ax                                ; 89 c6                       ; 0xc1d5d
    add si, strict byte 00020h                ; 83 c6 20                    ; 0xc1d5f
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc1d62
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1d65
    mov dx, ax                                ; 89 c2                       ; 0xc1d68
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1d6a
    xor ah, ah                                ; 30 e4                       ; 0xc1d6d
    add ax, dx                                ; 01 d0                       ; 0xc1d6f
    sal ax, 1                                 ; d1 e0                       ; 0xc1d71
    mov di, word [bp-020h]                    ; 8b 7e e0                    ; 0xc1d73
    add di, ax                                ; 01 c7                       ; 0xc1d76
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1d78
    xor bh, bh                                ; 30 ff                       ; 0xc1d7b
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1d7d
    sal bx, CL                                ; d3 e3                       ; 0xc1d7f
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc1d81
    mov cx, word [bp-01eh]                    ; 8b 4e e2                    ; 0xc1d85
    mov ax, si                                ; 89 f0                       ; 0xc1d88
    jcxz 01d8eh                               ; e3 02                       ; 0xc1d8a
    rep stosw                                 ; f3 ab                       ; 0xc1d8c
    jmp short 01de3h                          ; eb 53                       ; 0xc1d8e vgabios.c:1341
    jmp short 01de9h                          ; eb 57                       ; 0xc1d90
    jmp near 022a5h                           ; e9 10 05                    ; 0xc1d92
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1d95 vgabios.c:1342
    mov byte [bp-016h], al                    ; 88 46 ea                    ; 0xc1d98
    mov byte [bp-015h], ah                    ; 88 66 eb                    ; 0xc1d9b
    mov ax, cx                                ; 89 c8                       ; 0xc1d9e
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1da0
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc1da3
    mov byte [bp-01eh], dl                    ; 88 56 e2                    ; 0xc1da6
    mov byte [bp-01dh], 000h                  ; c6 46 e3 00                 ; 0xc1da9
    add ax, word [bp-01eh]                    ; 03 46 e2                    ; 0xc1dad
    sal ax, 1                                 ; d1 e0                       ; 0xc1db0
    mov si, word [bp-020h]                    ; 8b 76 e0                    ; 0xc1db2
    add si, ax                                ; 01 c6                       ; 0xc1db5
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1db7
    xor bh, bh                                ; 30 ff                       ; 0xc1dba
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1dbc
    sal bx, CL                                ; d3 e3                       ; 0xc1dbe
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1dc0
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc1dc4
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1dc7
    add ax, word [bp-01eh]                    ; 03 46 e2                    ; 0xc1dca
    sal ax, 1                                 ; d1 e0                       ; 0xc1dcd
    mov di, word [bp-020h]                    ; 8b 7e e0                    ; 0xc1dcf
    add di, ax                                ; 01 c7                       ; 0xc1dd2
    mov cx, word [bp-016h]                    ; 8b 4e ea                    ; 0xc1dd4
    mov dx, bx                                ; 89 da                       ; 0xc1dd7
    mov es, bx                                ; 8e c3                       ; 0xc1dd9
    jcxz 01de3h                               ; e3 06                       ; 0xc1ddb
    push DS                                   ; 1e                          ; 0xc1ddd
    mov ds, dx                                ; 8e da                       ; 0xc1dde
    rep movsw                                 ; f3 a5                       ; 0xc1de0
    pop DS                                    ; 1f                          ; 0xc1de2
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc1de3 vgabios.c:1343
    jmp near 01d33h                           ; e9 4a ff                    ; 0xc1de6
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1de9 vgabios.c:1346
    xor ah, ah                                ; 30 e4                       ; 0xc1dec
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1dee
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1df1
    xor ah, ah                                ; 30 e4                       ; 0xc1df4
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1df6
    jnbe short 01d92h                         ; 77 97                       ; 0xc1df9
    mov dl, al                                ; 88 c2                       ; 0xc1dfb vgabios.c:1348
    xor dh, dh                                ; 30 f6                       ; 0xc1dfd
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1dff
    add ax, dx                                ; 01 d0                       ; 0xc1e02
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1e04
    jnbe short 01e0fh                         ; 77 06                       ; 0xc1e07
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1e09
    jne short 01e51h                          ; 75 42                       ; 0xc1e0d
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1e0f vgabios.c:1349
    xor bh, bh                                ; 30 ff                       ; 0xc1e12
    mov ah, byte [bp-010h]                    ; 8a 66 f0                    ; 0xc1e14
    xor al, al                                ; 30 c0                       ; 0xc1e17
    mov di, ax                                ; 89 c7                       ; 0xc1e19
    add di, strict byte 00020h                ; 83 c7 20                    ; 0xc1e1b
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc1e1e
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1e21
    mov dx, ax                                ; 89 c2                       ; 0xc1e24
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1e26
    xor ah, ah                                ; 30 e4                       ; 0xc1e29
    add ax, dx                                ; 01 d0                       ; 0xc1e2b
    sal ax, 1                                 ; d1 e0                       ; 0xc1e2d
    mov dx, word [bp-020h]                    ; 8b 56 e0                    ; 0xc1e2f
    add dx, ax                                ; 01 c2                       ; 0xc1e32
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc1e34
    xor ah, ah                                ; 30 e4                       ; 0xc1e37
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1e39
    mov si, ax                                ; 89 c6                       ; 0xc1e3b
    sal si, CL                                ; d3 e6                       ; 0xc1e3d
    mov si, word [si+047b0h]                  ; 8b b4 b0 47                 ; 0xc1e3f
    mov cx, bx                                ; 89 d9                       ; 0xc1e43
    mov ax, di                                ; 89 f8                       ; 0xc1e45
    mov di, dx                                ; 89 d7                       ; 0xc1e47
    mov es, si                                ; 8e c6                       ; 0xc1e49
    jcxz 01e4fh                               ; e3 02                       ; 0xc1e4b
    rep stosw                                 ; f3 ab                       ; 0xc1e4d
    jmp short 01ea9h                          ; eb 58                       ; 0xc1e4f vgabios.c:1350
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc1e51 vgabios.c:1351
    mov byte [bp-01eh], al                    ; 88 46 e2                    ; 0xc1e54
    mov byte [bp-01dh], dh                    ; 88 76 e3                    ; 0xc1e57
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc1e5a
    xor ah, ah                                ; 30 e4                       ; 0xc1e5d
    mov dx, word [bp-01ah]                    ; 8b 56 e6                    ; 0xc1e5f
    sub dx, ax                                ; 29 c2                       ; 0xc1e62
    mov ax, dx                                ; 89 d0                       ; 0xc1e64
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1e66
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc1e69
    mov byte [bp-016h], dl                    ; 88 56 ea                    ; 0xc1e6c
    mov byte [bp-015h], 000h                  ; c6 46 eb 00                 ; 0xc1e6f
    mov si, ax                                ; 89 c6                       ; 0xc1e73
    add si, word [bp-016h]                    ; 03 76 ea                    ; 0xc1e75
    sal si, 1                                 ; d1 e6                       ; 0xc1e78
    add si, word [bp-020h]                    ; 03 76 e0                    ; 0xc1e7a
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1e7d
    xor bh, bh                                ; 30 ff                       ; 0xc1e80
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1e82
    sal bx, CL                                ; d3 e3                       ; 0xc1e84
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1e86
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc1e8a
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1e8d
    add ax, word [bp-016h]                    ; 03 46 ea                    ; 0xc1e90
    sal ax, 1                                 ; d1 e0                       ; 0xc1e93
    mov di, word [bp-020h]                    ; 8b 7e e0                    ; 0xc1e95
    add di, ax                                ; 01 c7                       ; 0xc1e98
    mov cx, word [bp-01eh]                    ; 8b 4e e2                    ; 0xc1e9a
    mov dx, bx                                ; 89 da                       ; 0xc1e9d
    mov es, bx                                ; 8e c3                       ; 0xc1e9f
    jcxz 01ea9h                               ; e3 06                       ; 0xc1ea1
    push DS                                   ; 1e                          ; 0xc1ea3
    mov ds, dx                                ; 8e da                       ; 0xc1ea4
    rep movsw                                 ; f3 a5                       ; 0xc1ea6
    pop DS                                    ; 1f                          ; 0xc1ea8
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1ea9 vgabios.c:1352
    xor ah, ah                                ; 30 e4                       ; 0xc1eac
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1eae
    jc short 01ee7h                           ; 72 34                       ; 0xc1eb1
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc1eb3 vgabios.c:1353
    jmp near 01df1h                           ; e9 38 ff                    ; 0xc1eb6
    mov si, word [bp-022h]                    ; 8b 76 de                    ; 0xc1eb9 vgabios.c:1359
    mov al, byte [si+0482ch]                  ; 8a 84 2c 48                 ; 0xc1ebc
    xor ah, ah                                ; 30 e4                       ; 0xc1ec0
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc1ec2
    mov si, ax                                ; 89 c6                       ; 0xc1ec4
    sal si, CL                                ; d3 e6                       ; 0xc1ec6
    mov al, byte [si+04842h]                  ; 8a 84 42 48                 ; 0xc1ec8
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc1ecc
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc1ecf vgabios.c:1360
    cmp AL, strict byte 003h                  ; 3c 03                       ; 0xc1ed3
    jc short 01ee3h                           ; 72 0c                       ; 0xc1ed5
    jbe short 01eeah                          ; 76 11                       ; 0xc1ed7
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc1ed9
    je short 01f17h                           ; 74 3a                       ; 0xc1edb
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc1edd
    je short 01eeah                           ; 74 09                       ; 0xc1edf
    jmp short 01ee7h                          ; eb 04                       ; 0xc1ee1
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc1ee3
    je short 01f1ah                           ; 74 33                       ; 0xc1ee5
    jmp near 022a5h                           ; e9 bb 03                    ; 0xc1ee7
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1eea vgabios.c:1364
    jne short 01f15h                          ; 75 25                       ; 0xc1eee
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc1ef0
    jne short 01f58h                          ; 75 62                       ; 0xc1ef4
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc1ef6
    jne short 01f58h                          ; 75 5c                       ; 0xc1efa
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1efc
    xor ah, ah                                ; 30 e4                       ; 0xc1eff
    mov dx, word [bp-014h]                    ; 8b 56 ec                    ; 0xc1f01
    dec dx                                    ; 4a                          ; 0xc1f04
    cmp ax, dx                                ; 39 d0                       ; 0xc1f05
    jne short 01f58h                          ; 75 4f                       ; 0xc1f07
    mov al, ch                                ; 88 e8                       ; 0xc1f09
    xor ah, dh                                ; 30 f4                       ; 0xc1f0b
    mov dx, word [bp-01ch]                    ; 8b 56 e4                    ; 0xc1f0d
    dec dx                                    ; 4a                          ; 0xc1f10
    cmp ax, dx                                ; 39 d0                       ; 0xc1f11
    je short 01f1dh                           ; 74 08                       ; 0xc1f13
    jmp short 01f58h                          ; eb 41                       ; 0xc1f15
    jmp near 0217ch                           ; e9 62 02                    ; 0xc1f17
    jmp near 02044h                           ; e9 27 01                    ; 0xc1f1a
    mov ax, 00205h                            ; b8 05 02                    ; 0xc1f1d vgabios.c:1366
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1f20
    out DX, ax                                ; ef                          ; 0xc1f23
    mov ax, word [bp-014h]                    ; 8b 46 ec                    ; 0xc1f24 vgabios.c:1367
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc1f27
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc1f2a
    xor dh, dh                                ; 30 f6                       ; 0xc1f2d
    mul dx                                    ; f7 e2                       ; 0xc1f2f
    mov dl, byte [bp-010h]                    ; 8a 56 f0                    ; 0xc1f31
    xor dh, dh                                ; 30 f6                       ; 0xc1f34
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc1f36
    xor bh, bh                                ; 30 ff                       ; 0xc1f39
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc1f3b
    sal bx, CL                                ; d3 e3                       ; 0xc1f3d
    mov bx, word [bx+047b0h]                  ; 8b 9f b0 47                 ; 0xc1f3f
    mov cx, ax                                ; 89 c1                       ; 0xc1f43
    mov ax, dx                                ; 89 d0                       ; 0xc1f45
    xor di, di                                ; 31 ff                       ; 0xc1f47
    mov es, bx                                ; 8e c3                       ; 0xc1f49
    jcxz 01f4fh                               ; e3 02                       ; 0xc1f4b
    rep stosb                                 ; f3 aa                       ; 0xc1f4d
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc1f4f vgabios.c:1368
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc1f52
    out DX, ax                                ; ef                          ; 0xc1f55
    jmp short 01ee7h                          ; eb 8f                       ; 0xc1f56 vgabios.c:1370
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc1f58 vgabios.c:1372
    jne short 01fcah                          ; 75 6c                       ; 0xc1f5c
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1f5e vgabios.c:1373
    xor ah, ah                                ; 30 e4                       ; 0xc1f61
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1f63
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1f66
    xor ah, ah                                ; 30 e4                       ; 0xc1f69
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1f6b
    jc short 01fc7h                           ; 72 57                       ; 0xc1f6e
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc1f70 vgabios.c:1375
    xor dh, dh                                ; 30 f6                       ; 0xc1f73
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc1f75
    cmp dx, ax                                ; 39 c2                       ; 0xc1f78
    jnbe short 01f82h                         ; 77 06                       ; 0xc1f7a
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc1f7c
    jne short 01fa3h                          ; 75 21                       ; 0xc1f80
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1f82 vgabios.c:1376
    xor ah, ah                                ; 30 e4                       ; 0xc1f85
    push ax                                   ; 50                          ; 0xc1f87
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1f88
    push ax                                   ; 50                          ; 0xc1f8b
    mov cl, byte [bp-01ch]                    ; 8a 4e e4                    ; 0xc1f8c
    xor ch, ch                                ; 30 ed                       ; 0xc1f8f
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1f91
    xor bh, bh                                ; 30 ff                       ; 0xc1f94
    mov dl, byte [bp-01ah]                    ; 8a 56 e6                    ; 0xc1f96
    xor dh, dh                                ; 30 f6                       ; 0xc1f99
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1f9b
    call 01956h                               ; e8 b5 f9                    ; 0xc1f9e
    jmp short 01fc2h                          ; eb 1f                       ; 0xc1fa1 vgabios.c:1377
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1fa3 vgabios.c:1378
    push ax                                   ; 50                          ; 0xc1fa6
    mov al, byte [bp-01ch]                    ; 8a 46 e4                    ; 0xc1fa7
    push ax                                   ; 50                          ; 0xc1faa
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc1fab
    xor ch, ch                                ; 30 ed                       ; 0xc1fae
    mov bl, byte [bp-01ah]                    ; 8a 5e e6                    ; 0xc1fb0
    xor bh, bh                                ; 30 ff                       ; 0xc1fb3
    mov dl, bl                                ; 88 da                       ; 0xc1fb5
    add dl, byte [bp-006h]                    ; 02 56 fa                    ; 0xc1fb7
    xor dh, dh                                ; 30 f6                       ; 0xc1fba
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc1fbc
    call 018c8h                               ; e8 06 f9                    ; 0xc1fbf
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc1fc2 vgabios.c:1379
    jmp short 01f66h                          ; eb 9f                       ; 0xc1fc5
    jmp near 022a5h                           ; e9 db 02                    ; 0xc1fc7
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc1fca vgabios.c:1382
    xor ah, ah                                ; 30 e4                       ; 0xc1fcd
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc1fcf
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc1fd2
    xor ah, ah                                ; 30 e4                       ; 0xc1fd5
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1fd7
    jnbe short 01fc7h                         ; 77 eb                       ; 0xc1fda
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc1fdc vgabios.c:1384
    xor dh, dh                                ; 30 f6                       ; 0xc1fdf
    add ax, dx                                ; 01 d0                       ; 0xc1fe1
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc1fe3
    jnbe short 01fech                         ; 77 04                       ; 0xc1fe6
    test dl, dl                               ; 84 d2                       ; 0xc1fe8
    jne short 0200dh                          ; 75 21                       ; 0xc1fea
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc1fec vgabios.c:1385
    xor ah, ah                                ; 30 e4                       ; 0xc1fef
    push ax                                   ; 50                          ; 0xc1ff1
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc1ff2
    push ax                                   ; 50                          ; 0xc1ff5
    mov cl, byte [bp-01ch]                    ; 8a 4e e4                    ; 0xc1ff6
    xor ch, ch                                ; 30 ed                       ; 0xc1ff9
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc1ffb
    xor bh, bh                                ; 30 ff                       ; 0xc1ffe
    mov dl, byte [bp-01ah]                    ; 8a 56 e6                    ; 0xc2000
    xor dh, dh                                ; 30 f6                       ; 0xc2003
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2005
    call 01956h                               ; e8 4b f9                    ; 0xc2008
    jmp short 02035h                          ; eb 28                       ; 0xc200b vgabios.c:1386
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc200d vgabios.c:1387
    xor ah, ah                                ; 30 e4                       ; 0xc2010
    push ax                                   ; 50                          ; 0xc2012
    mov al, byte [bp-01ch]                    ; 8a 46 e4                    ; 0xc2013
    push ax                                   ; 50                          ; 0xc2016
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc2017
    xor ch, ch                                ; 30 ed                       ; 0xc201a
    mov bl, byte [bp-01ah]                    ; 8a 5e e6                    ; 0xc201c
    xor bh, bh                                ; 30 ff                       ; 0xc201f
    mov dl, bl                                ; 88 da                       ; 0xc2021
    sub dl, byte [bp-006h]                    ; 2a 56 fa                    ; 0xc2023
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2026
    mov byte [bp-016h], al                    ; 88 46 ea                    ; 0xc2029
    mov byte [bp-015h], dh                    ; 88 76 eb                    ; 0xc202c
    mov ax, word [bp-016h]                    ; 8b 46 ea                    ; 0xc202f
    call 018c8h                               ; e8 93 f8                    ; 0xc2032
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2035 vgabios.c:1388
    xor ah, ah                                ; 30 e4                       ; 0xc2038
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc203a
    jc short 02089h                           ; 72 4a                       ; 0xc203d
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc203f vgabios.c:1389
    jmp short 01fd2h                          ; eb 8e                       ; 0xc2042
    mov cl, byte [bx+047afh]                  ; 8a 8f af 47                 ; 0xc2044 vgabios.c:1394
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc2048 vgabios.c:1395
    jne short 0208ch                          ; 75 3e                       ; 0xc204c
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc204e
    jne short 0208ch                          ; 75 38                       ; 0xc2052
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc2054
    jne short 0208ch                          ; 75 32                       ; 0xc2058
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc205a
    cmp ax, word [bp-024h]                    ; 3b 46 dc                    ; 0xc205d
    jne short 0208ch                          ; 75 2a                       ; 0xc2060
    mov al, ch                                ; 88 e8                       ; 0xc2062
    cmp ax, word [bp-018h]                    ; 3b 46 e8                    ; 0xc2064
    jne short 0208ch                          ; 75 23                       ; 0xc2067
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc2069 vgabios.c:1397
    xor dh, dh                                ; 30 f6                       ; 0xc206c
    mov ax, di                                ; 89 f8                       ; 0xc206e
    mul dx                                    ; f7 e2                       ; 0xc2070
    mov dl, cl                                ; 88 ca                       ; 0xc2072
    xor dh, dh                                ; 30 f6                       ; 0xc2074
    mul dx                                    ; f7 e2                       ; 0xc2076
    mov cx, ax                                ; 89 c1                       ; 0xc2078
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc207a
    xor ah, ah                                ; 30 e4                       ; 0xc207d
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc207f
    xor di, di                                ; 31 ff                       ; 0xc2083
    jcxz 02089h                               ; e3 02                       ; 0xc2085
    rep stosb                                 ; f3 aa                       ; 0xc2087
    jmp near 022a5h                           ; e9 19 02                    ; 0xc2089 vgabios.c:1399
    cmp cl, 002h                              ; 80 f9 02                    ; 0xc208c vgabios.c:1401
    jne short 0209ah                          ; 75 09                       ; 0xc208f
    sal byte [bp-008h], 1                     ; d0 66 f8                    ; 0xc2091 vgabios.c:1403
    sal byte [bp-00ah], 1                     ; d0 66 f6                    ; 0xc2094 vgabios.c:1404
    sal word [bp-01ch], 1                     ; d1 66 e4                    ; 0xc2097 vgabios.c:1405
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc209a vgabios.c:1408
    jne short 02109h                          ; 75 69                       ; 0xc209e
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc20a0 vgabios.c:1409
    xor ah, ah                                ; 30 e4                       ; 0xc20a3
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc20a5
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc20a8
    xor ah, ah                                ; 30 e4                       ; 0xc20ab
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc20ad
    jc short 02089h                           ; 72 d7                       ; 0xc20b0
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc20b2 vgabios.c:1411
    xor dh, dh                                ; 30 f6                       ; 0xc20b5
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc20b7
    cmp dx, ax                                ; 39 c2                       ; 0xc20ba
    jnbe short 020c4h                         ; 77 06                       ; 0xc20bc
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc20be
    jne short 020e5h                          ; 75 21                       ; 0xc20c2
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc20c4 vgabios.c:1412
    xor ah, ah                                ; 30 e4                       ; 0xc20c7
    push ax                                   ; 50                          ; 0xc20c9
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc20ca
    push ax                                   ; 50                          ; 0xc20cd
    mov cl, byte [bp-01ch]                    ; 8a 4e e4                    ; 0xc20ce
    xor ch, ch                                ; 30 ed                       ; 0xc20d1
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc20d3
    xor bh, bh                                ; 30 ff                       ; 0xc20d6
    mov dl, byte [bp-01ah]                    ; 8a 56 e6                    ; 0xc20d8
    xor dh, dh                                ; 30 f6                       ; 0xc20db
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc20dd
    call 01a87h                               ; e8 a4 f9                    ; 0xc20e0
    jmp short 02104h                          ; eb 1f                       ; 0xc20e3 vgabios.c:1413
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc20e5 vgabios.c:1414
    push ax                                   ; 50                          ; 0xc20e8
    mov al, byte [bp-01ch]                    ; 8a 46 e4                    ; 0xc20e9
    push ax                                   ; 50                          ; 0xc20ec
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc20ed
    xor ch, ch                                ; 30 ed                       ; 0xc20f0
    mov bl, byte [bp-01ah]                    ; 8a 5e e6                    ; 0xc20f2
    xor bh, bh                                ; 30 ff                       ; 0xc20f5
    mov dl, bl                                ; 88 da                       ; 0xc20f7
    add dl, byte [bp-006h]                    ; 02 56 fa                    ; 0xc20f9
    xor dh, dh                                ; 30 f6                       ; 0xc20fc
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc20fe
    call 019d1h                               ; e8 cd f8                    ; 0xc2101
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc2104 vgabios.c:1415
    jmp short 020a8h                          ; eb 9f                       ; 0xc2107
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2109 vgabios.c:1418
    xor ah, ah                                ; 30 e4                       ; 0xc210c
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc210e
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2111
    xor ah, ah                                ; 30 e4                       ; 0xc2114
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc2116
    jnbe short 0217ah                         ; 77 5f                       ; 0xc2119
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc211b vgabios.c:1420
    xor dh, dh                                ; 30 f6                       ; 0xc211e
    add ax, dx                                ; 01 d0                       ; 0xc2120
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc2122
    jnbe short 0212bh                         ; 77 04                       ; 0xc2125
    test dl, dl                               ; 84 d2                       ; 0xc2127
    jne short 0214ch                          ; 75 21                       ; 0xc2129
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc212b vgabios.c:1421
    xor ah, ah                                ; 30 e4                       ; 0xc212e
    push ax                                   ; 50                          ; 0xc2130
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2131
    push ax                                   ; 50                          ; 0xc2134
    mov cl, byte [bp-01ch]                    ; 8a 4e e4                    ; 0xc2135
    xor ch, ch                                ; 30 ed                       ; 0xc2138
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc213a
    xor bh, bh                                ; 30 ff                       ; 0xc213d
    mov dl, byte [bp-01ah]                    ; 8a 56 e6                    ; 0xc213f
    xor dh, dh                                ; 30 f6                       ; 0xc2142
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2144
    call 01a87h                               ; e8 3d f9                    ; 0xc2147
    jmp short 0216bh                          ; eb 1f                       ; 0xc214a vgabios.c:1422
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc214c vgabios.c:1423
    xor ah, ah                                ; 30 e4                       ; 0xc214f
    push ax                                   ; 50                          ; 0xc2151
    mov al, byte [bp-01ch]                    ; 8a 46 e4                    ; 0xc2152
    push ax                                   ; 50                          ; 0xc2155
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc2156
    xor ch, ch                                ; 30 ed                       ; 0xc2159
    mov bl, byte [bp-01ah]                    ; 8a 5e e6                    ; 0xc215b
    xor bh, bh                                ; 30 ff                       ; 0xc215e
    mov dl, bl                                ; 88 da                       ; 0xc2160
    sub dl, byte [bp-006h]                    ; 2a 56 fa                    ; 0xc2162
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2165
    call 019d1h                               ; e8 66 f8                    ; 0xc2168
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc216b vgabios.c:1424
    xor ah, ah                                ; 30 e4                       ; 0xc216e
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc2170
    jc short 021bbh                           ; 72 46                       ; 0xc2173
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc2175 vgabios.c:1425
    jmp short 02111h                          ; eb 97                       ; 0xc2178
    jmp short 021bbh                          ; eb 3f                       ; 0xc217a
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc217c vgabios.c:1430
    jne short 021beh                          ; 75 3c                       ; 0xc2180
    cmp byte [bp-00ch], 000h                  ; 80 7e f4 00                 ; 0xc2182
    jne short 021beh                          ; 75 36                       ; 0xc2186
    cmp byte [bp-008h], 000h                  ; 80 7e f8 00                 ; 0xc2188
    jne short 021beh                          ; 75 30                       ; 0xc218c
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc218e
    cmp ax, word [bp-024h]                    ; 3b 46 dc                    ; 0xc2191
    jne short 021beh                          ; 75 28                       ; 0xc2194
    mov al, ch                                ; 88 e8                       ; 0xc2196
    cmp ax, word [bp-018h]                    ; 3b 46 e8                    ; 0xc2198
    jne short 021beh                          ; 75 21                       ; 0xc219b
    mov dl, byte [bp-00eh]                    ; 8a 56 f2                    ; 0xc219d vgabios.c:1432
    xor dh, dh                                ; 30 f6                       ; 0xc21a0
    mov ax, di                                ; 89 f8                       ; 0xc21a2
    mul dx                                    ; f7 e2                       ; 0xc21a4
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc21a6
    sal ax, CL                                ; d3 e0                       ; 0xc21a8
    mov cx, ax                                ; 89 c1                       ; 0xc21aa
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc21ac
    xor ah, ah                                ; 30 e4                       ; 0xc21af
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc21b1
    xor di, di                                ; 31 ff                       ; 0xc21b5
    jcxz 021bbh                               ; e3 02                       ; 0xc21b7
    rep stosb                                 ; f3 aa                       ; 0xc21b9
    jmp near 022a5h                           ; e9 e7 00                    ; 0xc21bb vgabios.c:1434
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc21be vgabios.c:1437
    jne short 0222ah                          ; 75 66                       ; 0xc21c2
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc21c4 vgabios.c:1438
    xor ah, ah                                ; 30 e4                       ; 0xc21c7
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc21c9
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc21cc
    xor ah, ah                                ; 30 e4                       ; 0xc21cf
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc21d1
    jc short 021bbh                           ; 72 e5                       ; 0xc21d4
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc21d6 vgabios.c:1440
    xor dh, dh                                ; 30 f6                       ; 0xc21d9
    add dx, word [bp-01ah]                    ; 03 56 e6                    ; 0xc21db
    cmp dx, ax                                ; 39 c2                       ; 0xc21de
    jnbe short 021e8h                         ; 77 06                       ; 0xc21e0
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc21e2
    jne short 02207h                          ; 75 1f                       ; 0xc21e6
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc21e8 vgabios.c:1441
    xor ah, ah                                ; 30 e4                       ; 0xc21eb
    push ax                                   ; 50                          ; 0xc21ed
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc21ee
    push ax                                   ; 50                          ; 0xc21f1
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc21f2
    xor bh, bh                                ; 30 ff                       ; 0xc21f5
    mov dl, byte [bp-01ah]                    ; 8a 56 e6                    ; 0xc21f7
    xor dh, dh                                ; 30 f6                       ; 0xc21fa
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc21fc
    mov cx, word [bp-01ch]                    ; 8b 4e e4                    ; 0xc21ff
    call 01b9eh                               ; e8 99 f9                    ; 0xc2202
    jmp short 02225h                          ; eb 1e                       ; 0xc2205 vgabios.c:1442
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2207 vgabios.c:1443
    push ax                                   ; 50                          ; 0xc220a
    push word [bp-01ch]                       ; ff 76 e4                    ; 0xc220b
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc220e
    xor ch, ch                                ; 30 ed                       ; 0xc2211
    mov bl, byte [bp-01ah]                    ; 8a 5e e6                    ; 0xc2213
    xor bh, bh                                ; 30 ff                       ; 0xc2216
    mov dl, bl                                ; 88 da                       ; 0xc2218
    add dl, byte [bp-006h]                    ; 02 56 fa                    ; 0xc221a
    xor dh, dh                                ; 30 f6                       ; 0xc221d
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc221f
    call 01b1bh                               ; e8 f6 f8                    ; 0xc2222
    inc word [bp-01ah]                        ; ff 46 e6                    ; 0xc2225 vgabios.c:1444
    jmp short 021cch                          ; eb a2                       ; 0xc2228
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc222a vgabios.c:1447
    xor ah, ah                                ; 30 e4                       ; 0xc222d
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc222f
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2232
    xor ah, ah                                ; 30 e4                       ; 0xc2235
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc2237
    jnbe short 022a5h                         ; 77 69                       ; 0xc223a
    mov dl, al                                ; 88 c2                       ; 0xc223c vgabios.c:1449
    xor dh, dh                                ; 30 f6                       ; 0xc223e
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2240
    add ax, dx                                ; 01 d0                       ; 0xc2243
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc2245
    jnbe short 02250h                         ; 77 06                       ; 0xc2248
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc224a
    jne short 0226fh                          ; 75 1f                       ; 0xc224e
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc2250 vgabios.c:1450
    xor ah, ah                                ; 30 e4                       ; 0xc2253
    push ax                                   ; 50                          ; 0xc2255
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2256
    push ax                                   ; 50                          ; 0xc2259
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc225a
    xor bh, bh                                ; 30 ff                       ; 0xc225d
    mov dl, byte [bp-01ah]                    ; 8a 56 e6                    ; 0xc225f
    xor dh, dh                                ; 30 f6                       ; 0xc2262
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2264
    mov cx, word [bp-01ch]                    ; 8b 4e e4                    ; 0xc2267
    call 01b9eh                               ; e8 31 f9                    ; 0xc226a
    jmp short 02296h                          ; eb 27                       ; 0xc226d vgabios.c:1451
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc226f vgabios.c:1452
    xor ah, ah                                ; 30 e4                       ; 0xc2272
    push ax                                   ; 50                          ; 0xc2274
    push word [bp-01ch]                       ; ff 76 e4                    ; 0xc2275
    mov cl, byte [bp-00ah]                    ; 8a 4e f6                    ; 0xc2278
    xor ch, ch                                ; 30 ed                       ; 0xc227b
    mov bl, byte [bp-01ah]                    ; 8a 5e e6                    ; 0xc227d
    xor bh, bh                                ; 30 ff                       ; 0xc2280
    mov dl, bl                                ; 88 da                       ; 0xc2282
    sub dl, byte [bp-006h]                    ; 2a 56 fa                    ; 0xc2284
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2287
    mov byte [bp-01eh], al                    ; 88 46 e2                    ; 0xc228a
    mov byte [bp-01dh], dh                    ; 88 76 e3                    ; 0xc228d
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc2290
    call 01b1bh                               ; e8 85 f8                    ; 0xc2293
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2296 vgabios.c:1453
    xor ah, ah                                ; 30 e4                       ; 0xc2299
    cmp ax, word [bp-01ah]                    ; 3b 46 e6                    ; 0xc229b
    jc short 022a5h                           ; 72 05                       ; 0xc229e
    dec word [bp-01ah]                        ; ff 4e e6                    ; 0xc22a0 vgabios.c:1454
    jmp short 02232h                          ; eb 8d                       ; 0xc22a3
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc22a5 vgabios.c:1465
    pop di                                    ; 5f                          ; 0xc22a8
    pop si                                    ; 5e                          ; 0xc22a9
    pop bp                                    ; 5d                          ; 0xc22aa
    retn 00008h                               ; c2 08 00                    ; 0xc22ab
  ; disGetNextSymbol 0xc22ae LB 0x2244 -> off=0x0 cb=0000000000000112 uValue=00000000000c22ae 'write_gfx_char_pl4'
write_gfx_char_pl4:                          ; 0xc22ae LB 0x112
    push bp                                   ; 55                          ; 0xc22ae vgabios.c:1468
    mov bp, sp                                ; 89 e5                       ; 0xc22af
    push si                                   ; 56                          ; 0xc22b1
    push di                                   ; 57                          ; 0xc22b2
    sub sp, strict byte 00010h                ; 83 ec 10                    ; 0xc22b3
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc22b6
    mov byte [bp-00ah], dl                    ; 88 56 f6                    ; 0xc22b9
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc22bc
    mov al, cl                                ; 88 c8                       ; 0xc22bf
    mov bx, 0010ch                            ; bb 0c 01                    ; 0xc22c1 vgabios.c:67
    xor cx, cx                                ; 31 c9                       ; 0xc22c4
    mov es, cx                                ; 8e c1                       ; 0xc22c6
    mov cx, word [es:bx]                      ; 26 8b 0f                    ; 0xc22c8
    mov bx, word [es:bx+002h]                 ; 26 8b 5f 02                 ; 0xc22cb
    mov word [bp-014h], cx                    ; 89 4e ec                    ; 0xc22cf vgabios.c:68
    mov word [bp-010h], bx                    ; 89 5e f0                    ; 0xc22d2
    xor ah, ah                                ; 30 e4                       ; 0xc22d5 vgabios.c:1477
    mov cl, byte [bp+006h]                    ; 8a 4e 06                    ; 0xc22d7
    xor ch, ch                                ; 30 ed                       ; 0xc22da
    imul cx                                   ; f7 e9                       ; 0xc22dc
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc22de
    xor bh, bh                                ; 30 ff                       ; 0xc22e1
    imul bx                                   ; f7 eb                       ; 0xc22e3
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc22e5
    mov si, bx                                ; 89 de                       ; 0xc22e8
    add si, ax                                ; 01 c6                       ; 0xc22ea
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc22ec vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc22ef
    mov es, ax                                ; 8e c0                       ; 0xc22f2
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc22f4
    mov bl, byte [bp+008h]                    ; 8a 5e 08                    ; 0xc22f7 vgabios.c:58
    xor bh, bh                                ; 30 ff                       ; 0xc22fa
    mul bx                                    ; f7 e3                       ; 0xc22fc
    add si, ax                                ; 01 c6                       ; 0xc22fe
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2300 vgabios.c:1479
    xor ah, ah                                ; 30 e4                       ; 0xc2303
    imul cx                                   ; f7 e9                       ; 0xc2305
    mov word [bp-012h], ax                    ; 89 46 ee                    ; 0xc2307
    mov ax, 00f02h                            ; b8 02 0f                    ; 0xc230a vgabios.c:1480
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc230d
    out DX, ax                                ; ef                          ; 0xc2310
    mov ax, 00205h                            ; b8 05 02                    ; 0xc2311 vgabios.c:1481
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2314
    out DX, ax                                ; ef                          ; 0xc2317
    test byte [bp-00ah], 080h                 ; f6 46 f6 80                 ; 0xc2318 vgabios.c:1482
    je short 02324h                           ; 74 06                       ; 0xc231c
    mov ax, 01803h                            ; b8 03 18                    ; 0xc231e vgabios.c:1484
    out DX, ax                                ; ef                          ; 0xc2321
    jmp short 02328h                          ; eb 04                       ; 0xc2322 vgabios.c:1486
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc2324 vgabios.c:1488
    out DX, ax                                ; ef                          ; 0xc2327
    xor ch, ch                                ; 30 ed                       ; 0xc2328 vgabios.c:1490
    cmp ch, byte [bp+006h]                    ; 3a 6e 06                    ; 0xc232a
    jnc short 02344h                          ; 73 15                       ; 0xc232d
    mov al, ch                                ; 88 e8                       ; 0xc232f vgabios.c:1492
    xor ah, ah                                ; 30 e4                       ; 0xc2331
    mov bl, byte [bp+004h]                    ; 8a 5e 04                    ; 0xc2333
    xor bh, bh                                ; 30 ff                       ; 0xc2336
    imul bx                                   ; f7 eb                       ; 0xc2338
    mov bx, si                                ; 89 f3                       ; 0xc233a
    add bx, ax                                ; 01 c3                       ; 0xc233c
    mov byte [bp-008h], 000h                  ; c6 46 f8 00                 ; 0xc233e vgabios.c:1493
    jmp short 02358h                          ; eb 14                       ; 0xc2342
    jmp short 023a8h                          ; eb 62                       ; 0xc2344 vgabios.c:1502
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2346 vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc2349
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc234b
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc234f vgabios.c:1506
    cmp byte [bp-008h], 008h                  ; 80 7e f8 08                 ; 0xc2352
    jnc short 023a4h                          ; 73 4c                       ; 0xc2356
    mov cl, byte [bp-008h]                    ; 8a 4e f8                    ; 0xc2358
    mov ax, 00080h                            ; b8 80 00                    ; 0xc235b
    sar ax, CL                                ; d3 f8                       ; 0xc235e
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc2360
    mov byte [bp-00dh], 000h                  ; c6 46 f3 00                 ; 0xc2363
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2367
    mov ah, al                                ; 88 c4                       ; 0xc236a
    xor al, al                                ; 30 c0                       ; 0xc236c
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc236e
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2370
    out DX, ax                                ; ef                          ; 0xc2373
    mov dx, bx                                ; 89 da                       ; 0xc2374
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2376
    call 03837h                               ; e8 bb 14                    ; 0xc2379
    mov al, ch                                ; 88 e8                       ; 0xc237c
    xor ah, ah                                ; 30 e4                       ; 0xc237e
    add ax, word [bp-012h]                    ; 03 46 ee                    ; 0xc2380
    mov es, [bp-010h]                         ; 8e 46 f0                    ; 0xc2383
    mov di, word [bp-014h]                    ; 8b 7e ec                    ; 0xc2386
    add di, ax                                ; 01 c7                       ; 0xc2389
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc238b
    xor ah, ah                                ; 30 e4                       ; 0xc238e
    test word [bp-00eh], ax                   ; 85 46 f2                    ; 0xc2390
    je short 02346h                           ; 74 b1                       ; 0xc2393
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2395
    and AL, strict byte 00fh                  ; 24 0f                       ; 0xc2398
    mov di, 0a000h                            ; bf 00 a0                    ; 0xc239a
    mov es, di                                ; 8e c7                       ; 0xc239d
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc239f
    jmp short 0234fh                          ; eb ab                       ; 0xc23a2
    db  0feh, 0c5h
    ; inc ch                                    ; fe c5                     ; 0xc23a4 vgabios.c:1507
    jmp short 0232ah                          ; eb 82                       ; 0xc23a6
    mov ax, 0ff08h                            ; b8 08 ff                    ; 0xc23a8 vgabios.c:1508
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc23ab
    out DX, ax                                ; ef                          ; 0xc23ae
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc23af vgabios.c:1509
    out DX, ax                                ; ef                          ; 0xc23b2
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc23b3 vgabios.c:1510
    out DX, ax                                ; ef                          ; 0xc23b6
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc23b7 vgabios.c:1511
    pop di                                    ; 5f                          ; 0xc23ba
    pop si                                    ; 5e                          ; 0xc23bb
    pop bp                                    ; 5d                          ; 0xc23bc
    retn 00006h                               ; c2 06 00                    ; 0xc23bd
  ; disGetNextSymbol 0xc23c0 LB 0x2132 -> off=0x0 cb=0000000000000112 uValue=00000000000c23c0 'write_gfx_char_cga'
write_gfx_char_cga:                          ; 0xc23c0 LB 0x112
    push si                                   ; 56                          ; 0xc23c0 vgabios.c:1514
    push di                                   ; 57                          ; 0xc23c1
    push bp                                   ; 55                          ; 0xc23c2
    mov bp, sp                                ; 89 e5                       ; 0xc23c3
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc23c5
    mov ch, al                                ; 88 c5                       ; 0xc23c8
    mov byte [bp-002h], dl                    ; 88 56 fe                    ; 0xc23ca
    mov al, bl                                ; 88 d8                       ; 0xc23cd
    mov si, 0556ah                            ; be 6a 55                    ; 0xc23cf vgabios.c:1521
    xor ah, ah                                ; 30 e4                       ; 0xc23d2 vgabios.c:1522
    mov bl, byte [bp+00ah]                    ; 8a 5e 0a                    ; 0xc23d4
    xor bh, bh                                ; 30 ff                       ; 0xc23d7
    imul bx                                   ; f7 eb                       ; 0xc23d9
    mov bx, ax                                ; 89 c3                       ; 0xc23db
    mov al, cl                                ; 88 c8                       ; 0xc23dd
    xor ah, ah                                ; 30 e4                       ; 0xc23df
    mov di, 00140h                            ; bf 40 01                    ; 0xc23e1
    imul di                                   ; f7 ef                       ; 0xc23e4
    add bx, ax                                ; 01 c3                       ; 0xc23e6
    mov word [bp-004h], bx                    ; 89 5e fc                    ; 0xc23e8
    mov al, ch                                ; 88 e8                       ; 0xc23eb vgabios.c:1523
    xor ah, ah                                ; 30 e4                       ; 0xc23ed
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc23ef
    sal ax, CL                                ; d3 e0                       ; 0xc23f1
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc23f3
    xor ch, ch                                ; 30 ed                       ; 0xc23f6 vgabios.c:1524
    jmp near 02417h                           ; e9 1c 00                    ; 0xc23f8
    mov al, ch                                ; 88 e8                       ; 0xc23fb vgabios.c:1539
    xor ah, ah                                ; 30 e4                       ; 0xc23fd
    add ax, word [bp-008h]                    ; 03 46 f8                    ; 0xc23ff
    mov di, si                                ; 89 f7                       ; 0xc2402
    add di, ax                                ; 01 c7                       ; 0xc2404
    mov al, byte [di]                         ; 8a 05                       ; 0xc2406
    mov di, 0b800h                            ; bf 00 b8                    ; 0xc2408 vgabios.c:52
    mov es, di                                ; 8e c7                       ; 0xc240b
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc240d
    db  0feh, 0c5h
    ; inc ch                                    ; fe c5                     ; 0xc2410 vgabios.c:1543
    cmp ch, 008h                              ; 80 fd 08                    ; 0xc2412
    jnc short 0246fh                          ; 73 58                       ; 0xc2415
    mov al, ch                                ; 88 e8                       ; 0xc2417
    xor ah, ah                                ; 30 e4                       ; 0xc2419
    sar ax, 1                                 ; d1 f8                       ; 0xc241b
    mov bx, strict word 00050h                ; bb 50 00                    ; 0xc241d
    imul bx                                   ; f7 eb                       ; 0xc2420
    mov bx, word [bp-004h]                    ; 8b 5e fc                    ; 0xc2422
    add bx, ax                                ; 01 c3                       ; 0xc2425
    test ch, 001h                             ; f6 c5 01                    ; 0xc2427
    je short 0242fh                           ; 74 03                       ; 0xc242a
    add bh, 020h                              ; 80 c7 20                    ; 0xc242c
    mov DL, strict byte 080h                  ; b2 80                       ; 0xc242f
    cmp byte [bp+00ah], 001h                  ; 80 7e 0a 01                 ; 0xc2431
    jne short 02455h                          ; 75 1e                       ; 0xc2435
    test byte [bp-002h], dl                   ; 84 56 fe                    ; 0xc2437
    je short 023fbh                           ; 74 bf                       ; 0xc243a
    mov ax, 0b800h                            ; b8 00 b8                    ; 0xc243c
    mov es, ax                                ; 8e c0                       ; 0xc243f
    mov dl, byte [es:bx]                      ; 26 8a 17                    ; 0xc2441
    mov al, ch                                ; 88 e8                       ; 0xc2444
    xor ah, ah                                ; 30 e4                       ; 0xc2446
    add ax, word [bp-008h]                    ; 03 46 f8                    ; 0xc2448
    mov di, si                                ; 89 f7                       ; 0xc244b
    add di, ax                                ; 01 c7                       ; 0xc244d
    mov al, byte [di]                         ; 8a 05                       ; 0xc244f
    xor al, dl                                ; 30 d0                       ; 0xc2451
    jmp short 02408h                          ; eb b3                       ; 0xc2453
    test dl, dl                               ; 84 d2                       ; 0xc2455 vgabios.c:1545
    jbe short 02410h                          ; 76 b7                       ; 0xc2457
    test byte [bp-002h], 080h                 ; f6 46 fe 80                 ; 0xc2459 vgabios.c:1547
    je short 02469h                           ; 74 0a                       ; 0xc245d
    mov ax, 0b800h                            ; b8 00 b8                    ; 0xc245f vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc2462
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2464
    jmp short 0246bh                          ; eb 02                       ; 0xc2467 vgabios.c:1551
    xor al, al                                ; 30 c0                       ; 0xc2469 vgabios.c:1553
    xor ah, ah                                ; 30 e4                       ; 0xc246b vgabios.c:1555
    jmp short 02476h                          ; eb 07                       ; 0xc246d
    jmp short 024cah                          ; eb 59                       ; 0xc246f
    cmp ah, 004h                              ; 80 fc 04                    ; 0xc2471
    jnc short 024bfh                          ; 73 49                       ; 0xc2474
    mov byte [bp-006h], ch                    ; 88 6e fa                    ; 0xc2476 vgabios.c:1557
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc2479
    mov di, word [bp-008h]                    ; 8b 7e f8                    ; 0xc247d
    add di, word [bp-006h]                    ; 03 7e fa                    ; 0xc2480
    add di, si                                ; 01 f7                       ; 0xc2483
    mov cl, byte [di]                         ; 8a 0d                       ; 0xc2485
    mov byte [bp-00ah], cl                    ; 88 4e f6                    ; 0xc2487
    mov byte [bp-009h], 000h                  ; c6 46 f7 00                 ; 0xc248a
    mov byte [bp-006h], dl                    ; 88 56 fa                    ; 0xc248e
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc2491
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc2495
    test word [bp-006h], di                   ; 85 7e fa                    ; 0xc2498
    je short 024b9h                           ; 74 1c                       ; 0xc249b
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc249d vgabios.c:1558
    sub cl, ah                                ; 28 e1                       ; 0xc249f
    mov dh, byte [bp-002h]                    ; 8a 76 fe                    ; 0xc24a1
    and dh, 003h                              ; 80 e6 03                    ; 0xc24a4
    sal cl, 1                                 ; d0 e1                       ; 0xc24a7
    sal dh, CL                                ; d2 e6                       ; 0xc24a9
    mov cl, dh                                ; 88 f1                       ; 0xc24ab
    test byte [bp-002h], 080h                 ; f6 46 fe 80                 ; 0xc24ad vgabios.c:1559
    je short 024b7h                           ; 74 04                       ; 0xc24b1
    xor al, dh                                ; 30 f0                       ; 0xc24b3 vgabios.c:1561
    jmp short 024b9h                          ; eb 02                       ; 0xc24b5 vgabios.c:1563
    or al, dh                                 ; 08 f0                       ; 0xc24b7 vgabios.c:1565
    shr dl, 1                                 ; d0 ea                       ; 0xc24b9 vgabios.c:1568
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc24bb vgabios.c:1569
    jmp short 02471h                          ; eb b2                       ; 0xc24bd
    mov di, 0b800h                            ; bf 00 b8                    ; 0xc24bf vgabios.c:52
    mov es, di                                ; 8e c7                       ; 0xc24c2
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc24c4
    inc bx                                    ; 43                          ; 0xc24c7 vgabios.c:1571
    jmp short 02455h                          ; eb 8b                       ; 0xc24c8 vgabios.c:1572
    mov sp, bp                                ; 89 ec                       ; 0xc24ca vgabios.c:1575
    pop bp                                    ; 5d                          ; 0xc24cc
    pop di                                    ; 5f                          ; 0xc24cd
    pop si                                    ; 5e                          ; 0xc24ce
    retn 00004h                               ; c2 04 00                    ; 0xc24cf
  ; disGetNextSymbol 0xc24d2 LB 0x2020 -> off=0x0 cb=00000000000000a1 uValue=00000000000c24d2 'write_gfx_char_lin'
write_gfx_char_lin:                          ; 0xc24d2 LB 0xa1
    push si                                   ; 56                          ; 0xc24d2 vgabios.c:1578
    push di                                   ; 57                          ; 0xc24d3
    push bp                                   ; 55                          ; 0xc24d4
    mov bp, sp                                ; 89 e5                       ; 0xc24d5
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc24d7
    mov bh, al                                ; 88 c7                       ; 0xc24da
    mov ch, dl                                ; 88 d5                       ; 0xc24dc
    mov al, cl                                ; 88 c8                       ; 0xc24de
    mov di, 0556ah                            ; bf 6a 55                    ; 0xc24e0 vgabios.c:1585
    xor ah, ah                                ; 30 e4                       ; 0xc24e3 vgabios.c:1586
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc24e5
    xor dh, dh                                ; 30 f6                       ; 0xc24e8
    imul dx                                   ; f7 ea                       ; 0xc24ea
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc24ec
    mov dx, ax                                ; 89 c2                       ; 0xc24ee
    sal dx, CL                                ; d3 e2                       ; 0xc24f0
    mov al, bl                                ; 88 d8                       ; 0xc24f2
    xor ah, ah                                ; 30 e4                       ; 0xc24f4
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc24f6
    sal ax, CL                                ; d3 e0                       ; 0xc24f8
    add ax, dx                                ; 01 d0                       ; 0xc24fa
    mov word [bp-002h], ax                    ; 89 46 fe                    ; 0xc24fc
    mov al, bh                                ; 88 f8                       ; 0xc24ff vgabios.c:1587
    xor ah, ah                                ; 30 e4                       ; 0xc2501
    sal ax, CL                                ; d3 e0                       ; 0xc2503
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc2505
    xor bl, bl                                ; 30 db                       ; 0xc2508 vgabios.c:1588
    jmp short 0254eh                          ; eb 42                       ; 0xc250a
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc250c vgabios.c:1592
    jnc short 02547h                          ; 73 37                       ; 0xc250e
    xor bh, bh                                ; 30 ff                       ; 0xc2510 vgabios.c:1594
    mov dl, bl                                ; 88 da                       ; 0xc2512 vgabios.c:1595
    xor dh, dh                                ; 30 f6                       ; 0xc2514
    add dx, word [bp-006h]                    ; 03 56 fa                    ; 0xc2516
    mov si, di                                ; 89 fe                       ; 0xc2519
    add si, dx                                ; 01 d6                       ; 0xc251b
    mov dl, byte [si]                         ; 8a 14                       ; 0xc251d
    mov byte [bp-004h], dl                    ; 88 56 fc                    ; 0xc251f
    mov byte [bp-003h], bh                    ; 88 7e fd                    ; 0xc2522
    mov dl, ah                                ; 88 e2                       ; 0xc2525
    xor dh, dh                                ; 30 f6                       ; 0xc2527
    test word [bp-004h], dx                   ; 85 56 fc                    ; 0xc2529
    je short 02530h                           ; 74 02                       ; 0xc252c
    mov bh, ch                                ; 88 ef                       ; 0xc252e vgabios.c:1597
    mov dl, al                                ; 88 c2                       ; 0xc2530 vgabios.c:1599
    xor dh, dh                                ; 30 f6                       ; 0xc2532
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc2534
    add si, dx                                ; 01 d6                       ; 0xc2537
    mov dx, 0a000h                            ; ba 00 a0                    ; 0xc2539 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc253c
    mov byte [es:si], bh                      ; 26 88 3c                    ; 0xc253e
    shr ah, 1                                 ; d0 ec                       ; 0xc2541 vgabios.c:1600
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc2543 vgabios.c:1601
    jmp short 0250ch                          ; eb c5                       ; 0xc2545
    db  0feh, 0c3h
    ; inc bl                                    ; fe c3                     ; 0xc2547 vgabios.c:1602
    cmp bl, 008h                              ; 80 fb 08                    ; 0xc2549
    jnc short 0256bh                          ; 73 1d                       ; 0xc254c
    mov al, bl                                ; 88 d8                       ; 0xc254e
    xor ah, ah                                ; 30 e4                       ; 0xc2550
    mov dl, byte [bp+008h]                    ; 8a 56 08                    ; 0xc2552
    xor dh, dh                                ; 30 f6                       ; 0xc2555
    imul dx                                   ; f7 ea                       ; 0xc2557
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2559
    sal ax, CL                                ; d3 e0                       ; 0xc255b
    mov dx, word [bp-002h]                    ; 8b 56 fe                    ; 0xc255d
    add dx, ax                                ; 01 c2                       ; 0xc2560
    mov word [bp-008h], dx                    ; 89 56 f8                    ; 0xc2562
    mov AH, strict byte 080h                  ; b4 80                       ; 0xc2565
    xor al, al                                ; 30 c0                       ; 0xc2567
    jmp short 02510h                          ; eb a5                       ; 0xc2569
    mov sp, bp                                ; 89 ec                       ; 0xc256b vgabios.c:1603
    pop bp                                    ; 5d                          ; 0xc256d
    pop di                                    ; 5f                          ; 0xc256e
    pop si                                    ; 5e                          ; 0xc256f
    retn 00002h                               ; c2 02 00                    ; 0xc2570
  ; disGetNextSymbol 0xc2573 LB 0x1f7f -> off=0x0 cb=000000000000017b uValue=00000000000c2573 'biosfn_write_char_attr'
biosfn_write_char_attr:                      ; 0xc2573 LB 0x17b
    push bp                                   ; 55                          ; 0xc2573 vgabios.c:1606
    mov bp, sp                                ; 89 e5                       ; 0xc2574
    push si                                   ; 56                          ; 0xc2576
    push di                                   ; 57                          ; 0xc2577
    sub sp, strict byte 0001ch                ; 83 ec 1c                    ; 0xc2578
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc257b
    mov byte [bp-00eh], dl                    ; 88 56 f2                    ; 0xc257e
    mov byte [bp-006h], bl                    ; 88 5e fa                    ; 0xc2581
    mov si, cx                                ; 89 ce                       ; 0xc2584
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2586 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2589
    mov es, ax                                ; 8e c0                       ; 0xc258c
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc258e
    xor ah, ah                                ; 30 e4                       ; 0xc2591 vgabios.c:1614
    call 0380ch                               ; e8 76 12                    ; 0xc2593
    mov cl, al                                ; 88 c1                       ; 0xc2596
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc2598
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc259b vgabios.c:1615
    jne short 025a2h                          ; 75 03                       ; 0xc259d
    jmp near 026e7h                           ; e9 45 01                    ; 0xc259f
    mov al, dl                                ; 88 d0                       ; 0xc25a2 vgabios.c:1618
    xor ah, ah                                ; 30 e4                       ; 0xc25a4
    lea bx, [bp-01eh]                         ; 8d 5e e2                    ; 0xc25a6
    lea dx, [bp-020h]                         ; 8d 56 e0                    ; 0xc25a9
    call 00a97h                               ; e8 e8 e4                    ; 0xc25ac
    mov al, byte [bp-01eh]                    ; 8a 46 e2                    ; 0xc25af vgabios.c:1619
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc25b2
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc25b5
    mov al, ah                                ; 88 e0                       ; 0xc25b8
    xor ah, ah                                ; 30 e4                       ; 0xc25ba
    mov word [bp-01ah], ax                    ; 89 46 e6                    ; 0xc25bc
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc25bf
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc25c2
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc25c5 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc25c8
    mov es, ax                                ; 8e c0                       ; 0xc25cb
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc25cd
    mov word [bp-01ch], ax                    ; 89 46 e4                    ; 0xc25d0
    mov word [bp-018h], ax                    ; 89 46 e8                    ; 0xc25d3 vgabios.c:58
    mov al, cl                                ; 88 c8                       ; 0xc25d6 vgabios.c:1625
    xor ah, ah                                ; 30 e4                       ; 0xc25d8
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc25da
    mov di, ax                                ; 89 c7                       ; 0xc25dc
    sal di, CL                                ; d3 e7                       ; 0xc25de
    cmp byte [di+047adh], 000h                ; 80 bd ad 47 00              ; 0xc25e0
    jne short 02624h                          ; 75 3d                       ; 0xc25e5
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc25e7 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc25ea
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc25ed vgabios.c:58
    mul dx                                    ; f7 e2                       ; 0xc25f0
    mov bx, ax                                ; 89 c3                       ; 0xc25f2
    mov al, byte [bp-01ah]                    ; 8a 46 e6                    ; 0xc25f4 vgabios.c:1629
    xor ah, ah                                ; 30 e4                       ; 0xc25f7
    mul word [bp-01ch]                        ; f7 66 e4                    ; 0xc25f9
    mov dx, ax                                ; 89 c2                       ; 0xc25fc
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc25fe
    xor ah, ah                                ; 30 e4                       ; 0xc2601
    add ax, dx                                ; 01 d0                       ; 0xc2603
    sal ax, 1                                 ; d1 e0                       ; 0xc2605
    add bx, ax                                ; 01 c3                       ; 0xc2607
    mov dh, byte [bp-006h]                    ; 8a 76 fa                    ; 0xc2609 vgabios.c:1631
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc260c
    mov word [bp-020h], dx                    ; 89 56 e0                    ; 0xc260f
    mov ax, word [bp-020h]                    ; 8b 46 e0                    ; 0xc2612 vgabios.c:1632
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc2615
    mov cx, si                                ; 89 f1                       ; 0xc2619
    mov di, bx                                ; 89 df                       ; 0xc261b
    jcxz 02621h                               ; e3 02                       ; 0xc261d
    rep stosw                                 ; f3 ab                       ; 0xc261f
    jmp near 026e7h                           ; e9 c3 00                    ; 0xc2621 vgabios.c:1634
    mov bx, ax                                ; 89 c3                       ; 0xc2624 vgabios.c:1637
    mov al, byte [bx+0482ch]                  ; 8a 87 2c 48                 ; 0xc2626
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc262a
    mov bx, ax                                ; 89 c3                       ; 0xc262c
    sal bx, CL                                ; d3 e3                       ; 0xc262e
    mov al, byte [bx+04842h]                  ; 8a 87 42 48                 ; 0xc2630
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc2634
    mov al, byte [di+047afh]                  ; 8a 85 af 47                 ; 0xc2637 vgabios.c:1638
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc263b
    dec si                                    ; 4e                          ; 0xc263e vgabios.c:1639
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc263f
    je short 02691h                           ; 74 4d                       ; 0xc2642
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc2644 vgabios.c:1641
    xor bh, bh                                ; 30 ff                       ; 0xc2647
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2649
    sal bx, CL                                ; d3 e3                       ; 0xc264b
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc264d
    cmp al, cl                                ; 38 c8                       ; 0xc2651
    jc short 02662h                           ; 72 0d                       ; 0xc2653
    jbe short 02668h                          ; 76 11                       ; 0xc2655
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc2657
    je short 026bdh                           ; 74 62                       ; 0xc2659
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc265b
    je short 0266ch                           ; 74 0d                       ; 0xc265d
    jmp near 026e1h                           ; e9 7f 00                    ; 0xc265f
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc2662
    je short 02693h                           ; 74 2d                       ; 0xc2664
    jmp short 026e1h                          ; eb 79                       ; 0xc2666
    or byte [bp-006h], 001h                   ; 80 4e fa 01                 ; 0xc2668 vgabios.c:1644
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc266c vgabios.c:1646
    xor ah, ah                                ; 30 e4                       ; 0xc266f
    push ax                                   ; 50                          ; 0xc2671
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc2672
    push ax                                   ; 50                          ; 0xc2675
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc2676
    push ax                                   ; 50                          ; 0xc2679
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc267a
    xor ch, ch                                ; 30 ed                       ; 0xc267d
    mov bl, byte [bp-008h]                    ; 8a 5e f8                    ; 0xc267f
    xor bh, bh                                ; 30 ff                       ; 0xc2682
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc2684
    xor dh, dh                                ; 30 f6                       ; 0xc2687
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2689
    call 022aeh                               ; e8 1f fc                    ; 0xc268c
    jmp short 026e1h                          ; eb 50                       ; 0xc268f vgabios.c:1647
    jmp short 026e7h                          ; eb 54                       ; 0xc2691
    mov al, byte [bp-010h]                    ; 8a 46 f0                    ; 0xc2693 vgabios.c:1649
    xor ah, ah                                ; 30 e4                       ; 0xc2696
    push ax                                   ; 50                          ; 0xc2698
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc2699
    push ax                                   ; 50                          ; 0xc269c
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc269d
    xor ch, ch                                ; 30 ed                       ; 0xc26a0
    mov bl, byte [bp-008h]                    ; 8a 5e f8                    ; 0xc26a2
    xor bh, bh                                ; 30 ff                       ; 0xc26a5
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc26a7
    xor dh, dh                                ; 30 f6                       ; 0xc26aa
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc26ac
    mov byte [bp-016h], al                    ; 88 46 ea                    ; 0xc26af
    mov byte [bp-015h], ah                    ; 88 66 eb                    ; 0xc26b2
    mov ax, word [bp-016h]                    ; 8b 46 ea                    ; 0xc26b5
    call 023c0h                               ; e8 05 fd                    ; 0xc26b8
    jmp short 026e1h                          ; eb 24                       ; 0xc26bb vgabios.c:1650
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc26bd vgabios.c:1652
    xor ah, ah                                ; 30 e4                       ; 0xc26c0
    push ax                                   ; 50                          ; 0xc26c2
    mov cl, byte [bp-00ch]                    ; 8a 4e f4                    ; 0xc26c3
    xor ch, ch                                ; 30 ed                       ; 0xc26c6
    mov bl, byte [bp-008h]                    ; 8a 5e f8                    ; 0xc26c8
    xor bh, bh                                ; 30 ff                       ; 0xc26cb
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc26cd
    xor dh, dh                                ; 30 f6                       ; 0xc26d0
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc26d2
    mov byte [bp-016h], al                    ; 88 46 ea                    ; 0xc26d5
    mov byte [bp-015h], ah                    ; 88 66 eb                    ; 0xc26d8
    mov ax, word [bp-016h]                    ; 8b 46 ea                    ; 0xc26db
    call 024d2h                               ; e8 f1 fd                    ; 0xc26de
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc26e1 vgabios.c:1659
    jmp near 0263eh                           ; e9 57 ff                    ; 0xc26e4 vgabios.c:1660
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc26e7 vgabios.c:1662
    pop di                                    ; 5f                          ; 0xc26ea
    pop si                                    ; 5e                          ; 0xc26eb
    pop bp                                    ; 5d                          ; 0xc26ec
    retn                                      ; c3                          ; 0xc26ed
  ; disGetNextSymbol 0xc26ee LB 0x1e04 -> off=0x0 cb=0000000000000173 uValue=00000000000c26ee 'biosfn_write_char_only'
biosfn_write_char_only:                      ; 0xc26ee LB 0x173
    push bp                                   ; 55                          ; 0xc26ee vgabios.c:1665
    mov bp, sp                                ; 89 e5                       ; 0xc26ef
    push si                                   ; 56                          ; 0xc26f1
    push di                                   ; 57                          ; 0xc26f2
    sub sp, strict byte 0001ah                ; 83 ec 1a                    ; 0xc26f3
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc26f6
    mov byte [bp-00eh], dl                    ; 88 56 f2                    ; 0xc26f9
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc26fc
    mov si, cx                                ; 89 ce                       ; 0xc26ff
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2701 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2704
    mov es, ax                                ; 8e c0                       ; 0xc2707
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2709
    xor ah, ah                                ; 30 e4                       ; 0xc270c vgabios.c:1673
    call 0380ch                               ; e8 fb 10                    ; 0xc270e
    mov cl, al                                ; 88 c1                       ; 0xc2711
    mov byte [bp-012h], al                    ; 88 46 ee                    ; 0xc2713
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc2716 vgabios.c:1674
    jne short 0271dh                          ; 75 03                       ; 0xc2718
    jmp near 0285ah                           ; e9 3d 01                    ; 0xc271a
    mov al, dl                                ; 88 d0                       ; 0xc271d vgabios.c:1677
    xor ah, ah                                ; 30 e4                       ; 0xc271f
    lea bx, [bp-01eh]                         ; 8d 5e e2                    ; 0xc2721
    lea dx, [bp-01ch]                         ; 8d 56 e4                    ; 0xc2724
    call 00a97h                               ; e8 6d e3                    ; 0xc2727
    mov al, byte [bp-01eh]                    ; 8a 46 e2                    ; 0xc272a vgabios.c:1678
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc272d
    mov ax, word [bp-01eh]                    ; 8b 46 e2                    ; 0xc2730
    mov al, ah                                ; 88 e0                       ; 0xc2733
    xor ah, ah                                ; 30 e4                       ; 0xc2735
    mov word [bp-016h], ax                    ; 89 46 ea                    ; 0xc2737
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc273a
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc273d
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2740 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2743
    mov es, ax                                ; 8e c0                       ; 0xc2746
    mov di, word [es:bx]                      ; 26 8b 3f                    ; 0xc2748
    mov word [bp-018h], di                    ; 89 7e e8                    ; 0xc274b vgabios.c:58
    mov al, cl                                ; 88 c8                       ; 0xc274e vgabios.c:1684
    xor ah, ah                                ; 30 e4                       ; 0xc2750
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2752
    mov bx, ax                                ; 89 c3                       ; 0xc2754
    sal bx, CL                                ; d3 e3                       ; 0xc2756
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2758
    jne short 0279dh                          ; 75 3e                       ; 0xc275d
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc275f vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc2762
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2765 vgabios.c:58
    mul dx                                    ; f7 e2                       ; 0xc2768
    mov bx, ax                                ; 89 c3                       ; 0xc276a
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc276c vgabios.c:1688
    xor ah, ah                                ; 30 e4                       ; 0xc276f
    mul di                                    ; f7 e7                       ; 0xc2771
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc2773
    xor dh, dh                                ; 30 f6                       ; 0xc2776
    add ax, dx                                ; 01 d0                       ; 0xc2778
    sal ax, 1                                 ; d1 e0                       ; 0xc277a
    add bx, ax                                ; 01 c3                       ; 0xc277c
    dec si                                    ; 4e                          ; 0xc277e vgabios.c:1690
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc277f
    je short 0271ah                           ; 74 96                       ; 0xc2782
    mov al, byte [bp-012h]                    ; 8a 46 ee                    ; 0xc2784 vgabios.c:1691
    xor ah, ah                                ; 30 e4                       ; 0xc2787
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2789
    mov di, ax                                ; 89 c7                       ; 0xc278b
    sal di, CL                                ; d3 e7                       ; 0xc278d
    mov es, [di+047b0h]                       ; 8e 85 b0 47                 ; 0xc278f vgabios.c:50
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2793
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2796
    inc bx                                    ; 43                          ; 0xc2799 vgabios.c:1692
    inc bx                                    ; 43                          ; 0xc279a
    jmp short 0277eh                          ; eb e1                       ; 0xc279b vgabios.c:1693
    mov di, ax                                ; 89 c7                       ; 0xc279d vgabios.c:1698
    mov al, byte [di+0482ch]                  ; 8a 85 2c 48                 ; 0xc279f
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc27a3
    mov di, ax                                ; 89 c7                       ; 0xc27a5
    sal di, CL                                ; d3 e7                       ; 0xc27a7
    mov al, byte [di+04842h]                  ; 8a 85 42 48                 ; 0xc27a9
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc27ad
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc27b0 vgabios.c:1699
    mov byte [bp-014h], al                    ; 88 46 ec                    ; 0xc27b4
    dec si                                    ; 4e                          ; 0xc27b7 vgabios.c:1700
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc27b8
    je short 02816h                           ; 74 59                       ; 0xc27bb
    mov bl, byte [bp-012h]                    ; 8a 5e ee                    ; 0xc27bd vgabios.c:1702
    xor bh, bh                                ; 30 ff                       ; 0xc27c0
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc27c2
    sal bx, CL                                ; d3 e3                       ; 0xc27c4
    mov bl, byte [bx+047aeh]                  ; 8a 9f ae 47                 ; 0xc27c6
    cmp bl, cl                                ; 38 cb                       ; 0xc27ca
    jc short 027ddh                           ; 72 0f                       ; 0xc27cc
    jbe short 027e4h                          ; 76 14                       ; 0xc27ce
    cmp bl, 005h                              ; 80 fb 05                    ; 0xc27d0
    je short 02839h                           ; 74 64                       ; 0xc27d3
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc27d5
    je short 027e8h                           ; 74 0e                       ; 0xc27d8
    jmp near 02854h                           ; e9 77 00                    ; 0xc27da
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc27dd
    je short 02818h                           ; 74 36                       ; 0xc27e0
    jmp short 02854h                          ; eb 70                       ; 0xc27e2
    or byte [bp-00ah], 001h                   ; 80 4e f6 01                 ; 0xc27e4 vgabios.c:1705
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc27e8 vgabios.c:1707
    xor ah, ah                                ; 30 e4                       ; 0xc27eb
    push ax                                   ; 50                          ; 0xc27ed
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc27ee
    push ax                                   ; 50                          ; 0xc27f1
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc27f2
    push ax                                   ; 50                          ; 0xc27f5
    mov cl, byte [bp-010h]                    ; 8a 4e f0                    ; 0xc27f6
    xor ch, ch                                ; 30 ed                       ; 0xc27f9
    mov bl, byte [bp-008h]                    ; 8a 5e f8                    ; 0xc27fb
    xor bh, bh                                ; 30 ff                       ; 0xc27fe
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc2800
    xor dh, dh                                ; 30 f6                       ; 0xc2803
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2805
    mov byte [bp-01ah], al                    ; 88 46 e6                    ; 0xc2808
    mov byte [bp-019h], ah                    ; 88 66 e7                    ; 0xc280b
    mov ax, word [bp-01ah]                    ; 8b 46 e6                    ; 0xc280e
    call 022aeh                               ; e8 9a fa                    ; 0xc2811
    jmp short 02854h                          ; eb 3e                       ; 0xc2814 vgabios.c:1708
    jmp short 0285ah                          ; eb 42                       ; 0xc2816
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc2818 vgabios.c:1710
    xor ah, ah                                ; 30 e4                       ; 0xc281b
    push ax                                   ; 50                          ; 0xc281d
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc281e
    push ax                                   ; 50                          ; 0xc2821
    mov cl, byte [bp-010h]                    ; 8a 4e f0                    ; 0xc2822
    xor ch, ch                                ; 30 ed                       ; 0xc2825
    mov bl, byte [bp-008h]                    ; 8a 5e f8                    ; 0xc2827
    xor bh, bh                                ; 30 ff                       ; 0xc282a
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc282c
    xor dh, dh                                ; 30 f6                       ; 0xc282f
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2831
    call 023c0h                               ; e8 89 fb                    ; 0xc2834
    jmp short 02854h                          ; eb 1b                       ; 0xc2837 vgabios.c:1711
    mov al, byte [bp-018h]                    ; 8a 46 e8                    ; 0xc2839 vgabios.c:1713
    xor ah, ah                                ; 30 e4                       ; 0xc283c
    push ax                                   ; 50                          ; 0xc283e
    mov cl, byte [bp-010h]                    ; 8a 4e f0                    ; 0xc283f
    xor ch, ch                                ; 30 ed                       ; 0xc2842
    mov bl, byte [bp-008h]                    ; 8a 5e f8                    ; 0xc2844
    xor bh, bh                                ; 30 ff                       ; 0xc2847
    mov dl, byte [bp-00ah]                    ; 8a 56 f6                    ; 0xc2849
    xor dh, dh                                ; 30 f6                       ; 0xc284c
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc284e
    call 024d2h                               ; e8 7e fc                    ; 0xc2851
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc2854 vgabios.c:1720
    jmp near 027b7h                           ; e9 5d ff                    ; 0xc2857 vgabios.c:1721
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc285a vgabios.c:1723
    pop di                                    ; 5f                          ; 0xc285d
    pop si                                    ; 5e                          ; 0xc285e
    pop bp                                    ; 5d                          ; 0xc285f
    retn                                      ; c3                          ; 0xc2860
  ; disGetNextSymbol 0xc2861 LB 0x1c91 -> off=0x0 cb=000000000000017a uValue=00000000000c2861 'biosfn_write_pixel'
biosfn_write_pixel:                          ; 0xc2861 LB 0x17a
    push bp                                   ; 55                          ; 0xc2861 vgabios.c:1726
    mov bp, sp                                ; 89 e5                       ; 0xc2862
    push si                                   ; 56                          ; 0xc2864
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc2865
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2868
    mov byte [bp-004h], dl                    ; 88 56 fc                    ; 0xc286b
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc286e
    mov word [bp-00ah], cx                    ; 89 4e f6                    ; 0xc2871
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2874 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2877
    mov es, ax                                ; 8e c0                       ; 0xc287a
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc287c
    xor ah, ah                                ; 30 e4                       ; 0xc287f vgabios.c:1733
    call 0380ch                               ; e8 88 0f                    ; 0xc2881
    mov ch, al                                ; 88 c5                       ; 0xc2884
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc2886 vgabios.c:1734
    je short 028b1h                           ; 74 27                       ; 0xc2888
    mov bl, al                                ; 88 c3                       ; 0xc288a vgabios.c:1735
    xor bh, bh                                ; 30 ff                       ; 0xc288c
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc288e
    sal bx, CL                                ; d3 e3                       ; 0xc2890
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2892
    je short 028b1h                           ; 74 18                       ; 0xc2897
    mov al, byte [bx+047aeh]                  ; 8a 87 ae 47                 ; 0xc2899 vgabios.c:1737
    cmp al, cl                                ; 38 c8                       ; 0xc289d
    jc short 028adh                           ; 72 0c                       ; 0xc289f
    jbe short 028b7h                          ; 76 14                       ; 0xc28a1
    cmp AL, strict byte 005h                  ; 3c 05                       ; 0xc28a3
    je short 028b4h                           ; 74 0d                       ; 0xc28a5
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc28a7
    je short 028b7h                           ; 74 0c                       ; 0xc28a9
    jmp short 028b1h                          ; eb 04                       ; 0xc28ab
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc28ad
    je short 02929h                           ; 74 78                       ; 0xc28af
    jmp near 029b4h                           ; e9 00 01                    ; 0xc28b1
    jmp near 029bah                           ; e9 03 01                    ; 0xc28b4
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc28b7 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc28ba
    mov es, ax                                ; 8e c0                       ; 0xc28bd
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc28bf
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc28c2 vgabios.c:58
    mul dx                                    ; f7 e2                       ; 0xc28c5
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc28c7
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc28c9
    shr bx, CL                                ; d3 eb                       ; 0xc28cc
    add bx, ax                                ; 01 c3                       ; 0xc28ce
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc28d0 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc28d3
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc28d6 vgabios.c:58
    xor dh, dh                                ; 30 f6                       ; 0xc28d9
    mul dx                                    ; f7 e2                       ; 0xc28db
    add bx, ax                                ; 01 c3                       ; 0xc28dd
    mov cx, word [bp-008h]                    ; 8b 4e f8                    ; 0xc28df vgabios.c:1743
    and cl, 007h                              ; 80 e1 07                    ; 0xc28e2
    mov ax, 00080h                            ; b8 80 00                    ; 0xc28e5
    sar ax, CL                                ; d3 f8                       ; 0xc28e8
    mov ah, al                                ; 88 c4                       ; 0xc28ea vgabios.c:1744
    xor al, al                                ; 30 c0                       ; 0xc28ec
    or AL, strict byte 008h                   ; 0c 08                       ; 0xc28ee
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc28f0
    out DX, ax                                ; ef                          ; 0xc28f3
    mov ax, 00205h                            ; b8 05 02                    ; 0xc28f4 vgabios.c:1745
    out DX, ax                                ; ef                          ; 0xc28f7
    mov dx, bx                                ; 89 da                       ; 0xc28f8 vgabios.c:1746
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc28fa
    call 03837h                               ; e8 37 0f                    ; 0xc28fd
    test byte [bp-004h], 080h                 ; f6 46 fc 80                 ; 0xc2900 vgabios.c:1747
    je short 0290dh                           ; 74 07                       ; 0xc2904
    mov ax, 01803h                            ; b8 03 18                    ; 0xc2906 vgabios.c:1749
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2909
    out DX, ax                                ; ef                          ; 0xc290c
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc290d vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc2910
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc2912
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2915
    mov ax, 0ff08h                            ; b8 08 ff                    ; 0xc2918 vgabios.c:1752
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc291b
    out DX, ax                                ; ef                          ; 0xc291e
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc291f vgabios.c:1753
    out DX, ax                                ; ef                          ; 0xc2922
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc2923 vgabios.c:1754
    out DX, ax                                ; ef                          ; 0xc2926
    jmp short 028b1h                          ; eb 88                       ; 0xc2927 vgabios.c:1755
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc2929 vgabios.c:1757
    shr ax, 1                                 ; d1 e8                       ; 0xc292c
    mov dx, strict word 00050h                ; ba 50 00                    ; 0xc292e
    mul dx                                    ; f7 e2                       ; 0xc2931
    cmp byte [bx+047afh], 002h                ; 80 bf af 47 02              ; 0xc2933
    jne short 02943h                          ; 75 09                       ; 0xc2938
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc293a vgabios.c:1759
    shr bx, 1                                 ; d1 eb                       ; 0xc293d
    shr bx, 1                                 ; d1 eb                       ; 0xc293f
    jmp short 02948h                          ; eb 05                       ; 0xc2941 vgabios.c:1761
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc2943 vgabios.c:1763
    shr bx, CL                                ; d3 eb                       ; 0xc2946
    add bx, ax                                ; 01 c3                       ; 0xc2948
    test byte [bp-00ah], 001h                 ; f6 46 f6 01                 ; 0xc294a vgabios.c:1765
    je short 02953h                           ; 74 03                       ; 0xc294e
    add bh, 020h                              ; 80 c7 20                    ; 0xc2950
    mov ax, 0b800h                            ; b8 00 b8                    ; 0xc2953 vgabios.c:47
    mov es, ax                                ; 8e c0                       ; 0xc2956
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2958
    mov dl, ch                                ; 88 ea                       ; 0xc295b vgabios.c:1767
    xor dh, dh                                ; 30 f6                       ; 0xc295d
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc295f
    mov si, dx                                ; 89 d6                       ; 0xc2961
    sal si, CL                                ; d3 e6                       ; 0xc2963
    cmp byte [si+047afh], 002h                ; 80 bc af 47 02              ; 0xc2965
    jne short 02986h                          ; 75 1a                       ; 0xc296a
    mov ah, byte [bp-008h]                    ; 8a 66 f8                    ; 0xc296c vgabios.c:1769
    and ah, cl                                ; 20 cc                       ; 0xc296f
    mov dl, cl                                ; 88 ca                       ; 0xc2971
    sub dl, ah                                ; 28 e2                       ; 0xc2973
    mov ah, dl                                ; 88 d4                       ; 0xc2975
    sal ah, 1                                 ; d0 e4                       ; 0xc2977
    mov dl, byte [bp-004h]                    ; 8a 56 fc                    ; 0xc2979
    and dl, cl                                ; 20 ca                       ; 0xc297c
    mov cl, ah                                ; 88 e1                       ; 0xc297e
    sal dl, CL                                ; d2 e2                       ; 0xc2980
    mov AH, strict byte 003h                  ; b4 03                       ; 0xc2982 vgabios.c:1770
    jmp short 0299ah                          ; eb 14                       ; 0xc2984 vgabios.c:1772
    mov ah, byte [bp-008h]                    ; 8a 66 f8                    ; 0xc2986 vgabios.c:1774
    and ah, 007h                              ; 80 e4 07                    ; 0xc2989
    mov CL, strict byte 007h                  ; b1 07                       ; 0xc298c
    sub cl, ah                                ; 28 e1                       ; 0xc298e
    mov dl, byte [bp-004h]                    ; 8a 56 fc                    ; 0xc2990
    and dl, 001h                              ; 80 e2 01                    ; 0xc2993
    sal dl, CL                                ; d2 e2                       ; 0xc2996
    mov AH, strict byte 001h                  ; b4 01                       ; 0xc2998 vgabios.c:1775
    sal ah, CL                                ; d2 e4                       ; 0xc299a
    test byte [bp-004h], 080h                 ; f6 46 fc 80                 ; 0xc299c vgabios.c:1777
    je short 029a6h                           ; 74 04                       ; 0xc29a0
    xor al, dl                                ; 30 d0                       ; 0xc29a2 vgabios.c:1779
    jmp short 029ach                          ; eb 06                       ; 0xc29a4 vgabios.c:1781
    not ah                                    ; f6 d4                       ; 0xc29a6 vgabios.c:1783
    and al, ah                                ; 20 e0                       ; 0xc29a8
    or al, dl                                 ; 08 d0                       ; 0xc29aa vgabios.c:1784
    mov dx, 0b800h                            ; ba 00 b8                    ; 0xc29ac vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc29af
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc29b1
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc29b4 vgabios.c:1787
    pop si                                    ; 5e                          ; 0xc29b7
    pop bp                                    ; 5d                          ; 0xc29b8
    retn                                      ; c3                          ; 0xc29b9
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc29ba vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc29bd
    mov es, ax                                ; 8e c0                       ; 0xc29c0
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc29c2
    sal dx, CL                                ; d3 e2                       ; 0xc29c5 vgabios.c:58
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc29c7
    mul dx                                    ; f7 e2                       ; 0xc29ca
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc29cc
    add bx, ax                                ; 01 c3                       ; 0xc29cf
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc29d1 vgabios.c:52
    mov es, ax                                ; 8e c0                       ; 0xc29d4
    mov al, byte [bp-004h]                    ; 8a 46 fc                    ; 0xc29d6
    jmp short 029b1h                          ; eb d6                       ; 0xc29d9
  ; disGetNextSymbol 0xc29db LB 0x1b17 -> off=0x0 cb=000000000000025f uValue=00000000000c29db 'biosfn_write_teletype'
biosfn_write_teletype:                       ; 0xc29db LB 0x25f
    push bp                                   ; 55                          ; 0xc29db vgabios.c:1800
    mov bp, sp                                ; 89 e5                       ; 0xc29dc
    push si                                   ; 56                          ; 0xc29de
    sub sp, strict byte 00016h                ; 83 ec 16                    ; 0xc29df
    mov ch, al                                ; 88 c5                       ; 0xc29e2
    mov byte [bp-00ah], dl                    ; 88 56 f6                    ; 0xc29e4
    mov byte [bp-00ch], bl                    ; 88 5e f4                    ; 0xc29e7
    mov byte [bp-004h], cl                    ; 88 4e fc                    ; 0xc29ea
    cmp dl, 0ffh                              ; 80 fa ff                    ; 0xc29ed vgabios.c:1808
    jne short 02a00h                          ; 75 0e                       ; 0xc29f0
    mov bx, strict word 00062h                ; bb 62 00                    ; 0xc29f2 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc29f5
    mov es, ax                                ; 8e c0                       ; 0xc29f8
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc29fa
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc29fd vgabios.c:48
    mov bx, strict word 00049h                ; bb 49 00                    ; 0xc2a00 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2a03
    mov es, ax                                ; 8e c0                       ; 0xc2a06
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2a08
    xor ah, ah                                ; 30 e4                       ; 0xc2a0b vgabios.c:1813
    call 0380ch                               ; e8 fc 0d                    ; 0xc2a0d
    mov byte [bp-00eh], al                    ; 88 46 f2                    ; 0xc2a10
    cmp AL, strict byte 0ffh                  ; 3c ff                       ; 0xc2a13 vgabios.c:1814
    je short 02a7ch                           ; 74 65                       ; 0xc2a15
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2a17 vgabios.c:1817
    xor ah, ah                                ; 30 e4                       ; 0xc2a1a
    lea bx, [bp-016h]                         ; 8d 5e ea                    ; 0xc2a1c
    lea dx, [bp-018h]                         ; 8d 56 e8                    ; 0xc2a1f
    call 00a97h                               ; e8 72 e0                    ; 0xc2a22
    mov al, byte [bp-016h]                    ; 8a 46 ea                    ; 0xc2a25 vgabios.c:1818
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2a28
    mov ax, word [bp-016h]                    ; 8b 46 ea                    ; 0xc2a2b
    mov al, ah                                ; 88 e0                       ; 0xc2a2e
    xor ah, ah                                ; 30 e4                       ; 0xc2a30
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2a32
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2a35 vgabios.c:47
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc2a38
    mov es, dx                                ; 8e c2                       ; 0xc2a3b
    mov dl, byte [es:bx]                      ; 26 8a 17                    ; 0xc2a3d
    xor dh, dh                                ; 30 f6                       ; 0xc2a40 vgabios.c:48
    inc dx                                    ; 42                          ; 0xc2a42
    mov word [bp-012h], dx                    ; 89 56 ee                    ; 0xc2a43
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2a46 vgabios.c:57
    mov dx, word [es:bx]                      ; 26 8b 17                    ; 0xc2a49
    mov word [bp-014h], dx                    ; 89 56 ec                    ; 0xc2a4c vgabios.c:58
    cmp ch, 008h                              ; 80 fd 08                    ; 0xc2a4f vgabios.c:1824
    jc short 02a62h                           ; 72 0e                       ; 0xc2a52
    jbe short 02a6ah                          ; 76 14                       ; 0xc2a54
    cmp ch, 00dh                              ; 80 fd 0d                    ; 0xc2a56
    je short 02a7fh                           ; 74 24                       ; 0xc2a59
    cmp ch, 00ah                              ; 80 fd 0a                    ; 0xc2a5b
    je short 02a75h                           ; 74 15                       ; 0xc2a5e
    jmp short 02a85h                          ; eb 23                       ; 0xc2a60
    cmp ch, 007h                              ; 80 fd 07                    ; 0xc2a62
    jne short 02a85h                          ; 75 1e                       ; 0xc2a65
    jmp near 02b8dh                           ; e9 23 01                    ; 0xc2a67
    cmp byte [bp-006h], 000h                  ; 80 7e fa 00                 ; 0xc2a6a vgabios.c:1831
    jbe short 02a82h                          ; 76 12                       ; 0xc2a6e
    dec byte [bp-006h]                        ; fe 4e fa                    ; 0xc2a70
    jmp short 02a82h                          ; eb 0d                       ; 0xc2a73 vgabios.c:1832
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc2a75 vgabios.c:1835
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2a77
    jmp short 02a82h                          ; eb 06                       ; 0xc2a7a vgabios.c:1836
    jmp near 02c34h                           ; e9 b5 01                    ; 0xc2a7c
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc2a7f vgabios.c:1839
    jmp near 02b8dh                           ; e9 08 01                    ; 0xc2a82 vgabios.c:1840
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2a85 vgabios.c:1844
    xor ah, ah                                ; 30 e4                       ; 0xc2a88
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2a8a
    mov bx, ax                                ; 89 c3                       ; 0xc2a8c
    sal bx, CL                                ; d3 e3                       ; 0xc2a8e
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2a90
    jne short 02ad7h                          ; 75 40                       ; 0xc2a95
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2a97 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2a9a
    mov es, ax                                ; 8e c0                       ; 0xc2a9d
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc2a9f
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2aa2 vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc2aa5
    mul dx                                    ; f7 e2                       ; 0xc2aa7
    mov si, ax                                ; 89 c6                       ; 0xc2aa9
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2aab vgabios.c:1848
    xor ah, ah                                ; 30 e4                       ; 0xc2aae
    mul word [bp-014h]                        ; f7 66 ec                    ; 0xc2ab0
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc2ab3
    xor dh, dh                                ; 30 f6                       ; 0xc2ab6
    add ax, dx                                ; 01 d0                       ; 0xc2ab8
    sal ax, 1                                 ; d1 e0                       ; 0xc2aba
    add si, ax                                ; 01 c6                       ; 0xc2abc
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2abe vgabios.c:50
    mov byte [es:si], ch                      ; 26 88 2c                    ; 0xc2ac2 vgabios.c:52
    cmp cl, byte [bp-004h]                    ; 3a 4e fc                    ; 0xc2ac5 vgabios.c:1853
    jne short 02b07h                          ; 75 3d                       ; 0xc2ac8
    inc si                                    ; 46                          ; 0xc2aca vgabios.c:1854
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2acb vgabios.c:50
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2acf
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc2ad2
    jmp short 02b07h                          ; eb 30                       ; 0xc2ad5 vgabios.c:1856
    mov si, ax                                ; 89 c6                       ; 0xc2ad7 vgabios.c:1859
    mov al, byte [si+0482ch]                  ; 8a 84 2c 48                 ; 0xc2ad9
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc2add
    mov si, ax                                ; 89 c6                       ; 0xc2adf
    sal si, CL                                ; d3 e6                       ; 0xc2ae1
    mov dl, byte [si+04842h]                  ; 8a 94 42 48                 ; 0xc2ae3
    mov al, byte [bx+047afh]                  ; 8a 87 af 47                 ; 0xc2ae7 vgabios.c:1860
    mov bl, byte [bx+047aeh]                  ; 8a 9f ae 47                 ; 0xc2aeb vgabios.c:1861
    cmp bl, 003h                              ; 80 fb 03                    ; 0xc2aef
    jc short 02b02h                           ; 72 0e                       ; 0xc2af2
    jbe short 02b09h                          ; 76 13                       ; 0xc2af4
    cmp bl, 005h                              ; 80 fb 05                    ; 0xc2af6
    je short 02b59h                           ; 74 5e                       ; 0xc2af9
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc2afb
    je short 02b0dh                           ; 74 0d                       ; 0xc2afe
    jmp short 02b07h                          ; eb 05                       ; 0xc2b00
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc2b02
    je short 02b37h                           ; 74 30                       ; 0xc2b05
    jmp short 02b7ah                          ; eb 71                       ; 0xc2b07
    or byte [bp-00ch], 001h                   ; 80 4e f4 01                 ; 0xc2b09 vgabios.c:1864
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2b0d vgabios.c:1866
    xor ah, ah                                ; 30 e4                       ; 0xc2b10
    push ax                                   ; 50                          ; 0xc2b12
    mov al, dl                                ; 88 d0                       ; 0xc2b13
    push ax                                   ; 50                          ; 0xc2b15
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc2b16
    push ax                                   ; 50                          ; 0xc2b19
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2b1a
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc2b1d
    xor bh, bh                                ; 30 ff                       ; 0xc2b20
    mov dl, byte [bp-00ch]                    ; 8a 56 f4                    ; 0xc2b22
    xor dh, dh                                ; 30 f6                       ; 0xc2b25
    mov byte [bp-010h], ch                    ; 88 6e f0                    ; 0xc2b27
    mov byte [bp-00fh], ah                    ; 88 66 f1                    ; 0xc2b2a
    mov cx, ax                                ; 89 c1                       ; 0xc2b2d
    mov ax, word [bp-010h]                    ; 8b 46 f0                    ; 0xc2b2f
    call 022aeh                               ; e8 79 f7                    ; 0xc2b32
    jmp short 02b7ah                          ; eb 43                       ; 0xc2b35 vgabios.c:1867
    push ax                                   ; 50                          ; 0xc2b37 vgabios.c:1869
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc2b38
    push ax                                   ; 50                          ; 0xc2b3b
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2b3c
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc2b3f
    xor bh, bh                                ; 30 ff                       ; 0xc2b42
    mov dl, byte [bp-00ch]                    ; 8a 56 f4                    ; 0xc2b44
    xor dh, dh                                ; 30 f6                       ; 0xc2b47
    mov byte [bp-010h], ch                    ; 88 6e f0                    ; 0xc2b49
    mov byte [bp-00fh], ah                    ; 88 66 f1                    ; 0xc2b4c
    mov cx, ax                                ; 89 c1                       ; 0xc2b4f
    mov ax, word [bp-010h]                    ; 8b 46 f0                    ; 0xc2b51
    call 023c0h                               ; e8 69 f8                    ; 0xc2b54
    jmp short 02b7ah                          ; eb 21                       ; 0xc2b57 vgabios.c:1870
    mov al, byte [bp-014h]                    ; 8a 46 ec                    ; 0xc2b59 vgabios.c:1872
    push ax                                   ; 50                          ; 0xc2b5c
    mov dl, byte [bp-008h]                    ; 8a 56 f8                    ; 0xc2b5d
    xor dh, dh                                ; 30 f6                       ; 0xc2b60
    mov bl, byte [bp-006h]                    ; 8a 5e fa                    ; 0xc2b62
    xor bh, bh                                ; 30 ff                       ; 0xc2b65
    mov al, byte [bp-00ch]                    ; 8a 46 f4                    ; 0xc2b67
    mov byte [bp-010h], al                    ; 88 46 f0                    ; 0xc2b6a
    mov byte [bp-00fh], ah                    ; 88 66 f1                    ; 0xc2b6d
    mov al, ch                                ; 88 e8                       ; 0xc2b70
    mov cx, dx                                ; 89 d1                       ; 0xc2b72
    mov dx, word [bp-010h]                    ; 8b 56 f0                    ; 0xc2b74
    call 024d2h                               ; e8 58 f9                    ; 0xc2b77
    inc byte [bp-006h]                        ; fe 46 fa                    ; 0xc2b7a vgabios.c:1880
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2b7d vgabios.c:1882
    xor ah, ah                                ; 30 e4                       ; 0xc2b80
    cmp ax, word [bp-014h]                    ; 3b 46 ec                    ; 0xc2b82
    jne short 02b8dh                          ; 75 06                       ; 0xc2b85
    mov byte [bp-006h], ah                    ; 88 66 fa                    ; 0xc2b87 vgabios.c:1883
    inc byte [bp-008h]                        ; fe 46 f8                    ; 0xc2b8a vgabios.c:1884
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2b8d vgabios.c:1889
    xor ah, ah                                ; 30 e4                       ; 0xc2b90
    cmp ax, word [bp-012h]                    ; 3b 46 ee                    ; 0xc2b92
    jne short 02bf7h                          ; 75 60                       ; 0xc2b95
    mov bl, byte [bp-00eh]                    ; 8a 5e f2                    ; 0xc2b97 vgabios.c:1891
    xor bh, bh                                ; 30 ff                       ; 0xc2b9a
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2b9c
    sal bx, CL                                ; d3 e3                       ; 0xc2b9e
    mov ch, byte [bp-012h]                    ; 8a 6e ee                    ; 0xc2ba0
    db  0feh, 0cdh
    ; dec ch                                    ; fe cd                     ; 0xc2ba3
    mov cl, byte [bp-014h]                    ; 8a 4e ec                    ; 0xc2ba5
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc2ba8
    cmp byte [bx+047adh], 000h                ; 80 bf ad 47 00              ; 0xc2baa
    jne short 02bf9h                          ; 75 48                       ; 0xc2baf
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc2bb1 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2bb4
    mov es, ax                                ; 8e c0                       ; 0xc2bb7
    mov dx, word [es:si]                      ; 26 8b 14                    ; 0xc2bb9
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2bbc vgabios.c:58
    xor ah, ah                                ; 30 e4                       ; 0xc2bbf
    mul dx                                    ; f7 e2                       ; 0xc2bc1
    mov si, ax                                ; 89 c6                       ; 0xc2bc3
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2bc5 vgabios.c:1894
    xor ah, ah                                ; 30 e4                       ; 0xc2bc8
    dec ax                                    ; 48                          ; 0xc2bca
    mul word [bp-014h]                        ; f7 66 ec                    ; 0xc2bcb
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc2bce
    xor dh, dh                                ; 30 f6                       ; 0xc2bd1
    add ax, dx                                ; 01 d0                       ; 0xc2bd3
    sal ax, 1                                 ; d1 e0                       ; 0xc2bd5
    add si, ax                                ; 01 c6                       ; 0xc2bd7
    inc si                                    ; 46                          ; 0xc2bd9 vgabios.c:1895
    mov es, [bx+047b0h]                       ; 8e 87 b0 47                 ; 0xc2bda vgabios.c:45
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc2bde
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc2be1 vgabios.c:1896
    push ax                                   ; 50                          ; 0xc2be4
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2be5
    xor ah, ah                                ; 30 e4                       ; 0xc2be8
    push ax                                   ; 50                          ; 0xc2bea
    mov al, cl                                ; 88 c8                       ; 0xc2beb
    push ax                                   ; 50                          ; 0xc2bed
    mov al, ch                                ; 88 e8                       ; 0xc2bee
    push ax                                   ; 50                          ; 0xc2bf0
    xor cx, cx                                ; 31 c9                       ; 0xc2bf1
    xor bx, bx                                ; 31 db                       ; 0xc2bf3
    jmp short 02c0fh                          ; eb 18                       ; 0xc2bf5 vgabios.c:1898
    jmp short 02c18h                          ; eb 1f                       ; 0xc2bf7
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc2bf9 vgabios.c:1900
    push ax                                   ; 50                          ; 0xc2bfc
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2bfd
    xor ah, ah                                ; 30 e4                       ; 0xc2c00
    push ax                                   ; 50                          ; 0xc2c02
    mov al, cl                                ; 88 c8                       ; 0xc2c03
    push ax                                   ; 50                          ; 0xc2c05
    mov al, ch                                ; 88 e8                       ; 0xc2c06
    push ax                                   ; 50                          ; 0xc2c08
    xor cx, cx                                ; 31 c9                       ; 0xc2c09
    xor bx, bx                                ; 31 db                       ; 0xc2c0b
    xor dx, dx                                ; 31 d2                       ; 0xc2c0d
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc2c0f
    call 01c0ah                               ; e8 f5 ef                    ; 0xc2c12
    dec byte [bp-008h]                        ; fe 4e f8                    ; 0xc2c15 vgabios.c:1902
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc2c18 vgabios.c:1906
    xor ah, ah                                ; 30 e4                       ; 0xc2c1b
    mov word [bp-016h], ax                    ; 89 46 ea                    ; 0xc2c1d
    mov CL, strict byte 008h                  ; b1 08                       ; 0xc2c20
    sal word [bp-016h], CL                    ; d3 66 ea                    ; 0xc2c22
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2c25
    add word [bp-016h], ax                    ; 01 46 ea                    ; 0xc2c28
    mov dx, word [bp-016h]                    ; 8b 56 ea                    ; 0xc2c2b vgabios.c:1907
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2c2e
    call 012a1h                               ; e8 6d e6                    ; 0xc2c31
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2c34 vgabios.c:1908
    pop si                                    ; 5e                          ; 0xc2c37
    pop bp                                    ; 5d                          ; 0xc2c38
    retn                                      ; c3                          ; 0xc2c39
  ; disGetNextSymbol 0xc2c3a LB 0x18b8 -> off=0x0 cb=0000000000000035 uValue=00000000000c2c3a 'get_font_access'
get_font_access:                             ; 0xc2c3a LB 0x35
    push bp                                   ; 55                          ; 0xc2c3a vgabios.c:1911
    mov bp, sp                                ; 89 e5                       ; 0xc2c3b
    push dx                                   ; 52                          ; 0xc2c3d
    mov ax, strict word 00005h                ; b8 05 00                    ; 0xc2c3e vgabios.c:1913
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2c41
    out DX, ax                                ; ef                          ; 0xc2c44
    mov AL, strict byte 006h                  ; b0 06                       ; 0xc2c45 vgabios.c:1914
    out DX, AL                                ; ee                          ; 0xc2c47
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc2c48 vgabios.c:1915
    in AL, DX                                 ; ec                          ; 0xc2c4b
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2c4c
    mov ah, al                                ; 88 c4                       ; 0xc2c4e
    and ah, 001h                              ; 80 e4 01                    ; 0xc2c50
    or ah, 004h                               ; 80 cc 04                    ; 0xc2c53
    xor al, al                                ; 30 c0                       ; 0xc2c56
    or AL, strict byte 006h                   ; 0c 06                       ; 0xc2c58
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2c5a
    out DX, ax                                ; ef                          ; 0xc2c5d
    mov ax, 00402h                            ; b8 02 04                    ; 0xc2c5e vgabios.c:1916
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2c61
    out DX, ax                                ; ef                          ; 0xc2c64
    mov ax, 00604h                            ; b8 04 06                    ; 0xc2c65 vgabios.c:1917
    out DX, ax                                ; ef                          ; 0xc2c68
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2c69 vgabios.c:1918
    pop dx                                    ; 5a                          ; 0xc2c6c
    pop bp                                    ; 5d                          ; 0xc2c6d
    retn                                      ; c3                          ; 0xc2c6e
  ; disGetNextSymbol 0xc2c6f LB 0x1883 -> off=0x0 cb=0000000000000033 uValue=00000000000c2c6f 'release_font_access'
release_font_access:                         ; 0xc2c6f LB 0x33
    push bp                                   ; 55                          ; 0xc2c6f vgabios.c:1920
    mov bp, sp                                ; 89 e5                       ; 0xc2c70
    push dx                                   ; 52                          ; 0xc2c72
    mov dx, 003cch                            ; ba cc 03                    ; 0xc2c73 vgabios.c:1922
    in AL, DX                                 ; ec                          ; 0xc2c76
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2c77
    and ax, strict word 00001h                ; 25 01 00                    ; 0xc2c79
    sal ax, 1                                 ; d1 e0                       ; 0xc2c7c
    sal ax, 1                                 ; d1 e0                       ; 0xc2c7e
    mov ah, al                                ; 88 c4                       ; 0xc2c80
    or ah, 00ah                               ; 80 cc 0a                    ; 0xc2c82
    xor al, al                                ; 30 c0                       ; 0xc2c85
    or AL, strict byte 006h                   ; 0c 06                       ; 0xc2c87
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc2c89
    out DX, ax                                ; ef                          ; 0xc2c8c
    mov ax, 01005h                            ; b8 05 10                    ; 0xc2c8d vgabios.c:1923
    out DX, ax                                ; ef                          ; 0xc2c90
    mov ax, 00302h                            ; b8 02 03                    ; 0xc2c91 vgabios.c:1924
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2c94
    out DX, ax                                ; ef                          ; 0xc2c97
    mov ax, 00204h                            ; b8 04 02                    ; 0xc2c98 vgabios.c:1925
    out DX, ax                                ; ef                          ; 0xc2c9b
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2c9c vgabios.c:1926
    pop dx                                    ; 5a                          ; 0xc2c9f
    pop bp                                    ; 5d                          ; 0xc2ca0
    retn                                      ; c3                          ; 0xc2ca1
  ; disGetNextSymbol 0xc2ca2 LB 0x1850 -> off=0x0 cb=00000000000000d6 uValue=00000000000c2ca2 'set_scan_lines'
set_scan_lines:                              ; 0xc2ca2 LB 0xd6
    push bp                                   ; 55                          ; 0xc2ca2 vgabios.c:1928
    mov bp, sp                                ; 89 e5                       ; 0xc2ca3
    push bx                                   ; 53                          ; 0xc2ca5
    push cx                                   ; 51                          ; 0xc2ca6
    push dx                                   ; 52                          ; 0xc2ca7
    push si                                   ; 56                          ; 0xc2ca8
    push ax                                   ; 50                          ; 0xc2ca9
    push ax                                   ; 50                          ; 0xc2caa
    mov byte [bp-00ah], al                    ; 88 46 f6                    ; 0xc2cab
    mov bx, strict word 00063h                ; bb 63 00                    ; 0xc2cae vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2cb1
    mov es, ax                                ; 8e c0                       ; 0xc2cb4
    mov cx, word [es:bx]                      ; 26 8b 0f                    ; 0xc2cb6
    mov bx, cx                                ; 89 cb                       ; 0xc2cb9 vgabios.c:58
    mov AL, strict byte 009h                  ; b0 09                       ; 0xc2cbb vgabios.c:1934
    mov dx, cx                                ; 89 ca                       ; 0xc2cbd
    out DX, AL                                ; ee                          ; 0xc2cbf
    lea dx, [bx+001h]                         ; 8d 57 01                    ; 0xc2cc0 vgabios.c:1935
    in AL, DX                                 ; ec                          ; 0xc2cc3
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2cc4
    mov ah, al                                ; 88 c4                       ; 0xc2cc6 vgabios.c:1936
    and ah, 0e0h                              ; 80 e4 e0                    ; 0xc2cc8
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2ccb
    db  0feh, 0c8h
    ; dec al                                    ; fe c8                     ; 0xc2cce
    or al, ah                                 ; 08 e0                       ; 0xc2cd0
    out DX, AL                                ; ee                          ; 0xc2cd2 vgabios.c:1937
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2cd3 vgabios.c:1942
    xor ah, ah                                ; 30 e4                       ; 0xc2cd6
    mov cx, ax                                ; 89 c1                       ; 0xc2cd8
    mov ch, al                                ; 88 c5                       ; 0xc2cda
    xor cl, al                                ; 30 c1                       ; 0xc2cdc
    dec ax                                    ; 48                          ; 0xc2cde
    sub cx, 00200h                            ; 81 e9 00 02                 ; 0xc2cdf
    or cx, ax                                 ; 09 c1                       ; 0xc2ce3
    cmp byte [bp-00ah], 00eh                  ; 80 7e f6 0e                 ; 0xc2ce5 vgabios.c:1943
    jc short 02cefh                           ; 72 04                       ; 0xc2ce9
    sub cx, 00101h                            ; 81 e9 01 01                 ; 0xc2ceb vgabios.c:1944
    mov ax, cx                                ; 89 c8                       ; 0xc2cef vgabios.c:1946
    xor al, cl                                ; 30 c8                       ; 0xc2cf1
    or AL, strict byte 00ah                   ; 0c 0a                       ; 0xc2cf3
    mov dx, bx                                ; 89 da                       ; 0xc2cf5
    out DX, ax                                ; ef                          ; 0xc2cf7
    mov ah, cl                                ; 88 cc                       ; 0xc2cf8 vgabios.c:1947
    xor al, al                                ; 30 c0                       ; 0xc2cfa
    or AL, strict byte 00bh                   ; 0c 0b                       ; 0xc2cfc
    out DX, ax                                ; ef                          ; 0xc2cfe
    mov si, strict word 00060h                ; be 60 00                    ; 0xc2cff vgabios.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2d02
    mov es, ax                                ; 8e c0                       ; 0xc2d05
    mov word [es:si], cx                      ; 26 89 0c                    ; 0xc2d07
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc2d0a vgabios.c:1950
    mov byte [bp-00ch], al                    ; 88 46 f4                    ; 0xc2d0d
    mov byte [bp-00bh], 000h                  ; c6 46 f5 00                 ; 0xc2d10
    mov si, 00085h                            ; be 85 00                    ; 0xc2d14 vgabios.c:62
    mov ax, word [bp-00ch]                    ; 8b 46 f4                    ; 0xc2d17
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc2d1a
    mov AL, strict byte 012h                  ; b0 12                       ; 0xc2d1d vgabios.c:1951
    out DX, AL                                ; ee                          ; 0xc2d1f
    lea cx, [bx+001h]                         ; 8d 4f 01                    ; 0xc2d20 vgabios.c:1952
    mov dx, cx                                ; 89 ca                       ; 0xc2d23
    in AL, DX                                 ; ec                          ; 0xc2d25
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2d26
    mov si, ax                                ; 89 c6                       ; 0xc2d28
    mov AL, strict byte 007h                  ; b0 07                       ; 0xc2d2a vgabios.c:1953
    mov dx, bx                                ; 89 da                       ; 0xc2d2c
    out DX, AL                                ; ee                          ; 0xc2d2e
    mov dx, cx                                ; 89 ca                       ; 0xc2d2f vgabios.c:1954
    in AL, DX                                 ; ec                          ; 0xc2d31
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc2d32
    mov bl, al                                ; 88 c3                       ; 0xc2d34 vgabios.c:1955
    and bl, 002h                              ; 80 e3 02                    ; 0xc2d36
    xor bh, bh                                ; 30 ff                       ; 0xc2d39
    mov CL, strict byte 007h                  ; b1 07                       ; 0xc2d3b
    sal bx, CL                                ; d3 e3                       ; 0xc2d3d
    and AL, strict byte 040h                  ; 24 40                       ; 0xc2d3f
    xor ah, ah                                ; 30 e4                       ; 0xc2d41
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc2d43
    sal ax, CL                                ; d3 e0                       ; 0xc2d45
    add ax, bx                                ; 01 d8                       ; 0xc2d47
    inc ax                                    ; 40                          ; 0xc2d49
    add ax, si                                ; 01 f0                       ; 0xc2d4a
    xor dx, dx                                ; 31 d2                       ; 0xc2d4c vgabios.c:1956
    div word [bp-00ch]                        ; f7 76 f4                    ; 0xc2d4e
    mov cl, al                                ; 88 c1                       ; 0xc2d51 vgabios.c:1957
    db  0feh, 0c9h
    ; dec cl                                    ; fe c9                     ; 0xc2d53
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2d55 vgabios.c:52
    mov byte [es:bx], cl                      ; 26 88 0f                    ; 0xc2d58
    mov bx, strict word 0004ah                ; bb 4a 00                    ; 0xc2d5b vgabios.c:57
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc2d5e
    xor ah, ah                                ; 30 e4                       ; 0xc2d61 vgabios.c:1963
    mul bx                                    ; f7 e3                       ; 0xc2d63
    sal ax, 1                                 ; d1 e0                       ; 0xc2d65
    db  0feh, 0c4h
    ; inc ah                                    ; fe c4                     ; 0xc2d67
    mov bx, strict word 0004ch                ; bb 4c 00                    ; 0xc2d69 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc2d6c
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc2d6f vgabios.c:1964
    pop si                                    ; 5e                          ; 0xc2d72
    pop dx                                    ; 5a                          ; 0xc2d73
    pop cx                                    ; 59                          ; 0xc2d74
    pop bx                                    ; 5b                          ; 0xc2d75
    pop bp                                    ; 5d                          ; 0xc2d76
    retn                                      ; c3                          ; 0xc2d77
  ; disGetNextSymbol 0xc2d78 LB 0x177a -> off=0x0 cb=0000000000000020 uValue=00000000000c2d78 'biosfn_set_font_block'
biosfn_set_font_block:                       ; 0xc2d78 LB 0x20
    push bp                                   ; 55                          ; 0xc2d78 vgabios.c:1966
    mov bp, sp                                ; 89 e5                       ; 0xc2d79
    push bx                                   ; 53                          ; 0xc2d7b
    push dx                                   ; 52                          ; 0xc2d7c
    mov bl, al                                ; 88 c3                       ; 0xc2d7d
    mov ax, 00100h                            ; b8 00 01                    ; 0xc2d7f vgabios.c:1968
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc2d82
    out DX, ax                                ; ef                          ; 0xc2d85
    mov ah, bl                                ; 88 dc                       ; 0xc2d86 vgabios.c:1969
    xor al, al                                ; 30 c0                       ; 0xc2d88
    or AL, strict byte 003h                   ; 0c 03                       ; 0xc2d8a
    out DX, ax                                ; ef                          ; 0xc2d8c
    mov ax, 00300h                            ; b8 00 03                    ; 0xc2d8d vgabios.c:1970
    out DX, ax                                ; ef                          ; 0xc2d90
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2d91 vgabios.c:1971
    pop dx                                    ; 5a                          ; 0xc2d94
    pop bx                                    ; 5b                          ; 0xc2d95
    pop bp                                    ; 5d                          ; 0xc2d96
    retn                                      ; c3                          ; 0xc2d97
  ; disGetNextSymbol 0xc2d98 LB 0x175a -> off=0x0 cb=0000000000000078 uValue=00000000000c2d98 'load_text_patch'
load_text_patch:                             ; 0xc2d98 LB 0x78
    push bp                                   ; 55                          ; 0xc2d98 vgabios.c:1973
    mov bp, sp                                ; 89 e5                       ; 0xc2d99
    push si                                   ; 56                          ; 0xc2d9b
    push di                                   ; 57                          ; 0xc2d9c
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc2d9d
    push ax                                   ; 50                          ; 0xc2da0
    mov byte [bp-006h], cl                    ; 88 4e fa                    ; 0xc2da1
    call 02c3ah                               ; e8 93 fe                    ; 0xc2da4 vgabios.c:1978
    mov al, bl                                ; 88 d8                       ; 0xc2da7 vgabios.c:1980
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2da9
    xor ah, ah                                ; 30 e4                       ; 0xc2dab
    mov CL, strict byte 00eh                  ; b1 0e                       ; 0xc2dad
    mov di, ax                                ; 89 c7                       ; 0xc2daf
    sal di, CL                                ; d3 e7                       ; 0xc2db1
    mov al, bl                                ; 88 d8                       ; 0xc2db3
    and AL, strict byte 004h                  ; 24 04                       ; 0xc2db5
    mov CL, strict byte 00bh                  ; b1 0b                       ; 0xc2db7
    sal ax, CL                                ; d3 e0                       ; 0xc2db9
    add di, ax                                ; 01 c7                       ; 0xc2dbb
    mov word [bp-00ah], di                    ; 89 7e f6                    ; 0xc2dbd
    mov bx, dx                                ; 89 d3                       ; 0xc2dc0 vgabios.c:1981
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2dc2
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc2dc5
    inc dx                                    ; 42                          ; 0xc2dc8 vgabios.c:1982
    mov word [bp-00ch], dx                    ; 89 56 f4                    ; 0xc2dc9
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc2dcc vgabios.c:1983
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc2dcf
    test al, al                               ; 84 c0                       ; 0xc2dd2
    je short 02e06h                           ; 74 30                       ; 0xc2dd4
    xor ah, ah                                ; 30 e4                       ; 0xc2dd6 vgabios.c:1984
    mov CL, strict byte 005h                  ; b1 05                       ; 0xc2dd8
    sal ax, CL                                ; d3 e0                       ; 0xc2dda
    mov di, word [bp-00ah]                    ; 8b 7e f6                    ; 0xc2ddc
    add di, ax                                ; 01 c7                       ; 0xc2ddf
    mov cl, byte [bp-006h]                    ; 8a 4e fa                    ; 0xc2de1 vgabios.c:1985
    xor ch, ch                                ; 30 ed                       ; 0xc2de4
    mov si, word [bp-00ch]                    ; 8b 76 f4                    ; 0xc2de6
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc2de9
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2dec
    mov es, ax                                ; 8e c0                       ; 0xc2def
    jcxz 02df9h                               ; e3 06                       ; 0xc2df1
    push DS                                   ; 1e                          ; 0xc2df3
    mov ds, dx                                ; 8e da                       ; 0xc2df4
    rep movsb                                 ; f3 a4                       ; 0xc2df6
    pop DS                                    ; 1f                          ; 0xc2df8
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2df9 vgabios.c:1986
    xor ah, ah                                ; 30 e4                       ; 0xc2dfc
    inc ax                                    ; 40                          ; 0xc2dfe
    add word [bp-00ch], ax                    ; 01 46 f4                    ; 0xc2dff
    add bx, ax                                ; 01 c3                       ; 0xc2e02 vgabios.c:1987
    jmp short 02dcch                          ; eb c6                       ; 0xc2e04 vgabios.c:1988
    call 02c6fh                               ; e8 66 fe                    ; 0xc2e06 vgabios.c:1990
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2e09 vgabios.c:1991
    pop di                                    ; 5f                          ; 0xc2e0c
    pop si                                    ; 5e                          ; 0xc2e0d
    pop bp                                    ; 5d                          ; 0xc2e0e
    retn                                      ; c3                          ; 0xc2e0f
  ; disGetNextSymbol 0xc2e10 LB 0x16e2 -> off=0x0 cb=0000000000000084 uValue=00000000000c2e10 'biosfn_load_text_user_pat'
biosfn_load_text_user_pat:                   ; 0xc2e10 LB 0x84
    push bp                                   ; 55                          ; 0xc2e10 vgabios.c:1993
    mov bp, sp                                ; 89 e5                       ; 0xc2e11
    push si                                   ; 56                          ; 0xc2e13
    push di                                   ; 57                          ; 0xc2e14
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc2e15
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc2e18
    mov word [bp-00eh], dx                    ; 89 56 f2                    ; 0xc2e1b
    mov word [bp-00ah], bx                    ; 89 5e f6                    ; 0xc2e1e
    mov word [bp-00ch], cx                    ; 89 4e f4                    ; 0xc2e21
    call 02c3ah                               ; e8 13 fe                    ; 0xc2e24 vgabios.c:1998
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2e27 vgabios.c:1999
    and AL, strict byte 003h                  ; 24 03                       ; 0xc2e2a
    xor ah, ah                                ; 30 e4                       ; 0xc2e2c
    mov CL, strict byte 00eh                  ; b1 0e                       ; 0xc2e2e
    mov bx, ax                                ; 89 c3                       ; 0xc2e30
    sal bx, CL                                ; d3 e3                       ; 0xc2e32
    mov al, byte [bp+006h]                    ; 8a 46 06                    ; 0xc2e34
    and AL, strict byte 004h                  ; 24 04                       ; 0xc2e37
    mov CL, strict byte 00bh                  ; b1 0b                       ; 0xc2e39
    sal ax, CL                                ; d3 e0                       ; 0xc2e3b
    add bx, ax                                ; 01 c3                       ; 0xc2e3d
    mov word [bp-008h], bx                    ; 89 5e f8                    ; 0xc2e3f
    xor bx, bx                                ; 31 db                       ; 0xc2e42 vgabios.c:2000
    cmp bx, word [bp-00ch]                    ; 3b 5e f4                    ; 0xc2e44
    jnc short 02e7ah                          ; 73 31                       ; 0xc2e47
    mov al, byte [bp+008h]                    ; 8a 46 08                    ; 0xc2e49 vgabios.c:2002
    xor ah, ah                                ; 30 e4                       ; 0xc2e4c
    mov si, ax                                ; 89 c6                       ; 0xc2e4e
    mov ax, bx                                ; 89 d8                       ; 0xc2e50
    mul si                                    ; f7 e6                       ; 0xc2e52
    add ax, word [bp-00ah]                    ; 03 46 f6                    ; 0xc2e54
    mov di, word [bp+004h]                    ; 8b 7e 04                    ; 0xc2e57 vgabios.c:2003
    add di, bx                                ; 01 df                       ; 0xc2e5a
    mov CL, strict byte 005h                  ; b1 05                       ; 0xc2e5c
    sal di, CL                                ; d3 e7                       ; 0xc2e5e
    add di, word [bp-008h]                    ; 03 7e f8                    ; 0xc2e60
    mov cx, si                                ; 89 f1                       ; 0xc2e63 vgabios.c:2004
    mov si, ax                                ; 89 c6                       ; 0xc2e65
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc2e67
    mov ax, 0a000h                            ; b8 00 a0                    ; 0xc2e6a
    mov es, ax                                ; 8e c0                       ; 0xc2e6d
    jcxz 02e77h                               ; e3 06                       ; 0xc2e6f
    push DS                                   ; 1e                          ; 0xc2e71
    mov ds, dx                                ; 8e da                       ; 0xc2e72
    rep movsb                                 ; f3 a4                       ; 0xc2e74
    pop DS                                    ; 1f                          ; 0xc2e76
    inc bx                                    ; 43                          ; 0xc2e77 vgabios.c:2005
    jmp short 02e44h                          ; eb ca                       ; 0xc2e78
    call 02c6fh                               ; e8 f2 fd                    ; 0xc2e7a vgabios.c:2006
    cmp byte [bp-006h], 010h                  ; 80 7e fa 10                 ; 0xc2e7d vgabios.c:2007
    jc short 02e8bh                           ; 72 08                       ; 0xc2e81
    mov al, byte [bp+008h]                    ; 8a 46 08                    ; 0xc2e83 vgabios.c:2009
    xor ah, ah                                ; 30 e4                       ; 0xc2e86
    call 02ca2h                               ; e8 17 fe                    ; 0xc2e88
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2e8b vgabios.c:2011
    pop di                                    ; 5f                          ; 0xc2e8e
    pop si                                    ; 5e                          ; 0xc2e8f
    pop bp                                    ; 5d                          ; 0xc2e90
    retn 00006h                               ; c2 06 00                    ; 0xc2e91
  ; disGetNextSymbol 0xc2e94 LB 0x165e -> off=0x0 cb=0000000000000016 uValue=00000000000c2e94 'biosfn_load_gfx_8_8_chars'
biosfn_load_gfx_8_8_chars:                   ; 0xc2e94 LB 0x16
    push bp                                   ; 55                          ; 0xc2e94 vgabios.c:2013
    mov bp, sp                                ; 89 e5                       ; 0xc2e95
    push bx                                   ; 53                          ; 0xc2e97
    push cx                                   ; 51                          ; 0xc2e98
    mov bx, dx                                ; 89 d3                       ; 0xc2e99 vgabios.c:2015
    mov cx, ax                                ; 89 c1                       ; 0xc2e9b
    mov ax, strict word 0001fh                ; b8 1f 00                    ; 0xc2e9d
    call 009f0h                               ; e8 4d db                    ; 0xc2ea0
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2ea3 vgabios.c:2016
    pop cx                                    ; 59                          ; 0xc2ea6
    pop bx                                    ; 5b                          ; 0xc2ea7
    pop bp                                    ; 5d                          ; 0xc2ea8
    retn                                      ; c3                          ; 0xc2ea9
  ; disGetNextSymbol 0xc2eaa LB 0x1648 -> off=0x0 cb=000000000000004d uValue=00000000000c2eaa 'set_gfx_font'
set_gfx_font:                                ; 0xc2eaa LB 0x4d
    push bp                                   ; 55                          ; 0xc2eaa vgabios.c:2018
    mov bp, sp                                ; 89 e5                       ; 0xc2eab
    push si                                   ; 56                          ; 0xc2ead
    push di                                   ; 57                          ; 0xc2eae
    mov si, ax                                ; 89 c6                       ; 0xc2eaf
    mov ax, dx                                ; 89 d0                       ; 0xc2eb1
    mov di, bx                                ; 89 df                       ; 0xc2eb3
    mov dl, cl                                ; 88 ca                       ; 0xc2eb5
    mov bx, si                                ; 89 f3                       ; 0xc2eb7 vgabios.c:2022
    mov cx, ax                                ; 89 c1                       ; 0xc2eb9
    mov ax, strict word 00043h                ; b8 43 00                    ; 0xc2ebb
    call 009f0h                               ; e8 2f db                    ; 0xc2ebe
    test dl, dl                               ; 84 d2                       ; 0xc2ec1 vgabios.c:2023
    je short 02ed7h                           ; 74 12                       ; 0xc2ec3
    cmp dl, 003h                              ; 80 fa 03                    ; 0xc2ec5 vgabios.c:2024
    jbe short 02ecch                          ; 76 02                       ; 0xc2ec8
    mov DL, strict byte 002h                  ; b2 02                       ; 0xc2eca vgabios.c:2025
    mov bl, dl                                ; 88 d3                       ; 0xc2ecc vgabios.c:2026
    xor bh, bh                                ; 30 ff                       ; 0xc2ece
    mov al, byte [bx+07dfbh]                  ; 8a 87 fb 7d                 ; 0xc2ed0
    mov byte [bp+004h], al                    ; 88 46 04                    ; 0xc2ed4
    mov bx, 00085h                            ; bb 85 00                    ; 0xc2ed7 vgabios.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2eda
    mov es, ax                                ; 8e c0                       ; 0xc2edd
    mov word [es:bx], di                      ; 26 89 3f                    ; 0xc2edf
    mov al, byte [bp+004h]                    ; 8a 46 04                    ; 0xc2ee2 vgabios.c:2031
    xor ah, ah                                ; 30 e4                       ; 0xc2ee5
    dec ax                                    ; 48                          ; 0xc2ee7
    mov bx, 00084h                            ; bb 84 00                    ; 0xc2ee8 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc2eeb
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2eee vgabios.c:2032
    pop di                                    ; 5f                          ; 0xc2ef1
    pop si                                    ; 5e                          ; 0xc2ef2
    pop bp                                    ; 5d                          ; 0xc2ef3
    retn 00002h                               ; c2 02 00                    ; 0xc2ef4
  ; disGetNextSymbol 0xc2ef7 LB 0x15fb -> off=0x0 cb=000000000000001d uValue=00000000000c2ef7 'biosfn_load_gfx_user_chars'
biosfn_load_gfx_user_chars:                  ; 0xc2ef7 LB 0x1d
    push bp                                   ; 55                          ; 0xc2ef7 vgabios.c:2034
    mov bp, sp                                ; 89 e5                       ; 0xc2ef8
    push si                                   ; 56                          ; 0xc2efa
    mov si, ax                                ; 89 c6                       ; 0xc2efb
    mov ax, dx                                ; 89 d0                       ; 0xc2efd
    mov dl, byte [bp+004h]                    ; 8a 56 04                    ; 0xc2eff vgabios.c:2037
    xor dh, dh                                ; 30 f6                       ; 0xc2f02
    push dx                                   ; 52                          ; 0xc2f04
    xor ch, ch                                ; 30 ed                       ; 0xc2f05
    mov dx, si                                ; 89 f2                       ; 0xc2f07
    call 02eaah                               ; e8 9e ff                    ; 0xc2f09
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc2f0c vgabios.c:2038
    pop si                                    ; 5e                          ; 0xc2f0f
    pop bp                                    ; 5d                          ; 0xc2f10
    retn 00002h                               ; c2 02 00                    ; 0xc2f11
  ; disGetNextSymbol 0xc2f14 LB 0x15de -> off=0x0 cb=0000000000000022 uValue=00000000000c2f14 'biosfn_load_gfx_8_14_chars'
biosfn_load_gfx_8_14_chars:                  ; 0xc2f14 LB 0x22
    push bp                                   ; 55                          ; 0xc2f14 vgabios.c:2043
    mov bp, sp                                ; 89 e5                       ; 0xc2f15
    push bx                                   ; 53                          ; 0xc2f17
    push cx                                   ; 51                          ; 0xc2f18
    mov bl, al                                ; 88 c3                       ; 0xc2f19
    mov al, dl                                ; 88 d0                       ; 0xc2f1b
    xor ah, ah                                ; 30 e4                       ; 0xc2f1d vgabios.c:2045
    push ax                                   ; 50                          ; 0xc2f1f
    mov al, bl                                ; 88 d8                       ; 0xc2f20
    mov cx, ax                                ; 89 c1                       ; 0xc2f22
    mov bx, strict word 0000eh                ; bb 0e 00                    ; 0xc2f24
    mov ax, 05d6ah                            ; b8 6a 5d                    ; 0xc2f27
    mov dx, ds                                ; 8c da                       ; 0xc2f2a
    call 02eaah                               ; e8 7b ff                    ; 0xc2f2c
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2f2f vgabios.c:2046
    pop cx                                    ; 59                          ; 0xc2f32
    pop bx                                    ; 5b                          ; 0xc2f33
    pop bp                                    ; 5d                          ; 0xc2f34
    retn                                      ; c3                          ; 0xc2f35
  ; disGetNextSymbol 0xc2f36 LB 0x15bc -> off=0x0 cb=0000000000000022 uValue=00000000000c2f36 'biosfn_load_gfx_8_8_dd_chars'
biosfn_load_gfx_8_8_dd_chars:                ; 0xc2f36 LB 0x22
    push bp                                   ; 55                          ; 0xc2f36 vgabios.c:2047
    mov bp, sp                                ; 89 e5                       ; 0xc2f37
    push bx                                   ; 53                          ; 0xc2f39
    push cx                                   ; 51                          ; 0xc2f3a
    mov bl, al                                ; 88 c3                       ; 0xc2f3b
    mov al, dl                                ; 88 d0                       ; 0xc2f3d
    xor ah, ah                                ; 30 e4                       ; 0xc2f3f vgabios.c:2049
    push ax                                   ; 50                          ; 0xc2f41
    mov al, bl                                ; 88 d8                       ; 0xc2f42
    mov cx, ax                                ; 89 c1                       ; 0xc2f44
    mov bx, strict word 00008h                ; bb 08 00                    ; 0xc2f46
    mov ax, 0556ah                            ; b8 6a 55                    ; 0xc2f49
    mov dx, ds                                ; 8c da                       ; 0xc2f4c
    call 02eaah                               ; e8 59 ff                    ; 0xc2f4e
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2f51 vgabios.c:2050
    pop cx                                    ; 59                          ; 0xc2f54
    pop bx                                    ; 5b                          ; 0xc2f55
    pop bp                                    ; 5d                          ; 0xc2f56
    retn                                      ; c3                          ; 0xc2f57
  ; disGetNextSymbol 0xc2f58 LB 0x159a -> off=0x0 cb=0000000000000022 uValue=00000000000c2f58 'biosfn_load_gfx_8_16_chars'
biosfn_load_gfx_8_16_chars:                  ; 0xc2f58 LB 0x22
    push bp                                   ; 55                          ; 0xc2f58 vgabios.c:2051
    mov bp, sp                                ; 89 e5                       ; 0xc2f59
    push bx                                   ; 53                          ; 0xc2f5b
    push cx                                   ; 51                          ; 0xc2f5c
    mov bl, al                                ; 88 c3                       ; 0xc2f5d
    mov al, dl                                ; 88 d0                       ; 0xc2f5f
    xor ah, ah                                ; 30 e4                       ; 0xc2f61 vgabios.c:2053
    push ax                                   ; 50                          ; 0xc2f63
    mov al, bl                                ; 88 d8                       ; 0xc2f64
    mov cx, ax                                ; 89 c1                       ; 0xc2f66
    mov bx, strict word 00010h                ; bb 10 00                    ; 0xc2f68
    mov ax, 06b6ah                            ; b8 6a 6b                    ; 0xc2f6b
    mov dx, ds                                ; 8c da                       ; 0xc2f6e
    call 02eaah                               ; e8 37 ff                    ; 0xc2f70
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc2f73 vgabios.c:2054
    pop cx                                    ; 59                          ; 0xc2f76
    pop bx                                    ; 5b                          ; 0xc2f77
    pop bp                                    ; 5d                          ; 0xc2f78
    retn                                      ; c3                          ; 0xc2f79
  ; disGetNextSymbol 0xc2f7a LB 0x1578 -> off=0x0 cb=0000000000000005 uValue=00000000000c2f7a 'biosfn_alternate_prtsc'
biosfn_alternate_prtsc:                      ; 0xc2f7a LB 0x5
    push bp                                   ; 55                          ; 0xc2f7a vgabios.c:2056
    mov bp, sp                                ; 89 e5                       ; 0xc2f7b
    pop bp                                    ; 5d                          ; 0xc2f7d vgabios.c:2061
    retn                                      ; c3                          ; 0xc2f7e
  ; disGetNextSymbol 0xc2f7f LB 0x1573 -> off=0x0 cb=0000000000000032 uValue=00000000000c2f7f 'biosfn_set_txt_lines'
biosfn_set_txt_lines:                        ; 0xc2f7f LB 0x32
    push bx                                   ; 53                          ; 0xc2f7f vgabios.c:2063
    push si                                   ; 56                          ; 0xc2f80
    push bp                                   ; 55                          ; 0xc2f81
    mov bp, sp                                ; 89 e5                       ; 0xc2f82
    mov bl, al                                ; 88 c3                       ; 0xc2f84
    mov si, 00089h                            ; be 89 00                    ; 0xc2f86 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc2f89
    mov es, ax                                ; 8e c0                       ; 0xc2f8c
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc2f8e
    and AL, strict byte 06fh                  ; 24 6f                       ; 0xc2f91 vgabios.c:2069
    cmp bl, 002h                              ; 80 fb 02                    ; 0xc2f93 vgabios.c:2071
    je short 02fa0h                           ; 74 08                       ; 0xc2f96
    test bl, bl                               ; 84 db                       ; 0xc2f98
    jne short 02fa2h                          ; 75 06                       ; 0xc2f9a
    or AL, strict byte 080h                   ; 0c 80                       ; 0xc2f9c vgabios.c:2074
    jmp short 02fa2h                          ; eb 02                       ; 0xc2f9e vgabios.c:2075
    or AL, strict byte 010h                   ; 0c 10                       ; 0xc2fa0 vgabios.c:2077
    mov bx, 00089h                            ; bb 89 00                    ; 0xc2fa2 vgabios.c:52
    mov si, strict word 00040h                ; be 40 00                    ; 0xc2fa5
    mov es, si                                ; 8e c6                       ; 0xc2fa8
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc2faa
    pop bp                                    ; 5d                          ; 0xc2fad vgabios.c:2081
    pop si                                    ; 5e                          ; 0xc2fae
    pop bx                                    ; 5b                          ; 0xc2faf
    retn                                      ; c3                          ; 0xc2fb0
  ; disGetNextSymbol 0xc2fb1 LB 0x1541 -> off=0x0 cb=0000000000000005 uValue=00000000000c2fb1 'biosfn_switch_video_interface'
biosfn_switch_video_interface:               ; 0xc2fb1 LB 0x5
    push bp                                   ; 55                          ; 0xc2fb1 vgabios.c:2084
    mov bp, sp                                ; 89 e5                       ; 0xc2fb2
    pop bp                                    ; 5d                          ; 0xc2fb4 vgabios.c:2089
    retn                                      ; c3                          ; 0xc2fb5
  ; disGetNextSymbol 0xc2fb6 LB 0x153c -> off=0x0 cb=0000000000000005 uValue=00000000000c2fb6 'biosfn_enable_video_refresh_control'
biosfn_enable_video_refresh_control:         ; 0xc2fb6 LB 0x5
    push bp                                   ; 55                          ; 0xc2fb6 vgabios.c:2090
    mov bp, sp                                ; 89 e5                       ; 0xc2fb7
    pop bp                                    ; 5d                          ; 0xc2fb9 vgabios.c:2095
    retn                                      ; c3                          ; 0xc2fba
  ; disGetNextSymbol 0xc2fbb LB 0x1537 -> off=0x0 cb=000000000000008f uValue=00000000000c2fbb 'biosfn_write_string'
biosfn_write_string:                         ; 0xc2fbb LB 0x8f
    push bp                                   ; 55                          ; 0xc2fbb vgabios.c:2098
    mov bp, sp                                ; 89 e5                       ; 0xc2fbc
    push si                                   ; 56                          ; 0xc2fbe
    push di                                   ; 57                          ; 0xc2fbf
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc2fc0
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc2fc3
    mov byte [bp-006h], dl                    ; 88 56 fa                    ; 0xc2fc6
    mov byte [bp-00ah], bl                    ; 88 5e f6                    ; 0xc2fc9
    mov si, cx                                ; 89 ce                       ; 0xc2fcc
    mov di, word [bp+00ah]                    ; 8b 7e 0a                    ; 0xc2fce
    mov al, dl                                ; 88 d0                       ; 0xc2fd1 vgabios.c:2105
    xor ah, ah                                ; 30 e4                       ; 0xc2fd3
    lea bx, [bp-00eh]                         ; 8d 5e f2                    ; 0xc2fd5
    lea dx, [bp-00ch]                         ; 8d 56 f4                    ; 0xc2fd8
    call 00a97h                               ; e8 b9 da                    ; 0xc2fdb
    cmp byte [bp+004h], 0ffh                  ; 80 7e 04 ff                 ; 0xc2fde vgabios.c:2108
    jne short 02ff0h                          ; 75 0c                       ; 0xc2fe2
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc2fe4 vgabios.c:2109
    mov byte [bp+006h], al                    ; 88 46 06                    ; 0xc2fe7
    mov ax, word [bp-00eh]                    ; 8b 46 f2                    ; 0xc2fea vgabios.c:2110
    mov byte [bp+004h], ah                    ; 88 66 04                    ; 0xc2fed
    mov dh, byte [bp+004h]                    ; 8a 76 04                    ; 0xc2ff0 vgabios.c:2113
    mov dl, byte [bp+006h]                    ; 8a 56 06                    ; 0xc2ff3
    xor ah, ah                                ; 30 e4                       ; 0xc2ff6
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc2ff8 vgabios.c:2114
    call 012a1h                               ; e8 a3 e2                    ; 0xc2ffb
    dec si                                    ; 4e                          ; 0xc2ffe vgabios.c:2116
    cmp si, strict byte 0ffffh                ; 83 fe ff                    ; 0xc2fff
    je short 03030h                           ; 74 2c                       ; 0xc3002
    mov bx, di                                ; 89 fb                       ; 0xc3004 vgabios.c:2118
    inc di                                    ; 47                          ; 0xc3006
    mov es, [bp+008h]                         ; 8e 46 08                    ; 0xc3007 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc300a
    test byte [bp-008h], 002h                 ; f6 46 f8 02                 ; 0xc300d vgabios.c:2119
    je short 0301ch                           ; 74 09                       ; 0xc3011
    mov bx, di                                ; 89 fb                       ; 0xc3013 vgabios.c:2120
    inc di                                    ; 47                          ; 0xc3015
    mov ah, byte [es:bx]                      ; 26 8a 27                    ; 0xc3016 vgabios.c:47
    mov byte [bp-00ah], ah                    ; 88 66 f6                    ; 0xc3019 vgabios.c:48
    mov bl, byte [bp-00ah]                    ; 8a 5e f6                    ; 0xc301c vgabios.c:2122
    xor bh, bh                                ; 30 ff                       ; 0xc301f
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc3021
    xor dh, dh                                ; 30 f6                       ; 0xc3024
    xor ah, ah                                ; 30 e4                       ; 0xc3026
    mov cx, strict word 00003h                ; b9 03 00                    ; 0xc3028
    call 029dbh                               ; e8 ad f9                    ; 0xc302b
    jmp short 02ffeh                          ; eb ce                       ; 0xc302e vgabios.c:2123
    test byte [bp-008h], 001h                 ; f6 46 f8 01                 ; 0xc3030 vgabios.c:2126
    jne short 03041h                          ; 75 0b                       ; 0xc3034
    mov dx, word [bp-00eh]                    ; 8b 56 f2                    ; 0xc3036 vgabios.c:2127
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc3039
    xor ah, ah                                ; 30 e4                       ; 0xc303c
    call 012a1h                               ; e8 60 e2                    ; 0xc303e
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3041 vgabios.c:2128
    pop di                                    ; 5f                          ; 0xc3044
    pop si                                    ; 5e                          ; 0xc3045
    pop bp                                    ; 5d                          ; 0xc3046
    retn 00008h                               ; c2 08 00                    ; 0xc3047
  ; disGetNextSymbol 0xc304a LB 0x14a8 -> off=0x0 cb=00000000000001f2 uValue=00000000000c304a 'biosfn_read_state_info'
biosfn_read_state_info:                      ; 0xc304a LB 0x1f2
    push bp                                   ; 55                          ; 0xc304a vgabios.c:2131
    mov bp, sp                                ; 89 e5                       ; 0xc304b
    push cx                                   ; 51                          ; 0xc304d
    push si                                   ; 56                          ; 0xc304e
    push di                                   ; 57                          ; 0xc304f
    push ax                                   ; 50                          ; 0xc3050
    push ax                                   ; 50                          ; 0xc3051
    push dx                                   ; 52                          ; 0xc3052
    mov si, strict word 00049h                ; be 49 00                    ; 0xc3053 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3056
    mov es, ax                                ; 8e c0                       ; 0xc3059
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc305b
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc305e vgabios.c:48
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc3061 vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3064
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc3067 vgabios.c:58
    mov ax, ds                                ; 8c d8                       ; 0xc306a vgabios.c:2142
    mov es, dx                                ; 8e c2                       ; 0xc306c vgabios.c:72
    mov word [es:bx], 05500h                  ; 26 c7 07 00 55              ; 0xc306e
    mov [es:bx+002h], ds                      ; 26 8c 5f 02                 ; 0xc3073
    lea di, [bx+004h]                         ; 8d 7f 04                    ; 0xc3077 vgabios.c:2147
    mov cx, strict word 0001eh                ; b9 1e 00                    ; 0xc307a
    mov si, strict word 00049h                ; be 49 00                    ; 0xc307d
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc3080
    jcxz 0308bh                               ; e3 06                       ; 0xc3083
    push DS                                   ; 1e                          ; 0xc3085
    mov ds, dx                                ; 8e da                       ; 0xc3086
    rep movsb                                 ; f3 a4                       ; 0xc3088
    pop DS                                    ; 1f                          ; 0xc308a
    mov si, 00084h                            ; be 84 00                    ; 0xc308b vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc308e
    mov es, ax                                ; 8e c0                       ; 0xc3091
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3093
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc3096 vgabios.c:48
    lea si, [bx+022h]                         ; 8d 77 22                    ; 0xc3098
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc309b vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc309e
    lea di, [bx+023h]                         ; 8d 7f 23                    ; 0xc30a1 vgabios.c:2149
    mov cx, strict word 00002h                ; b9 02 00                    ; 0xc30a4
    mov si, 00085h                            ; be 85 00                    ; 0xc30a7
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc30aa
    jcxz 030b5h                               ; e3 06                       ; 0xc30ad
    push DS                                   ; 1e                          ; 0xc30af
    mov ds, dx                                ; 8e da                       ; 0xc30b0
    rep movsb                                 ; f3 a4                       ; 0xc30b2
    pop DS                                    ; 1f                          ; 0xc30b4
    mov si, 0008ah                            ; be 8a 00                    ; 0xc30b5 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc30b8
    mov es, ax                                ; 8e c0                       ; 0xc30bb
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc30bd
    lea si, [bx+025h]                         ; 8d 77 25                    ; 0xc30c0 vgabios.c:48
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc30c3 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc30c6
    lea si, [bx+026h]                         ; 8d 77 26                    ; 0xc30c9 vgabios.c:2152
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc30cc vgabios.c:52
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc30d0 vgabios.c:2153
    mov word [es:si], strict word 00010h      ; 26 c7 04 10 00              ; 0xc30d3 vgabios.c:62
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc30d8 vgabios.c:2154
    mov byte [es:si], 008h                    ; 26 c6 04 08                 ; 0xc30db vgabios.c:52
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc30df vgabios.c:2155
    mov byte [es:si], 002h                    ; 26 c6 04 02                 ; 0xc30e2 vgabios.c:52
    lea si, [bx+02bh]                         ; 8d 77 2b                    ; 0xc30e6 vgabios.c:2156
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc30e9 vgabios.c:52
    lea si, [bx+02ch]                         ; 8d 77 2c                    ; 0xc30ed vgabios.c:2157
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc30f0 vgabios.c:52
    lea si, [bx+02dh]                         ; 8d 77 2d                    ; 0xc30f4 vgabios.c:2158
    mov byte [es:si], 021h                    ; 26 c6 04 21                 ; 0xc30f7 vgabios.c:52
    lea si, [bx+031h]                         ; 8d 77 31                    ; 0xc30fb vgabios.c:2159
    mov byte [es:si], 003h                    ; 26 c6 04 03                 ; 0xc30fe vgabios.c:52
    lea si, [bx+032h]                         ; 8d 77 32                    ; 0xc3102 vgabios.c:2160
    mov byte [es:si], 000h                    ; 26 c6 04 00                 ; 0xc3105 vgabios.c:52
    mov si, 00089h                            ; be 89 00                    ; 0xc3109 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc310c
    mov es, ax                                ; 8e c0                       ; 0xc310f
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3111
    mov dl, al                                ; 88 c2                       ; 0xc3114 vgabios.c:2165
    and dl, 080h                              ; 80 e2 80                    ; 0xc3116
    xor dh, dh                                ; 30 f6                       ; 0xc3119
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc311b
    sar dx, CL                                ; d3 fa                       ; 0xc311d
    and AL, strict byte 010h                  ; 24 10                       ; 0xc311f
    xor ah, ah                                ; 30 e4                       ; 0xc3121
    mov CL, strict byte 004h                  ; b1 04                       ; 0xc3123
    sar ax, CL                                ; d3 f8                       ; 0xc3125
    or ax, dx                                 ; 09 d0                       ; 0xc3127
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3129 vgabios.c:2166
    je short 0313fh                           ; 74 11                       ; 0xc312c
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc312e
    je short 0313bh                           ; 74 08                       ; 0xc3131
    test ax, ax                               ; 85 c0                       ; 0xc3133
    jne short 0313fh                          ; 75 08                       ; 0xc3135
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc3137 vgabios.c:2167
    jmp short 03141h                          ; eb 06                       ; 0xc3139
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc313b vgabios.c:2168
    jmp short 03141h                          ; eb 02                       ; 0xc313d
    xor al, al                                ; 30 c0                       ; 0xc313f vgabios.c:2170
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc3141 vgabios.c:2172
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc3144 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3147
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc314a vgabios.c:2175
    cmp AL, strict byte 00eh                  ; 3c 0e                       ; 0xc314d
    jc short 03171h                           ; 72 20                       ; 0xc314f
    cmp AL, strict byte 012h                  ; 3c 12                       ; 0xc3151
    jnbe short 03171h                         ; 77 1c                       ; 0xc3153
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3155 vgabios.c:2176
    test ax, ax                               ; 85 c0                       ; 0xc3158
    je short 031b3h                           ; 74 57                       ; 0xc315a
    mov si, ax                                ; 89 c6                       ; 0xc315c vgabios.c:2177
    shr si, 1                                 ; d1 ee                       ; 0xc315e
    shr si, 1                                 ; d1 ee                       ; 0xc3160
    mov ax, 04000h                            ; b8 00 40                    ; 0xc3162
    xor dx, dx                                ; 31 d2                       ; 0xc3165
    div si                                    ; f7 f6                       ; 0xc3167
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc3169
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc316c vgabios.c:52
    jmp short 031b3h                          ; eb 42                       ; 0xc316f vgabios.c:2178
    lea si, [bx+029h]                         ; 8d 77 29                    ; 0xc3171
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3174
    cmp AL, strict byte 013h                  ; 3c 13                       ; 0xc3177
    jne short 0318ch                          ; 75 11                       ; 0xc3179
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc317b vgabios.c:52
    mov byte [es:si], 001h                    ; 26 c6 04 01                 ; 0xc317e
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc3182 vgabios.c:2180
    mov word [es:si], 00100h                  ; 26 c7 04 00 01              ; 0xc3185 vgabios.c:62
    jmp short 031b3h                          ; eb 27                       ; 0xc318a vgabios.c:2181
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc318c
    jc short 031b3h                           ; 72 23                       ; 0xc318e
    cmp AL, strict byte 006h                  ; 3c 06                       ; 0xc3190
    jnbe short 031b3h                         ; 77 1f                       ; 0xc3192
    cmp word [bp-00ah], strict byte 00000h    ; 83 7e f6 00                 ; 0xc3194 vgabios.c:2183
    je short 031a8h                           ; 74 0e                       ; 0xc3198
    mov ax, 04000h                            ; b8 00 40                    ; 0xc319a vgabios.c:2184
    xor dx, dx                                ; 31 d2                       ; 0xc319d
    div word [bp-00ah]                        ; f7 76 f6                    ; 0xc319f
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc31a2 vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc31a5
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc31a8 vgabios.c:2185
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc31ab vgabios.c:62
    mov word [es:si], strict word 00004h      ; 26 c7 04 04 00              ; 0xc31ae
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc31b3 vgabios.c:2187
    cmp AL, strict byte 006h                  ; 3c 06                       ; 0xc31b6
    je short 031beh                           ; 74 04                       ; 0xc31b8
    cmp AL, strict byte 011h                  ; 3c 11                       ; 0xc31ba
    jne short 031c9h                          ; 75 0b                       ; 0xc31bc
    lea si, [bx+027h]                         ; 8d 77 27                    ; 0xc31be vgabios.c:2188
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc31c1 vgabios.c:62
    mov word [es:si], strict word 00002h      ; 26 c7 04 02 00              ; 0xc31c4
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc31c9 vgabios.c:2190
    cmp AL, strict byte 004h                  ; 3c 04                       ; 0xc31cc
    jc short 03225h                           ; 72 55                       ; 0xc31ce
    cmp AL, strict byte 007h                  ; 3c 07                       ; 0xc31d0
    je short 03225h                           ; 74 51                       ; 0xc31d2
    lea si, [bx+02dh]                         ; 8d 77 2d                    ; 0xc31d4 vgabios.c:2191
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc31d7 vgabios.c:52
    mov byte [es:si], 001h                    ; 26 c6 04 01                 ; 0xc31da
    mov si, 00084h                            ; be 84 00                    ; 0xc31de vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc31e1
    mov es, ax                                ; 8e c0                       ; 0xc31e4
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc31e6
    xor ah, ah                                ; 30 e4                       ; 0xc31e9 vgabios.c:48
    inc ax                                    ; 40                          ; 0xc31eb
    mov si, 00085h                            ; be 85 00                    ; 0xc31ec vgabios.c:47
    mov dl, byte [es:si]                      ; 26 8a 14                    ; 0xc31ef
    xor dh, dh                                ; 30 f6                       ; 0xc31f2 vgabios.c:48
    imul dx                                   ; f7 ea                       ; 0xc31f4
    cmp ax, 0015eh                            ; 3d 5e 01                    ; 0xc31f6 vgabios.c:2193
    jc short 03209h                           ; 72 0e                       ; 0xc31f9
    jbe short 03212h                          ; 76 15                       ; 0xc31fb
    cmp ax, 001e0h                            ; 3d e0 01                    ; 0xc31fd
    je short 0321ah                           ; 74 18                       ; 0xc3200
    cmp ax, 00190h                            ; 3d 90 01                    ; 0xc3202
    je short 03216h                           ; 74 0f                       ; 0xc3205
    jmp short 0321ah                          ; eb 11                       ; 0xc3207
    cmp ax, 000c8h                            ; 3d c8 00                    ; 0xc3209
    jne short 0321ah                          ; 75 0c                       ; 0xc320c
    xor al, al                                ; 30 c0                       ; 0xc320e vgabios.c:2194
    jmp short 0321ch                          ; eb 0a                       ; 0xc3210
    mov AL, strict byte 001h                  ; b0 01                       ; 0xc3212 vgabios.c:2195
    jmp short 0321ch                          ; eb 06                       ; 0xc3214
    mov AL, strict byte 002h                  ; b0 02                       ; 0xc3216 vgabios.c:2196
    jmp short 0321ch                          ; eb 02                       ; 0xc3218
    mov AL, strict byte 003h                  ; b0 03                       ; 0xc321a vgabios.c:2198
    lea si, [bx+02ah]                         ; 8d 77 2a                    ; 0xc321c vgabios.c:2200
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc321f vgabios.c:52
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3222
    lea di, [bx+033h]                         ; 8d 7f 33                    ; 0xc3225 vgabios.c:2203
    mov cx, strict word 0000dh                ; b9 0d 00                    ; 0xc3228
    xor ax, ax                                ; 31 c0                       ; 0xc322b
    mov es, [bp-00ch]                         ; 8e 46 f4                    ; 0xc322d
    jcxz 03234h                               ; e3 02                       ; 0xc3230
    rep stosb                                 ; f3 aa                       ; 0xc3232
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3234 vgabios.c:2204
    pop di                                    ; 5f                          ; 0xc3237
    pop si                                    ; 5e                          ; 0xc3238
    pop cx                                    ; 59                          ; 0xc3239
    pop bp                                    ; 5d                          ; 0xc323a
    retn                                      ; c3                          ; 0xc323b
  ; disGetNextSymbol 0xc323c LB 0x12b6 -> off=0x0 cb=0000000000000023 uValue=00000000000c323c 'biosfn_read_video_state_size2'
biosfn_read_video_state_size2:               ; 0xc323c LB 0x23
    push dx                                   ; 52                          ; 0xc323c vgabios.c:2207
    push bp                                   ; 55                          ; 0xc323d
    mov bp, sp                                ; 89 e5                       ; 0xc323e
    mov dx, ax                                ; 89 c2                       ; 0xc3240
    xor ax, ax                                ; 31 c0                       ; 0xc3242 vgabios.c:2211
    test dl, 001h                             ; f6 c2 01                    ; 0xc3244 vgabios.c:2212
    je short 0324ch                           ; 74 03                       ; 0xc3247
    mov ax, strict word 00046h                ; b8 46 00                    ; 0xc3249 vgabios.c:2213
    test dl, 002h                             ; f6 c2 02                    ; 0xc324c vgabios.c:2215
    je short 03254h                           ; 74 03                       ; 0xc324f
    add ax, strict word 0002ah                ; 05 2a 00                    ; 0xc3251 vgabios.c:2216
    test dl, 004h                             ; f6 c2 04                    ; 0xc3254 vgabios.c:2218
    je short 0325ch                           ; 74 03                       ; 0xc3257
    add ax, 00304h                            ; 05 04 03                    ; 0xc3259 vgabios.c:2219
    pop bp                                    ; 5d                          ; 0xc325c vgabios.c:2222
    pop dx                                    ; 5a                          ; 0xc325d
    retn                                      ; c3                          ; 0xc325e
  ; disGetNextSymbol 0xc325f LB 0x1293 -> off=0x0 cb=000000000000001b uValue=00000000000c325f 'vga_get_video_state_size'
vga_get_video_state_size:                    ; 0xc325f LB 0x1b
    push bp                                   ; 55                          ; 0xc325f vgabios.c:2224
    mov bp, sp                                ; 89 e5                       ; 0xc3260
    push bx                                   ; 53                          ; 0xc3262
    push cx                                   ; 51                          ; 0xc3263
    mov bx, dx                                ; 89 d3                       ; 0xc3264
    call 0323ch                               ; e8 d3 ff                    ; 0xc3266 vgabios.c:2227
    add ax, strict word 0003fh                ; 05 3f 00                    ; 0xc3269
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc326c
    shr ax, CL                                ; d3 e8                       ; 0xc326e
    mov word [ss:bx], ax                      ; 36 89 07                    ; 0xc3270
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3273 vgabios.c:2228
    pop cx                                    ; 59                          ; 0xc3276
    pop bx                                    ; 5b                          ; 0xc3277
    pop bp                                    ; 5d                          ; 0xc3278
    retn                                      ; c3                          ; 0xc3279
  ; disGetNextSymbol 0xc327a LB 0x1278 -> off=0x0 cb=00000000000002d8 uValue=00000000000c327a 'biosfn_save_video_state'
biosfn_save_video_state:                     ; 0xc327a LB 0x2d8
    push bp                                   ; 55                          ; 0xc327a vgabios.c:2230
    mov bp, sp                                ; 89 e5                       ; 0xc327b
    push cx                                   ; 51                          ; 0xc327d
    push si                                   ; 56                          ; 0xc327e
    push di                                   ; 57                          ; 0xc327f
    push ax                                   ; 50                          ; 0xc3280
    push ax                                   ; 50                          ; 0xc3281
    push ax                                   ; 50                          ; 0xc3282
    mov cx, dx                                ; 89 d1                       ; 0xc3283
    mov si, strict word 00063h                ; be 63 00                    ; 0xc3285 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3288
    mov es, ax                                ; 8e c0                       ; 0xc328b
    mov di, word [es:si]                      ; 26 8b 3c                    ; 0xc328d
    mov si, di                                ; 89 fe                       ; 0xc3290 vgabios.c:58
    test byte [bp-00ch], 001h                 ; f6 46 f4 01                 ; 0xc3292 vgabios.c:2235
    je short 032feh                           ; 74 66                       ; 0xc3296
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3298 vgabios.c:2236
    in AL, DX                                 ; ec                          ; 0xc329b
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc329c
    mov es, cx                                ; 8e c1                       ; 0xc329e vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32a0
    inc bx                                    ; 43                          ; 0xc32a3 vgabios.c:2236
    mov dx, di                                ; 89 fa                       ; 0xc32a4
    in AL, DX                                 ; ec                          ; 0xc32a6
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32a7
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32a9 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc32ac vgabios.c:2237
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc32ad
    in AL, DX                                 ; ec                          ; 0xc32b0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32b1
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32b3 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc32b6 vgabios.c:2238
    mov dx, 003dah                            ; ba da 03                    ; 0xc32b7
    in AL, DX                                 ; ec                          ; 0xc32ba
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32bb
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc32bd vgabios.c:2240
    in AL, DX                                 ; ec                          ; 0xc32c0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32c1
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc32c3
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc32c6 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32c9
    inc bx                                    ; 43                          ; 0xc32cc vgabios.c:2241
    mov dx, 003cah                            ; ba ca 03                    ; 0xc32cd
    in AL, DX                                 ; ec                          ; 0xc32d0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32d1
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32d3 vgabios.c:52
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc32d6 vgabios.c:2244
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc32d9
    add bx, ax                                ; 01 c3                       ; 0xc32dc vgabios.c:2242
    jmp short 032e6h                          ; eb 06                       ; 0xc32de
    cmp word [bp-008h], strict byte 00004h    ; 83 7e f8 04                 ; 0xc32e0
    jnbe short 03301h                         ; 77 1b                       ; 0xc32e4
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc32e6 vgabios.c:2245
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc32e9
    out DX, AL                                ; ee                          ; 0xc32ec
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc32ed vgabios.c:2246
    in AL, DX                                 ; ec                          ; 0xc32f0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc32f1
    mov es, cx                                ; 8e c1                       ; 0xc32f3 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc32f5
    inc bx                                    ; 43                          ; 0xc32f8 vgabios.c:2246
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc32f9 vgabios.c:2247
    jmp short 032e0h                          ; eb e2                       ; 0xc32fc
    jmp near 033aeh                           ; e9 ad 00                    ; 0xc32fe
    xor al, al                                ; 30 c0                       ; 0xc3301 vgabios.c:2248
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc3303
    out DX, AL                                ; ee                          ; 0xc3306
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc3307 vgabios.c:2249
    in AL, DX                                 ; ec                          ; 0xc330a
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc330b
    mov es, cx                                ; 8e c1                       ; 0xc330d vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc330f
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3312 vgabios.c:2251
    inc bx                                    ; 43                          ; 0xc3317 vgabios.c:2249
    jmp short 03320h                          ; eb 06                       ; 0xc3318
    cmp word [bp-008h], strict byte 00018h    ; 83 7e f8 18                 ; 0xc331a
    jnbe short 03337h                         ; 77 17                       ; 0xc331e
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3320 vgabios.c:2252
    mov dx, si                                ; 89 f2                       ; 0xc3323
    out DX, AL                                ; ee                          ; 0xc3325
    lea dx, [si+001h]                         ; 8d 54 01                    ; 0xc3326 vgabios.c:2253
    in AL, DX                                 ; ec                          ; 0xc3329
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc332a
    mov es, cx                                ; 8e c1                       ; 0xc332c vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc332e
    inc bx                                    ; 43                          ; 0xc3331 vgabios.c:2253
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3332 vgabios.c:2254
    jmp short 0331ah                          ; eb e3                       ; 0xc3335
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3337 vgabios.c:2256
    jmp short 03344h                          ; eb 06                       ; 0xc333c
    cmp word [bp-008h], strict byte 00013h    ; 83 7e f8 13                 ; 0xc333e
    jnbe short 03368h                         ; 77 24                       ; 0xc3342
    mov dx, 003dah                            ; ba da 03                    ; 0xc3344 vgabios.c:2257
    in AL, DX                                 ; ec                          ; 0xc3347
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3348
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc334a vgabios.c:2258
    and ax, strict word 00020h                ; 25 20 00                    ; 0xc334d
    or ax, word [bp-008h]                     ; 0b 46 f8                    ; 0xc3350
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc3353
    out DX, AL                                ; ee                          ; 0xc3356
    mov dx, 003c1h                            ; ba c1 03                    ; 0xc3357 vgabios.c:2259
    in AL, DX                                 ; ec                          ; 0xc335a
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc335b
    mov es, cx                                ; 8e c1                       ; 0xc335d vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc335f
    inc bx                                    ; 43                          ; 0xc3362 vgabios.c:2259
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3363 vgabios.c:2260
    jmp short 0333eh                          ; eb d6                       ; 0xc3366
    mov dx, 003dah                            ; ba da 03                    ; 0xc3368 vgabios.c:2261
    in AL, DX                                 ; ec                          ; 0xc336b
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc336c
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc336e vgabios.c:2263
    jmp short 0337bh                          ; eb 06                       ; 0xc3373
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc3375
    jnbe short 03393h                         ; 77 18                       ; 0xc3379
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc337b vgabios.c:2264
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc337e
    out DX, AL                                ; ee                          ; 0xc3381
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc3382 vgabios.c:2265
    in AL, DX                                 ; ec                          ; 0xc3385
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3386
    mov es, cx                                ; 8e c1                       ; 0xc3388 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc338a
    inc bx                                    ; 43                          ; 0xc338d vgabios.c:2265
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc338e vgabios.c:2266
    jmp short 03375h                          ; eb e2                       ; 0xc3391
    mov es, cx                                ; 8e c1                       ; 0xc3393 vgabios.c:62
    mov word [es:bx], si                      ; 26 89 37                    ; 0xc3395
    inc bx                                    ; 43                          ; 0xc3398 vgabios.c:2268
    inc bx                                    ; 43                          ; 0xc3399
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc339a vgabios.c:52
    inc bx                                    ; 43                          ; 0xc339e vgabios.c:2271
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc339f vgabios.c:52
    inc bx                                    ; 43                          ; 0xc33a3 vgabios.c:2272
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc33a4 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc33a8 vgabios.c:2273
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc33a9 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc33ad vgabios.c:2274
    test byte [bp-00ch], 002h                 ; f6 46 f4 02                 ; 0xc33ae vgabios.c:2276
    jne short 033b7h                          ; 75 03                       ; 0xc33b2
    jmp near 034f6h                           ; e9 3f 01                    ; 0xc33b4
    mov si, strict word 00049h                ; be 49 00                    ; 0xc33b7 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33ba
    mov es, ax                                ; 8e c0                       ; 0xc33bd
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc33bf
    mov es, cx                                ; 8e c1                       ; 0xc33c2 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc33c4
    inc bx                                    ; 43                          ; 0xc33c7 vgabios.c:2277
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc33c8 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33cb
    mov es, ax                                ; 8e c0                       ; 0xc33ce
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc33d0
    mov es, cx                                ; 8e c1                       ; 0xc33d3 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc33d5
    inc bx                                    ; 43                          ; 0xc33d8 vgabios.c:2278
    inc bx                                    ; 43                          ; 0xc33d9
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc33da vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33dd
    mov es, ax                                ; 8e c0                       ; 0xc33e0
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc33e2
    mov es, cx                                ; 8e c1                       ; 0xc33e5 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc33e7
    inc bx                                    ; 43                          ; 0xc33ea vgabios.c:2279
    inc bx                                    ; 43                          ; 0xc33eb
    mov si, strict word 00063h                ; be 63 00                    ; 0xc33ec vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc33ef
    mov es, ax                                ; 8e c0                       ; 0xc33f2
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc33f4
    mov es, cx                                ; 8e c1                       ; 0xc33f7 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc33f9
    inc bx                                    ; 43                          ; 0xc33fc vgabios.c:2280
    inc bx                                    ; 43                          ; 0xc33fd
    mov si, 00084h                            ; be 84 00                    ; 0xc33fe vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3401
    mov es, ax                                ; 8e c0                       ; 0xc3404
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3406
    mov es, cx                                ; 8e c1                       ; 0xc3409 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc340b
    inc bx                                    ; 43                          ; 0xc340e vgabios.c:2281
    mov si, 00085h                            ; be 85 00                    ; 0xc340f vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3412
    mov es, ax                                ; 8e c0                       ; 0xc3415
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3417
    mov es, cx                                ; 8e c1                       ; 0xc341a vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc341c
    inc bx                                    ; 43                          ; 0xc341f vgabios.c:2282
    inc bx                                    ; 43                          ; 0xc3420
    mov si, 00087h                            ; be 87 00                    ; 0xc3421 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3424
    mov es, ax                                ; 8e c0                       ; 0xc3427
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3429
    mov es, cx                                ; 8e c1                       ; 0xc342c vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc342e
    inc bx                                    ; 43                          ; 0xc3431 vgabios.c:2283
    mov si, 00088h                            ; be 88 00                    ; 0xc3432 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3435
    mov es, ax                                ; 8e c0                       ; 0xc3438
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc343a
    mov es, cx                                ; 8e c1                       ; 0xc343d vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc343f
    inc bx                                    ; 43                          ; 0xc3442 vgabios.c:2284
    mov si, 00089h                            ; be 89 00                    ; 0xc3443 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3446
    mov es, ax                                ; 8e c0                       ; 0xc3449
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc344b
    mov es, cx                                ; 8e c1                       ; 0xc344e vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3450
    inc bx                                    ; 43                          ; 0xc3453 vgabios.c:2285
    mov si, strict word 00060h                ; be 60 00                    ; 0xc3454 vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3457
    mov es, ax                                ; 8e c0                       ; 0xc345a
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc345c
    mov es, cx                                ; 8e c1                       ; 0xc345f vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3461
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3464 vgabios.c:2287
    inc bx                                    ; 43                          ; 0xc3469 vgabios.c:2286
    inc bx                                    ; 43                          ; 0xc346a
    jmp short 03473h                          ; eb 06                       ; 0xc346b
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc346d
    jnc short 0348fh                          ; 73 1c                       ; 0xc3471
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc3473 vgabios.c:2288
    sal si, 1                                 ; d1 e6                       ; 0xc3476
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc3478
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc347b vgabios.c:57
    mov es, ax                                ; 8e c0                       ; 0xc347e
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3480
    mov es, cx                                ; 8e c1                       ; 0xc3483 vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3485
    inc bx                                    ; 43                          ; 0xc3488 vgabios.c:2289
    inc bx                                    ; 43                          ; 0xc3489
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc348a vgabios.c:2290
    jmp short 0346dh                          ; eb de                       ; 0xc348d
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc348f vgabios.c:57
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3492
    mov es, ax                                ; 8e c0                       ; 0xc3495
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc3497
    mov es, cx                                ; 8e c1                       ; 0xc349a vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc349c
    inc bx                                    ; 43                          ; 0xc349f vgabios.c:2291
    inc bx                                    ; 43                          ; 0xc34a0
    mov si, strict word 00062h                ; be 62 00                    ; 0xc34a1 vgabios.c:47
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc34a4
    mov es, ax                                ; 8e c0                       ; 0xc34a7
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc34a9
    mov es, cx                                ; 8e c1                       ; 0xc34ac vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc34ae
    inc bx                                    ; 43                          ; 0xc34b1 vgabios.c:2292
    mov si, strict word 0007ch                ; be 7c 00                    ; 0xc34b2 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc34b5
    mov es, ax                                ; 8e c0                       ; 0xc34b7
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc34b9
    mov es, cx                                ; 8e c1                       ; 0xc34bc vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc34be
    inc bx                                    ; 43                          ; 0xc34c1 vgabios.c:2294
    inc bx                                    ; 43                          ; 0xc34c2
    mov si, strict word 0007eh                ; be 7e 00                    ; 0xc34c3 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc34c6
    mov es, ax                                ; 8e c0                       ; 0xc34c8
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc34ca
    mov es, cx                                ; 8e c1                       ; 0xc34cd vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc34cf
    inc bx                                    ; 43                          ; 0xc34d2 vgabios.c:2295
    inc bx                                    ; 43                          ; 0xc34d3
    mov si, 0010ch                            ; be 0c 01                    ; 0xc34d4 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc34d7
    mov es, ax                                ; 8e c0                       ; 0xc34d9
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc34db
    mov es, cx                                ; 8e c1                       ; 0xc34de vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc34e0
    inc bx                                    ; 43                          ; 0xc34e3 vgabios.c:2296
    inc bx                                    ; 43                          ; 0xc34e4
    mov si, 0010eh                            ; be 0e 01                    ; 0xc34e5 vgabios.c:57
    xor ax, ax                                ; 31 c0                       ; 0xc34e8
    mov es, ax                                ; 8e c0                       ; 0xc34ea
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc34ec
    mov es, cx                                ; 8e c1                       ; 0xc34ef vgabios.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc34f1
    inc bx                                    ; 43                          ; 0xc34f4 vgabios.c:2297
    inc bx                                    ; 43                          ; 0xc34f5
    test byte [bp-00ch], 004h                 ; f6 46 f4 04                 ; 0xc34f6 vgabios.c:2299
    je short 03548h                           ; 74 4c                       ; 0xc34fa
    mov dx, 003c7h                            ; ba c7 03                    ; 0xc34fc vgabios.c:2301
    in AL, DX                                 ; ec                          ; 0xc34ff
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3500
    mov es, cx                                ; 8e c1                       ; 0xc3502 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3504
    inc bx                                    ; 43                          ; 0xc3507 vgabios.c:2301
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc3508
    in AL, DX                                 ; ec                          ; 0xc350b
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc350c
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc350e vgabios.c:52
    inc bx                                    ; 43                          ; 0xc3511 vgabios.c:2302
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc3512
    in AL, DX                                 ; ec                          ; 0xc3515
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3516
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3518 vgabios.c:52
    inc bx                                    ; 43                          ; 0xc351b vgabios.c:2303
    xor al, al                                ; 30 c0                       ; 0xc351c
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc351e
    out DX, AL                                ; ee                          ; 0xc3521
    xor ah, ah                                ; 30 e4                       ; 0xc3522 vgabios.c:2306
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3524
    jmp short 03530h                          ; eb 07                       ; 0xc3527
    cmp word [bp-008h], 00300h                ; 81 7e f8 00 03              ; 0xc3529
    jnc short 03541h                          ; 73 11                       ; 0xc352e
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc3530 vgabios.c:2307
    in AL, DX                                 ; ec                          ; 0xc3533
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3534
    mov es, cx                                ; 8e c1                       ; 0xc3536 vgabios.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc3538
    inc bx                                    ; 43                          ; 0xc353b vgabios.c:2307
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc353c vgabios.c:2308
    jmp short 03529h                          ; eb e8                       ; 0xc353f
    mov es, cx                                ; 8e c1                       ; 0xc3541 vgabios.c:52
    mov byte [es:bx], 000h                    ; 26 c6 07 00                 ; 0xc3543
    inc bx                                    ; 43                          ; 0xc3547 vgabios.c:2309
    mov ax, bx                                ; 89 d8                       ; 0xc3548 vgabios.c:2312
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc354a
    pop di                                    ; 5f                          ; 0xc354d
    pop si                                    ; 5e                          ; 0xc354e
    pop cx                                    ; 59                          ; 0xc354f
    pop bp                                    ; 5d                          ; 0xc3550
    retn                                      ; c3                          ; 0xc3551
  ; disGetNextSymbol 0xc3552 LB 0xfa0 -> off=0x0 cb=00000000000002ba uValue=00000000000c3552 'biosfn_restore_video_state'
biosfn_restore_video_state:                  ; 0xc3552 LB 0x2ba
    push bp                                   ; 55                          ; 0xc3552 vgabios.c:2314
    mov bp, sp                                ; 89 e5                       ; 0xc3553
    push cx                                   ; 51                          ; 0xc3555
    push si                                   ; 56                          ; 0xc3556
    push di                                   ; 57                          ; 0xc3557
    sub sp, strict byte 00008h                ; 83 ec 08                    ; 0xc3558
    push ax                                   ; 50                          ; 0xc355b
    mov cx, dx                                ; 89 d1                       ; 0xc355c
    test byte [bp-010h], 001h                 ; f6 46 f0 01                 ; 0xc355e vgabios.c:2318
    je short 035d8h                           ; 74 74                       ; 0xc3562
    mov dx, 003dah                            ; ba da 03                    ; 0xc3564 vgabios.c:2320
    in AL, DX                                 ; ec                          ; 0xc3567
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3568
    lea si, [bx+040h]                         ; 8d 77 40                    ; 0xc356a vgabios.c:2322
    mov es, cx                                ; 8e c1                       ; 0xc356d vgabios.c:57
    mov ax, word [es:si]                      ; 26 8b 04                    ; 0xc356f
    mov word [bp-00ch], ax                    ; 89 46 f4                    ; 0xc3572 vgabios.c:58
    mov si, bx                                ; 89 de                       ; 0xc3575 vgabios.c:2323
    mov word [bp-008h], strict word 00001h    ; c7 46 f8 01 00              ; 0xc3577 vgabios.c:2326
    add bx, strict byte 00005h                ; 83 c3 05                    ; 0xc357c vgabios.c:2324
    jmp short 03587h                          ; eb 06                       ; 0xc357f
    cmp word [bp-008h], strict byte 00004h    ; 83 7e f8 04                 ; 0xc3581
    jnbe short 0359dh                         ; 77 16                       ; 0xc3585
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc3587 vgabios.c:2327
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc358a
    out DX, AL                                ; ee                          ; 0xc358d
    mov es, cx                                ; 8e c1                       ; 0xc358e vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3590
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc3593 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3596
    inc bx                                    ; 43                          ; 0xc3597 vgabios.c:2328
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc3598 vgabios.c:2329
    jmp short 03581h                          ; eb e4                       ; 0xc359b
    xor al, al                                ; 30 c0                       ; 0xc359d vgabios.c:2330
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc359f
    out DX, AL                                ; ee                          ; 0xc35a2
    mov es, cx                                ; 8e c1                       ; 0xc35a3 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc35a5
    mov dx, 003c5h                            ; ba c5 03                    ; 0xc35a8 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc35ab
    inc bx                                    ; 43                          ; 0xc35ac vgabios.c:2331
    mov dx, 003cch                            ; ba cc 03                    ; 0xc35ad
    in AL, DX                                 ; ec                          ; 0xc35b0
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc35b1
    and AL, strict byte 0feh                  ; 24 fe                       ; 0xc35b3
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc35b5
    cmp word [bp-00ch], 003d4h                ; 81 7e f4 d4 03              ; 0xc35b8 vgabios.c:2335
    jne short 035c3h                          ; 75 04                       ; 0xc35bd
    or byte [bp-00eh], 001h                   ; 80 4e f2 01                 ; 0xc35bf vgabios.c:2336
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc35c3 vgabios.c:2337
    mov dx, 003c2h                            ; ba c2 03                    ; 0xc35c6
    out DX, AL                                ; ee                          ; 0xc35c9
    mov ax, strict word 00011h                ; b8 11 00                    ; 0xc35ca vgabios.c:2340
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc35cd
    out DX, ax                                ; ef                          ; 0xc35d0
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc35d1 vgabios.c:2342
    jmp short 035e1h                          ; eb 09                       ; 0xc35d6
    jmp near 0369bh                           ; e9 c0 00                    ; 0xc35d8
    cmp word [bp-008h], strict byte 00018h    ; 83 7e f8 18                 ; 0xc35db
    jnbe short 035fbh                         ; 77 1a                       ; 0xc35df
    cmp word [bp-008h], strict byte 00011h    ; 83 7e f8 11                 ; 0xc35e1 vgabios.c:2343
    je short 035f5h                           ; 74 0e                       ; 0xc35e5
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc35e7 vgabios.c:2344
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc35ea
    out DX, AL                                ; ee                          ; 0xc35ed
    mov es, cx                                ; 8e c1                       ; 0xc35ee vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc35f0
    inc dx                                    ; 42                          ; 0xc35f3 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc35f4
    inc bx                                    ; 43                          ; 0xc35f5 vgabios.c:2347
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc35f6 vgabios.c:2348
    jmp short 035dbh                          ; eb e0                       ; 0xc35f9
    mov AL, strict byte 011h                  ; b0 11                       ; 0xc35fb vgabios.c:2350
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc35fd
    out DX, AL                                ; ee                          ; 0xc3600
    lea di, [word bx-00007h]                  ; 8d bf f9 ff                 ; 0xc3601 vgabios.c:2351
    mov es, cx                                ; 8e c1                       ; 0xc3605 vgabios.c:47
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc3607
    inc dx                                    ; 42                          ; 0xc360a vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc360b
    lea di, [si+003h]                         ; 8d 7c 03                    ; 0xc360c vgabios.c:2354
    mov dl, byte [es:di]                      ; 26 8a 15                    ; 0xc360f vgabios.c:47
    xor dh, dh                                ; 30 f6                       ; 0xc3612 vgabios.c:48
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc3614
    mov dx, 003dah                            ; ba da 03                    ; 0xc3617 vgabios.c:2355
    in AL, DX                                 ; ec                          ; 0xc361a
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc361b
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc361d vgabios.c:2356
    jmp short 0362ah                          ; eb 06                       ; 0xc3622
    cmp word [bp-008h], strict byte 00013h    ; 83 7e f8 13                 ; 0xc3624
    jnbe short 03643h                         ; 77 19                       ; 0xc3628
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc362a vgabios.c:2357
    and ax, strict word 00020h                ; 25 20 00                    ; 0xc362d
    or ax, word [bp-008h]                     ; 0b 46 f8                    ; 0xc3630
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc3633
    out DX, AL                                ; ee                          ; 0xc3636
    mov es, cx                                ; 8e c1                       ; 0xc3637 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3639
    out DX, AL                                ; ee                          ; 0xc363c vgabios.c:48
    inc bx                                    ; 43                          ; 0xc363d vgabios.c:2358
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc363e vgabios.c:2359
    jmp short 03624h                          ; eb e1                       ; 0xc3641
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc3643 vgabios.c:2360
    mov dx, 003c0h                            ; ba c0 03                    ; 0xc3646
    out DX, AL                                ; ee                          ; 0xc3649
    mov dx, 003dah                            ; ba da 03                    ; 0xc364a vgabios.c:2361
    in AL, DX                                 ; ec                          ; 0xc364d
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc364e
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3650 vgabios.c:2363
    jmp short 0365dh                          ; eb 06                       ; 0xc3655
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc3657
    jnbe short 03673h                         ; 77 16                       ; 0xc365b
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc365d vgabios.c:2364
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc3660
    out DX, AL                                ; ee                          ; 0xc3663
    mov es, cx                                ; 8e c1                       ; 0xc3664 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3666
    mov dx, 003cfh                            ; ba cf 03                    ; 0xc3669 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc366c
    inc bx                                    ; 43                          ; 0xc366d vgabios.c:2365
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc366e vgabios.c:2366
    jmp short 03657h                          ; eb e4                       ; 0xc3671
    add bx, strict byte 00006h                ; 83 c3 06                    ; 0xc3673 vgabios.c:2367
    mov es, cx                                ; 8e c1                       ; 0xc3676 vgabios.c:47
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3678
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc367b vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc367e
    inc si                                    ; 46                          ; 0xc367f vgabios.c:2370
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3680 vgabios.c:47
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc3683 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc3686
    inc si                                    ; 46                          ; 0xc3687 vgabios.c:2371
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3688 vgabios.c:47
    mov dx, 003ceh                            ; ba ce 03                    ; 0xc368b vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc368e
    inc si                                    ; 46                          ; 0xc368f vgabios.c:2372
    inc si                                    ; 46                          ; 0xc3690
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc3691 vgabios.c:47
    mov dx, word [bp-00ch]                    ; 8b 56 f4                    ; 0xc3694 vgabios.c:48
    add dx, strict byte 00006h                ; 83 c2 06                    ; 0xc3697
    out DX, AL                                ; ee                          ; 0xc369a
    test byte [bp-010h], 002h                 ; f6 46 f0 02                 ; 0xc369b vgabios.c:2376
    jne short 036a4h                          ; 75 03                       ; 0xc369f
    jmp near 037bfh                           ; e9 1b 01                    ; 0xc36a1
    mov es, cx                                ; 8e c1                       ; 0xc36a4 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc36a6
    mov si, strict word 00049h                ; be 49 00                    ; 0xc36a9 vgabios.c:52
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc36ac
    mov es, dx                                ; 8e c2                       ; 0xc36af
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc36b1
    inc bx                                    ; 43                          ; 0xc36b4 vgabios.c:2377
    mov es, cx                                ; 8e c1                       ; 0xc36b5 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36b7
    mov si, strict word 0004ah                ; be 4a 00                    ; 0xc36ba vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc36bd
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc36bf
    inc bx                                    ; 43                          ; 0xc36c2 vgabios.c:2378
    inc bx                                    ; 43                          ; 0xc36c3
    mov es, cx                                ; 8e c1                       ; 0xc36c4 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36c6
    mov si, strict word 0004ch                ; be 4c 00                    ; 0xc36c9 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc36cc
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc36ce
    inc bx                                    ; 43                          ; 0xc36d1 vgabios.c:2379
    inc bx                                    ; 43                          ; 0xc36d2
    mov es, cx                                ; 8e c1                       ; 0xc36d3 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36d5
    mov si, strict word 00063h                ; be 63 00                    ; 0xc36d8 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc36db
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc36dd
    inc bx                                    ; 43                          ; 0xc36e0 vgabios.c:2380
    inc bx                                    ; 43                          ; 0xc36e1
    mov es, cx                                ; 8e c1                       ; 0xc36e2 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc36e4
    mov si, 00084h                            ; be 84 00                    ; 0xc36e7 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc36ea
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc36ec
    inc bx                                    ; 43                          ; 0xc36ef vgabios.c:2381
    mov es, cx                                ; 8e c1                       ; 0xc36f0 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc36f2
    mov si, 00085h                            ; be 85 00                    ; 0xc36f5 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc36f8
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc36fa
    inc bx                                    ; 43                          ; 0xc36fd vgabios.c:2382
    inc bx                                    ; 43                          ; 0xc36fe
    mov es, cx                                ; 8e c1                       ; 0xc36ff vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3701
    mov si, 00087h                            ; be 87 00                    ; 0xc3704 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc3707
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3709
    inc bx                                    ; 43                          ; 0xc370c vgabios.c:2383
    mov es, cx                                ; 8e c1                       ; 0xc370d vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc370f
    mov si, 00088h                            ; be 88 00                    ; 0xc3712 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc3715
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3717
    inc bx                                    ; 43                          ; 0xc371a vgabios.c:2384
    mov es, cx                                ; 8e c1                       ; 0xc371b vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc371d
    mov si, 00089h                            ; be 89 00                    ; 0xc3720 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc3723
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3725
    inc bx                                    ; 43                          ; 0xc3728 vgabios.c:2385
    mov es, cx                                ; 8e c1                       ; 0xc3729 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc372b
    mov si, strict word 00060h                ; be 60 00                    ; 0xc372e vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc3731
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3733
    mov word [bp-008h], strict word 00000h    ; c7 46 f8 00 00              ; 0xc3736 vgabios.c:2387
    inc bx                                    ; 43                          ; 0xc373b vgabios.c:2386
    inc bx                                    ; 43                          ; 0xc373c
    jmp short 03745h                          ; eb 06                       ; 0xc373d
    cmp word [bp-008h], strict byte 00008h    ; 83 7e f8 08                 ; 0xc373f
    jnc short 03761h                          ; 73 1c                       ; 0xc3743
    mov es, cx                                ; 8e c1                       ; 0xc3745 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3747
    mov si, word [bp-008h]                    ; 8b 76 f8                    ; 0xc374a vgabios.c:58
    sal si, 1                                 ; d1 e6                       ; 0xc374d
    add si, strict byte 00050h                ; 83 c6 50                    ; 0xc374f
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc3752 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc3755
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc3757
    inc bx                                    ; 43                          ; 0xc375a vgabios.c:2389
    inc bx                                    ; 43                          ; 0xc375b
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc375c vgabios.c:2390
    jmp short 0373fh                          ; eb de                       ; 0xc375f
    mov es, cx                                ; 8e c1                       ; 0xc3761 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3763
    mov si, strict word 0004eh                ; be 4e 00                    ; 0xc3766 vgabios.c:62
    mov dx, strict word 00040h                ; ba 40 00                    ; 0xc3769
    mov es, dx                                ; 8e c2                       ; 0xc376c
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc376e
    inc bx                                    ; 43                          ; 0xc3771 vgabios.c:2391
    inc bx                                    ; 43                          ; 0xc3772
    mov es, cx                                ; 8e c1                       ; 0xc3773 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc3775
    mov si, strict word 00062h                ; be 62 00                    ; 0xc3778 vgabios.c:52
    mov es, dx                                ; 8e c2                       ; 0xc377b
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc377d
    inc bx                                    ; 43                          ; 0xc3780 vgabios.c:2392
    mov es, cx                                ; 8e c1                       ; 0xc3781 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3783
    mov si, strict word 0007ch                ; be 7c 00                    ; 0xc3786 vgabios.c:62
    xor dx, dx                                ; 31 d2                       ; 0xc3789
    mov es, dx                                ; 8e c2                       ; 0xc378b
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc378d
    inc bx                                    ; 43                          ; 0xc3790 vgabios.c:2394
    inc bx                                    ; 43                          ; 0xc3791
    mov es, cx                                ; 8e c1                       ; 0xc3792 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc3794
    mov si, strict word 0007eh                ; be 7e 00                    ; 0xc3797 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc379a
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc379c
    inc bx                                    ; 43                          ; 0xc379f vgabios.c:2395
    inc bx                                    ; 43                          ; 0xc37a0
    mov es, cx                                ; 8e c1                       ; 0xc37a1 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc37a3
    mov si, 0010ch                            ; be 0c 01                    ; 0xc37a6 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc37a9
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc37ab
    inc bx                                    ; 43                          ; 0xc37ae vgabios.c:2396
    inc bx                                    ; 43                          ; 0xc37af
    mov es, cx                                ; 8e c1                       ; 0xc37b0 vgabios.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc37b2
    mov si, 0010eh                            ; be 0e 01                    ; 0xc37b5 vgabios.c:62
    mov es, dx                                ; 8e c2                       ; 0xc37b8
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc37ba
    inc bx                                    ; 43                          ; 0xc37bd vgabios.c:2397
    inc bx                                    ; 43                          ; 0xc37be
    test byte [bp-010h], 004h                 ; f6 46 f0 04                 ; 0xc37bf vgabios.c:2399
    je short 03802h                           ; 74 3d                       ; 0xc37c3
    inc bx                                    ; 43                          ; 0xc37c5 vgabios.c:2400
    mov es, cx                                ; 8e c1                       ; 0xc37c6 vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc37c8
    xor ah, ah                                ; 30 e4                       ; 0xc37cb vgabios.c:48
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc37cd
    inc bx                                    ; 43                          ; 0xc37d0 vgabios.c:2401
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc37d1 vgabios.c:47
    mov dx, 003c6h                            ; ba c6 03                    ; 0xc37d4 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc37d7
    inc bx                                    ; 43                          ; 0xc37d8 vgabios.c:2402
    xor al, al                                ; 30 c0                       ; 0xc37d9
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc37db
    out DX, AL                                ; ee                          ; 0xc37de
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc37df vgabios.c:2405
    jmp short 037ebh                          ; eb 07                       ; 0xc37e2
    cmp word [bp-008h], 00300h                ; 81 7e f8 00 03              ; 0xc37e4
    jnc short 037fah                          ; 73 0f                       ; 0xc37e9
    mov es, cx                                ; 8e c1                       ; 0xc37eb vgabios.c:47
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc37ed
    mov dx, 003c9h                            ; ba c9 03                    ; 0xc37f0 vgabios.c:48
    out DX, AL                                ; ee                          ; 0xc37f3
    inc bx                                    ; 43                          ; 0xc37f4 vgabios.c:2406
    inc word [bp-008h]                        ; ff 46 f8                    ; 0xc37f5 vgabios.c:2407
    jmp short 037e4h                          ; eb ea                       ; 0xc37f8
    inc bx                                    ; 43                          ; 0xc37fa vgabios.c:2408
    mov al, byte [bp-00eh]                    ; 8a 46 f2                    ; 0xc37fb
    mov dx, 003c8h                            ; ba c8 03                    ; 0xc37fe
    out DX, AL                                ; ee                          ; 0xc3801
    mov ax, bx                                ; 89 d8                       ; 0xc3802 vgabios.c:2412
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc3804
    pop di                                    ; 5f                          ; 0xc3807
    pop si                                    ; 5e                          ; 0xc3808
    pop cx                                    ; 59                          ; 0xc3809
    pop bp                                    ; 5d                          ; 0xc380a
    retn                                      ; c3                          ; 0xc380b
  ; disGetNextSymbol 0xc380c LB 0xce6 -> off=0x0 cb=000000000000002b uValue=00000000000c380c 'find_vga_entry'
find_vga_entry:                              ; 0xc380c LB 0x2b
    push bx                                   ; 53                          ; 0xc380c vgabios.c:2421
    push cx                                   ; 51                          ; 0xc380d
    push dx                                   ; 52                          ; 0xc380e
    push bp                                   ; 55                          ; 0xc380f
    mov bp, sp                                ; 89 e5                       ; 0xc3810
    mov dl, al                                ; 88 c2                       ; 0xc3812
    mov AH, strict byte 0ffh                  ; b4 ff                       ; 0xc3814 vgabios.c:2423
    xor al, al                                ; 30 c0                       ; 0xc3816 vgabios.c:2424
    jmp short 03820h                          ; eb 06                       ; 0xc3818
    db  0feh, 0c0h
    ; inc al                                    ; fe c0                     ; 0xc381a vgabios.c:2425
    cmp AL, strict byte 00fh                  ; 3c 0f                       ; 0xc381c
    jnbe short 03830h                         ; 77 10                       ; 0xc381e
    mov bl, al                                ; 88 c3                       ; 0xc3820
    xor bh, bh                                ; 30 ff                       ; 0xc3822
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc3824
    sal bx, CL                                ; d3 e3                       ; 0xc3826
    cmp dl, byte [bx+047ach]                  ; 3a 97 ac 47                 ; 0xc3828
    jne short 0381ah                          ; 75 ec                       ; 0xc382c
    mov ah, al                                ; 88 c4                       ; 0xc382e
    mov al, ah                                ; 88 e0                       ; 0xc3830 vgabios.c:2430
    pop bp                                    ; 5d                          ; 0xc3832
    pop dx                                    ; 5a                          ; 0xc3833
    pop cx                                    ; 59                          ; 0xc3834
    pop bx                                    ; 5b                          ; 0xc3835
    retn                                      ; c3                          ; 0xc3836
  ; disGetNextSymbol 0xc3837 LB 0xcbb -> off=0x0 cb=000000000000000e uValue=00000000000c3837 'readx_byte'
readx_byte:                                  ; 0xc3837 LB 0xe
    push bx                                   ; 53                          ; 0xc3837 vgabios.c:2442
    push bp                                   ; 55                          ; 0xc3838
    mov bp, sp                                ; 89 e5                       ; 0xc3839
    mov bx, dx                                ; 89 d3                       ; 0xc383b
    mov es, ax                                ; 8e c0                       ; 0xc383d vgabios.c:2444
    mov al, byte [es:bx]                      ; 26 8a 07                    ; 0xc383f
    pop bp                                    ; 5d                          ; 0xc3842 vgabios.c:2445
    pop bx                                    ; 5b                          ; 0xc3843
    retn                                      ; c3                          ; 0xc3844
  ; disGetNextSymbol 0xc3845 LB 0xcad -> off=0x8a cb=0000000000000456 uValue=00000000000c38cf 'int10_func'
    db  056h, 04fh, 01ch, 01bh, 013h, 012h, 011h, 010h, 00eh, 00dh, 00ch, 00ah, 009h, 008h, 007h, 006h
    db  005h, 004h, 003h, 002h, 001h, 000h, 01eh, 03dh, 0f9h, 038h, 036h, 039h, 045h, 039h, 053h, 039h
    db  063h, 039h, 073h, 039h, 07dh, 039h, 0a6h, 039h, 0cfh, 039h, 0ddh, 039h, 0f3h, 039h, 00bh, 03ah
    db  02eh, 03ah, 042h, 03ah, 058h, 03ah, 064h, 03ah, 066h, 03bh, 0ech, 03bh, 00fh, 03ch, 023h, 03ch
    db  065h, 03ch, 0f0h, 03ch, 030h, 024h, 023h, 022h, 021h, 020h, 014h, 012h, 011h, 010h, 004h, 003h
    db  002h, 001h, 000h, 01eh, 03dh, 083h, 03ah, 09eh, 03ah, 0bch, 03ah, 0d4h, 03ah, 0dfh, 03ah, 083h
    db  03ah, 09eh, 03ah, 0bch, 03ah, 0dfh, 03ah, 0f7h, 03ah, 002h, 03bh, 01bh, 03bh, 02ah, 03bh, 039h
    db  03bh, 046h, 03bh, 00ah, 009h, 006h, 004h, 002h, 001h, 000h, 0e2h, 03ch, 08bh, 03ch, 099h, 03ch
    db  0aah, 03ch, 0bah, 03ch, 0cfh, 03ch, 0e2h, 03ch, 0e2h, 03ch
int10_func:                                  ; 0xc38cf LB 0x456
    push bp                                   ; 55                          ; 0xc38cf vgabios.c:2523
    mov bp, sp                                ; 89 e5                       ; 0xc38d0
    push si                                   ; 56                          ; 0xc38d2
    push di                                   ; 57                          ; 0xc38d3
    push ax                                   ; 50                          ; 0xc38d4
    mov si, word [bp+004h]                    ; 8b 76 04                    ; 0xc38d5
    mov al, byte [bp+013h]                    ; 8a 46 13                    ; 0xc38d8 vgabios.c:2528
    xor ah, ah                                ; 30 e4                       ; 0xc38db
    mov dx, ax                                ; 89 c2                       ; 0xc38dd
    cmp ax, strict word 00056h                ; 3d 56 00                    ; 0xc38df
    jnbe short 03950h                         ; 77 6c                       ; 0xc38e2
    push CS                                   ; 0e                          ; 0xc38e4
    pop ES                                    ; 07                          ; 0xc38e5
    mov cx, strict word 00017h                ; b9 17 00                    ; 0xc38e6
    mov di, 03845h                            ; bf 45 38                    ; 0xc38e9
    repne scasb                               ; f2 ae                       ; 0xc38ec
    sal cx, 1                                 ; d1 e1                       ; 0xc38ee
    mov di, cx                                ; 89 cf                       ; 0xc38f0
    mov ax, word [cs:di+0385bh]               ; 2e 8b 85 5b 38              ; 0xc38f2
    jmp ax                                    ; ff e0                       ; 0xc38f7
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc38f9 vgabios.c:2531
    xor ah, ah                                ; 30 e4                       ; 0xc38fc
    call 013f4h                               ; e8 f3 da                    ; 0xc38fe
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3901 vgabios.c:2532
    and ax, strict word 0007fh                ; 25 7f 00                    ; 0xc3904
    cmp ax, strict word 00007h                ; 3d 07 00                    ; 0xc3907
    je short 03921h                           ; 74 15                       ; 0xc390a
    cmp ax, strict word 00006h                ; 3d 06 00                    ; 0xc390c
    je short 03918h                           ; 74 07                       ; 0xc390f
    cmp ax, strict word 00005h                ; 3d 05 00                    ; 0xc3911
    jbe short 03921h                          ; 76 0b                       ; 0xc3914
    jmp short 0392ah                          ; eb 12                       ; 0xc3916
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3918 vgabios.c:2534
    xor al, al                                ; 30 c0                       ; 0xc391b
    or AL, strict byte 03fh                   ; 0c 3f                       ; 0xc391d
    jmp short 03931h                          ; eb 10                       ; 0xc391f vgabios.c:2535
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3921 vgabios.c:2543
    xor al, al                                ; 30 c0                       ; 0xc3924
    or AL, strict byte 030h                   ; 0c 30                       ; 0xc3926
    jmp short 03931h                          ; eb 07                       ; 0xc3928
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc392a vgabios.c:2546
    xor al, al                                ; 30 c0                       ; 0xc392d
    or AL, strict byte 020h                   ; 0c 20                       ; 0xc392f
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc3931
    jmp short 03950h                          ; eb 1a                       ; 0xc3934 vgabios.c:2548
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc3936 vgabios.c:2550
    xor ah, ah                                ; 30 e4                       ; 0xc3939
    mov dx, ax                                ; 89 c2                       ; 0xc393b
    mov al, byte [bp+011h]                    ; 8a 46 11                    ; 0xc393d
    call 011a5h                               ; e8 62 d8                    ; 0xc3940
    jmp short 03950h                          ; eb 0b                       ; 0xc3943 vgabios.c:2551
    mov dx, word [bp+00eh]                    ; 8b 56 0e                    ; 0xc3945 vgabios.c:2553
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3948
    xor ah, ah                                ; 30 e4                       ; 0xc394b
    call 012a1h                               ; e8 51 d9                    ; 0xc394d
    jmp near 03d1eh                           ; e9 cb 03                    ; 0xc3950 vgabios.c:2554
    lea bx, [bp+00eh]                         ; 8d 5e 0e                    ; 0xc3953 vgabios.c:2556
    lea dx, [bp+010h]                         ; 8d 56 10                    ; 0xc3956
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3959
    xor ah, ah                                ; 30 e4                       ; 0xc395c
    call 00a97h                               ; e8 36 d1                    ; 0xc395e
    jmp short 03950h                          ; eb ed                       ; 0xc3961 vgabios.c:2557
    xor ax, ax                                ; 31 c0                       ; 0xc3963 vgabios.c:2563
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc3965
    mov word [bp+00ch], ax                    ; 89 46 0c                    ; 0xc3968 vgabios.c:2564
    mov word [bp+010h], ax                    ; 89 46 10                    ; 0xc396b vgabios.c:2565
    mov word [bp+00eh], ax                    ; 89 46 0e                    ; 0xc396e vgabios.c:2566
    jmp short 03950h                          ; eb dd                       ; 0xc3971 vgabios.c:2567
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3973 vgabios.c:2569
    xor ah, ah                                ; 30 e4                       ; 0xc3976
    call 0130dh                               ; e8 92 d9                    ; 0xc3978
    jmp short 03950h                          ; eb d3                       ; 0xc397b vgabios.c:2570
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc397d vgabios.c:2572
    push ax                                   ; 50                          ; 0xc3980
    mov ax, 000ffh                            ; b8 ff 00                    ; 0xc3981
    push ax                                   ; 50                          ; 0xc3984
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3985
    xor ah, ah                                ; 30 e4                       ; 0xc3988
    push ax                                   ; 50                          ; 0xc398a
    mov al, byte [bp+00fh]                    ; 8a 46 0f                    ; 0xc398b
    push ax                                   ; 50                          ; 0xc398e
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc398f
    mov cx, ax                                ; 89 c1                       ; 0xc3992
    mov bl, byte [bp+011h]                    ; 8a 5e 11                    ; 0xc3994
    xor bh, bh                                ; 30 ff                       ; 0xc3997
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3999
    mov dx, ax                                ; 89 c2                       ; 0xc399c
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc399e
    call 01c0ah                               ; e8 66 e2                    ; 0xc39a1
    jmp short 03950h                          ; eb aa                       ; 0xc39a4 vgabios.c:2573
    xor ax, ax                                ; 31 c0                       ; 0xc39a6 vgabios.c:2575
    push ax                                   ; 50                          ; 0xc39a8
    mov ax, 000ffh                            ; b8 ff 00                    ; 0xc39a9
    push ax                                   ; 50                          ; 0xc39ac
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc39ad
    xor ah, ah                                ; 30 e4                       ; 0xc39b0
    push ax                                   ; 50                          ; 0xc39b2
    mov al, byte [bp+00fh]                    ; 8a 46 0f                    ; 0xc39b3
    push ax                                   ; 50                          ; 0xc39b6
    mov al, byte [bp+010h]                    ; 8a 46 10                    ; 0xc39b7
    mov cx, ax                                ; 89 c1                       ; 0xc39ba
    mov al, byte [bp+011h]                    ; 8a 46 11                    ; 0xc39bc
    mov bx, ax                                ; 89 c3                       ; 0xc39bf
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc39c1
    mov dl, byte [bp+012h]                    ; 8a 56 12                    ; 0xc39c4
    mov si, dx                                ; 89 d6                       ; 0xc39c7
    mov dx, ax                                ; 89 c2                       ; 0xc39c9
    mov ax, si                                ; 89 f0                       ; 0xc39cb
    jmp short 039a1h                          ; eb d2                       ; 0xc39cd
    lea dx, [bp+012h]                         ; 8d 56 12                    ; 0xc39cf vgabios.c:2578
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc39d2
    xor ah, ah                                ; 30 e4                       ; 0xc39d5
    call 00ddbh                               ; e8 01 d4                    ; 0xc39d7
    jmp near 03d1eh                           ; e9 41 03                    ; 0xc39da vgabios.c:2579
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc39dd vgabios.c:2581
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc39e0
    xor ah, ah                                ; 30 e4                       ; 0xc39e3
    mov bx, ax                                ; 89 c3                       ; 0xc39e5
    mov dl, byte [bp+00dh]                    ; 8a 56 0d                    ; 0xc39e7
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc39ea
    call 02573h                               ; e8 83 eb                    ; 0xc39ed
    jmp near 03d1eh                           ; e9 2b 03                    ; 0xc39f0 vgabios.c:2582
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc39f3 vgabios.c:2584
    mov bl, byte [bp+00ch]                    ; 8a 5e 0c                    ; 0xc39f6
    xor bh, bh                                ; 30 ff                       ; 0xc39f9
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc39fb
    xor ah, ah                                ; 30 e4                       ; 0xc39fe
    mov dx, ax                                ; 89 c2                       ; 0xc3a00
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a02
    call 026eeh                               ; e8 e6 ec                    ; 0xc3a05
    jmp near 03d1eh                           ; e9 13 03                    ; 0xc3a08 vgabios.c:2585
    mov cx, word [bp+00eh]                    ; 8b 4e 0e                    ; 0xc3a0b vgabios.c:2587
    mov bx, word [bp+010h]                    ; 8b 5e 10                    ; 0xc3a0e
    mov dl, byte [bp+012h]                    ; 8a 56 12                    ; 0xc3a11
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3a14
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc3a17
    mov byte [bp-005h], dh                    ; 88 76 fb                    ; 0xc3a1a
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc3a1d
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc3a20
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc3a23
    xor ah, ah                                ; 30 e4                       ; 0xc3a26
    call 02861h                               ; e8 36 ee                    ; 0xc3a28
    jmp near 03d1eh                           ; e9 f0 02                    ; 0xc3a2b vgabios.c:2588
    lea cx, [bp+012h]                         ; 8d 4e 12                    ; 0xc3a2e vgabios.c:2590
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3a31
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3a34
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3a37
    xor ah, ah                                ; 30 e4                       ; 0xc3a3a
    call 00f99h                               ; e8 5a d5                    ; 0xc3a3c
    jmp near 03d1eh                           ; e9 dc 02                    ; 0xc3a3f vgabios.c:2591
    mov cx, strict word 00002h                ; b9 02 00                    ; 0xc3a42 vgabios.c:2599
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3a45
    xor ah, ah                                ; 30 e4                       ; 0xc3a48
    mov bx, ax                                ; 89 c3                       ; 0xc3a4a
    mov dx, 000ffh                            ; ba ff 00                    ; 0xc3a4c
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a4f
    call 029dbh                               ; e8 86 ef                    ; 0xc3a52
    jmp near 03d1eh                           ; e9 c6 02                    ; 0xc3a55 vgabios.c:2600
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3a58 vgabios.c:2603
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3a5b
    call 01106h                               ; e8 a5 d6                    ; 0xc3a5e
    jmp near 03d1eh                           ; e9 ba 02                    ; 0xc3a61 vgabios.c:2604
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3a64 vgabios.c:2606
    xor ah, ah                                ; 30 e4                       ; 0xc3a67
    cmp ax, strict word 00030h                ; 3d 30 00                    ; 0xc3a69
    jnbe short 03adch                         ; 77 6e                       ; 0xc3a6c
    push CS                                   ; 0e                          ; 0xc3a6e
    pop ES                                    ; 07                          ; 0xc3a6f
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc3a70
    mov di, 03889h                            ; bf 89 38                    ; 0xc3a73
    repne scasb                               ; f2 ae                       ; 0xc3a76
    sal cx, 1                                 ; d1 e1                       ; 0xc3a78
    mov di, cx                                ; 89 cf                       ; 0xc3a7a
    mov ax, word [cs:di+03898h]               ; 2e 8b 85 98 38              ; 0xc3a7c
    jmp ax                                    ; ff e0                       ; 0xc3a81
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3a83 vgabios.c:2610
    xor ah, ah                                ; 30 e4                       ; 0xc3a86
    push ax                                   ; 50                          ; 0xc3a88
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3a89
    push ax                                   ; 50                          ; 0xc3a8c
    push word [bp+00eh]                       ; ff 76 0e                    ; 0xc3a8d
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3a90
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc3a93
    mov bx, word [bp+008h]                    ; 8b 5e 08                    ; 0xc3a96
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3a99
    jmp short 03ab7h                          ; eb 19                       ; 0xc3a9c
    mov ax, strict word 0000eh                ; b8 0e 00                    ; 0xc3a9e vgabios.c:2614
    push ax                                   ; 50                          ; 0xc3aa1
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3aa2
    xor ah, ah                                ; 30 e4                       ; 0xc3aa5
    push ax                                   ; 50                          ; 0xc3aa7
    xor al, al                                ; 30 c0                       ; 0xc3aa8
    push ax                                   ; 50                          ; 0xc3aaa
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3aab
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3aae
    mov bx, 05d6ah                            ; bb 6a 5d                    ; 0xc3ab1
    mov dx, 0c000h                            ; ba 00 c0                    ; 0xc3ab4
    call 02e10h                               ; e8 56 f3                    ; 0xc3ab7
    jmp short 03adch                          ; eb 20                       ; 0xc3aba
    mov ax, strict word 00008h                ; b8 08 00                    ; 0xc3abc vgabios.c:2618
    push ax                                   ; 50                          ; 0xc3abf
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3ac0
    xor ah, ah                                ; 30 e4                       ; 0xc3ac3
    push ax                                   ; 50                          ; 0xc3ac5
    xor al, al                                ; 30 c0                       ; 0xc3ac6
    push ax                                   ; 50                          ; 0xc3ac8
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3ac9
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3acc
    mov bx, 0556ah                            ; bb 6a 55                    ; 0xc3acf
    jmp short 03ab4h                          ; eb e0                       ; 0xc3ad2
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3ad4 vgabios.c:2621
    xor ah, ah                                ; 30 e4                       ; 0xc3ad7
    call 02d78h                               ; e8 9c f2                    ; 0xc3ad9
    jmp near 03d1eh                           ; e9 3f 02                    ; 0xc3adc vgabios.c:2622
    mov ax, strict word 00010h                ; b8 10 00                    ; 0xc3adf vgabios.c:2625
    push ax                                   ; 50                          ; 0xc3ae2
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3ae3
    xor ah, ah                                ; 30 e4                       ; 0xc3ae6
    push ax                                   ; 50                          ; 0xc3ae8
    xor al, al                                ; 30 c0                       ; 0xc3ae9
    push ax                                   ; 50                          ; 0xc3aeb
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3aec
    mov cx, 00100h                            ; b9 00 01                    ; 0xc3aef
    mov bx, 06b6ah                            ; bb 6a 6b                    ; 0xc3af2
    jmp short 03ab4h                          ; eb bd                       ; 0xc3af5
    mov dx, word [bp+008h]                    ; 8b 56 08                    ; 0xc3af7 vgabios.c:2628
    mov ax, word [bp+016h]                    ; 8b 46 16                    ; 0xc3afa
    call 02e94h                               ; e8 94 f3                    ; 0xc3afd
    jmp short 03adch                          ; eb da                       ; 0xc3b00 vgabios.c:2629
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3b02 vgabios.c:2631
    xor ah, ah                                ; 30 e4                       ; 0xc3b05
    push ax                                   ; 50                          ; 0xc3b07
    mov cl, byte [bp+00ch]                    ; 8a 4e 0c                    ; 0xc3b08
    xor ch, ch                                ; 30 ed                       ; 0xc3b0b
    mov bx, word [bp+010h]                    ; 8b 5e 10                    ; 0xc3b0d
    mov dx, word [bp+008h]                    ; 8b 56 08                    ; 0xc3b10
    mov ax, word [bp+016h]                    ; 8b 46 16                    ; 0xc3b13
    call 02ef7h                               ; e8 de f3                    ; 0xc3b16
    jmp short 03adch                          ; eb c1                       ; 0xc3b19 vgabios.c:2632
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3b1b vgabios.c:2634
    xor ah, ah                                ; 30 e4                       ; 0xc3b1e
    mov dx, ax                                ; 89 c2                       ; 0xc3b20
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3b22
    call 02f14h                               ; e8 ec f3                    ; 0xc3b25
    jmp short 03adch                          ; eb b2                       ; 0xc3b28 vgabios.c:2635
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3b2a vgabios.c:2637
    xor ah, ah                                ; 30 e4                       ; 0xc3b2d
    mov dx, ax                                ; 89 c2                       ; 0xc3b2f
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3b31
    call 02f36h                               ; e8 ff f3                    ; 0xc3b34
    jmp short 03adch                          ; eb a3                       ; 0xc3b37 vgabios.c:2638
    mov dl, byte [bp+00eh]                    ; 8a 56 0e                    ; 0xc3b39 vgabios.c:2640
    mov al, byte [bp+00ch]                    ; 8a 46 0c                    ; 0xc3b3c
    xor ah, ah                                ; 30 e4                       ; 0xc3b3f
    call 02f58h                               ; e8 14 f4                    ; 0xc3b41
    jmp short 03adch                          ; eb 96                       ; 0xc3b44 vgabios.c:2641
    lea ax, [bp+00eh]                         ; 8d 46 0e                    ; 0xc3b46 vgabios.c:2643
    push ax                                   ; 50                          ; 0xc3b49
    lea cx, [bp+010h]                         ; 8d 4e 10                    ; 0xc3b4a
    lea bx, [bp+008h]                         ; 8d 5e 08                    ; 0xc3b4d
    lea dx, [bp+016h]                         ; 8d 56 16                    ; 0xc3b50
    mov al, byte [bp+00dh]                    ; 8a 46 0d                    ; 0xc3b53
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc3b56
    mov byte [bp-005h], 000h                  ; c6 46 fb 00                 ; 0xc3b59
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc3b5d
    call 00f16h                               ; e8 b3 d3                    ; 0xc3b60
    jmp near 03d1eh                           ; e9 b8 01                    ; 0xc3b63 vgabios.c:2651
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3b66 vgabios.c:2653
    xor ah, ah                                ; 30 e4                       ; 0xc3b69
    cmp ax, strict word 00034h                ; 3d 34 00                    ; 0xc3b6b
    jc short 03b7fh                           ; 72 0f                       ; 0xc3b6e
    jbe short 03baah                          ; 76 38                       ; 0xc3b70
    cmp ax, strict word 00036h                ; 3d 36 00                    ; 0xc3b72
    je short 03bd4h                           ; 74 5d                       ; 0xc3b75
    cmp ax, strict word 00035h                ; 3d 35 00                    ; 0xc3b77
    je short 03bd6h                           ; 74 5a                       ; 0xc3b7a
    jmp near 03d1eh                           ; e9 9f 01                    ; 0xc3b7c
    cmp ax, strict word 00030h                ; 3d 30 00                    ; 0xc3b7f
    je short 03b8eh                           ; 74 0a                       ; 0xc3b82
    cmp ax, strict word 00020h                ; 3d 20 00                    ; 0xc3b84
    jne short 03bd1h                          ; 75 48                       ; 0xc3b87
    call 02f7ah                               ; e8 ee f3                    ; 0xc3b89 vgabios.c:2656
    jmp short 03bd1h                          ; eb 43                       ; 0xc3b8c vgabios.c:2657
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3b8e vgabios.c:2659
    xor ah, ah                                ; 30 e4                       ; 0xc3b91
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3b93
    jnbe short 03bd1h                         ; 77 39                       ; 0xc3b96
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3b98 vgabios.c:2660
    call 02f7fh                               ; e8 e1 f3                    ; 0xc3b9b
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3b9e vgabios.c:2661
    xor al, al                                ; 30 c0                       ; 0xc3ba1
    or AL, strict byte 012h                   ; 0c 12                       ; 0xc3ba3
    mov word [bp+012h], ax                    ; 89 46 12                    ; 0xc3ba5
    jmp short 03bd1h                          ; eb 27                       ; 0xc3ba8 vgabios.c:2663
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3baa vgabios.c:2665
    xor ah, ah                                ; 30 e4                       ; 0xc3bad
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3baf
    jnc short 03bceh                          ; 73 1a                       ; 0xc3bb2
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3bb4 vgabios.c:45
    mov es, ax                                ; 8e c0                       ; 0xc3bb7
    mov bx, 00087h                            ; bb 87 00                    ; 0xc3bb9
    mov ah, byte [es:bx]                      ; 26 8a 27                    ; 0xc3bbc vgabios.c:47
    and ah, 0feh                              ; 80 e4 fe                    ; 0xc3bbf vgabios.c:48
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3bc2
    or al, ah                                 ; 08 e0                       ; 0xc3bc5
    mov si, bx                                ; 89 de                       ; 0xc3bc7 vgabios.c:50
    mov byte [es:si], al                      ; 26 88 04                    ; 0xc3bc9 vgabios.c:52
    jmp short 03b9eh                          ; eb d0                       ; 0xc3bcc
    mov byte [bp+012h], ah                    ; 88 66 12                    ; 0xc3bce vgabios.c:2671
    jmp near 03d1eh                           ; e9 4a 01                    ; 0xc3bd1 vgabios.c:2672
    jmp short 03be4h                          ; eb 0e                       ; 0xc3bd4
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3bd6 vgabios.c:2674
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3bd9
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3bdc
    call 02fb1h                               ; e8 cf f3                    ; 0xc3bdf
    jmp short 03b9eh                          ; eb ba                       ; 0xc3be2
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3be4 vgabios.c:2678
    call 02fb6h                               ; e8 cc f3                    ; 0xc3be7
    jmp short 03b9eh                          ; eb b2                       ; 0xc3bea
    push word [bp+008h]                       ; ff 76 08                    ; 0xc3bec vgabios.c:2688
    push word [bp+016h]                       ; ff 76 16                    ; 0xc3bef
    mov al, byte [bp+00eh]                    ; 8a 46 0e                    ; 0xc3bf2
    xor ah, ah                                ; 30 e4                       ; 0xc3bf5
    push ax                                   ; 50                          ; 0xc3bf7
    mov al, byte [bp+00fh]                    ; 8a 46 0f                    ; 0xc3bf8
    push ax                                   ; 50                          ; 0xc3bfb
    mov bl, byte [bp+00ch]                    ; 8a 5e 0c                    ; 0xc3bfc
    xor bh, bh                                ; 30 ff                       ; 0xc3bff
    mov dl, byte [bp+00dh]                    ; 8a 56 0d                    ; 0xc3c01
    mov al, byte [bp+012h]                    ; 8a 46 12                    ; 0xc3c04
    mov cx, word [bp+010h]                    ; 8b 4e 10                    ; 0xc3c07
    call 02fbbh                               ; e8 ae f3                    ; 0xc3c0a
    jmp short 03bd1h                          ; eb c2                       ; 0xc3c0d vgabios.c:2689
    mov bx, si                                ; 89 f3                       ; 0xc3c0f vgabios.c:2691
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c11
    mov ax, word [bp+00ch]                    ; 8b 46 0c                    ; 0xc3c14
    call 0304ah                               ; e8 30 f4                    ; 0xc3c17
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3c1a vgabios.c:2692
    xor al, al                                ; 30 c0                       ; 0xc3c1d
    or AL, strict byte 01bh                   ; 0c 1b                       ; 0xc3c1f
    jmp short 03ba5h                          ; eb 82                       ; 0xc3c21
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3c23 vgabios.c:2695
    xor ah, ah                                ; 30 e4                       ; 0xc3c26
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc3c28
    je short 03c4fh                           ; 74 22                       ; 0xc3c2b
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc3c2d
    je short 03c41h                           ; 74 0f                       ; 0xc3c30
    test ax, ax                               ; 85 c0                       ; 0xc3c32
    jne short 03c5bh                          ; 75 25                       ; 0xc3c34
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3c36 vgabios.c:2698
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3c39
    call 0325fh                               ; e8 20 f6                    ; 0xc3c3c
    jmp short 03c5bh                          ; eb 1a                       ; 0xc3c3f vgabios.c:2699
    mov bx, word [bp+00ch]                    ; 8b 5e 0c                    ; 0xc3c41 vgabios.c:2701
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c44
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3c47
    call 0327ah                               ; e8 2d f6                    ; 0xc3c4a
    jmp short 03c5bh                          ; eb 0c                       ; 0xc3c4d vgabios.c:2702
    mov bx, word [bp+00ch]                    ; 8b 5e 0c                    ; 0xc3c4f vgabios.c:2704
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c52
    mov ax, word [bp+010h]                    ; 8b 46 10                    ; 0xc3c55
    call 03552h                               ; e8 f7 f8                    ; 0xc3c58
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3c5b vgabios.c:2711
    xor al, al                                ; 30 c0                       ; 0xc3c5e
    or AL, strict byte 01ch                   ; 0c 1c                       ; 0xc3c60
    jmp near 03ba5h                           ; e9 40 ff                    ; 0xc3c62
    call 00801h                               ; e8 99 cb                    ; 0xc3c65 vgabios.c:2716
    test ax, ax                               ; 85 c0                       ; 0xc3c68
    je short 03ce0h                           ; 74 74                       ; 0xc3c6a
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3c6c vgabios.c:2717
    xor ah, ah                                ; 30 e4                       ; 0xc3c6f
    cmp ax, strict word 0000ah                ; 3d 0a 00                    ; 0xc3c71
    jnbe short 03ce2h                         ; 77 6c                       ; 0xc3c74
    push CS                                   ; 0e                          ; 0xc3c76
    pop ES                                    ; 07                          ; 0xc3c77
    mov cx, strict word 00008h                ; b9 08 00                    ; 0xc3c78
    mov di, 038b8h                            ; bf b8 38                    ; 0xc3c7b
    repne scasb                               ; f2 ae                       ; 0xc3c7e
    sal cx, 1                                 ; d1 e1                       ; 0xc3c80
    mov di, cx                                ; 89 cf                       ; 0xc3c82
    mov ax, word [cs:di+038bfh]               ; 2e 8b 85 bf 38              ; 0xc3c84
    jmp ax                                    ; ff e0                       ; 0xc3c89
    mov bx, si                                ; 89 f3                       ; 0xc3c8b vgabios.c:2720
    mov dx, word [bp+016h]                    ; 8b 56 16                    ; 0xc3c8d
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3c90
    call 03eefh                               ; e8 59 02                    ; 0xc3c93
    jmp near 03d1eh                           ; e9 85 00                    ; 0xc3c96 vgabios.c:2721
    mov cx, si                                ; 89 f1                       ; 0xc3c99 vgabios.c:2723
    mov bx, word [bp+016h]                    ; 8b 5e 16                    ; 0xc3c9b
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3c9e
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3ca1
    call 0401ah                               ; e8 73 03                    ; 0xc3ca4
    jmp near 03d1eh                           ; e9 74 00                    ; 0xc3ca7 vgabios.c:2724
    mov cx, si                                ; 89 f1                       ; 0xc3caa vgabios.c:2726
    mov bx, word [bp+016h]                    ; 8b 5e 16                    ; 0xc3cac
    mov dx, word [bp+00ch]                    ; 8b 56 0c                    ; 0xc3caf
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3cb2
    call 040b9h                               ; e8 01 04                    ; 0xc3cb5
    jmp short 03d1eh                          ; eb 64                       ; 0xc3cb8 vgabios.c:2727
    lea ax, [bp+00ch]                         ; 8d 46 0c                    ; 0xc3cba vgabios.c:2729
    push ax                                   ; 50                          ; 0xc3cbd
    mov cx, word [bp+016h]                    ; 8b 4e 16                    ; 0xc3cbe
    mov bx, word [bp+00eh]                    ; 8b 5e 0e                    ; 0xc3cc1
    mov dx, word [bp+010h]                    ; 8b 56 10                    ; 0xc3cc4
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3cc7
    call 0428ch                               ; e8 bf 05                    ; 0xc3cca
    jmp short 03d1eh                          ; eb 4f                       ; 0xc3ccd vgabios.c:2730
    lea cx, [bp+00eh]                         ; 8d 4e 0e                    ; 0xc3ccf vgabios.c:2732
    lea bx, [bp+010h]                         ; 8d 5e 10                    ; 0xc3cd2
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3cd5
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3cd8
    call 04319h                               ; e8 3b 06                    ; 0xc3cdb
    jmp short 03d1eh                          ; eb 3e                       ; 0xc3cde vgabios.c:2733
    jmp short 03ce9h                          ; eb 07                       ; 0xc3ce0
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3ce2 vgabios.c:2755
    jmp short 03d1eh                          ; eb 35                       ; 0xc3ce7 vgabios.c:2758
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3ce9 vgabios.c:2760
    jmp short 03d1eh                          ; eb 2e                       ; 0xc3cee vgabios.c:2762
    call 00801h                               ; e8 0e cb                    ; 0xc3cf0 vgabios.c:2764
    test ax, ax                               ; 85 c0                       ; 0xc3cf3
    je short 03d19h                           ; 74 22                       ; 0xc3cf5
    mov ax, word [bp+012h]                    ; 8b 46 12                    ; 0xc3cf7 vgabios.c:2765
    xor ah, ah                                ; 30 e4                       ; 0xc3cfa
    cmp ax, strict word 00042h                ; 3d 42 00                    ; 0xc3cfc
    jne short 03d12h                          ; 75 11                       ; 0xc3cff
    lea cx, [bp+00eh]                         ; 8d 4e 0e                    ; 0xc3d01 vgabios.c:2768
    lea bx, [bp+010h]                         ; 8d 5e 10                    ; 0xc3d04
    lea dx, [bp+00ch]                         ; 8d 56 0c                    ; 0xc3d07
    lea ax, [bp+012h]                         ; 8d 46 12                    ; 0xc3d0a
    call 043fbh                               ; e8 eb 06                    ; 0xc3d0d
    jmp short 03d1eh                          ; eb 0c                       ; 0xc3d10 vgabios.c:2769
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3d12 vgabios.c:2771
    jmp short 03d1eh                          ; eb 05                       ; 0xc3d17 vgabios.c:2774
    mov word [bp+012h], 00100h                ; c7 46 12 00 01              ; 0xc3d19 vgabios.c:2776
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d1e vgabios.c:2786
    pop di                                    ; 5f                          ; 0xc3d21
    pop si                                    ; 5e                          ; 0xc3d22
    pop bp                                    ; 5d                          ; 0xc3d23
    retn                                      ; c3                          ; 0xc3d24
  ; disGetNextSymbol 0xc3d25 LB 0x7cd -> off=0x0 cb=000000000000001f uValue=00000000000c3d25 'dispi_set_xres'
dispi_set_xres:                              ; 0xc3d25 LB 0x1f
    push bp                                   ; 55                          ; 0xc3d25 vbe.c:100
    mov bp, sp                                ; 89 e5                       ; 0xc3d26
    push bx                                   ; 53                          ; 0xc3d28
    push dx                                   ; 52                          ; 0xc3d29
    mov bx, ax                                ; 89 c3                       ; 0xc3d2a
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc3d2c vbe.c:105
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d2f
    call 005a0h                               ; e8 6b c8                    ; 0xc3d32
    mov ax, bx                                ; 89 d8                       ; 0xc3d35 vbe.c:106
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d37
    call 005a0h                               ; e8 63 c8                    ; 0xc3d3a
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d3d vbe.c:107
    pop dx                                    ; 5a                          ; 0xc3d40
    pop bx                                    ; 5b                          ; 0xc3d41
    pop bp                                    ; 5d                          ; 0xc3d42
    retn                                      ; c3                          ; 0xc3d43
  ; disGetNextSymbol 0xc3d44 LB 0x7ae -> off=0x0 cb=000000000000001f uValue=00000000000c3d44 'dispi_set_yres'
dispi_set_yres:                              ; 0xc3d44 LB 0x1f
    push bp                                   ; 55                          ; 0xc3d44 vbe.c:109
    mov bp, sp                                ; 89 e5                       ; 0xc3d45
    push bx                                   ; 53                          ; 0xc3d47
    push dx                                   ; 52                          ; 0xc3d48
    mov bx, ax                                ; 89 c3                       ; 0xc3d49
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3d4b vbe.c:114
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d4e
    call 005a0h                               ; e8 4c c8                    ; 0xc3d51
    mov ax, bx                                ; 89 d8                       ; 0xc3d54 vbe.c:115
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d56
    call 005a0h                               ; e8 44 c8                    ; 0xc3d59
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d5c vbe.c:116
    pop dx                                    ; 5a                          ; 0xc3d5f
    pop bx                                    ; 5b                          ; 0xc3d60
    pop bp                                    ; 5d                          ; 0xc3d61
    retn                                      ; c3                          ; 0xc3d62
  ; disGetNextSymbol 0xc3d63 LB 0x78f -> off=0x0 cb=0000000000000019 uValue=00000000000c3d63 'dispi_get_yres'
dispi_get_yres:                              ; 0xc3d63 LB 0x19
    push bp                                   ; 55                          ; 0xc3d63 vbe.c:118
    mov bp, sp                                ; 89 e5                       ; 0xc3d64
    push dx                                   ; 52                          ; 0xc3d66
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc3d67 vbe.c:120
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d6a
    call 005a0h                               ; e8 30 c8                    ; 0xc3d6d
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d70 vbe.c:121
    call 005a7h                               ; e8 31 c8                    ; 0xc3d73
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3d76 vbe.c:122
    pop dx                                    ; 5a                          ; 0xc3d79
    pop bp                                    ; 5d                          ; 0xc3d7a
    retn                                      ; c3                          ; 0xc3d7b
  ; disGetNextSymbol 0xc3d7c LB 0x776 -> off=0x0 cb=000000000000001f uValue=00000000000c3d7c 'dispi_set_bpp'
dispi_set_bpp:                               ; 0xc3d7c LB 0x1f
    push bp                                   ; 55                          ; 0xc3d7c vbe.c:124
    mov bp, sp                                ; 89 e5                       ; 0xc3d7d
    push bx                                   ; 53                          ; 0xc3d7f
    push dx                                   ; 52                          ; 0xc3d80
    mov bx, ax                                ; 89 c3                       ; 0xc3d81
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3d83 vbe.c:129
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3d86
    call 005a0h                               ; e8 14 c8                    ; 0xc3d89
    mov ax, bx                                ; 89 d8                       ; 0xc3d8c vbe.c:130
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3d8e
    call 005a0h                               ; e8 0c c8                    ; 0xc3d91
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3d94 vbe.c:131
    pop dx                                    ; 5a                          ; 0xc3d97
    pop bx                                    ; 5b                          ; 0xc3d98
    pop bp                                    ; 5d                          ; 0xc3d99
    retn                                      ; c3                          ; 0xc3d9a
  ; disGetNextSymbol 0xc3d9b LB 0x757 -> off=0x0 cb=0000000000000019 uValue=00000000000c3d9b 'dispi_get_bpp'
dispi_get_bpp:                               ; 0xc3d9b LB 0x19
    push bp                                   ; 55                          ; 0xc3d9b vbe.c:133
    mov bp, sp                                ; 89 e5                       ; 0xc3d9c
    push dx                                   ; 52                          ; 0xc3d9e
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc3d9f vbe.c:135
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3da2
    call 005a0h                               ; e8 f8 c7                    ; 0xc3da5
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3da8 vbe.c:136
    call 005a7h                               ; e8 f9 c7                    ; 0xc3dab
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3dae vbe.c:137
    pop dx                                    ; 5a                          ; 0xc3db1
    pop bp                                    ; 5d                          ; 0xc3db2
    retn                                      ; c3                          ; 0xc3db3
  ; disGetNextSymbol 0xc3db4 LB 0x73e -> off=0x0 cb=000000000000001f uValue=00000000000c3db4 'dispi_set_virt_width'
dispi_set_virt_width:                        ; 0xc3db4 LB 0x1f
    push bp                                   ; 55                          ; 0xc3db4 vbe.c:139
    mov bp, sp                                ; 89 e5                       ; 0xc3db5
    push bx                                   ; 53                          ; 0xc3db7
    push dx                                   ; 52                          ; 0xc3db8
    mov bx, ax                                ; 89 c3                       ; 0xc3db9
    mov ax, strict word 00006h                ; b8 06 00                    ; 0xc3dbb vbe.c:144
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3dbe
    call 005a0h                               ; e8 dc c7                    ; 0xc3dc1
    mov ax, bx                                ; 89 d8                       ; 0xc3dc4 vbe.c:145
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3dc6
    call 005a0h                               ; e8 d4 c7                    ; 0xc3dc9
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3dcc vbe.c:146
    pop dx                                    ; 5a                          ; 0xc3dcf
    pop bx                                    ; 5b                          ; 0xc3dd0
    pop bp                                    ; 5d                          ; 0xc3dd1
    retn                                      ; c3                          ; 0xc3dd2
  ; disGetNextSymbol 0xc3dd3 LB 0x71f -> off=0x0 cb=0000000000000019 uValue=00000000000c3dd3 'dispi_get_virt_width'
dispi_get_virt_width:                        ; 0xc3dd3 LB 0x19
    push bp                                   ; 55                          ; 0xc3dd3 vbe.c:148
    mov bp, sp                                ; 89 e5                       ; 0xc3dd4
    push dx                                   ; 52                          ; 0xc3dd6
    mov ax, strict word 00006h                ; b8 06 00                    ; 0xc3dd7 vbe.c:150
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3dda
    call 005a0h                               ; e8 c0 c7                    ; 0xc3ddd
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3de0 vbe.c:151
    call 005a7h                               ; e8 c1 c7                    ; 0xc3de3
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3de6 vbe.c:152
    pop dx                                    ; 5a                          ; 0xc3de9
    pop bp                                    ; 5d                          ; 0xc3dea
    retn                                      ; c3                          ; 0xc3deb
  ; disGetNextSymbol 0xc3dec LB 0x706 -> off=0x0 cb=0000000000000019 uValue=00000000000c3dec 'dispi_get_virt_height'
dispi_get_virt_height:                       ; 0xc3dec LB 0x19
    push bp                                   ; 55                          ; 0xc3dec vbe.c:154
    mov bp, sp                                ; 89 e5                       ; 0xc3ded
    push dx                                   ; 52                          ; 0xc3def
    mov ax, strict word 00007h                ; b8 07 00                    ; 0xc3df0 vbe.c:156
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3df3
    call 005a0h                               ; e8 a7 c7                    ; 0xc3df6
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3df9 vbe.c:157
    call 005a7h                               ; e8 a8 c7                    ; 0xc3dfc
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3dff vbe.c:158
    pop dx                                    ; 5a                          ; 0xc3e02
    pop bp                                    ; 5d                          ; 0xc3e03
    retn                                      ; c3                          ; 0xc3e04
  ; disGetNextSymbol 0xc3e05 LB 0x6ed -> off=0x0 cb=0000000000000012 uValue=00000000000c3e05 'in_word'
in_word:                                     ; 0xc3e05 LB 0x12
    push bp                                   ; 55                          ; 0xc3e05 vbe.c:160
    mov bp, sp                                ; 89 e5                       ; 0xc3e06
    push bx                                   ; 53                          ; 0xc3e08
    mov bx, ax                                ; 89 c3                       ; 0xc3e09
    mov ax, dx                                ; 89 d0                       ; 0xc3e0b
    mov dx, bx                                ; 89 da                       ; 0xc3e0d vbe.c:162
    out DX, ax                                ; ef                          ; 0xc3e0f
    in ax, DX                                 ; ed                          ; 0xc3e10 vbe.c:163
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3e11 vbe.c:164
    pop bx                                    ; 5b                          ; 0xc3e14
    pop bp                                    ; 5d                          ; 0xc3e15
    retn                                      ; c3                          ; 0xc3e16
  ; disGetNextSymbol 0xc3e17 LB 0x6db -> off=0x0 cb=0000000000000014 uValue=00000000000c3e17 'in_byte'
in_byte:                                     ; 0xc3e17 LB 0x14
    push bp                                   ; 55                          ; 0xc3e17 vbe.c:166
    mov bp, sp                                ; 89 e5                       ; 0xc3e18
    push bx                                   ; 53                          ; 0xc3e1a
    mov bx, ax                                ; 89 c3                       ; 0xc3e1b
    mov ax, dx                                ; 89 d0                       ; 0xc3e1d
    mov dx, bx                                ; 89 da                       ; 0xc3e1f vbe.c:168
    out DX, ax                                ; ef                          ; 0xc3e21
    in AL, DX                                 ; ec                          ; 0xc3e22 vbe.c:169
    db  02ah, 0e4h
    ; sub ah, ah                                ; 2a e4                     ; 0xc3e23
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3e25 vbe.c:170
    pop bx                                    ; 5b                          ; 0xc3e28
    pop bp                                    ; 5d                          ; 0xc3e29
    retn                                      ; c3                          ; 0xc3e2a
  ; disGetNextSymbol 0xc3e2b LB 0x6c7 -> off=0x0 cb=0000000000000014 uValue=00000000000c3e2b 'dispi_get_id'
dispi_get_id:                                ; 0xc3e2b LB 0x14
    push bp                                   ; 55                          ; 0xc3e2b vbe.c:173
    mov bp, sp                                ; 89 e5                       ; 0xc3e2c
    push dx                                   ; 52                          ; 0xc3e2e
    xor ax, ax                                ; 31 c0                       ; 0xc3e2f vbe.c:175
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3e31
    out DX, ax                                ; ef                          ; 0xc3e34
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3e35 vbe.c:176
    in ax, DX                                 ; ed                          ; 0xc3e38
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3e39 vbe.c:177
    pop dx                                    ; 5a                          ; 0xc3e3c
    pop bp                                    ; 5d                          ; 0xc3e3d
    retn                                      ; c3                          ; 0xc3e3e
  ; disGetNextSymbol 0xc3e3f LB 0x6b3 -> off=0x0 cb=000000000000001a uValue=00000000000c3e3f 'dispi_set_id'
dispi_set_id:                                ; 0xc3e3f LB 0x1a
    push bp                                   ; 55                          ; 0xc3e3f vbe.c:179
    mov bp, sp                                ; 89 e5                       ; 0xc3e40
    push bx                                   ; 53                          ; 0xc3e42
    push dx                                   ; 52                          ; 0xc3e43
    mov bx, ax                                ; 89 c3                       ; 0xc3e44
    xor ax, ax                                ; 31 c0                       ; 0xc3e46 vbe.c:181
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3e48
    out DX, ax                                ; ef                          ; 0xc3e4b
    mov ax, bx                                ; 89 d8                       ; 0xc3e4c vbe.c:182
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3e4e
    out DX, ax                                ; ef                          ; 0xc3e51
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc3e52 vbe.c:183
    pop dx                                    ; 5a                          ; 0xc3e55
    pop bx                                    ; 5b                          ; 0xc3e56
    pop bp                                    ; 5d                          ; 0xc3e57
    retn                                      ; c3                          ; 0xc3e58
  ; disGetNextSymbol 0xc3e59 LB 0x699 -> off=0x0 cb=000000000000002a uValue=00000000000c3e59 'vbe_init'
vbe_init:                                    ; 0xc3e59 LB 0x2a
    push bp                                   ; 55                          ; 0xc3e59 vbe.c:188
    mov bp, sp                                ; 89 e5                       ; 0xc3e5a
    push bx                                   ; 53                          ; 0xc3e5c
    mov ax, 0b0c0h                            ; b8 c0 b0                    ; 0xc3e5d vbe.c:190
    call 03e3fh                               ; e8 dc ff                    ; 0xc3e60
    call 03e2bh                               ; e8 c5 ff                    ; 0xc3e63 vbe.c:191
    cmp ax, 0b0c0h                            ; 3d c0 b0                    ; 0xc3e66
    jne short 03e7dh                          ; 75 12                       ; 0xc3e69
    mov bx, 000b9h                            ; bb b9 00                    ; 0xc3e6b vbe.c:52
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc3e6e
    mov es, ax                                ; 8e c0                       ; 0xc3e71
    mov byte [es:bx], 001h                    ; 26 c6 07 01                 ; 0xc3e73
    mov ax, 0b0c4h                            ; b8 c4 b0                    ; 0xc3e77 vbe.c:194
    call 03e3fh                               ; e8 c2 ff                    ; 0xc3e7a
    lea sp, [bp-002h]                         ; 8d 66 fe                    ; 0xc3e7d vbe.c:199
    pop bx                                    ; 5b                          ; 0xc3e80
    pop bp                                    ; 5d                          ; 0xc3e81
    retn                                      ; c3                          ; 0xc3e82
  ; disGetNextSymbol 0xc3e83 LB 0x66f -> off=0x0 cb=000000000000006c uValue=00000000000c3e83 'mode_info_find_mode'
mode_info_find_mode:                         ; 0xc3e83 LB 0x6c
    push bp                                   ; 55                          ; 0xc3e83 vbe.c:202
    mov bp, sp                                ; 89 e5                       ; 0xc3e84
    push bx                                   ; 53                          ; 0xc3e86
    push cx                                   ; 51                          ; 0xc3e87
    push si                                   ; 56                          ; 0xc3e88
    push di                                   ; 57                          ; 0xc3e89
    mov di, ax                                ; 89 c7                       ; 0xc3e8a
    mov si, dx                                ; 89 d6                       ; 0xc3e8c
    xor dx, dx                                ; 31 d2                       ; 0xc3e8e vbe.c:208
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3e90
    call 03e05h                               ; e8 6f ff                    ; 0xc3e93
    cmp ax, 077cch                            ; 3d cc 77                    ; 0xc3e96 vbe.c:209
    jne short 03ee4h                          ; 75 49                       ; 0xc3e99
    test si, si                               ; 85 f6                       ; 0xc3e9b vbe.c:213
    je short 03eb2h                           ; 74 13                       ; 0xc3e9d
    mov ax, strict word 0000bh                ; b8 0b 00                    ; 0xc3e9f vbe.c:220
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc3ea2
    call 005a0h                               ; e8 f8 c6                    ; 0xc3ea5
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc3ea8 vbe.c:221
    call 005a7h                               ; e8 f9 c6                    ; 0xc3eab
    test ax, ax                               ; 85 c0                       ; 0xc3eae vbe.c:222
    je short 03ee6h                           ; 74 34                       ; 0xc3eb0
    mov bx, strict word 00004h                ; bb 04 00                    ; 0xc3eb2 vbe.c:226
    mov dx, bx                                ; 89 da                       ; 0xc3eb5 vbe.c:232
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3eb7
    call 03e05h                               ; e8 48 ff                    ; 0xc3eba
    mov cx, ax                                ; 89 c1                       ; 0xc3ebd
    cmp cx, strict byte 0ffffh                ; 83 f9 ff                    ; 0xc3ebf vbe.c:233
    je short 03ee4h                           ; 74 20                       ; 0xc3ec2
    lea dx, [bx+002h]                         ; 8d 57 02                    ; 0xc3ec4 vbe.c:235
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3ec7
    call 03e05h                               ; e8 38 ff                    ; 0xc3eca
    lea dx, [bx+044h]                         ; 8d 57 44                    ; 0xc3ecd
    cmp cx, di                                ; 39 f9                       ; 0xc3ed0 vbe.c:237
    jne short 03ee0h                          ; 75 0c                       ; 0xc3ed2
    test si, si                               ; 85 f6                       ; 0xc3ed4 vbe.c:239
    jne short 03edch                          ; 75 04                       ; 0xc3ed6
    mov ax, bx                                ; 89 d8                       ; 0xc3ed8 vbe.c:240
    jmp short 03ee6h                          ; eb 0a                       ; 0xc3eda
    test AL, strict byte 080h                 ; a8 80                       ; 0xc3edc vbe.c:241
    jne short 03ed8h                          ; 75 f8                       ; 0xc3ede
    mov bx, dx                                ; 89 d3                       ; 0xc3ee0 vbe.c:244
    jmp short 03eb7h                          ; eb d3                       ; 0xc3ee2 vbe.c:249
    xor ax, ax                                ; 31 c0                       ; 0xc3ee4 vbe.c:252
    lea sp, [bp-008h]                         ; 8d 66 f8                    ; 0xc3ee6 vbe.c:253
    pop di                                    ; 5f                          ; 0xc3ee9
    pop si                                    ; 5e                          ; 0xc3eea
    pop cx                                    ; 59                          ; 0xc3eeb
    pop bx                                    ; 5b                          ; 0xc3eec
    pop bp                                    ; 5d                          ; 0xc3eed
    retn                                      ; c3                          ; 0xc3eee
  ; disGetNextSymbol 0xc3eef LB 0x603 -> off=0x0 cb=000000000000012b uValue=00000000000c3eef 'vbe_biosfn_return_controller_information'
vbe_biosfn_return_controller_information: ; 0xc3eef LB 0x12b
    push bp                                   ; 55                          ; 0xc3eef vbe.c:284
    mov bp, sp                                ; 89 e5                       ; 0xc3ef0
    push cx                                   ; 51                          ; 0xc3ef2
    push si                                   ; 56                          ; 0xc3ef3
    push di                                   ; 57                          ; 0xc3ef4
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc3ef5
    mov si, ax                                ; 89 c6                       ; 0xc3ef8
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc3efa
    mov di, bx                                ; 89 df                       ; 0xc3efd
    mov word [bp-00ch], strict word 00022h    ; c7 46 f4 22 00              ; 0xc3eff vbe.c:289
    call 005eah                               ; e8 e3 c6                    ; 0xc3f04 vbe.c:292
    mov word [bp-010h], ax                    ; 89 46 f0                    ; 0xc3f07
    mov bx, di                                ; 89 fb                       ; 0xc3f0a vbe.c:295
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3f0c
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc3f0f
    xor dx, dx                                ; 31 d2                       ; 0xc3f12 vbe.c:298
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3f14
    call 03e05h                               ; e8 eb fe                    ; 0xc3f17
    cmp ax, 077cch                            ; 3d cc 77                    ; 0xc3f1a vbe.c:299
    je short 03f29h                           ; 74 0a                       ; 0xc3f1d
    push SS                                   ; 16                          ; 0xc3f1f vbe.c:301
    pop ES                                    ; 07                          ; 0xc3f20
    mov word [es:si], 00100h                  ; 26 c7 04 00 01              ; 0xc3f21
    jmp near 04012h                           ; e9 e9 00                    ; 0xc3f26 vbe.c:305
    mov cx, strict word 00004h                ; b9 04 00                    ; 0xc3f29 vbe.c:307
    mov word [bp-00eh], strict word 00000h    ; c7 46 f2 00 00              ; 0xc3f2c vbe.c:314
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3f31 vbe.c:322
    cmp word [es:bx+002h], 03245h             ; 26 81 7f 02 45 32           ; 0xc3f34
    jne short 03f43h                          ; 75 07                       ; 0xc3f3a
    cmp word [es:bx], 04256h                  ; 26 81 3f 56 42              ; 0xc3f3c
    je short 03f52h                           ; 74 0f                       ; 0xc3f41
    cmp word [es:bx+002h], 04153h             ; 26 81 7f 02 53 41           ; 0xc3f43
    jne short 03f57h                          ; 75 0c                       ; 0xc3f49
    cmp word [es:bx], 04556h                  ; 26 81 3f 56 45              ; 0xc3f4b
    jne short 03f57h                          ; 75 05                       ; 0xc3f50
    mov word [bp-00eh], strict word 00001h    ; c7 46 f2 01 00              ; 0xc3f52 vbe.c:324
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3f57 vbe.c:332
    mov word [es:bx], 04556h                  ; 26 c7 07 56 45              ; 0xc3f5a
    mov word [es:bx+002h], 04153h             ; 26 c7 47 02 53 41           ; 0xc3f5f vbe.c:334
    mov word [es:bx+004h], 00200h             ; 26 c7 47 04 00 02           ; 0xc3f65 vbe.c:338
    mov word [es:bx+006h], 07e00h             ; 26 c7 47 06 00 7e           ; 0xc3f6b vbe.c:341
    mov [es:bx+008h], ds                      ; 26 8c 5f 08                 ; 0xc3f71
    mov word [es:bx+00ah], strict word 00001h ; 26 c7 47 0a 01 00           ; 0xc3f75 vbe.c:344
    mov word [es:bx+00ch], strict word 00000h ; 26 c7 47 0c 00 00           ; 0xc3f7b vbe.c:346
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc3f81 vbe.c:350
    mov word [es:bx+010h], ax                 ; 26 89 47 10                 ; 0xc3f84
    lea ax, [di+022h]                         ; 8d 45 22                    ; 0xc3f88 vbe.c:351
    mov word [es:bx+00eh], ax                 ; 26 89 47 0e                 ; 0xc3f8b
    mov dx, strict word 0ffffh                ; ba ff ff                    ; 0xc3f8f vbe.c:354
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3f92
    call 03e05h                               ; e8 6d fe                    ; 0xc3f95
    mov es, [bp-008h]                         ; 8e 46 f8                    ; 0xc3f98
    mov word [es:bx+012h], ax                 ; 26 89 47 12                 ; 0xc3f9b
    cmp word [bp-00eh], strict byte 00000h    ; 83 7e f2 00                 ; 0xc3f9f vbe.c:356
    je short 03fc9h                           ; 74 24                       ; 0xc3fa3
    mov word [es:bx+014h], strict word 00003h ; 26 c7 47 14 03 00           ; 0xc3fa5 vbe.c:359
    mov word [es:bx+016h], 07e15h             ; 26 c7 47 16 15 7e           ; 0xc3fab vbe.c:360
    mov [es:bx+018h], ds                      ; 26 8c 5f 18                 ; 0xc3fb1
    mov word [es:bx+01ah], 07e32h             ; 26 c7 47 1a 32 7e           ; 0xc3fb5 vbe.c:361
    mov [es:bx+01ch], ds                      ; 26 8c 5f 1c                 ; 0xc3fbb
    mov word [es:bx+01eh], 07e50h             ; 26 c7 47 1e 50 7e           ; 0xc3fbf vbe.c:362
    mov [es:bx+020h], ds                      ; 26 8c 5f 20                 ; 0xc3fc5
    mov dx, cx                                ; 89 ca                       ; 0xc3fc9 vbe.c:369
    add dx, strict byte 0001bh                ; 83 c2 1b                    ; 0xc3fcb
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3fce
    call 03e17h                               ; e8 43 fe                    ; 0xc3fd1
    xor ah, ah                                ; 30 e4                       ; 0xc3fd4 vbe.c:370
    cmp ax, word [bp-010h]                    ; 3b 46 f0                    ; 0xc3fd6
    jnbe short 03ff2h                         ; 77 17                       ; 0xc3fd9
    mov dx, cx                                ; 89 ca                       ; 0xc3fdb vbe.c:372
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3fdd
    call 03e05h                               ; e8 22 fe                    ; 0xc3fe0
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc3fe3 vbe.c:376
    add bx, di                                ; 01 fb                       ; 0xc3fe6
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc3fe8 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc3feb
    add word [bp-00ch], strict byte 00002h    ; 83 46 f4 02                 ; 0xc3fee vbe.c:378
    add cx, strict byte 00044h                ; 83 c1 44                    ; 0xc3ff2 vbe.c:380
    mov dx, cx                                ; 89 ca                       ; 0xc3ff5 vbe.c:381
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc3ff7
    call 03e05h                               ; e8 08 fe                    ; 0xc3ffa
    cmp ax, strict word 0ffffh                ; 3d ff ff                    ; 0xc3ffd vbe.c:382
    jne short 03fc9h                          ; 75 c7                       ; 0xc4000
    add di, word [bp-00ch]                    ; 03 7e f4                    ; 0xc4002 vbe.c:385
    mov es, [bp-00ah]                         ; 8e 46 f6                    ; 0xc4005 vbe.c:62
    mov word [es:di], ax                      ; 26 89 05                    ; 0xc4008
    push SS                                   ; 16                          ; 0xc400b vbe.c:386
    pop ES                                    ; 07                          ; 0xc400c
    mov word [es:si], strict word 0004fh      ; 26 c7 04 4f 00              ; 0xc400d
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc4012 vbe.c:387
    pop di                                    ; 5f                          ; 0xc4015
    pop si                                    ; 5e                          ; 0xc4016
    pop cx                                    ; 59                          ; 0xc4017
    pop bp                                    ; 5d                          ; 0xc4018
    retn                                      ; c3                          ; 0xc4019
  ; disGetNextSymbol 0xc401a LB 0x4d8 -> off=0x0 cb=000000000000009f uValue=00000000000c401a 'vbe_biosfn_return_mode_information'
vbe_biosfn_return_mode_information:          ; 0xc401a LB 0x9f
    push bp                                   ; 55                          ; 0xc401a vbe.c:399
    mov bp, sp                                ; 89 e5                       ; 0xc401b
    push si                                   ; 56                          ; 0xc401d
    push di                                   ; 57                          ; 0xc401e
    push ax                                   ; 50                          ; 0xc401f
    push ax                                   ; 50                          ; 0xc4020
    mov ax, dx                                ; 89 d0                       ; 0xc4021
    mov si, bx                                ; 89 de                       ; 0xc4023
    mov bx, cx                                ; 89 cb                       ; 0xc4025
    test dh, 040h                             ; f6 c6 40                    ; 0xc4027 vbe.c:410
    je short 04031h                           ; 74 05                       ; 0xc402a
    mov dx, strict word 00001h                ; ba 01 00                    ; 0xc402c
    jmp short 04033h                          ; eb 02                       ; 0xc402f
    xor dx, dx                                ; 31 d2                       ; 0xc4031
    and ah, 001h                              ; 80 e4 01                    ; 0xc4033 vbe.c:411
    call 03e83h                               ; e8 4a fe                    ; 0xc4036 vbe.c:413
    mov word [bp-006h], ax                    ; 89 46 fa                    ; 0xc4039
    test ax, ax                               ; 85 c0                       ; 0xc403c vbe.c:415
    je short 040a7h                           ; 74 67                       ; 0xc403e
    mov cx, 00100h                            ; b9 00 01                    ; 0xc4040 vbe.c:420
    xor ax, ax                                ; 31 c0                       ; 0xc4043
    mov di, bx                                ; 89 df                       ; 0xc4045
    mov es, si                                ; 8e c6                       ; 0xc4047
    jcxz 0404dh                               ; e3 02                       ; 0xc4049
    rep stosb                                 ; f3 aa                       ; 0xc404b
    xor cx, cx                                ; 31 c9                       ; 0xc404d vbe.c:421
    jmp short 04056h                          ; eb 05                       ; 0xc404f
    cmp cx, strict byte 00042h                ; 83 f9 42                    ; 0xc4051
    jnc short 0406fh                          ; 73 19                       ; 0xc4054
    mov dx, word [bp-006h]                    ; 8b 56 fa                    ; 0xc4056 vbe.c:424
    inc dx                                    ; 42                          ; 0xc4059
    inc dx                                    ; 42                          ; 0xc405a
    add dx, cx                                ; 01 ca                       ; 0xc405b
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc405d
    call 03e17h                               ; e8 b4 fd                    ; 0xc4060
    mov di, bx                                ; 89 df                       ; 0xc4063 vbe.c:425
    add di, cx                                ; 01 cf                       ; 0xc4065
    mov es, si                                ; 8e c6                       ; 0xc4067 vbe.c:52
    mov byte [es:di], al                      ; 26 88 05                    ; 0xc4069
    inc cx                                    ; 41                          ; 0xc406c vbe.c:426
    jmp short 04051h                          ; eb e2                       ; 0xc406d
    lea di, [bx+002h]                         ; 8d 7f 02                    ; 0xc406f vbe.c:427
    mov es, si                                ; 8e c6                       ; 0xc4072 vbe.c:47
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc4074
    test AL, strict byte 001h                 ; a8 01                       ; 0xc4077 vbe.c:428
    je short 0408bh                           ; 74 10                       ; 0xc4079
    lea di, [bx+00ch]                         ; 8d 7f 0c                    ; 0xc407b vbe.c:429
    mov word [es:di], 0065ch                  ; 26 c7 05 5c 06              ; 0xc407e vbe.c:62
    lea di, [bx+00eh]                         ; 8d 7f 0e                    ; 0xc4083 vbe.c:431
    mov word [es:di], 0c000h                  ; 26 c7 05 00 c0              ; 0xc4086 vbe.c:62
    mov ax, strict word 0000bh                ; b8 0b 00                    ; 0xc408b vbe.c:434
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc408e
    call 005a0h                               ; e8 0c c5                    ; 0xc4091
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4094 vbe.c:435
    call 005a7h                               ; e8 0d c5                    ; 0xc4097
    add bx, strict byte 0002ah                ; 83 c3 2a                    ; 0xc409a
    mov es, si                                ; 8e c6                       ; 0xc409d vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc409f
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc40a2 vbe.c:437
    jmp short 040aah                          ; eb 03                       ; 0xc40a5 vbe.c:438
    mov ax, 00100h                            ; b8 00 01                    ; 0xc40a7 vbe.c:442
    push SS                                   ; 16                          ; 0xc40aa vbe.c:445
    pop ES                                    ; 07                          ; 0xc40ab
    mov bx, word [bp-008h]                    ; 8b 5e f8                    ; 0xc40ac
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc40af
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc40b2 vbe.c:446
    pop di                                    ; 5f                          ; 0xc40b5
    pop si                                    ; 5e                          ; 0xc40b6
    pop bp                                    ; 5d                          ; 0xc40b7
    retn                                      ; c3                          ; 0xc40b8
  ; disGetNextSymbol 0xc40b9 LB 0x439 -> off=0x0 cb=00000000000000f1 uValue=00000000000c40b9 'vbe_biosfn_set_mode'
vbe_biosfn_set_mode:                         ; 0xc40b9 LB 0xf1
    push bp                                   ; 55                          ; 0xc40b9 vbe.c:458
    mov bp, sp                                ; 89 e5                       ; 0xc40ba
    push si                                   ; 56                          ; 0xc40bc
    push di                                   ; 57                          ; 0xc40bd
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc40be
    mov si, ax                                ; 89 c6                       ; 0xc40c1
    mov word [bp-00ah], dx                    ; 89 56 f6                    ; 0xc40c3
    test byte [bp-009h], 040h                 ; f6 46 f7 40                 ; 0xc40c6 vbe.c:466
    je short 040d1h                           ; 74 05                       ; 0xc40ca
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc40cc
    jmp short 040d3h                          ; eb 02                       ; 0xc40cf
    xor ax, ax                                ; 31 c0                       ; 0xc40d1
    mov dx, ax                                ; 89 c2                       ; 0xc40d3
    test ax, ax                               ; 85 c0                       ; 0xc40d5 vbe.c:467
    je short 040dch                           ; 74 03                       ; 0xc40d7
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc40d9
    mov byte [bp-008h], al                    ; 88 46 f8                    ; 0xc40dc
    test byte [bp-009h], 080h                 ; f6 46 f7 80                 ; 0xc40df vbe.c:468
    je short 040eah                           ; 74 05                       ; 0xc40e3
    mov ax, 00080h                            ; b8 80 00                    ; 0xc40e5
    jmp short 040ech                          ; eb 02                       ; 0xc40e8
    xor ax, ax                                ; 31 c0                       ; 0xc40ea
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc40ec
    and byte [bp-009h], 001h                  ; 80 66 f7 01                 ; 0xc40ef vbe.c:470
    cmp word [bp-00ah], 00100h                ; 81 7e f6 00 01              ; 0xc40f3 vbe.c:473
    jnc short 0410dh                          ; 73 13                       ; 0xc40f8
    xor ax, ax                                ; 31 c0                       ; 0xc40fa vbe.c:477
    call 00610h                               ; e8 11 c5                    ; 0xc40fc
    mov al, byte [bp-00ah]                    ; 8a 46 f6                    ; 0xc40ff vbe.c:481
    xor ah, ah                                ; 30 e4                       ; 0xc4102
    call 013f4h                               ; e8 ed d2                    ; 0xc4104
    mov ax, strict word 0004fh                ; b8 4f 00                    ; 0xc4107 vbe.c:482
    jmp near 0419eh                           ; e9 91 00                    ; 0xc410a vbe.c:483
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc410d vbe.c:486
    call 03e83h                               ; e8 70 fd                    ; 0xc4110
    mov bx, ax                                ; 89 c3                       ; 0xc4113
    test ax, ax                               ; 85 c0                       ; 0xc4115 vbe.c:488
    jne short 0411ch                          ; 75 03                       ; 0xc4117
    jmp near 0419bh                           ; e9 7f 00                    ; 0xc4119
    lea dx, [bx+014h]                         ; 8d 57 14                    ; 0xc411c vbe.c:493
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc411f
    call 03e05h                               ; e8 e0 fc                    ; 0xc4122
    mov cx, ax                                ; 89 c1                       ; 0xc4125
    lea dx, [bx+016h]                         ; 8d 57 16                    ; 0xc4127 vbe.c:494
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc412a
    call 03e05h                               ; e8 d5 fc                    ; 0xc412d
    mov di, ax                                ; 89 c7                       ; 0xc4130
    lea dx, [bx+01bh]                         ; 8d 57 1b                    ; 0xc4132 vbe.c:495
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc4135
    call 03e17h                               ; e8 dc fc                    ; 0xc4138
    mov bl, al                                ; 88 c3                       ; 0xc413b
    mov bh, al                                ; 88 c7                       ; 0xc413d
    xor ax, ax                                ; 31 c0                       ; 0xc413f vbe.c:503
    call 00610h                               ; e8 cc c4                    ; 0xc4141
    mov ax, strict word 00007h                ; b8 07 00                    ; 0xc4144 vbe.c:505
    mov dx, 003c4h                            ; ba c4 03                    ; 0xc4147
    out DX, ax                                ; ef                          ; 0xc414a
    cmp bl, 004h                              ; 80 fb 04                    ; 0xc414b vbe.c:507
    jne short 04156h                          ; 75 06                       ; 0xc414e
    mov ax, strict word 0006ah                ; b8 6a 00                    ; 0xc4150 vbe.c:509
    call 013f4h                               ; e8 9e d2                    ; 0xc4153
    mov al, bh                                ; 88 f8                       ; 0xc4156 vbe.c:512
    xor ah, ah                                ; 30 e4                       ; 0xc4158
    call 03d7ch                               ; e8 1f fc                    ; 0xc415a
    mov ax, cx                                ; 89 c8                       ; 0xc415d vbe.c:513
    call 03d25h                               ; e8 c3 fb                    ; 0xc415f
    mov ax, di                                ; 89 f8                       ; 0xc4162 vbe.c:514
    call 03d44h                               ; e8 dd fb                    ; 0xc4164
    xor ax, ax                                ; 31 c0                       ; 0xc4167 vbe.c:515
    call 00636h                               ; e8 ca c4                    ; 0xc4169
    mov dl, byte [bp-006h]                    ; 8a 56 fa                    ; 0xc416c vbe.c:516
    or dl, 001h                               ; 80 ca 01                    ; 0xc416f
    mov al, byte [bp-008h]                    ; 8a 46 f8                    ; 0xc4172
    xor ah, ah                                ; 30 e4                       ; 0xc4175
    or al, dl                                 ; 08 d0                       ; 0xc4177
    call 00610h                               ; e8 94 c4                    ; 0xc4179
    call 00708h                               ; e8 89 c5                    ; 0xc417c vbe.c:517
    mov bx, 000bah                            ; bb ba 00                    ; 0xc417f vbe.c:62
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc4182
    mov es, ax                                ; 8e c0                       ; 0xc4185
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc4187
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc418a
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc418d vbe.c:520
    or AL, strict byte 060h                   ; 0c 60                       ; 0xc4190
    mov bx, 00087h                            ; bb 87 00                    ; 0xc4192 vbe.c:52
    mov byte [es:bx], al                      ; 26 88 07                    ; 0xc4195
    jmp near 04107h                           ; e9 6c ff                    ; 0xc4198
    mov ax, 00100h                            ; b8 00 01                    ; 0xc419b vbe.c:529
    push SS                                   ; 16                          ; 0xc419e vbe.c:533
    pop ES                                    ; 07                          ; 0xc419f
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc41a0
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc41a3 vbe.c:534
    pop di                                    ; 5f                          ; 0xc41a6
    pop si                                    ; 5e                          ; 0xc41a7
    pop bp                                    ; 5d                          ; 0xc41a8
    retn                                      ; c3                          ; 0xc41a9
  ; disGetNextSymbol 0xc41aa LB 0x348 -> off=0x0 cb=0000000000000008 uValue=00000000000c41aa 'vbe_biosfn_read_video_state_size'
vbe_biosfn_read_video_state_size:            ; 0xc41aa LB 0x8
    push bp                                   ; 55                          ; 0xc41aa vbe.c:536
    mov bp, sp                                ; 89 e5                       ; 0xc41ab
    mov ax, strict word 00012h                ; b8 12 00                    ; 0xc41ad vbe.c:539
    pop bp                                    ; 5d                          ; 0xc41b0
    retn                                      ; c3                          ; 0xc41b1
  ; disGetNextSymbol 0xc41b2 LB 0x340 -> off=0x0 cb=000000000000004b uValue=00000000000c41b2 'vbe_biosfn_save_video_state'
vbe_biosfn_save_video_state:                 ; 0xc41b2 LB 0x4b
    push bp                                   ; 55                          ; 0xc41b2 vbe.c:541
    mov bp, sp                                ; 89 e5                       ; 0xc41b3
    push bx                                   ; 53                          ; 0xc41b5
    push cx                                   ; 51                          ; 0xc41b6
    push si                                   ; 56                          ; 0xc41b7
    mov si, ax                                ; 89 c6                       ; 0xc41b8
    mov bx, dx                                ; 89 d3                       ; 0xc41ba
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc41bc vbe.c:545
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc41bf
    out DX, ax                                ; ef                          ; 0xc41c2
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc41c3 vbe.c:546
    in ax, DX                                 ; ed                          ; 0xc41c6
    mov es, si                                ; 8e c6                       ; 0xc41c7 vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc41c9
    inc bx                                    ; 43                          ; 0xc41cc vbe.c:548
    inc bx                                    ; 43                          ; 0xc41cd
    test AL, strict byte 001h                 ; a8 01                       ; 0xc41ce vbe.c:549
    je short 041f5h                           ; 74 23                       ; 0xc41d0
    mov cx, strict word 00001h                ; b9 01 00                    ; 0xc41d2 vbe.c:551
    jmp short 041dch                          ; eb 05                       ; 0xc41d5
    cmp cx, strict byte 00009h                ; 83 f9 09                    ; 0xc41d7
    jnbe short 041f5h                         ; 77 19                       ; 0xc41da
    cmp cx, strict byte 00004h                ; 83 f9 04                    ; 0xc41dc vbe.c:552
    je short 041f2h                           ; 74 11                       ; 0xc41df
    mov ax, cx                                ; 89 c8                       ; 0xc41e1 vbe.c:553
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc41e3
    out DX, ax                                ; ef                          ; 0xc41e6
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc41e7 vbe.c:554
    in ax, DX                                 ; ed                          ; 0xc41ea
    mov es, si                                ; 8e c6                       ; 0xc41eb vbe.c:62
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc41ed
    inc bx                                    ; 43                          ; 0xc41f0 vbe.c:555
    inc bx                                    ; 43                          ; 0xc41f1
    inc cx                                    ; 41                          ; 0xc41f2 vbe.c:557
    jmp short 041d7h                          ; eb e2                       ; 0xc41f3
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc41f5 vbe.c:558
    pop si                                    ; 5e                          ; 0xc41f8
    pop cx                                    ; 59                          ; 0xc41f9
    pop bx                                    ; 5b                          ; 0xc41fa
    pop bp                                    ; 5d                          ; 0xc41fb
    retn                                      ; c3                          ; 0xc41fc
  ; disGetNextSymbol 0xc41fd LB 0x2f5 -> off=0x0 cb=000000000000008f uValue=00000000000c41fd 'vbe_biosfn_restore_video_state'
vbe_biosfn_restore_video_state:              ; 0xc41fd LB 0x8f
    push bp                                   ; 55                          ; 0xc41fd vbe.c:561
    mov bp, sp                                ; 89 e5                       ; 0xc41fe
    push bx                                   ; 53                          ; 0xc4200
    push cx                                   ; 51                          ; 0xc4201
    push si                                   ; 56                          ; 0xc4202
    push ax                                   ; 50                          ; 0xc4203
    mov cx, ax                                ; 89 c1                       ; 0xc4204
    mov bx, dx                                ; 89 d3                       ; 0xc4206
    mov es, ax                                ; 8e c0                       ; 0xc4208 vbe.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc420a
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc420d
    inc bx                                    ; 43                          ; 0xc4210 vbe.c:566
    inc bx                                    ; 43                          ; 0xc4211
    test byte [bp-008h], 001h                 ; f6 46 f8 01                 ; 0xc4212 vbe.c:568
    jne short 04228h                          ; 75 10                       ; 0xc4216
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc4218 vbe.c:569
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc421b
    out DX, ax                                ; ef                          ; 0xc421e
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc421f vbe.c:570
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4222
    out DX, ax                                ; ef                          ; 0xc4225
    jmp short 04284h                          ; eb 5c                       ; 0xc4226 vbe.c:571
    mov ax, strict word 00001h                ; b8 01 00                    ; 0xc4228 vbe.c:572
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc422b
    out DX, ax                                ; ef                          ; 0xc422e
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc422f vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4232 vbe.c:58
    out DX, ax                                ; ef                          ; 0xc4235
    inc bx                                    ; 43                          ; 0xc4236 vbe.c:574
    inc bx                                    ; 43                          ; 0xc4237
    mov ax, strict word 00002h                ; b8 02 00                    ; 0xc4238
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc423b
    out DX, ax                                ; ef                          ; 0xc423e
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc423f vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4242 vbe.c:58
    out DX, ax                                ; ef                          ; 0xc4245
    inc bx                                    ; 43                          ; 0xc4246 vbe.c:577
    inc bx                                    ; 43                          ; 0xc4247
    mov ax, strict word 00003h                ; b8 03 00                    ; 0xc4248
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc424b
    out DX, ax                                ; ef                          ; 0xc424e
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc424f vbe.c:57
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4252 vbe.c:58
    out DX, ax                                ; ef                          ; 0xc4255
    inc bx                                    ; 43                          ; 0xc4256 vbe.c:580
    inc bx                                    ; 43                          ; 0xc4257
    mov ax, strict word 00004h                ; b8 04 00                    ; 0xc4258
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc425b
    out DX, ax                                ; ef                          ; 0xc425e
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc425f vbe.c:582
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc4262
    out DX, ax                                ; ef                          ; 0xc4265
    mov si, strict word 00005h                ; be 05 00                    ; 0xc4266 vbe.c:584
    jmp short 04270h                          ; eb 05                       ; 0xc4269
    cmp si, strict byte 00009h                ; 83 fe 09                    ; 0xc426b
    jnbe short 04284h                         ; 77 14                       ; 0xc426e
    mov ax, si                                ; 89 f0                       ; 0xc4270 vbe.c:585
    mov dx, 001ceh                            ; ba ce 01                    ; 0xc4272
    out DX, ax                                ; ef                          ; 0xc4275
    mov es, cx                                ; 8e c1                       ; 0xc4276 vbe.c:57
    mov ax, word [es:bx]                      ; 26 8b 07                    ; 0xc4278
    mov dx, 001cfh                            ; ba cf 01                    ; 0xc427b vbe.c:58
    out DX, ax                                ; ef                          ; 0xc427e
    inc bx                                    ; 43                          ; 0xc427f vbe.c:587
    inc bx                                    ; 43                          ; 0xc4280
    inc si                                    ; 46                          ; 0xc4281 vbe.c:588
    jmp short 0426bh                          ; eb e7                       ; 0xc4282
    lea sp, [bp-006h]                         ; 8d 66 fa                    ; 0xc4284 vbe.c:590
    pop si                                    ; 5e                          ; 0xc4287
    pop cx                                    ; 59                          ; 0xc4288
    pop bx                                    ; 5b                          ; 0xc4289
    pop bp                                    ; 5d                          ; 0xc428a
    retn                                      ; c3                          ; 0xc428b
  ; disGetNextSymbol 0xc428c LB 0x266 -> off=0x0 cb=000000000000008d uValue=00000000000c428c 'vbe_biosfn_save_restore_state'
vbe_biosfn_save_restore_state:               ; 0xc428c LB 0x8d
    push bp                                   ; 55                          ; 0xc428c vbe.c:606
    mov bp, sp                                ; 89 e5                       ; 0xc428d
    push si                                   ; 56                          ; 0xc428f
    push di                                   ; 57                          ; 0xc4290
    push ax                                   ; 50                          ; 0xc4291
    mov si, ax                                ; 89 c6                       ; 0xc4292
    mov word [bp-006h], dx                    ; 89 56 fa                    ; 0xc4294
    mov ax, bx                                ; 89 d8                       ; 0xc4297
    mov bx, word [bp+004h]                    ; 8b 5e 04                    ; 0xc4299
    mov di, strict word 0004fh                ; bf 4f 00                    ; 0xc429c vbe.c:611
    xor ah, ah                                ; 30 e4                       ; 0xc429f vbe.c:612
    cmp ax, strict word 00002h                ; 3d 02 00                    ; 0xc42a1
    je short 042ech                           ; 74 46                       ; 0xc42a4
    cmp ax, strict word 00001h                ; 3d 01 00                    ; 0xc42a6
    je short 042d0h                           ; 74 25                       ; 0xc42a9
    test ax, ax                               ; 85 c0                       ; 0xc42ab
    jne short 04308h                          ; 75 59                       ; 0xc42ad
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc42af vbe.c:614
    call 0323ch                               ; e8 87 ef                    ; 0xc42b2
    mov cx, ax                                ; 89 c1                       ; 0xc42b5
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc42b7 vbe.c:618
    je short 042c2h                           ; 74 05                       ; 0xc42bb
    call 041aah                               ; e8 ea fe                    ; 0xc42bd vbe.c:619
    add ax, cx                                ; 01 c8                       ; 0xc42c0
    add ax, strict word 0003fh                ; 05 3f 00                    ; 0xc42c2 vbe.c:620
    mov CL, strict byte 006h                  ; b1 06                       ; 0xc42c5
    shr ax, CL                                ; d3 e8                       ; 0xc42c7
    push SS                                   ; 16                          ; 0xc42c9
    pop ES                                    ; 07                          ; 0xc42ca
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc42cb
    jmp short 0430bh                          ; eb 3b                       ; 0xc42ce vbe.c:621
    push SS                                   ; 16                          ; 0xc42d0 vbe.c:623
    pop ES                                    ; 07                          ; 0xc42d1
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc42d2
    mov dx, cx                                ; 89 ca                       ; 0xc42d5 vbe.c:624
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc42d7
    call 0327ah                               ; e8 9d ef                    ; 0xc42da
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc42dd vbe.c:628
    je short 0430bh                           ; 74 28                       ; 0xc42e1
    mov dx, ax                                ; 89 c2                       ; 0xc42e3 vbe.c:629
    mov ax, cx                                ; 89 c8                       ; 0xc42e5
    call 041b2h                               ; e8 c8 fe                    ; 0xc42e7
    jmp short 0430bh                          ; eb 1f                       ; 0xc42ea vbe.c:630
    push SS                                   ; 16                          ; 0xc42ec vbe.c:632
    pop ES                                    ; 07                          ; 0xc42ed
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc42ee
    mov dx, cx                                ; 89 ca                       ; 0xc42f1 vbe.c:633
    mov ax, word [bp-006h]                    ; 8b 46 fa                    ; 0xc42f3
    call 03552h                               ; e8 59 f2                    ; 0xc42f6
    test byte [bp-006h], 008h                 ; f6 46 fa 08                 ; 0xc42f9 vbe.c:637
    je short 0430bh                           ; 74 0c                       ; 0xc42fd
    mov dx, ax                                ; 89 c2                       ; 0xc42ff vbe.c:638
    mov ax, cx                                ; 89 c8                       ; 0xc4301
    call 041fdh                               ; e8 f7 fe                    ; 0xc4303
    jmp short 0430bh                          ; eb 03                       ; 0xc4306 vbe.c:639
    mov di, 00100h                            ; bf 00 01                    ; 0xc4308 vbe.c:642
    push SS                                   ; 16                          ; 0xc430b vbe.c:645
    pop ES                                    ; 07                          ; 0xc430c
    mov word [es:si], di                      ; 26 89 3c                    ; 0xc430d
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc4310 vbe.c:646
    pop di                                    ; 5f                          ; 0xc4313
    pop si                                    ; 5e                          ; 0xc4314
    pop bp                                    ; 5d                          ; 0xc4315
    retn 00002h                               ; c2 02 00                    ; 0xc4316
  ; disGetNextSymbol 0xc4319 LB 0x1d9 -> off=0x0 cb=00000000000000e2 uValue=00000000000c4319 'vbe_biosfn_get_set_scanline_length'
vbe_biosfn_get_set_scanline_length:          ; 0xc4319 LB 0xe2
    push bp                                   ; 55                          ; 0xc4319 vbe.c:667
    mov bp, sp                                ; 89 e5                       ; 0xc431a
    push si                                   ; 56                          ; 0xc431c
    push di                                   ; 57                          ; 0xc431d
    sub sp, strict byte 0000ah                ; 83 ec 0a                    ; 0xc431e
    push ax                                   ; 50                          ; 0xc4321
    mov di, dx                                ; 89 d7                       ; 0xc4322
    mov word [bp-006h], bx                    ; 89 5e fa                    ; 0xc4324
    mov si, cx                                ; 89 ce                       ; 0xc4327
    call 03d9bh                               ; e8 6f fa                    ; 0xc4329 vbe.c:676
    cmp AL, strict byte 00fh                  ; 3c 0f                       ; 0xc432c vbe.c:677
    jne short 04335h                          ; 75 05                       ; 0xc432e
    mov cx, strict word 00010h                ; b9 10 00                    ; 0xc4330
    jmp short 04339h                          ; eb 04                       ; 0xc4333
    xor ah, ah                                ; 30 e4                       ; 0xc4335
    mov cx, ax                                ; 89 c1                       ; 0xc4337
    mov ch, cl                                ; 88 cd                       ; 0xc4339
    call 03dd3h                               ; e8 95 fa                    ; 0xc433b vbe.c:678
    mov word [bp-00ah], ax                    ; 89 46 f6                    ; 0xc433e
    mov word [bp-00ch], strict word 0004fh    ; c7 46 f4 4f 00              ; 0xc4341 vbe.c:679
    push SS                                   ; 16                          ; 0xc4346 vbe.c:680
    pop ES                                    ; 07                          ; 0xc4347
    mov bx, word [bp-006h]                    ; 8b 5e fa                    ; 0xc4348
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc434b
    mov al, byte [es:di]                      ; 26 8a 05                    ; 0xc434e vbe.c:681
    cmp AL, strict byte 002h                  ; 3c 02                       ; 0xc4351 vbe.c:685
    je short 04360h                           ; 74 0b                       ; 0xc4353
    cmp AL, strict byte 001h                  ; 3c 01                       ; 0xc4355
    je short 04389h                           ; 74 30                       ; 0xc4357
    test al, al                               ; 84 c0                       ; 0xc4359
    je short 04384h                           ; 74 27                       ; 0xc435b
    jmp near 043e4h                           ; e9 84 00                    ; 0xc435d
    cmp ch, 004h                              ; 80 fd 04                    ; 0xc4360 vbe.c:687
    jne short 0436bh                          ; 75 06                       ; 0xc4363
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc4365 vbe.c:688
    sal bx, CL                                ; d3 e3                       ; 0xc4367
    jmp short 04384h                          ; eb 19                       ; 0xc4369 vbe.c:689
    mov al, ch                                ; 88 e8                       ; 0xc436b vbe.c:690
    xor ah, ah                                ; 30 e4                       ; 0xc436d
    cwd                                       ; 99                          ; 0xc436f
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc4370
    sal dx, CL                                ; d3 e2                       ; 0xc4372
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc4374
    sar ax, CL                                ; d3 f8                       ; 0xc4376
    mov word [bp-00eh], ax                    ; 89 46 f2                    ; 0xc4378
    mov ax, bx                                ; 89 d8                       ; 0xc437b
    xor dx, dx                                ; 31 d2                       ; 0xc437d
    div word [bp-00eh]                        ; f7 76 f2                    ; 0xc437f
    mov bx, ax                                ; 89 c3                       ; 0xc4382
    mov ax, bx                                ; 89 d8                       ; 0xc4384 vbe.c:693
    call 03db4h                               ; e8 2b fa                    ; 0xc4386
    call 03dd3h                               ; e8 47 fa                    ; 0xc4389 vbe.c:696
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc438c
    push SS                                   ; 16                          ; 0xc438f vbe.c:697
    pop ES                                    ; 07                          ; 0xc4390
    mov bx, word [bp-006h]                    ; 8b 5e fa                    ; 0xc4391
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc4394
    cmp ch, 004h                              ; 80 fd 04                    ; 0xc4397 vbe.c:698
    jne short 043a4h                          ; 75 08                       ; 0xc439a
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc439c vbe.c:699
    mov bx, ax                                ; 89 c3                       ; 0xc439e
    shr bx, CL                                ; d3 eb                       ; 0xc43a0
    jmp short 043bah                          ; eb 16                       ; 0xc43a2 vbe.c:700
    mov al, ch                                ; 88 e8                       ; 0xc43a4 vbe.c:701
    xor ah, ah                                ; 30 e4                       ; 0xc43a6
    cwd                                       ; 99                          ; 0xc43a8
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc43a9
    sal dx, CL                                ; d3 e2                       ; 0xc43ab
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc43ad
    sar ax, CL                                ; d3 f8                       ; 0xc43af
    mov bx, ax                                ; 89 c3                       ; 0xc43b1
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc43b3
    mul bx                                    ; f7 e3                       ; 0xc43b6
    mov bx, ax                                ; 89 c3                       ; 0xc43b8
    add bx, strict byte 00003h                ; 83 c3 03                    ; 0xc43ba vbe.c:702
    and bl, 0fch                              ; 80 e3 fc                    ; 0xc43bd
    push SS                                   ; 16                          ; 0xc43c0 vbe.c:703
    pop ES                                    ; 07                          ; 0xc43c1
    mov word [es:di], bx                      ; 26 89 1d                    ; 0xc43c2
    call 03dech                               ; e8 24 fa                    ; 0xc43c5 vbe.c:704
    push SS                                   ; 16                          ; 0xc43c8
    pop ES                                    ; 07                          ; 0xc43c9
    mov word [es:si], ax                      ; 26 89 04                    ; 0xc43ca
    call 03d63h                               ; e8 93 f9                    ; 0xc43cd vbe.c:705
    push SS                                   ; 16                          ; 0xc43d0
    pop ES                                    ; 07                          ; 0xc43d1
    cmp ax, word [es:si]                      ; 26 3b 04                    ; 0xc43d2
    jbe short 043e9h                          ; 76 12                       ; 0xc43d5
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc43d7 vbe.c:706
    call 03db4h                               ; e8 d7 f9                    ; 0xc43da
    mov word [bp-00ch], 00200h                ; c7 46 f4 00 02              ; 0xc43dd vbe.c:707
    jmp short 043e9h                          ; eb 05                       ; 0xc43e2 vbe.c:709
    mov word [bp-00ch], 00100h                ; c7 46 f4 00 01              ; 0xc43e4 vbe.c:712
    push SS                                   ; 16                          ; 0xc43e9 vbe.c:715
    pop ES                                    ; 07                          ; 0xc43ea
    mov ax, word [bp-00ch]                    ; 8b 46 f4                    ; 0xc43eb
    mov bx, word [bp-010h]                    ; 8b 5e f0                    ; 0xc43ee
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc43f1
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc43f4 vbe.c:716
    pop di                                    ; 5f                          ; 0xc43f7
    pop si                                    ; 5e                          ; 0xc43f8
    pop bp                                    ; 5d                          ; 0xc43f9
    retn                                      ; c3                          ; 0xc43fa
  ; disGetNextSymbol 0xc43fb LB 0xf7 -> off=0x0 cb=00000000000000f7 uValue=00000000000c43fb 'private_biosfn_custom_mode'
private_biosfn_custom_mode:                  ; 0xc43fb LB 0xf7
    push bp                                   ; 55                          ; 0xc43fb vbe.c:742
    mov bp, sp                                ; 89 e5                       ; 0xc43fc
    push si                                   ; 56                          ; 0xc43fe
    push di                                   ; 57                          ; 0xc43ff
    sub sp, strict byte 00006h                ; 83 ec 06                    ; 0xc4400
    push ax                                   ; 50                          ; 0xc4403
    mov si, dx                                ; 89 d6                       ; 0xc4404
    mov di, cx                                ; 89 cf                       ; 0xc4406
    mov word [bp-00ah], strict word 0004fh    ; c7 46 f6 4f 00              ; 0xc4408 vbe.c:755
    push SS                                   ; 16                          ; 0xc440d vbe.c:756
    pop ES                                    ; 07                          ; 0xc440e
    mov al, byte [es:si]                      ; 26 8a 04                    ; 0xc440f
    test al, al                               ; 84 c0                       ; 0xc4412 vbe.c:757
    jne short 04436h                          ; 75 20                       ; 0xc4414
    push SS                                   ; 16                          ; 0xc4416 vbe.c:759
    pop ES                                    ; 07                          ; 0xc4417
    mov bx, word [es:bx]                      ; 26 8b 1f                    ; 0xc4418
    mov ax, word [es:di]                      ; 26 8b 05                    ; 0xc441b vbe.c:760
    mov word [bp-008h], ax                    ; 89 46 f8                    ; 0xc441e
    mov al, byte [es:si+001h]                 ; 26 8a 44 01                 ; 0xc4421 vbe.c:761
    and ax, strict word 0007fh                ; 25 7f 00                    ; 0xc4425
    mov ch, al                                ; 88 c5                       ; 0xc4428
    cmp AL, strict byte 008h                  ; 3c 08                       ; 0xc442a vbe.c:766
    je short 0443eh                           ; 74 10                       ; 0xc442c
    cmp AL, strict byte 010h                  ; 3c 10                       ; 0xc442e
    je short 0443eh                           ; 74 0c                       ; 0xc4430
    cmp AL, strict byte 020h                  ; 3c 20                       ; 0xc4432
    je short 0443eh                           ; 74 08                       ; 0xc4434
    mov word [bp-00ah], 00100h                ; c7 46 f6 00 01              ; 0xc4436 vbe.c:767
    jmp near 044e0h                           ; e9 a2 00                    ; 0xc443b vbe.c:768
    push SS                                   ; 16                          ; 0xc443e vbe.c:772
    pop ES                                    ; 07                          ; 0xc443f
    test byte [es:si+001h], 080h              ; 26 f6 44 01 80              ; 0xc4440
    je short 0444ch                           ; 74 05                       ; 0xc4445
    mov ax, strict word 00040h                ; b8 40 00                    ; 0xc4447
    jmp short 0444eh                          ; eb 02                       ; 0xc444a
    xor ax, ax                                ; 31 c0                       ; 0xc444c
    mov byte [bp-006h], al                    ; 88 46 fa                    ; 0xc444e
    cmp bx, 00280h                            ; 81 fb 80 02                 ; 0xc4451 vbe.c:775
    jnc short 0445ch                          ; 73 05                       ; 0xc4455
    mov bx, 00280h                            ; bb 80 02                    ; 0xc4457 vbe.c:776
    jmp short 04465h                          ; eb 09                       ; 0xc445a vbe.c:777
    cmp bx, 00a00h                            ; 81 fb 00 0a                 ; 0xc445c
    jbe short 04465h                          ; 76 03                       ; 0xc4460
    mov bx, 00a00h                            ; bb 00 0a                    ; 0xc4462 vbe.c:778
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc4465 vbe.c:779
    cmp ax, 001e0h                            ; 3d e0 01                    ; 0xc4468
    jnc short 04474h                          ; 73 07                       ; 0xc446b
    mov word [bp-008h], 001e0h                ; c7 46 f8 e0 01              ; 0xc446d vbe.c:780
    jmp short 0447eh                          ; eb 0a                       ; 0xc4472 vbe.c:781
    cmp ax, 00780h                            ; 3d 80 07                    ; 0xc4474
    jbe short 0447eh                          ; 76 05                       ; 0xc4477
    mov word [bp-008h], 00780h                ; c7 46 f8 80 07              ; 0xc4479 vbe.c:782
    mov dx, strict word 0ffffh                ; ba ff ff                    ; 0xc447e vbe.c:788
    mov ax, 003b6h                            ; b8 b6 03                    ; 0xc4481
    call 03e05h                               ; e8 7e f9                    ; 0xc4484
    mov si, ax                                ; 89 c6                       ; 0xc4487
    mov al, ch                                ; 88 e8                       ; 0xc4489 vbe.c:791
    xor ah, ah                                ; 30 e4                       ; 0xc448b
    cwd                                       ; 99                          ; 0xc448d
    mov CL, strict byte 003h                  ; b1 03                       ; 0xc448e
    sal dx, CL                                ; d3 e2                       ; 0xc4490
    db  01bh, 0c2h
    ; sbb ax, dx                                ; 1b c2                     ; 0xc4492
    sar ax, CL                                ; d3 f8                       ; 0xc4494
    mov dx, ax                                ; 89 c2                       ; 0xc4496
    mov ax, bx                                ; 89 d8                       ; 0xc4498
    mul dx                                    ; f7 e2                       ; 0xc449a
    add ax, strict word 00003h                ; 05 03 00                    ; 0xc449c vbe.c:792
    and AL, strict byte 0fch                  ; 24 fc                       ; 0xc449f
    mov dx, word [bp-008h]                    ; 8b 56 f8                    ; 0xc44a1 vbe.c:794
    mul dx                                    ; f7 e2                       ; 0xc44a4
    cmp dx, si                                ; 39 f2                       ; 0xc44a6 vbe.c:796
    jnbe short 044b0h                         ; 77 06                       ; 0xc44a8
    jne short 044b7h                          ; 75 0b                       ; 0xc44aa
    test ax, ax                               ; 85 c0                       ; 0xc44ac
    jbe short 044b7h                          ; 76 07                       ; 0xc44ae
    mov word [bp-00ah], 00200h                ; c7 46 f6 00 02              ; 0xc44b0 vbe.c:798
    jmp short 044e0h                          ; eb 29                       ; 0xc44b5 vbe.c:799
    xor ax, ax                                ; 31 c0                       ; 0xc44b7 vbe.c:803
    call 00610h                               ; e8 54 c1                    ; 0xc44b9
    mov al, ch                                ; 88 e8                       ; 0xc44bc vbe.c:804
    xor ah, ah                                ; 30 e4                       ; 0xc44be
    call 03d7ch                               ; e8 b9 f8                    ; 0xc44c0
    mov ax, bx                                ; 89 d8                       ; 0xc44c3 vbe.c:805
    call 03d25h                               ; e8 5d f8                    ; 0xc44c5
    mov ax, word [bp-008h]                    ; 8b 46 f8                    ; 0xc44c8 vbe.c:806
    call 03d44h                               ; e8 76 f8                    ; 0xc44cb
    xor ax, ax                                ; 31 c0                       ; 0xc44ce vbe.c:807
    call 00636h                               ; e8 63 c1                    ; 0xc44d0
    mov al, byte [bp-006h]                    ; 8a 46 fa                    ; 0xc44d3 vbe.c:808
    or AL, strict byte 001h                   ; 0c 01                       ; 0xc44d6
    xor ah, ah                                ; 30 e4                       ; 0xc44d8
    call 00610h                               ; e8 33 c1                    ; 0xc44da
    call 00708h                               ; e8 28 c2                    ; 0xc44dd vbe.c:809
    push SS                                   ; 16                          ; 0xc44e0 vbe.c:817
    pop ES                                    ; 07                          ; 0xc44e1
    mov ax, word [bp-00ah]                    ; 8b 46 f6                    ; 0xc44e2
    mov bx, word [bp-00ch]                    ; 8b 5e f4                    ; 0xc44e5
    mov word [es:bx], ax                      ; 26 89 07                    ; 0xc44e8
    lea sp, [bp-004h]                         ; 8d 66 fc                    ; 0xc44eb vbe.c:818
    pop di                                    ; 5f                          ; 0xc44ee
    pop si                                    ; 5e                          ; 0xc44ef
    pop bp                                    ; 5d                          ; 0xc44f0
    retn                                      ; c3                          ; 0xc44f1

  ; Padding 0x14e bytes at 0xc44f2
  times 334 db 0

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
    db  06fh, 073h, 038h, 030h, 038h, 036h, 02fh, 056h, 042h, 06fh, 078h, 056h, 067h, 061h, 042h, 069h
    db  06fh, 073h, 038h, 030h, 038h, 036h, 02eh, 073h, 079h, 06dh, 000h, 000h, 000h, 000h, 000h, 000h
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
    db  000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 084h
