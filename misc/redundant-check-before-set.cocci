// Redundant check of a variable before being set
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes --include-headers

virtual report

@initialize:python@
@@
def WARN(pos, var, val):
    var = var.translate(str.maketrans('', '', ' '))
    val = val.translate(str.maketrans('', '', ' '))
    print("%s:%s: Warning: Redundant check for '%s != %s'" % (pos.file, pos.line, var, val), flush=True)


@ r @
expression var, val;
position p;
@@
- if (var@p != val)
  {
      var = val;
  }

@script:python depends on report@
p << r.p;
var << r.var;
val << r.val;
@@
WARN(p[0], var, val)
