@@
identifier fld, var;
expression E;
type T;
@@
(
* T var = {..., .fld = E, ...};
|
* T var = {..., fld: E, ...};
)
