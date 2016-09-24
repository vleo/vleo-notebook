from time import sleep
from sys import stdout
from PyQt4 import QtCore
from PyQt4 import QtGui
import threading

def processing(psignal):
    sleep(1)
    psignal.emit(('hello',))
    sleep(1)
    psignal.emit(('world',))

def psignal_cb(data):
  print(data)


###### QT ##############################
app = QtGui.QApplication(['testapp'])

def cleanUp_cb():
  print('QT app cleanup')

app.aboutToQuit.connect(cleanUp_cb)

class MyWidget(QtGui.QWidget):

  def btn_clicked_cb(self,state):
    print('btn clicked:',state)
    processing_thr.start()

  def qbtn_clicked_cb(self,state):
    print('quit clicked:',state)
    app.quit()

  my_signal = QtCore.pyqtSignal(tuple)
  def __init__(self):
    super(MyWidget,self).__init__()
    l = QtGui.QGridLayout()
    self.setLayout(l)

    btn = QtGui.QPushButton('Test')
    btn.clicked.connect(self.btn_clicked_cb)

    qbtn = QtGui.QPushButton('Quit')
    qbtn.clicked.connect(self.qbtn_clicked_cb)

    l.addWidget(btn)
    l.addWidget(qbtn)

    self.my_signal.connect(psignal_cb)

wgt = MyWidget()
wgt.show()

############## TASKS ########################

processing_thr = threading.Thread(target=processing, args=(wgt.my_signal,))

app.exec_()

