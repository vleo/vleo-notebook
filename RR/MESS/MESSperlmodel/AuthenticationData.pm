#!/usr/bin/perl

# use XML::Smart::Tie here
package AuthenticationData;
use feature 'say';
#use strict;
use Exporter;
our @ISA=qw(Exporter); 

use Data::Dumper;

use Getopt::Std;
getopts("p:");
our $opt_p;
use XML::Smart;

my $authData;
sub import
{
	my $callPkg = caller;
	say join(":",@_)," caller=",$callPkg;

	# export GET_AUTH to invokation context
	*{"$callPkg\::GET_AUTH"}=\&GET_AUTH;
	*{"$callPkg\::GET_AUTH_TABLE"}=\&GET_AUTH_TABLE;

	if($_[1])
	{
		say "reading config file $_[1]";
		if(defined($opt_p))
		{
			die unless -e $opt_p;
			$authData	= XML::Smart->new($opt_c);
		}
		else
		{
			die "Can't open configuration file $_[0]" unless -e $_[1];
			$authData	= XML::Smart->new($_[1]);
		}
	}
	else
	{
		$authData	= XML::Smart->new('AuthData.xml');
	}
}

sub GET_AUTH
{ 
  $authData->tree->{auth}->{$_[0]}->{pwd};
}

sub GET_AUTH_TABLE
{
  $authData->tree->{auth};
}

1;
