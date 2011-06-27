#!/usr/bin/perl

use strict; 

use Data::Dumper;
use POSIX;
use POSIX::RT::MQ;
use XML::Smart;
use Time::HiRes 'gettimeofday';

use MessMessage;
use MessageTransport;

use MessConfig qw(MessConfig.xml c TC_SERV_MQ TC_SERV_ID MESS_MY_ID);

use TwoWayMQLink;

my $mq = new TwoWayMQLink(TC_SERV_MQ);

$mq->{IN}->blocking(1);

my $msg = new MessageTransport;
my $mqMsg;
while($mqMsg=$mq->{IN}->receive())
{
   $msg->setFrozen($mqMsg);
   $msg->print;
	 # here methos are implemented in tcServer
	 if ($msg->get_METHOD eq 'pingtcs')
	 {
		 my $replyMsg = new MessageTransport(MT_RET,TC_SERV_ID,MESS_MY_ID,$msg->get_SRCSUB,$msg->get_SRC,$msg->get_METHOD,$msg->get_ARGVAL,MS_OK,$msg->get_UUID);
		 $mq->{OUT}->send($replyMsg->getFrozen);
	 }
	 if ($msg->get_METHOD eq 'mqRegister')
	 {
		 my $replyMsg = new MessageTransport(MT_RET,TC_SERV_ID,MESS_MY_ID,$msg->get_SRCSUB,$msg->get_SRC,$msg->get_METHOD,{ tm => scalar(gettimeofday) },MS_OK,$msg->get_UUID);
		 $mq->{OUT}->send($replyMsg->getFrozen);
	 }
	 else  # add other TC SERVER methods/event handlers here ^^^^^^^^^^^^^^^
	 {
		 my $replyMsg = new MessageTransport(MT_RET,TC_SERV_ID,MESS_MY_ID,$msg->get_SRCSUB,$msg->get_SRC,$msg->get_METHOD,$msg->get_ARGVAL,MS_NOMETHOD,$msg->get_UUID);
		 $mq->{OUT}->send($replyMsg->getFrozen);
	 }
}

