// Use IsRectEmpty() instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: FIXME: SetRect cannot be used from all places. This produces false positives.

@ skip @
@@
#include "gdi_private.h"

@ depends on !skip @
expression rect;
@@
(
- (rect.left >= rect.right) || (rect.top >= rect.bottom)
+ IsRectEmpty(&rect)
|
- (rect.top >= rect.bottom) || (rect.left >= rect.right)
+ IsRectEmpty(&rect)
)


@ depends on !skip disable ptr_to_array @
expression rect;
@@
(
- (rect->left >= rect->right) || (rect->top >= rect->bottom)
+ IsRectEmpty(rect)
|
- (rect->top >= rect->bottom) || (rect->left >= rect->right)
+ IsRectEmpty(rect)
)
