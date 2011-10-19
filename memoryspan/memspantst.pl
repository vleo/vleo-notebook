#!/usr/bin/perl
use strict;

my $s;
my @v;
while(<>)
{
  chomp;
  @v = split(' *');
  printf "v= %s\n",join(":",@v);
}
