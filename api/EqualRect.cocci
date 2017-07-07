// Use EqualRect() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: FIXME: EqualRect cannot be used from all places. This produces false positives.

virtual report
using "../binary_and.iso"


@initialize:python@
@@
def WARN(pos, func):
    print("%s:%s: Warning: In function %s use EqualRect() instead of %s" % (pos.file, pos.line, pos.current_element, func), flush=True)


@ skip @
@@
#include "gdi_private.h"

@ open1 depends on !skip disable paren @
expression r1, r2;
position p;
@@
(
- r1@p.left == r2.left && r1.top == r2.top && r1.right == r2.right && r1.bottom == r2.bottom
+ EqualRect(&r1, &r2)
|
- (r1@p.left == r2.left) && (r1.top == r2.top) && (r1.right == r2.right) && (r1.bottom == r2.bottom)
+ EqualRect(&r1, &r2)
|
- (r1@p.left) == (r2.left) && (r1.top) == (r2.top) && (r1.right) == (r2.right) && (r1.bottom) == (r2.bottom)
+ EqualRect(&r1, &r2)
)


@script:python depends on report@
p << open1.p;
@@
WARN(p[0], "open conding it")


@ open2 depends on !skip disable paren, ptr_to_array @
expression r1, r2;
position p;
@@
(
- r1@p->left == r2->left && r1->top == r2->top && r1->right == r2->right && r1->bottom == r2->bottom
+ EqualRect(r1, r2)
|
- (r1@p->left == r2->left) && (r1->top == r2->top) && (r1->right == r2->right) && (r1->bottom == r2->bottom)
+ EqualRect(r1, r2)
|
- (r1@p->left) == (r2->left) && (r1->top) == (r2->top) && (r1->right) == (r2->right) && (r1->bottom) == (r2->bottom)
+ EqualRect(r1, r2)
)


@script:python depends on report@
p << open2.p;
@@
WARN(p[0], "open conding it")


@ open3 depends on !skip disable paren, ptr_to_array @
expression r1, r2;
position p;
@@
(
- r1@p.left == r2->left && r1.top == r2->top && r1.right == r2->right && r1.bottom == r2->bottom
+ EqualRect(&r1, r2)
|
- (r1@p.left == r2->left) && (r1.top == r2->top) && (r1.right == r2->right) && (r1.bottom == r2->bottom)
+ EqualRect(&r1, r2)
|
- (r1@p.left) == (r2->left) && (r1.top) == (r2->top) && (r1.right) == (r2->right) && (r1.bottom) == (r2->bottom)
+ EqualRect(&r1, r2)
)


@script:python depends on report@
p << open3.p;
@@
WARN(p[0], "open conding it")


@ open4 depends on !skip disable paren, ptr_to_array @
expression r1, r2;
position p;
@@
(
- r1@p->left == r2.left && r1->top == r2.top && r1->right == r2.right && r1->bottom == r2.bottom
+ EqualRect(r1, &r2)
|
- (r1@p->left == r2.left) && (r1->top == r2.top) && (r1->right == r2.right) && (r1->bottom == r2.bottom)
+ EqualRect(r1, &r2)
|
- (r1@p->left) == (r2.left) && (r1->top) == (r2.top) && (r1->right) == (r2.right) && (r1->bottom) == (r2.bottom)
+ EqualRect(r1, &r2)
)


@script:python depends on report@
p << open4.p;
@@
WARN(p[0], "open conding it")


@ memcmp1 depends on !skip @
typedef RECT;
RECT *r1;
RECT *r2;
expression size;
position p;
@@
(
- !memcmp@p
+ EqualRect
|
- memcmp@p
+ !EqualRect
)
            ( r1, r2,
-                     size
            )


@script:python depends on report@
p << memcmp1.p;
@@
WARN(p[0], "memcmp()")


@ memcmp2 depends on !skip @
expression r1, r2;
position p;
@@
- memcmp@p
+ !EqualRect
            ( r1, r2,
-                     sizeof(RECT)
            )


@script:python depends on report@
p << memcmp2.p;
@@
WARN(p[0], "memcmp()")


@ memcmp3 depends on !skip @
RECT *r1;
expression r2, size;
position p;
@@
- memcmp@p
+ !EqualRect
            ( r1, r2,
-                     size
            )


@script:python depends on report@
p << memcmp3.p;
@@
WARN(p[0], "memcmp()")
