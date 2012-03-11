package descriptionToCorrAcct;

use strict;

use Exporter;
our @ISA=qw(Exporter);
our @EXPORT=qw(descriptionToAccount);

my @match1060DebitToCorrAcctCode =
(
[
  1200,
  [
    qr/^INTL WIRE/,
    qr/^SG INTL WIRE/,
    qr/^WIRE INTL/,
    qr/^Wire/,
    qr/^WIRE TRANSFER/,
    qr/^WIRE/
  ] ],
[
  1210,
  [
    qr/^TRANSFIRST LLC VMC SETTLE/,
    qr/^TRANSFIRST LLC BKCD STLMT/,
    qr/^ACH TRANSFIRST LLC BKCD STLMT/,
    qr/^CCD TRANSFIRST LLC BKCD STLMT/,
    qr/^AMERICAN EXPRESS SETTLEMENT/,
    qr/^ACH AMERICAN EXPRESS SETTLEMENT/,
    qr/^DEPOSIT/
  ] ],

[
  5770,
  [
    qr/UPS/
  ] ],

[
  5780,
  [
    qr/^PPD PAYPAL VERIFYBANK/
  ] ],

[
  9998,
  [
    qr/^$/,
    qr/^Deposit$/,
    qr/^WIRE$/,
    qr/BORROWED/
  ] ]
);

my @match1060CreditToCorrAcctCode =
(
[
1210,
[
qr/^TRANSFIRST LLC VMC SETTLE/,
qr/^ACH TRANSFIRST LLC BKCD STLMT/,
qr/^CCD TRANSFIRST LLC BKCD STLMT/,
qr/^AMERICAN EXPRESS SETTLEMENT/,
qr/^ACH AMERICAN EXPRESS SETTLEMENT/
] ],

[
1520,
[
qr/LONRUN CHINA/,
qr/TT INTL HK TECH/,
qr/POTOMAC COMM TECH/,
qr/POTOMAC/,
qr/AVTECH/
] ],

[
1820,
[
qr/^ACME MICRO/,
qr/^ADDONICS TECHNOLOGIES/,
qr/^APCB COMPUTER/,
qr/^PROVANTAGE PROVANTAGE CORP/,
qr/^XYTRONIX RE XYTRONIX RESEARCH/,
] ],

[
5410,
[
qr/PAYCHECK/
] ],


[
5610,
[
qr/^TRANSFIRST LLC DISCOUNT/,
qr/^ACH TRANSFIRST LLC DISCOUNT/,
qr/^CCD TRANSFIRST LLC DISCOUNT/,
qr/^AMERICAN EXPRESS AXP DISCNT/,
qr/^AMERICAN EXPRESS COLLECTION/,
qr/^ACH AMERICAN EXPRESS AXP DISCNT/,
qr/^ACH AMERICAN EXPRESS COLLECTION/,
qr/^Maintenance Fee/,
qr/^MAINTENANCE FEE/,
qr/^Foreign ATM Fee/,
qr/^ANNUAL CHECKCARD FEE/,
qr/^Zions First National Bank/,
qr/^ZION/,
qr/^SERVICE CHARGES ASSESSED/,
qr/NSF Paid Item Fee/
] ],

[
5710,
[
qr/2CO\.COM/,
qr/BUY.COM/,
qr/NATIONAL CO NATIONAL CONTROL DEV/,
qr/AMAZON MKTPLACE/
] ],

[
5720,
[
qr/ARRAY SOLUTION/,
qr/TOTAL PHASE/,
qr/LMA INC/

] ],

[
5770,
[
qr/^USPS/,
qr/^POS USPS/,
qr/THE UPS STORE/,
qr/^300 W SOUTH AVE/,
qr/^113 9TH ST/,
qr/^PDQ MAIL & MORE/,
qr/^UPS/
] ],

[
5650,
[
qr/^GOOGLE/,
qr/^POS GOOGLE/,
qr/^Essen Trade Show/
] ],

[
5780,
[
qr/KALL8/,
qr/^QWEST/,
qr/^CIT INTERNET/,
qr/PAYPAL INST XFER/,
qr/SKYPE/

] ],

[
5790,
[
qr/^GEOTRUST/,
qr/^NETWORK SOLUTIONS/,
qr/NAMECHEAPINC/
] ],

[
5020,
[
qr/^AVERMEDIA TECHNOLOGIES/
] ],

[
5720,
[
qr/^PREMIER COMPONENTS/,
qr/^OEM PARTS/,
qr/^TRANSCEND INFORMATION/,
qr/^OPELCO/,
qr/Amazon\.com/,
qr/IDOTPC INTERNATIONAL/,
qr/BARNES.NOBLE/,
    # those can also be 5030
qr/ADEX ELECTRONICS/,
qr/^CIRCUIT EXPRESS/,
qr/DKC\*DIGI\s+KEY\s+CORP/,
qr/IRONWOOD ELECTRONICS/,
qr/MOUSER ELECTRONICS/,
qr/CONSOURCE/
] ],

[
5700,
[
qr/^OFFICE DEPOT/,
qr/BEST BUY/
] ],

[
5420,
[
qr/^RBA ATM/,
qr/^ATM 52/,
qr/^BANKOMAT/,
qr/^Alfa Acq/,
qr/^80\d\d/,
qr/^PAVELETSKAYA STATION/,
qr/^NUTRICENTRO INTERNATIO/,
qr/^ROS/,
qr/^SOYUZ/,
qr/CASH WITHDRAWAL BANKOMAT/,
qr/CASH WITHDRAWAL GEN TYULENEVA STR 4A/,
qr/CASH WITHDRAWAL GENERALA TULENEVA 4A/,
qr/CASH WITHDRAWAL MMB ATM/,
qr/CASH WITHDRAWAL TEPLYY STAN STATION/,
qr/CASH WITHDRAWAL BSGV SOCIETE GENERALE/,
qr/CASH WITHDRAWAL .*ATM/
] ],

[
5800,
[
qr/ESSENER/
] ],

[
5910,
[
qr/H&R BLOCK/,
qr/H.R BLOCK/,
qr/SECRETARY OF STATE/,
qr/COLORADO DEPT OF REVENUE SALES TAX/,
qr/DEPT OF REVENUE CO/
] ],

[
5999,
[
qr/900 TAMARAC PKWY/,
qr/LWN\.NET/
] ],

[
9999,
[
qr/^INTL WIRE AND FEE/
] ]

);


sub descriptionToAccount($$)
{
  my($desc,$amount) = @_;
  my $corrAcct=9999;

  #debit to bank acct
  #debits on banking acct 1060
  #find appropriate credit accts code to credit it
  # withdrawl
  # credit acct '1060'
  # find debit acct code to debit it
  my $acct_ref;
  my $matchExpr;
  for $acct_ref ($amount > 0 ? @match1060DebitToCorrAcctCode : @match1060CreditToCorrAcctCode )
  {
    for $matchExpr (@{$acct_ref->[1]})
    {
      return $acct_ref->[0] if $desc =~ $matchExpr;
    }
  }
  print "$desc\n";
  return $amount >0 ? 9998 : 9999;
}

1;
