// Find and print the function with the longest name
//
// Copyright: Michael Stefaniuc <mstefani@redhat.com>

@initialize:python@
maxlen = 0
strings = {}

@ r @
identifier f;
@@
  f(...);

@script:python@
f << r.f;
@@
t = len(f.ident)
if t > maxlen:
    maxlen = t
    strings = {f.ident: 0}
elif t == maxlen:
    strings[f.ident] = 0

@finalize:python@
print(maxlen, sorted(strings.keys()))
