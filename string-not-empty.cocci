// Don't use strlen() to check for an empty string.
// Fixes V805 from PVS-Studio.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report


@initialize:python@
@@
def WARN(pos, func):
    print("%s:%s: Warning: In function %s don't use %s() to check for an empty string" % (pos.file, pos.line, pos.current_element, func), flush=True)


@ strlen @
identifier len =~ "strlen";
expression str;
position p;
@@
(
- (len@p(str) > 0)
+ str[0]
|
- (len@p(str) == 0)
+ !str[0]
)


@script:python depends on report@
p << strlen.p;
len << strlen.len;
@@
WARN(p[0], len)


@ strcmp @
expression str;
position p;
@@
- !strcmp@p(str, "")
+ !str[0]


@script:python depends on report@
p << strcmp.p;
@@
WARN(p[0], "strcmp")
