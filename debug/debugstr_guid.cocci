// Use the debugstr_guid helper instead of open coding it.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
// Comments: Make use of the new format string support from coccinelle.

@@
identifier func;
expression E;
@@
 func(...,
-       E.Data1, E.Data2, E.Data3, E.Data4[0], E.Data4[1], E.Data4[2],
-       E.Data4[3], E.Data4[4], E.Data4[5], E.Data4[6], E.Data4[7]
+       debugstr_guid(E)
 , ... )
