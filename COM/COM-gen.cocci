// Script to generate a Coccinelle script that can perform the COM changes
// for an interface.

@initialize:python@
# Parsed stuff
fullIIFaceVtbl = ""
lpVtbl = ""
Object = ""
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
identifier lpVtbl ~= ".*[vV]tbl";
identifier tag_obj;
@@
  typedef struct tag_obj {
      ...
      Tv *lpVtbl;
      ...
  } obj;

@ find2 @
type obj, Tv;
identifier lpVtbl ~= ".*[vV]tbl";
@@
  typedef struct {
      ...
      Tv *lpVtbl;
      ...
  } obj;

@ findS @
type Tv;
identifier lpVtbl ~= ".*[vV]tbl";
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
    lpVtbl = vtbl.ident
    Object = obj
    tagObject = tag_obj.ident


@script:python@
Tvtbl << find2.Tv;
vtbl << find2.lpVtbl;
obj << find2.obj;
@@
if not found and r_Tvtbl.search(Tvtbl):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl.ident
    Object = obj


@script:python@
Tvtbl << findS.Tv;
vtbl << findS.lpVtbl;
tag_obj << findS.tag_obj;
obj << findT.obj;
@@
if not found and r_Tvtbl.search(Tvtbl):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl.ident
    Object = obj
    tagObject = tag_obj.ident
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
    lpVtbl = vtbl.ident
    Object = tag_obj.ident
    tagObject = tag_obj.ident
    separate = 1
    import sys
    print >> sys.stderr, ("Warning: Assuming \"typedef struct %s %s;\"" % (Object, Object))


@finalize:python@
if not found:
    quit()

if fullIIFaceVtbl.startswith("const "):
    IIFaceVtbl_struct = fullIIFaceVtbl[6:]
else:
    IIFaceVtbl_struct = fullIIFaceVtbl
if IIFaceVtbl_struct.startswith("struct "):
    IIFaceVtbl = IIFaceVtbl_struct[7:]
    IIFaceVtbl_typedef = ""
else:
    IIFaceVtbl = IIFaceVtbl_struct
    IIFaceVtbl_typedef = "\ntypedef " + IIFaceVtbl + ";"
IIFace = IIFaceVtbl[:-4]        # strip the "Vtbl"
IIFace_iface = IIFace + "_iface"
if IIFace[0] == "I":
    LPIFACE = "LP" + IIFace[1:].upper()
else:
    LPIFACE = "LP" + IIFace.upper()
if len(tagObject) > 0:
    object_types = [Object, "struct " + tagObject]
    tag_obj = "tag_obj"
else:
    object_types = [Object]
    tag_obj = ""

////////////////////////
// Generate the rules //
////////////////////////
print("// Generated Wine COM cleanup cocci file\n")
if not separate:
    print("""
// Change the COM object
@ object @%s
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
""" % (IIFaceVtbl_typedef, IIFace, tag_obj, fullIIFaceVtbl, lpVtbl, IIFace, IIFace_iface))
else:
    print("""
// Change the COM object
@ object @%s
typedef %s;
identifier tag_obj;
@@
  struct tag_obj {
      ...
-     %s *%s;
+     %s %s;
      ...
  };
""" % (IIFaceVtbl_typedef, IIFace, fullIIFaceVtbl, lpVtbl, IIFace, IIFace_iface))

print("""
// Fixup the initialization of the object
@@
typedef %s;
%s *This;
identifier _Vtbl_;
@@
- This->%s = &_Vtbl_
+ This->%s.lpVtbl = &_Vtbl_

@@
%s This;
identifier _Vtbl_;
@@
- This.%s = &_Vtbl_
+ This.%s.lpVtbl = &_Vtbl_

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
""" % (Object, Object, lpVtbl, IIFace_iface,
       Object, lpVtbl, IIFace_iface,
       Object + "Vtbl", Object))

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
-      return (%s *)((onebyte *)iface - \(FIELD_OFFSET\|offsetof\)(%s, %s));
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
+
+ static inline %s *impl_from_%s(%s *iface)
+ {
+     return CONTAINING_RECORD(iface, %s, %s);
+ }
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
typedef %s;
identifier obj_this.OBJ_THIS;
%s *iface;
%s lpiface;
@@
- OBJ_THIS
+ impl_from_%s
      (\(iface\|lpiface\))

@@
identifier obj_this.OBJ_THIS;
@@
- #undef OBJ_THIS
""" % (Object, IIFace_THIS, Object,
       LPIFACE, IIFace, LPIFACE, IIFace))

for objectT in object_types:
    print("""
// Fixup IIFace to Object casts
@ disable drop_cast @
%s *iface;
%s lpiface;
@@
(
- (%s *)(iface)
+ impl_from_%s(iface)
|
- (%s *)(lpiface)
+ impl_from_%s(lpiface)
)
""" % (IIFace, LPIFACE, objectT, IIFace, objectT, IIFace))

print("""
// ICOM_THIS_MULTI replacement
@@
%s *iface;
%s lpiface;
@@
(
- ICOM_THIS_MULTI(%s, %s, iface);
+ %s *This = impl_from_%s(iface);
|
- ICOM_THIS_MULTI(%s, %s, lpiface);
+ %s *This = impl_from_%s(lpiface);
)
""" % (IIFace, LPIFACE, Object, lpVtbl, Object, IIFace, Object, lpVtbl, Object, IIFace))

for objectT in object_types:
    print("""
// Replace all object to interface casts to address of instance expressions
@ disable drop_cast @
%s *This;
@@
- (\(%s *\|%s\))(&(This->%s))
+ &This->%s

@ disable drop_cast @
%s This;
@@
- (\(%s *\|%s\))(&(This.%s))
+ &This.%s

@ disable drop_cast @
%s This;
@@
- (\(%s *\|%s\))(&(This))
+ &This.%s

@ disable drop_cast @
%s *This;
@@
- (\(%s *\|%s\))(This)
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
""" % (objectT, IIFace, LPIFACE, lpVtbl, IIFace_iface,
       objectT, IIFace, LPIFACE, lpVtbl, IIFace_iface,
       objectT, IIFace, LPIFACE, IIFace_iface,
       objectT, IIFace, LPIFACE, IIFace_iface,
       objectT, lpVtbl, IIFace_iface,
       objectT, lpVtbl, IIFace_iface))

if IIFace != "IUnknown":
    typedefIUnknown = "typedef IUnknown;"
    for objectT in object_types:
        print("""
// Replace object to (IUnknown *) casts.
// Though this two rules are not entirely correct. We just assume that the
// run for the first iface has eliminated all (IUnknown *)object sites.
// This is a limitation in coccinelle for now.
@ disable drop_cast @
%s
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
""" % (typedefIUnknown, objectT, IIFace_iface, objectT, IIFace_iface))
        typedefIUnknown = ""

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
@ disable drop_cast @
expression E, arg2, arg3;
@@
(
- IUnknown_QueryInterface((IUnknown *)&E->%s, arg2, arg3)
+ %s_QueryInterface(&E->%s, arg2, arg3)
|
- IUnknown_AddRef((IUnknown *)&E->%s)
+ %s_AddRef(&E->%s)
|
- IUnknown_Release((IUnknown *)&E->%s)
+ %s_Release(&E->%s)
)
""" % (IIFace_iface, IIFace, IIFace_iface, IIFace_iface, IIFace, IIFace_iface,
       IIFace_iface, IIFace, IIFace_iface))


print("""
// Sanity: impl_from%s() should be used only from %s members
@ vtbl @
identifier fn, vtbl;
type T;
@@
  T vtbl = {
      ...,
      fn,
      ...,
  };

@ script:python vtblcheck @
T << vtbl.T;
f << vtbl.fn;
fn;
@@
if T.endswith("%s"):
    coccinelle.fn = f

@ good_impl_from_use @
identifier vtblcheck.fn;
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
""" % (IIFace, IIFaceVtbl, IIFaceVtbl_struct, IIFace, IIFace))
