// Avoid the direct use of COM methods
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --timeout 300


@initialize:python@
@@
import re


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
cobjmacro;
@@
if not method.startswith("I"):
    newmethod = "I" + method
else:
    newmethod = method
coccinelle.cobjmacro = re.sub("Impl_", "_", newmethod)


@usage@
identifier vtable.method;
identifier gen.cobjmacro;
@@
- method
+ cobjmacro
           (...);


//@@
//identifier vtable.method;
//type T;
//@@
//- T method(...);
