#!/usr/bin/env python3
import inspect

from PyQt5.QtCore import (QLineF, QPointF, QRectF, Qt)
from PyQt5.QtGui import (QBrush, QColor, QPainter, QImage, QPixmap, QKeyEvent, QMouseEvent)
from PyQt5.QtWidgets import (QApplication, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsItem,
                             QGridLayout, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton)

class MainWindow(QGraphicsView):
    def __init__(self):
        scene = QGraphicsScene()
        super().__init__(scene)
        scene.setSceneRect(0,0,640,480)
        self.setWindowTitle('Graphic Scene')

    def keyPressEvent(self,event):
        print(type(event),event)

    def mousePressEvent(self,event):
        print(event)

import sys

if __name__ == '__main__':
    app = QApplication(sys.argv)

    mainWindow = MainWindow()

    mainWindow.show()

    rc = app.exec_()
    del app
    sys.exit(rc)
