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
position p;
@@
- WCHAR lvar[]@p = { \('\0'\|0\) };


@@
identifier empty.lvar;
@@
- lvar
+ L""


@r@
typedef LOGFONTW, WCHAR;
identifier lvar;
initializer list chs;
position p;
type T;
@@
(
 WCHAR lvar[]@p = { chs, \('\0'\|0\) };
|
 WCHAR *lvar@p = { chs, \('\0'\|0\) };
|
 LOGFONTW lvar@p = { ..., { chs, \('\0'\|0\) } };
|
 T lvar[]@p = { ..., { ..., {..., { chs, \('\0'\|0\) }}, ... }, ...};
)


@script:python u@
lvar << r.lvar;
chs << r.chs;
p << r.p;
wstr;
@@
coccinelle.wstr = 'L"' + "".join(map(lambda x: x[1:-1], chs)) + '"'
#print(lvar, chs)
#print(lvar, coccinelle.wstr)


@@
identifier r.lvar;
identifier u.wstr;
initializer list r.chs;
position r.p;
type T;
@@
(
 WCHAR lvar[]@p =
-                 { chs, \('\0'\|0\) }
+                 wstr
                  ;
|
 WCHAR *lvar@p =
-                { chs, \('\0'\|0\) }
+                wstr
                 ;
|
 LOGFONTW lvar@p = { ...,
-                       { chs, \('\0'\|0\) }
+                       wstr
                   };
|
 T lvar[]@p = { ..., {..., {...,
-                       { chs, \('\0'\|0\) }
+                       wstr
                   }, ...}, ... };
)
