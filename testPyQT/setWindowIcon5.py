#!/usr/bin/env python3

import os
import sys
import subprocess
import os.path

from PyQt5 import QtGui
from PyQt5 import QtCore
from PyQt5 import QtWidgets

class MyWin(QtWidgets.QMainWindow):
    def __init__(self, parent=None):
        super(MyWin, self).__init__(parent)
        self.setWindowTitle("My Window")
        self.setWindowIcon(QtGui.QIcon('test_icon.png'))
        self.show()

def main(args):
    app = QtWidgets.QApplication([])

    ww= MyWin()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main(sys.argv[1:])
