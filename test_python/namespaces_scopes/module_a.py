import sys
a = 1

def show_frame(num, frame):
  print(frame)
  print("  frame     = sys._getframe({:d})".format(num))
  print("  function  = {:s}()".format(frame.f_code.co_name))
  print("  file/line = {:s}:{:d}".format(frame.f_code.co_filename, frame.f_lineno))

class C:
  x = 321
  y = 444
  def __init__(self):
      def f(self):
        return self.x
      self.x = 123
      print(f(self))