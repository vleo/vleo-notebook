#!/usr/bin/perl

package RoutingTables;

use strict;
use feature 'say';

use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw();
use Scalar::Util 'refaddr';
use Data::Dumper;


my (%mid2mid,%cid2mid,%sid2mid);

sub new
{
	my $class = shift;
	bless \do{my $v},$class;
}

sub mRoute
{
	my $self=shift;
	my $me=refaddr $self;
	$mid2mid{$me}->{$_[0]}->{$_[1]}=$_[2] if @_ >1;
	return $mid2mid{$me}->{$_[0]};
}

sub mRouteDel
{
	my $self=shift;
	die unless scalar(@_) == 2;
	my $me=refaddr $self;

#	my $dst=$_[1];
#	@{$mid2mid{$me}->{$_[0]}} = grep { $dst ne $_ }  @{$mid2mid{$me}->{$_[0]}};

	
	delete $mid2mid{$me}->{$_[0]}->{$_[1]};

	return $mid2mid{$me}->{$_[0]};
}

1;
