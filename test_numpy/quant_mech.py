# hydrogen atom orbitals approx. radiuses
# for electron n-quantum state number

from math import pi as Pi
import math

# in SGS meas. system
def r_SGS(n):
  h = 6.6E-27
  me = 9.02E-28
  qe = 4.8E-10
  r = ( n**2 * h**2 ) / (4*Pi**2 * me * qe**2)
  return r

# in SI meas. system
def r_SI(n):
  hp = 1.05E-34
  me = 9.11E-31
  qe = 1.6E-19
  #ke = 8.99E9
  c = 2.99792E8
  ke = c**2*1E-7
  r = ( n**2 * hp**2 ) / (ke * me * qe**2)
  return r

