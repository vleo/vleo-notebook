#!/usr/bin/perl

use strict;
use feature 'say';
use AuthenticatedLink;
use MessageTransport;
use Data::Dumper;

use MessConfig 'tcClient.xml' "c:" qw(MY_ID MY_PWD MY_MESS_ADDR MY_MESS_PORT MY_MESS_ID);

use Authen::SASL;

##########################################################################

my $sock = newClient AuthenticatedLink(
	MY_PWD,
	MY_ID,
	MY_MESS_ADDR,
	MY_MESS_PORT
);

my $callData = new MessageTransport;
my $messEvent = new MessEvent(MY_ID,MY_MESS_ID,"ping",{ a=>1, b=>2},undef);

$callData->setRaw($messEvent);
$callData->sendData($sock);

my $returnData = new MessageTransport;
$returnData->receiveData($sock);
print Dumper($returnData->getRaw);

sleep(3);
my $messEvent1 = new MessEvent(MY_ID,'M2',"pingtcs",{ a=>1, b=>2},undef);
$callData->setRaw($messEvent1);
$callData->sendData($sock);
$returnData->receiveData($sock);
print Dumper($returnData->getRaw);

sleep(3);
$messEvent1 = new MessEvent(MY_ID,'M2',"ping",{ a=>1, b=>2},undef);
$callData->setRaw($messEvent1);
$callData->sendData($sock);
$returnData->receiveData($sock);
print Dumper($returnData->getRaw);

while($returnData->receiveData($sock)>0)
{
	say "events arrived";
	# this return corresponds to previous call
#	if ( UUID in list of calls made)
#	{
#	}
  print Dumper($returnData->getRaw);
}

printf "Closing socket\n";
$sock->close();
