#!/usr/bin/perl

use strict;
use descriptionToCorrAcct;
use Getopt::Std;
use Text::CSV;
use URI::Escape;
sub sqesc

{
  my ($s) = @_;

  $s =~ s/'/'\\''/g;

  return $s;
}

### OPTIONS ###

getopts("i:o:m:y:vhH");
our $opt_i;
our $opt_o;
our $opt_m;
our $opt_y;
our $opt_v;
our $opt_h;
our $opt_H;

### HELP ####

if ($opt_h or not defined($opt_i) or not defined($opt_o))
{
print <<EOT;
Generate SQLedger .pl service scripts invokations shell script
Usage: $0 <options>
Mandatory:
    -i <input file>  
    -o <output file>  
Optional:
    -m <month>        do for just one month
    -y <year>         do for year given
    -v                Print text report on STDERR
    -h                this help
    -H                Input CSV file format description
EOT
exit
}


### MAIN ###
open my $fOut, ">$opt_o" or die "$opt_o: $!";

my $csv = Text::CSV->new or die "Cannot use CSV: ".Text::CSV->error_diag ();

open my $fh, "<:encoding(utf8)", $opt_i or die "$opt_i: $!";

my $row = $csv->getline($fh);
die unless $row->[0] eq "Account Number";
$csv->column_names($csv->fields());

my($bankAcct, $date, $memo, $descr, $withdr, $dep, $corracct );
my($withdrTot, $depTot, $amount, $amt, $debitacc, $creditacc, $acctsrc, $acctmemo);

while ( my $lin = $csv->getline_hr($fh) ) {

  $bankAcct = $lin->{'Account'};


  my($mnum,$day,$year) = split(/\//,$lin->{'Post Date'});
  next if $opt_y and $opt_y != $year;
  next if $opt_m and $opt_m != $mnum;
   
  my $date=sprintf("%04d-%02d-%02d",$year,$mnum,$day);

  $memo = $lin->{'Check'};

  $descr = $lin->{'Description'};

  $withdr = $lin->{'Debit'};
  $withdrTot += $withdr;

  $dep    = $lin->{'Credit'};
  $depTot    += $dep;

  die "withdr and dep both defined: $_" if $withdr != 0 and $dep != 0;
  $amount = $withdr > 0 ? -$withdr : $dep;
  $amt = abs($amount);

  $corracct = descriptionToAccount($lin->{'Description'},$amount);


  if ($withdr > 0)
  {
    $debitacc=$corracct;
    $creditacc=1060;
    $acctsrc="source_1";
    $acctmemo="memo_1";
  }
  else
  {
    $debitacc=1060;
    $creditacc=$corracct;
    $acctsrc="source_2";
    $acctmemo="memo_2";
  };

   if ($memo)
  {
  printf $fOut "./gl.pl 'action=post&login=vleo&password=tmxsybs&path=bin/mozilla&transdate=%s&description=%s&accno_1=%s&debit_1=%s&accno_2=%s&credit_2=%s&rowcount=2&%s=%s&%s=%s'\n",
         sqesc(uri_escape($date)),
         sqesc(uri_escape($descr)),
         $debitacc,
         $amt,
         $creditacc,
         $amt,
         $acctsrc,sqesc(uri_escape('PSBREPORT')),
         $acctmemo,sqesc(uri_escape($memo));
  }
  else
  {
  printf $fOut "./gl.pl 'action=post&login=vleo&password=tmxsybs&path=bin/mozilla&transdate=%s&description=%s&accno_1=%s&debit_1=%s&accno_2=%s&credit_2=%s&rowcount=2&%s=%s'\n",
         sqesc(uri_escape($date)),
         sqesc(uri_escape($descr)),
         $debitacc,
         $amt,
         $creditacc,
         $amt,
         $acctsrc,sqesc(uri_escape('PSBREPORT'));
  }


  printf STDERR "%8s %9.2f %9.2f %8s %10s %s\n",$memo,$dep,$withdr,$corracct,$date,$descr if $opt_v;
}

printf STDERR "Deposits= %9.2f Withdrawals= %9.2f\n",$depTot,$withdrTot if $opt_v; 
