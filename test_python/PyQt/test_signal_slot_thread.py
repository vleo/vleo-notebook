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
    tracePrints.append(2)
    self.emit(sigQuit)
    print("Leave thread")


def callMe():
  print("Called !")
  tracePrints.append(3)


if __name__ == "__main__":
  print('before QApp create')
  app = QCoreApplication(sys.argv)
  print('before Thread create')
  thread = MyQThread()
  app.connect(thread, sigTest, callMe)
  app.connect(thread, sigQuit, app.quit)
  print('before Thread start')
  thread.start()
  print('begore App exec_')
  app.exec_()
  print("After exec_:",tracePrints)
