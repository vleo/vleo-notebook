#!/usr/bin/perl

$lp=12;

#srand(33);

@L=split //,'01234567890qwertyuiopasdfghjkzxcvbnmQWERTYUIPLKJHGFDSAZXCVBNM+-?!$%&@_';

#@L=split //,'0123456789qwerty';
$sl=int(@L);
#print int(@L),"\n"; 
#print join(":",@L),"\n";

while ($i++ < $lp)
{
$r1=int(rand($sl));
$d[$r1]++;
$p = $p . $L[$r1];
}

for ($j=0;$j<$sl;$j++)
{
#printf "%2d %s  %3d %s\n", $j, $L[$j], $d[$j] , '*' x $d[$j];
}

print $p,"\n";
