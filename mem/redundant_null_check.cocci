// Check for redundant NULL checks before free() and similar functions.
// free(NULL) is a no-op.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
expression E;
type T;
@@
- if (E != NULL)
- {
       \(CoTaskMemFree\|free\|Free\|GdipFree\|HeapFree\|heap_free\|I_RpcFree\|msi_free\|MSVCRT_free\|MyFree\|RtlFreeHeap\|SysFreeString\)(..., (T)E);
- }


@@
expression E;
type T;
@@
- if (E != NULL)
       \(CoTaskMemFree\|free\|Free\|GdipFree\|HeapFree\|heap_free\|I_RpcFree\|msi_free\|MSVCRT_free\|MyFree\|RtlFreeHeap\|SysFreeString\)(..., (T)E);
