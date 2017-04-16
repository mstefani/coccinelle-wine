// Use SetRect() and variants instead of open conding them.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --recursive-includes
// Comments: - The report mode is better at eliminating false positives. The diff mode shows them
//             as diffs with BADBADBAD in them
//           - FIXME: SetRect cannot be used from all places. This produces false positives.

virtual report
using "../assign.iso"

@initialize:python@
@@
def WARN(pos, msg):
    print("%s:%s: Warning: In function %s %s" % (pos.file, pos.line, pos.current_element, msg), flush=True)

import re

def setrect(pos, rect, left, top, right, bottom):
    if left == "0" and top == "0" and right == "0" and bottom == "0":
        WARN(pos, "use SetRectEmty() instead of open coding it")
        return
    bad = re.compile(r"\b" + rect + r" (\.|->) ")
    if bad.search(left) or bad.search(top) or bad.search(right) or bad.search(bottom):
        # A rect field would be used in SetRect() so skip it
        return
    WARN(pos, "use SetRect() instead of open coding it")


@ skip @
@@
#include "gdi_private.h"


@ sr1 depends on !skip @
typedef RECT;
typedef LPRECT;
RECT rect;
expression l, t, r, b;
position p;
@@
(
- rect@p.left = l; rect.top = t; rect.right = r; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.left = l; rect.top = t; rect.bottom = b; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.left = l; rect.right = r; rect.top = t; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.left = l; rect.right = r; rect.bottom = b; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.left = l; rect.bottom = b; rect.top = t; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.left = l; rect.bottom = b; rect.right = r; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.top = t; rect.left = l; rect.right = r; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.top = t; rect.left = l; rect.bottom = b; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.top = t; rect.right = r; rect.left = l; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.top = t; rect.right = r; rect.bottom = b; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.top = t; rect.bottom = b; rect.left = l; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.top = t; rect.bottom = b; rect.right = r; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.right = r; rect.left = l; rect.top = t; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.right = r; rect.left = l; rect.bottom = b; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.right = r; rect.top = t; rect.left = l; rect.bottom = b;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.right = r; rect.top = t; rect.bottom = b; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.right = r; rect.bottom = b; rect.left = l; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.right = r; rect.bottom = b; rect.top = t; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.bottom = b; rect.left = l; rect.top = t; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.bottom = b; rect.left = l; rect.right = r; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.bottom = b; rect.top = t; rect.left = l; rect.right = r;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.bottom = b; rect.top = t; rect.right = r; rect.left = l;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.bottom = b; rect.right = r; rect.left = l; rect.top = t;
+ SetRect(&rect, l, t, r, b);
|
- rect@p.bottom = b; rect.right = r; rect.top = t; rect.left = l;
+ SetRect(&rect, l, t, r, b);
)


@script:python depends on report@
p << sr1.p;
rect << sr1.rect;
l << sr1.l;
t << sr1.t;
r << sr1.r;
b << sr1.b;
@@
setrect(p[0], rect, l, t, r, b)


@ sr2 depends on !skip disable ptr_to_array @
RECT *rect;
expression l, t, r, b;
position p;
@@
(
- rect@p->left = l; rect->top = t; rect->right = r; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect@p->left = l; rect->top = t; rect->bottom = b; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect@p->left = l; rect->right = r; rect->top = t; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect@p->left = l; rect->right = r; rect->bottom = b; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect@p->left = l; rect->bottom = b; rect->top = t; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect@p->left = l; rect->bottom = b; rect->right = r; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect@p->top = t; rect->left = l; rect->right = r; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect@p->top = t; rect->left = l; rect->bottom = b; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect@p->top = t; rect->right = r; rect->left = l; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect@p->top = t; rect->right = r; rect->bottom = b; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect@p->top = t; rect->bottom = b; rect->left = l; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect@p->top = t; rect->bottom = b; rect->right = r; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect@p->right = r; rect->left = l; rect->top = t; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect@p->right = r; rect->left = l; rect->bottom = b; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect@p->right = r; rect->top = t; rect->left = l; rect->bottom = b;
+ SetRect(rect, l, t, r, b);
|
- rect@p->right = r; rect->top = t; rect->bottom = b; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect@p->right = r; rect->bottom = b; rect->left = l; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect@p->right = r; rect->bottom = b; rect->top = t; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect@p->bottom = b; rect->left = l; rect->top = t; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect@p->bottom = b; rect->left = l; rect->right = r; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect@p->bottom = b; rect->top = t; rect->left = l; rect->right = r;
+ SetRect(rect, l, t, r, b);
|
- rect@p->bottom = b; rect->top = t; rect->right = r; rect->left = l;
+ SetRect(rect, l, t, r, b);
|
- rect@p->bottom = b; rect->right = r; rect->left = l; rect->top = t;
+ SetRect(rect, l, t, r, b);
|
- rect@p->bottom = b; rect->right = r; rect->top = t; rect->left = l;
+ SetRect(rect, l, t, r, b);
)


@script:python depends on report@
p << sr2.p;
rect << sr2.rect;
l << sr2.l;
t << sr2.t;
r << sr2.r;
b << sr2.b;
@@
setrect(p[0], rect, l, t, r, b)


@ sr3 depends on !skip @
RECT rect;
expression l, t, b;
position p;
@@
- rect@p.left = l;
- rect.top = t;
- rect.right = rect.bottom = b;
+ SetRect(&rect, l, t, b, b);


@script:python depends on report@
p << sr3.p;
rect << sr3.rect;
l << sr3.l;
t << sr3.t;
b << sr3.b;
@@
setrect(p[0], rect, l, t, b, b)


@ sr4 depends on !skip disable ptr_to_array @
RECT *rect;
expression l, t, b;
position p;
@@
- rect@p->left = l;
- rect->top = t;
- rect->right = rect->bottom = b;
+ SetRect(rect, l, t, b, b);


@script:python depends on report@
p << sr4.p;
rect << sr4.rect;
l << sr4.l;
t << sr4.t;
b << sr4.b;
@@
setrect(p[0], rect, l, t, b, b)


@ sr5 depends on !skip @
RECT rect;
expression t, r, b;
position p;
@@
- rect@p.left = rect.top = t;
- rect.right = r;
- rect.bottom = b;
+ SetRect(&rect, t, t, r, b);


@script:python depends on report@
p << sr5.p;
rect << sr5.rect;
t << sr5.t;
r << sr5.r;
b << sr5.b;
@@
setrect(p[0], rect, t, t, r, b)


@ sr6 depends on !skip disable ptr_to_array @
RECT *rect;
expression t, r, b;
position p;
@@
- rect@p->left = rect->top = t;
- rect->right = r;
- rect->bottom = b;
+ SetRect(rect, t, t, r, b);


@script:python depends on report@
p << sr6.p;
rect << sr6.rect;
t << sr6.t;
r << sr6.r;
b << sr6.b;
@@
setrect(p[0], rect, t, t, r, b)


@ sr7 depends on !skip @
RECT rect;
expression t, b;
position p;
@@
- rect@p.left = rect.top = t;
- rect.right = rect.bottom = b;
+ SetRect(&rect, t, t, b, b);


@script:python depends on report@
p << sr7.p;
rect << sr7.rect;
t << sr7.t;
b << sr7.b;
@@
setrect(p[0], rect, t, t, b, b)


@ sr8 depends on !skip disable ptr_to_array @
RECT *rect;
expression t, b;
position p;
@@
- rect@p->left = rect->top = t;
- rect->right = rect->bottom = b;
+ SetRect(rect, t, t, b, b);


@script:python depends on report@
p << sr8.p;
rect << sr8.rect;
t << sr8.t;
b << sr8.b;
@@
setrect(p[0], rect, t, t, b, b)


@ sr9 depends on !skip @
RECT rect;
expression l, b;
position p;
@@
- rect@p.left = l;
- rect.top = rect.right = rect.bottom = b;
+ SetRect(&rect, l, b, b, b);


@script:python depends on report@
p << sr9.p;
rect << sr9.rect;
l << sr9.l;
b << sr9.b;
@@
setrect(p[0], rect, l, b, b, b)


@ sr10 depends on !skip disable ptr_to_array @
RECT *rect;
expression l, b;
position p;
@@
- rect@p->left = l;
- rect->top = rect->right = rect->bottom = b;
+ SetRect(rect, l, b, b, b);


@script:python depends on report@
p << sr10.p;
rect << sr10.rect;
l << sr10.l;
b << sr10.b;
@@
setrect(p[0], rect, l, b, b, b)


@ sr11 depends on !skip @
RECT rect;
expression b;
position p;
@@
- rect@p.left = rect.top = rect.right = rect.bottom = b;
+ SetRect(&rect, b, b, b, b);


@script:python depends on report@
p << sr11.p;
rect << sr11.rect;
b << sr11.b;
@@
setrect(p[0], rect, b, b, b, b)


@ sr12 depends on !skip disable ptr_to_array @
RECT *rect;
expression b;
position p;
@@
- rect@p->left = rect->top = rect->right = rect->bottom = b;
+ SetRect(rect, b, b, b, b);


@script:python depends on report@
p << sr12.p;
rect << sr12.rect;
b << sr12.b;
@@
setrect(p[0], rect, b, b, b, b)


@ memset @
RECT *rect;
position p;
@@
- memset@p
+ SetRectEmpty
              (rect
-                  , 0, ...
                   )


@script:python depends on report@
p << memset.p;
@@
WARN(p[0], "use SetRectEmpty() instead of memset()")


// SetRect() calls that should be something else
@ sre @
expression rect;
position p;
@@
- SetRect@p
+ SetRectEmpty
         (rect,
-            0, 0, 0, 0
         )


@script:python depends on report@
p << sre.p;
@@
WARN(p[0], "use SetRectEmpty() instead of SetRect()")


@ assign @
expression r1;
RECT r2;
RECT *r3;
position p;
@@
(
- SetRect@p(&r1, r2.left, r2.top, r2.right, r2.bottom)
+ r1 = r2
|
- SetRect@p(&r1, r3->left, r3->top, r3->right, r3->bottom)
+ r1 = *r3
|
- SetRect@p(r1, r2.left, r2.top, r2.right, r2.bottom)
+ *r1 = r2
|
- SetRect@p(r1, r3->left, r3->top, r3->right, r3->bottom)
+ *r1 = *r3
)


@script:python depends on report@
p << assign.p;
@@
WARN(p[0], "use a struct assignment instead of SetRect() to copy a RECT")


// SetRectEmpty() calls that should be a SetRect()
@ nosre @
expression rect, l;
position p;
@@
- SetRectEmpty@p
+ SetRect
         (&rect
+                 , l, 0, 0, 0
         );
- rect.left = l;


@script:python depends on report@
p << nosre.p;
@@
WARN(p[0], "use SetRect() instead of SetRectEmpty() followed be an assigment to a RECT field")


// Sanity check to not use an RECT field in the SetRect.
@ depends on !report disable ptr_to_array @
expression rect;
identifier fld;
@@
(
  SetRect(&rect, ...,
-                     <+... rect.fld ...+>
+                     BADBADBAD
                                ,...)
|
  SetRect(&rect, ...,
-                     <+... rect.fld ...+>
+                     BADBADBAD
                                )
|
  SetRect(rect, ...,
-                     <+... rect->fld ...+>
+                     BADBADBAD
                                ,...)
|
  SetRect(rect, ...,
-                     <+... rect->fld ...+>
+                     BADBADBAD
                                )
)
