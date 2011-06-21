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

use RoutingTables;

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

if (CONFIG(MESS_MY_ID) eq NAME_PRIMARY)
{
	say "We are the primary, no futher up connection required";
}
else
{
	say "We have to connect to Primary(or Secondary, then Tertiary)";
  $sockUpPrim = newClient AuthenticatedLink(
	  CONFIG('MESS_MY_PWD'),
	  CONFIG('MESS_MY_ID'),
	  NAME_PRIMARY_HOST,
	  NAME_PRIMARY_PORT 
);
	$sockUpPrim or die;
}

my $serverSock = newServer AuthenticatedLink(NAME_SERVICE_PORT(CONFIG(MESS_MY_ID)));
my $readSet = new IO::Select();
$readSet->add($serverSock);

#$serverSock->listenOnPort(\&serverletThread);

# main loop on all sockets for all clients
# select()
# can read - read - write to destination
 
my $clientSockets={};
# { message destination => open socket }
my $routingTable={};

my $myClientsIDs =
	  {
			# loginID => cleartext password
			'L1' => 'qwerty',
			'L2' => 'abcdef',
			'L3' => '12345',
			'L4' => '76543210',
			'M1' => 'M1qwerty'
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
