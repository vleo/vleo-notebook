#!/usr/bin/perl

use feature 'say';
use strict;

use IO::Select;
use Socket;

use Data::Dumper;

use AuthenticatedLink;
use MessMessage;
use MessageTransport;

use TwoWayMQLink;
use MessConfig qw(MessConfig.xml c MESS_MY_ID MESS_MY_PWD TC_SERV_MQ MESS_PRIMARY TC_SERV_ID MESS_MY_HOST MESS_MY_PORT);
use NameService;

use RoutingTables;
use AuthenticationData;

use Authen::SASL qw(Perl);


# MY tcServer
my $mq = new TwoWayMQLink(TC_SERV_MQ,'reverse');
$mq->{IN}->blocking(0);

my $callData = new MessageTransport
  (MT_CALL,SUBADDR_SELF,MESS_MY_ID,TC_SERV_ID,MESS_MY_ID,,"mqRegister",{ messID => MESS_MY_ID });

say $callData->get_UUID;

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

if (not MESS_PRIMARY)
{
	say "We are the primary, no futher up connection required";
}
else
{
	say "We have to connect to Primary(or Secondary, then Tertiary)";
  $sockUpPrim = newClient AuthenticatedLink(
	  MESS_MY_PWD,
	  MESS_MY_ID,
	  NAME_SERVICE_HOST(MESS_PRIMARY),
	  NAME_SERVICE_PORT(MESS_PRIMARY)
);
	$sockUpPrim or die;
	$routingTable->mRoute(MESS_MY_ID,MESS_PRIMARY,$sockUpPrim,'MESS');
  $readSet->add($sockUpPrim);
	$authOK->{$sockUpPrim}=MESS_PRIMARY;
}

# open my server socket
say MESS_MY_ID;
say NAME_SERVICE_PORT(MESS_MY_ID);
my $serverSock = newServer AuthenticatedLink(NAME_SERVICE_PORT(MESS_MY_ID));
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
	$routingTable -> bcastLocalIpPort(MESS_MY_ID,MESS_MY_HOST,MESS_MY_PORT);
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
		my $callData = new MessageTransport;
		$callData->setFrozen($msg);
		print "FROM MQ: "; $callData->printMsg;
		$routingTable->floodRoute(MESS_MY_ID,$callData,sub {});
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
				$routingTable->mRoute(MESS_MY_ID,$clientID,$newSock);
			}
			else
			{
				printf "Failure to authenticate socket %s\n",$newSock;
			}
    } 
    elsif ($authOK->{$readyHandle})
    {
      my $callData = new MessageTransport;
      if ($callData->receiveData($readyHandle) != -1 )
      {
        
        print "FROM SOCK: ", $callData->printMsg;
				$routingTable->floodRoute(MESS_MY_ID,$callData,sub 
					{
						my $msg=shift;
					  # process events addressed to this MESS server itself or it's TC server
						if ($msg->get_METHOD eq 'ping')
						{
							if ($msg->get_DSTSUB eq SUBADDR_SELF)
							{
								my $callData = new MessageTransport
									(MT_RET,SUBADDR_SELF,MESS_MY_ID,$msg->get_SRCSUB,$msg->get_SRC,"ping",$msg->get_ARGVAL,MS_OK,$msg->get_UUID);
								# route reply packet
								$routingTable->floodRoute(MESS_MY_ID,$callData,sub {});
							}
							elsif ($msg->get_DSTSUB eq TC_SERV_ID)
							 # forward to attached TC server
							{
								$mq->sendMsg($callData->getFrozen);
							}
							else
							{
								die "should route to other subaddr even for this MESS_ID in routingTables::";
							}
						}
						else	# unkown method, ADD METHODS / EVENT handlers here ^^^^^^^^^^^
						{
							say "got unhandled method ",$msg->get_METHOD," request";
							my $callData = new MessageTransport
								(MT_RET,SUBADDR_SELF,MESS_MY_ID,$msg->get_SRCSUB,$msg->get_SRC,msg->get_METHOD,undef,MS_NOMETHOD,$msg->get_UUID);
							# route reply packet
							$routingTable->floodRoute(MESS_MY_ID,$callData,sub {});
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
