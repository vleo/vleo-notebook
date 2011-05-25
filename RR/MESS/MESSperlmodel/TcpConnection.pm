#!/usr/bin/perl

package TcpConnection;

use strict;
use IO::Socket;

use Exporter;

our @ISA=qw(Exporter IO::Socket); 
our @EXPORT=qw(
&listenOnPort
&connectToAddr
);

sub new
{
  my $class = shift;
  my $self = [];
  bless $self,$class;
  $self->_init();
  return $self;
}

sub _init
{
   my $self = shift;
   $self=undef;
}


sub listenOnPort
{
   my ($self,$port,$handler)=@_;
   my $self->[0] = new IO::Socket::INET 
   (
     LocalHost => 'localhost',
     LocalPort => $port,
     Proto => 'tcp',
     Listen => 5,
     Reuse => 1 
   );
   die "Could not create socket: $!\n" unless $self->[0];
   my ($newSock,$childPid);
   while( $newSock = $self->[0]->accept() )
   {
     $childPid=fork();
     if($childPid == 0)
     {
       &$handler($newSock);
     }
   }
	 return $self->[0];
}

sub connectToAddr
{
   my ($self,$server,$port)=@_;
   $self->[0] = new IO::Socket::INET 
   (
     PeerAddr => $server,
     PeerPort => $port,
     Proto => 'tcp',
   );
   die "Could not create socket: $!\n" unless $self->[0];
}

1;

=head1 TCP/IP connection class

=over 4

=item new()

Contructs object handler, use like this:

my $sock = new TcpConnection

=item listenOnPort($port,\&handler)

Create socket and listen on specified $port, spawning processes for 
each new connection using specified &handler function, which is passed handler to 
newly accpeted socket. Use like this:

$sock->listenOnPort(6666,\&handler);

=item $fd = connectToAddr($server,$port)

Create and open socket, connecting to specified $server on specified $port:

$sock->connectToAddr('localhost',6666);

Return newly created socket, that can be used line this: 

print $fd "Qwerrty\n"

=back

=cut
