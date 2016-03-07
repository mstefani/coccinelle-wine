// Wine tests:
// Verify that a variable isn't checked in two ok() calls without being
// modified in between.
//
// Confidence: Medium
// Copyright:  Michael Stefaniuc <mstefani@winehq.org>
// License:    LGPLv2.1+
//
// TODO:
//    - Make the checks more generic (only "equal" comparison are supported)
//    - Handle global variables.
//    - False positives: var1 == var2 <op> expression
//

//// Generic but non working code.
//@@
//idexpression ret;
//@@
// ok(<+... ret ...+>, ...);
// ... when != ret
//*ok(<+... ret ...+>, ...);

virtual expect

// Eliminate false positives due to ok(var1 == var2, ...)
// FIXME: Eliminates too much, should be more specific.
@v1v2@
local idexpression var1, var2;
position p;
@@
 ok@p(var1 == var2, ...)

// Eliminate false positives due to ok(var == f(), ...)
@vfunc@
local idexpression var;
expression f;
position p;
@@
 ok@p(var == f(...), ...)

// Verify that a variable isn't checked in two ok() calls without being
// modified in between.
@@
local idexpression hr;
position p1 != vfunc.p;
position p2 != {v1v2.p, vfunc.p};
expression E1, E2, E3, f, Ef1, Ef2;
type T;
@@
 ok@p1(hr == E1, ...)
 ... when != \( hr = E2 \| f(..., \( (T)&hr \| Ef1 ? (T)&hr : Ef2 \), ...) \)
-ok@p2
+NOTOK
      (hr == E3, ...)

@msg depends on expect@
constant C, fmt;
expression E;
position p;
type T;
@@
 ok@p(E == (T)C, fmt, ...)

@initialize:python@
@@
import re

@script:python msgfix@
C << msg.C;
fmt << msg.fmt;
newfmt;
@@
if re.search(r"\bexpect(?:ed)?\b", fmt, re.I) and not re.search(r"\b" + re.escape(C) + r"\b", fmt, re.I):
        # Negative numeric constants have a space between "-" and the number
        replace = r"\g<1>" + re.sub(r"-\s+", r"-", C)
        coccinelle.newfmt = re.sub(r"(\bexpect(?:ed)?\s+)[\w-]+", replace, fmt)
else:
    cocci.include_match(False)

@@
constant msg.fmt;
position msg.p;
identifier msgfix.newfmt;
@@
 ok@p(...,
-        fmt
+        newfmt
         , ...)
