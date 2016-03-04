// Use the correct macro instead of casting the MAKELONG() result.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@ disable drop_cast @
typedef LPARAM, WPARAM;
@@

(
- (LPARAM) MAKELONG
+ MAKELPARAM
|
- (WPARAM) MAKELONG
+ MAKEWPARAM
)
  (...)

