#!/usr/bin/perl
use Getopt::Std;
use URI::Escape;

sub sqesc
{
  my ($s) = @_;

  $s =~ s/'/'\\''/g;

  return $s;
}

getopts("i:o:vY:m:Cf:hH");

if ($opt_H)
{
print <<EOT;
Input, CSV with ":" separator file format:

FIELD0:
if <number> then transaction is a check
if "Wire" then it is a wire transaction
else it is electronic deposit/withdrawl

FIELD1:
First line - Checking account information:
<account name> <account number>
(optionally Fields2-6 contain: DATE, AMOUNT,  WITHDR., DEPOSIT, CORRESP. ACCOUNT NUMBER)

Other lines - Transaction description
Empty line - end of data

Field2:
Date, format depends on option -f value:
0 - default: <yyyy> <mm> <dd>
    4 digit year, 2 digit month, 2 digit day, optionally space separated
1 - <day>-<Month>
    3 letter <Month> names as follows: Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec
    example: 14-Oct
2 - <month>-<day>
    example: 12-31

Field3:
Amount, as a signed number, negative with withdrawls from 1060

Field4:
Withdrawl (as positive number)

Field5:
Deposit (as positive number)

Field6:
Corresponding account nubmer (to account number in First Line of this CSV file)

EOT
  exit;
}

if ($opt_h or ($opt_f and $opt_Y < 2009))
{
print <<EOT;
Generate SQLedger .pl service scripts invokations shell script
Usage: $0 <options>
Options:
    -i <input file>
    -o <output file>
    -v                Print text report on STDERR
    -Y <year>         Set the 4digit year to generate transactions for
    -m <month>        do for just one month
    -f <number>       Format for date, see in Field2  description
    -C                Checks only
    -h                this help
    -H                Input CSV file format description
EOT
exit
}


#$opt_Y=2009 unless defined($opt_Y);


%mname2num = (
Jan => 1,
Feb => 2,
Mar => 3,
Apr => 4,
May => 5,
Jun => 6,
Jul => 7,
Aug => 8,
Sep => 9,
Oct => 10,
Nov => 11,
Dec => 12
);

if($opt_i)
{
  open STDIN,"<$opt_i" or die;
}

if($opt_o)
{
  open STDOUT,">$opt_o" or die;
}

while(<>)
{
  chomp;
  @lin = split(m/:/);
  next if $lin[1] eq '"PSB ACCOUNT 1060"';
  last if $lin[1] eq '';


  if(not $opt_f )
  {
     ($year,$month,$day) = $lin[2] =~ m/^(\d+)\s?(\d+)\s?(\d+)$/;
     $mnum = $month;
  }
  elsif ($opt_f == 1)
  {
    ($day,$month) = $lin[2] =~ m/^(\d+)-(\w+)$/;
    $mnum = $mname2num{$month};
  }
  elsif ($opt_r == 2)
  {
    ($month,$day) = $lin[2] =~ m/^(\d+)-(\d+)$/;
    $mnum = $month;
  }
  else
  {
     die;
  }


  next if $opt_m and $opt_m != $mnum;

  $memo = $lin[0];
  next if $opt_C and ($memo eq "" or $memo =~ m/Wire/);

  if(not $opt_f)
  {
    $date = sprintf("%04d-%02d-%02d",$year,$mnum,$day);
  }
  else
  {
    $date = sprintf("%04d-%02d-%02d",$opt_Y,$mnum,$day);
  }

  $withdr = $lin[4];
  $withdrTot += $withdr;

  $dep    = $lin[5];
  $depTot    += $dep;

  $corracct = $lin[6];
  $descr = $lin[1];


  die "withdr and dep both defined: $_" if $withdr != 0 and $dep != 0;
  $amt = $withdr > 0 ? $withdr : $dep;

  $corracct = $withdr > 0 ? 9999 : 9998 if $corracct eq '""';

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

  $descr =~ s/^\s*//;
  $descr =~ s/^"//g;
  $descr =~ s/"$//g;

  $memo =~ s/^\s*//;
  $memo =~ s/^"//g;
  $memo =~ s/"$//g;



  if ($memo)
  {
  printf "./gl.pl 'action=post&login=vleo&password=tmxsybs&path=bin/mozilla&transdate=%s&description=%s&accno_1=%s&debit_1=%s&accno_2=%s&credit_2=%s&rowcount=2&%s=%s&%s=%s'\n",
         sqesc(uri_escape($date)),
         sqesc(uri_escape($descr)),
         $debitacc,
         $amt,
         $creditacc,
         $amt,
         $acctsrc,sqesc(uri_escape(PSBREPORT)),
         $acctmemo,sqesc(uri_escape($memo));
  }
  else
  {
  printf "./gl.pl 'action=post&login=vleo&password=tmxsybs&path=bin/mozilla&transdate=%s&description=%s&accno_1=%s&debit_1=%s&accno_2=%s&credit_2=%s&rowcount=2&%s=%s'\n",
         sqesc(uri_escape($date)),
         sqesc(uri_escape($descr)),
         $debitacc,
         $amt,
         $creditacc,
         $amt,
         $acctsrc,sqesc(uri_escape(PSBREPORT));
  }


  printf STDERR "%8s %9.2f %9.2f %8s %10s %s\n",$memo,$dep,$withdr,$corracct,$date,$descr if $opt_v;
}

printf STDERR "Deposits= %9.2f Withdrawals= %9.2f\n",$depTot,$withdrTot if $opt_v;
