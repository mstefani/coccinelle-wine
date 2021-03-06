// Helper to standardize the COM aggregation in Wine.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes
// NOTES: - Cannot automate the whole work so manual intervention is still
//          required.
//

@ object @
typedef IUnknown;
type obj;
identifier tag_obj;
identifier outer =~ "[Oo][Uu][Tt]";
@@
(
 typedef struct tag_obj {
+    IUnknown IUnknown_inner;
     ...
-    IUnknown IUnknown_iface;
     ...
     IUnknown *outer;
     ...
 } obj;
|
 typedef struct {
+    IUnknown IUnknown_inner;
     ...
-    IUnknown IUnknown_iface;
     ...
     IUnknown *outer;
     ...
 } obj;
|
 struct tag_obj {
+    IUnknown IUnknown_inner;
     ...
-    IUnknown IUnknown_iface;
     ...
     IUnknown *outer;
     ...
 };
)


@ object2 @
type obj;
identifier tag_obj;
identifier outer =~ "[Oo][Uu][Tt]";
@@
(
 typedef struct tag_obj {
     ...
     IUnknown IUnknown_inner;
     ...
-    IUnknown *outer;
+    IUnknown *outer_unk;
     ...
 } obj;
|
 typedef struct {
     ...
     IUnknown IUnknown_inner;
     ...
-    IUnknown *outer;
+    IUnknown *outer_unk;
     ...
 } obj;
|
 struct tag_obj {
     ...
     IUnknown IUnknown_inner;
     ...
-    IUnknown *outer;
+    IUnknown *outer_unk;
     ...
 };
)


@@
type object.obj;
identifier iface;
@@
 return CONTAINING_RECORD(iface, obj,
-                         IUnknown_iface
+                         IUnknown_inner
 );


@@
identifier object.tag_obj;
identifier iface;
@@
 return CONTAINING_RECORD(iface, struct tag_obj,
-                         IUnknown_iface
+                         IUnknown_inner
 );


@@
object.obj *This;
@@
- This->IUnknown_iface
+ This->IUnknown_inner


@@
identifier object.tag_obj;
struct tag_obj *This;
@@
- This->IUnknown_iface
+ This->IUnknown_inner


@@
object2.obj *This;
identifier object.outer;
@@
- This->outer
+ This->outer_unk


@@
identifier object2.tag_obj;
struct tag_obj *This;
identifier object2.outer;
@@
- This->outer
+ This->outer_unk


@@
identifier My_QueryInterface =~ "_QueryInterface$";
identifier Obj_QueryInterface =~ "_QueryInterface$";
identifier iface, This;
type object2.obj;
type T;
expression E;
@@
 My_QueryInterface(T *iface, ...)
 {
     obj *This = ...;
     return
-            Obj_QueryInterface
+            IUnknown_QueryInterface
                     (
-                     E,
+                     This->outer_unk,
                      ...);
 }


@@
identifier My_QueryInterface =~ "_QueryInterface$";
identifier Obj_QueryInterface =~ "_QueryInterface$";
identifier iface, This;
identifier object2.tag_obj;
type T;
expression E;
@@
 My_QueryInterface(T *iface, ...)
 {
     struct tag_obj *This = ...;
     return
-            Obj_QueryInterface
+            IUnknown_QueryInterface
                     (
-                     E,
+                     This->outer_unk,
                      ...);
 }


@@
identifier My_AddRef =~ "_AddRef$";
identifier Obj_AddRef =~ "_AddRef$";
identifier iface, This;
type object2.obj;
type T;
@@
 My_AddRef(T *iface)
 {
     obj *This = ...;
-    return Obj_AddRef(...);
+    return IUnknown_AddRef(This->outer_unk);
 }


@@
identifier My_AddRef =~ "_AddRef$";
identifier Obj_AddRef =~ "_AddRef$";
identifier iface, This;
identifier object2.tag_obj;
type T;
@@
 My_AddRef(T *iface)
 {
     struct tag_obj *This = ...;
-    return Obj_AddRef(...);
+    return IUnknown_AddRef(This->outer_unk);
 }


@@
identifier My_Release =~ "_Release$";
identifier Obj_Release =~ "_Release$";
identifier iface, This;
type object2.obj;
type T;
@@
 My_Release(T *iface)
 {
     obj *This = ...;
-    return Obj_Release(...);
+    return IUnknown_Release(This->outer_unk);
 }


@@
identifier My_Release =~ "_Release$";
identifier Obj_Release =~ "_Release$";
identifier iface, This;
identifier object2.tag_obj;
type T;
@@
 My_Release(T *iface)
 {
     struct tag_obj *This = ...;
-    return Obj_Release(...);
+    return IUnknown_Release(This->outer_unk);
 }
