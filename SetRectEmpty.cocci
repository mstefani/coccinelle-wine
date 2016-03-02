// Use SectRectEmpty instead of open conding it.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: FIXME: SetRectEmpty cannot be used from all places. This produces false positives.

@@
expression E;
@@
- SetRect
+ SetRectEmpty
         (E,
-            0, 0, 0, 0
         )


@@
expression r;
@@
- r.left = 0;
- r.top = 0;
- r.right = 0;
- r.bottom = 0;
+ SetRectEmpty(&r);
