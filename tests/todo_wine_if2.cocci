// Use todo_wine_if() instead of if with duplicated if and else branch.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: The code needs to be prepared for this script with:
//           perl -pi -e 's/\btodo_wine\b//g' `git grep -w -l todo_wine`
//           The generated diff is not usable as is and the code needs to be manually modified


@disable drop_else@
statement S;
@@
  if (...) {
      S
  }
- else {
-     S
- }
