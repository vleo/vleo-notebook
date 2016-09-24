from random import uniform as rndmu
from math import sqrt, cos, sin, pi as Pi
import numpy as np

class Spin():
  x = None
  y = None
  z = None

  def __repr__(self):
    return "({},{},{})".format(self.x,self.y,self.z)

  def __matmul__(self, other): # vector multiplication
    assert isinstance(other,Spin)
    x = self.y*other.z - self.z*other.y
    y = self.z*other.x - self.x*other.z
    z = self.x*other.y - self.y*other.x
    return Spin(x,y,z);

  def __mul__(self, other):  # scalar multiplicatin
    assert isinstance(other,Spin)
    return self.x*other.x+self.y*other.y+self.z*other.z

  def __neg__(self):
    return Spin(-self.x,-self.y,-self.z)

  def __pos__(self):
    return Spin(self.x,self.y,self.z)

  def __pow__(self,other):
    assert other==2, "Can power only to 2"
    return self * self

  def set(self,other):
    self.x = other.x
    self.y = other.y
    self.z = other.z

  def __or__(self,other): # measure spin on direction other, represented by spin
    p = self * other # scalar product
    r = rndmu(-1,1)
    if r < p:
     v = 1
     self.set(other)
    else:
     v = -1
     self.set(-other)
    return v

  def setRandDir(self):
    while True:
      x1 = rndmu(-1,1)
      x2 = rndmu(-1,1)
      x3 = x1**2 + x2**2
      if x3 < 1:
        break
    x4 = sqrt(1-x3)
    self.x = 2*x1*x4
    self.y = 2*x2*x4
    self.z = 1 - 2*x3

  def __init__(self, x=None, y=None, z=None):
    if x is not None and y is not None and z is not None:
      self.x = x
      self.y = y
      self.z = z
    elif isinstance(x,Spin):
      self.x = x.x
      self.y = x.y
      self.z = x.z
    else:
      self.setRandDir()

sx = Spin(1,0,0)

sy = Spin(0,1,0)

sz = Spin(0,0,1)

def runEPR(n,phi):
  s1a = np.array([])
  s2a = np.array([])
  s12a = np.array([])

  m1 = Spin(0,0,1)
  #m2 = Spin(sqrt(2)/2,0,sqrt(2)/2)
  #m2 = Spin(1,0,0)
  m2 = Spin(cos(phi),0,sin(phi))

  for i in range(n):
    s1 = Spin()
    s2 = + s1

    o1=s1 | m1
    o2=s2 | m2

    s1a=np.append(s1a,o1)
    s2a=np.append(s2a,o2)
    s12a=np.append(s12a,o1*o2)

  #print(s1a,s2a,s12a)

  #return np.average(s1a), np.average(s2a),np.average(s12a)
  print("{:0.3f} {:0.3f} {:0.3f}".format(np.average(s1a), np.average(s2a),np.average(s12a)))

def testCoss1s2(n,phi):
  m2 = Spin(cos(phi),0,sin(phi))

  s=0
  for i in range(n):
    m1 = Spin(sx)
    s += m1 | m2

  #return s / n
  print("{:0.3f} {:0.3f}".format(s/n, cos(phi)))


