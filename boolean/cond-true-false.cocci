// Avoid excessive "expression ? TRUE : FALSE" constructs.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
expression E1, E2;
@@
- (
(
   E1 == E2
|
   E1 != E2
)
- ) ? TRUE : FALSE

@@
expression E1, E2;
@@
(
  E1 == E2
|
  E1 != E2
)
- ? TRUE : FALSE

@@
type T;
T *E;
@@
  E
-   ? TRUE : FALSE
+   != NULL

@@
expression E;
@@
  E
-   ? TRUE : FALSE
+   != 0

@@
expression E1, E2;
@@
  E1
-    ==
+    !=
        E2
-          ? FALSE : TRUE


@@
expression E;
@@
+ !
   E
-    ? FALSE : TRUE


// Deal with the unary & having lower projority than == or !=
@@
expression E1, E2;
@@
+ (
   E1 & E2
+ )
  == \(0 \| NULL\)

@@
expression E1, E2;
@@
+ (
   E1 & E2
+ )
  != \(0 \| NULL\)
