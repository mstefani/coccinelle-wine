#!/bin/bash

in=$1
header=/tmp/`basename $in`
COCCIDIR="$HOME/work/janitorial/coccinelle"
WINE="/j/wine/source/COM"
DLL=`dirname $in`

perl -p -e 's,^(\s+const\s+(?:struct\s+)?I\w+Vtbl\s*\*\s*\w*[vV]tbl),//$1,' "$in" > "$header"
vtbls=`perl -n -e 'm,^//\s+const\s+(?:struct\s+)?(I\w+Vtbl)\b, and print "$1 ";' $header`

for v in $vtbls; do
    vh="/tmp/$v.h"
    perl -p -e 's,^//(\s+const\s+(?:struct\s+)?'$v')\b,$1,' $header > $vh
    spatch -sp_file "$COCCIDIR/COM/COM-gen.cocci" -macro_file "$COCCIDIR/macros" --quiet $vh > $v.cocci
    spatch -sp_file $v.cocci -macro_file "$COCCIDIR/macros" -patch "$WINE" -smpl_spacing --quiet $DLL/*.c > $v.diff
done
