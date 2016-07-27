// Drop redundant memset before memcpy.
// No point in initializing the memory if it gets overwritten immediately.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
expression e1,e2,e3,e4;
@@
(
- memset(e1,e2,e3);
|
- FillMemory(e1,e2,e3);
|
- RtlFillMemory(e1,e2,e3);
|
- ZeroMemory(e1,e3);
|
- RtlZeroMemory(e1,e3);
)
... when != e1
(
  memcpy(e1,e4,e3);
|
  FillMemory(e1,e3,e4);
|
  RtlFillMemory(e1,e3,e4);
)
