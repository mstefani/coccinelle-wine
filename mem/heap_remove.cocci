// Remove the old HeapAlloc() wrappers.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes --disable-worth-trying-opt

virtual report

@initialize:python@
@@
def WARN(pos, fn):
    print("%s:%s: Error: Open coded %s(). Include wine/heap.h instead" % (pos.file, pos.line, fn), flush=True)


@r@
type T;
position p;
identifier fn = {heap_alloc, heap_alloc_zero, heap_realloc, heap_free};
@@
- T fn@p(...)
- {
-      ...
- }


@script:python depends on report@
p << r.p;
fn << r.fn;
@@
WARN(p[0], fn)
