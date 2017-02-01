// Use IsRectEmpty() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: FIXME: IsRectEmpty cannot be used from all places. This produces false positives.

@ skip @
@@
#include "gdi_private.h"


@ depends on !skip @
type T != {D2D_RECT_F, RECT16, rectangle_t, struct wined3d_box};
T rect;
@@
(
- (rect.left >= rect.right) || (rect.top >= rect.bottom)
+ IsRectEmpty(&rect)
|
- (rect.top >= rect.bottom) || (rect.left >= rect.right)
+ IsRectEmpty(&rect)
)


@ depends on !skip disable ptr_to_array @
type T != {D2D_RECT_F*, RECT16*, rectangle_t*, struct wined3d_box*};
T rect;
@@
(
- (rect->left >= rect->right) || (rect->top >= rect->bottom)
+ IsRectEmpty(rect)
|
- (rect->top >= rect->bottom) || (rect->left >= rect->right)
+ IsRectEmpty(rect)
)


@ depends on skip @
type T != {D2D_RECT_F, RECT16, rectangle_t, struct wined3d_box};
T rect;
@@
(
- (rect.left >= rect.right) || (rect.top >= rect.bottom)
+ is_rect_empty(&rect)
|
- (rect.top >= rect.bottom) || (rect.left >= rect.right)
+ is_rect_empty(&rect)
)


@ depends on skip disable ptr_to_array @
type T != {D2D_RECT_F*, RECT16*, rectangle_t*, struct wined3d_box*};
T rect;
@@
(
- (rect->left >= rect->right) || (rect->top >= rect->bottom)
+ is_rect_empty(rect)
|
- (rect->top >= rect->bottom) || (rect->left >= rect->right)
+ is_rect_empty(rect)
)
