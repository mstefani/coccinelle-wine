// Use separate statements instead of the comma operator.
//
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --local-includes --include-headers --disable-worth-trying-opt

virtual report

@initialize:python@
@@
def WARN(pos):
    print("%s:%s: Warning: In function %s avoid using the comma operator" % (pos.file, pos.line, pos.current_element), flush=True)


@r@
expression E1, E2;
statement S;
position p;
@@
  S
  E1
- ,@p
+ ;
  E2;


@script:python depends on report@
p << r.p;
@@
WARN(p[0])
