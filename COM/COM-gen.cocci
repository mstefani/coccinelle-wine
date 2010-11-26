// Script to generate a Coccinelle script that can perform the COM changes
// for an interface.

@initialize:python@
found = 0

@ find @
type Tv;
identifier lpVtbl ~= "^lp.*Vtbl$";
@@
  struct {
      ...
      Tv *lpVtbl;
      ...
  }

@script:python@
Tv << find.Tv;
lpVtbl << find.lpVtbl;
@@
print("// Generated Wine COM cleanup cocci file\n")
if found:
    cocci.include_match(False)
found = 1

Tv_pure = Tv.lstrip("const ")
Ti = Tv_pure.rstrip("Vtbl")
iface = Ti + "_iface"

// Generate the rules
print("""
// Change the COM object
@ object @
typedef %s;
typedef %s;
@@
  struct {
      ...
-     %s *%s;
+     %s %s;
      ...
  }
""" % (Tv_pure, Ti, Tv, lpVtbl, Ti, iface))

print("""
// Replace all object to interface casts to address of instance expressions
@ disable drop_cast @
@@
- (%s *) &This->%s
+ &This->%s
""" % (Ti, lpVtbl, iface))

print("""
// Cleanups
@@
type T;
identifier iface, vtbl;
@@
- return (T *)((char *)iface - FIELD_OFFSET(T, vtbl));
+ return CONTAINING_RECORD(iface, T, vtbl);
""")
