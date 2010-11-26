// Don't use negation for FAILED/SUCCEEDED
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@redhat.com>

@@ expression E; @@

(
- !SUCCEEDED(E)
+ FAILED(E)
|
- !FAILED(E)
+ SUCCEEDED(E)
)
