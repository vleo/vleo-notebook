#!/usr/bin/perl

use feature say;
use strict;

use IO::Select;
use Socket;

use Data::Dumper;

use AuthenticatedLink;
use CallEventData;

use TwoWayMQLink;
use MessConfig;
DEFAULT_CONFIG_FILE('MessConfig.xml');
use NameService;

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
my $mq = new TwoWayMQLink(CONFIG('TC_SERV_MQ'),'reverse');
$mq->{IN}->blocking(0);

my $initMsg = new MessEvent(CONFIG('MESS_MY_ID'),CONFIG('TC_SERV_ID'),"mqRegister",{ messID => &CONFIG('MESS_MY_ID') },{ OK => undef});
my $callData = new CallEventData;
$callData->setRaw($initMsg);
$mq->sendMsg($callData->getFrozen());

# we need to pass structure of { methodName => "func1", argumentsStruct => { A=>1, B=>"qwerty"}, valueStruct => { X=>2,Y="QWERTY"} }
# called relayed to appropriate TcServer
# what can come from $newSock
# 1) method call (0,0,1)
# 2) event (0,0,2)

# establish connection with upstream MESS server
if (CONFIG(MESS_MY_ID) eq NAME_PRIMARY)
{
	say "We are the primary, no futher up connection required";
}
else
{
	say "We have to connect to Primary(or Secondary, then Tertiary)";
}

my $serverSock = newServer AuthenticatedLink(6666);
my $readSet = new IO::Select();
$readSet->add($serverSock);

#$serverSock->listenOnPort(\&serverletThread);

# main loop on all sockets for all clients
# select()
# can read - read - write to destination
 
my $clientSockets={};
# { message destination => open socket }
my $routingTable={};

=pod
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

=pod
my $passWords=
{
	# auth domain
	'messauth' => 
	  {
			# loginID => cleartext password
			'L1' => 'qwerty',
			'L2' => 'abcdef',
			'L3' => '12345',
			'L4' => '76543210'
	  }
};

sub getsecret
{
	my ($self,$parts,$callBack)=@_;
	$callBack->($passWords->{
	                          $parts->{authzid}
													}->
														{
															$parts->{user}
														});
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
	$mySock->send($serverResponse);

	die "We do not expect to need 2nd step for DIGEST-MD5" if $myConn->need_step;

	if ($myConn->code)
	{
		printf "Error code: %d Message: %s\n",$myConn->code,$myConn->error;
		return;
	}
	
	printf "Adding Auth OK status to socket %s\n",$mySock;
	$authOK->{$mySock}=$myConn;
	# ^ ^ ^ Authenticate new connection ^ ^ ^

  $mySock->blocking(0);
	#print Dumper($myConn);

	return $myConn->{'answer'}{'username'};

}
=cut

my $myClientsIDs =
	  {
			# loginID => cleartext password
			'L1' => 'qwerty',
			'L2' => 'abcdef',
			'L3' => '12345',
			'L4' => '76543210'
	  };

my	$authOK={};

while(1)
{
	sleep(1);
  my ($readyHandlesSet) = IO::Select->select($readSet, undef, undef, 1); 
	if ($readyHandlesSet)
	{
		printf "Got %d sockets ready to be read\n",int(@$readyHandlesSet);
		printf "ready sockets: %s\n",join(":",@$readyHandlesSet);
		printf "authOK: %s\n",join(":",map sprintf("%s => %s",$_,$authOK->{$_}),(keys %$authOK));
	};

	# process MQ
	my $msg;
	while ($msg=$mq->recvMsg())
	{
		my $callData = new CallEventData;
		$callData->setFrozen($msg);
		print "FROM MQ: ",Dumper($callData->getRaw);
		if($callData->getRaw->{DEST} eq CONFIG('MESS_MY_ID'))
		{
			if ($callData->getRaw->{METHOD} eq 'pingtcs')
			{
				print Dumper($callData->getRaw);
			}
		}
		else
		{
			$callData->sendData($routingTable->{$callData->getRaw->{DEST}}->[0]);
		}
	}

	# process SOCK
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
			my $ipasc=join(".",unpack("C*",$ipraw));
      printf "opened socket for client at addr %s:%d\n",$ipasc,$port;

			$newSock->authenticateOnServer($myClientsIDs);
			my $clientID=$newSock->getAuth;
			if($clientID)
			{	
				$authOK->{$newSock}=$clientID;
				$routingTable->{$clientID}=[$newSock,$ipasc,$port,CONFIG('MESS_MY_ID')];
			}
			else
			{
				printf "Failure to authenticate socket %s\n",$newSock;
			}
    } 
    elsif ($authOK->{$readyHandle})
    {
      my $callData = new CallEventData;
      if ($callData -> receiveData($readyHandle) != -1)
      {
        
        print "FROM SOCK: ", Dumper($callData->getRaw);
        my $dst = $callData->getRaw->{DEST};
				my $src  = $callData->getRaw->{SRC};
				my $method = $callData->getRaw->{METHOD};
				my $argval = $callData->getRaw->{ARGVAL}; 
        if($dst eq CONFIG('MESS_MY_ID'))
        {
				# process events addressed to MESS server
					if ($method eq 'ping')
					{
						my $callData = new CallEventData;
						my $messEvent = new MessEvent($dst,$src,"ping",undef,$argval);
						$callData->setRaw($messEvent);
						$callData->sendData($readyHandle);
					}
					else # forward to corresponding TC server
					{
					  $mq->sendMsg($callData->getFrozen);
					}
        }
        else
          {
          my $destList=$routingTable->{$dst};
					my $fwdDst;
          foreach $fwdDst (@$destList)
            {
              $callData->sendData($fwdDst);
            }
          }
      }
			else
			{
				goto CLOSE;
			}
		}
    else
    {
			CLOSE:
      #print Dumper($clientSockets);
      printf "closing socket %s for client at %s:%d\n", $readyHandle, join(":",unpack("C*",$clientSockets->{$readyHandle}->{IP})), $clientSockets->{$readyHandle}->{PORT};
      delete $clientSockets->{$readyHandle};
      $readSet->remove($readyHandle);
			delete $authOK->{$readyHandle} if defined($authOK->{$readyHandle});
      $readyHandle->close();
    }
  }
}
