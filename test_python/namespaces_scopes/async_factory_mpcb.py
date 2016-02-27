from multiprocessing import Pool
from time import sleep
from random import randint
import os


class AsyncFactory:
    def __init__(self, func, cb_func):
        self.func = func
        self.cb_func = cb_func
        self.pool = Pool()

    def call(self,*args, **kwargs):
        self.pool.apply_async(self.func, args, kwargs, self.cb_func)

    def wait(self):
        self.pool.close()
        self.pool.join()



def square(x):
    sleep_duration = randint(1,5)
    print("PID: %d \t Value: %d \t Sleep: %d" % (os.getpid(), x ,sleep_duration))
    sleep(sleep_duration)
    return x*x

def cb_func(x):
    print("CB PID: {} \t Value: {}".format(os.getpid(), x))

print("MAIN PID: {}".format(os.getpid()))
async_square = AsyncFactory(square, cb_func)

async_square.call(1)
async_square.call(2)
async_square.call(3)
async_square.call(4)
async_square.call(5)

async_square.wait()