@r@
identifier virtual.func;
position p;
@@
 func@p(...)


@script:python@
p << r.p;
@@
print("%s:%s" % (p[0].current_element, p[0].line), flush=True)


@r2@
identifier virtual.fld;
expression E;
position p;
@@
 E->fld@p


@script:python@
p << r2.p;
@@
print("%s:%s" % (p[0].current_element, p[0].line), flush=True)
