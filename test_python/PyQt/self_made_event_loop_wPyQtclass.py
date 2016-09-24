from time import sleep
from sys import stdout
from PyQt4 import QtCore
from PyQt4 import QtGui

import collections
cotaskQueue = collections.deque()

###### QT ##############################
app = QtGui.QApplication(['testapp'])

def cleanUp_cb():
  print('QT app cleanup')

def btn_clicked_cb(state):
  print('btn clicked:',state)

def qbtn_clicked_cb(state):
  print('quit clicked:',state)
  app.quit()

app.aboutToQuit.connect(cleanUp_cb)

wgt = QtGui.QWidget()
l = QtGui.QGridLayout()
wgt.setLayout(l)

btn = QtGui.QPushButton('Test')
btn.clicked.connect(btn_clicked_cb)

qbtn = QtGui.QPushButton('Quit')
qbtn.clicked.connect(qbtn_clicked_cb)

l.addWidget(btn)
l.addWidget(qbtn)

wgt.show()

qt_event_loop = QtCore.QEventLoop()

############## TASKS ########################

def processQtEvents():
  while True:
    yield
    if True not in (w.isVisible() for w in QtGui.QApplication.topLevelWidgets()):
      return
    app.sendPostedEvents()
    qt_event_loop.processEvents(QtCore.QEventLoop.AllEvents)

#### our event loop ####

cotaskQueue.append(processQtEvents())

while cotaskQueue:
  t = cotaskQueue.popleft()
  try:
    #print("next task {:0.3f} ".format(clock_gettime(CLOCK_REALTIME)),end='')
    print("{}".format(t.gi_frame.f_code.co_name)); stdout.flush()
    next(t)
    cotaskQueue.append(t)
    sleep(1)
  except StopIteration:
    pass
print("scheduler done...")


