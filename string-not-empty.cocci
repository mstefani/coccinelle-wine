// Don't use strlen() to check for an empty string.
// Fixes V805 from PVS-Studio.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
identifier len =~ "strlen";
expression str;
@@
(
- (len(str) > 0)
+ str[0]
|
- (len(str) == 0)
+ !str[0]
)


@@
expression str;
@@
- !strcmp(str, "")
+ !str[0]
