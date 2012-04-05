#!/usr/bin/perl
sub x
{
 my $class = shift;
 my %h = @_;
 print $class,"\n";
 foreach $key (keys %h)
  {
  printf " %s => %s\n",$key,$h{$key};
  }
}

$h = {
     LocalHost => 'localhost',
     LocalPort => 6666,
     Proto => 'tcp',
     Listen => 5,
     Reuse => 1 
   };
print ref($h),"\n";
x(%$h);
x('qqq',a,1,b,2);
