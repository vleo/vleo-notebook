#!/usr/bin/perl

use CallEventData;
use Data::Dumper;

my $x = new CallEventData;
my $y = new CallEventData;

$hp={ a => 1, b => 2, t => {c => 11, d => 12}};
$ap=[1,2,3,4,[5,6]];
$v=123;
$sp=\$v;

$x->setRaw($hp);
print Dumper($x->getRaw);

$y->setFrozen($x->getFrozen);
print Dumper($y->getRaw);
