// Avoid the direct use of COM methods
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --timeout 300

virtual report


@initialize:python@
@@
import re

def WARN(pos, good, bad):
    print("%s:%s: Warning: Use the COM C macro %s instead of the implementation %s" % (pos.file, pos.line, good, bad), flush=True)


@find disable ptr_to_array@
identifier vtbl;
identifier iface =~ "([vV]tbl|_iface$|^IUnknown_inner$)";
expression obj;
@@
(
  obj->iface.lpVtbl = &vtbl;
|
  obj.iface.lpVtbl = &vtbl;
)


@vtable@
identifier find.vtbl;
identifier method;
type T;
@@
  T vtbl = {
      ...,
      method,
      ...,
  };


@script:python gen@
method << vtable.method;
iface << find.iface;
cobjmacro;
@@
interface = "IUnknown"
if iface != "IUnknown_inner":
    interface = re.sub("_iface", "", iface)
newmethod = re.sub("^.*(?=_[^_]+$)", "", method)
coccinelle.cobjmacro = interface + newmethod


@usage@
identifier vtable.method;
identifier gen.cobjmacro;
position p;
@@
- method@p
+ cobjmacro
           (...);


@script:python depends on report@
p << usage.p;
good << gen.cobjmacro;
bad << vtable.method;
@@
WARN(p[0], good, bad)


//@@
//identifier vtable.method;
//type T;
//@@
//- T method(...);
