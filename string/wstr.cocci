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
ustr;
@@
coccinelle.ustr = 'u"' + "".join(map(lambda x: x[1:-1], chs)) + '"'
#print(lvar, chs)
#print(lvar, coccinelle.ustr)


@@
identifier r.lvar;
identifier u.ustr;
initializer list r.chs;
position r.p;
type T;
@@
(
 WCHAR lvar[]@p =
-                 { chs, \('\0'\|0\) }
+                 ustr
                  ;
|
 WCHAR *lvar@p =
-                { chs, \('\0'\|0\) }
+                ustr
                 ;
|
 LOGFONTW lvar@p = { ...,
-                       { chs, \('\0'\|0\) }
+                       ustr
                   };
|
 T lvar[]@p = { ..., {..., {...,
-                       { chs, \('\0'\|0\) }
+                       ustr
                   }, ...}, ... };
)
