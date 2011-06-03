#!/usr/bin/perl

use IO::Select;
use Socket;
use POSIX;
use POSIX::RT::MQ;
use Data::Dumper;


use TcpConnection;
use CallEventData;

use MessConfig;
DEFAULT_CONFIG_FILE('MessConfig.xml');

use Authen::SASL qw(Perl);

=pod
print CONFIG(TCSERVERMQ),"\n";
print CONFIG(MY_ID),"\n";
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
my $attr = { mq_maxmsg  => 10, mq_msgsize =>  8192 };
my $mq = POSIX::RT::MQ->open($mqname, O_RDWR|O_CREAT, 0600, $attr)
            or die "cannot open $mqname: $!\n";

my $initMsg = new MessEvent(&CONFIG(MESS_MYNAME),"mqRegister",{ messID => &CONFIG(MESS_MY_ID) },{ OK => undef});
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

$routingTable->{'VC1'} = ['M1','sock:1234'];
$routingTable->{'VC2'} = ['M1','sock:5678'];
$routingTable->{'M2'} = ['M1','sock:4321'];
$routingTable->{'VC3'} = ['M2','sock:4321'];

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
      $readSet->add($newSock); 

      my ($port,$ipraw)=unpack_sockaddr_in($addr);
      $clientSockets->{$newSock}->{PORT} = $port;
      $clientSockets->{$newSock}->{IP} = $ipraw;
      printf "opened socket for client at addr %s:%d\n",join(".",unpack("C*",$ipraw)),$port;

      my $sasl = Authen::SASL->new (
        mechanism => "PLAIN",
        callback => 
        {
          checkpass => \&checkpass,
          canonuser => \&canonuser,
        }
      );

      # Creating the Authen::SASL::Cyrus instance
      my $conn = $sasl->server_new("mess");
      # Clients first string (maybe "", depends on mechanism)
      # Client has to start always
      my $request = <$newSock>;
      printf "request=%s\n",$request;
      my $reply = $conn->server_start( $request );
      printf "reply=%s\n",$reply;
      print $sock $conn->server_start( $request );

#          $routingTable->{eventFrame->getRaw->{CLIENT_ID}}=[$newSock,$ipasc,$port,$localMessID];
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
          my $destList=$routingTable->{$callData->getRaw->{DEST}};
          foreach $dest (@$destList)
            {
              $callData->sendData($dest);
            }
          }
      }
      else
      {
        #print Dumper($clientSockets);
        printf "closing socket %s for client at %s:%d\n", $readyHandle, join(":",unpack("C*",$clientSockets->{$readyHandle}->{IP})), $clientSockets->{$readyHandle}->{PORT};
        undef $clientSockets->{$readyHandle};
        $readSet->remove($readyHandle);
        $readyHandle->close();
      }
    }
  }
}
