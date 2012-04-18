#!/usr/bin/perl

$rh->{"A"}=10;
$rh->{"B"}=20;

#printf "%s %s\n",%{$rh};
@a=qw /A B/;
%h=qw /A 1 B 2/;

printf "%s %s\n", @h{@a};

printf "%s %s\n", @{h}{@a};

printf "%s %s\n", @{h}{qw/A B/};

printf "%s %s\n", @{$rh}{qw/A B/};

