#!/usr/bin/perl

use strict; 

use Data::Dumper;
use POSIX;
use POSIX::RT::MQ;
use XML::Smart;

use CallEventData;

use MessConfig;
DEFAULT_CONFIG_FILE('MessConfig.xml');

use TwoWayMQLink;

my $mq = new TwoWayMQLink(CONFIG('TC_SERV_MQ'));

$mq->{IN}->blocking(1);

my $messEvent = new MessEvent;
my $callData = new CallEventData;
my $msg;
while($msg=$mq->{IN}->receive())
{
   $callData->setFrozen($msg);
   print Dumper($callData->getRaw());
	 # here methos are implemented in tcServer
	 if ($callData->getRaw->{METHOD} eq 'pingtcs')
	 {
		 my $replyEvent = new MessEvent(CONFIG('TC_SERV_ID'),$callData->getRaw->{SRC},'pingtcs',undef,$callData->getRaw->{ARGVAL});
		 $callData->setRaw($replyEvent);
		 $mq->{OUT}->send($callData->getFrozen);
	 }
}

