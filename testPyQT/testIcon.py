#!/usr/bin/python3
import sys,random
from PyQt5.QtWidgets import QApplication, QWidget, QMainWindow, QLabel,QVBoxLayout
from PyQt5.QtGui import QIcon
from PyQt5.QtGui import QPainter, QColor, QFont, QBrush
from PyQt5.QtCore import Qt, QObject, pyqtSlot, pyqtSignal, QEvent
from time import sleep


class MyView(QMainWindow):
    aSignal = pyqtSignal()
    def __init__(self,model):
        super().__init__()
        self.aSignal.connect(model.slotHandler)
        self.initUI()

    def event(self,event):
        print('View event:',type(event),event.type(), event.spontaneous())
        return super().event(event)


    def initUI(self):


        self.setGeometry(300, 300, 1280, 720)
        self.setWindowTitle('Test Icon, Draw')
        self.setWindowIcon(QIcon('test_icon.png'))

        self.text = 'ABCDEFG'

        #self.vl = QVBoxLayout()
        self.label = QLabel("Mqyjp##^^__",parent=self)
        self.label.setStyleSheet('color: blue; border: 5px solid red; background-color: pink; padding: 0.2em; margin: 1em; max-width: 10em; max-height: 1em;')
        #self.layout().addWidget(self.label)

        self.show()
#    def showEvent(self,event):
#        print('Show event')
#    def moveEvent(self,event):
#        print('Move event')
#    def resizeEvent(self,event):
#        print('Resize event')

    def paintEvent(self, event):

        print('Paint event',event.spontaneous(),event.type(),event.rect())

        #self.aSignal.emit()

        qp = QPainter()
        qp.begin(self)
        self.drawText(event, qp)
        self.drawPoints(qp)
        self.drawRectangles(qp)

        qp.end()
        #sleep(5)

    def drawText(self, event, qp):

        qp.setPen(QColor(168, 34, 3))
        qp.setFont(QFont('Decorative', 10))
        qp.drawText(event.rect(), Qt.AlignCenter, self.text)

    def drawPoints(self, qp):

        qp.setPen(Qt.red)
        size = self.size()

        for i in range(1000):
            x = random.randint(1, size.width()-1)
            y = random.randint(1, size.height()-1)
            qp.drawPoint(x, y)

    def drawRectangles(self, qp):

        col = QColor(0, 0, 0)
        col.setNamedColor('#d4d4d4')
        qp.setPen(col)

        qp.setBrush(QColor(200, 0, 0))
        qp.drawRect(10, 55, 90, 60)

        qp.setBrush(QColor(255, 80, 0, 160))
        qp.drawRect(130, 55, 90, 60)

        qp.setBrush(QColor(25, 0, 90, 200))
        qp.drawRect(250, 55, 90, 60)

    @pyqtSlot()
    def slotHandler(self):
        print('View Slot signal received')

class MyModel(QObject):
    bSignal = pyqtSignal()
    def __init__(self):
        super().__init__()
    def event(self,event):
        print('Model event:',type(event))
        return super().event(event)
    @pyqtSlot()
    def slotHandler(self):
        print('Model Slot signal received')
        #self.bSignal.emit()

if __name__ == '__main__':
  app = QApplication(sys.argv)
  m = MyModel()
  v = MyView(m)
  m.bSignal.connect(v.slotHandler)
  sys.exit(app.exec_())
