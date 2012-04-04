#!/usr/bin/perl

package MyPackage;

use strict;
use feature 'say';
use Data::Dumper;

use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw(new);

use Hash::Util qw(fieldhash fieldhashes);

fieldhash my  %attrib1;
fieldhashes \my(%attrib2,$attrib3);

sub new # instance 
{
	my $class = shift;
	bless \do{my $v},$class;
}

sub attrib1 
{
	my $self=shift;
	my ($val) = @_;
    $attrib{$self} = $val if defined($val);
    return  $attrib{$self}
}

1;
