#!/usr/bin/perl
package NameService;

use strict;
use feature qw(say);
use Exporter;

use XML::Smart;

my $NameServiceTable= XML::Smart->new('NameService.xml');

#$NameServiceTable->{config}{"M1"} = {'host'=>'localhost','port'=>6666};
#$NameServiceTable->{config}{"M2"} = {'host'=>'localhost','port'=>8888};
#$NameServiceTable->{config}{"M3"} = {'host'=>'localhost','port'=>9999};
#$NameServiceTable->save('NameService.xml');

sub NAME_SERVICE
{
	my($name)=@_;
	return $NameServiceTable->{config}{$name};
}

sub NAME_SERVICE_HOST
{
	my($name)=@_;
	return $NameServiceTable->{config}{$name}->{host};
}

sub NAME_SERVICE_PORT
{
	my($name)=@_;
	return $NameServiceTable->{config}{$name}->{port};
}

sub NAME_ALL_IDS
{
	grep { not m/^(PRIMARY|SECONDARY|TERTIARY)$/ } (keys %{$NameServiceTable->{config}})
}

sub NAME_PRIMARY   { $NameServiceTable->{config}->{PRIMARY} }
sub NAME_SECONDARY { $NameServiceTable->{config}->{SECONDARY} }
sub NAME_TERTIARY { $NameServiceTable->{config}->{TERTIARY} }

our @ISA=qw(Exporter); 
our @EXPORT=qw(NAME_SERVICE NAME_SERVICE_HOST NAME_SERVICE_PORT NAME_ALL_IDS NAME_PRIMARY NAME_SECONDARY NAME_TERTIARY);

1;
