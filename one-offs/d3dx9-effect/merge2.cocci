@base@
identifier virtual.func;
identifier fld;
symbol base;
type T;
@@
  T func(...)
  {
      <...
(
-     base->
+     effect->base_effect.
            fld
|
-     base
+     &effect->base_effect
)
      ...>
  }


@exists@
identifier virtual.func;
identifier i;
typedef UINT;
type T;
@@
  T func(...)
  {
      ...
-     UINT
+     unsigned int
          i;
      ...
  }


@exists@
identifier virtual.func;
statement S;
type T;
@@
  T func(...)
  {
      ...
      for(...; ...; ...)
-     {
           S
-     }
      ...
  }


@r@
identifier virtual.func;
identifier trace = { ERR, FIXME, TRACE, WARN };
constant fmt;
type T;
position p;
@@
  T func(...)
  {
      <+...
      trace@p(fmt, ...);
      ...+>
  }


@script:python n@
fmt << r.fmt;
newfmt;
@@
if not fmt.endswith(".\\n\""):
    coccinelle.newfmt = fmt[0:-3] + ".\\n\""
    print(fmt, flush=True)
    print(coccinelle.newfmt, flush=True)
else:
    cocci.include_match(False)


@@
identifier r.trace;
constant r.fmt;
identifier n.newfmt;
position r.p;
@@
  trace@p(
-         fmt
+         newfmt
          , ...)

