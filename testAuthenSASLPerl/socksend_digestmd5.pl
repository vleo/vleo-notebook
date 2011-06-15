#!/usr/bin/perl

use strict;
use IO::Socket;
use Authen::SASL;
use Data::Dumper;

my $pc = {
    PeerAddr => 'localhost',
    PeerPort => 6666,
    Proto    => 'tcp',
};

my $sock=new IO::Socket::INET(%$pc) or die "Can't connect to socket: $!\n"; 

my $sasl = Authen::SASL->new
(
  mechanism => 'DIGEST-MD5',
  callback => 
	{
    pass => 'qwerty',
    user => 'L1',
		authname => 'myauth'
  }
);

my $conn = $sasl->client_new("mess", "mess-server.vks.mt.ru","noplaintext noanonymous");

$conn->need_step or die "We expect to need client_start for DIGEST-MD5";

$conn->client_start() eq "" or die "Expecting empty return from client_start()";

$conn->need_step or die "We expect to need another step for DIGEST-MD5";

my $sc;
$sock->sysread($sc,1000);

printf "sc= %s\n",$sc;
my $initial = $conn->client_step($sc);
printf "initial= %s\n",$initial;

$sock->send($initial);

sleep(1);

$sock->send("abcdef");

sleep(5);
