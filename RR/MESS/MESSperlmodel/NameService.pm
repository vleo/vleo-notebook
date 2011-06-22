#!/usr/bin/perl
package NameService;

use strict;
use feature qw(say);
use Exporter;
use Data::Dumper;

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

sub NAME_SERVICE_DOMAIN
{
	my($name)=@_;
	return $NameServiceTable->{config}{$name}->{domain};
}

sub NAME_ALL_IDS
{
	grep { not m/^(PRIMARY|SECONDARY|TERTIARY)$/ } (keys %{$NameServiceTable->{config}})
}

=pod
sub NAME_PRIMARY   { $NameServiceTable->{config}->{PRIMARY} }
sub NAME_SECONDARY { $NameServiceTable->{config}->{SECONDARY} }
sub NAME_TERTIARY { $NameServiceTable->{config}->{TERTIARY} }

sub NAME_PRIMARY_HOST   { NAME_SERVICE_HOST($NameServiceTable->{config}->{PRIMARY}) }
sub NAME_PRIMARY_PORT   { NAME_SERVICE_PORT($NameServiceTable->{config}->{PRIMARY}) }

sub NAME_SECONDARY_HOST   { NAME_SERVICE_HOST($NameServiceTable->{config}->{SECONDARY}) }
sub NAME_SECONDARY_PORT   { NAME_SERVICE_PORT($NameServiceTable->{config}->{SECONDARY}) }

sub NAME_TERTIARY_HOST   { NAME_SERVICE_HOST($NameServiceTable->{config}->{TERTIARY}) }
sub NAME_TERTIARY_PORT   { NAME_SERVICE_PORT($NameServiceTable->{config}->{TERTIARY}) }
=cut

our @ISA=qw(Exporter); 
our @EXPORT=qw(NAME_SERVICE NAME_SERVICE_HOST NAME_SERVICE_PORT NAME_SERVICE_DOMAIN NAME_ALL_IDS); # NAME_PRIMARY NAME_PRIMARY_HOST NAME_PRIMARY_PORT NAME_SECONDARY NNAME_SECONDARY_HOST  NAME_SECONDARY_PORT NAME_TERTIARY NAME_TERTIARY_HOST NAME_TERTIARY_PORT);

1;
