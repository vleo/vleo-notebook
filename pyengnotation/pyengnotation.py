#!/usr/bin/python3

siPrefixNames = { -5:"f", -4:"p", -3:"n", -2:"u", 0:"", -1:"m", 1:"K", 2:"M", 3:"G", 4:"T", 5:"P" }


class EngNumber:
  def __init__(self,c=0.0,e=0.0):
    self.v=[c,e] # c - value, e - exponent in 1000^(e) (i.e. 1 means 10^3 or Kilo)
  def __add__(self,v):
    return EngNumber(self.v[0]+v.v[0],self.v[1]+v.v[1])
  def __repr__(self):
    return "[{}, {}]".format(self.v[0],self.v[1])
  def __str__(self):
    return "{} {}".format(self.v[0],siPrefixNames[self.v[1]])

a=EngNumber(1,1)
b=EngNumber(2,2)

print("__repr_:", repr(a))
print("__str__:",a)

print(repr(a),repr(b),repr(a+b))
