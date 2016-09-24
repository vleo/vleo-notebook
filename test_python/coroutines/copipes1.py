import time

def coroutine(func):
    def start(*args,**kwargs):
        cr = func(*args,**kwargs)
        next(cr)
        return cr
    return start

@coroutine
def sqrv(target):
  while True:
    v = yield
    v = v*v
    target.send(v)


@coroutine
def prn():
  while True:
    v = yield
    print("v=",v)

def datasrc(target):
  v = 0
  while True:
   target.send(v)
   v += 1
   time.sleep(1)

if __name__ == '__main__':
  datasrc(sqrv(prn()))

