#!/usr/bin/perl

use strict;
use constant MATCH_CSV => qr{:(?=(?:[^"]*"[^"]*")*(?![^"]*"))};
use descriptionToCorrAcct;
use Getopt::Std;
getopts("S");
our $opt_S;

my $runningBalance;
my $runningBalanceBeg;
my $totalDeposits;
my $totalDepositsTrans;
my $totalWithdrawals;
my $totalWithdrawalsTrans;

sub unQuote(\$)
{
 my $sr = shift;
 $$sr =~ s/^"//;
 $$sr =~ s/"$//;
}

my @lin;
sub readDate($\%$)
{
  my($dateName,$retDate_ref,$firstLineAlreadyRead)= @_;
  die "readDate - wrong sub arguments" unless defined($dateName) and defined($retDate_ref);
  unless($firstLineAlreadyRead)
  {
    while(<>)
    {
      @lin = split(MATCH_CSV);
      last if $lin[0];
    }
  }
  return -1 unless $_;
  die "readDate can't match dateName=$dateName in $_" unless $lin[0] =~ m/$dateName/;
  unQuote($lin[1]);
  ($retDate_ref->{'month'}, $retDate_ref->{'day'}, $retDate_ref->{'year'}) = split(m/-/,$lin[1]);
  return 1;
}

sub readAmount($)
{
  my($v) = @_;
  die "readAmout missing argument" unless $v;
  $v =~ s/,//g;
  $v =~ s/\s*//g;
  die "readAmount: incorrect amount format in $_" unless $v =~ m/(-)?(\d+)(\.(\d+))?(-)?/;
#  print "$v => $1:$2:$3:$4:$5";
  $v=scalar($2 . "." . $4);
  $v = -$v if $1 eq '-' or $5 eq '-';
#  print " ==> $v\n";
  return $v;
}

sub readSummaryAmount($)
{
  my($fieldName)= @_;
  my $v;
  die unless $fieldName;
  while(<>)
  {
    @lin = split(MATCH_CSV);
    next unless $lin[1];
    die "expected fieldName: $fieldName not found in $_" unless $lin[1] =~ m/$fieldName/;
    die "unexpected value in field2=$lin[2]: $_" if $lin[2];
    #$lin[3] =~ s/,//g;
    #die $_ unless $lin[3] =~ m/(\d+)\.(\d+)/;
    #$v= scalar($1 . "." . $2);
    $v = readAmount($lin[3]);
    last;
  }
  return ($lin[0],$v);
}

sub readChecks(\@$)
{
  my($accountTransactions_ref,$year)=@_;
  die unless defined($accountTransactions_ref);
  while(<>)
  {
    @lin = split(MATCH_CSV);
    next unless $lin[0];
#    die "Expecting CHECKS, got $_" unless $lin[0] =~ m/CHECKS/;
    last;
  }
  unless ($lin[0] =~ m/CHECKS/)
  {
    return -1;
  }
  while(<>)
  {
    @lin = split(MATCH_CSV);
    next unless $lin[0];
    unQuote($lin[0]);
    unQuote($lin[2]);
    unQuote($lin[3]);
    unQuote($lin[4]);
    die "Expecting \"Number\"::\"Date\":\"Amount\":: got $_" unless $lin[0] eq 'Number' && $lin[2] eq 'Date' and $lin[3] eq 'Amount';
    last;
  }
  while(<>)
  {
    @lin = split(MATCH_CSV);
    last unless $lin[2];
    unQuote($lin[0]);
    unQuote($lin[1]);
    unQuote($lin[2]);
    $lin[0] =~ s/\*$//;
    my($month,$day) = $lin[2] =~ m/(\d+)-(\d+)/;
    die unless defined($day) and defined($month);

    my $amount = readAmount($lin[3]);
    push @$accountTransactions_ref,
         [
           $lin[0],
           $lin[1],
           sprintf("%04d %02d %02d",$year,$month,$day),
           sprintf("%2.2f",-$amount),
           sprintf("%2.2f",$amount),
           "",
           descriptionToAccount($lin[1],-$amount)
         ];
    $totalWithdrawalsTrans += $amount;
    $runningBalance -= $amount;

  }
  return 1;
}

sub readTransactions(\@$$)
{
  my($accountTransactions_ref,$year,$headlineRead)=@_;
  die unless defined($accountTransactions_ref);

  unless ($headlineRead)
  {
    while(<>)
    {
      @lin = split(MATCH_CSV);
      next unless $lin[1];
      last;
    }
  }

  unQuote($lin[0]);
  unQuote($lin[1]);
  unQuote($lin[2]);
  unQuote($lin[3]);
  $lin[0] =~ s/\*//g;
  $lin[0] =~ s/^\s+//;
  $lin[0] =~ s/\s+$//;
  $lin[1] =~ s/\*//g;
  $lin[1] =~ s/^\s+//;
  $lin[1] =~ s/\s+$//;
  unless( $lin[0] eq '' && $lin[1] eq "Other Account Transactions" && $lin[2] eq 'Date' and $lin[3] eq 'Amount')
  {
    return -1;
  }

  while(<>)
  {
    @lin = split(MATCH_CSV);
    last unless $lin[3];
    unQuote($lin[0]);
    unQuote($lin[1]);
    unQuote($lin[2]);
    unQuote($lin[3]);
    my($month,$day) = $lin[2] =~ m/(\d+)-(\d+)/;
    unless(defined($day) and defined($month))
    {
      ($month,$day) = $lin[0] =~ m/^(\d\d)(\d\d)(\d\d)$/;
      die "Can't parse <day>-<month> in $_" unless(defined($day) and defined($month))
    }

    my $amount = readAmount($lin[3]);
    push @$accountTransactions_ref,
         [
           "",
           $lin[1],
           sprintf("%04d %02d %02d",$year,$month,$day),
           sprintf("%2.2f",$amount),
           $amount < 0.0 ? sprintf("%2.2f",-$amount) : "" ,
           $amount > 0.0 ? sprintf("%2.2f",$amount) : "",
           descriptionToAccount($lin[1],$amount)
         ];
     if ($amount > 0.0)
     {
       $totalDepositsTrans += $amount;
     }
     else
     {
       $totalWithdrawalsTrans += -$amount;
     }
     $runningBalance += $amount;
  }
  return 1;
}

my %statementDate;
my %lastStatementDate;
my $balanceForward;
my $numberOfDeposits;
my $amountDeposits;
my $numberOfWithdrawals;
my $amountWithdrawals;
my $endingBalance;

my @accountTransactions;
# [
#   empty or check_number or 'wire' ,
#   description,
#   date in "$year $month $day" (year %04d, month/day numbers, %02d format),
#   amount (signed) %+8.2f,
#   withdrawl >0,
#   deposit >0,
#   corresponding account number
# ]

my $statusOK = 1;
my $i;

while(1)
{
  $i++;

  if ($statusOK==1) # previous statement could be w/o 2nd account transactions block
  {
    # normal read
    $statusOK=readDate("Statement Date",%statementDate,0);
  }
  elsif ($statusOK<0)
  {
    # first line already read - skip skipping blank lines and reading non-blank line
    $statusOK=readDate("Statement Date",%statementDate,1);
  }
  last if $statusOK == -1;


  readDate("Date Last Statement",%lastStatementDate,0);

  my $n783;
  ($n783,$balanceForward,)=readSummaryAmount("Balance Forward");
  die "expected value 783 not found in field0=$n783 in $_" unless $n783 ==783;

  if ($i ==1)
  {
    $runningBalanceBeg = $balanceForward;
    $runningBalance = $balanceForward;
  }

  ($numberOfDeposits ,$amountDeposits,)=readSummaryAmount("Deposits");

  ($numberOfWithdrawals,$amountWithdrawals)=readSummaryAmount("Withdrawals");
  print "MDW:$amountDeposits:$amountWithdrawals\n" if $opt_S;
  $totalDeposits+=$amountDeposits;
  $totalWithdrawals+=$amountWithdrawals;

  my $dummy;
  ($dummy,$endingBalance)=readSummaryAmount("Ending Balance");

  $statusOK = readChecks(@accountTransactions,2000+$statementDate{'year'});
  die unless $statusOK == 1;
  $statusOK = readChecks(@accountTransactions,2000+$statementDate{'year'});

  if ($statusOK == -1)
  {
    # we may have only one check statement (maybe :-)
    die $lin[1] unless $lin[1] =~ /Other Account Transactions/;
    $statusOK = readTransactions(@accountTransactions,2000+$statementDate{'year'},1);
  }
  else
  {
    $statusOK = readTransactions(@accountTransactions,2000+$statementDate{'year'},0);
  }
  die unless $statusOK == 1; # we expect at least one account transactions block (really?)

  # 2nd page account transactions - optional
  $statusOK = readTransactions(@accountTransactions,2000+$statementDate{'year'},0);
  #printf "%d. statusOK=%d : $_", ++$i,$statusOK;

}
if ($opt_S)
{
  print "YDWS:$totalDeposits:$totalWithdrawals\n";
  print "YDWT:$totalDepositsTrans:$totalWithdrawalsTrans\n";
  print "B:$runningBalanceBeg:$runningBalance:$endingBalance\n";
}
else
{
print ":\"PSB ACCOUNT 1060\"::::\n";

for my $t (@accountTransactions) { print join(":",@$t),"\n"; }
}
