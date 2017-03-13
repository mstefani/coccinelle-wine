// Casting NULL is always wrong in C; either not needed or 0 should
// be used instead.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes

virtual report


@initialize:python@
@@
def WARN(pos, msg):
    print("%s:%s: Warning: In function %s %s" % (pos.file, pos.line, pos.current_element, msg), flush=True)


@ zero disable drop_cast @
typedef LPARAM;
typedef WPARAM;
position p;
@@
(
- (LPARAM) NULL@p
+ 0
|
- (WPARAM) NULL@p
+ 0
)


@ script:python depends on report @
p << zero.p;
@@
WARN(p[0], "use 0 instead of casting NULL")


@ null disable drop_cast @
type T;
position p;
@@
- (T@p)
  NULL


@ script:python depends on report @
p << null.p;
T << null.T;
@@
WARN(p[0], "do not cast NULL to " + T)
