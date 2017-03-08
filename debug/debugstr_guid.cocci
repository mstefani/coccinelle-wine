// Use the debugstr_guid() helper to trace GUIDs.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: Make use of the new format string support from coccinelle.

virtual report


@initialize:python@
@@
import re

def WARN(pos):
    func = "debugstr_guid"
    if re.match(r"/tests/", pos.file):
        func = "wine_dbgstr_guid"
    msg = "In function " + pos.current_element + ": Use " + func + "() to trace GUIDs"
    print("%s:%s: Warning: %s" % (pos.file, pos.line, msg), flush=True)


@ open1 disable ptr_to_array @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace|)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression E;
position p;
@@
(
 dbg
|
 dbg_(channel)
|
 ok_(file, line)
|
 trace_(file, line)
)
       (...,
-       E@p->Data1, E->Data2, E->Data3, E->Data4[0], E->Data4[1], E->Data4[2],
-       E->Data4[3], E->Data4[4], E->Data4[5], E->Data4[6], E->Data4[7]
+       debugstr_guid(E)
 , ... )


@ script:python depends on report @
p << open1.p;
@@
WARN(p[0])


@ open2 @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression E;
position p;
@@
(
 dbg
|
 dbg_(channel)
|
 ok_(file, line)
|
 trace_(file, line)
)
       (...,
-       E@p.Data1, E.Data2, E.Data3, E.Data4[0], E.Data4[1], E.Data4[2],
-       E.Data4[3], E.Data4[4], E.Data4[5], E.Data4[6], E.Data4[7]
+       debugstr_guid(&E)
 , ... )


@ script:python depends on report @
p << open2.p;
@@
WARN(p[0])


@ missing @
typedef CLSID;
typedef GUID;
typedef LPCGUID;
typedef LPCLSID;
typedef LPGUID;
typedef IID;
typedef REFCLSID;
typedef REFIID;
typedef WICPixelFormatGUID;
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace|)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
{CLSID*, LPCLSID, REFCLSID, IID*, REFIID, const GUID*, LPGUID, LPCGUID, WICPixelFormatGUID*} guid;
expression E;
position p;
@@
(
 dbg
|
 dbg_(channel)
|
 ok_(file, line)
|
 trace_(file, line)
)
       (...,
+       debugstr_guid(
                      guid@p
+                    )
 , ... )
 ... when != *guid = E


@ script:python depends on report @
p << missing.p;
@@
WARN(p[0])


@ test @
@@
 #include "wine/test.h"


@ depends on test && !report @
@@
- debugstr_guid
+ wine_dbgstr_guid
                  (...)
