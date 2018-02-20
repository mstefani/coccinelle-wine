// Find and print the function with the longest name
//
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes -j 1

@initialize:python@
@@
maxlen = 0
strings = set()

@ r @
identifier f;
@@
  f(...);

@script:python@
f << r.f;
@@
t = len(f)
if t > maxlen:
    maxlen = t
    strings = set()
    strings.add(f)
elif t == maxlen:
    strings.add(f)

@finalize:python@
@@
print(maxlen, sorted(strings))
