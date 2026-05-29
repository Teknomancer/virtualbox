NASM git master aa12d3381a1fd08e72f594147f2486c1b5ab7813 (3.02rc7) with
the patches below applied.

Requires perl and git in the PATH.

Sketchy build steps for amd64:

  pushd %VBOXROOT%
  "tools/env.cmd"
  set VBOXROOT=%_CWD
  popd
  "%VBOXROOT%/tools/win/vcc/v14.3.17.11.5/env-amd64.cmd"
  "%VBOXROOT%/tools/win/sdk/v10.0.26100.3323/env-amd64.cmd" --ucrt

  git clone https://github.com/netwide-assembler/nasm.git git-nasm-3.02rc7-p1-amd64
  cd git-nasm-3.02rc7-p1-amd64
  git checkout aa12d3381a1fd08e72f594147f2486c1b5ab7813

  git apply --stat %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool
  git apply --check --verbose %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool
  for %i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do kmk_sed -ne "/^---patch-00%i/,/^---patch/{/^---patch/d;p}" %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool > vbox-00%i.patch
  for %i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do git am --signoff vbox-00%i.patch

  cmd /c nmake /f Mkfiles/msvc.mak EMPTY=kmk_touch

  zip -9Xj ..\win.amd64.nasm.v3.02rc7-p1.zip nasm.exe ndisasm.exe %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool

Sketchy build steps for arm64:

  pushd %VBOXROOT%
  "tools/env.cmd"
  set VBOXROOT=%_CWD
  popd
  "%VBOXROOT%/tools/win/vcc/v14.3.17.11.5/env-arm64.cmd"
  "%VBOXROOT%/tools/win/sdk/v10.0.26100.3323/env-arm64.cmd" --ucrt

  git clone https://github.com/netwide-assembler/nasm.git git-nasm-3.02rc7-p1-arm64
  cd git-nasm-3.02rc7-p1-arm64
  git checkout aa12d3381a1fd08e72f594147f2486c1b5ab7813

  git apply --stat %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool
  git apply --check --verbose %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool
  for %i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do kmk_sed -ne "/^---patch-00%i/,/^---patch/{/^---patch/d;p}" %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool > vbox-00%i.patch
  for %i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do git am --signoff vbox-00%i.patch

  cmd /c nmake /f Mkfiles/msvc.mak EMPTY=kmk_touch

  zip -9Xj ..\win.arm64.nasm.v3.02rc7-p1.zip nasm.exe ndisasm.exe %VBOXROOT%\doc\tools\win.amd64\nasm\readme.tool

---patch-0001

From 7e7724f09864c597f5629e69f5ea80380db0052c Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 01:19:23 +0200
Subject: [PATCH 01/20] outcoff.c: Added support for 'function' type on global
 symbols.

Setting the symbol type is necessary for the control flow guard (CFG)
stuff on windows.
---
 output/outcoff.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/output/outcoff.c b/output/outcoff.c
index d38085d4..01a597de 100644
--- a/output/outcoff.c
+++ b/output/outcoff.c
@@ -539,9 +539,8 @@ static void coff_deflabel(char *name, int32_t segment, int64_t offset,
     int pos, section;
     struct coff_Symbol *sym;
 
-    if (special)
-        nasm_nonfatal("COFF format does not support any"
-                      " special symbol types");
+    nasm_debug(2, " coff_deflabel: %s, seg=%"PRIx32", off=%"PRIx64", is_global=%d, %s, coff_nsyms=%"PRIu32"\n",
+               name, segment, offset, is_global, special, coff_nsyms);
 
     if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
         if (strcmp(name,WRT_IMAGEBASE))
@@ -549,6 +548,9 @@ static void coff_deflabel(char *name, int32_t segment, int64_t offset,
         return;
     }
 
+    if (is_global == 3)    /* discard special-retry from pass two. */
+        return;
+
     if (segment == NO_SEG)
         section = -1;      /* absolute symbol */
     else {
@@ -598,6 +600,20 @@ static void coff_deflabel(char *name, int32_t segment, int64_t offset,
     else
         sym->value = (sym->section == 0 ? 0 : offset);
 
+    if (special) {
+        special = nasm_skip_spaces(special);
+        while (*special) {
+            const char *wend = nasm_skip_word(special);
+            size_t wlen = wend - special;
+            if (wlen == 8 && !nasm_strnicmp(special, "function", 8))
+                sym->type = 0x20; /* DT_FCN */
+            else
+                nasm_nonfatal("unrecognised symbol type `%*.*s' on `%s'",
+                              (int)wlen, (int)wlen, special, name);
+            special = nasm_skip_spaces(wend);
+        }
+    }
+
     /*
      * define the references from external-symbol segment numbers
      * to these symbol records.
-- 
2.47.0.windows.2

---patch-0002

From 7114c9d9b5b673f9e9e606e670dbd31431ecea03 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 01:36:56 +0200
Subject: [PATCH 02/20] outcoff.c: Prevent elimination of extern safeseh
 symbol.

Do a lookup of the symbol given to safeseh to prevent out_symdef() from
thinking it is unused.
---
 output/outcoff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/output/outcoff.c b/output/outcoff.c
index 01a597de..a1f5a2f2 100644
--- a/output/outcoff.c
+++ b/output/outcoff.c
@@ -916,6 +916,8 @@ coff_directives(enum directive directive, char *value)
     {
         static int sxseg=-1;
         int i;
+        int32_t ignseg;
+        int64_t ignoff;
 
         if (!win32) /* Only applicable for -f win32 */
             return DIRR_UNKNOWN;
@@ -923,6 +925,8 @@ coff_directives(enum directive directive, char *value)
         if (!value)
             return DIRR_OK;
 
+        lookup_label(value, &ignseg, &ignoff); /* prevent extern elimination */
+
         if (sxseg == -1) {
             for (i = 0; i < coff_nsects; i++)
                 if (!strcmp(".sxdata",coff_sects[i]->name))
-- 
2.47.0.windows.2

---patch-0003

From 8af3ee21aaa83e62cf5b89002b870fcde26fef16 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 01:41:27 +0200
Subject: [PATCH 03/20] nasmbli/file.c: Windows build fix/hack for Windows 11
 SDK.

---
 nasmlib/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/nasmlib/file.c b/nasmlib/file.c
index c8088326..cea3a33a 100644
--- a/nasmlib/file.c
+++ b/nasmlib/file.c
@@ -45,6 +45,7 @@
  */
 #ifdef _WIN32
 #include <wchar.h>
+#include <windows.h> /* stringapiset.h doesn't work without this in the w11 SDK. */
 #include <stringapiset.h>
 
 typedef wchar_t *os_filename;
-- 
2.47.0.windows.2

---patch-0004


From 3369ddf975a58002da6e0f160b87e059636f654b Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 13:57:13 +0200
Subject: [PATCH 04/20] msvc.mak: Define _CRT_DISABLE_PERFCRIT_LOCKS to avoid
 some stdio locking.

---
 Mkfiles/msvc.mak | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Mkfiles/msvc.mak b/Mkfiles/msvc.mak
index 4117df2e..3ba9c957 100644
--- a/Mkfiles/msvc.mak
+++ b/Mkfiles/msvc.mak
@@ -33,7 +33,7 @@ CC		= cl
 AR		= lib
 ARFLAGS		= /nologo
 
-CFLAGS		= $(OPTFLAGS) /Zi /nologo /std:c11 /bigobj
+CFLAGS		= $(OPTFLAGS) /Zi /nologo /std:c11 /bigobj /D_CRT_DISABLE_PERFCRIT_LOCKS
 BUILD_CFLAGS	= $(CFLAGS) /W2
 INTERNAL_CFLAGS = /I$(srcdir) /I. \
 		  /I$(srcdir)/include /I./include \
-- 
2.47.0.windows.2

---patch-0005

From 242745bdf8128bcb2c57488405cb0c410f2d72f7 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 13:58:51 +0200
Subject: [PATCH 05/20] eval.c: Recycle the temp expression allocs to speed
 things up.

---
 asm/eval.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/asm/eval.c b/asm/eval.c
index b4c7d3a3..62ea5231 100644
--- a/asm/eval.c
+++ b/asm/eval.c
@@ -20,11 +20,16 @@
 
 #define TEMPEXPRS_DELTA 128
 #define TEMPEXPR_DELTA 8
+#define TEMPEXPRS_KEEP
 
 static scanner scanfunc;        /* Address of scanner routine */
 static void *scpriv;            /* Scanner private pointer */
 
+#ifdef TEMPEXPRS_KEEP
+static struct { expr *array; int size; } *tempexprs = NULL;
+#else
 static expr **tempexprs = NULL;
+#endif
 static int ntempexprs;
 static int tempexprs_size = 0;
 
@@ -48,8 +53,13 @@ static int64_t deadman;
  */
 void eval_cleanup(void)
 {
+#ifdef TEMPEXPRS_KEEP
+    while (tempexprs_size > 0)
+        nasm_free(tempexprs[--tempexprs_size].array);
+#else
     while (ntempexprs)
         nasm_free(tempexprs[--ntempexprs]);
+#endif
     nasm_free(tempexprs);
 }
 
@@ -58,6 +68,18 @@ void eval_cleanup(void)
  */
 static void begintemp(void)
 {
+#ifdef TEMPEXPRS_KEEP
+    if ((unsigned)ntempexprs < (unsigned)tempexprs_size) {
+        tempexpr = tempexprs[ntempexprs].array;
+        if (tempexpr) {
+            tempexpr_size = tempexprs[ntempexprs].size;
+            tempexprs[ntempexprs].array = NULL;
+            tempexprs[ntempexprs].size  = 0;
+            ntempexpr = 0;
+            return;
+        }
+    }
+#endif
     tempexpr = NULL;
     tempexpr_size = ntempexpr = 0;
 }
@@ -77,11 +99,28 @@ static expr *finishtemp(void)
 {
     addtotemp(0L, 0L);          /* terminate */
     while (ntempexprs >= tempexprs_size) {
+#ifdef TEMPEXPRS_KEEP
+        int idx = tempexprs_size;
+#endif
         tempexprs_size += TEMPEXPRS_DELTA;
         tempexprs = nasm_realloc(tempexprs,
                                  tempexprs_size * sizeof(*tempexprs));
+#ifdef TEMPEXPRS_KEEP
+        while (idx < tempexprs_size) {
+            tempexprs[idx].array = NULL;
+            tempexprs[idx++].size = 0;
+        }
+#endif
     }
+#ifdef TEMPEXPRS_KEEP
+    if (tempexprs[ntempexprs].array)
+        nasm_free(tempexprs[ntempexprs].array);
+    tempexprs[ntempexprs].array = tempexpr;
+    tempexprs[ntempexprs++].size = tempexpr_size;
+    return tempexpr;
+#else
     return tempexprs[ntempexprs++] = tempexpr;
+#endif
 }
 
 /*
@@ -995,8 +1034,12 @@ expr *evaluate(scanner sc, void *scprivate, struct tokenval *tv,
     tokval = tv;
     opflags = fwref;
 
+#ifdef TEMPEXPRS_KEEP
+    ntempexprs = 0;             /* initialize temporary storage */
+#else
     while (ntempexprs)          /* initialize temporary storage */
         nasm_free(tempexprs[--ntempexprs]);
+#endif
 
     tt = tokval->t_type;
     if (tt == TOKEN_INVALID)
-- 
2.47.0.windows.2

---patch-0006

From 6592329e3eceacec81518ea89416bacdf68a2c1c Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 14:00:33 +0200
Subject: [PATCH 06/20] listing.c: fprintf is expensive on windows/ucrt, so
 format the listing line in a stack buffer by hand and call fwrite instead.
 This is a bit over the top, but it saves time on huge files.

---
 asm/listing.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/asm/listing.c b/asm/listing.c
index c0a64c56..32718b93 100644
--- a/asm/listing.c
+++ b/asm/listing.c
@@ -62,6 +62,78 @@ static void list_emit(void)
     const struct strlist_entry *e;
 
     if (listlinep || *listdata) {
+#if 1
+        static char const s_digits[] = "0123456789ABCDEF";
+        char line[LIST_MAX_LEN * 2];
+        size_t len;
+        int off;
+        unsigned lineno = (unsigned)listlineno;
+
+        if (lineno >= 100000) {
+            off = strlen(itoa(listlineno, line, 10));
+        } else {
+            line[0] = line[1] = line[2] = line[3] = line[4] = ' ';
+            if (lineno < 10) {
+                line[5] = s_digits[listlineno];
+            } else if (lineno < 100) {
+                line[4] = s_digits[listlineno / 10];
+                line[5] = s_digits[listlineno % 10];
+            } else {
+                off = (unsigned)listlineno < 1000  ? 3
+                    : (unsigned)listlineno < 10000 ? 2 : 1;
+                itoa(listlineno, &line[off], 10);
+            }
+            off = 6;
+        }
+        line[off++] = ' ';
+
+        if (listdata[0]) {
+            line[off++] = s_digits[(listoffset >> 28) & 0xf];
+            line[off++] = s_digits[(listoffset >> 24) & 0xf];
+            line[off++] = s_digits[(listoffset >> 20) & 0xf];
+            line[off++] = s_digits[(listoffset >> 16) & 0xf];
+            line[off++] = s_digits[(listoffset >> 12) & 0xf];
+            line[off++] = s_digits[(listoffset >>  8) & 0xf];
+            line[off++] = s_digits[(listoffset >>  4) & 0xf];
+            line[off++] = s_digits[ listoffset        & 0xf];
+            line[off++] = ' ';
+            len = strlen(listdata);
+            memcpy(&line[off], listdata, len);
+            off += len;
+            while (len++ < LIST_HEXBIT + 1)
+                line[off++] = ' ';
+        } else {
+            memset(&line[off], ' ', LIST_HEXBIT + 10);
+            off += LIST_HEXBIT + 10;
+        }
+
+        if (listlevel_e) {
+            if (listlevel < 10)
+                line[off++] = ' ';
+            line[off++] = '<';
+            if ((unsigned)listlevel_e < 10)
+                line[off++] = s_digits[listlevel_e];
+            else
+                off += strlen(itoa(listlevel_e, &line[off], 10));
+            line[off++] = '>';
+        } else if (listlinep) {
+            line[off++] = ' ';
+            line[off++] = ' ';
+            line[off++] = ' ';
+            line[off++] = ' ';
+        }
+
+        if (listlinep) {
+            len = strlen(listline);
+            line[off++] = ' ';
+            memcpy(&line[off], listline, len);
+            off += len;
+        }
+
+        line[off++] = '\n';
+        fwrite(line, off, 1, listfp);
+
+#else
         fprintf(listfp, "%6"PRId32" ", listlineno);
 
         if (listdata[0])
@@ -80,6 +152,7 @@ static void list_emit(void)
             fprintf(listfp, " %s", listline);
 
         putc('\n', listfp);
+#endif
         listlinep = false;
         listdata[0] = '\0';
     }
-- 
2.47.0.windows.2

---patch-0007

From 721a57f3b3359b0a5cd44bfed43c515edfecb26c Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 14:03:58 +0200
Subject: [PATCH 07/20] preproc.c: Enabled the token block allocator.

---
 asm/preproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/asm/preproc.c b/asm/preproc.c
index 776a5223..5c4e31aa 100644
--- a/asm/preproc.c
+++ b/asm/preproc.c
@@ -1939,7 +1939,7 @@ static Token *tokenize(const char *line)
  *
  * alloc_Token() returns a zero-initialized token structure.
  */
-#define TOKEN_BLOCKSIZE 0 /* 4096 */ /* Number of tokens, not bytes */
+#define TOKEN_BLOCKSIZE 4096 /* Number of tokens, not bytes */
 
 #if TOKEN_BLOCKSIZE
 
-- 
2.47.0.windows.2

---patch-0008

From 05922fb50fb92d8c23fe3acb390f3f6b9297c8c0 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 14:05:05 +0200
Subject: [PATCH 08/20] stdscan.c: Recycle the allocations in
 stdscan_tempstorage to speed things when processing large files.

---
 asm/stdscan.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/asm/stdscan.c b/asm/stdscan.c
index 6903b0ce..9dd68876 100644
--- a/asm/stdscan.c
+++ b/asm/stdscan.c
@@ -32,8 +32,17 @@ struct stdscan_state {
     enum stdscan_scan_state sstate;
 };
 
+#define STDSCAN_KEEP_ALLOC
+
 static struct stdscan_state scan;
+#ifdef STDSCAN_KEEP_ALLOC
+static struct stdscan_tempentry {
+    void *bufptr;
+    size_t bufsize;
+} *stdscan_tempstorage = NULL;
+#else
 static char **stdscan_tempstorage = NULL;
+#endif
 static int stdscan_tempsize = 0, stdscan_templen = 0;
 #define STDSCAN_TEMP_DELTA 256
 
@@ -58,7 +67,11 @@ char *stdscan_tell(void)
 
 static void stdscan_pop(void)
 {
+#ifdef STDSCAN_KEEP_ALLOC
+    --stdscan_templen;
+#else
     nasm_free(stdscan_tempstorage[--stdscan_templen]);
+#endif
 }
 
 static void stdscan_pushback_pop(void)
@@ -72,8 +85,12 @@ static void stdscan_pushback_pop(void)
 
 void stdscan_reset(char *buffer)
 {
+#ifdef STDSCAN_KEEP_ALLOC
+    stdscan_templen = 0;
+#else
     while (stdscan_templen > 0)
         stdscan_pop();
+#endif
 
     while (scan.pushback)
         stdscan_pushback_pop();
@@ -89,11 +106,34 @@ void stdscan_reset(char *buffer)
 void stdscan_cleanup(void)
 {
     stdscan_reset(NULL);
+#ifdef STDSCAN_KEEP_ALLOC
+    while (stdscan_tempsize > 0)
+        nasm_free(stdscan_tempstorage[--stdscan_tempsize].bufptr);
+#endif
     nasm_free(stdscan_tempstorage);
 }
 
 static void *stdscan_alloc(size_t bytes)
 {
+#ifdef STDSCAN_KEEP_ALLOC
+    int const idx = stdscan_templen;
+    void *buf;
+    if (idx >= stdscan_tempsize) {
+        stdscan_tempsize += STDSCAN_TEMP_DELTA;
+        stdscan_tempstorage = nasm_realloc(stdscan_tempstorage,
+                                           stdscan_tempsize *
+                                           sizeof(stdscan_tempstorage[0]));
+        nasm_zeron(&stdscan_tempstorage[idx], STDSCAN_TEMP_DELTA);
+    }
+    buf = stdscan_tempstorage[idx].bufptr;
+    if (bytes > stdscan_tempstorage[idx].bufsize) {
+        nasm_free(buf);
+        bytes = (bytes + 31) & ~(size_t)31;
+        stdscan_tempstorage[idx].bufsize = bytes;
+        stdscan_tempstorage[idx].bufptr  = buf = nasm_malloc(bytes);
+    }
+    stdscan_templen = idx + 1;
+#else
     void *buf = nasm_malloc(bytes);
     if (stdscan_templen >= stdscan_tempsize) {
         stdscan_tempsize += STDSCAN_TEMP_DELTA;
@@ -102,6 +142,7 @@ static void *stdscan_alloc(size_t bytes)
                                            sizeof(char *));
     }
     stdscan_tempstorage[stdscan_templen++] = buf;
+#endif
 
     return buf;
 }
-- 
2.47.0.windows.2

---patch-0009

From afd66f09289a2cb43f1b64805caf2f161261e8e3 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Mon, 11 May 2026 14:06:07 +0200
Subject: [PATCH 09/20] file.c: More aggressive output buffer on windows (not
 much impact).

---
 nasmlib/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/nasmlib/file.c b/nasmlib/file.c
index cea3a33a..6b7ae555 100644
--- a/nasmlib/file.c
+++ b/nasmlib/file.c
@@ -279,6 +279,9 @@ FILE *nasm_open_write(const char *filename, enum file_flags flags)
         setvbuf(f, NULL, _IOFBF, 0);
         break;
     default:
+#ifdef _MSC_VER /* More agressive buffering. */
+        setvbuf(f, NULL, _IOFBF, 0x10000);
+#endif
         break;
     }
 
-- 
2.47.0.windows.2

---patch-0010

From 9843040784278755a43008b3afd83f3baa2e512c Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Tue, 12 May 2026 03:40:59 +0200
Subject: [PATCH 10/20] alloc.c: Use lookaside lists to speed up allocations on
 Windows a little.

---
 asm/nasm.c        |   1 +
 include/nasmlib.h |   1 +
 nasmlib/alloc.c   | 270 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 272 insertions(+)

diff --git a/asm/nasm.c b/asm/nasm.c
index 5da8a820..96573d2d 100644
--- a/asm/nasm.c
+++ b/asm/nasm.c
@@ -795,6 +795,7 @@ int main(int argc, char **argv)
     stdscan_cleanup();
     src_free();
     strlist_free(&include_path);
+    lookaside_allocator_cleanup();
 
     return terminate_after_phase();
 }
diff --git a/include/nasmlib.h b/include/nasmlib.h
index 4d6eca4f..c36354e7 100644
--- a/include/nasmlib.h
+++ b/include/nasmlib.h
@@ -101,6 +101,7 @@ char * safe_alloc nasm_strdup(const char *);
 char * safe_alloc nasm_strndup(const char *, size_t);
 char * safe_alloc nasm_strcat(const char *one, const char *two);
 char * safe_alloc end_with_null nasm_strcatn(const char *one, ...);
+void lookaside_allocator_cleanup(void);
 
 /*
  * nasm_[v]asprintf() are variants of the semi-standard [v]asprintf()
diff --git a/nasmlib/alloc.c b/nasmlib/alloc.c
index 32e181e7..e39f3f02 100644
--- a/nasmlib/alloc.c
+++ b/nasmlib/alloc.c
@@ -10,6 +10,242 @@
 #include "error.h"
 #include "alloc.h"
 
+/*
+ * Lookaside allocator lists to avoid expensive heap operations.
+ *
+ * The heap can be very slow on Windows, try enable this to speed up
+ * assembling of large files.
+ *
+ * The principle is that we don't give memory back to the heap, but keep the
+ * allocations on various list according to their sizes.  When a new allocation
+ * request comes along, we check the corresponding list and return anything
+ * chained there before asking the heap.
+ *
+ * The current implemenation is extremely simple and does not have any
+ * safeguards against wasting loads of heap or what to do if we run out
+ * of memory.
+ */
+#if defined(_MSC_VER)
+# define USE_LOOKASIDE_ALLOC
+#endif
+#ifdef USE_LOOKASIDE_ALLOC
+
+/*# define LOOKASIDE_STATS*/
+
+/** Header that precedes every allocation. */
+struct lookaside_hdr
+{
+    struct lookaside_hdr *next;
+    size_t size;
+};
+# define LOOKASIDE_CACHE_HDR_NEXT_IN_USE ((struct lookaside_hdr *)(intptr_t)0xbeeff00d)
+# define LOOKASIDE_CACHE_HDR_NEXT_FREED  ((struct lookaside_hdr *)(intptr_t)0xdeadbeef)
+
+/** Number of allocation lists. */
+# define LOOKASIDE_NUM_LISTS    256
+/** The lookaside lists - One list for one size range. */
+static struct lookaside_list {
+    struct lookaside_hdr *head; /* chain of free (unused) allocations. */
+# ifdef LOOKASIDE_STATS
+    size_t nfree;
+    size_t ntotal; /* number of alloc calls. */
+# endif
+} lookaside_lists[LOOKASIDE_NUM_LISTS];
+
+# ifdef LOOKASIDE_STATS
+static size_t lookaside_too_large = 0;
+static size_t lookaside_too_large_total_bytes = 0;
+# endif
+
+static size_t lookaside_round_size(size_t size)
+{
+    if (size < 256)
+        return size ? (size + 15) & ~(size_t)15 : 16;
+    /* [16..] - by 64. */
+    return (size + 63) & ~(size_t)63;
+}
+
+static size_t lookaside_index_to_size(size_t idx)
+{
+    if (idx < 16)
+        return (idx + 1) * 16;
+    return (idx - 16) * 64 + 256;
+}
+
+static size_t lookaside_size_to_index(size_t size)
+{
+    /* [0..15] - by 16. */
+    if (size < 256)
+        return size ? ((size + 15) / 16) - 1 : 0;
+    /* [16..] - by 64. */
+    return ((size + 63) / 64) + 16 - 256 / 64;
+}
+
+# ifdef DEBUG
+static bool lookaside_sanity_checked = false;
+
+/* Does sanitiy checking of the three above functions.*/
+static void lookaside_santiy_check(void)
+{
+    size_t size;
+    for (size = 0; size < 32678; size++) {
+        size_t const size_rounded  = lookaside_round_size(size);
+        size_t const idx           = lookaside_size_to_index(size);
+        size_t const size_form_idx = lookaside_index_to_size(idx);
+        nasm_assert(size_rounded == size_form_idx && size <= size_rounded);
+    }
+    for (size = 0; size <= 32; size++) {
+        size_t const idx = lookaside_size_to_index(size);
+        nasm_assert(idx == (size > 16));
+    }
+    lookaside_sanity_checked = true;
+}
+#endif /* DEBUG*/
+
+static void *lookaside_alloc(size_t size)
+{
+    struct lookaside_hdr *hdr;
+    size_t idx = lookaside_size_to_index(size);
+# ifdef DEBUG
+    if (!lookaside_sanity_checked)
+        lookaside_sanity_check();
+# endif
+
+    if (idx < LOOKASIDE_NUM_LISTS) {
+        hdr = lookaside_lists[idx].head;
+        if (hdr) {
+            size = lookaside_index_to_size(idx);
+            nasm_assert(hdr->size == size);
+# ifdef LOOKASIDE_STATS
+            lookaside_lists[idx].nfree--;
+            lookaside_lists[idx].ntotal++;
+# endif
+            lookaside_lists[idx].head = hdr->next;
+            hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
+            return hdr + 1;
+        }
+    }
+# ifdef LOOKASIDE_STATS
+    else {
+        lookaside_too_large++;
+        lookaside_too_large_total_bytes += size;
+    }
+# endif
+
+    size = lookaside_index_to_size(idx);
+    hdr = malloc(sizeof(*hdr) + size);
+    if (hdr) {
+        hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
+        hdr->size = size;
+        return hdr + 1;
+    }
+
+    nasm_critical("out of memory!");
+    return NULL;
+}
+
+static void *lookaside_zalloc(size_t size)
+{
+    struct lookaside_hdr *hdr;
+    size_t idx = lookaside_size_to_index(size);
+# ifdef DEBUG
+    if (!lookaside_sanity_checked)
+        lookaside_sanity_check();
+# endif
+
+    if (idx < LOOKASIDE_NUM_LISTS) {
+        hdr = lookaside_lists[idx].head;
+        if (hdr) {
+            size = lookaside_index_to_size(idx);
+            nasm_assert(hdr->size == size);
+# ifdef LOOKASIDE_STATS
+            lookaside_lists[idx].nfree--;
+            lookaside_lists[idx].ntotal++;
+# endif
+            lookaside_lists[idx].head = hdr->next;
+            hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
+            return memset(hdr + 1, 0, size);
+        }
+    }
+# ifdef LOOKASIDE_STATS
+    else {
+        lookaside_too_large++;
+        lookaside_too_large_total_bytes +=size;
+    }
+# endif
+
+    size = lookaside_index_to_size(idx);
+    hdr = calloc(sizeof(*hdr) + size, 1);
+    if (hdr) {
+        hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
+        hdr->size = size;
+        return hdr + 1;
+    }
+
+    nasm_critical("out of memory!");
+    return NULL;
+}
+
+static void lookaside_free(void *user)
+{
+    struct lookaside_hdr * const hdr = (struct lookaside_hdr *)user - 1;
+    size_t idx;
+    nasm_assert(hdr->next == LOOKASIDE_CACHE_HDR_NEXT_IN_USE);
+    nasm_assert(!(hdr->size & 15));
+    idx = lookaside_size_to_index(hdr->size);
+    if (idx < LOOKASIDE_NUM_LISTS) {
+        hdr->next = lookaside_lists[idx].head;
+        lookaside_lists[idx].head = hdr;
+# ifdef LOOKASIDE_STATS
+        lookaside_lists[idx].nfree++;
+# endif
+    } else {
+        hdr->next = LOOKASIDE_CACHE_HDR_NEXT_FREED;
+        free(hdr);
+    }
+}
+#endif /* USE_LOOKASIDE_ALLOC */
+
+void lookaside_allocator_cleanup(void)
+{
+#ifdef USE_LOOKASIDE_ALLOC
+    size_t idx;
+# ifdef LOOKASIDE_STATS
+    size_t cur_user_byte     = 0;
+    size_t cur_nheaders      = 0;
+    size_t total_user_bytes  = 0;
+    size_t total_nallocs     = 0;
+    fprintf(stderr, "allocation stats:\n");
+    for (idx = 0; idx < LOOKASIDE_NUM_LISTS; idx++) {
+        if (lookaside_lists[idx].ntotal != 0) {
+            size_t const size = lookaside_index_to_size(idx);
+            total_user_bytes  += lookaside_lists[idx].ntotal * size;
+            total_nallocs     += lookaside_lists[idx].ntotal;
+            cur_user_byte     += lookaside_lists[idx].nfree * size;
+            cur_nheaders      += lookaside_lists[idx].nfree;
+            fprintf(stderr, " #%zu - %zu bytes - nfree=%zu ntotal=%zu (%zu)\n",
+                    idx, size, lookaside_lists[idx].nfree, lookaside_lists[idx].ntotal,
+                    lookaside_lists[idx].ntotal * size);
+        }
+    }
+    fprintf(stderr, " total: free: %zu bytes in %zu units; total: %zu bytes in %zu alloc calls\n",
+            cur_user_byte, cur_nheaders, total_user_bytes, total_nallocs);
+    fprintf(stderr, " %zu allocations were too large (%zu bytes)\n",
+            lookaside_too_large, lookaside_too_large_total_bytes);
+#endif
+    for (idx = 0; idx < LOOKASIDE_NUM_LISTS; idx++) {
+        struct lookaside_hdr *cur = lookaside_lists[idx].head;
+        while (cur) {
+            struct lookaside_hdr *next = cur->next;
+            free(cur);
+            cur = next;
+        }
+        lookaside_lists[idx].head = NULL;
+    }
+#endif /* USE_LOOKASIDE_ALLOC */
+}
+
+
 size_t _nasm_last_string_size;
 
 fatal_func nasm_alloc_failed(void)
@@ -19,6 +255,9 @@ fatal_func nasm_alloc_failed(void)
 
 void *nasm_malloc(size_t size)
 {
+#ifdef USE_LOOKASIDE_ALLOC
+    return lookaside_alloc(size);
+#else
     void *p;
 
 again:
@@ -32,10 +271,14 @@ again:
         nasm_alloc_failed();
     }
     return p;
+#endif
 }
 
 void *nasm_calloc(size_t nelem, size_t size)
 {
+#ifdef USE_LOOKASIDE_ALLOC
+    return lookaside_zalloc(nelem * size); /** @todo overflow check */
+#else
     void *p;
 
 again:
@@ -50,11 +293,16 @@ again:
     }
 
     return p;
+#endif
 }
 
 void *nasm_zalloc(size_t size)
 {
+#ifdef USE_LOOKASIDE_ALLOC
+    return lookaside_zalloc(size);
+#else
     return nasm_calloc(size, 1);
+#endif
 }
 
 /*
@@ -66,16 +314,38 @@ void *nasm_zalloc(size_t size)
  */
 void *nasm_realloc(void *q, size_t size)
 {
+#ifdef USE_LOOKASIDE_ALLOC
+    if (q) {
+        struct lookaside_hdr *hdr = (struct lookaside_hdr *)q - 1;
+        nasm_assert(hdr->next == LOOKASIDE_CACHE_HDR_NEXT_IN_USE);
+        nasm_assert(!(hdr->size & 15));
+        size = lookaside_round_size(size);
+        if (hdr->size == size)
+            return hdr + 1;
+        hdr = (struct lookaside_hdr *)realloc(hdr, sizeof(*hdr) + size);
+        if (!hdr)
+            nasm_critical("out of memory!");
+        hdr->size = size;
+        return hdr + 1;
+    }
+    return lookaside_alloc(size);
+
+#else
     if (unlikely(!size))
         size = 1;
     q = q ? realloc(q, size) : malloc(size);
     return validate_ptr(q);
+#endif
 }
 
 void nasm_free(void *q)
 {
     if (q)
+#ifdef USE_LOOKASIDE_ALLOC
+        lookaside_free(q);
+#else
         free(q);
+#endif
 }
 
 char *nasm_strdup(const char *s)
-- 
2.47.0.windows.2

---patch-0011

From 9a4ac295287d2de61b409e6718296f25c7551fc1 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Wed, 13 May 2026 00:17:15 +0200
Subject: [PATCH 11/20] outcoff.c: dd symbol wrt ..symtab

Added a special symbol ..symtab for emitting the COFF symbol table
index of a symbol rather than some kind of address.  For use with ehcont
metadata and possible other stuff.
---
 doc/lang.src       |  3 +-
 doc/outfmt.src     | 10 ++++++
 output/outcoff.c   | 87 ++++++++++++++++++++++++++++++++++++++++++++--
 output/pecoff.h    |  8 +++++
 test/wrtsymtab.asm | 79 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+), 4 deletions(-)
 create mode 100644 test/wrtsymtab.asm

diff --git a/doc/lang.src b/doc/lang.src
index de389a8b..d76fa3c1 100644
--- a/doc/lang.src
+++ b/doc/lang.src
@@ -992,6 +992,7 @@ NASM has the capacity to define other special symbols beginning with
 a double period: for example, \c{..start} is used to specify the
 entry point in the \c{obj} output format (see \k{dotdotstart}),
 \c{..imagebase} is used to find out the offset from a base address
-of the current image in the \c{win64} output format (see \k{win64pic}).
+of the current image in the \c{win64} output format (see \k{win64pic}),
+\c{..symtab} is used to emit the COFF symbol table index (see \k{win32wrt}).
 So just keep in mind that symbols beginning with a double period are
 special.
diff --git a/doc/outfmt.src b/doc/outfmt.src
index b67382f3..63cfafbf 100644
--- a/doc/outfmt.src
+++ b/doc/outfmt.src
@@ -759,6 +759,16 @@ data for "safe exception handler table" causes no backward
 incompatibilities and "safeseh" modules generated by NASM 2.03 and
 later can still be linked by earlier versions or non-Microsoft linkers.
 
+\S{win32wrt} \c{win32}: Special Symbol and WRT
+
+The Microsoft linker may require symbol table indexes instead of absolute or
+image relative addresses in some more modern structures, like those used for
+exception handler control flow guard metadata (ehcont).  This can be
+accomplished by getting the symbol address with respect to the special
+\c{..symtab} symbol.  For instance:
+
+\c __guard_ehcont_main: dd main.cont wrt ..symtab
+
 \S{codeview} Debugging formats for Windows
 \I{Windows debugging formats}
 
diff --git a/output/outcoff.c b/output/outcoff.c
index a1f5a2f2..117331f2 100644
--- a/output/outcoff.c
+++ b/output/outcoff.c
@@ -74,6 +74,9 @@ bool win32, win64;
 static int32_t imagebase_sect;
 #define WRT_IMAGEBASE "..imagebase"
 
+static int32_t symtab_sect;
+#define WRT_SYMTAB    "..symtab"
+
 /*
  * Some common section flags by default
  */
@@ -192,6 +195,8 @@ static void coff_gen_init(void)
     coff_strs = saa_init(1);
     strslen = 0;
     def_seg = seg_alloc();
+    symtab_sect = seg_alloc()+1;
+    backend_label(WRT_SYMTAB, symtab_sect, 0);
 }
 
 static void coff_cleanup(void)
@@ -210,6 +215,11 @@ static void coff_cleanup(void)
             coff_sects[i]->head = coff_sects[i]->head->next;
             nasm_free(r);
         }
+        while (coff_sects[i]->symidx_reloc_head) {
+            struct coff_SymIdxReloc * const ir = coff_sects[i]->symidx_reloc_head;
+            coff_sects[i]->symidx_reloc_head = ir->next;
+            nasm_free(ir);
+        }
         nasm_free(coff_sects[i]->name);
         nasm_free(coff_sects[i]->comdat_name);
         nasm_free(coff_sects[i]);
@@ -543,7 +553,7 @@ static void coff_deflabel(char *name, int32_t segment, int64_t offset,
                name, segment, offset, is_global, special, coff_nsyms);
 
     if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
-        if (strcmp(name,WRT_IMAGEBASE))
+        if (strcmp(name,WRT_IMAGEBASE) && strcmp(name, WRT_SYMTAB))
             nasm_nonfatal("unrecognized special symbol `%s'", name);
         return;
     }
@@ -665,6 +675,50 @@ static int32_t coff_add_reloc(struct coff_Section *sect, int32_t segment,
     return 0;
 }
 
+/* Helper for coff_out handling wrt ..symtab addressing. */
+static uint32_t coff_out_get_symbol_idx(int32_t tsegment, int64_t offset)
+{
+    /* No better way of doing this? */
+    int section;
+    if (tsegment == NO_SEG) {
+        section = -1;
+    } else {
+        for (section = 0; section < coff_nsects; section++)
+            if (tsegment == coff_sects[section]->index)
+                break;
+        section++;
+    }
+
+    /* Do symbol table lookup (unless it is external). */
+    if (section <= coff_nsects) {
+        uint32_t symidx = UINT32_MAX;
+        int n;
+        saa_rewind(coff_syms);
+        for (n = 0; n < coff_nsyms; n++) {
+            struct coff_Symbol *sym = saa_rstruct(coff_syms);
+            nasm_try_static_assert(sizeof(sym->value) == sizeof(int32_t));
+            if (sym->section == section && sym->value == (int32_t)offset) {
+                if (sym->type & 0x30) /* N_TMASK */
+                    return n; /* Prefer symbol with non-NULL type. */
+                if (symidx == UINT32_MAX)
+                    symidx = n;
+            }
+        }
+        if (symidx == UINT32_MAX)
+            nasm_nonfatal("wrt ..symtab: Unable to find symbol for %s:%#" PRIx64,
+                          section > 0 ? coff_sects[section - 1]->name : "ABS", offset);
+        return symidx;
+    }
+
+    /* External symbols. */
+    if (tsegment != NO_SEG)
+        return raa_read(bsym, tsegment);
+
+    nasm_nonfatal("wrt ..symtab: Unable to find symbol for %#"PRIx32":%#" PRIx64,
+                  tsegment, offset);
+    return UINT32_MAX;
+}
+
 static void coff_out(const struct out_data *out)
 {
     OUT_LEGACY(out,segto,data,type,size,segment,wrt);
@@ -672,7 +726,7 @@ static void coff_out(const struct out_data *out)
     uint8_t mydata[8], *p;
     int i;
 
-    if (wrt != NO_SEG && !win64) {
+    if (wrt != NO_SEG && wrt != symtab_sect && !win64) {
         wrt = NO_SEG;           /* continue to do _something_ */
         nasm_nonfatal("WRT not supported by COFF output formats");
     }
@@ -732,7 +786,25 @@ static void coff_out(const struct out_data *out)
         coff_sect_write(s, data, size);
     } else if (type == OUT_ADDRESS) {
         int asize = abs((int)size);
-        if (!win64) {
+        if (wrt == symtab_sect) {
+            /* Emit internal fixup since the table starts with sections and
+               stuff that can be added to after this statement.  */
+            struct coff_SymIdxReloc *ir;
+            nasm_new(ir);
+            ir->offset = s->len;
+            ir->size = (uint8_t)asize;
+            ir->symbol = coff_out_get_symbol_idx(segment, out->toffset);
+            ir->next = s->symidx_reloc_head;
+            s->symidx_reloc_head = ir;
+            nasm_assert(asize <= sizeof(mydata));
+            coff_sect_write(s, mydata, asize);
+            if (asize > 4)
+                nasm_warn(WARN_OTHER, "zero extending 'wrt "WRT_SYMTAB
+                          "' (32-bit) to %u-bit", asize * 8);
+            else if (asize < 4)
+                nasm_warn(WARN_OTHER, "truncating 'wrt "WRT_SYMTAB
+                          "' (32-bit) to %u-bit", asize * 8);
+        } else if (!win64) {
             if (asize != 4 && (segment != NO_SEG || wrt != NO_SEG)) {
                 nasm_nonfatal("COFF format does not support non-32-bit"
                               " relocations");
@@ -1122,6 +1194,15 @@ static void coff_write(void)
      */
     for (i = 0; i < coff_nsects; i++)
         if (coff_sects[i]->data) {
+            /* Apply symbol table index fixups before writing */
+            struct coff_SymIdxReloc *ir;
+            for (ir = coff_sects[i]->symidx_reloc_head; ir; ir = ir->next) {
+                uint8_t mydata[4];
+                setu32(mydata, ir->symbol + initsym);
+                saa_fwrite(coff_sects[i]->data, ir->offset,
+                           mydata, ir->size >= 4 ? 4 : ir->size);
+            }
+
             saa_fpwrite(coff_sects[i]->data, ofile);
             coff_write_relocs(coff_sects[i]);
 
diff --git a/output/pecoff.h b/output/pecoff.h
index 9fe4145d..63a805a0 100644
--- a/output/pecoff.h
+++ b/output/pecoff.h
@@ -457,6 +457,7 @@ struct coff_Section {
     int32_t namepos;            /* Offset of name into the strings table */
     int32_t pos, relpos;
     int64_t pass_last_seen;
+    struct coff_SymIdxReloc *symidx_reloc_head;
 
     /* comdat-related members */
     char *comdat_name;
@@ -478,6 +479,13 @@ struct coff_Reloc {
     int16_t type;
 };
 
+struct coff_SymIdxReloc {
+    struct coff_SymIdxReloc *next;
+    uint32_t symbol;            /* symbol number */
+    uint32_t offset;            /* byte offset into the secetion. */
+    uint32_t size;              /* the size of the area to fix up */
+};
+
 struct coff_Symbol {
     char name[9];
     int32_t strpos;             /* string table position of name */
diff --git a/test/wrtsymtab.asm b/test/wrtsymtab.asm
new file mode 100644
index 00000000..ff49b39b
--- /dev/null
+++ b/test/wrtsymtab.asm
@@ -0,0 +1,79 @@
+;Testname=win32;  Arguments=-fwin32  -owrtsymtab.o -Ox; Files=stdout stderr wrtsymtab.o
+;Testname=win64;  Arguments=-fwin64  -owrtsymtab.o -Ox; Files=stdout stderr wrtsymtab.o
+
+; Just some symbols & code to work with.
+abs_sym1 equ 0x12345678
+
+section .text
+extern   extrn_sym_unused
+required extrn_sym1
+mysymbol1:
+        ret
+        int3
+        int3
+mysymbol2:
+        ret
+        int3
+mysymbol3_private:
+.start_of_prolog:
+mysymbol3:
+global mysymbol3:function
+        ret
+
+oddsym1:
+        ret
+
+required extrn_sym2
+required extrn_sym3
+extern   extrn_sym4
+
+section .data
+abs_sym2 equ 0x91929394
+
+section .rodata rdata
+        ; Various uses with DD
+        db      '  mysymbol1:'
+        dd      mysymbol1 wrt ..symtab
+        db      ' extrn_sym1:'
+        dd      extrn_sym1 wrt ..symtab
+        db      '   abs_sym1:'
+        dd      abs_sym1 wrt ..symtab
+
+        db      '  mysymbol2:'
+        dd      mysymbol2 wrt ..symtab
+        db      ' extrn_sym2:'
+        dd      extrn_sym2 wrt ..symtab
+        db      '   abs_sym2:'
+        dd      abs_sym2 wrt ..symtab
+
+        db      ' extrn_sym3:'
+        dd      extrn_sym3 wrt ..symtab
+        db      '  mysymbol3:'
+        dd      mysymbol3 wrt ..symtab
+        db      ' extrn_sym4:'
+        dd      extrn_sym4 wrt ..symtab
+
+        ; Uses with DB, DW, DD and DQ. Will generate warnings.
+        db      '    db oddsym1:'
+        db      oddsym1 wrt ..symtab
+        db      '   dw oddsym1:'
+        dw      oddsym1 wrt ..symtab
+        db      ' dd oddsym1:'
+        dd      oddsym1 wrt ..symtab    ; ok, no warning
+        db      'dq same:'
+        dq      oddsym1 wrt ..symtab
+
+; a little closer to real life use.
+section gehcont$y align=4 rdata
+__guard_ehcont_main: dd main.cont wrt ..symtab
+
+section .text
+global main:function
+main:
+        call    mysymbol3
+        xor     eax, eax
+        ret
+.cont:
+        mov     eax, -1
+        ret
+
-- 
2.47.0.windows.2

---patch-0012

From f99106054f2a9ad799167a3b0af954a39643c290 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Wed, 13 May 2026 00:30:21 +0200
Subject: [PATCH 12/20] outcoff.c: fix warnings

---
 output/outcoff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/output/outcoff.c b/output/outcoff.c
index 117331f2..adcaf3a4 100644
--- a/output/outcoff.c
+++ b/output/outcoff.c
@@ -691,8 +691,7 @@ static uint32_t coff_out_get_symbol_idx(int32_t tsegment, int64_t offset)
 
     /* Do symbol table lookup (unless it is external). */
     if (section <= coff_nsects) {
-        uint32_t symidx = UINT32_MAX;
-        int n;
+        uint32_t n, symidx = UINT32_MAX;
         saa_rewind(coff_syms);
         for (n = 0; n < coff_nsyms; n++) {
             struct coff_Symbol *sym = saa_rstruct(coff_syms);
@@ -796,7 +795,7 @@ static void coff_out(const struct out_data *out)
             ir->symbol = coff_out_get_symbol_idx(segment, out->toffset);
             ir->next = s->symidx_reloc_head;
             s->symidx_reloc_head = ir;
-            nasm_assert(asize <= sizeof(mydata));
+            nasm_assert((unsigned)asize <= sizeof(mydata));
             coff_sect_write(s, mydata, asize);
             if (asize > 4)
                 nasm_warn(WARN_OTHER, "zero extending 'wrt "WRT_SYMTAB
-- 
2.47.0.windows.2

---patch-0013

From 085b7dea9bd6c16f187910d84121401d1b5766d5 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Wed, 13 May 2026 00:31:42 +0200
Subject: [PATCH 13/20] listing.c: only do crazy list_emit() optimizations for
 MSC (no itoa on linux)

---
 asm/listing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/asm/listing.c b/asm/listing.c
index 32718b93..fd88a1f1 100644
--- a/asm/listing.c
+++ b/asm/listing.c
@@ -62,7 +62,7 @@ static void list_emit(void)
     const struct strlist_entry *e;
 
     if (listlinep || *listdata) {
-#if 1
+#ifdef _MSC_VER
         static char const s_digits[] = "0123456789ABCDEF";
         char line[LIST_MAX_LEN * 2];
         size_t len;
-- 
2.47.0.windows.2

---patch-0014

From 69e994b55ae7680eebc12931359206844ee6ae6b Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Wed, 13 May 2026 01:07:42 +0200
Subject: [PATCH 14/20] test/wrtsymtab.asm: reproducible

---
 test/wrtsymtab.asm | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/wrtsymtab.asm b/test/wrtsymtab.asm
index ff49b39b..d069672d 100644
--- a/test/wrtsymtab.asm
+++ b/test/wrtsymtab.asm
@@ -1,5 +1,5 @@
-;Testname=win32;  Arguments=-fwin32  -owrtsymtab.o -Ox; Files=stdout stderr wrtsymtab.o
-;Testname=win64;  Arguments=-fwin64  -owrtsymtab.o -Ox; Files=stdout stderr wrtsymtab.o
+;Testname=win32;  Arguments=-fwin32  -owrtsymtab.o -Ox --reproducible; Files=stdout stderr wrtsymtab.o
+;Testname=win64;  Arguments=-fwin64  -owrtsymtab.o -Ox --reproducible; Files=stdout stderr wrtsymtab.o
 
 ; Just some symbols & code to work with.
 abs_sym1 equ 0x12345678
-- 
2.47.0.windows.2

---patch-0015

From 5ae714f49692e5e79f5e7515fbea956826a4999f Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Wed, 13 May 2026 01:32:20 +0200
Subject: [PATCH 15/20] doc/outfmt.src: Documented the 'function' win32/64
 extension to the global, extern and static directives.

---
 doc/outfmt.src | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/doc/outfmt.src b/doc/outfmt.src
index 63cfafbf..bf12fc65 100644
--- a/doc/outfmt.src
+++ b/doc/outfmt.src
@@ -769,6 +769,20 @@ accomplished by getting the symbol address with respect to the special
 
 \c __guard_ehcont_main: dd main.cont wrt ..symtab
 
+\S{win32glob} \c{win32} Extensions to the \c{GLOBAL}, \c{EXTERN} and \c{STATIC} Directives\I{GLOBAL,
+win32 extensions to}\I{EXTERN, win32 extensions to}\I{STATIC, win32 extensions to}
+
+You can specify whether a symbol is a function by suffixing the name
+with a colon and the word \i\c{function}. For example:
+
+\c global   hashlookup:function
+\c static   localfunc:function
+\c extern   extfunc:function
+
+The linker may use this extra symbol information when generating tables of
+valid indirect branch targets and such.
+
+
 \S{codeview} Debugging formats for Windows
 \I{Windows debugging formats}
 
-- 
2.47.0.windows.2

---patch-0016

From b1b3cc77458ad9bbdc3abb686dea667ccc91f5ad Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Kacper=20Michaj=C5=82ow?= <kasper93@gmail.com>
Date: Mon, 30 Mar 2026 19:02:19 +0200
Subject: [PATCH 16/20] output/codeview: don't panic when there is not code
 section
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Simply skip the tables that require code section and source information.

Fixes: https://github.com/netwide-assembler/nasm/issues/216
Fixes: https://github.com/netwide-assembler/nasm/pull/178#issuecomment-4156226648
Signed-off-by: Kacper Michajłow <kasper93@gmail.com>
Signed-off-by: knut st. osmundsen <bird-nasm@anduin.net>
---
 output/codeview.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/output/codeview.c b/output/codeview.c
index 8266cc43..017685e9 100644
--- a/output/codeview.c
+++ b/output/codeview.c
@@ -759,12 +759,14 @@ static void build_symbol_table(struct coff_Section *const sect)
 {
     section_write32(sect, 0x00000004);
 
-    write_filename_table(sect);
-    align4_table(sect);
-    write_sourcefile_table(sect);
-    align4_table(sect);
-    write_linenumber_table(sect);
-    align4_table(sect);
+    if (cv8_state.source_files) {
+        write_filename_table(sect);
+        align4_table(sect);
+        write_sourcefile_table(sect);
+        align4_table(sect);
+        write_linenumber_table(sect);
+        align4_table(sect);
+    }
     write_symbolinfo_table(sect);
     align4_table(sect);
 }
-- 
2.47.0.windows.2

---patch-0017

From fde377775e59d04b390152d4dd8d344a8f23cc57 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Thu, 14 May 2026 00:51:26 +0200
Subject: [PATCH 17/20] realpath.c,alloc.c: nasm_realpath must not return
 direct heap allocation when USE_LOOKASIDE_ALLOC is in effect, but always use
 the nasm heap wrapper routines.

---
 Mkfiles/msvc.mak   |  2 +-
 nasmlib/alloc.c    |  3 ---
 nasmlib/realpath.c | 21 +++++++++++++++++++++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/Mkfiles/msvc.mak b/Mkfiles/msvc.mak
index 3ba9c957..b3016cdc 100644
--- a/Mkfiles/msvc.mak
+++ b/Mkfiles/msvc.mak
@@ -33,7 +33,7 @@ CC		= cl
 AR		= lib
 ARFLAGS		= /nologo
 
-CFLAGS		= $(OPTFLAGS) /Zi /nologo /std:c11 /bigobj /D_CRT_DISABLE_PERFCRIT_LOCKS
+CFLAGS		= $(OPTFLAGS) /Zi /nologo /std:c11 /bigobj /D_CRT_DISABLE_PERFCRIT_LOCKS /DUSE_LOOKASIDE_ALLOC
 BUILD_CFLAGS	= $(CFLAGS) /W2
 INTERNAL_CFLAGS = /I$(srcdir) /I. \
 		  /I$(srcdir)/include /I./include \
diff --git a/nasmlib/alloc.c b/nasmlib/alloc.c
index e39f3f02..5dec3eef 100644
--- a/nasmlib/alloc.c
+++ b/nasmlib/alloc.c
@@ -25,9 +25,6 @@
  * safeguards against wasting loads of heap or what to do if we run out
  * of memory.
  */
-#if defined(_MSC_VER)
-# define USE_LOOKASIDE_ALLOC
-#endif
 #ifdef USE_LOOKASIDE_ALLOC
 
 /*# define LOOKASIDE_STATS*/
diff --git a/nasmlib/realpath.c b/nasmlib/realpath.c
index 8ba0b0e9..183a1739 100644
--- a/nasmlib/realpath.c
+++ b/nasmlib/realpath.c
@@ -26,6 +26,13 @@
 char *nasm_realpath(const char *rel_path)
 {
     char *rp = canonicalize_file_name(rel_path);
+# ifdef USE_LOOKASIDE_ALLOC
+    if (rp) {
+        char *ret = nasm_strdup(rp); /* must return nasmlib/alloc.c alloc. */
+        free(rp);
+        return ret;
+    }
+# endif
     return rp ? rp : nasm_strdup(rel_path);
 }
 
@@ -73,6 +80,13 @@ char *nasm_realpath(const char *rel_path)
             rp = nasm_realloc(rp, strlen(rp) + 1);
         }
     }
+# ifdef USE_LOOKASIDE_ALLOC
+    else if (rp) {
+        char *ret = nasm_strdup(rp); /* must return nasmlib/alloc.c alloc. */
+        free(rp);
+        return ret;
+    }
+# endif
 
     return rp ? rp : nasm_strdup(rel_path);
 }
@@ -86,6 +100,13 @@ char *nasm_realpath(const char *rel_path)
 char *nasm_realpath(const char *rel_path)
 {
     char *rp = _fullpath(NULL, rel_path, 0);
+# ifdef USE_LOOKASIDE_ALLOC
+    if (rp) {
+        char *ret = nasm_strdup(rp); /* must return nasmlib/alloc.c alloc. */
+        free(rp);
+        return ret;
+    }
+# endif
     return rp ? rp : nasm_strdup(rel_path);
 }
 
-- 
2.47.0.windows.2

---patch-0018

From 3e46d7f064d3e4504ad162891f68fc9049f9c2f4 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Thu, 14 May 2026 01:26:48 +0200
Subject: [PATCH 18/20] file.c: Long filename support for windows.

---
 nasmlib/file.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/nasmlib/file.c b/nasmlib/file.c
index 6b7ae555..f28ce3f6 100644
--- a/nasmlib/file.c
+++ b/nasmlib/file.c
@@ -51,8 +51,18 @@
 typedef wchar_t *os_filename;
 typedef wchar_t  os_fopenflag;
 
+static bool is_unc_name(wchar_t const *path)
+{
+    /* starts with exactly two slashes and a server name. */
+    return (path[0] == L'\\' || path[0] == L'/')
+        && (path[1] == L'\\' || path[1] == L'/')
+        && (path[2] != L'\\' && path[2] != L'/' && path[2] != '\0');
+}
+
 static os_filename os_mangle_filename(const char *filename)
 {
+    static wchar_t const longpfx[] = L"\\\\?\\";
+    static const size_t cwclongpfx = sizeof(longpfx) / sizeof(wchar_t) - 1;
     size_t wclen;
     wchar_t *buf;
 
@@ -71,6 +81,31 @@ static os_filename os_mangle_filename(const char *filename)
         return NULL;
     }
 
+    /* If the length exceeds 260 and there is no \\?\ prefix, convert it to an
+       absolute (full) path and add the passthru-prefix. */
+    if (wclen >= 260 && wcsncmp(buf, longpfx, cwclongpfx) != 0) {
+        wclen = GetFullPathNameW(buf, 0, NULL, NULL);
+        if (wclen > 0) {
+            static wchar_t const uncpfx[] = L"\\\\?\\UNC";
+            static wchar_t const cwcuncpfx = sizeof(uncpfx) / sizeof(wchar_t) - 1;
+            wchar_t *buf2 = (wchar_t *)nasm_malloc((wclen + 1 + cwcuncpfx) << 1);
+            memcpy(buf2, longpfx, sizeof(longpfx));
+            wclen = GetFullPathNameW(buf, wclen + 1, &buf2[cwclongpfx], NULL);
+            if (wclen) {
+                nasm_free(buf);
+                buf = buf2;
+                if (is_unc_name(&buf2[cwclongpfx])) {
+                    /* \\?\\\server\share -> \\?\UNC\server\share */
+                    memmove(&buf2[cwcuncpfx], &buf2[cwclongpfx + 1],
+                            wclen * sizeof(*buf2));
+                    memcpy(buf2, uncpfx, cwcuncpfx * sizeof(*buf2));
+                }
+            } else {
+                nasm_free(buf2);
+            }
+        }
+    }
+
     return buf;
 }
 
-- 
2.47.0.windows.2

---patch-0019

From 39cdba0e8d59f37447763a9300471a4efa0e4058 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Thu, 14 May 2026 01:33:27 +0200
Subject: [PATCH 19/20] file.c: Don't call setvbuf with f=NULL, as it cause
 nasm abend on windows due to UCRT panic.

---
 nasmlib/file.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/nasmlib/file.c b/nasmlib/file.c
index f28ce3f6..edfe9e53 100644
--- a/nasmlib/file.c
+++ b/nasmlib/file.c
@@ -303,21 +303,23 @@ FILE *nasm_open_write(const char *filename, enum file_flags flags)
         nasm_fatalf(ERR_NOFILE, "unable to open output file: `%s': %s",
                     filename, strerror(errno));
 
-    switch (flags & NF_BUF_MASK) {
-    case NF_IONBF:
-        setvbuf(f, NULL, _IONBF, 0);
-        break;
-    case NF_IOLBF:
-        setvbuf(f, NULL, _IOLBF, 0);
-        break;
-    case NF_IOFBF:
-        setvbuf(f, NULL, _IOFBF, 0);
-        break;
-    default:
+    if (f) {
+        switch (flags & NF_BUF_MASK) {
+        case NF_IONBF:
+            setvbuf(f, NULL, _IONBF, 0);
+            break;
+        case NF_IOLBF:
+            setvbuf(f, NULL, _IOLBF, 0);
+            break;
+        case NF_IOFBF:
+            setvbuf(f, NULL, _IOFBF, 0);
+            break;
+        default:
 #ifdef _MSC_VER /* More agressive buffering. */
-        setvbuf(f, NULL, _IOFBF, 0x10000);
+            setvbuf(f, NULL, _IOFBF, 0x10000);
 #endif
-        break;
+            break;
+        }
     }
 
     return f;
-- 
2.47.0.windows.2

---patch-0020

From 90034a273ceb31367996e75a2c14f6198b25f679 Mon Sep 17 00:00:00 2001
From: "knut st. osmundsen" <bird-nasm@anduin.net>
Date: Thu, 14 May 2026 01:48:19 +0200
Subject: [PATCH 20/20] file.c: Need to consider the full path length as well
 as the input path length when checking for the 260 path length limit.

---
 nasmlib/file.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/nasmlib/file.c b/nasmlib/file.c
index edfe9e53..17b31002 100644
--- a/nasmlib/file.c
+++ b/nasmlib/file.c
@@ -62,7 +62,7 @@ static bool is_unc_name(wchar_t const *path)
 static os_filename os_mangle_filename(const char *filename)
 {
     static wchar_t const longpfx[] = L"\\\\?\\";
-    static const size_t cwclongpfx = sizeof(longpfx) / sizeof(wchar_t) - 1;
+    static const size_t longpfx_len = sizeof(longpfx) / sizeof(wchar_t) - 1;
     size_t wclen;
     wchar_t *buf;
 
@@ -81,28 +81,28 @@ static os_filename os_mangle_filename(const char *filename)
         return NULL;
     }
 
-    /* If the length exceeds 260 and there is no \\?\ prefix, convert it to an
-       absolute (full) path and add the passthru-prefix. */
-    if (wclen >= 260 && wcsncmp(buf, longpfx, cwclongpfx) != 0) {
-        wclen = GetFullPathNameW(buf, 0, NULL, NULL);
-        if (wclen > 0) {
+    /* Prefix long file names. Mind, the 260 limitation is on the full path
+       and not just the relative path. */
+    if (wcsncmp(buf, longpfx, longpfx_len) != 0) {
+        size_t wclenabs = GetFullPathNameW(buf, 0, NULL, NULL);
+        if (wclen >= 260 || wclenabs >= 260) {
             static wchar_t const uncpfx[] = L"\\\\?\\UNC";
-            static wchar_t const cwcuncpfx = sizeof(uncpfx) / sizeof(wchar_t) - 1;
-            wchar_t *buf2 = (wchar_t *)nasm_malloc((wclen + 1 + cwcuncpfx) << 1);
+            static size_t const uncpfx_len = sizeof(uncpfx) / sizeof(wchar_t) - 1;
+            wchar_t *buf2 = (wchar_t *)nasm_malloc((wclenabs + 1 + uncpfx_len) << 1);
+
             memcpy(buf2, longpfx, sizeof(longpfx));
-            wclen = GetFullPathNameW(buf, wclen + 1, &buf2[cwclongpfx], NULL);
-            if (wclen) {
-                nasm_free(buf);
-                buf = buf2;
-                if (is_unc_name(&buf2[cwclongpfx])) {
+            wclenabs = GetFullPathNameW(buf, wclenabs + 1, &buf2[longpfx_len], NULL);
+            if (wclenabs) {
+                if (is_unc_name(&buf2[longpfx_len])) {
                     /* \\?\\\server\share -> \\?\UNC\server\share */
-                    memmove(&buf2[cwcuncpfx], &buf2[cwclongpfx + 1],
-                            wclen * sizeof(*buf2));
-                    memcpy(buf2, uncpfx, cwcuncpfx * sizeof(*buf2));
+                    memmove(&buf2[uncpfx_len], &buf2[longpfx_len + 1],
+                            wclenabs * sizeof(*buf2));
+                    memcpy(buf2, uncpfx, uncpfx_len * sizeof(*buf2));
                 }
-            } else {
-                nasm_free(buf2);
+                nasm_free(buf);
+                return buf2;
             }
+            nasm_free(buf2);
         }
     }
 
-- 
2.47.0.windows.2

---patch-end

