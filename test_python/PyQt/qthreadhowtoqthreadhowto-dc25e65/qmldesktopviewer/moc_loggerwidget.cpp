/****************************************************************************
** Meta object code from reading C++ file 'loggerwidget.h'
**
** Created: Tue Jul 3 10:21:28 2012
**      by: The Qt Meta Object Compiler version 67 (Qt 5.0.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "loggerwidget.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'loggerwidget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.0.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_LoggerWidget_t {
    QByteArrayData data[12];
    char stringdata[130];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_LoggerWidget_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_LoggerWidget_t qt_meta_stringdata_LoggerWidget = {
    {
QT_MOC_LITERAL(0, 0, 12),
QT_MOC_LITERAL(1, 13, 6),
QT_MOC_LITERAL(2, 20, 0),
QT_MOC_LITERAL(3, 21, 6),
QT_MOC_LITERAL(4, 28, 6),
QT_MOC_LITERAL(5, 35, 3),
QT_MOC_LITERAL(6, 39, 21),
QT_MOC_LITERAL(7, 61, 25),
QT_MOC_LITERAL(8, 87, 8),
QT_MOC_LITERAL(9, 96, 6),
QT_MOC_LITERAL(10, 103, 12),
QT_MOC_LITERAL(11, 116, 12)
    },
    "LoggerWidget\0opened\0\0closed\0append\0"
    "msg\0updateNoWarningsLabel\0"
    "warningsPreferenceChanged\0QAction*\0"
    "action\0readSettings\0saveSettings\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LoggerWidget[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   49,    2, 0x05,
       3,    0,   50,    2, 0x05,

 // slots: name, argc, parameters, tag, flags
       4,    1,   51,    2, 0x0a,
       6,    0,   54,    2, 0x0a,
       7,    1,   55,    2, 0x08,
      10,    0,   58,    2, 0x08,
      11,    0,   59,    2, 0x08,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 8,    9,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void LoggerWidget::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        LoggerWidget *_t = static_cast<LoggerWidget *>(_o);
        switch (_id) {
        case 0: _t->opened(); break;
        case 1: _t->closed(); break;
        case 2: _t->append((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 3: _t->updateNoWarningsLabel(); break;
        case 4: _t->warningsPreferenceChanged((*reinterpret_cast< QAction*(*)>(_a[1]))); break;
        case 5: _t->readSettings(); break;
        case 6: _t->saveSettings(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (LoggerWidget::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LoggerWidget::opened)) {
                *result = 0;
            }
        }
        {
            typedef void (LoggerWidget::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LoggerWidget::closed)) {
                *result = 1;
            }
        }
    }
}

const QMetaObject LoggerWidget::staticMetaObject = {
    { &QMainWindow::staticMetaObject, qt_meta_stringdata_LoggerWidget.data,
      qt_meta_data_LoggerWidget,  qt_static_metacall, 0, 0}
};


const QMetaObject *LoggerWidget::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LoggerWidget::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_LoggerWidget.stringdata))
        return static_cast<void*>(const_cast< LoggerWidget*>(this));
    return QMainWindow::qt_metacast(_clname);
}

int LoggerWidget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    return _id;
}

// SIGNAL 0
void LoggerWidget::opened()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void LoggerWidget::closed()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}
QT_END_MOC_NAMESPACE
