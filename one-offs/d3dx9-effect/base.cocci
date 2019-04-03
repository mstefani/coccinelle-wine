@r@
identifier func;
type T;
symbol base;
@@
 T func(..., struct d3dx9_base_effect *base, ...) { ... }


@script:python@
func << r.func;
@@
print("%s" % (func), flush=True)
