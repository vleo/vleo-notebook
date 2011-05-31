#!/usr/bin/perl

use IO::Select;
use Socket;
use POSIX;
use POSIX::RT::MQ;
use Data::Dumper;
use Getopt::Std;
getopts("c:");
our $opt_c;
use XML::Smart;

use TcpConnection;
use CallEventData;

$opt_c = 'MessConfig.xml' unless defined($opt_c);
my $MessConfig = XML::Smart->new($opt_c);
sub CONFIG { $MessConfig->{config}->{$_[0]} };

=pod
print $opt_c," ",CONFIG(TCSERVERMQ),"\n";
exit;


=pod
my $initialConfig = 
{
  TCSERVERMQ => '/tcServerIn',
  MESS_MYNAME => 'localhost:6666',
  MESS_PEERS => ['localhost:8888','localhost:9999'],
  MESS_PRIMARY => 'localhost:8888'
};
$MessConfig->{'config'}=$initialConfig;
$MessConfig->save('MessConfig.xml');
exit;
=cut

=pod
sub serverletThread
{
  my ($newSock) = @_;
  my $callData = new CallEventData;
  print ref($newSock)," Server receives:\n";
#  my $buf;
#  my $len = read($newSock,$buf,1024);
#  print $len," ",length($buf)," ",map(sprintf("0x%02x %c ",$_,$_),unpack("C*",$buf)),"\n";
  while($callData -> receiveData($newSock) != -1)
  {
    $callData->printDumper();
# for events:
#    $recepientSockList = $routingTable->getRecepientSock($callData->getData->{'callRecepient'});
#    foreach $recepientSock (@$recepientSockList)
#    { $callData->sendData($recepientSock); }
# for methods:
    # send()
    # receive()
  }
  close($newSock);
}
=cut

# We need to establish initial connections

# MESS PEERS
# foreach $peer (TCSERVERMQ)
#  {
#  }

# MY tcServer
# FIXME - convert to Class (also used by tcServer)
my $mqname = CONFIG(TCSERVERMQ);
my $attr = { mq_maxmsg  => 8192, mq_msgsize =>  1024 };
my $mq = POSIX::RT::MQ->open($mqname, O_RDWR|O_CREAT, 0600, $attr)
            or die "cannot open $mqname: $!\n";

my $initMsg = new CONFIG(MESS_MYNAME),"mqRegister",{ },{ OK => undef});
my $callData = new CallEventData;
$callData->setRaw($initMsg);
$mq->send($callData->getFrozen());

# we need to pass structure of { methodName => "func1", argumentsStruct => { A=>1, B=>"qwerty"}, valueStruct => { X=>2,Y="QWERTY"} }
# called relayed to appropriate TcServer
# what can come from $newSock
# 1) method call (0,0,1)
# 2) event (0,0,2)


my $serverSock = new TcpConnection(6666);
my $readSet = new IO::Select();
$readSet->add($serverSock);

#$serverSock->listenOnPort(\&serverletThread);

# main loop on all sockets for all clients
# select()
# can read - read - write to destination
 
my $clientSockets={};
# { message destination => open socket }
my $routingTable={};

$routingTable->{'VC1'} = ['M1',sock:1234;

=pod
VC1  ---\
VC2  ---- M1+S1
          |
VC3  ---- M2(*)+S2
          | 
VC4  ---  M3+S3
          |
VC5  --   M4+S4
=cut

while(1)
{
  sleep(1);
  my ($readyHandlesSet) = IO::Select->select($readSet, undef, undef, 0); 
  printf "Got %d sockets ready to be read\n",int(@$readyHandlesSet);
  my $readyHandle;
  foreach $readyHandle (@$readyHandlesSet) 
  { 
    if ($readyHandle == $serverSock) 
    {
      my ($newSock,$addr) = $readyHandle->accept();
      my ($port,$ipraw)=unpack_sockaddr_in($addr);
      my $ipasc=inet_ntoa($ipraw);
      $clientSockets->{$newSock}->{PORT} = $port;
      $clientSockets->{$newSock}->{IP} = $ipasc;

      printf "opened socket for client at addr %s:%d\n",$ipasc,$port;

      $readSet->add($newSock); 
    } 
    else
    {
      my $callData = new CallEventData;
      if ($callData -> receiveData($readyHandle) != -1)
      {
        
        print Dumper($callData->getRaw);
        my $dest =$callData->getRaw->{DEST};
        if($dest eq MESS_MYNAME)
          {
             $mq->send($callData->getFrozen);
          }
        else
          {
          my $destList=$routingTable->{$callData->{RAW}->{DEST}};
          foreach $dest (@$destList)
            {
              $callData->sendData($dest);
            }
          }
      }
      else
      {
        #print Dumper($clientSockets);
        printf "closing socket %s for client at %s:%d\n", $readyHandle, $clientSockets->{$readyHandle}->{IP}, $clientSockets->{$readyHandle}->{PORT};
        undef $clientSockets->{$readyHandle};
        $readSet->remove($readyHandle);
        $readyHandle->close();
      }
    }
  }
}
