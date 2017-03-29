// Use the wine_dbgstr_rect helper instead of open coding it.
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
    print("%s:%s: Warning: In function %s use wine_dbgstr_rect() instead of open coding it" % (pos.file, pos.line, pos.current_element), flush=True)


@ r1 disable ptr_to_array @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression r;
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
-       r@p->left, r->top, r->right, r->bottom
+       wine_dbgstr_rect(r)
 , ... )


@script:python depends on report@
p << r1.p;
@@
WARN(p[0])


@ r2 @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression r;
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
-       r@p.left, r.top, r.right, r.bottom
+       wine_dbgstr_rect(&r)
 , ... )


@script:python depends on report@
p << r2.p;
@@
WARN(p[0])


// Detect RECT fields specified out of the natural order.
@ rl disable ptr_to_array @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression r;
position pl;
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
       (..., \(r.left@pl\|r->left@pl\), ... )


@ rt disable ptr_to_array @
expression rl.r;
identifier fn;
position rl.pl;
position pt;
@@
(
 fn(..., r.left@pl, ..., r.top@pt, ...)
|
 fn(..., r.top@pt, ..., r.left@pl, ...)
|
 fn(..., r->left@pl, ..., r->top@pt, ...)
|
 fn(..., r->top@pt, ..., r->left@pl, ...)
)

@ rr disable ptr_to_array @
expression rl.r;
identifier fn;
position rt.pt;
position pr;
@@
(
 fn(..., r.top@pt, ..., r.right@pr, ...)
|
 fn(..., r.right@pr, ..., r.top@pt, ...)
|
 fn(..., r->top@pt, ..., r->right@pr, ...)
|
 fn(..., r->right@pr, ..., r->top@pt, ...)
)


@ rb disable ptr_to_array @
expression rl.r;
identifier fn;
position rr.pr, p;
@@
(
 fn(..., r.right@pr, ...,
-        r@p.bottom
+        wine_dbgstr_rect(&r)
                   , ...)
|
 fn(...,
-        r@p.bottom
+        wine_dbgstr_rect(&r)
                   , ..., r.right@pr, ...)
|
 fn(..., r->right@pr, ...,
-        r@p->bottom
+        wine_dbgstr_rect(r)
                   , ...)
|
 fn(...,
-        r@p->bottom
+        wine_dbgstr_rect(r)
                   , ..., r->right@pr, ...)
)


@script:python depends on report@
p << rb.p;
@@
WARN(p[0])
