// Remove the 'register' storage class specifier.
// It is just a hint that the compiler can freely ignore.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
type T;
identifier I;
@@
- register
        T I;

@@
type T;
identifier I;
@@
- register
        T I = ...;
