#!/usr/bin/perl

use strict;
use constant MATCH_CSV => qr{,(?=(?:[^"]*"[^"]*")*(?![^"]*"))};
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
 chomp $$sr;
 $$sr =~ s/^"//;
 $$sr =~ s/"$//;
}

sub unQuoteStar(\$)
{
 my $sr = shift;
 unQuote($$sr);
 $$sr =~ s/\*//g;
 $$sr =~ s/^\s+//;
 $$sr =~ s/\s+$//;
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
#print "line<",join(":",@lin),">\n";
      last if $lin[0];
    }
  }
  return -1 unless $_;
  die "readDate can't match dateName=$dateName in $_" unless $lin[0] =~ m/$dateName/;
  unQuote($lin[1]);
  ($retDate_ref->{'month'}, $retDate_ref->{'day'}, $retDate_ref->{'year'}) = split(m/-/,$lin[1]);
  return 1;
}

sub readUnquote($)
{
  my($v) = @_;
  $v =~ s/^"([^"]*)"$/$1/g;
  return $v;
}

sub readAmount($)
{
  my($v) = @_;
  die "readAmout missing argument" unless $v;
  $v =~ s/^"([^"]*)"$/$1/g;
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
  my $s;
  my $v;
  die unless $fieldName;
  while(<>)
  {
    @lin = split(MATCH_CSV);
#print "line<",join(":",@lin),">\n";
    next unless $lin[1];
    die "expected fieldName: $fieldName not found in $_" unless $lin[1] =~ m/$fieldName/;
    #die "unexpected value in field2=$lin[2]: $_" if $lin[2];
    #$lin[3] =~ s/,//g;
    #die $_ unless $lin[3] =~ m/(\d+)\.(\d+)/;
    #$v= scalar($1 . "." . $2);
    $v = readAmount($lin[2]);
    $s = readUnquote($lin[0]);
    last;
  }
  return ($s,$v);
}

sub readChecks(\@$\$)
{
  my($accountTransactions_ref,$year,$amountWithdrawalsTrans_ref)=@_;
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
    die "Expecting \"Number\",,\"Date\",\"Amount\",, got <$lin[0]:$lin[2]:$lin[3]>" unless $lin[0] eq 'Number' && $lin[2] eq 'Date' and $lin[3] eq 'Amount';
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
    $$amountWithdrawalsTrans_ref += $amount;
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

sub reShuffle(\@)
{
   my $lin_ref = $_[0];
   my @tmp = @{$lin_ref};
   $$lin_ref[0] = $tmp[3]; 
   $$lin_ref[1] = $tmp[2]; 
   $$lin_ref[2] = $tmp[0]; 
   $$lin_ref[3] = $tmp[1]; 
}

sub readTransactions(\@$$\$\$)
{
  my($accountTransactions_ref,$year,$headlineRead,
     $amountDepositsTrans_ref, $amountWithdrawalsTrans_ref)=@_;
  my $reshuffle;
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

  unQuoteStar($lin[0]);
  unQuoteStar($lin[1]);
  unQuoteStar($lin[2]);
  unQuoteStar($lin[3]);
  if(
      $lin[0] eq '' && 
      $lin[1] eq "Other Account Transactions" && 
      $lin[2] eq 'Date' && 
      $lin[3] eq 'Amount')
  {
   #do nothing 
   $reshuffle=0;
  }
  elsif ( 
      $lin[3] eq '' && 
      $lin[2] eq "Other Account Transactions" && 
      $lin[0] eq 'Date' && 
      $lin[1] eq 'Amount')
  {
   #move around
   reShuffle(@lin);
   $reshuffle=1;
   #print "reshuffled order\n";
  }
  else
  { 
    #print join(":",@lin),"\n"; 
    return -1 
  }

  while(<>)
  {
    chomp;
    @lin = split(MATCH_CSV);
    unQuote($lin[0]);
    unQuote($lin[1]);
    unQuote($lin[2]);
    unQuote($lin[3]);
    last if ! $lin[0] && ! $lin[1] && ! $lin[2] && ! $lin[3];
    if($reshuffle)
    {
     next if ! $lin[1] && ! $lin[2] && $lin[3];
     reShuffle(@lin);
    }
    else
    {
      next if $lin[0] && ! $lin[1] && ! $lin[2] && ! $lin[3];
    }
#print "line<",join(":",@lin),">\n";
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
       $totalDepositsTrans+= $amount;
       $$amountDepositsTrans_ref+= $amount;
     }
     else
     {
       $totalWithdrawalsTrans+= -$amount;
       $$amountWithdrawalsTrans_ref+= -$amount;
     }
     $runningBalance += $amount;
  }
  return 1;
}

my %statementDate;
my %lastStatementDate;
my $balanceForward;
my $numberOfDepositsStmt;
my $amountDepositsStmt;
my $numberOfWithdrawalsStmt;
my $amountWithdrawalsStmt;
my $endingBalance;
my $amountDepositsTrans;
my $amountWithdrawalsTrans;

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
  die "expected value 783 or 084 not found in field0=$n783 in $_" 
    unless $n783 ==783 || $n783 ==84;

  if ($i ==1)
  {
    $runningBalanceBeg = $balanceForward;
    $runningBalance = $balanceForward;
  }

  ($numberOfDepositsStmt ,$amountDepositsStmt,)=readSummaryAmount("Deposits");

  ($numberOfWithdrawalsStmt,$amountWithdrawalsStmt)=readSummaryAmount("Withdrawals");
  printf "MDWS:%2d %8.2f:%8.2f\n",$statementDate{'month'},$amountDepositsStmt,$amountWithdrawalsStmt if $opt_S;
  $totalDeposits+=$amountDepositsStmt;
  $totalWithdrawals+=$amountWithdrawalsStmt;
  $amountDepositsTrans=0;
  $amountWithdrawalsTrans=0;

  my $dummy;
  ($dummy,$endingBalance)=readSummaryAmount("Ending Balance");

  $statusOK = readChecks(@accountTransactions,2000+$statementDate{'year'},
                         $amountWithdrawalsTrans);
  die unless $statusOK == 1;
  $statusOK = readChecks(@accountTransactions,2000+$statementDate{'year'},
                         $amountWithdrawalsTrans);

  if ($statusOK == -1)
  {
    # we may have only one check statement (maybe :-)
    die $lin[1] unless ($lin[1] =~ /Other Account Transactions/) ||
                       ($lin[1] =~ /Amount/);
    $statusOK = readTransactions(@accountTransactions,2000+$statementDate{'year'},1,
                                 $amountDepositsTrans, $amountWithdrawalsTrans);
  }
  else
  {
    $statusOK = readTransactions(@accountTransactions,2000+$statementDate{'year'},0,
                                 $amountDepositsTrans, $amountWithdrawalsTrans);
  }
  die unless $statusOK == 1; # we expect at least one account transactions block (really?)

  # 2nd page account transactions - optional
  $statusOK = readTransactions(@accountTransactions,2000+$statementDate{'year'},0,
                               $amountDepositsTrans, $amountWithdrawalsTrans);
  #printf "%d. statusOK=%d : $_", ++$i,$statusOK;
  printf "MDWT:   %8.2f:%8.2f\n",$amountDepositsTrans,$amountWithdrawalsTrans 
    if $opt_S && (sprintf("%8.2f",$amountDepositsStmt) ne sprintf("%8.2f",$amountDepositsTrans) || sprintf("%8.2f",$amountWithdrawalsStmt) ne sprintf("%8.2f",$amountWithdrawalsTrans) )

}
if ($opt_S)
{
  printf "YDWS:%8.2f:%8.2f\n",$totalDeposits,$totalWithdrawals;
  printf "YDWT:%8.2f:%8.2f\n",$totalDepositsTrans,$totalWithdrawalsTrans if
    sprintf("%8.2f",$totalDeposits) ne sprintf("%8.2f",$totalDepositsTrans) || sprintf("%8.2f",$totalWithdrawals) ne sprintf("%8.2f",$totalWithdrawalsTrans);
  printf "BALANCE BEG,ENDT,ENDS:%8.2f:%8.2f:%8.2f\n",$runningBalanceBeg,$runningBalance,$endingBalance;
}
else
{
print ":\"PSB ACCOUNT 1060\"::::\n";

for my $t (@accountTransactions) { print join(":",@$t),"\n"; }
}
