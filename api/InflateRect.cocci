// Use InflateRect() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers
// Comments: FIXME: InflateRect cannot be used from all places. This produces false positives.

virtual report


@initialize:python@
@@
def WARN(pos):
    print("%s:%s: Warning: In function %s use InflateRect() instead of open coding it" % (pos.file, pos.line, pos.current_element), flush=True)


@ skip @
@@
#include "gdi_private.h"


@ r1 depends on !skip @
expression rect, x, y;
position p;
@@
(
- rect@p.left -= x; rect.top -= y; rect.right += x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect@p.left -= x; rect.top -= y; rect.bottom += y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect@p.left -= x; rect.right += x; rect.top -= y; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect@p.left -= x; rect.right += x; rect.bottom += y; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect@p.left -= x; rect.bottom += y; rect.top -= y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect@p.left -= x; rect.bottom += y; rect.right += x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect@p.top -= y; rect.left -= x; rect.right += x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect@p.top -= y; rect.left -= x; rect.bottom += y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect@p.top -= y; rect.right += x; rect.left -= x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect@p.top -= y; rect.right += x; rect.bottom += y; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect@p.top -= y; rect.bottom += y; rect.left -= x; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect@p.top -= y; rect.bottom += y; rect.right += x; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect@p.right += x; rect.left -= x; rect.top -= y; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect@p.right += x; rect.left -= x; rect.bottom += y; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect@p.right += x; rect.top -= y; rect.left -= x; rect.bottom += y;
+ InflateRect(&rect, x, y);
|
- rect@p.right += x; rect.top -= y; rect.bottom += y; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect@p.right += x; rect.bottom += y; rect.left -= x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect@p.right += x; rect.bottom += y; rect.top -= y; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect@p.bottom += y; rect.left -= x; rect.top -= y; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect@p.bottom += y; rect.left -= x; rect.right += x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect@p.bottom += y; rect.top -= y; rect.left -= x; rect.right += x;
+ InflateRect(&rect, x, y);
|
- rect@p.bottom += y; rect.top -= y; rect.right += x; rect.left -= x;
+ InflateRect(&rect, x, y);
|
- rect@p.bottom += y; rect.right += x; rect.left -= x; rect.top -= y;
+ InflateRect(&rect, x, y);
|
- rect@p.bottom += y; rect.right += x; rect.top -= y; rect.left -= x;
+ InflateRect(&rect, x, y);
)


@script:python depends on report@
p << r1.p;
@@
WARN(p[0])


@ r2 depends on !skip disable ptr_to_array @
expression rect, x, y;
position p;
@@
(
- rect@p->left -= x; rect->top -= y; rect->right += x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect@p->left -= x; rect->top -= y; rect->bottom += y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect@p->left -= x; rect->right += x; rect->top -= y; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect@p->left -= x; rect->right += x; rect->bottom += y; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect@p->left -= x; rect->bottom += y; rect->top -= y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect@p->left -= x; rect->bottom += y; rect->right += x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect@p->top -= y; rect->left -= x; rect->right += x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect@p->top -= y; rect->left -= x; rect->bottom += y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect@p->top -= y; rect->right += x; rect->left -= x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect@p->top -= y; rect->right += x; rect->bottom += y; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect@p->top -= y; rect->bottom += y; rect->left -= x; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect@p->top -= y; rect->bottom += y; rect->right += x; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect@p->right += x; rect->left -= x; rect->top -= y; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect@p->right += x; rect->left -= x; rect->bottom += y; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect@p->right += x; rect->top -= y; rect->left -= x; rect->bottom += y;
+ InflateRect(rect, x, y);
|
- rect@p->right += x; rect->top -= y; rect->bottom += y; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect@p->right += x; rect->bottom += y; rect->left -= x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect@p->right += x; rect->bottom += y; rect->top -= y; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect@p->bottom += y; rect->left -= x; rect->top -= y; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect@p->bottom += y; rect->left -= x; rect->right += x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect@p->bottom += y; rect->top -= y; rect->left -= x; rect->right += x;
+ InflateRect(rect, x, y);
|
- rect@p->bottom += y; rect->top -= y; rect->right += x; rect->left -= x;
+ InflateRect(rect, x, y);
|
- rect@p->bottom += y; rect->right += x; rect->left -= x; rect->top -= y;
+ InflateRect(rect, x, y);
|
- rect@p->bottom += y; rect->right += x; rect->top -= y; rect->left -= x;
+ InflateRect(rect, x, y);
)


@script:python depends on report@
p << r2.p;
@@
WARN(p[0])


@ r3 depends on !skip @
expression rect, x, y;
position p;
@@
(
- rect@p.left -= x; rect.top += y; rect.right += x; rect.bottom -= y;
+ InflateRect(&rect, x, -y);
|
- rect@p.left -= x; rect.top += y; rect.bottom -= y; rect.right += x;
+ InflateRect(&rect, x, -y);
|
- rect@p.left -= x; rect.right += x; rect.top += y; rect.bottom -= y;
+ InflateRect(&rect, x, -y);
|
- rect@p.left -= x; rect.right += x; rect.bottom -= y; rect.top += y;
+ InflateRect(&rect, x, -y);
|
- rect@p.left -= x; rect.bottom -= y; rect.top += y; rect.right += x;
+ InflateRect(&rect, x, -y);
|
- rect@p.left -= x; rect.bottom -= y; rect.right += x; rect.top += y;
+ InflateRect(&rect, x, -y);
|
- rect@p.top += y; rect.left -= x; rect.right += x; rect.bottom -= y;
+ InflateRect(&rect, x, -y);
|
- rect@p.top += y; rect.left -= x; rect.bottom -= y; rect.right += x;
+ InflateRect(&rect, x, -y);
|
- rect@p.top += y; rect.right += x; rect.left -= x; rect.bottom -= y;
+ InflateRect(&rect, x, -y);
|
- rect@p.top += y; rect.right += x; rect.bottom -= y; rect.left -= x;
+ InflateRect(&rect, x, -y);
|
- rect@p.top += y; rect.bottom -= y; rect.left -= x; rect.right += x;
+ InflateRect(&rect, x, -y);
|
- rect@p.top += y; rect.bottom -= y; rect.right += x; rect.left -= x;
+ InflateRect(&rect, x, -y);
|
- rect@p.right += x; rect.left -= x; rect.top += y; rect.bottom -= y;
+ InflateRect(&rect, x, -y);
|
- rect@p.right += x; rect.left -= x; rect.bottom -= y; rect.top += y;
+ InflateRect(&rect, x, -y);
|
- rect@p.right += x; rect.top += y; rect.left -= x; rect.bottom -= y;
+ InflateRect(&rect, x, -y);
|
- rect@p.right += x; rect.top += y; rect.bottom -= y; rect.left -= x;
+ InflateRect(&rect, x, -y);
|
- rect@p.right += x; rect.bottom -= y; rect.left -= x; rect.top += y;
+ InflateRect(&rect, x, -y);
|
- rect@p.right += x; rect.bottom -= y; rect.top += y; rect.left -= x;
+ InflateRect(&rect, x, -y);
|
- rect@p.bottom -= y; rect.left -= x; rect.top += y; rect.right += x;
+ InflateRect(&rect, x, -y);
|
- rect@p.bottom -= y; rect.left -= x; rect.right += x; rect.top += y;
+ InflateRect(&rect, x, -y);
|
- rect@p.bottom -= y; rect.top += y; rect.left -= x; rect.right += x;
+ InflateRect(&rect, x, -y);
|
- rect@p.bottom -= y; rect.top += y; rect.right += x; rect.left -= x;
+ InflateRect(&rect, x, -y);
|
- rect@p.bottom -= y; rect.right += x; rect.left -= x; rect.top += y;
+ InflateRect(&rect, x, -y);
|
- rect@p.bottom -= y; rect.right += x; rect.top += y; rect.left -= x;
+ InflateRect(&rect, x, -y);
)


@script:python depends on report@
p << r3.p;
@@
WARN(p[0])


@ r4 depends on !skip disable ptr_to_array @
expression rect, x, y;
position p;
@@
(
- rect@p->left -= x; rect->top += y; rect->right += x; rect->bottom -= y;
+ InflateRect(rect, x, -y);
|
- rect@p->left -= x; rect->top += y; rect->bottom -= y; rect->right += x;
+ InflateRect(rect, x, -y);
|
- rect@p->left -= x; rect->right += x; rect->top += y; rect->bottom -= y;
+ InflateRect(rect, x, -y);
|
- rect@p->left -= x; rect->right += x; rect->bottom -= y; rect->top += y;
+ InflateRect(rect, x, -y);
|
- rect@p->left -= x; rect->bottom -= y; rect->top += y; rect->right += x;
+ InflateRect(rect, x, -y);
|
- rect@p->left -= x; rect->bottom -= y; rect->right += x; rect->top += y;
+ InflateRect(rect, x, -y);
|
- rect@p->top += y; rect->left -= x; rect->right += x; rect->bottom -= y;
+ InflateRect(rect, x, -y);
|
- rect@p->top += y; rect->left -= x; rect->bottom -= y; rect->right += x;
+ InflateRect(rect, x, -y);
|
- rect@p->top += y; rect->right += x; rect->left -= x; rect->bottom -= y;
+ InflateRect(rect, x, -y);
|
- rect@p->top += y; rect->right += x; rect->bottom -= y; rect->left -= x;
+ InflateRect(rect, x, -y);
|
- rect@p->top += y; rect->bottom -= y; rect->left -= x; rect->right += x;
+ InflateRect(rect, x, -y);
|
- rect@p->top += y; rect->bottom -= y; rect->right += x; rect->left -= x;
+ InflateRect(rect, x, -y);
|
- rect@p->right += x; rect->left -= x; rect->top += y; rect->bottom -= y;
+ InflateRect(rect, x, -y);
|
- rect@p->right += x; rect->left -= x; rect->bottom -= y; rect->top += y;
+ InflateRect(rect, x, -y);
|
- rect@p->right += x; rect->top += y; rect->left -= x; rect->bottom -= y;
+ InflateRect(rect, x, -y);
|
- rect@p->right += x; rect->top += y; rect->bottom -= y; rect->left -= x;
+ InflateRect(rect, x, -y);
|
- rect@p->right += x; rect->bottom -= y; rect->left -= x; rect->top += y;
+ InflateRect(rect, x, -y);
|
- rect@p->right += x; rect->bottom -= y; rect->top += y; rect->left -= x;
+ InflateRect(rect, x, -y);
|
- rect@p->bottom -= y; rect->left -= x; rect->top += y; rect->right += x;
+ InflateRect(rect, x, -y);
|
- rect@p->bottom -= y; rect->left -= x; rect->right += x; rect->top += y;
+ InflateRect(rect, x, -y);
|
- rect@p->bottom -= y; rect->top += y; rect->left -= x; rect->right += x;
+ InflateRect(rect, x, -y);
|
- rect@p->bottom -= y; rect->top += y; rect->right += x; rect->left -= x;
+ InflateRect(rect, x, -y);
|
- rect@p->bottom -= y; rect->right += x; rect->left -= x; rect->top += y;
+ InflateRect(rect, x, -y);
|
- rect@p->bottom -= y; rect->right += x; rect->top += y; rect->left -= x;
+ InflateRect(rect, x, -y);
)


@script:python depends on report@
p << r4.p;
@@
WARN(p[0])


@ r5 depends on !skip @
expression rect, x, y;
position p;
@@
(
- rect@p.left += x; rect.top -= y; rect.right -= x; rect.bottom += y;
+ InflateRect(&rect, -x, y);
|
- rect@p.left += x; rect.top -= y; rect.bottom += y; rect.right -= x;
+ InflateRect(&rect, -x, y);
|
- rect@p.left += x; rect.right -= x; rect.top -= y; rect.bottom += y;
+ InflateRect(&rect, -x, y);
|
- rect@p.left += x; rect.right -= x; rect.bottom += y; rect.top -= y;
+ InflateRect(&rect, -x, y);
|
- rect@p.left += x; rect.bottom += y; rect.top -= y; rect.right -= x;
+ InflateRect(&rect, -x, y);
|
- rect@p.left += x; rect.bottom += y; rect.right -= x; rect.top -= y;
+ InflateRect(&rect, -x, y);
|
- rect@p.top -= y; rect.left += x; rect.right -= x; rect.bottom += y;
+ InflateRect(&rect, -x, y);
|
- rect@p.top -= y; rect.left += x; rect.bottom += y; rect.right -= x;
+ InflateRect(&rect, -x, y);
|
- rect@p.top -= y; rect.right -= x; rect.left += x; rect.bottom += y;
+ InflateRect(&rect, -x, y);
|
- rect@p.top -= y; rect.right -= x; rect.bottom += y; rect.left += x;
+ InflateRect(&rect, -x, y);
|
- rect@p.top -= y; rect.bottom += y; rect.left += x; rect.right -= x;
+ InflateRect(&rect, -x, y);
|
- rect@p.top -= y; rect.bottom += y; rect.right -= x; rect.left += x;
+ InflateRect(&rect, -x, y);
|
- rect@p.right -= x; rect.left += x; rect.top -= y; rect.bottom += y;
+ InflateRect(&rect, -x, y);
|
- rect@p.right -= x; rect.left += x; rect.bottom += y; rect.top -= y;
+ InflateRect(&rect, -x, y);
|
- rect@p.right -= x; rect.top -= y; rect.left += x; rect.bottom += y;
+ InflateRect(&rect, -x, y);
|
- rect@p.right -= x; rect.top -= y; rect.bottom += y; rect.left += x;
+ InflateRect(&rect, -x, y);
|
- rect@p.right -= x; rect.bottom += y; rect.left += x; rect.top -= y;
+ InflateRect(&rect, -x, y);
|
- rect@p.right -= x; rect.bottom += y; rect.top -= y; rect.left += x;
+ InflateRect(&rect, -x, y);
|
- rect@p.bottom += y; rect.left += x; rect.top -= y; rect.right -= x;
+ InflateRect(&rect, -x, y);
|
- rect@p.bottom += y; rect.left += x; rect.right -= x; rect.top -= y;
+ InflateRect(&rect, -x, y);
|
- rect@p.bottom += y; rect.top -= y; rect.left += x; rect.right -= x;
+ InflateRect(&rect, -x, y);
|
- rect@p.bottom += y; rect.top -= y; rect.right -= x; rect.left += x;
+ InflateRect(&rect, -x, y);
|
- rect@p.bottom += y; rect.right -= x; rect.left += x; rect.top -= y;
+ InflateRect(&rect, -x, y);
|
- rect@p.bottom += y; rect.right -= x; rect.top -= y; rect.left += x;
+ InflateRect(&rect, -x, y);
)


@script:python depends on report@
p << r5.p;
@@
WARN(p[0])


@ r6 depends on !skip disable ptr_to_array @
expression rect, x, y;
position p;
@@
(
- rect@p->left += x; rect->top -= y; rect->right -= x; rect->bottom += y;
+ InflateRect(rect, -x, y);
|
- rect@p->left += x; rect->top -= y; rect->bottom += y; rect->right -= x;
+ InflateRect(rect, -x, y);
|
- rect@p->left += x; rect->right -= x; rect->top -= y; rect->bottom += y;
+ InflateRect(rect, -x, y);
|
- rect@p->left += x; rect->right -= x; rect->bottom += y; rect->top -= y;
+ InflateRect(rect, -x, y);
|
- rect@p->left += x; rect->bottom += y; rect->top -= y; rect->right -= x;
+ InflateRect(rect, -x, y);
|
- rect@p->left += x; rect->bottom += y; rect->right -= x; rect->top -= y;
+ InflateRect(rect, -x, y);
|
- rect@p->top -= y; rect->left += x; rect->right -= x; rect->bottom += y;
+ InflateRect(rect, -x, y);
|
- rect@p->top -= y; rect->left += x; rect->bottom += y; rect->right -= x;
+ InflateRect(rect, -x, y);
|
- rect@p->top -= y; rect->right -= x; rect->left += x; rect->bottom += y;
+ InflateRect(rect, -x, y);
|
- rect@p->top -= y; rect->right -= x; rect->bottom += y; rect->left += x;
+ InflateRect(rect, -x, y);
|
- rect@p->top -= y; rect->bottom += y; rect->left += x; rect->right -= x;
+ InflateRect(rect, -x, y);
|
- rect@p->top -= y; rect->bottom += y; rect->right -= x; rect->left += x;
+ InflateRect(rect, -x, y);
|
- rect@p->right -= x; rect->left += x; rect->top -= y; rect->bottom += y;
+ InflateRect(rect, -x, y);
|
- rect@p->right -= x; rect->left += x; rect->bottom += y; rect->top -= y;
+ InflateRect(rect, -x, y);
|
- rect@p->right -= x; rect->top -= y; rect->left += x; rect->bottom += y;
+ InflateRect(rect, -x, y);
|
- rect@p->right -= x; rect->top -= y; rect->bottom += y; rect->left += x;
+ InflateRect(rect, -x, y);
|
- rect@p->right -= x; rect->bottom += y; rect->left += x; rect->top -= y;
+ InflateRect(rect, -x, y);
|
- rect@p->right -= x; rect->bottom += y; rect->top -= y; rect->left += x;
+ InflateRect(rect, -x, y);
|
- rect@p->bottom += y; rect->left += x; rect->top -= y; rect->right -= x;
+ InflateRect(rect, -x, y);
|
- rect@p->bottom += y; rect->left += x; rect->right -= x; rect->top -= y;
+ InflateRect(rect, -x, y);
|
- rect@p->bottom += y; rect->top -= y; rect->left += x; rect->right -= x;
+ InflateRect(rect, -x, y);
|
- rect@p->bottom += y; rect->top -= y; rect->right -= x; rect->left += x;
+ InflateRect(rect, -x, y);
|
- rect@p->bottom += y; rect->right -= x; rect->left += x; rect->top -= y;
+ InflateRect(rect, -x, y);
|
- rect@p->bottom += y; rect->right -= x; rect->top -= y; rect->left += x;
+ InflateRect(rect, -x, y);
)


@script:python depends on report@
p << r6.p;
@@
WARN(p[0])


@ r7 depends on !skip @
expression rect, x, y;
position p;
@@
(
- rect@p.left += x; rect.top += y; rect.right -= x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.left += x; rect.top += y; rect.bottom -= y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.left += x; rect.right -= x; rect.top += y; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.left += x; rect.right -= x; rect.bottom -= y; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.left += x; rect.bottom -= y; rect.top += y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.left += x; rect.bottom -= y; rect.right -= x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.top += y; rect.left += x; rect.right -= x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.top += y; rect.left += x; rect.bottom -= y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.top += y; rect.right -= x; rect.left += x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.top += y; rect.right -= x; rect.bottom -= y; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.top += y; rect.bottom -= y; rect.left += x; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.top += y; rect.bottom -= y; rect.right -= x; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.right -= x; rect.left += x; rect.top += y; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.right -= x; rect.left += x; rect.bottom -= y; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.right -= x; rect.top += y; rect.left += x; rect.bottom -= y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.right -= x; rect.top += y; rect.bottom -= y; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.right -= x; rect.bottom -= y; rect.left += x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.right -= x; rect.bottom -= y; rect.top += y; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.bottom -= y; rect.left += x; rect.top += y; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.bottom -= y; rect.left += x; rect.right -= x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.bottom -= y; rect.top += y; rect.left += x; rect.right -= x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.bottom -= y; rect.top += y; rect.right -= x; rect.left += x;
+ InflateRect(&rect, -x, -y);
|
- rect@p.bottom -= y; rect.right -= x; rect.left += x; rect.top += y;
+ InflateRect(&rect, -x, -y);
|
- rect@p.bottom -= y; rect.right -= x; rect.top += y; rect.left += x;
+ InflateRect(&rect, -x, -y);
)


@script:python depends on report@
p << r7.p;
@@
WARN(p[0])


@ r8 depends on !skip disable ptr_to_array @
expression rect, x, y;
position p;
@@
(
- rect@p->left += x; rect->top += y; rect->right -= x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect@p->left += x; rect->top += y; rect->bottom -= y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect@p->left += x; rect->right -= x; rect->top += y; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect@p->left += x; rect->right -= x; rect->bottom -= y; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect@p->left += x; rect->bottom -= y; rect->top += y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect@p->left += x; rect->bottom -= y; rect->right -= x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect@p->top += y; rect->left += x; rect->right -= x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect@p->top += y; rect->left += x; rect->bottom -= y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect@p->top += y; rect->right -= x; rect->left += x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect@p->top += y; rect->right -= x; rect->bottom -= y; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect@p->top += y; rect->bottom -= y; rect->left += x; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect@p->top += y; rect->bottom -= y; rect->right -= x; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect@p->right -= x; rect->left += x; rect->top += y; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect@p->right -= x; rect->left += x; rect->bottom -= y; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect@p->right -= x; rect->top += y; rect->left += x; rect->bottom -= y;
+ InflateRect(rect, -x, -y);
|
- rect@p->right -= x; rect->top += y; rect->bottom -= y; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect@p->right -= x; rect->bottom -= y; rect->left += x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect@p->right -= x; rect->bottom -= y; rect->top += y; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect@p->bottom -= y; rect->left += x; rect->top += y; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect@p->bottom -= y; rect->left += x; rect->right -= x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect@p->bottom -= y; rect->top += y; rect->left += x; rect->right -= x;
+ InflateRect(rect, -x, -y);
|
- rect@p->bottom -= y; rect->top += y; rect->right -= x; rect->left += x;
+ InflateRect(rect, -x, -y);
|
- rect@p->bottom -= y; rect->right -= x; rect->left += x; rect->top += y;
+ InflateRect(rect, -x, -y);
|
- rect@p->bottom -= y; rect->right -= x; rect->top += y; rect->left += x;
+ InflateRect(rect, -x, -y);
)


@script:python depends on report@
p << r8.p;
@@
WARN(p[0])


@ r9 depends on !skip @
expression rect, x, y;
position p;
@@
(
- rect@p.left -= x; rect.right += x;
+ InflateRect(&rect, x, 0);
|
- rect@p.right += x; rect.left -= x;
+ InflateRect(&rect, x, 0);
|
- rect@p.left += x; rect.right -= x;
+ InflateRect(&rect, -x, 0);
|
- rect@p.right -= x; rect.left += x;
+ InflateRect(&rect, -x, 0);
|
- rect@p.top -= y; rect.bottom += y;
+ InflateRect(&rect, 0, y);
|
- rect@p.bottom += y; rect.top -= y;
+ InflateRect(&rect, 0, y);
|
- rect@p.top += y; rect.bottom -= y;
+ InflateRect(&rect, 0, -y);
|
- rect@p.bottom -= y; rect.top += y;
+ InflateRect(&rect, 0, -y);
)


@script:python depends on report@
p << r9.p;
@@
WARN(p[0])


@ r10 depends on !skip disable ptr_to_array @
expression rect, x, y;
position p;
@@
(
- rect@p->left -= x; rect->right += x;
+ InflateRect(rect, x, 0);
|
- rect@p->right += x; rect->left -= x;
+ InflateRect(rect, x, 0);
|
- rect@p->left += x; rect->right -= x;
+ InflateRect(rect, -x, 0);
|
- rect@p->right -= x; rect->left += x;
+ InflateRect(rect, -x, 0);
|
- rect@p->top -= y; rect->bottom += y;
+ InflateRect(rect, 0, y);
|
- rect@p->bottom += y; rect->top -= y;
+ InflateRect(rect, 0, y);
|
- rect@p->top += y; rect->bottom -= y;
+ InflateRect(rect, 0, -y);
|
- rect@p->bottom -= y; rect->top += y;
+ InflateRect(rect, 0, -y);
)


@script:python depends on report@
p << r10.p;
@@
WARN(p[0])
