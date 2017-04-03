#!/usr/bin/perl -w
# LPJUNK.pl
#       Read the output of the COM-stats.cocci and generate the rules for
#       LPJUNK.cocci

use strict;

my %types;

while (<>) {
    m/^find: iface='\w+_iface', type='(I\w+)',/ and do {
        $types{$1} = 1;
    };
}

my $r = 0;
foreach my $t (sort(keys(%types))) {
    $r++;
    my $PJUNK = $t;
    $PJUNK =~ tr/a-z/A-Z/;
    $PJUNK =~ s/^I/P/;
    my $LPJUNK = "L" . $PJUNK;
    print("\n\n\@r$r@\ntypedef $t;\ntypedef $PJUNK;\nposition p;\n@@\n");
    print("- $PJUNK\@p\n+ $t *\n");
    print("\n\@script:python depends on report@\n");
    print("p << r$r.p;\n@@\nWARN(p[0], \"$t*\", \"$PJUNK\")\n");
    $r++;
    print("\n\n\@r$r@\ntypedef $LPJUNK;\nposition p;\n@@\n");
    print("- $LPJUNK\@p\n+ $t *\n");
    print("\n\@script:python depends on report@\n");
    print("p << r$r.p;\n@@\nWARN(p[0], \"$t*\", \"$LPJUNK\")\n");
}
