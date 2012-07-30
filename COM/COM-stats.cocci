// Parse some statistics for COM interfaces implemented by Wine.

@initialize:python@
iface_old = 0
iface_new = 0
objects = set()
# Vtbl type
import re
r_Tiface = re.compile(r"\b(ns)?I\w+(\s+\*)?$")
r_Tvtbl = re.compile(r"\b(ns)?I\w+Vtbl\s+\*$")
r_Tvtbl2 = re.compile(r"\b(ns)?I\w+Vtbl$")

@ find @
type T;
identifier iface =~ "([vV]tbl|_iface$|^IUnknown_inner$)";
identifier tag_obj;
position p;
@@
  struct tag_obj@p {
      ...
      T iface;
      ...
  }

@ find2 @
type obj, T;
identifier iface =~ "([vV]tbl|_iface$|^IUnknown_inner$)";
position p;
@@
  typedef struct {
      ...
      T iface;
      ...
  } obj@p;


@script:python@
T << find.T;
iface << find.iface;
obj << find.tag_obj;
p << find.p;
@@
print("find: iface='%s', type='%s', obj='%s, file='%s'" % (iface, T, obj, p[0].file))
if r_Tiface.search(T):
    if iface.endswith("_iface") or iface == "IUnknown_inner":
        iface_new += 1
    elif r_Tvtbl.search(T):
        iface_old += 1
    else:
        print("Error detecting iface style")
    objects.add(p[0].file + "::" + obj)
else:
    print("Warning: Missdetection")


@script:python@
T << find2.T;
iface << find2.iface;
obj << find2.obj;
p << find2.p;
@@
print("find: iface='%s', type='%s', obj='%s, file='%s'" % (iface, T, obj, p[0].file))
if r_Tiface.search(T):
    if iface.endswith("_iface") or iface == "IUnknown_inner":
        iface_new += 1
    elif r_Tvtbl.search(T):
        iface_old += 1
    else:
        print("Error detecting iface style")
    objects.add(p[0].file + "::" + obj)
else:
    print("Warning: Missdetection")


// Try to detect COM interface implemetations that don't use the standard
// naming schemes (old or new) for the iface field name.
@vtable@
identifier vtbl, QueryInterface, AddRef, Release;
type T;
@@
  T vtbl = {
      QueryInterface,
      AddRef,
      Release,
      ...,
  };

@script:python vtbltype@
T << vtable.T;
@@
if not r_Tvtbl2.search(T):
    cocci.include_match(False)

@oddball depends on vtbltype@
identifier vtable.vtbl;
identifier iface !~ "([vV]tbl|_iface$|^IUnknown_inner$)";
type T;
T obj;
position p;
@@
(
  obj.iface@p = &vtbl;
|
  obj.iface.lpVtbl@p = &vtbl;
)

@script:python@
T << vtable.T;
iface << oddball.iface;
obj << oddball.T;
p << oddball.p;
@@
print("oddball: iface='%s', type='%s', obj='%s', file='%s'" % (iface, T, obj, p[0].file))


@finalize:python@
print('New iface style "_iface": %d' % (iface_new))
print('Old iface style "lpVtbl": %d' % (iface_old))
print("Total of %d ifaces in %d objects" % (iface_new + iface_old, len(objects)))
