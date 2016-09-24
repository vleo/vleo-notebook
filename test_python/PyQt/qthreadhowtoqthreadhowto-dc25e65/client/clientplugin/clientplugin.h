#ifndef CLIENTPLUGIN_H
#define CLIENTPLUGIN_H

#include <QtQuick/QQuickItem>

class Client : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(Client)
    
public:
    Client(QQuickItem *parent = 0);
    ~Client();
};

QML_DECLARE_TYPE(Client)

#endif // CLIENTPLUGIN_H

