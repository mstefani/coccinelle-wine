#!/usr/bin/perl -w
#
# dup-rule
#       Script to parse the output of 'spatch --parse-cocci' and provide information
#       about duplicated alternate rules produced during isomorphism expansion.

use strict;

my %rules;

sub read_rule()
{
    my $r = "";
    while (<>) {
        last if (/^[(|)]/);
        s/^\s+//;
        s/ +$//;
        s/ +/ /g;
        $r .= $_;
    }
    if (exists($rules{$r})) {
        #print("Duplicated rule:\n$r");
        $rules{$r}++;
    } elsif ($r ne "") {
        $rules{$r} = 1;
    }
}

while (<>) {
    /^[(|]/ and do {
        read_rule();
        redo;
    };
    /^\)/ and do {
        my $uniq = 0;
        my $total = 0;
        foreach my $r (keys(%rules)) {
            if ($rules{$r} > 1) {
                print("$rules{$r} duplicates for rule:\n$r");
                $total += $rules{$r};
            } else {
                $total++;
            }
            $uniq++;
        }
        print("$uniq unique rules\n");
        print("$total total rules\n");
        %rules = ();
    }
}
