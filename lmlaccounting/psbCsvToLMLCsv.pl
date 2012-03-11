#!/usr/bin/perl

use strict;
use descriptionToCorrAcct;
use Getopt::Std;
use Text::CSV;

getopts("i:o:m:hH");
our $opt_i;
our $opt_o;
our $opt_m;
our $opt_h;
our $opt_H;

if ($opt_h or not defined($opt_i))
{
print <<EOT;
Generate SQLedger .pl service scripts invokations shell script
Usage: $0 <options>
Options:
    -i <input file>
    -o <output file>  default: stdout
    -m <month>        do for just one month
    -h                this help
    -H                Input CSV file format description
EOT
exit
}


### MAIN ###
my $csv = Text::CSV->new or die "Cannot use CSV: ".Text::CSV->error_diag ();

open my $fh, "<:encoding(utf8)", $opt_i or die "$opt_i: $!";

my $row = $csv->getline($fh);
die unless $row->[0] eq "Account Number";
$csv->column_names($csv->fields());

my($date, $withdr, $withdrTot, $dep, $depTot, $corracct, $descr, $amt);

while ( my $lin = $csv->getline_hr($fh) ) {

  my($mnum,$day,$year) = split(/\//,$lin->{'Post Date'});
   
  my $date=sprintf("%04d-%02d-%02d",$year,$mnum,$day);

  print $date,"\n";
  $withdr = $lin->{'Debit'};
  $withdrTot += $withdr;

  $dep    = $lin->{'Credit'};
  $depTot    += $dep;

  die "withdr and dep both defined: $_" if $withdr != 0 and $dep != 0;
  $amt = $withdr > 0 ? $withdr : $dep;
#  $corracct = $lin[6];
  $descr = $lin->{'Description'};
}
