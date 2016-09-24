TEMPLATE = app
TARGET = qmldesktopviewer
DEPENDPATH += .
INCLUDEPATH += .
QT += qml widgets quick

# Input
HEADERS +=  qmldesktopviewer.h \
            loggerwidget.h
SOURCES +=  main.cpp \
            qmldesktopviewer.cpp \
            loggerwidget.cpp
CONFIG -=app_bundle
target.path = $$[QT_INSTALL_BINS]
message($$[QT_INSTALL_BINS])
INSTALLS += target
