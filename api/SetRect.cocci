// Use SetRect() and variants instead of open conding them.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --recursive-includes
// Comments: FIXME: SetRect cannot be used from all places. This produces false positives.

using "../assign.iso"

@ skip @
@@
#include "gdi_private.h"

@ depends on !skip @
typedef RECT;
typedef LPRECT;
RECT rect;
expression l, t, r, b;
@@
(
- rect.left = l; rect.top = t; rect.right = r; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect.left = l; rect.top = t; rect.bottom = b; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect.left = l; rect.right = r; rect.top = t; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect.left = l; rect.right = r; rect.bottom = b; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect.left = l; rect.bottom = b; rect.top = t; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect.left = l; rect.bottom = b; rect.right = r; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect.top = t; rect.left = l; rect.right = r; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect.top = t; rect.left = l; rect.bottom = b; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect.top = t; rect.right = r; rect.left = l; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect.top = t; rect.right = r; rect.bottom = b; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect.top = t; rect.bottom = b; rect.left = l; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect.top = t; rect.bottom = b; rect.right = r; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect.right = r; rect.left = l; rect.top = t; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect.right = r; rect.left = l; rect.bottom = b; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect.right = r; rect.top = t; rect.left = l; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect.right = r; rect.top = t; rect.bottom = b; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect.right = r; rect.bottom = b; rect.left = l; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect.right = r; rect.bottom = b; rect.top = t; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect.bottom = b; rect.left = l; rect.top = t; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect.bottom = b; rect.left = l; rect.right = r; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect.bottom = b; rect.top = t; rect.left = l; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect.bottom = b; rect.top = t; rect.right = r; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect.bottom = b; rect.right = r; rect.left = l; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect.bottom = b; rect.right = r; rect.top = t; rect.left = l;
+ SetRect(&rect, l, t, r, b);
)


@ depends on !skip disable ptr_to_array @
RECT *rect;
expression l, t, r, b;
@@
(
- rect->left = l; rect->top = t; rect->right = r; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect->left = l; rect->top = t; rect->bottom = b; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect->left = l; rect->right = r; rect->top = t; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect->left = l; rect->right = r; rect->bottom = b; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect->left = l; rect->bottom = b; rect->top = t; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect->left = l; rect->bottom = b; rect->right = r; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect->top = t; rect->left = l; rect->right = r; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect->top = t; rect->left = l; rect->bottom = b; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect->top = t; rect->right = r; rect->left = l; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect->top = t; rect->right = r; rect->bottom = b; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect->top = t; rect->bottom = b; rect->left = l; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect->top = t; rect->bottom = b; rect->right = r; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect->right = r; rect->left = l; rect->top = t; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect->right = r; rect->left = l; rect->bottom = b; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect->right = r; rect->top = t; rect->left = l; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect->right = r; rect->top = t; rect->bottom = b; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect->right = r; rect->bottom = b; rect->left = l; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect->right = r; rect->bottom = b; rect->top = t; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect->bottom = b; rect->left = l; rect->top = t; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect->bottom = b; rect->left = l; rect->right = r; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect->bottom = b; rect->top = t; rect->left = l; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect->bottom = b; rect->top = t; rect->right = r; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect->bottom = b; rect->right = r; rect->left = l; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect->bottom = b; rect->right = r; rect->top = t; rect->left = l;
+ SetRect(rect, l, t, r, b);
)


@ depends on !skip @
RECT rect;
expression l, t, b;
@@
- rect.left = l;
- rect.top = t;
- rect.right = rect.bottom = b;
+ SetRect(&rect, l, t, b, b);


@ depends on !skip disable ptr_to_array @
RECT *rect;
expression l, t, b;
@@
- rect->left = l;
- rect->top = t;
- rect->right = rect->bottom = b;
+ SetRect(rect, l, t, b, b);


@ depends on !skip @
RECT rect;
expression t, r, b;
@@
- rect.left = rect.top = t;
- rect.right = r;
- rect.bottom = b;
+ SetRect(&rect, t, t, r, b);


@ depends on !skip disable ptr_to_array @
RECT *rect;
expression t, r, b;
@@
- rect->left = rect->top = t;
- rect->right = r;
- rect->bottom = b;
+ SetRect(rect, t, t, r, b);


@ depends on !skip @
RECT rect;
expression t, b;
@@
- rect.left = rect.top = t;
- rect.right = rect.bottom = b;
+ SetRect(&rect, t, t, b, b);


@ depends on !skip disable ptr_to_array @
RECT *rect;
expression t, b;
@@
- rect->left = rect->top = t;
- rect->right = rect->bottom = b;
+ SetRect(rect, t, t, b, b);


@ depends on !skip @
RECT rect;
expression l, b;
@@
- rect.left = l;
- rect.top = rect.right = rect.bottom = b;
+ SetRect(&rect, l, b, b, b);


@ depends on !skip disable ptr_to_array @
RECT *rect;
expression l, b;
@@
- rect->left = l;
- rect->top = rect->right = rect->bottom = b;
+ SetRect(rect, l, b, b, b);


@ depends on !skip @
RECT rect;
expression b;
@@
- rect.left = rect.top = rect.right = rect.bottom = b;
+ SetRect(&rect, b, b, b, b);


@ depends on !skip disable ptr_to_array @
RECT *rect;
expression b;
@@
- rect->left = rect->top = rect->right = rect->bottom = b;
+ SetRect(rect, b, b, b, b);


// SetRect() calls that should be something else
@@
expression rect;
@@
- SetRect
+ SetRectEmpty
         (rect,
-            0, 0, 0, 0
         )


@@
expression r1;
RECT r2;
RECT *r3;
@@
(
- SetRect(&r1, r2.left, r2.top, r2.right, r2.bottom)
+ r1 = r2
|
- SetRect(&r1, r3->left, r3->top, r3->right, r3->bottom)
+ r1 = *r3
|
- SetRect(r1, r2.left, r2.top, r2.right, r2.bottom)
+ *r1 = r2
|
- SetRect(r1, r3->left, r3->top, r3->right, r3->bottom)
+ *r1 = *r3
)


// Sanity check to not use an RECT field in the SetRect.
@ disable ptr_to_array @
expression rect;
identifier fld;
@@
(
  SetRect(&rect, ...,
-                     <+... rect.fld ...+>
+                     BADBADBAD
                                ,...)
|
  SetRect(&rect, ...,
-                     <+... rect.fld ...+>
+                     BADBADBAD
                                )
|
  SetRect(rect, ...,
-                     <+... rect->fld ...+>
+                     BADBADBAD
                                ,...)
|
  SetRect(rect, ...,
-                     <+... rect->fld ...+>
+                     BADBADBAD
                                )
)
