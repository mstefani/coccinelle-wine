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

foreach my $t (sort(keys(%types))) {
    my $PJUNK = $t;
    $PJUNK =~ tr/a-z/A-Z/;
    $PJUNK =~ s/^I/P/;
    my $LPJUNK = "L" . $PJUNK;
    print("\n\n@@\ntypedef $t;\ntypedef $PJUNK;\ntypedef $LPJUNK;\n@@\n");
    print("(\n- $PJUNK\n+ $t *\n|\n- $LPJUNK\n+ $t *\n)\n");
}
