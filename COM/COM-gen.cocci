// Script to generate a Coccinelle script that can perform the COM changes
// for an interface.

@initialize:python@
found = 0

@ find @
type Tv;
identifier lpVtbl ~= "^lp.*Vtbl$";
type obj;
@@
  typedef struct {
      ...
      Tv *lpVtbl;
      ...
  } obj;

@script:python@
fullIIFaceVtbl << find.Tv;
lpVtbl << find.lpVtbl;
Object << find.obj;
@@
print("// Generated Wine COM cleanup cocci file\n")
if found:
    cocci.include_match(False)
found = 1

IIFaceVtbl = fullIIFaceVtbl.lstrip("const ")
IIFace = IIFaceVtbl.rstrip("Vtbl")
IIFace_iface = IIFace + "_iface"

////////////////////////
// Generate the rules //
////////////////////////
print("""
// Change the COM object
@ object @
typedef %s;
typedef %s;
type obj;
@@
  typedef struct {
      ...
-     %s *%s;
+     %s %s;
      ...
  } obj;
""" % (IIFaceVtbl, IIFace, fullIIFaceVtbl, lpVtbl, IIFace, IIFace_iface))

print("""
// Implement impl_from_IFace if it doesn't exist yet
@ has_impl @
typedef %s;
identifier iface;
@@
  static inline %s *impl_from_%s(%s *iface)
  {
      ...
  }

@ depends on !has_impl @
type object.obj;
@@
  typedef struct { ... } obj;
+
+ static inline %s *impl_from_%s(%s *iface)
+ {
+     return CONTAINING_RECORD(iface, %s, %s);
+ }
""" % (Object, Object, IIFace, IIFace, Object, IIFace, IIFace, Object, IIFace_iface))

print("""
// Fixup declarations of *This
@ disable drop_cast @
identifier This;
%s *iface;
@@
  %s *This =
-            (%s *)iface;
+            impl_from_%s(iface);
""" % (IIFace, Object, Object, IIFace))

print("""
// Replace all object to interface casts to address of instance expressions
@ disable drop_cast @
@@
- (%s *) &This->%s
+ &This->%s
""" % (IIFace, lpVtbl, IIFace_iface))

print("""
// Cleanups
@@
type T;
identifier iface, vtbl;
@@
- return (T *)((char *)iface - FIELD_OFFSET(T, vtbl));
+ return CONTAINING_RECORD(iface, T, vtbl);
""")
