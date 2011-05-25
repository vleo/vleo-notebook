#!/usr/bin/perl

use TcpConnection;

sub serverletThread
{
  my ($newSock) = @_;
  print ref($newSock)," Server receives:\n";
  while(<$newSock>)
    { print $_; } 
  close($newSock);
}

my $sock = new TcpConnection;
$sock->listenOnPort(6666,\&serverletThread);
