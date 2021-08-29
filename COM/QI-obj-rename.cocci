// Third argument of QueryInterface holds an interface pointer and not a COM object.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes --timeout 300
//

virtual report

@r@
identifier QueryInterface =~ "_QueryInterface$";
identifier ppobj =~ "[oO]bj";
identifier iface, riid;
type Ti, Tr, Tv;
position p;
@@
 QueryInterface(Ti *iface, Tr riid, Tv
-                                        ppobj@p
+                                        ret_iface
                                                  )
 {
     <...
-        ppobj
+        ret_iface
     ...>
 }


@script:python depends on report@
ppobj << r.ppobj;
p << r.p;
@@
print("%s:%s: Warning: In function %s misleading 3rd parameter name '%s', use 'ret_iface' instead" % (p[0].file, p[0].line, p[0].current_element, ppobj), flush=True)
