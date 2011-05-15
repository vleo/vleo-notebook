#!/usr/bin/perl -s
do 'bigint.pl';
($_,$n)=@ARGV;
s/^.(..)*$/0$&/;
($k=unpack('B*',pack('H*',$_)))=~ s/^0*//;
$x=0;
$z=$n=~s/./$x=&badd(&bmul($x,16),hex$&)/ge;
while(1)
{
  $w=((2*$d-1+$z)&~1)/2;
  print $w,"\n";
  break unless read(STDIN,$_,$w);
  $r=1;
  $_=substr($_."\0"x$w,$c=0,$w);s/.|\n/$c=&badd(&bmul($c,256),ord$&)/ge;
  $_=$k;
  s/./$r=&bmod(&bmul($r,$r),$x),$&?$r=&bmod(&bmul($r,$c),$x):0,""/ge;
  ($r,$t)=&bdiv($r,256),$_=pack(C,$t).$_ while$w--+1-2*$d;
  print
}
