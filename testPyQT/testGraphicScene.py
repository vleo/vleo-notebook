#!/usr/bin/env python3

from PyQt5.QtCore import (QLineF, QPointF, QRectF, Qt)
from PyQt5.QtGui import (QBrush, QColor, QPainter, QImage, QPixmap)
from PyQt5.QtWidgets import (QApplication, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsItem,
                             QGridLayout, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton)
import sys

class TicTacToe(QGraphicsItem):
    def __init__(self):
        super(TicTacToe, self).__init__()
        self.board = [[-1, -1, -1],[-1, -1, -1], [-1, -1, -1]]
        self.O = 0
        self.X = 1
        self.turn = self.O
        print("self.first = True")
        self.first = True

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

    def paintImage(self, painter, option, widget):
        source=QRectF(0, 0, 600, 600);
        image=QImage('test_image.png');
        for i in range(3):
          for j in range(3):
            target=QRectF(i*100, j*100, 100, 100);
            painter.drawImage(target,image,source);

    def paint(self, painter, option, widget):
        source=QRectF(0, 0, 600, 600);
        image=QPixmap('test_image.png');
        for i in range(3):
          for j in range(3):
            target=QRectF(i*100, j*100, 100, 100);
            painter.drawPixmap(target,image,source);


#        painter.setPen(Qt.black)
#        painter.drawLine(0,100,300,100)
#        painter.drawLine(0,200,300,200)
#        painter.drawLine(100,0,100,300)
#        painter.drawLine(200,0,200,300)

#        for y in range(3):
#            for x in range(3):
#                if self.board[y][x] == self.O:
#                    painter.setPen(Qt.red)
#                    painter.drawEllipse(QPointF(50+x*100, 50+y*100), 30, 30)
#                elif self.board[y][x] == self.X:
#                    painter.setPen(Qt.blue)
#                    painter.drawLine(20+x*100, 20+y*100, 80+x*100, 80+y*100)
#                    painter.drawLine(20+x*100, 80+y*100, 80+x*100, 20+y*100)

    def boundingRect(self):
        return QRectF(0,0,300,300)

    def mousePressEvent(self, event):
        pos = event.pos()
        self.select(int(pos.x()/100), int(pos.y()/100))
        self.update()
        super(TicTacToe, self).mousePressEvent(event)

class MainWindow(QGraphicsView):
    def __init__(self):
        scene = QGraphicsScene()
        scene.setSceneRect(0, 0, 300, 300)
        super(MainWindow, self).__init__(scene)
        self.tic_tac_toe = TicTacToe()
        scene.addItem(self.tic_tac_toe)
        self.setCacheMode(QGraphicsView.CacheBackground)
        self.setWindowTitle("Tic Tac Toe")
        self.resize(300,300)

    def keyPressEvent(self, event):
        key = event.key()
        if key == Qt.Key_R:
            self.tic_tac_toe.reset()
        super(MainWindow, self).keyPressEvent(event)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    mainWindow = MainWindow()

    mainWindow.show()

    rc = app.exec_()
    del app
    sys.exit(rc)
