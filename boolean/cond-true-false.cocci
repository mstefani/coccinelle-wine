// Avoid excessive "expression ? TRUE : FALSE" constructs.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report

@initialize:python@
@@
def WARN(pos, msg):
    print("%s:%s: Warning: In function %s avoid %s conditional expressions" % (pos.file, pos.line, pos.current_element, msg), flush=True)


@depends on !report@
expression E1, E2;
binary operator op = {&&, ||, ==, !=, >, >=, <, <=};
@@
(
- (
   E1 op E2
- ) ? TRUE : FALSE
|
   E1 op E2
-   ? TRUE : FALSE
)


@depends on !report@
identifier I;
expression E;
@@
(
+ !!
  I
-   ? TRUE : FALSE
|
+ !!
  E.I
-   ? TRUE : FALSE
|
+ !!
  E->I
-   ? TRUE : FALSE
)


@rt@
expression E;
position p;
@@
+ !!(
  E
+  )
-   ?@p TRUE : FALSE


@script:python depends on report@
p << rt.p;
@@
WARN(p[0], "TRUE : FALSE")


@depends on !report@
expression E1, E2;
@@
  E1
-    ==
+    !=
        E2
-          ? FALSE : TRUE


@rf@
expression E;
position p;
@@
+ !
   E
-    ?@p FALSE : TRUE


@script:python depends on report@
p << rf.p;
@@
WARN(p[0], "FALSE : TRUE")
