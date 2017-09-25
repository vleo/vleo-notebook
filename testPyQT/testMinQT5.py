#!/usr/bin/env python3

from PyQt5.QtCore import (QLineF, QPointF, QRectF, Qt)
from PyQt5.QtGui import (QBrush, QColor, QPainter, QImage, QPixmap, QPicture, QPen,
                         QTextOption,QFont)

from PyQt5.QtWidgets import (QApplication)

from PyQt5.QtWidgets import (QWidget, QMainWindow)
from PyQt5.QtWidgets import (QLabel, QLineEdit, QPushButton)
from PyQt5.QtWidgets import (QSlider, QSpinBox, QComboBox)
from PyQt5.QtWidgets import (QStatusBar)
from PyQt5.QtWidgets import (GraphicsView)

from PyQt5.QtWidgets import (QGraphicsScene, QGraphicsItem)

from PyQt5.QtWidgets import (QGridLayout, QVBoxLayout, QHBoxLayout)

import sys

if __name__ == '__main__':
    app = QApplication(sys.argv)
    mainWindow = QLabel()

    mainWindow.resize(300,300)
    #mainWindow.move(200,200)
    mainWindow.show()

    rc = app.exec_()
    del app
    sys.exit(rc)
