// Sanity check the IUnknown method forwards.
// Confidence: High
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
//

@@
identifier addref =~ "AddRef$";
identifier release =~ "Release$";
@@
 addref(...)
 {
     ...
*    return release(...);
 }


@@
identifier addref =~ "AddRef$";
identifier release =~ "Release$";
@@
 release(...)
 {
     ...
*    return addref(...);
 }
