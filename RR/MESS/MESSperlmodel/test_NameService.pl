#!/usr/bin/perl

use feature say;
use strict;
use NameService;

say "Primary MESS:",NAME_PRIMARY;
say "Secondary MESS:",NAME_SECONDARY;
say "Tertirary MESS:",NAME_TERTIARY;

for my $id (NAME_ALL_IDS)
{
#  say "IP/port of $id is",NAME_SERVICE($id)->{host},":",NAME_SERVICE($id)->{port};
  say "IP/port of $id is",NAME_SERVICE_HOST($id),":",NAME_SERVICE_PORT($id);
}
