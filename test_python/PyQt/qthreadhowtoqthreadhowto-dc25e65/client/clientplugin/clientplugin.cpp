#include "clientplugin.h"

Client::Client(QQuickItem *parent):
    QQuickItem(parent) {

     setFlag(ItemHasContents, false);
}

Client::~Client(){}

