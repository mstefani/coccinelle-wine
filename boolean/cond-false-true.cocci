// Avoid excessive "expression ? FALSE : TRUE" constructs.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

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
