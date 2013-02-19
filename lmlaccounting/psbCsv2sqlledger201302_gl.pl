#!/usr/bin/perl

use strict;
use 5.010;
use feature 'say';
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
our $opt_a;
our $opt_v;
our $opt_h;
our $opt_H;


### HELP ####

if ($opt_h or (not defined($opt_i) or not defined($opt_o)) and not defined($opt_H) )
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
		-a <account>      default: 64084
    -v                Print text report on STDERR
    -h                this help
    -H                Input CSV file format description
EOT
exit
}

if ($opt_H)
{
print <<EOT;
1st row must have this headers for columns:
Date | Amount | Credit or Debit | Check Number | Description 
other rows have data for above
EOT
exit
}

### MAIN ###
open my $fOut, ">$opt_o" or die "$opt_o: $!";

my $csv = Text::CSV->new or die "Cannot use CSV: ".Text::CSV->error_diag ();

open my $fh, "<:encoding(utf8)", $opt_i or die "$opt_i: $!";

my $row = $csv->getline($fh);
my @row = $csv->fields();
my @colNms = ("Date","Amount","Credit or Debit","Check Number","Description");
die "1st Row Mismatch. Required:(",join(":",@colNms),") Got:(",join(":",@row),")" unless @row ~~ @colNms;

$csv->column_names($csv->fields());

my $bankAcct  = defined($opt_a)?$opt_a : 64084;
my $corracct;

my( $withdrTot, $depTot, $acctsrc, $acctmemo);

while ( my $lin = $csv->getline_hr($fh) ) {
	my($amount_in, $date_in, $credit_or_debit, $memo, $descr );

  #print join(':',%$lin)."\n";
  $date_in = $lin->{$colNms[0]}; # Date
  $amount_in = $lin->{$colNms[1]}; # Amount
	$credit_or_debit = $lin->{$colNms[2]};
  $memo = $lin->{$colNms[3]}; # Check Number
  $descr = $lin->{$colNms[4]}; # Description

  my($mnum,$day,$year) = split(/\//,$date_in);
  next if $opt_y and $opt_y != $year;
  next if $opt_m and $opt_m != $mnum;
  my $date=sprintf("%04d-%02d-%02d",$year,$mnum,$day);

	my $is_debit;
	if ($credit_or_debit eq "Debit")
	{
	  $is_debit = 1;
  	$withdrTot += $amount_in;
	}
  elsif ($credit_or_debit eq 'Credit')
	{
	  $is_debit = undef;
  	$depTot    += $amount_in;
	}
	else 
	{ 
	  die "Nor Debit, nor Credit???:",$_ 
	}

  my $amount = $is_debit ? -$amount_in : $amount_in;
  my $amt = abs($amount);

  $corracct = descriptionToAccount($lin->{'Description'},$amount);

	my($debitacc,$creditacc,$dep);
  if ($credit_or_debit eq "Debit")
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

  printf $fOut "gl.pl 'action=post&login=vleo&password=tmxsybs&path=bin/mozilla&transdate=%s&description=%s&accno_1=%s&debit_1=%.2f&accno_2=%s&credit_2=%.2f&rowcount=2&%s=%s".($memo ? "&%s=%s":"")."'\n",
         sqesc(uri_escape($date)),
         sqesc(uri_escape($descr)),
         $debitacc,
         $amt,
         $creditacc,
         $amt,
         $acctsrc,sqesc(uri_escape('PSBREPORT')),
         $acctmemo,sqesc(uri_escape($memo));

  printf STDERR "%8s %9.2f %8s %8s %10s %s\n",$memo,$amt,$debitacc,$corracct,$date,$descr if $opt_v;
}

printf STDERR "Deposits= %9.2f Withdrawals= %9.2f\n",$depTot,$withdrTot if $opt_v; 
