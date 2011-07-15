#!/usr/bin/perl
use lib "$ENV{HOME}/bin";
use strict; 
use feature qw(say);
=pod
use Getopt::Std;

getopts("i:h");
our $opt_i;
our $opt_h;

if($opt_h or not $opt_i)
{
print <<EOT;
Usage: $0 <options>
 -i <input file name>
 -h   print this help info
    
EOT
exit(0);
}
=cut

my $a;
my $b=2;

say $a // $b;
say $b;
