#!/usr/bin/perl
use strict;

sub printToN
{
  my($current,$limit)=@_;
  if($current <= $limit)
  {
    printf "%d\n",$current;
    printToN($current+1,$limit);
  }
};

printToN(1,10);
