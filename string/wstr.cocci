// Convert WCHAR strings from old style array initialization to L"string".
// Also remove no longer needed variables holding those strings.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes --include-headers --smpl-spacing


@initialize:python@
@@
def array2wstr(chs):
    return  'L"' + "".join(map(lambda x: x[1:-1], chs)) + '"'


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
type T;
@@
(
 LOGFONTW lvar = { ..., { chs, \('\0'\|0\) } };
|
 T lvar[] = { ..., { ..., { ..., { chs, \('\0'\|0\) } }, ... }, ...};
)


@script:python Ls@
chs << rs.chs;
wstr;
@@
coccinelle.wstr = array2wstr(chs)


@@
identifier rs.lvar;
identifier Ls.wstr;
type T;
@@
(
 LOGFONTW lvar = { ...,
-                       { ... }
+                       wstr
                   };
|
 T lvar[] = { ..., {..., {...,
-                       { ... }
+                       wstr
                   }, ...}, ... };
)


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


@single@
identifier rv.lvar;
identifier Lv.wstr;
@@
  ... when != lvar
- lvar
+ wstr
  ... when != lvar


@depends on single@
identifier rv.lvar;
@@
(
- WCHAR lvar[] = ...;
|
- WCHAR *lvar = ...;
)


@@
identifier rv.lvar;
identifier Lv.wstr;
@@
(
 WCHAR lvar[] =
-                 { ... }
+                 wstr
                  ;
|
 WCHAR *lvar =
-                { ... }
+                wstr
                 ;
)
