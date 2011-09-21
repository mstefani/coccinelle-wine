// Casting NULL is always wrong in C; either not needed or 0 should
// be used instead.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@redhat.com>

@ disable drop_cast @
typedef LPARAM;
typedef WPARAM;
@@
(
- (LPARAM) NULL
+ 0
|
- (WPARAM) NULL
+ 0
)

@ disable drop_cast @
type T;
@@
- (T)
  NULL
