// Remove the 'register' storage class specifier.
// It is just a hint that the compiler can freely ignore.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report


@initialize:python@
@@
def WARN(pos):
    print("%s:%s: Warning: In function %s using 'register' is obsolescent" % (pos.file, pos.line, pos.current_element), flush=True)


@ r @
type T;
identifier I;
position p;
@@
(
- register@p
        T I;
|
- register@p
        T I = ...;
)


@ script:python depends on report @
p << r.p;
@@
WARN(p[0])
