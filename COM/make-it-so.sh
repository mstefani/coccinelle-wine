#!/bin/bash
#
# make-it-so.sh <path-to-wine-src-dll-or-C-file>
#       Wrapper around the COM cocci genrator cocci file.


#WINE="$HOME/work/wine"
WINE="/j/wine/source/COM"
MYDIR=`dirname $0`
DATE=`date +%Y%m%d-%H%M`
GENCOCCI=`mktemp --tmpdir COM-$DATE-XXXX.cocci`

spatch -sp_file "$MYDIR/COM-gen.cocci" -I "$WINE/include" $@ > "$GENCOCCI" || exit 1
if [ -s "$GENCOCCI" ]; then
    echo Generated $GENCOCCI >&2
    spatch -sp_file "$GENCOCCI" -macro_file "$MYDIR/../macros" -patch "$WINE" -smpl_spacing $@
else
    echo Nothing to do >&2
    exit 42
fi
