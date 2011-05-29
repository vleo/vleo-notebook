#!/usr/bin/perl

# use XML::Smart::Tie here
package MessConfig;
use Exporter;

our @ISA=qw(Exporter); 

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

1;

