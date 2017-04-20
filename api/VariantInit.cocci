// Use VariantInit() instead of open coding it.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

virtual report


@r@
expression variant;
position p;
@@
- V_VT@p(variant) = VT_EMPTY
+ VariantInit(variant)


@script:python depends on report@
p << r.p;
@@
print("%s:%s: Warning: In function %s use VariantInit() instead of open coding it" % (p[0].file, p[0].line, p[0].current_element), flush=True)
