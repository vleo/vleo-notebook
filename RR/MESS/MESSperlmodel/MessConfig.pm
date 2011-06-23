#!/usr/bin/perl
use feature 'say';

# use XML::Smart::Tie here
package MessConfig;

use Data::Dumper;

use Getopt::Std;
use XML::Smart;

=pod

=head1 NAME

MessConfig - configuration file read and access module

=head1 SYNOPSIS

use MessConfig qw( ConfigFileName.xml c PARM1 PARM2 )

=head1 DESCRIPTION

 Read configuration file ConfigFileName.xml, tag <config> shall contain PARM1, PARM2 values.
 Use -c to specify another filename on script's command line.
 Export PARM1, PARM2 to calling scope.

=cut

sub import
{
	my $callPkg = caller;
	my $selfName = (caller(0))[3];
#  say $selfName,"(",join(":",@_),") caller=",$callPkg;

	my $myPkg = shift;
	my $defaultConfig= shift;
	my $optLtr = shift;
  getopts($optLtr.":");

	# export GET_AUTH to invokation context
	foreach my $name (@_)
	{
		*{"$callPkg\::$name"}= \&{sub { CONFIG($name) }};
	};
#	*{"$callPkg\::GET_AUTH"}=\&GET_AUTH;
#	*{"$callPkg\::GET_AUTH_TABLE"}=\&GET_AUTH_TABLE;

	my $optc=${"opt_".$optLtr};
#	say ">",$optc,"<";

	if(defined($optc))
	{
		die "Can't open configuration file $optc per -c option" unless -e $optc;
		$messConfig	= XML::Smart->new($optc);
	}
	else
	{
		die "Can't open configuration file $defaultConfig" unless -e $defaultConfig;
		$messConfig	= XML::Smart->new($defaultConfig);
	}
}

sub CONFIG 
{ 
	my $caller= (caller(0))[3];
#	say "$caller( ",join(":",@_)," ) caller=",join(":",caller);
  $messConfig->tree->{config}->{$_[0]};
}

1;


