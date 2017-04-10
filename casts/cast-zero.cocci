// Casting 0 should be avoided if not needed. Either use NULL or
// drop the cast.
// Warning: Has some false positives in Wine.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes

virtual report


@ bitwise disable drop_cast @
identifier i;
position p;
type T;
@@
(
  ~((T)@p 0)
|
  ((T)@p 0)->i
|
  *((T)@p 0)
)


@ r disable drop_cast @
type T;
position p != bitwise.p;
@@
- (T)@p
  0


@ script:python depends on report @
p << r.p;
T << r.T;
@@
print("%s:%s: Warning: In function %s do not cast 0 to %s" % (p[0].file, p[0].line, p[0].current_element, T), flush=True)
