// Check for redundant NULL checks before free() and similar functions.
// free(NULL) is a no-op.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
expression E;
@@
- if (E != NULL)
- {
       \(free\|HeapFree\|heap_free\|msi_free\|MSVCRT_free\)(..., E);
- }


@@
expression E;
@@
- if (E != NULL)
       \(free\|HeapFree\|heap_free\|msi_free\|MSVCRT_free\)(..., E);
