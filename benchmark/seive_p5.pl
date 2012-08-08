#!/usr/bin/perl
use feature qw(say);
use strict;
my $min = 1;
my $max = 10000000;
# Create a max-sized array
my @primes = (1...$max);
# Initially assume all numbers are prime
my ($i,$j);
for ($i = 0; $i < $max; $i++) {    
 $primes[$i] = 1;
}
# The sieve
for ($i=2; $i*$i <= $max;$i+=1) {    
 if ($primes[$i]) {        
   for ($j=$i; $j*$i < $max; $j+=1) {            
     $primes[$i * $j] = 0;        
   }    
 }
}
# Show the results
my @p = ();
for ($i=$min; $i<=$max; $i++) {    
 if ($primes[$i]) {        
   push @p, $i;    
 }
}
my $size = scalar(@p);
say "Number of primes below: $max";
say "Found $size primes"; 
