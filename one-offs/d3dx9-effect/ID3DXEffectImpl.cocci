@initialize:python@
@@
import re

@old@
typedef ID3DXEffectVtbl;
identifier Impl;
@@
  static const struct ID3DXEffectVtbl ID3DXEffect_Vtbl =
  {
      ...,
      Impl,
      ...,
  };


@script:python new@
Impl << old.Impl;
effect;
@@
coccinelle.effect = re.sub("ID3DXEffectImpl", "d3dx9_effect", Impl)


@@
identifier old.Impl;
identifier new.effect;
@@
- Impl
+ effect


@@
identifier old.Impl;
identifier new.effect;
type T;
@@
  T
- Impl
+ effect
  (...) {...}


@@
identifier new.effect;
identifier This;
type T;
@@
  T effect(...)
  {
      ...
-     struct ID3DXEffectImpl
+     struct d3dx9_effect
      *This = ...;
      ...
  }

