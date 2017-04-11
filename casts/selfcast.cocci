// Casting an expression to its own type is a no-op and thus pointless.
//
// Confidence: High (Medium in reality due to coccinelle limitations)
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options:

virtual report


@ r disable drop_cast @
type T;
T E;
position p;
@@
- (T)
     E@p

@ script:python depends on report @
p << r.p;
T << r.T;
E << r.E;
@@
print("%s:%s: Warning: In function %s explicit cast of '%s' to its own type '%s'" % (p[0].file, p[0].line, p[0].current_element, E, T), flush=True)
