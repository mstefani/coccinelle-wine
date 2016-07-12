// Use PtInRect() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes --timeout 900
// Comments: FIXME: PtInRect cannot be used from all places. This produces false positives.

using "../binary_and.iso"

@ skip @
@@
#include "gdi_private.h"

@ depends on !skip disable paren @
expression pt, r;
@@
(
- pt.x >= r.left && pt.y >= r.top && pt.x < r.right && pt.y < r.bottom
+ PtInRect(&r, &pt)
|
- pt.x < r.left && pt.y < r.top && pt.x >= r.right && pt.y >= r.bottom
+ !PtInRect(&r, &pt)
|
- (pt.x >= r.left) && (pt.y >= r.top) && (pt.x < r.right) && (pt.y < r.bottom)
+ PtInRect(&r, &pt)
|
- (pt.x < r.left) && (pt.y < r.top) && (pt.x < r.right) && (pt.y < r.bottom)
+ !PtInRect(&r, &pt)
|
- (pt.x) >= (r.left) && (pt.y) >= (r.top) && (pt.x) < (r.right) && (pt.y) < (r.bottom)
+ PtInRect(&r, &pt)
|
- (pt.x) < (r.left) && (pt.y) < (r.top) && (pt.x) >= (r.right) && (pt.y) >= (r.bottom)
+ !PtInRect(&r, &pt)
)


@ depends on !skip disable paren, ptr_to_array @
expression pt, r;
@@
(
- pt->x >= r->left && pt->y >= r->top && pt->x < r->right && pt->y < r->bottom
+ PtInRect(r, pt)
|
- pt->x < r->left && pt->y < r->top && pt->x >= r->right && pt->y >= r->bottom
+ !PtInRect(r, pt)
|
- (pt->x >= r->left) && (pt->y >= r->top) && (pt->x < r->right) && (pt->y < r->bottom)
+ PtInRect(r, pt)
|
- (pt->x < r->left) && (pt->y < r->top) && (pt->x >= r->right) && (pt->y >= r->bottom)
+ !PtInRect(r, pt)
|
- (pt->x) >= (r->left) && (pt->y) >= (r->top) && (pt->x) < (r->right) && (pt->y) < (r->bottom)
+ PtInRect(r, pt)
|
- (pt->x) < (r->left) && (pt->y) < (r->top) && (pt->x) >= (r->right) && (pt->y) >= (r->bottom)
+ !PtInRect(r, pt)
)


@ depends on !skip disable paren, ptr_to_array @
expression pt, r;
@@
(
- pt.x >= r->left && pt.y >= r->top && pt.x < r->right && pt.y < r->bottom
+ PtInRect(r, &pt)
|
- pt.x < r->left && pt.y < r->top && pt.x >= r->right && pt.y >= r->bottom
+ !PtInRect(r, &pt)
|
- (pt.x >= r->left) && (pt.y >= r->top) && (pt.x < r->right) && (pt.y < r->bottom)
+ PtInRect(r, &pt)
|
- (pt.x < r->left) && (pt.y < r->top) && (pt.x >= r->right) && (pt.y >= r->bottom)
+ !PtInRect(r, &pt)
|
- (pt.x) >= (r->left) && (pt.y) >= (r->top) && (pt.x) < (r->right) && (pt.y) < (r->bottom)
+ PtInRect(r, &pt)
|
- (pt.x) < (r->left) && (pt.y) < (r->top) && (pt.x) >= (r->right) && (pt.y) >= (r->bottom)
+ !PtInRect(r, &pt)
)


@ depends on !skip disable paren, ptr_to_array @
expression pt, r;
@@
(
- pt->x >= r.left && pt->y >= r.top && pt->x < r.right && pt->y < r.bottom
+ PtInRect(&r, pt)
|
- pt->x < r.left && pt->y < r.top && pt->x >= r.right && pt->y >= r.bottom
+ !PtInRect(&r, pt)
|
- (pt->x >= r.left) && (pt->y >= r.top) && (pt->x < r.right) && (pt->y < r.bottom)
+ PtInRect(&r, pt)
|
- (pt->x < r.left) && (pt->y < r.top) && (pt->x >= r.right) && (pt->y >= r.bottom)
+ !PtInRect(&r, pt)
|
- (pt->x) >= (r.left) && (pt->y) >= (r.top) && (pt->x) < (r.right) && (pt->y) < (r.bottom)
+ PtInRect(&r, pt)
|
- (pt->x) < (r.left) && (pt->y) < (r.top) && (pt->x) >= (r.right) && (pt->y) >= (r.bottom)
+ !PtInRect(&r, pt)
)
