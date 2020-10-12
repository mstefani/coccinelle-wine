// Convert WCHAR strings from old style array initialization to L"string".
// Also remove no longer needed variables holding those strings.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes --include-headers --smpl-spacing


@initialize:python@
@@
def array2wstr(chs):
    s = 'L"'
    for c in chs:
        if c[0] == "'":
            c = c[1:-1]
            if c == r"\'":
                c = "'"
            elif c == '"':
                c = r'\"'
            s += c
        else:
            if c.startswith('0x'):
                i = int(c, 16)
            elif c.startswith('0'):
                i = int(c, 8)
            elif c.isnumeric():
                i = int(c)
            else:
                # Define, variable, ... skip
                cocci.include_match(False)
                return
            if i < 10:
                s += '\\' + str(i)
            else:
                s += '\\x%04x' % (i)
    return s + '"'


// Always remove variables holding the empty string
@empty@
typedef WCHAR;
identifier lvar;
@@
(
- WCHAR lvar[] = { \('\0'\|0\) };
|
- WCHAR *lvar = { \('\0'\|0\) };
)


@@
identifier empty.lvar;
@@
- lvar
+ L""


@empty2@
identifier lvar;
@@
- WCHAR lvar = \('\0'\|0\);
  <+...
- &lvar
+ L""
  ...+>


// Initialization of structs
@rs@
typedef LOGFONTW;
identifier lvar;
initializer list chs;
@@
 LOGFONTW lvar = { ..., { chs, \('\0'\|0\) } };


@script:python Ls@
chs << rs.chs;
wstr;
@@
coccinelle.wstr = array2wstr(chs)


@@
identifier rs.lvar;
identifier Ls.wstr;
initializer list rs.chs;
@@
 LOGFONTW lvar = { ...,
-                       { chs, \('\0'\|0\) }
+                       wstr
                   };


// Array of arrays
@ra@
identifier lvar;
initializer list chs;
initializer list[n] elem;
@@
 WCHAR lvar[...][...] = { elem, { chs, \('\0'\|0\) }, ... };


@script:python La@
chs << ra.chs;
wstr;
@@
coccinelle.wstr = array2wstr(chs)


@@
identifier ra.lvar;
identifier La.wstr;
initializer list[ra.n] ra.elem;
@@
   WCHAR lvar[...][...] = { elem,
-                              { ... }
++                             wstr
                            , ... };


// Remove single use variables
@rv@
identifier lvar;
initializer list chs;
@@
(
 WCHAR lvar[] = { chs, \('\0'\|0\) };
|
 WCHAR *lvar = { chs, \('\0'\|0\) };
)


@script:python Lv@
chs << rv.chs;
wstr;
@@
coccinelle.wstr = array2wstr(chs)


@single exists@
identifier rv.lvar;
identifier Lv.wstr;
@@
   ... when != lvar
(
(
-  memcmp
+  lstrcmpW
|
-  memcpy
+  lstrcpyW
)
           (...,
-                lvar
+                wstr
-                    , sizeof(lvar)
           )
|
-  lvar
++ wstr
)
   ... when != lvar


@depends on single@
identifier rv.lvar;
initializer list rv.chs;
@@
(
- WCHAR lvar[] = { chs, \('\0'\|0\) };
|
- WCHAR *lvar = { chs, \('\0'\|0\) };
)


@@
identifier rv.lvar;
identifier Lv.wstr;
initializer list rv.chs;
@@
(
  WCHAR lvar[] =
-                { chs, \('\0'\|0\) }
+                wstr
                 ;
|
  WCHAR *lvar =
-                { chs, \('\0'\|0\) }
+                wstr
                 ;
)
