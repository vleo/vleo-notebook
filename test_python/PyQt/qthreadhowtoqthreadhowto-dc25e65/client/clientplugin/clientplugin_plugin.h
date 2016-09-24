#ifndef CLIENTPLUGIN_PLUGIN_H
#define CLIENTPLUGIN_PLUGIN_H

#include <QtQml/QQmlExtensionPlugin>
#include <QtCore/QtPlugin>

class ClientPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qthreadhowto.clientplugin" FILE "clientplugin.json")
public:
    void registerTypes(const char *uri);
};

#endif // CLIENTPLUGIN_PLUGIN_H

