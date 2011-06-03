#!/usr/bin/perl

use strict;
use IO::Select;
use IO::Socket;
use Authen::SASL;
use Data::Dumper;

my $ps = {
    LocalHost => 'localhost',
    LocalPort => 6666,
    Proto     => 'tcp',
    Listen    => 5,
    Reuse     => 1
};

my $sock=new IO::Socket::INET(%$ps) or die "Can't create listening socket: $!\n";

my $readSet = new IO::Select();
$readSet->add($sock);

my $authOK={};

while (1)
{
	my ($readyHandlesSet) = IO::Select->select($readSet, undef, undef, 10); 
	next unless defined($readyHandlesSet);
	my $readyHandle;
	print "readyHandlesSet= ",join(":",@$readyHandlesSet),"\n";
  foreach $readyHandle (@$readyHandlesSet) 
	{
		if ($readyHandle == $sock)
		{
			my $newSock=$sock->accept() or die "Error accepting connections : $! :" . join(":",grep $!{$_},(keys %!)) . "\n" ;
      $readSet->add($newSock);

			# v v v Authenticate new connection v v v
			my $sasl = Authen::SASL->new (
				mechanism => "DIGEST-MD5",
				callback => 
				{
					getsecret => \&getsecret,
				}
			);

			my $conn = $sasl->server_new("mess","mess-server.vks.mt.ru",{ no_integrity => 1 });
			$conn->need_step or die "We expect to need auth start for DIGEST-MD5";

      my $sc;
			my $reply = $conn->server_start("",sub { $sc = shift } );
			printf "sc= %s\n",$sc;
			$conn->need_step or die "We expect to need one step for DIGEST-MD5";

			$newSock->send($sc);

      $newSock->blocking(1);
			my $buf;
			my $n=$newSock->sysread($buf,1000);
			printf "buffer read %d bytes: %s\n",$n,$buf;
			my $sr;
			$conn->server_step($buf, sub { $sr = shift });
			printf "sr= %sr\n",$sr;
			not $conn->need_step or die "We do not expect to need 2nd step for DIGEST-MD5";

			if ($conn->code)
			{
				printf "Error code: %d Message: %s\n",$conn->code,$conn->error;
			}
			else
			{
				printf "Adding Auth OK status to socket %s\n",$readyHandle;
				$authOK->{$newSock}=1;
			}
			# ^ ^ ^ Authenticate new connection ^ ^ ^

      $newSock->blocking(0);

		}
		else
		{
			my $buf;
			my $n=sysread($readyHandle,$buf,10000);
			if (not defined($n)) 
			{
				die "Error reading from client socket : $! :" . join(":",grep $!{$_},(keys %!)) . "\n" ; 
			}
			elsif ($n == 0)
			{
				printf "Socket %s closed\n",$readyHandle;
        $readSet->remove($readyHandle);
				delete $authOK->{$readyHandle};
			}
			else
			{
				if($authOK->{$readyHandle})
				{
					printf "buffer read %d bytes: %s\n",$n,$buf;
				}
				else
				{
					die "Socket connection should be authenticated when new socket is spawned\n";
				}
			}
		}
	}
}

sub getsecret
{
	my ($self,$parts,$cb)=@_;
	printf "getsecret() %s",Dumper($parts);

	if(
      $parts->{authzid} eq 'myauth' and
			$parts->{user} eq 'L1'
		)
	{ $cb->( 'qwerty'  ) }
	else
	{ $cb->( ''  ) }

}
