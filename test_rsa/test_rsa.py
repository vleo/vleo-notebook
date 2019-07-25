from random import randint
from math import sqrt

def lcm0(x,y):
  """This function takes two
  integers and returns the L.C.M."""
  return (x*y)/gcd(x,y)

def lcm(x, y):
  """This function takes two
  integers and returns the L.C.M."""

  greater = x if x > y else y

  while(True):
    if((greater % x == 0) and (greater % y == 0)):
      lcm = greater
      break
    greater += 1

  return lcm


def gcd(a, b):
    """Calculate the Greatest Common Divisor of a and b.

    Unless b==0, the result will have the same sign as b (so that when
    b is divided by it, the result comes out positive).
    """
    while b:
        a, b = b, a%b
    return a

def extended_gcd(a,b):

    s, t, r = 0, 1, b

    s0, t0, r0 = 1, 0, a

    while r != 0:
        q = r0 // r
        r0, r = r, r0 - q*r
        s0, s = s, s0 - q*s
        t0, t = t, t0 - q*t

# s0*a + t0*b == gcd(a, b) == r0
    return (s0, t0, r0)

def mmi(a,b):
    x, y, gcd = extended_gcd(a,b)
    if gcd != 1:
        raise Exception('modular inverse does not exist')
    return x % b

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('modular inverse does not exist')
    else:
        return x % m


def lambda_n(p,q):
  return lcm(p-1,q-1)

def isComposite(a, d, n, s):
    if pow(a, d, n) == 1:
        return False
    else:
        for i in range(s):
            if pow(a, 2**i*d, n) == n - 1:
                return False
    return True

def isProbablePrime(n, nt = 8):
    """
    Miller-Rabin primality test.
    """
    s = 0
    d = n - 1
    while d % 2 == 0:
        d >>= 1
        s += 1
    assert(2**s*d == n-1)

    for i in range(nt):
        a = randint(2,n)
        if isComposite(a, d, n, s):
            return False
    return True

def randomPrime(bits):
  min = int(sqrt(2)*2**20)*2**(bits-1) >> 20
  max = 2**bits - 1
#  print(f"min= {min}, max={max}")
  while True:
      p = randint(min,max)
      if isProbablePrime(p,256):
          return p

#########################################################

#1
p, q = 61, 53

#2
n = p*q

#3
l = lambda_n(p,q)

#4
e = 17

assert(1 < e < l)
assert(gcd(e,l) == 1)

#5
d = mmi(e,l)

#6
publicKey = (n, e)
privateKey = (n, d)

#7
# message
m = 65

#8
# crypted message
c = m**e % n

#9
# message decrypted
md = c**d % n

#########################################################

def genKeys(bits):
    p, q = randomPrime(bits), randomPrime(bits)
    n = p*q
    l = lambda_n(p,q)
    print(f"l= {l}")

    while True:
        e = randint(1,l)
        if gcd(e,l) == 1:
            break
    publicKey = (n, e)
    privateKey = (n, d)
    return (publicKey, privateKey)


