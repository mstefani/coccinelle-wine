// Check for redundant NULL checks before free() and similar functions.
// free(NULL) is a no-op.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes --disable-worth-trying-opt

virtual report

@initialize:python@
@@
def WARN(pos, fn):
    print("%s:%s: Warning: Redundant NULL check before %s()" % (pos.file, pos.line, fn), flush=True)


@r@
expression E;
type T;
position p;
identifier fn = {CoTaskMemFree, free, Free, GdipFree, HeapFree, heap_free, I_RpcFree, msi_free, MSVCRT_free, MyFree, ReleaseStgMedium, RtlFreeHeap, SysFreeString};
@@
(
- if@p (E != NULL)
      fn(..., (T)E);
|
- if@p (E != NULL)
- {
      fn(..., (T)E);
?     E = NULL;
- }
)


@script:python depends on report@
p << r.p;
fn << r.fn;
@@
WARN(p[0], fn)
