if [[ $1 != clean ]]
then
unzip -x images.zip
g++ -fPIC -I /usr/include/qt5 -I/usr/include/qt5/QtCore  -I /usr/include/qt5/QtGui/ -I /usr/include/qt5/QtWidgets/ -c snake.cpp
g++ -fPIC -I /usr/include/qt5 -I/usr/include/qt5/QtCore  -I /usr/include/qt5/QtGui/ -I /usr/include/qt5/QtWidgets/ -c main.cpp 
g++ -lQt5Widgets -lQt5Gui -lQt5Core main.o snake.o -o snake 
else
rm -f *.o *.png snake
fi
