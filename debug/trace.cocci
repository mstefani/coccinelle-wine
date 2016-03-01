// Sanity checks for ERR, FIXME, TRACE, WARN calls.
//
// Confidence: Medium
// Copyright: Michael Stefaniuc <mstefani@winehq.org>
// Options: --include-headers --no-includes
//
// Comments: Needs cleanups as it is way too verbose.
//           Should use the new format string support from coccinelle.

virtual diff

@initialize:python@
@@
import re
fmtcache = {}

def MSG(level, pos, msg=""):
    print("%s: In function '%s':" % (pos[0].file, pos[0].current_element))
    print("%s:%s: %s: %s" % (pos[0].file, pos[0].line, level, msg))
def ERR(pos, msg):
    MSG("error", pos, msg)
def WARN(pos, msg):
    MSG("warning", pos, msg)

def get_fmt_spec(format):
    if format in fmtcache:
        return fmtcache[format]
    spec = []
    r = re.compile(r"(?:[^%]|(?:%%))*(%[^%]*?[diouxXeEfFgGcspn])")
    m = r.match(format, 0)
    while m:
        if re.search(r"(?<!\.)\*", m.group(1)):
            spec.append("*")    # field width in next arg
        if re.search(r"\.\*", m.group(1)):
            spec.append(".*")   # precission in next arg
        spec.append(m.group(1))
        m = r.match(format, m.end())
    fmtcache[format] = spec
    return spec

def check_format(fmt, args, func, p):
    #print(fmt)
    # Remove the quotes and concatenate the strings
    format = "".join(fmt[1:-1].split('" "'))
    #print(format)

    # Name check
    ###
    if func.startswith("WINE_") and re.search(r"/dlls/", p[0].file):
        WARN(p, "Unneccessary 'WINE_' prefix in '" + func + "'")
    if not re.search("FIXME", func) and re.search("stub", fmt, re.I):
        ERR(p, "'stub' message in '" + func + "' call")

    # Whitespace checks
    ###
    m = re.match(r"^(?:\\.|[^\\])*?(\s)*\\n(\s)*$", format)
    if m:
        if m.group(1):
            ERR(p, "Whitespace before newline")
        if m.group(2):
            ERR(p, "Whitespace after newline")
    else:
        WARN(p, "Missing newline")

    # Argument checks
    ###
    if len(args.elements) > 0:
        spec = get_fmt_spec(format)
        if len(args.elements) == len(spec):
            for i in range(len(spec)):
                if re.match("(wine_)?d(b|ebu)gstr_", args.elements[i]):
                    if not spec[i][-1] == "s":
                        ERR(p, "Format specifier for debugstr arg %d is %%%s instead of %%s" % (i + 1, spec[i][-1]))
        else:
            ERR(p, "Nr of format specifiers (%d) doesn't match the args (%d)" % (len(spec), len(args.elements)))
        print(spec)


@r@
identifier f =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)$";
constant fmt;
expression list varargs;
position p;
@@
 f@p(fmt, varargs)

@r2@
identifier f =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)_$";
identifier channel;
constant fmt;
expression list varargs;
position p;
@@
 f@p(channel)(fmt, varargs)

@script:python@
func << r.f;
fmt << r.fmt;
args << r.varargs;
p << r.p;
@@
check_format(fmt, args, func, p)

@script:python@
func << r2.f;
fmt << r2.fmt;
args << r2.varargs;
p << r2.p;
@@
check_format(fmt, args, func, p)

@@
identifier f =~ "^(WINE_)?(ERR|FIXME|TRACE|WARN)$";
expression E;
@@
 f(...,
-       E->left, E->top, E->right, E->bottom
+       wine_dbgstr_rect(E)
 , ...)

@stub depends on diff@
identifier f;
identifier FIXME =~ "^(WINE_)?FIXME$";
constant fmt, C;
position p;
@@
 f(...)
 {
     FIXME@p(fmt, ...);
     return C;
 }

@script:python stub_added @
fmt << stub.fmt;
p << stub.p;
newfmt;
@@
if not re.search("stub", fmt, re.I):
    WARN(p, "stub function without 'stub' FIXME")
    coccinelle.newfmt = '"(' + fmt[1:-3] + r') stub\n"'
else:
    cocci.include_match(False)

@@
identifier FIXME =~ "^(WINE_)?FIXME$";
position stub.p;
constant stub.fmt;
identifier stub_added.newfmt;
@@
 FIXME@p(
-        fmt
+        newfmt
         , ...);

