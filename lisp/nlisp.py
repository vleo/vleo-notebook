def cons (x,y):
  return lambda m : y if m else x

def car(p):
  return p(0)

def cdr(p):
  return p(1)

def zero():
  return lambda f : lambda x: x

def add1(n):
  return lambda f : lambda x : f(n(f)(x))
