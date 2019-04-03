@r@
identifier func = { d3dx_create_param_eval };
type T;
symbol base;
@@
 T func(struct
-              d3dx9_base_effect *base
+              d3dx_effect *effect
        , ...) {...}


@@
identifier r.func;
symbol base, effect;
@@
  func(
(
-      base
+      effect
|
-      &
        effect
-             ->base_effect
)
       , ...)
