#!/usr/bin/perl
use strict;
use warnings;
my $t = Test->new();
$t->run();

package Test;
use strict;
use warnings;
use Data::Dumper;


sub new {
 our @array = ('foo','bar');
 return bless {}, $_[0]
 };

sub run {print "Array: " . Dumper(\@Test::array); return}

1;
