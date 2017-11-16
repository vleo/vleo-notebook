from collections import deque
import random

def blink():
  n=5
  while n:
   print("+++" if n%2==0 else "---")
   n -= 1
   yield


def getint(x):
  m = random.randrange(100)
  print(x,"m=",m)
  n=10
  while n:
    n -= 1;
    if n:
      yield
  res=str(m)+"/"+str(n)
  return res

def readnfo(x,n):
   while n>0:
     yield
     #print("readnfo loop")
     res = yield from getint(x)
     print(x,"res=",res)
     n -= 1

q = deque([blink(),readnfo('a',5),readnfo('b',5)])

while q:
  t = q.popleft()
  #print("sched")
  try:
    next(t)
    q.append(t)
  except StopIteration:
    pass
