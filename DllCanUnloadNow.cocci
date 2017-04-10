// Returning S_FALSE in DllCanUnloadNow() is perfectly fine as an
// implementation of that function. Don't output a FIXME there.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes

virtual report


@initialize:python@
@@
def WARN(pos, msg):
    print("%s:%s: Warning: %s in DllCanUnloadNow()" % (pos.file, pos.line, msg), flush=True)


@ fixme @
position p;
@@
  DllCanUnloadNow( ... ) {
      ...
-     FIXME@p( ... );
      ...
  }


@ script:python depends on report @
p << fixme.p;
@@
WARN(p[0], "Don't bother printing a FIXME")


@ sok @
identifier trace =~ "^(ERR|FIXME|TRACE|WARN)$";
position p;
@@

  DllCanUnloadNow( ... ) {
?     trace(...);
      return
-         S_OK@p
+         S_FALSE
      ;
  }


@ script:python depends on report @
p << sok.p;
@@
WARN(p[0], "Returning S_FALSE is better than S_OK")
