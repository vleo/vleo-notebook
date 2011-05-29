#!/usr/bin/perl

use Data::Dumper;
use POSIX;
use POSIX::RT::MQ;
use CallEventData;
use MessConfig;

# FIXME - convert to Class (also used by MessSrv)
# $messMQ = new MessMQ(TCSERVERMQ);
my $mqname = TCSERVERMQ;
my $attr = { mq_maxmsg  => 8192, mq_msgsize =>  1024 };
my $mq = POSIX::RT::MQ->open($mqname, O_RDWR|O_CREAT, 0600, $attr)
            or die "cannot open $mqname: $!\n";


$mq->blocking(1);

my $messEvent = new MessEvent;
my $callData = new CallEventData;
while($msg=$mq->receive())
{
   $callData->setFrozen($msg);
   print Dumper($callData->getRaw());
}

