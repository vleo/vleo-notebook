#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use feature 'say';

use IO::Socket;
use IO::Select;

my $socket= new IO::Socket::INET(
	PeerHost => '10.15.3.249',
	PeerPort => 5555,
	Proto => 'tcp',
	);

$socket or die;

my $select=new IO::Select($socket);

my ($b,$s); 
my $n=1;
while(my @ready = $select->can_read())
{
	@ready > 0 or die;
#	say join(":",@ready);
	my $s = $ready[0]->recv($b,10);
	say defined($s) ? "OK$s" : "ERROR";
	say "b[",length($b),"]:",$b;
	last if length($b)<1;
	sleep(5);
	$socket->send(sprintf("PING n=%03d",$n++));
}


