// Use the wine_dbgstr_rect helper instead of open coding it.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: Make use of the new format string support from coccinelle.

@ disable ptr_to_array @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression r;
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
-       r->left, r->top, r->right, r->bottom
+       wine_dbgstr_rect(r)
 , ... )


@@
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN|ok|trace)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel, file, line;
expression r;
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
-       r.left, r.top, r.right, r.bottom
+       wine_dbgstr_rect(&r)
 , ... )


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
position rr.pr;
@@
(
 fn(..., r.right@pr, ...,
-        r.bottom
+        wine_dbgstr_rect(&r)
                   , ...)
|
 fn(...,
-        r.bottom
+        wine_dbgstr_rect(&r)
                   , ..., r.right@pr, ...)
|
 fn(..., r->right@pr, ...,
-        r->bottom
+        wine_dbgstr_rect(r)
                   , ...)
|
 fn(...,
-        r->bottom
+        wine_dbgstr_rect(r)
                   , ..., r->right@pr, ...)
)
