#!/usr/bin/perl

use feature 'say';
use POSIX;
use POSIX::RT::MQ;

my $mqname = '/tcServerIn';

my $attr = { mq_maxmsg => 10, mq_msgsize => 8192 };

my $mq = POSIX::RT::MQ->open( $mqname, O_RDWR | O_CREAT, 0666, $attr )
         or die "cannot open $mqname: $!\n";

$mq->send( 'MQ test: OK', 0 ) or die "cannot send: $!\n";

my ( $msg, $prio ) = $mq->receive() or die "cannot receive: $!\n";

say $msg;

0;
