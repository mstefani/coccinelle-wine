// Use IsRectEmpty() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: FIXME: IsRectEmpty cannot be used from all places. This produces false positives.

virtual report


@initialize:python@
@@
def WARN(pos, func):
    print("%s:%s: Warning: In function %s use %s() instead of open coding it" % (pos.file, pos.line, pos.current_element, func), flush=True)


@ skip @
@@
#include "gdi_private.h"


@ r1 depends on !skip disable fld_to_ptr @
type T != {D2D_RECT_F, RECT16, rectangle_t, struct wined3d_box};
T rect;
position p;
@@
(
- (rect.left@p >= rect.right) || (rect.top >= rect.bottom)
+ IsRectEmpty(&rect)
|
- (rect.top@p >= rect.bottom) || (rect.left >= rect.right)
+ IsRectEmpty(&rect)
)


@script:python depends on report@
p << r1.p;
@@
WARN(p[0], "IsRectEmpty")


@ r2 depends on !skip disable ptr_to_array @
type T != {D2D_RECT_F*, RECT16*, rectangle_t*, struct wined3d_box*};
T rect;
position p;
@@
(
- (rect->left@p >= rect->right) || (rect->top >= rect->bottom)
+ IsRectEmpty(rect)
|
- (rect->top@p >= rect->bottom) || (rect->left >= rect->right)
+ IsRectEmpty(rect)
)


@script:python depends on report@
p << r2.p;
@@
WARN(p[0], "IsRectEmpty")


@ gdi1 depends on skip disable fld_to_ptr @
type T != {D2D_RECT_F, RECT16, rectangle_t, struct wined3d_box};
T rect;
position p;
@@
(
- (rect.left@p >= rect.right) || (rect.top >= rect.bottom)
+ is_rect_empty(&rect)
|
- (rect.top@p >= rect.bottom) || (rect.left >= rect.right)
+ is_rect_empty(&rect)
)


@script:python depends on report@
p << gdi1.p;
@@
WARN(p[0], "is_rect_empty")


@ gdi2 depends on skip disable ptr_to_array @
type T != {D2D_RECT_F*, RECT16*, rectangle_t*, struct wined3d_box*};
T rect;
position p;
@@
(
- (rect->left@p >= rect->right) || (rect->top >= rect->bottom)
+ is_rect_empty(rect)
|
- (rect->top@p >= rect->bottom) || (rect->left >= rect->right)
+ is_rect_empty(rect)
)


@script:python depends on report@
p << gdi2.p;
@@
WARN(p[0], "is_rect_empty")
