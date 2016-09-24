import functools as ft


from PyQt4.QtCore import QTimer
from PyQt4.QtGui import QApplication, QWidget, QLabel, QRadioButton, QButtonGroup, QVBoxLayout, QHBoxLayout, QCheckBox, QPushButton

class GuiQt(QWidget):

  def onRadioButton(self, t, i):
    self.ss = i
    print('signal {} #{} isdown:{} text:{}'.format(t, i, self.rb[i].isDown(), self.rb[i].text()))

  def onCheck(self, t):
    print('check {} checkState:{} isTristate:{}'.format(t, self.cb.checkState(), self.cb.isTristate()))

  def onQuit(self,t):
    print(t)
    self.app.quit()

  def buildGui(self):

    self.setWindowTitle("MainWindow")
    self.lbl.setText("TestGui")

    self.setLayout(self.hl)

    self.hl.addWidget(self.lbl)
    self.hl.addLayout(self.vl)

    for i in range(3):
      self.rbg.addButton(self.rb[i])
      self.vl.addWidget(self.rb[i])
      self.rb[i].setEnabled(False)
#      self.rb[i].pressed.connect(ft.partial(self.onSignal, 'pressed', i))
#      self.rb[i].released.connect(ft.partial(self.onSignal, 'released', i))
#      self.rb[i].clicked.connect(ft.partial(self.onSignal, 'clicked', i))
      self.rb[i].toggled.connect(ft.partial(self.onRadioButton, 'toggled', i))

    self.hl.addWidget(self.cb)

    self.cb.setText('N')
#    self.cb.pressed.connect(ft.partial(self.onCheck, 'pressed'))
#    self.cb.released.connect(ft.partial(self.onCheck, 'released'))
    self.cb.clicked.connect(ft.partial(self.onCheck, 'clicked'))
    self.cb.toggled.connect(ft.partial(self.onCheck, 'toggled'))

    self.hl.addWidget(self.qb)
    self.qb.setText("Quit")
    self.qb.clicked.connect(ft.partial(self.onQuit,'clicked'))

    self.ss = None
    self.resize(200, 0)
    self.show()

  def __init__(self,app):
    super(GuiQt, self).__init__()
    self.app = app

    self.vl = QVBoxLayout()
    self.hl = QHBoxLayout()

    self.lbl = QLabel()
    self.rb = {}
    self.cb = QCheckBox()
    self.qb = QPushButton()

    self.rbg = QButtonGroup(self)
    for i in range(3):
      self.rb[i]=QRadioButton("0x{:02x}".format(i))

    self.buildGui()

  def cleanUp(self):
    print('cleanUp:', self.ss)


def main():

    app_g = QApplication([])
#    app_g.setStyle("fusion")

    gui_g=GuiQt(app_g)

    app_g.aboutToQuit.connect(gui_g.cleanUp)

    gui_g.rb[1].setEnabled(True)
    gui_g.rb[2].setEnabled(True)
    gui_g.cb.setTristate(True)

#    sAM = ft.partial(gui_g.setActiveMCUs,[0xc1,0xc9])

#    QTimer.singleShot(1000,sAM)

#    QTimer.singleShot(5000,app_g.quit)

    app_g.exec_()

    print('Selected:', gui_g.ss)

if __name__ == '__main__':
    main()

