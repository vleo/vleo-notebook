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
				unless($authOK->{$readyHandle})
				{
					my $sasl = Authen::SASL->new (
						mechanism => "PLAIN",
						callback => 
						{
							checkpass => \&checkpass
						}
					);

					my $conn = $sasl->server_new("mess");
					$conn->need_step or die "We expect to need auth step for PLAIN";
					$conn->server_start( $buf );
					die "We don't expect more then server_start steps for PLAIN" if $conn->need_step;
					if ($conn->code)
					{
						printf "Error code: %d Message: %s\n",$conn->code,$conn->error;
					}
					else
					{
						printf "Adding Auth OK status to socket %s\n",$readyHandle;
						$authOK->{$readyHandle}=1;
					}
				}
				else
				{
					printf "buffer read %d bytes: %s\n",$n,$buf;
				}
			}
		}
	}
}

sub checkpass
{
	my ($self,$parts,$cb)=@_;
	printf "checkpass() %s",Dumper($parts);

	$cb->(
	$parts->{authname} eq 'myauth' and
  $parts->{user} eq 'L1' and
	$parts->{pass} eq 'qwerty' 
	)

}
