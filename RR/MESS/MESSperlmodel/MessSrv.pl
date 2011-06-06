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

sub getsecret
{
	my ($self,$parts,$callBack)=@_;

	if(
      $parts->{authzid} eq 'myauth' and
			$parts->{user} eq 'L1'
		)
	{ $callBack->( 'qwerty'  ) }
	else
	{ $callBack->( ''  ) }

}

my	$authOK={};

sub authenticateServer
{
	my ($mySock) = @_;
	# v v v Authenticate new connection v v v
	my $mySasl = Authen::SASL->new (
		mechanism => "DIGEST-MD5",
		callback => 
		{
			getsecret => \&getsecret,
		}
	);

	my $myConn = $mySasl->server_new("mess","mess-server.vks.mt.ru",{ no_integrity => 1 });
	die "We expect to need server_start() for DIGEST-MD5" unless $myConn->need_step;

  my $serverChallange;
	$myConn->server_start("",sub { $serverChallange = shift } ) eq "" or die "Expecting empty return from server_start()\n";
	printf "serverChallange= %s\n",$serverChallange;
	die "We expect to need one server_step() for DIGEST-MD5" unless $myConn->need_step;

	$mySock->send($serverChallange);

  $mySock->blocking(1);
	my $clientResponse;
	my $n = $mySock->sysread($clientResponse,1000);
	printf "buffer read %d bytes: %s\n",$n,$clientResponse;
	my $serverResponse;
	$myConn->server_step($clientResponse, sub { $serverResponse = shift });
	printf "serverResponse= %sr\n",$serverResponse;

	die "We do not expect to need 2nd step for DIGEST-MD5" if $myConn->need_step;

	if ($myConn->code)
	{
		printf "Error code: %d Message: %s\n",$myConn->code,$myConn->error;
	}
	else
	{
		printf "Adding Auth OK status to socket %s\n",$readyHandle;
		$authOK->{$mySock}=$myConn;
	}
	# ^ ^ ^ Authenticate new connection ^ ^ ^

  $mySock->blocking(0);
	print Dumper($myConn);

	return 1;

}

while(1)
{
  my ($readyHandlesSet) = IO::Select->select($readSet, undef, undef, 10); 
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
			if authenticateServer($newSock)
      {
				$routingTable->{eventFrame->getRaw->{CLIENT_ID}}=[$newSock,$ipasc,$port,CONFIG(MESS_MY_ID)];
			}
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
