// Use SectRect() and variants instead of open conding them.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --recursive-includes --include-headers-for-types
// Comments: FIXME: SetRect cannot be used from all places. This produces false positives.

@@
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


@@
expression E;
@@
- SetRect
+ SetRectEmpty
         (E,
-            0, 0, 0, 0
         )
