// Use the available ARRAY_SIZE instead of sizeof(array)/sizeof(element)
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --include-headers --disable-worth-trying-opt

virtual report

@initialize:python@
@@
def WARN(pos):
    print("%s:%s: Warning: In function %s use the available ARRAY_SIZE() macro" % (pos.file, pos.line, pos.current_element), flush=True)


@ testh @
@@
(
 #include <wine/test.h>
|
 #include "wine/test.h"
)

@ array_size depends on !testh @
identifier a;
@@
(
#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
|
#define ARRAY_SIZE(a) (sizeof(a) / sizeof(*(a)))
)


@ r depends on (array_size || testh) @
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
