# ----------------------------------------------------
# This file is generated by the Qt Visual Studio Add-in.
# ------------------------------------------------------

# This is a reminder that you are using a generated .pro file.
# Remove it when you are finished editing this file.
message("You are running qmake on a generated .pro file. This may not work!")


TEMPLATE = app
TARGET = nonBlockServer
DESTDIR = ./debug
QT += network gui core widgets
CONFIG += debug
DEFINES += _WINDOWS QT_LARGEFILE_SUPPORT _WINDOWS QT_LARGEFILE_SUPPORT _WINDOWS QT_LARGEFILE_SUPPORT _WINDOWS QT_LARGEFILE_SUPPORT QT_LARGEFILE_SUPPORT QT_NETWORK_LIB QT_DLL QT_DLL QT_DLL QT_DLL
INCLUDEPATH += ./GeneratedFiles \
    ./GeneratedFiles/Debug \
    . \
    ./GeneratedFiles/debug \
    $(QTDIR)/mkspecs/win32-msvc2008 \
    ./../shared \
    ./GeneratedFiles/debug \
    ./GeneratedFiles \
    $(QTDIR)/mkspecs/win32-msvc2008
DEPENDPATH += .
MOC_DIR += ./GeneratedFiles/debug
OBJECTS_DIR += debug
UI_DIR += ./GeneratedFiles
RCC_DIR += ./GeneratedFiles
include(nonBlockServer.pri)