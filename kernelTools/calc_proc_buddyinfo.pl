#!/usr/bin/perl
# proves that 'free -m' reporst as 'free' all pages that are an all 3 free lists combined
use feature ':5.10';
use strict;

open PROCIN,"/proc/buddyinfo" or die;

my ($nodes,$zn);
while(<PROCIN>)
{
	if( s/^Node 0, zone\s+(\w+)\s+(.*)$/$2/ )
	{
	  $zn = $1;
		while( $_ )
		{
			push @{$nodes->{$zn}},$1 if s/(\d+)\s*(.*)$/$2/;
		}
	}
}

my $allSum;
foreach $zn (keys %$nodes)
{
	my $order=1;
  my $node=$nodes->{$zn};
	#say join(":",@$node);
	my $sum;
	my $n;
	foreach $n (@$node)
	{
		#say $order," ", $n*$order;
	  $sum += $n*$order;
		$order <<= 1;
	}
	say "Free pages in zone $zn: ",$sum;
	$allSum += $sum;
}
printf "from   /proc/buddyinfo: Total free= %6.2f Mb\n", $allSum*4/1024;
system "free -m";
