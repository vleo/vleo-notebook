#!/usr/bin/perl6
#use feature qw(say);
my $min = 1;
my $max = 1000;
# Create a max-sized array
my @primes = (1...$max);
# Initially assume all numbers are prime
my ($i,$j);
loop ($i = 0; $i < $max; $i++) {    
 @primes[$i] = 1;
}
# The sieve
loop ($i=2; $i*$i <= $max;$i+=1) {    
 if (@primes[$i]) {        
   loop ($j=$i; $j*$i < $max; $j+=1) {            
     @primes[$i * $j] = 0;        
   }    
 }
}
# Show the results
my @p = ();
loop ($i=$min; $i<=$max; $i++) {    
 if (@primes[$i]) {        
   push @p, $i;    
 }
}
my $size = @p.elems;
say "Found $size primes"; 
