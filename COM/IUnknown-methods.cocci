// Avoid to use the IUnknown methods directly. Prefer instead the interface specific
// C wrappers.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --no-includes --timeout 300
//

virtual report


@initialize:python@
@@
import re


@ find @
identifier IUnknown_method = { IUnknown_QueryInterface, IUnknown_AddRef, IUnknown_Release };
type T;
T E;
position p;
@@
  IUnknown_method@p(E, ...)


@ script:python gen @
IUnknown_method << find.IUnknown_method;
T << find.T;
method;
@@
Tiface = re.sub(r"[ *]", "", T)
coccinelle.method = re.sub("IUnknown", Tiface, IUnknown_method)


@ depends on !report @
identifier find.IUnknown_method;
position find.p;
identifier gen.method;
@@
- IUnknown_method@p
+ method


@script:python depends on report@
IUnknown_method << find.IUnknown_method;
p << find.p;
method << gen.method;
@@
print("%s:%s: Warning: In function %s use '%s' instead of '%s'" % (p[0].file, p[0].line, p[0].current_element, method, IUnknown_method), flush=True)
