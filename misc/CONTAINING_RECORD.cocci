// Replace open coded offsetof / FIELD_OFFSET and CONTAINING_RECORD
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report


@initialize:python@
@@
def WARN(pos, func):
    print("%s:%s: Warning: In function %s use %s() instead of open coding it" % (pos.file, pos.line, pos.current_element, func), flush=True)


@ offset @
identifier f;
type t, T;
position p;
@@
- (t)&((T *)\(0\|NULL\))->f@p
+ offsetof(T, f)


@ script:python depends on report @
p << offset.p;
@@
WARN(p[0], "offsetof")


@ cont @
expression ptr;
identifier f;
type onebyte, T;
typedef PCHAR;
position p;
@@
- (T *)((\(onebyte *\|PCHAR\))ptr@p - \(FIELD_OFFSET\|offsetof\)(T, f))
+ CONTAINING_RECORD(ptr, T, f)


@ script:python depends on report @
p << cont.p;
@@
WARN(p[0], "CONTAINING_RECORD")
