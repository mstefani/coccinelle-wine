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


@ptr@
expression r1, r2;
@@
- CopyRect(r1, r2)
+ *r1 = *r2


// Cleanup of the generated patch
@depends on ptr@
expression r;
@@
- *&
    r
