#!/usr/bin/perl
package myPackage;

use strict;
use feature 'say';

use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw(new);

use Scalar::Util 'refaddr';
use Data::Dumper;

my (%insideOutObject);

sub new # object
{
	my $class = shift;
	bless \do{my $v},$class;
}

sub DESTROY {
    my $self = shift;
    delete $insideOutObjct{ refaddr $self };
}
