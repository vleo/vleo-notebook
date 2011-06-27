#!/usr/bin/perl

use strict;
use feature 'say';
use AuthenticatedLink;
use MessMessage;
use MessageTransport;
use Data::Dumper;
use Time::HiRes 'gettimeofday';

use MessConfig qw(tcClient.xml c MY_ID MY_PWD MY_MESS_ADDR MY_MESS_PORT MY_MESS_ID);

use Authen::SASL;

use IO::Select;
use Socket;
##########################################################################

my $sock = newClient AuthenticatedLink(
	MY_PWD,
	MY_ID,
	MY_MESS_ADDR,
	MY_MESS_PORT
);

my $readSet = new IO::Select();
$readSet->add($sock);

my $returnData = new MessageTransport;

if(my $pid = fork)
{ # parent
	say "server iteration (receive msgs) process $pid spawned";
	while(<>)
	{
		chomp;
		s/^\s+//;
		s/\s+$//;
		say ">$_<";
		my($cmd,$arg1,$arg2) = split(/\s+/);
		last if $cmd eq 'q';
		if($cmd eq 'p')
		{
			my $callData = new MessageTransport
				 (MT_CALL,MY_ID,MY_MESS_ID,$arg1,$arg2,"ping",{ tm => scalar(gettimeofday)});
			print "Sending: ",Dumper($callData->getMsg);
			$callData->sendData($sock);
		}
	}
	kill 15, $pid;
}
elsif (defined($pid))
{ #child
	sleep(1);
  say "child pid=$pid";
  while(1)
	{
		if(my ($readyHandlesSet) = IO::Select->select($readSet, undef, undef, 1))
		{
			foreach my $readyHandle (@$readyHandlesSet) 
			{
				my $msg = new MessageTransport;
				if($msg->receiveData($readyHandle) != -1)
				{
					$msg->printMsg;
					if ($msg->get_METHOD eq 'ping' and $msg->get_TYPE eq MT_CALL)
					{
						my $replyMsg = new MessageTransport
							(MT_RET,MY_ID,MY_MESS_ID,$msg->get_SRCSUB,$msg->get_SRC,$msg->get_METHOD,{tm0 => $msg->get_ARGVAL->{tm}, tm => scalar(gettimeofday)},MS_OK,$msg->get_UUID);
						# route reply packet
						$replyMsg->sendData($readyHandle);
					}
				}
				else
				{ goto END }
			}
		}
	}

}
else
{ die "Error spawning child process: $?" }

goto END;

goto P2;


my $returnData = new MessageTransport;
$returnData->receiveData($sock);
print Dumper($returnData->getMsg);
sleep(1);
goto END;

P2:
my $callData = new MessageTransport
    (MT_CALL,MY_ID,MY_MESS_ID,'S1',MY_MESS_ID,"ping",{ tm => scalar(gettimeofday)});
print "Sending: ",Dumper($callData->getMsg);
$callData->sendData($sock);
my $returnData = new MessageTransport;
$returnData->receiveData($sock);
print Dumper($returnData->getMsg);
sleep(1);
goto END;

END:
printf "Closing socket\n";
$sock->close();
