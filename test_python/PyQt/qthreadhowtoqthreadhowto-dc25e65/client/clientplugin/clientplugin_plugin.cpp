#include "clientplugin_plugin.h"
#include "clientplugin.h"



void ClientPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<Client>(uri, 1, 0, "Client");
}

