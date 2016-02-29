// Returning S_FALSE in DllCanUnloadNow() is perfectly fine as an
// implementation of that function. Don't output a FIXME there.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>

@@ @@
  DllCanUnloadNow( ... ) {
      ...
-     FIXME( ... );
      ...
  }

@@
identifier trace =~ "^(ERR|FIXME|TRACE|WARN)$";
@@

  DllCanUnloadNow( ... ) {
?     trace(...);
      return
-         S_OK
+         S_FALSE
      ;
  }
