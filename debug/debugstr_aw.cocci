// Use the debugstr string helpers.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: The _w version most likely doesn't works, needs tests.

virtual report


@initialize:python@
@@
def WARN(pos, aw):
    print("%s:%s: Warning: In function %s use debugstr_%s() to trace a potential NULL string" % (pos.file, pos.line, pos.current_element, aw), flush=True)


@ a @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel;
expression E;
constant C;
position p;
@@
(
 dbg
|
 dbg_(channel)
)
       (...,
-            E@p ? E : C
+            debugstr_a(E)
 , ... )


@script:python depends on report@
p << a.p;
@@
WARN(p[0], "a")


@ w @
typedef WCHAR, LPCWSTR, LPWSTR;
identifier dbg =~ "^(WINE_)?(ERR|FIXME|trace|TRACE|WARN)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression E;
{WCHAR *, LPCWSTR, LPWSTR} wstr;
position p;
@@
(
 dbg
|
 dbg_(channel)
|
 trace_(file, line)
)
       (...,
-            E@p ? E : wstr
+            debugstr_w(E)
 , ... )


@script:python depends on report@
p << w.p;
@@
WARN(p[0], "w")
