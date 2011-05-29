#!/usr/bin/perl

use POSIX;
use POSIX::RT::MQ;

my $mqname = '/tcServerIn';

my $attr = { mq_maxmsg  => 1024, mq_msgsize =>  256 };

my $mq = POSIX::RT::MQ->open($mqname, O_RDWR | O_CREAT, 0666, $attr)
         or die "cannot open $mqname: $!\n";

$mq->send('some_message', 0) or die "cannot send: $!\n";

my ($msg,  $prio)  = $mq->receive() or die "cannot receive: $!\n";

0;
