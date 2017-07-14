from PyQt4 import QtGui, QtCore

class MyWindow(QtGui.QDialog):    # any super class is okay
    def __init__(self, parent=None):
        super(MyWindow, self).__init__(parent)
        self.button = QtGui.QPushButton('Press')
        layout = QtGui.QHBoxLayout()
        layout.addWidget(self.button)
        self.setLayout(layout)
        self.button.clicked.connect(self.create_child)
    def create_child(self):
        # here put the code that creates the new window and shows it.
        child = MyWindow(self)
        child.show()


if __name__ == '__main__':
    # QApplication created only here.
    app = QtGui.QApplication([])
    window = MyWindow()
    window.show()
    app.exec_()
