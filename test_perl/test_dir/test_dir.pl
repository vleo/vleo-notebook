#!/usr/bin/perl 
use feature qw(:5.10);
use strict;

sub pfind 
{ 
	my $dir = shift;
	opendir my $dh,$dir; 
	my @f = sort readdir $dh; 
	my $dd = '\.\.?$';
	my @d = grep { -d $_ && ! m/$dd/ } map {"$dir/$_"} @f;
	say $dir =~ m/$dd/ ? $_ : "$dir/$_" for grep { !m/$dd/ } @f;
	pfind($_) for @d 
}

pfind(".");
