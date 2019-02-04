// Check for the proper use of COM in Wine.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --timeout 300
//

@ find @
type Ti, To;
identifier iface =~ "(_iface|^IUnknown_inner)$";
identifier tag_obj;
@@
(
  typedef struct tag_obj {
      ...
      Ti iface;
      ...
  } To;
|
  typedef struct {
      ...
      Ti iface;
      ...
  } To;
|
  struct tag_obj {
      ...
      Ti iface;
      ...
  };
)


@ find2 @
type To;
identifier find.tag_obj;
@@
  typedef struct tag_obj To;


// Fix object to interface casts
////////
@ disable drop_cast @
type find.Ti;
identifier find.iface;
{find.To, find2.To} *obj;
@@
- (Ti *)(obj)
+ &obj->iface


@ disable drop_cast @
type find.Ti;
identifier find.iface;
{find.To, find2.To} obj;
@@
- (Ti *)(&(obj))
+ &obj.iface


@ disable drop_cast @
type find.Ti;
identifier find.iface, find.tag_obj;
struct tag_obj *obj;
@@
- (Ti *)(obj)
+ &obj->iface


@ disable drop_cast @
type find.Ti;
identifier find.iface, find.tag_obj;
struct tag_obj obj;
@@
- (Ti *)(&(obj))
+ &obj.iface


// There should be no need to cast a COM object to something else.
@ disable drop_cast @
type T;
{find.To, find2.To} *obj;
@@
(
  \(SetWindowLongPtrA\|SetWindowLongPtrW\)(..., GWLP_USERDATA, (T)(obj))
|
- (T)
       (obj)
)


@ disable drop_cast @
type T;
identifier find.tag_obj;
struct tag_obj *obj;
@@
(
  \(SetWindowLongPtrA\|SetWindowLongPtrW\)(..., GWLP_USERDATA, (T)(obj))
|
- (T)
       (obj)
)


// Get rid of some ->lpVtbl to IIFace wrappers
@ wrapcast disable drop_cast @
type find.Ti;
identifier find.iface, wrapper, x;
@@
(
- #define wrapper(x) ((Ti *)&(x)->iface)
|
- #define wrapper(x) (&(x)->iface)
)

@@
identifier wrapcast.wrapper;
@@
- #undef wrapper

@@
identifier find.iface, wrapcast.wrapper;
expression obj;
@@
(
- wrapper(&obj)
+ &obj.iface
|
- wrapper(*obj)
+ &(*obj)->iface
|
- wrapper(obj)
+ &obj->iface
)


// Avoid some casts to IUnknown*
@ script:python gen_methods @
Ti << find.Ti;
AddRef;
Release;
QI;
@@
coccinelle.AddRef = Ti + "_AddRef"
coccinelle.Release = Ti + "_Release"
coccinelle.QI = Ti + "_QueryInterface"



@ disable drop_cast, ptr_to_array @
typedef IUnknown;
identifier find.iface;
identifier gen_methods.AddRef, gen_methods.Release, gen_methods.QI;
expression E;
@@
(
- IUnknown_QueryInterface
+ QI
                         (
-                         (IUnknown *)
                                      &E->iface, ...)
|
- IUnknown_QueryInterface
+ QI
                         (
-                         (IUnknown *)
                                      &E.iface, ...)
|
- IUnknown_AddRef((IUnknown *)&E->iface)
+ AddRef(&E->iface)
|
- IUnknown_AddRef((IUnknown *)&E.iface)
+ AddRef(&E.iface)
|
- IUnknown_Release((IUnknown *)&E->iface)
+ Release(&E->iface)
|
- IUnknown_Release((IUnknown *)&E.iface)
+ Release(&E.iface)
)


// Fix interface to object casts
////////
@ script:python gen_impl @
Ti << find.Ti;
impl_from_IFace;
@@
coccinelle.impl_from_IFace = "impl_from_" + Ti


@ disable drop_cast @
type find.Ti;
type To = {find.To, find2.To};
Ti *iface;
identifier gen_impl.impl_from_IFace;
@@
- (To *)(iface)
+ impl_from_IFace(iface)


@ disable drop_cast @
type find.Ti;
Ti *iface;
identifier find.tag_obj;
identifier gen_impl.impl_from_IFace;
@@
- (struct tag_obj *)(iface)
+ impl_from_IFace(iface)


// Don't use impl_from_IFace() outside declarations
@@
type find.To;
identifier fn, iface, foo, bar;
identifier gen_impl.impl_from_IFace;
@@
 fn( ... )
 {
+    To *This = impl_from_IFace(iface);
     ...
(
     foo(...,
-             impl_from_IFace(iface)
+             This
         , ...)
|
-    (impl_from_IFace(iface))->bar
+    This->bar
)
     ...
 }


@@
type find2.To;
identifier fn, iface, foo, bar;
identifier gen_impl.impl_from_IFace;
@@
 fn( ... )
 {
+    To *This = impl_from_IFace(iface);
     ...
(
     foo(...,
-             impl_from_IFace(iface)
+             This
         , ...)
|
-    (impl_from_IFace(iface))->bar
+    This->bar
)
     ...
 }


@@
identifier find.tag_obj;
identifier fn, iface, foo, bar;
identifier gen_impl.impl_from_IFace;
@@
 fn( ... )
 {
+    struct tag_obj *This = impl_from_IFace(iface);
     ...
(
     foo(...,
-             impl_from_IFace(iface)
+             This
         , ...)
|
-    (impl_from_IFace(iface))->bar
+    This->bar
)
     ...
 }
