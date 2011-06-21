#!/usr/bin/perl
use feature say;
use strict;
use RoutingTables;

use Devel::Size qw(size total_size);
use Devel::Size::Report qw/report_size/;

use Data::Dumper;

my $myRT = new RoutingTables;

#say Dumper($myRT), report_size($myRT);

$myRT->mRoute("M1","M2");
$myRT->mRoute("M1","M3");
$myRT->mRoute("M1","M4");
$myRT->mRouteDel("M1","M4");
$myRT->mRouteDel("M1","XX");
$myRT->mRouteDel("M1","M2");
$myRT->mRouteDel("M1","M3");
$myRT->mRoute("M1","M2",[1,2,3]);

#say Dumper($myRT), report_size($myRT),Dumper($myRT->mRoute);
print Dumper($myRT->mRoute("M1"));
