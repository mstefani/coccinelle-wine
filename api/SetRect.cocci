// Use SectRect() and variants instead of open conding them.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --recursive-includes --include-headers-for-types
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
- rect.left = l;
(
- rect.top = t;
- rect.right = r;
|
- rect.right = r;
- rect.top = t;
)
- rect.bottom = b;
+ SetRect(&rect, l, t, r, b);


@ depends on !skip @
RECT rect;
expression l, t, b;
@@
- rect.left = l;
- rect.top = t;
- rect.right = rect.bottom = b;
+ SetRect(&rect, l, t, b, b);


@ depends on !skip @
RECT rect;
expression t, r, b;
@@
- rect.left = rect.top = t;
- rect.right = r;
- rect.bottom = b;
+ SetRect(&rect, t, t, r, b);


@ depends on !skip @
RECT rect;
expression t, b;
@@
- rect.left = rect.top = t;
- rect.right = rect.bottom = b;
+ SetRect(&rect, t, t, b, b);


@ depends on !skip @
RECT rect;
expression l, b;
@@
- rect.left = l;
- rect.top = rect.right = rect.bottom = b;
+ SetRect(&rect, l, b, b, b);


@ depends on !skip @
RECT rect;
expression b;
@@
- rect.left = rect.top = rect.right = rect.bottom = b;
+ SetRect(&rect, b, b, b, b);


@ depends on !skip @
expression E;
@@
- SetRect
+ SetRectEmpty
         (E,
-            0, 0, 0, 0
         )
