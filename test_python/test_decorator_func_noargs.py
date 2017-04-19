class C:
  def __init__(self,retry):
    self.retry = retry

  def retry(func):
    def wrap(self,*args):
      print('before calling', func.__name__)
      func(self, *args)
      print('after calling', func.__name__)
    return wrap

  @retry
  def work(self,x):
    print(self.retry,x)

  @retry
  def work2(self,x,y):
    print(self.retry,x,y)


