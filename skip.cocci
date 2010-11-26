// Insert missing skip() in test files.
// The skip message needs to be manually adjusted as well as some
// skip() changed to win_skip().
//
// Confidence: Unknown
// Copyright: Michael Stefaniuc <mstefani@redhat.com>
@ okskip @
position p;
expression E, E1;
statement S;
@@
(
  ok(E, ...);
  if@p(!E) S
|
  ok(E == E1, ...);
  if@p(E != E1) S
)

@@
position p != okskip.p;
@@
  if@p(...)
  {
      ... when != \(skip\|win_skip\)(...)
-     trace
+     skip
            ( ... );
      ... when != \(skip\|win_skip\)(...)
      return ...;
  }
  ...
  ok(...);

@ okskip2 @
position p;
expression E, E1;
statement S;
@@
(
  ok(E, ...);
  if@p(!E) S
|
  ok(E == E1, ...);
  if@p(E != E1) S
)

@@
position p != okskip2.p;
@@
  if@p(...)
  {
      ... when != \(skip\|win_skip\)(...)
+     skip("INSERT REASON\n");
      return ...;
  }
  ...
  ok(...);
