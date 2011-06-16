#!/usr/bin/perl

use feature say;
use MessConfig;
use strict;

#DEFAULT_CONFIG_FILE('MessConfig_2.xml');

say CONFIG(MESS_MY_ID);
say CONFIG(TC_SERV_MQ);
say CONFIG(TC_SERV_ID);
