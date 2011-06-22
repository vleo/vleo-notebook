#!/usr/bin/perl
use feature say;
use strict;
use Data::Dumper;

use AuthenticationData;
#use AuthenticationData 'AuthData2.xml';
#use AuthenticationData 'AuthData_2.xml';


say GET_AUTH("M1");

say Dumper(GET_AUTH_TABLE);
