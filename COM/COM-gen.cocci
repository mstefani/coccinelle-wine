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

@ find @
type obj, Tv;
identifier lpVtbl ~= ".*[vV]tbl";
identifier tag_obj;
@@
(
  typedef struct {
      ...
      Tv *lpVtbl;
      ...
  } obj;
|
  typedef struct tag_obj {
      ...
      Tv *lpVtbl;
      ...
  } obj;
)

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
if not found and Tvtbl.endswith("Vtbl"):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl.ident
    Object = obj
    if tag_obj:
        tagObject = tag_obj.ident


@script:python@
Tvtbl << findS.Tv;
vtbl << findS.lpVtbl;
obj << findT.obj;
@@
if not found and Tvtbl.endswith("Vtbl"):
    found = 1
    fullIIFaceVtbl = Tvtbl
    lpVtbl = vtbl.ident
    Object = obj
    separate = 1


@finalize:python@
if not found:
    quit()

if fullIIFaceVtbl.startswith("const "):
    IIFaceVtbl = fullIIFaceVtbl[6:]
else:
    IIFaceVtbl = fullIIFaceVtbl
IIFace = IIFaceVtbl[:-4]        # strip the "Vtbl"
IIFace_iface = IIFace + "_iface"
if len(tagObject) > 0:
    tag_obj = "tag_obj"
else:
    tag_obj = ""

////////////////////////
// Generate the rules //
////////////////////////
print("// Generated Wine COM cleanup cocci file\n")
if not separate:
    print("""
// Change the COM object
@ object @
typedef %s;
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
""" % (IIFaceVtbl, IIFace, tag_obj, fullIIFaceVtbl, lpVtbl, IIFace, IIFace_iface))
else:
    print("""
// Change the COM object
@ object @
typedef %s;
typedef %s;
identifier tag_obj;
@@
  struct tag_obj {
      ...
-     %s *%s;
+     %s %s;
      ...
  };
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
""" % (Object, IIFace, IIFace))

print("@ depends on !has_impl @")
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

print("""
@ depends on has_impl disable drop_cast @
type onebyte, T;
identifier iface;
@@
(
- return (T *)((onebyte *)iface - FIELD_OFFSET(T, %s));
+ return CONTAINING_RECORD(iface, T, %s);
|
- return CONTAINING_RECORD(iface, T, %s);
+ return CONTAINING_RECORD(iface, T, %s);
)
""" % (lpVtbl, IIFace_iface, lpVtbl, IIFace_iface))

if len(lpVtbl) > 6 and lpVtbl.startswith("lp") and lpVtbl.endswith("Vtbl"):
    IIFace_THIS = lpVtbl[2:-4]
else:
    IIFace_THIS = IIFace
print("""
// Get rid of DEFINE_THIS and look alikes
@ obj_this @
identifier iface, OBJ_THIS;
@@
- #define OBJ_THIS(iface) DEFINE_THIS(%s, %s, iface)

@@
identifier obj_this.OBJ_THIS;
%s *iface;
@@
- OBJ_THIS(iface)
+ impl_from_%s(iface)

// #undef is not supportet yet in coccinelle
//@@
//identifier obj_this.OBJ_THIS;
//@@
//- #undef OBJ_THIS
""" % (Object, IIFace_THIS, IIFace, IIFace))

print("""
// Fixup IIFace to Object casts
@ disable drop_cast @
%s *iface;
@@
- (%s *)(iface)
+ impl_from_%s(iface)

// Grrr... sometimes IIFace * is typedef'ed to LPIFACE
@ disable drop_cast @
identifier iface, This;
@@
%s *This =
-         (%s *)(iface);
+         impl_from_%s(iface);
""" % (IIFace, Object, IIFace, Object, Object, IIFace))

print("""
// ICOM_THIS_MULTI replacement
@@
%s *iface;
@@
- ICOM_THIS_MULTI(%s, %s, iface);
+ %s *This = impl_from_%s(iface);
""" % (IIFace, Object, lpVtbl, Object, IIFace))

print("""
// Replace all object to interface casts to address of instance expressions
@ disable drop_cast @
%s *This;
@@
- (%s *)(&This->%s)
+ &This->%s

@ disable drop_cast @
%s This;
@@
- (%s *)(&This)
+ &This.%s

@ disable drop_cast @
%s *This;
@@
- (%s *)(This)
+ &This->%s
""" % (Object, IIFace, lpVtbl, IIFace_iface, Object, IIFace, IIFace_iface, Object, IIFace, IIFace_iface))

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
type T;
T *obj;
@@
- wrapper(obj)
+ &obj->%s

@@
expression obj;
identifier wrapcast.wrapper;
@@
- wrapper(obj)
+ obj.%s
""" % (IIFace, lpVtbl, lpVtbl, IIFace_iface, IIFace_iface))

print("""
// Replace the other member accesses too
@@
%s *This;
@@
- &This->%s
+ &This->%s
""" % (Object, lpVtbl, IIFace_iface))

print("""
// Sanity: impl_from%s() should be used only from %s members
@ vtbl @
identifier fn, vtbl;
@@
  %s vtbl = {
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
""" % (IIFace, IIFaceVtbl, IIFaceVtbl, IIFace, IIFace))
