#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';

use IO::Socket;

my $socket= new IO::Socket::INET(
	LocalHost => '10.15.3.249',
	LocalPort => 5555,
	Proto => 'tcp',
	Listen => 5,
	Reuse => 1 
	);

my ($newsock,$peeraddr) = $socket->accept();

my ($b,$l,$s); 
my $n=1;
if(my $pid=fork)
{ # parent
	while(1)
	{
	$l=$newsock->send(sprintf("PING n=%03d",$n++));
	say $l," bytes sent";
	last if $l<1;
	sleep(5);
	};
	say "parent exits"
}
else
{ #child
	while(defined($s = $newsock->recv($b,10)))
	{
		say "recv ",defined($s) ? "OK$s" : "ERROR", " ",length($b)," bytes :",$b;
		last if length($b)<1;
	}
	say "child exits"
}
