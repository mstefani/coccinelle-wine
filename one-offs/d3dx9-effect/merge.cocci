@base@
identifier virtual.func;
statement list body;
type T;
@@
- T func(...) { body }


@@
identifier virtual.func;
statement list base.body;
@@
- return func(...);
+ body
