// Use the debugstr string helpers.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: The _w version most likely doesn't works, needs tests.

@@
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel;
expression E;
constant C;
@@
(
 dbg
|
 dbg_(channel)
)
       (...,
-            E ? E : C
+            debugstr_a(E)
 , ... )


@@
typedef WCHAR, LPCWSTR, LPWSTR;
identifier dbg =~ "^(WINE_)?(ERR|FIXME|trace|TRACE|WARN)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression E;
{WCHAR *, LPCWSTR, LPWSTR} wstr;
@@
(
 dbg
|
 dbg_(channel)
|
 trace_(file, line)
)
       (...,
-            E ? E : wstr
+            debugstr_w(E)
 , ... )
