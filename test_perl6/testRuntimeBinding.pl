#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  x.pl
#
#        USAGE:  ./x.pl  
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
#      CREATED:  06/06/2011 04:40:31 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


printf "f(0)=%d\n",f(0);

my $i=5;

while($i--)
{
  sub f { my $n = shift; return 10+$n+$i };
  printf "f(0)=%d\n",f(0);
}

$i=1;
printf "g(0)=%d\n",g(0);

$i=int(<STDIN>);

if ($i)
{ 
  printf "i=%d\n",$i;
  sub g { 123; } 
} 
else
{ 
  printf "i=%d\n",$i;
  sub g { 321; } 
} 
