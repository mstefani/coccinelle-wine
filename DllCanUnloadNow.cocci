// Returning S_FALSE in DllCanUnloadNow() is perfectly fine as an
// implementation of that function. Don't output a FIXME there.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@redhat.com>

@@ @@
  DllCanUnloadNow( ... ) {
      ...
-     FIXME( ... );
      ...
  }

