// Use EqualRect() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: FIXME: EqualRect cannot be used from all places. This produces false positives.

using "../binary_and.iso"

@ skip @
@@
#include "gdi_private.h"

@ depends on !skip disable paren @
expression r1, r2;
@@
(
- r1.left == r2.left && r1.top == r2.top && r1.right == r2.right && r1.bottom == r2.bottom
+ EqualRect(&r1, &r2)
|
- (r1.left == r2.left) && (r1.top == r2.top) && (r1.right == r2.right) && (r1.bottom == r2.bottom)
+ EqualRect(&r1, &r2)
|
- (r1.left) == (r2.left) && (r1.top) == (r2.top) && (r1.right) == (r2.right) && (r1.bottom) == (r2.bottom)
+ EqualRect(&r1, &r2)
)


@ depends on !skip disable paren, ptr_to_array @
expression r1, r2;
@@
(
- r1->left == r2->left && r1->top == r2->top && r1->right == r2->right && r1->bottom == r2->bottom
+ EqualRect(r1, r2)
|
- (r1->left == r2->left) && (r1->top == r2->top) && (r1->right == r2->right) && (r1->bottom == r2->bottom)
+ EqualRect(r1, r2)
|
- (r1->left) == (r2->left) && (r1->top) == (r2->top) && (r1->right) == (r2->right) && (r1->bottom) == (r2->bottom)
+ EqualRect(r1, r2)
)


@ depends on !skip disable paren, ptr_to_array @
expression r1, r2;
@@
(
- r1.left == r2->left && r1.top == r2->top && r1.right == r2->right && r1.bottom == r2->bottom
+ EqualRect(r1, r2)
|
- (r1.left == r2->left) && (r1.top == r2->top) && (r1.right == r2->right) && (r1.bottom == r2->bottom)
+ EqualRect(r1, r2)
|
- (r1.left) == (r2->left) && (r1.top) == (r2->top) && (r1.right) == (r2->right) && (r1.bottom) == (r2->bottom)
+ EqualRect(&r1, r2)
)


@ depends on !skip disable paren, ptr_to_array @
expression r1, r2;
@@
(
- r1->left == r2.left && r1->top == r2.top && r1->right == r2.right && r1->bottom == r2.bottom
+ EqualRect(r1, r2)
|
- (r1->left == r2.left) && (r1->top == r2.top) && (r1->right == r2.right) && (r1->bottom == r2.bottom)
+ EqualRect(r1, r2)
|
- (r1->left) == (r2.left) && (r1->top) == (r2.top) && (r1->right) == (r2.right) && (r1->bottom) == (r2.bottom)
+ EqualRect(r1, &r2)
)
