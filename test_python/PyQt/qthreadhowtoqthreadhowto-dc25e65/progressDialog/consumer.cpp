#include "consumer.h"
#include <QFile>
#include <QDebug>
Consumer::Consumer(QObject *parent)
: QObject(parent){

}

Consumer::~Consumer(){

}
void Consumer::startReceiving(bool on){

    if(on){
        inStream.setVersion(QDataStream::Qt_4_6);
        m_destination = new QFile(".\\data\\destination.dat");
        m_destination->open(QIODevice::WriteOnly);
        inStream.setDevice(m_destination);
		emit openDialog();
        emit initiate(on);
    }
    else{
		inStream.device()->seek(0);
        m_destination->close();
		emit closeDialog();
    }
}
void Consumer::receiveFrame(const QByteArray& frame, bool last){

    qint8 c;
    static qint64 count=0;
	
    for(int i=0;i<frame.size();++i){
        
        c = frame.at(i);
        inStream << c;
    }
	if(!last){
		emit measure(false);
		emit blockDone();
	}
	else{
		count = 0;
	}
}
