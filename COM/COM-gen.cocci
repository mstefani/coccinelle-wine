// Script to generate a Coccinelle script that can perform the COM changes
// for an interface.

@initialize:python@
found = 0

@ find @
type Tv;
identifier lpVtbl ~= ".*[vV]tbl$";
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
if found:
    cocci.include_match(False)
    quit()
// Cross check if we found the right member
if not fullIIFaceVtbl.endswith("Vtbl"):
    cocci.include_match(False)
    quit()
found = 1

if fullIIFaceVtbl.startswith("const "):
    IIFaceVtbl = fullIIFaceVtbl[6:]
else:
    IIFaceVtbl = fullIIFaceVtbl
IIFace = IIFaceVtbl[:-4]        # strip the "Vtbl"
IIFace_iface = IIFace + "_iface"

////////////////////////
// Generate the rules //
////////////////////////
print("// Generated Wine COM cleanup cocci file\n")
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
// Fixup the initialization of the object
@@
typedef %s;
%s *This;
identifier Vtbl;
@@
- This->%s = &Vtbl
+ This->%s.lpVtbl = &Vtbl

@@
identifier obj;
identifier vtbl ~= "%s"; // FIXME: Dynamically detect the Vtbl
@@
  static %s obj = {
      ...,
-     &vtbl,
+     { &vtbl },
      ...,
  };
""" % (Object, Object, lpVtbl, IIFace_iface, Object + "Vtbl", Object))


print("""
// Implement impl_from_IFace if it doesn't exist yet
@ has_impl @
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
""" % (Object, IIFace, IIFace, Object, IIFace, IIFace, Object, IIFace_iface))

print("""
@ depends on has_impl disable drop_cast @
type T;
identifier iface;
@@
(
- return (T *)((char *)iface - FIELD_OFFSET(T, %s));
+ return CONTAINING_RECORD(iface, T, %s);
|
- return CONTAINING_RECORD(iface, T, %s);
+ return CONTAINING_RECORD(iface, T, %s);
)
""" % (lpVtbl, IIFace_iface, lpVtbl, IIFace_iface))

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
%s *This;
@@
- (%s *)&This->%s
+ &This->%s

@ disable drop_cast @
%s *This;
@@
- (%s *)This
+ &This->%s
""" % (Object, IIFace, lpVtbl, IIFace_iface, Object, IIFace, IIFace_iface))

print("""
// Replace the other member accesses too
@@
%s *This;
@@
- &This->%s
+ &This->%s
""" % (Object, lpVtbl, IIFace_iface))
