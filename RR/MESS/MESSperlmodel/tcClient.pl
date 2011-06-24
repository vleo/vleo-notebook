#!/usr/bin/perl

use strict;
use feature 'say';
use AuthenticatedLink;
use MessMessage;
use MessageTransport;
use Data::Dumper;

use MessConfig qw(tcClient.xml c MY_ID MY_PWD MY_MESS_ADDR MY_MESS_PORT MY_MESS_ID);

use Authen::SASL;

##########################################################################

my $sock = newClient AuthenticatedLink(
	MY_PWD,
	MY_ID,
	MY_MESS_ADDR,
	MY_MESS_PORT
);

my $callData = new MessageTransport;
    (MT_CALL,MY_ID,MY_MESS_ID,SUBADDR_SELF,MY_MESS_ID,"ping",{ a=>1, b=>2});

$callData->sendData($sock);

my $returnData = new MessageTransport;
$returnData->receiveData($sock);
print Dumper($returnData->getMsg);

sleep(3);
my $messEvent1 = new MessEvent(MY_ID,'M2',"pingtcs",{ a=>1, b=>2},undef);
$callData->setRaw($messEvent1);
$callData->sendData($sock);
$returnData->receiveData($sock);
print Dumper($returnData->getMsg);

sleep(3);
$messEvent1 = new MessEvent(MY_ID,'M2',"ping",{ a=>1, b=>2},undef);
$callData->setRaw($messEvent1);
$callData->sendData($sock);
$returnData->receiveData($sock);
print Dumper($returnData->getMsg);

while($returnData->receiveData($sock)>0)
{
	say "events arrived";
	# this return corresponds to previous call
#	if ( UUID in list of calls made)
#	{
#	}
  print Dumper($returnData->getMsg);
}

printf "Closing socket\n";
$sock->close();
