// Use struct assignment instead of CopyRect().
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
expression r1, r2;
@@
- CopyRect(&r1, &r2)
+ r1 = r2
