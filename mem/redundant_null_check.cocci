// Check for redundant NULL checks before free() and similar functions.
// free(NULL) is a no-op.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes --disable-worth-trying-opt

@@
expression E;
type T;
identifier fn = {CoTaskMemFree, free, Free, GdipFree, HeapFree, heap_free, I_RpcFree, msi_free, MSVCRT_free, MyFree, RtlFreeHeap, SysFreeString};
@@
- if (E != NULL)
  {
       fn(..., (T)E);
  }
