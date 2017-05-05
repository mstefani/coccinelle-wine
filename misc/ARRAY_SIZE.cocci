// Use the available ARRAY_SIZE instead of sizeof(array)/sizeof(element)
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --include-headers

virtual report

@initialize:python@
@@
def WARN(pos):
    print("%s:%s: Warning: In function %s use the available ARRAY_SIZE() macro" % (pos.file, pos.line, pos.current_element), flush=True)


@ array_size @
@@
#define ARRAY_SIZE ...


@ r depends on array_size @
type T;
T[] E;
position p;
@@
(
- (sizeof(E@p)/sizeof(E[...]))
+ ARRAY_SIZE(E)
|
- (sizeof(E@p)/sizeof(*E))
+ ARRAY_SIZE(E)
|
- (sizeof(E@p)/sizeof(T))
+ ARRAY_SIZE(E)
)


@script:python depends on report@
p << r.p;
@@
WARN(p[0])
