import time
import sys
import PyQt4
from PyQt4.QtCore import (QObject, QThread, QCoreApplication)

SIG = PyQt4.QtCore.SIGNAL

tracePrints=[]
sigTest=SIG("t()")
sigQuit=SIG("q()")

class MyQThread(QThread):

  def __init__(self):
    QThread.__init__(self)

  def run(self):
    print("Enter thread")
    tracePrints.append(1)
    self.emit(sigTest)
    app.processEvents()
    print("Leave thread")
    tracePrints.append(2)
    self.emit(sigQuit)


class TestSigSlot(QObject):

  def __init__(self,app):
    QObject.__init__(self)
    self._thread = MyQThread()
    self.connect(self._thread, sigTest, self.Called)
    self.connect(self._thread, sigQuit, app.quit)
    self._thread.start()

  def Called(self):
    print("Called !")
    tracePrints.append(3)


if __name__ == "__main__":
  print('before QApp create')
  app = QCoreApplication(sys.argv)
  print('before Thread create')
  obj = TestSigSlot(app)
  print('after thread create')
  app.exec_()
  print("After exec_:",tracePrints)
