#!/usr/bin/env python3

from PyQt5.QtCore import (QLineF, QPointF, QRectF, Qt)
from PyQt5.QtGui import (QBrush, QColor, QPainter, QImage, QPixmap, QPicture, QPen,
                         QTextOption,QFont)
from PyQt5.QtWidgets import (QApplication, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsItem,
                             QGridLayout, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton)
import sys

if __name__ == '__main__':
    app = QApplication(sys.argv)
    mainWindow = QLabel("Test paint")

    picture = QPicture()
    mainWindow.setPicture(picture)
    painter = QPainter(picture)

    # Изображение

    image = QPixmap('test_image.png')

    painter.drawPixmap(10,20,100,120,image)

    painter.drawLine(0,0,200,200)

    painter.end()


#################################
    mainWindow.show()
    rc = app.exec_()
    del app
    sys.exit(rc)
