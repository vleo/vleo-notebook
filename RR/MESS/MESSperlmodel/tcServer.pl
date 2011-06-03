#!/usr/bin/perl

use Data::Dumper;
use POSIX;
use POSIX::RT::MQ;
use CallEventData;
use XML::Smart;
use MessConfig;
DEFAULT_CONFIG_FILE('MessConfig.xml');

# FIXME - convert to Class (also used by MessSrv)
# $messMQ = new MessMQ(TCSERVERMQ);
my $attr = { mq_maxmsg  => 10, mq_msgsize =>  8192 };
my $mq = POSIX::RT::MQ->open(CONFIG(TCSERVERMQ), O_RDWR|O_CREAT, 0600, $attr)
            or die "cannot open $mqname: $!\n";


$mq->blocking(1);

my $messEvent = new MessEvent;
my $callData = new CallEventData;
while($msg=$mq->receive())
{
   $callData->setFrozen($msg);
   print Dumper($callData->getRaw());
}

