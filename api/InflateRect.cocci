// Use InflateRect() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --recursive-includes --include-headers-for-types
// Comments: FIXME: InflateRect cannot be used from all places. This produces false positives.

@ skip @
@@
#include "gdi_private.h"

@ depends on !skip @
expression rect, x, y;
@@
(
- rect.left -= x; rect.top -= y; rect.right += x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect.left -= x; rect.top -= y; rect.bottom += y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect.left -= x; rect.right += x; rect.top -= y; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect.left -= x; rect.right += x; rect.bottom += y; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect.left -= x; rect.bottom += y; rect.top -= y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect.left -= x; rect.bottom += y; rect.right += x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect.top -= y; rect.left -= x; rect.right += x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect.top -= y; rect.left -= x; rect.bottom += y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect.top -= y; rect.right += x; rect.left -= x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect.top -= y; rect.right += x; rect.bottom += y; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect.top -= y; rect.bottom += y; rect.left -= x; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect.top -= y; rect.bottom += y; rect.right += x; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect.right += x; rect.left -= x; rect.top -= y; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect.right += x; rect.left -= x; rect.bottom += y; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect.right += x; rect.top -= y; rect.left -= x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect.right += x; rect.top -= y; rect.bottom += y; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect.right += x; rect.bottom += y; rect.left -= x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect.right += x; rect.bottom += y; rect.top -= y; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect.bottom += y; rect.left -= x; rect.top -= y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect.bottom += y; rect.left -= x; rect.right += x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect.bottom += y; rect.top -= y; rect.left -= x; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect.bottom += y; rect.top -= y; rect.right += x; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect.bottom += y; rect.right += x; rect.left -= x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect.bottom += y; rect.right += x; rect.top -= y; rect.left -= x;
+ InflateRect(&rect, x, y);
)


@ depends on !skip disable ptr_to_array @
expression rect, x, y;
@@
(
- rect->left -= x; rect->top -= y; rect->right += x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect->left -= x; rect->top -= y; rect->bottom += y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect->left -= x; rect->right += x; rect->top -= y; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect->left -= x; rect->right += x; rect->bottom += y; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect->left -= x; rect->bottom += y; rect->top -= y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect->left -= x; rect->bottom += y; rect->right += x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect->top -= y; rect->left -= x; rect->right += x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect->top -= y; rect->left -= x; rect->bottom += y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect->top -= y; rect->right += x; rect->left -= x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect->top -= y; rect->right += x; rect->bottom += y; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect->top -= y; rect->bottom += y; rect->left -= x; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect->top -= y; rect->bottom += y; rect->right += x; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect->right += x; rect->left -= x; rect->top -= y; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect->right += x; rect->left -= x; rect->bottom += y; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect->right += x; rect->top -= y; rect->left -= x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect->right += x; rect->top -= y; rect->bottom += y; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect->right += x; rect->bottom += y; rect->left -= x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect->right += x; rect->bottom += y; rect->top -= y; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect->bottom += y; rect->left -= x; rect->top -= y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect->bottom += y; rect->left -= x; rect->right += x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect->bottom += y; rect->top -= y; rect->left -= x; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect->bottom += y; rect->top -= y; rect->right += x; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect->bottom += y; rect->right += x; rect->left -= x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect->bottom += y; rect->right += x; rect->top -= y; rect->left -= x;
+ InflateRect(rect, x, y);
)


@ depends on !skip @
expression rect, x, y;
@@
(
- rect.left += x; rect.top += y; rect.right -= x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect.left += x; rect.top += y; rect.bottom -= y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect.left += x; rect.right -= x; rect.top += y; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect.left += x; rect.right -= x; rect.bottom -= y; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect.left += x; rect.bottom -= y; rect.top += y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect.left += x; rect.bottom -= y; rect.right -= x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect.top += y; rect.left += x; rect.right -= x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect.top += y; rect.left += x; rect.bottom -= y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect.top += y; rect.right -= x; rect.left += x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect.top += y; rect.right -= x; rect.bottom -= y; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect.top += y; rect.bottom -= y; rect.left += x; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect.top += y; rect.bottom -= y; rect.right -= x; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect.right -= x; rect.left += x; rect.top += y; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect.right -= x; rect.left += x; rect.bottom -= y; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect.right -= x; rect.top += y; rect.left += x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect.right -= x; rect.top += y; rect.bottom -= y; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect.right -= x; rect.bottom -= y; rect.left += x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect.right -= x; rect.bottom -= y; rect.top += y; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect.bottom -= y; rect.left += x; rect.top += y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect.bottom -= y; rect.left += x; rect.right -= x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect.bottom -= y; rect.top += y; rect.left += x; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect.bottom -= y; rect.top += y; rect.right -= x; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect.bottom -= y; rect.right -= x; rect.left += x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect.bottom -= y; rect.right -= x; rect.top += y; rect.left += x;
+ InflateRect(&rect, -x, -y);
)


@ depends on !skip disable ptr_to_array @
expression rect, x, y;
@@
(
- rect->left += x; rect->top += y; rect->right -= x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect->left += x; rect->top += y; rect->bottom -= y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect->left += x; rect->right -= x; rect->top += y; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect->left += x; rect->right -= x; rect->bottom -= y; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect->left += x; rect->bottom -= y; rect->top += y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect->left += x; rect->bottom -= y; rect->right -= x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect->top += y; rect->left += x; rect->right -= x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect->top += y; rect->left += x; rect->bottom -= y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect->top += y; rect->right -= x; rect->left += x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect->top += y; rect->right -= x; rect->bottom -= y; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect->top += y; rect->bottom -= y; rect->left += x; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect->top += y; rect->bottom -= y; rect->right -= x; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect->right -= x; rect->left += x; rect->top += y; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect->right -= x; rect->left += x; rect->bottom -= y; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect->right -= x; rect->top += y; rect->left += x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect->right -= x; rect->top += y; rect->bottom -= y; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect->right -= x; rect->bottom -= y; rect->left += x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect->right -= x; rect->bottom -= y; rect->top += y; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect->bottom -= y; rect->left += x; rect->top += y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect->bottom -= y; rect->left += x; rect->right -= x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect->bottom -= y; rect->top += y; rect->left += x; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect->bottom -= y; rect->top += y; rect->right -= x; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect->bottom -= y; rect->right -= x; rect->left += x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect->bottom -= y; rect->right -= x; rect->top += y; rect->left += x;
+ InflateRect(rect, -x, -y);
)
