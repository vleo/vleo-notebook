#!/usr/bin/perl

use MessageTransport;
use Data::Dumper;

my $x = new MessageTransport;
my $y = new MessageTransport;

$hp={ a => 1, b => 2, t => {c => 11, d => 12}};
$ap=[1,2,3,4,[5,6]];
$v=123;
$sp=\$v;

$x->setRaw($hp);
print Dumper($x->getMsg);

$y->setFrozen($x->getFrozen);
print Dumper($y->getMsg);
