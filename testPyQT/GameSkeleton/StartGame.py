#!/usr/bin/env python3

import os
import sys
import subprocess
import os.path
import gameWindow
from PyQt5 import QtGui
from PyQt5 import QtCore
from PyQt5 import QtWidgets
class MyWin(QtWidgets.QMainWindow):
    def __init__(self, parent=None):
        super(MyWin, self).__init__(parent)
        QtWidgets.QToolTip.setFont(QtGui.QFont('SansSerif', 5))
        self.setToolTip('Выход из игры')#Это подсказка

        qbtn = QtWidgets.QPushButton('Quit', self)
        qbtn.clicked.connect(QtCore.QCoreApplication.instance().quit)
        qbtn.setToolTip('Выход из игры')
        qbtn.resize(100, 30)
        qbtn.move(50, 100)#Это кнопка выхода

        pbtn = QtWidgets.QPushButton('Play!', self)
        pbtn.clicked.connect(self.playGame)
        pbtn.resize(100, 50)
        pbtn.move(50, 50)#Это кнопка запуска игры

        self.resize(200 ,200)
        self.setWindowTitle("My Game")
        self.setWindowIcon(QtGui.QIcon('иконка.png'))
        self.show()#Это окно

    def playGame(self,text):
        print('playGame:',text)
        mw = gameWindow.MainGameWindow(self)
        mw.show()
        print('gameWindow shown')
        mw.update()


def main(args):
    app = QtWidgets.QApplication([])

    ww= MyWin()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main(sys.argv[1:])
