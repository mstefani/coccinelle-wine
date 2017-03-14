// Use struct assignment instead of CopyRect().
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report


@initialize:python@
@@
def WARN(pos):
    print("%s:%s: Warning: In function %s use struct assignment instead of CopyRect()" % (pos.file, pos.line, pos.current_element), flush=True)


@copy@
expression r1, r2;
position p;
@@
(
- CopyRect@p(&r1, &r2)
+ r1 = r2
|
- CopyRect@p(r1, r2)
+ *r1 = *r2
)


@script:python depends on report@
p << copy.p;
@@
WARN(p[0])


// Cleanup of the generated patch
@depends on copy && !report@
expression r;
@@
- *&
    r
