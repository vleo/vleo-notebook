#!/usr/bin/perl
use feature qw(:5.10);

say 'no state:';
sub some_sub { my $v = rand(); return $v }; 
say some_sub for 1..3;
say 'with state:';
sub some_sub_state { state $v = rand(); return $v }; 
say some_sub_state for 1..3;
