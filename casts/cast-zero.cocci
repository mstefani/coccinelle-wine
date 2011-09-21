// Casting 0 should be avoided if not needed. Either use NULL or
// drop the cast.
// Warning: Has some false positives in Wine.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@redhat.com>

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

@ disable drop_cast @
type T;
position p != bitwise.p;
@@
- (T)@p
  0
