#!/usr/bin/perl
use feature say;
use strict;
use Data::Dumper;
use AuthenticatedLink;

my $myAuth;
my $link = newClient AuthenticatedLink($myAuth,'localhost',6666);

say Dumper($link);
