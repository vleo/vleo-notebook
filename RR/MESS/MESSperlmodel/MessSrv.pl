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
DEFAULT_CONFIG_FILE("MessConfig.xml");
use NameService;

use RoutingTables;
use AuthenticationData;

use Authen::SASL qw(Perl);


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
# establish other initial connections

# MESS PEERS
# foreach $peer (TCSERVERMQ)
#  {
#  }

my $sockUpPrim;
my $routingTable = new RoutingTables;
my $readSet = new IO::Select();
my $authOK={};

if (not CONFIG(MESS_PRIMARY))
{
	say "We are the primary, no futher up connection required";
}
else
{
	say "We have to connect to Primary(or Secondary, then Tertiary)";
  $sockUpPrim = newClient AuthenticatedLink(
	  CONFIG(MESS_MY_PWD),
	  CONFIG(MESS_MY_ID),
	  NAME_SERVICE_HOST(CONFIG(MESS_PRIMARY)),
	  NAME_SERVICE_PORT(CONFIG(MESS_PRIMARY))
);
	$sockUpPrim or die;
	$routingTable->mRoute(CONFIG(MESS_MY_ID),CONFIG(MESS_PRIMARY),$sockUpPrim,'MESS');
  $readSet->add($sockUpPrim);
	$authOK->{$sockUpPrim}=CONFIG(MESS_PRIMARY);
}

# open my server socket
say CONFIG(MESS_MY_ID);
say NAME_SERVICE_PORT(CONFIG(MESS_MY_ID));
my $serverSock = newServer AuthenticatedLink(NAME_SERVICE_PORT(CONFIG(MESS_MY_ID)));
$readSet->add($serverSock);

my $clientSockets={};

=pod
my $myClientsIDs =
	  {
			# loginID => cleartext password
			'L1' => 'qwerty',
			'L2' => 'abcdef',
			'L3' => '12345',
			'L4' => '76543210',
			'M1' => 'M1qwerty'
	  };
=cut


while(1)
{
	sleep(1);
	$routingTable -> bcastLocalIpPort(CONFIG(MESS_MY_ID),CONFIG(MESS_MY_HOST),CONFIG(MESS_MY_PORT));
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
			$routingTable->floodRoute(CONFIG(MESS_MY_ID),$callData,sub {});
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
      $clientSockets->{$newSock}->{IPASC} = $ipasc;
      printf "opened socket for client at addr %s:%d\n",$ipasc,$port;

			$newSock->authenticateOnServer(GET_AUTH_TABLE);
			my $clientID=$newSock->getClientID;
			if($clientID)
			{	
				$authOK->{$newSock}=$clientID;
				say "Adding route to $clientID";
				$routingTable->mRoute(CONFIG(MESS_MY_ID),$clientID,$newSock);
			}
			else
			{
				printf "Failure to authenticate socket %s\n",$newSock;
			}
    } 
    elsif ($authOK->{$readyHandle})
    {
      my $callData = new CallEventData;
      if ($callData->receiveData($readyHandle) != -1 )
      {
        
        print "FROM SOCK: ", Dumper($callData->getRaw);
				$routingTable->floodRoute(CONFIG(MESS_MY_ID),$callData,sub 
					{
					# process events addressed to this MESS server
						if ($_[0]->getRaw->{METHOD} eq 'ping')
						{
							my $callData = new CallEventData;
							my $messEvent = new MessEvent($_[0]->getRaw->{DEST},$_[0]->getRaw->{SRC},"ping",undef,$_[0]->getRaw->{ARGVAL});
							$callData->setRaw($messEvent);
							# route reply packet
							$routingTable->floodRoute(CONFIG(MESS_MY_ID),$callData,sub {});
						}
						else # forward to attached TC server
						{
							$mq->sendMsg($callData->getFrozen);
						}
					});
			}
			else
			{
				goto CLOSE
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
