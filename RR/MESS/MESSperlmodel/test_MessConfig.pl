#!/usr/bin/perl

use feature say;
#use MessConfig;
use MessConfig qw(MessConfig_2.xml c MESS_MY_ID MESS_MY_PWD TC_SERV_MQ MESS_PRIMARY TC_SERV_ID MESS_MY_HOST MESS_MY_PORT);
use strict;

say MESS_MY_ID;
say MESS_MY_PWD;
say TC_SERV_MQ;
say TC_SERV_ID;
