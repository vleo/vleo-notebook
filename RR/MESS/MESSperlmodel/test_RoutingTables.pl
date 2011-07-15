#!/usr/bin/perl
use feature say;
use strict;
use RoutingTables;

use Devel::Size qw(size total_size);
use Devel::Size::Report qw/report_size/;

use Data::Dumper;

my $myRT = new RoutingTables;

#say Dumper($myRT), report_size($myRT);

$myRT->lRoute("M2",123,RT_MESS);
$myRT->lRoute("M3",222,RT_MESS);
$myRT->lRoute("M4",333,RT_MESS);
$myRT->lRouteDel("M4");
$myRT->lRouteDel("XX");
$myRT->lRouteDel("M3");

say join(":",map({sprintf "%s => %s ",$_,$myRT->lRoute("M2")->{$_} } keys(%{$myRT->lRoute("M2")})));
say Dumper($myRT), report_size($myRT), 
