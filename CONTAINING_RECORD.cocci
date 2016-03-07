// Replace open coded offsetof / FIELD_OFFSET and CONTAINING_RECORD
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes

@@
identifier f;
type t, T;
@@
- (t)&((T *)\(0\|NULL\))->f
+ offsetof(T, f)

@@
expression ptr;
identifier f;
type onebyte, T;
typedef PCHAR;
@@
- (T *)((\(onebyte *\|PCHAR\))ptr - \(FIELD_OFFSET\|offsetof\)(T, f))
+ CONTAINING_RECORD(ptr, T, f)
