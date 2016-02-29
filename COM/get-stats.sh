#!/bin/bash
WINEDIR=/j/wine/source/COM
MYDIR=`dirname $0`

pushd "$WINEDIR" || exit 1
git pull && git clean -dxf
popd

pushd "$MYDIR" || exit 1
mv stats stats.old
spatch --sp-file COM-stats.cocci --include-headers --no-includes --macro-file-builtins ../macros "$WINEDIR/dlls" > stats
diff -u stats.old stats
