// Convert WCHAR strings from old style array initialization to L"string".
// Also remove no longer needed variables holding those strings.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --include-headers --smpl-spacing

virtual constify
virtual no_array
virtual no_empty
virtual no_final
virtual no_simple
virtual no_single


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
            if i < 7:
                s += '\\' + str(i)
            elif i == 7:
                s += '\\a'
            elif i == 8:
                s += '\\b'
            elif i == 9:
                s += '\\t'
            elif i == 10:
                s += '\\n'
            elif i == 11:
                s += '\\v'
            elif i == 12:
                s += '\\f'
            elif i == 13:
                s += '\\r'
            else:
                s += '\\x%04x' % (i)
    return s + '"'


// Always remove variables holding the empty string
@empty depends on !no_empty@
typedef WCHAR;
identifier lvar;
@@
(
- WCHAR lvar[] = { \('\0'\|0\) };
|
- WCHAR lvar[1] = { \('\0'\|0\) };
|
- WCHAR *lvar = { \('\0'\|0\) };
)


@@
identifier empty.lvar;
@@
- lvar
+ L""


@empty2 depends on !no_empty@
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
@ra depends on !no_array@
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


// Constify WCHAR strings. Most of the time this is wrong.
// Defaults to off.
@depends on constify disable optional_qualifier@
identifier lvar;
initializer list chs;
@@
(
+ const
  WCHAR lvar[] = { chs, \('\0'\|0\) };
|
+ const
  WCHAR *lvar = { chs, \('\0'\|0\) };
)


// Inline simple strings
@r1 depends on !no_simple@
identifier lvar;
initializer list chs;
@@
(
 const WCHAR lvar[] = { chs, \('\0'\|0\) };
|
 const WCHAR *lvar = { chs, \('\0'\|0\) };
)


@script:python L1@
chs << r1.chs;
wstr;
@@
if len(chs.elements) == 1:
    coccinelle.wstr = array2wstr(chs)
else:
    cocci.include_match(False)


@simple@
identifier r1.lvar;
identifier L1.wstr;
@@
- lvar
+ wstr


@depends on simple@
identifier r1.lvar;
initializer list r1.chs;
@@
(
- WCHAR lvar[] = { chs, \('\0'\|0\) };
|
- WCHAR *lvar = { chs, \('\0'\|0\) };
)


// Remove single use variables
@rv depends on !no_single disable optional_qualifier@
identifier lvar;
initializer list chs;
@@
(
 const WCHAR lvar[] = { chs, \('\0'\|0\) };
|
 const WCHAR *lvar = { chs, \('\0'\|0\) };
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


// Finally replace the remaining WCHAR arrays
@rf depends on !no_final@
identifier lvar;
initializer list chs;
@@
(
 WCHAR lvar[] = { chs, \('\0'\|0\) };
|
 WCHAR *lvar = { chs, \('\0'\|0\) };
)


@script:python Lf@
chs << rf.chs;
wstr;
@@
coccinelle.wstr = array2wstr(chs)


@@
identifier rf.lvar;
identifier Lf.wstr;
initializer list rf.chs;
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
