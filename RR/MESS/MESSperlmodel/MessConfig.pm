#!/usr/bin/perl

# use XML::Smart::Tie here
package MessConfig;
use Exporter;
our @ISA=qw(Exporter); 

use Data::Dumper;

use Getopt::Std;
getopts("c:");
our $opt_c;
use XML::Smart;

use constant MESS_MY_ID => "MESS_MY_ID";
use constant MESS_MY_PWD => "MESS_MY_PWD";
use constant TC_SERV_MQ => "TC_SERV_MQ";
use constant TC_SERV_ID => "TC_SERV_ID";
use constant MESS_PRIMARY => "MESS_PRIMARY";
use constant MESS_MY_HOST => "MESS_MY_HOST";
use constant MESS_MY_PORT => "MESS_MY_PORT";

my $MessConfig;

sub DEFAULT_CONFIG_FILE 
{ 
	if(defined($opt_c))
	{
		die unless -e $opt_c;
		$MessConfig	= XML::Smart->new($opt_c);
	}
	else
	{
		die unless -e $_[0];
		$MessConfig	= XML::Smart->new($_[0]);
	}
}

sub CONFIG 
{ 
	$MessConfig	= XML::Smart->new('MessConfig.xml') unless defined($MessConfig);
  $MessConfig->tree->{config}->{$_[0]};
}

our @EXPORT=qw(DEFAULT_CONFIG_FILE CONFIG MESS_MY_ID MESS_MY_PWD TC_SERV_MQ MESS_PRIMARY TC_SERV_ID MESS_MY_HOST MESS_MY_PORT);

=pod
our @EXPORT=qw(
TESTSTR TCSERVERMQ MESS_MYNAME MESS_PEERS MESS_PRIMARY 
);

#constants
use constant TESTSTR => "Quick brown fox jumped over the lazy dog 1234567890 times!?\n";

#this MESS instance specific
use constant TCSERVERMQ => '/tcServerIn';
use constant MESS_MYNAME => 'localhost:6666';
use constant MESS_PEERS => qw( localhost:8888 localhost:9999 );

#MESS network configuration
use constant MESS_PRIMARY => qw( localhost:8888 );
=cut


1;

