// Validate the debug info of critical sections.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report


@initialize:python@
@@
import re

def ERR(pos, cs):
    print("%s:%s: Error: Assign the correct CRITICAL_SECTION_DEBUG to %s" % (pos.file, pos.line, cs), flush=True)


@ r @
typedef CRITICAL_SECTION_DEBUG;
identifier cs, cs_debug, wrong;
type T;
expression e1, e2, e3, e4, name;
position p;
@@
  CRITICAL_SECTION_DEBUG cs_debug@p =
  {
      e1, e2, &cs,
      {
(
        &cs_debug.ProcessLocksList
|
-       &wrong.ProcessLocksList
+       &cs_debug.ProcessLocksList
)
        ,
(
        &cs_debug.ProcessLocksList
|
-       &wrong.ProcessLocksList
+       &cs_debug.ProcessLocksList
)
      },
      e3, e4, { (T)(name) }
  };


@script:python depends on report@
p << r.p;
cs_debug << r.cs_debug;
wrong << r.wrong;
@@
if wrong != cs_debug:
    ERR(p[0], cs_debug)
