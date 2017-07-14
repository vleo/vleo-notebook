#!/usr/bin/env python3

from PyQt5.QtCore import (QLineF, QPointF, QRectF, Qt)
from PyQt5.QtGui import (QBrush, QColor, QPainter, QImage, QPixmap)
from PyQt5.QtWidgets import (QApplication, QWidget, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsItem,
                             QGridLayout, QVBoxLayout, QHBoxLayout, QStackedLayout,
                             QLabel, QLineEdit, QPushButton)
import sys
import World
import Block

from random import randint

class GameGraphics(QGraphicsItem):
    def __init__(self, gameWorld):
        super(GameGraphics, self).__init__()
        self.gameWorld = gameWorld
        print("init gameGraphics")
        self.px = 0
        self.py = 0

    def reset(self):
        for y in range(3):
            for x in range(3):
                self.board[y][x] = -1
        self.turn = self.O
        self.update()

    def select(self, x, y):
        if x < 0 or y < 0 or x >= 3 or y >= 3:
            return
        if self.board[y][x] == -1:
            self.board[y][x] = self.turn
            self.turn = 1 - self.turn


    def paint(self, painter, option, widget):
        print('paint')
        source=QRectF(0, 0, 600, 600)
        image=QPixmap('test_image.png')
        for i in range(3):
          for j in range(3):
            target=QRectF(i*100, j*100, 100, 100)
            if self.px // 100 == i and self.py // 100 == j:
              painter.drawPixmap(target,image,source)


    def boundingRect(self):
        return QRectF(0,0,300,300)

    def mousePressEvent(self, event):
        pos = event.pos()
        self.px = int(pos.x())
        self.py = int(pos.y())
        print('mousePressEvent pos:', pos)
        #self.select(int(pos.x()/100), int(pos.y()/100))
        self.update()
        super(GameGraphics, self).mousePressEvent(event)

class MyView(QGraphicsView):
    def __init__(self, parent=None):
        QtGui.QGraphicsView.__init__(self, parent=parent)

        self.scene = QGraphicsScene(self)

        self.setScene(self.scene)

class simpleWindow(QMainWindow):
    def __init__(self,parent=None):
        super(simpleWindow,self).__init__(parent=parent)
        self.setWindowTitle("Colossal Cave Adventures")
        self.resize(300,300)

class MainGameWindow(QMainWindow):
    def __init__(self,parent=None):
        super(MainGameWindow, self).__init__(parent=parent)
        self.setWindowTitle("Colossal Cave Adventures")
        self.resize(300,300)
        self.setMaximumSize(500,500)

        self.view = QGraphicsView(self)
        self.view.setCacheMode(QGraphicsView.CacheBackground)
        #self.view.resize(300,300)

        self.setCentralWidget(self.view)


        self.scene = QGraphicsScene(self.view)
        self.view.setScene(self.scene)

        self.scene.setSceneRect(0, 0, 300, 300)
        item0=self.scene.addText('Colossal Cave')
        item0.setPos(125,20)
        image=QPixmap('test_image.png')
        images=image.scaled(50,50)
        for i in range(100):
          item1=self.scene.addPixmap(images)
          item1.setPos(randint(80,200),randint(100,200))

        self.gameWorld = World.World(10,10,(Block.Stone)) # (World)

        self.gameGraphics = GameGraphics(self.gameWorld)
        self.scene.addItem(self.gameGraphics)


    def keyPressEvent(self, event):
        key = event.key()
        if key == Qt.Key_R:
            self.gameGraphics.reset()
        super(MainWindow, self).keyPressEvent(event)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    mainWindow = MainGameWindow()

    mainWindow.show()

    rc = app.exec_()
    del app
    sys.exit(rc)
