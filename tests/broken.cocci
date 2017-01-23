// Check for wrong use of broken()
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes


// broken(CONSTANT) is wrong.
// Only exception that can make sense is broken(TRUE).
@@
constant C;
@@
(
  broken(\(TRUE\|1\))
|
* broken(C)
)


// Comparing an expression expr with something followed by an || broken(expr) is most likely
// incorrect.
@@
expression E1, E2;
binary operator comp = {==, !=, >, >=, <, <= };
@@
(
  E1 == 0 || broken(E1)
|
  SUCCEEDED(E1) == E2 || broken(SUCCEEDED(E1))
|
  E1 comp E2 ||
*               broken(\(E1\|E2\))
)
