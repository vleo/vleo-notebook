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
#################################
    mainWindow.setStyleSheet("margin: 10px; padding:20px; border: 2px dot-dash green; background-color: pink;")
#################################
    painter = QPainter(picture)

    # по умолчанию просто черная линия
    painter.drawLine(0,0,200,200)

    # цвет толщина тип-линии форма-на-концах
    painter.setPen(QPen(Qt.black,5,Qt.DashLine,Qt.RoundCap))

    painter.drawLine(0,200,200,0)

    painter.setPen(QPen(Qt.blue,1,Qt.SolidLine,Qt.RoundCap))
    painter.drawLine(0,0,200,0)
    painter.drawLine(200,0,200,200)
    painter.drawLine(200,200,0,200)
    painter.drawLine(0,200,0,0)

    # Изображение

    image = QPixmap('test_image.png')

    painter.drawPixmap(10,20,100,120,image)

    # просто текст
    painter.drawText( QPointF(60,160),'Quick Brown Fox')

    # Текст и его стиль
    font=QFont()
    font.setPixelSize(12)
    painter.setFont(font)
    painter.setPen(QColor(Qt.red))
    painter.drawText( QPointF(50,180),'Jumped Over the Lazy Dog')

    painter.end()
#################################
    mainWindow.move(200,200)
    mainWindow.show()
    rc = app.exec_()
    del app
    sys.exit(rc)
