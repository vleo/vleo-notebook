TEMPLATE = lib
TARGET = clientplugin
QT += core network quick
CONFIG += qt plugin
INCLUDEPATH += \
            ../shared \
            $$[QT_INSTALL_HEADERS]


DEPENDPATH += $$INCLUDEPATH

include(nonblockclient.pri)

OTHER_FILES += \
    ConfigDialog.qml \
    ConnectionMonitor.qml


