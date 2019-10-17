// Convert WCHAR strings from old style array initialization to L"string".
// Also remove no longer needed variables holding those strings.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes --include-headers

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


@r@
typedef LOGFONTW, WCHAR;
identifier lvar;
initializer list chs;
type T;
@@
(
 WCHAR lvar[] = { chs, \('\0'\|0\) };
|
 WCHAR *lvar = { chs, \('\0'\|0\) };
|
 LOGFONTW lvar = { ..., { chs, \('\0'\|0\) } };
|
 T lvar[] = { ..., { ..., {..., { chs, \('\0'\|0\) }}, ... }, ...};
)


@script:python L@
lvar << r.lvar;
chs << r.chs;
wstr;
@@
coccinelle.wstr = 'L"' + "".join(map(lambda x: x[1:-1], chs)) + '"'
#print(lvar, chs)
#print(lvar, coccinelle.wstr)


@@
identifier r.lvar;
identifier L.wstr;
type T;
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
|
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
