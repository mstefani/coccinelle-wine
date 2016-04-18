// Use the wine_dbgstr_rect helper instead of open coding it.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: Make use of the new format string support from coccinelle.

@ disable ptr_to_array @
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel;
expression r;
@@
(
 dbg
|
 dbg_(channel)
)
       (...,
-       r->left, r->top, r->right, r->bottom
+       wine_dbgstr_rect(r)
 , ... )


@@
identifier dbg =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)$";
identifier dbg_ =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel;
expression r;
@@
(
 dbg
|
 dbg_(channel)
)
       (...,
-       r.left, r.top, r.right, r.bottom
+       wine_dbgstr_rect(&r)
 , ... )
