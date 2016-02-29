// Casting an expression to its own type is a no-op and thus pointless.
//
// Confidence: High (Medium in reality due to coccinelle limitations)
// Copyright: Michael Stefaniuc <mstefani@redhat.com>

@ disable drop_cast @
type T;
T E;
@@
- (T)
     E
