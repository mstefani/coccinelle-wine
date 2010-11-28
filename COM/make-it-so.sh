#!/bin/bash
#
# make-it-so.sh <path-to-wine-src-dll-or-C-file>
#       Wrapper around the COM cocci genrator cocci file.


WINE="$HOME/work/wine"
MYDIR=`dirname $0`
DATE=`date +%Y%m%d-%H%M`
GENCOCCI=`mktemp --tmpdir COM-$DATE-XXXX.cocci`

spatch -sp_file "$MYDIR/COM-gen.cocci" $@ > "$GENCOCCI" || exit 1
if [ -s "$GENCOCCI" ]; then
    echo Generated $GENCOCCI >&2
    spatch -sp_file "$GENCOCCI" -patch "$WINE" -smpl_spacing $@
else
    echo Nothing to do >&2
fi
