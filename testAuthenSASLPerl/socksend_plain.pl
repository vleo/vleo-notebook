#!/usr/bin/perl

use strict;
use IO::Socket;
use Authen::SASL;

my $pc = {
    PeerAddr => 'localhost',
    PeerPort => 6666,
    Proto    => 'tcp',
};

my $sock=new IO::Socket::INET(%$pc) or die "Can't connect to socket: $!\n"; 

my $sasl = Authen::SASL->new
(
  mechanism => 'PLAIN',
  callback => 
	{
    pass => 'qwerty',
    user => 'L1',
		authname => 'myauth' 
  }
);

my $conn = $sasl->client_new("mess", "mess-server.vks.mt.ru");
my $myRequest = $conn->client_start();

printf "myRequest=%s\n", $myRequest;

$sock->send($myRequest);

#my $buf;
#my $n = $sock->sysread($buf,1000);
#printf "read %d bytes: %s\n",$n,$buf;
sleep(1);
$sock->send("qwerty");

sleep(5);
