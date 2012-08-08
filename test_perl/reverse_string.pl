#!/usr/bin/perl

use Benchmark;

sub reverse0
{ return reverse shift }

sub reverse1
{ return join("",reverse split //,shift); }

sub reverse2
{
  my $s = shift;
  my $l = length $s;
  my $r;
  for(my $i=0;$i<$l;$i++)
  { $r .= substr($s,$l-$i-1,1); }
  return $r;
}

sub reverse3
{
   my($s,$r)=@_;
   if($s)
   {
     my $c;
     ($c,$s)= $s =~ /(.)(.*)/;
     $r = $c . $r;
     reverse3($s,$r);
   }
   else
   {
     return $r
   }
}

$str = "ABCDE";
printf "%s : %s : %s : %s\n",scalar(reverse($str)),reverse1($str),reverse2($str),reverse3($str);

for(my $i=0;$i<1000;$i++) { $str .= int(rand(10)); }

timethis(500000,sub { reverse $str }  );
timethis(10000,sub { reverse1($str) } );
timethis(10000,sub { reverse2($str) } );
timethis(1000,sub { reverse3($str) } );

