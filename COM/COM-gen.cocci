// Script to generate a Coccinelle script that can perform the COM changes
// for an interface.

@initialize:python@
@@
# Parsed stuff
fullIIFaceVtbl = ""
lpVtbl = ""
Object = ""
TObject = ""
tagObject = ""
# typedef and struct are separate for the Object
separate = 0
# Limit to only one match
found = 0
# Vtbl type
import re
r_Tvtbl = re.compile(r"\bI\w+Vtbl$")

@ find @
type obj, Tv;
identifier lpVtbl =~ "[vV]tbl";
identifier tag_obj;
@@
  typedef struct tag_obj {
      ...
      Tv *lpVtbl;
      ...
  } obj;

@ find2 @
type obj, Tv;
identifier lpVtbl =~ "[vV]tbl";
@@
  typedef struct {
      ...
      Tv *lpVtbl;
      ...
  } obj;

@ findS @
type Tv;
identifier lpVtbl =~ "[vV]tbl";
identifier tag_obj;
@@
  struct tag_obj {
      ...
      Tv *lpVtbl;
      ...
  }

@ findT @
identifier findS.tag_obj;
type obj;
@@
  typedef struct tag_obj obj;


@script:python@
Tvtbl << find.Tv;
vtbl << find.lpVtbl;
obj << find.obj;
tag_obj << find.tag_obj;
@@
if not found and r_Tvtbl.search(Tvtbl):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl
    Object = obj
    TObject = obj
    tagObject = tag_obj


@script:python@
Tvtbl << find2.Tv;
vtbl << find2.lpVtbl;
obj << find2.obj;
@@
if not found and r_Tvtbl.search(Tvtbl):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl
    Object = obj
    TObject = obj


@script:python@
Tvtbl << findS.Tv;
vtbl << findS.lpVtbl;
tag_obj << findS.tag_obj;
obj << findT.obj;
@@
if not found and r_Tvtbl.search(Tvtbl):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl
    Object = obj
    TObject = obj
    tagObject = tag_obj
    separate = 1


// "found" will take care of the double matching with the previous rule
@script:python@
Tvtbl << findS.Tv;
vtbl << findS.lpVtbl;
tag_obj << findS.tag_obj;
@@
if not found and r_Tvtbl.search(Tvtbl):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl
    Object = "struct " + tag_obj
    TObject = tag_obj
    tagObject = tag_obj
    separate = 1
    import sys
    print >> sys.stderr, ("Warning: Assuming \"typedef %s %s;\"" % (Object, TObject))


@finalize:python@
@@
if not found:
    quit()

if fullIIFaceVtbl.startswith("const IDocHostContainerVtbl"):
    quit()      # False positive, badly named type

if fullIIFaceVtbl.startswith("const "):
    IIFaceVtbl_struct = fullIIFaceVtbl[6:]
else:
    IIFaceVtbl_struct = fullIIFaceVtbl
if IIFaceVtbl_struct.startswith("struct "):
    IIFaceVtbl = IIFaceVtbl_struct[7:]
else:
    IIFaceVtbl = IIFaceVtbl_struct
IIFace = IIFaceVtbl[:-4]        # strip the "Vtbl"
IIFace_iface = IIFace + "_iface"
if IIFace[0] == "I":
    PIFACE = "P" + IIFace[1:].upper()
    LPIFACE = "LP" + IIFace[1:].upper()
else:
    PIFACE = "P" + IIFace.upper()
    LPIFACE = "LP" + IIFace.upper()
if len(tagObject) > 0:
    object_types = [TObject, "struct " + tagObject]
    object_types_header = "{" + TObject + ", struct " + tagObject + "}"
    tag_obj = "tag_obj"
else:
    object_types = [TObject]
    object_types_header = TObject
    tag_obj = ""

////////////////////////
// Generate the rules //
////////////////////////
print("// Generated Wine COM cleanup cocci file\n")
print("""
// First get rid of the PIFACE and LPIFACE aliases of IIFace*
@@
typedef %s;
typedef %s;
typedef %s;
@@
(
- %s
+ %s *
|
- %s
+ %s *
)
""" % (IIFace, PIFACE, LPIFACE, PIFACE, IIFace, LPIFACE, IIFace))

if not separate:
    print("""
// Change the COM object
@ object @
typedef %s;
type obj;
identifier tag_obj;
@@
  typedef struct %s {
      ...
-     %s *%s;
+     %s %s;
      ...
  } obj;
""" % (IIFaceVtbl, tag_obj, fullIIFaceVtbl, lpVtbl, IIFace, IIFace_iface))
else:
    print("""
// Change the COM object
@ object @
typedef %s;
identifier tag_obj;
@@
  struct tag_obj {
      ...
-     %s *%s;
+     %s %s;
      ...
  };
""" % (IIFaceVtbl, fullIIFaceVtbl, lpVtbl, IIFace, IIFace_iface))

print("""
// Fixup the initialization of the object
@@
typedef %s;
%s *This;
identifier _Vtbl_;
@@
- This->%s
+ This->%s.lpVtbl
                  = &_Vtbl_

@@
%s This;
identifier _Vtbl_;
@@
- This.%s = &_Vtbl_
+ This.%s.lpVtbl = &_Vtbl_

@@
identifier obj;
identifier vtbl =~ "%s"; // FIXME: Dynamically detect the Vtbl
@@
  static %s obj = {
      ...,
-     &vtbl,
+     { &vtbl },
      ...,
  };
""" % (TObject, Object, lpVtbl, IIFace_iface,
       Object, lpVtbl, IIFace_iface,
       TObject + "Vtbl", Object))

print("""
// Fixup vtbl pointer comparison
@@
%s *This;
identifier _Vtbl_;
@@
- This->%s == &_Vtbl_
+ This->%s.lpVtbl == &_Vtbl_

@@
%s This;
identifier _Vtbl_;
@@
- This.%s == &_Vtbl_
+ This.%s.lpVtbl == &_Vtbl_
""" % (Object, lpVtbl, IIFace_iface,
       Object, lpVtbl, IIFace_iface))

print("""
@ has_impl_from disable drop_cast @
type onebyte;
identifier iface, impl_from_IFace;
@@
  %s *
-      impl_from_IFace
+      impl_from_%s
                      (%s *iface)
  {
(
-      return CONTAINING_RECORD(iface, %s, %s);
+      return CONTAINING_RECORD(iface, %s, %s);
|
-      return (%s *)((onebyte *)(iface) - \(FIELD_OFFSET\|offsetof\)(%s, %s));
+      return CONTAINING_RECORD(iface, %s, %s);
|
-      return (%s *)iface;
+      return CONTAINING_RECORD(iface, %s, %s);
)
  }
""" % (Object, IIFace, IIFace, Object, lpVtbl, Object, IIFace_iface,
       Object, Object, lpVtbl, Object, IIFace_iface,
       Object, Object, IIFace_iface))

print("""@ impl_from_IFace depends on has_impl_from @
identifier has_impl_from.impl_from_IFace;
@@
- impl_from_IFace
+ impl_from_%s
""" % (IIFace))

print("@ depends on !has_impl_from @")
if not separate:
    print("""type object.obj;
identifier tag_obj;
@@
  typedef struct %s { ... } obj;
""" % (tag_obj))
else:
    print("""identifier object.tag_obj;
@@
  struct tag_obj { ... };
""")
print("""
+static inline %s *impl_from_%s(%s *iface)
+{
+    return CONTAINING_RECORD(iface, %s, %s);
+}
""" % (Object, IIFace, IIFace, Object, IIFace_iface))

if len(lpVtbl) > 6 and lpVtbl.startswith("lp") and lpVtbl.endswith("Vtbl"):
    IIFace_THIS = lpVtbl[2:-4]
else:
    IIFace_THIS = IIFace
print("""
// Get rid of DEFINE_THIS and look alikes
@ obj_this @
identifier iface, OBJ_THIS;
@@
(
- #define OBJ_THIS(iface) DEFINE_THIS(%s, %s, iface)
|
- #define OBJ_THIS(iface) ((%s *)iface)
)

@@
identifier obj_this.OBJ_THIS;
%s *iface;
@@
- OBJ_THIS
+ impl_from_%s
      (iface)

@@
identifier obj_this.OBJ_THIS;
@@
- #undef OBJ_THIS
""" % (Object, IIFace_THIS, Object, IIFace, IIFace))

for objectT in object_types:
    print("""
// Fixup IIFace to Object casts
@ disable drop_cast @
%s *iface;
@@
- (%s *)(iface)
+ impl_from_%s(iface)
""" % (IIFace, objectT, IIFace))

print("""
// ICOM_THIS_MULTI replacement
@@
%s *iface;
@@
- ICOM_THIS_MULTI(%s, %s, iface);
+ %s *This = impl_from_%s(iface);
""" % (IIFace, Object, lpVtbl, Object, IIFace))

print("""
// Don't use impl_from_IFace() outside declarations
@@
identifier fn, iface, foo, bar;
@@
 fn( ... )
 {
+    %s *This = impl_from_%s(iface);
     ...
(
     foo(...,
-             impl_from_%s(iface)
+             This
         , ...)
|
-    (impl_from_%s(iface))->bar
+    This->bar
)
     ...
 }
""" % (Object, IIFace, IIFace, IIFace))

print("""
// Replace all object to interface casts to address of instance expressions
@ disable drop_cast @
%s *This;
@@
- (%s *)(&(This->%s))
+ &This->%s

@ disable drop_cast @
%s This;
@@
- (%s *)(&(This.%s))
+ &This.%s

@ disable drop_cast @
%s This;
@@
- (%s *)(&(This))
+ &This.%s

@ disable drop_cast @
%s *This;
@@
- (%s *)(This)
+ &This->%s

// Replace the other member accesses too
@@
%s *This;
@@
- (This->%s)
+ This->%s

@@
%s This;
@@
- (This.%s)
+ This.%s
""" % (object_types_header, IIFace, lpVtbl, IIFace_iface,
       object_types_header, IIFace, lpVtbl, IIFace_iface,
       object_types_header, IIFace, IIFace_iface,
       object_types_header, IIFace, IIFace_iface,
       object_types_header, lpVtbl, IIFace_iface,
       object_types_header, lpVtbl, IIFace_iface))

if IIFace != "IUnknown":
    print("""
// Replace object to (IUnknown *) casts.
// Though this two rules are not entirely correct. We just assume that the
// run for the first iface has eliminated all (IUnknown *)object sites.
// This is a limitation in coccinelle for now.
@ disable drop_cast @
typedef IUnknown;
%s This;
@@
  (IUnknown *)
-             (&(This))
+             &This.%s

@ disable drop_cast @
%s *This;
@@
  (IUnknown *)
-             (This)
+             &This->%s
""" % (object_types_header, IIFace_iface, object_types_header, IIFace_iface))

print("""
// Get rid of some ->lpVtbl to IIFace wrappers
@ wrapcast disable drop_cast @
identifier iface, wrapper;
@@
(
- #define wrapper(iface) ((%s *)&(iface)->%s)
|
- #define wrapper(iface) (&(iface)->%s)
)

@@
identifier wrapcast.wrapper;
@@
- #undef wrapper

@@
identifier wrapcast.wrapper;
expression obj;
@@
(
- wrapper(&obj)
+ &obj.%s
|
- wrapper(*obj)
+ &(*obj)->%s
|
- wrapper(obj)
+ &obj->%s
)
""" % (IIFace, lpVtbl, lpVtbl, IIFace_iface, IIFace_iface, IIFace_iface))


if IIFace != "IUnknown":
    print("""
// Avoid some casts to IUnknown*
@ disable drop_cast, ptr_to_array @
expression E, arg2, arg3;
@@
(
- IUnknown_QueryInterface((IUnknown *)&E->%s, arg2, arg3)
+ %s_QueryInterface(&E->%s, arg2, arg3)
|
- IUnknown_QueryInterface((IUnknown *)&E.%s, arg2, arg3)
+ %s_QueryInterface(&E.%s, arg2, arg3)
|
- IUnknown_AddRef((IUnknown *)&E->%s)
+ %s_AddRef(&E->%s)
|
- IUnknown_AddRef((IUnknown *)&E.%s)
+ %s_AddRef(&E.%s)
|
- IUnknown_Release((IUnknown *)&E->%s)
+ %s_Release(&E->%s)
|
- IUnknown_Release((IUnknown *)&E.%s)
+ %s_Release(&E.%s)
)
""" % (IIFace_iface, IIFace, IIFace_iface,
       IIFace_iface, IIFace, IIFace_iface,
       IIFace_iface, IIFace, IIFace_iface,
       IIFace_iface, IIFace, IIFace_iface,
       IIFace_iface, IIFace, IIFace_iface,
       IIFace_iface, IIFace, IIFace_iface))


print("""
// The third parameter of QueryInterface is NOT an object!
@@
identifier QueryInterface =~ "_QueryInterface$";
identifier riid, ppvObj;
typedef REFIID;
type T;
@@
 QueryInterface(%s *iface, REFIID riid,
-                                       T ppvObj
+                                       void **ret_iface
               )
 {
     <...
-    ppvObj
+    ret_iface
     ...>
 }

// Make sure we don't assing the object to ret_iface
@@
identifier QueryInterface =~ "_QueryInterface$";
identifier riid, ret_iface;
%s *This;
@@
 QueryInterface(%s *iface, REFIID riid, void **ret_iface)
 {
     <...
     *ret_iface =
-                 This
+                 NOTANOBJECT
           ;
     ...>
 }
""" % (IIFace, object_types_header, IIFace))

print("""
// Sanity: impl_from_%s() should be used only from %s members
@ vtbl @
identifier fn, vtbl;
@@
  \(%s\|struct %s\) vtbl = {
      ...,
      fn,
      ...,
  };

@ good_impl_from_use @
identifier vtbl.fn;
position p;
@@
  fn@p( ... )
  {
      <...
      impl_from_%s( ... )
      ...>
  }

@ bad_impl_from_use @
identifier fn;
position p != good_impl_from_use.p;
@@
  fn@p( ... )
  {
      <...
-     impl_from_%s
+     BADBADBAD
      ...>
  }
""" % (IIFace, IIFaceVtbl, IIFaceVtbl, IIFaceVtbl, IIFace, IIFace))
