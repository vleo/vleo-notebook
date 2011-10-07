#!/usr/bin/python

# Sieve by Baavgai
  
def eratosthenes(n):
       sieve = [ True for i in range(n+1) ]
       def markOff(pv):
               for i in range(pv+pv, n+1, pv):
                       sieve[i] = False
       markOff(2)
       for i in range(3, n+1):
               if sieve[i]:
                       markOff(i)
       return [ i for i in range(1, n+1) if sieve[i] ]


n=10000
primelist=eratosthenes(n)
print 'Number of Primes upto %d: %d'%(n,len(primelist))
