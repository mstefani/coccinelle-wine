// Use todo_wine_if() instead of if with duplicated if and else branch.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: The code needs to be prepared for this script with:
//           perl -pi -e 's/\btodo_wine\b/(todo_wine)/g' `git grep -w -l todo_wine`
//           The generated diff needs to be fixed too:
//           perl -pi -e '/^+.*todo_wine_if/ and do {s/\bif ?\(//; s/\)([^)]*$)/$1/}; /^-/ and s/\(todo_wine\)/todo_wine/g;' tests/todo_wine_if.out

@disable drop_else, drop_cast@
typedef todo_wine;
expression cond, ok;
@@
  if (
+     todo_wine_if(
                   cond
+                   )
                     ) {
-         (todo_wine)
                ok;
  }
- else {
-         ok;
- }

@disable drop_else, drop_cast@
expression cond, ok;
@@
  if (
+     todo_wine_if(!(
                   cond
+                   ))
                     ) {
          ok;
  }
- else {
-         (todo_wine) ok;
- }
