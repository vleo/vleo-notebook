#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  test_operators.pl
#
#        USAGE:  ./test_operators.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  01/25/2012 07:01:33 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


my $v=7;

my $m=0;

$m ||= $v == 7;
$m ||= $v == 8;

print $m,"\n";
