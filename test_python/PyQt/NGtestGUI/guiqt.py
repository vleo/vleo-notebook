import sys
# noinspection PyUnresolvedReferences
from PyQt4.QtCore import QTimer
from PyQt4.QtGui import QApplication, QWidget, QLabel, QRadioButton, QButtonGroup, QVBoxLayout, QHBoxLayout

from multiprocessing import Queue as mpQueue_f

import functools as ft

#    super(MyQueue, self).__init__()
class MyQueue:
  def __init__(self):
    self.queue_ = mpQueue_f()

idle_loop = MyQueue()


# noinspection PyPep8Naming
class MCUSelectGui(QWidget):

  allMCUs=range(0xc0,0xca)

  def onActivated(self, mcu, text):
    self.selectedMCU = mcu
    print('mcuId:', self.selectedMCU)
    self.app.quit()

  def setActiveMCUs(self, mcuList):
    self.mcu_l = mcuList
    print(mcuList)
    for mcu in mcuList:
      self.rb_d[mcu].setEnabled(True)

  # noinspection PyUnresolvedReferences
  def buildGui(self):

    self.setWindowTitle("MCU selection")
    self.lbl.setText("Выбрать контроллер")
    self.setLayout(self.hl)
    self.hl.addLayout(self.vl)
    self.hl.addWidget(self.lbl)
    for mcu in self.allMCUs:
      self.bg.addButton(self.rb_d[mcu])
      self.vl.addWidget(self.rb_d[mcu])
      self.rb_d[mcu].setEnabled(False)
      self.rb_d[mcu].clicked.connect(ft.partial(self.onActivated,mcu))

    self.resize(200, 0)
    self.show()

  def __init__(self,app):
    super(MCUSelectGui, self).__init__()
    self.app = app
    self.mcu_l = []
    self.selectedMCU = None

    self.lbl = QLabel()
    self.rb_d = {}
    self.vl = QVBoxLayout()
    self.hl = QHBoxLayout()
    self.bg = QButtonGroup(self)

    print(type(self.bg).__bases__)

    for mcu in self.allMCUs:
      self.rb_d[mcu]=QRadioButton("0x{:02x}".format(mcu))

    self.buildGui()

  def cleanUp(self):
    print('cleanUp mcuId:', self.selectedMCU)


def main():

    app_g = QApplication([])
#    app_g.setStyle("fusion")

    gui=MCUSelectGui(app_g)

    app_g.aboutToQuit.connect(gui.cleanUp)

#    sAM = ft.partial(gui.setActiveMCUs,[0xc1,0xc9])
    gui.setActiveMCUs([0xc1,0xc9])

#    QTimer.singleShot(1000,sAM)

#    QTimer.singleShot(5000,app_g.quit)

    app_g.exec_()

    print('return mcuId:', gui.selectedMCU)



if __name__ == '__main__':
    main()


