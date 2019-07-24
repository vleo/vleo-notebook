#!/usr/bin/env python3
import rpyc
from rpyc.utils.server import ThreadedServer

import inspect
import sys

from PyQt5.QtCore import (QLineF, QPointF, QRectF, Qt, QCoreApplication)
from PyQt5.QtGui import (QBrush, QColor, QPainter, QImage, QPixmap, QKeyEvent, QMouseEvent, QWheelEvent)
from PyQt5.QtWidgets import (QApplication, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsItem,
                             QGridLayout, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton)

#import pystuck; pystuck.run_server()
from pprint import pprint
from inspect import getmembers

class QtService(rpyc.Service):
    def exposed_quit(self):
        QCoreApplication.instance().quit()

def show_members(e):
    v = inspect.getmembers(e)
    for t in v:
        print(t)


def show_em(em):
    print('NoModifier: ', em == Qt.NoModifier)
    print('ShiftModifier: ', em == Qt.ShiftModifier)
    print('ControlModifier: ', em == Qt.ControlModifier)


def show_bts(bts):
    print('NoButton: ', bts == Qt.NoButton)
    print('LeftButton: ', bts == Qt.LeftButton)
    print('ModButton: ', bts == Qt.MidButton)
    print('RightButton: ', bts == Qt.RightButton)


def show_pos(event):
    print('pos: ', event.pos())
    print('localPos: ', event.localPos())
    print('globalPos: ', event.globalPos())
    print('screenPos: ', event.screenPos())
    print('windowPos: ', event.windowPos())


def show_event(event):
    if event.type() == QMouseEvent.MouseButtonPress:
        print('MouseButtonPress')
    elif event.type() == QMouseEvent.MouseMove:
        print('MouseMove')
    elif event.type() == QWheelEvent.Wheel:
        print('Wheel')
    else:
        print('Event: ', event)
    # show_pos(event)
    # show_em(event.modifiers())
    # show_bts(event.buttons())


class Item1(QGraphicsItem):
    def __init__(self):
        super().__init__()

    def boundingRect(self):
        return QRectF(0, 0, 57, 87)

    def paint(self, painter, option, widget):
        # show_members(option)
        # show_members(widget)
        # print(widget.x(), widget.y(), widget.width(), widget.height())
        source = QRectF(0, 0, 57, 87)
        image = QPixmap('ant.png')
        target = QRectF(0, 0, 57, 87)
        painter.drawPixmap(target, image, source)


class MainWindow(QGraphicsView):
    def __init__(self):
        self.scene = QGraphicsScene()
        super().__init__(self.scene)
        self.scene.setSceneRect(0, 0, 640, 480)
        self.setWindowTitle('Graphic Scene')
        self.item1 = Item1()
        self.additem(self.item1)

    def additem(self, item):
        self.scene.addItem(item)

    def keyPressEvent(self, event):
        pprint(event)
        if event.key() == 81:
            QCoreApplication.instance().quit()


    def mousePressEvent(self, event):
        print(type(event))
        show_event(event)
        self.item1.setPos(event.pos())

    def mouseMoveEvent(self, event):
        show_event(event)
        self.item1.setPos(event.pos())

    def wheelEvent(self, event: QWheelEvent):
        show_event(event)


class AntService(rpyc.Service):
    def exposed_setpos(self,x,y):
        print("setpos ",x,y)



if __name__ == '__main__':

    server = ThreadedServer(QtService, port = 12345)
    server.start()

    app = QApplication(sys.argv)

    mainWindow = MainWindow()

    mainWindow.show()

    rc = app.exec_()
    del app
    sys.exit(rc)
