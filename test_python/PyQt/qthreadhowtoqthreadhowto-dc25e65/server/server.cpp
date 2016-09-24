#include "server.h"

/* ClientSocket IMPLEMENTATION */
ClientSocket::ClientSocket(QObject *parent,int fd) 
: QTcpSocket(parent), m_fd(fd){

	setSocketDescriptor(m_fd);
    connect(this, SIGNAL(readyRead()),this,SLOT(readClient()));
    connect(this, SIGNAL(disconnected()),this,SLOT(deleteLater()));
    m_ServerThread = new ServerThread;
	moveToThread(m_ServerThread);
	m_ServerThread->start();
    m_newFrame = false;

}
ClientSocket::~ClientSocket(){
	
	m_ServerThread->terminate();
	m_ServerThread->wait();
}
void ClientSocket::readClient(){

    
    QDataStream in(this);
    in.setVersion(QDataStream::Qt_4_6);
    static qint64 thisFrameSize = 0;
    if(m_newFrame == false){
        if(bytesAvailable() < sizeof(qint64))
            return;
        in >> thisFrameSize;
        m_newFrame = true;
        m_data = new dataDescriptor_t();
    }else{
        in >> thisFrameSize;
    }
    qint64 bytes = bytesAvailable();

    if(bytes < thisFrameSize)
        return;
   
    in >> m_data->req_type;

    if(m_data->req_type == REQ_SND){

        in >> m_data->blocks;
        in >> m_data->blockSize;
        in >> m_data->lastBlockSize;

        m_data->data = new char [(m_data->blocks * m_data->blocks) + m_data->lastBlockSize] ;
		
        sendResponse();
        emit callMessage(m_fd,(QString("Received new frame request  %1 blocks of %2 bytes + last block of %3 bytes").arg(m_data->blocks).arg(m_data->blockSize).arg(m_data->lastBlockSize)));
    }
    if(m_data->req_type == SND){
        
        in.readRawData(m_data->data,m_data->blockSize);
        sendResponse();
         emit callMessage(m_fd,(QString("Received %1 block of %2 bytes").arg(1).arg(m_data->blockSize)));
    }
	if(m_data->req_type == END){

        m_newFrame = false;
        emit reqDisconnection(m_fd);
        delete [] m_data->data;
	    delete m_data;
        m_data = NULL;	
    }
   	
   emit callProgress(m_fd,(int)0.0);
	
}

void ClientSocket::sendResponse(){

      QByteArray  returnData;
      QDataStream out(&returnData, QIODevice::WriteOnly);
      out.setVersion(QDataStream::Qt_4_6);
      out << qint64(0)  << quint8(ACK);
      out.device()->seek(0);
      out << qint64(returnData.size() - sizeof(qint64));
      write(returnData); 
}
void ClientSocket::closeDown(int cid){
	if(cid == this->socketDescriptor()){
		emit callMessage(cid, "client socket closing...");
        //disconnectFromHostImplementation ();
        disconnectFromHost();
	}
}
void BlockServer::disconnectRequest(int cid){

	m_ConnectionMap.remove(cid);
	emit closeClient(cid);
}
/* BlockServer IMPLEMENTATION */
BlockServer::BlockServer(QObject *parent) : QTcpServer(parent){
    m_CurrentHandle = 0;
}
BlockServer::~BlockServer(){

}
void BlockServer::incomingConnection(int handle){

	emit updateProgress(handle,0);
    ClientSocket *socket = new ClientSocket(NULL,handle);
	socket->setObjectName(QString("%1").arg(handle));
	m_ConnectionMap.insert(handle,socket);
	connect(socket,SIGNAL(disconnected()),socket,SLOT(deleteLater()));
	connect(socket, SIGNAL(disconnected()),this,SLOT(_hungUp()));
	connect(socket,SIGNAL(callProgress(int,int)),this,SLOT(progress(int,int)));
	connect(socket,SIGNAL(callMessage(int,QString)),this,SLOT(message(int,QString)));
    connect(socket,SIGNAL(reqDisconnection(int)),this,SLOT(disconnectRequest(int)));
	connect(this,SIGNAL(closeClient(int)),socket,SLOT(closeDown(int)));
    m_CurrentHandle = handle;
	
	
    emit status(handle,"connection received");

}
void BlockServer::progress(int cid, int progress){
    emit updateProgress(cid,progress);
}
void BlockServer::message(int cid, const QString& msg){
	emit status(cid,msg);
}
void BlockServer::_hungUp(){
	
	
}
/*server IMPLEMENTATION*/
server::server(QObject *parent)
: QObject(0), m_Parent(parent){
    
}
server::~server(){
}

void server::startListening(quint16 port){
                                      
    m_Server = new BlockServer(this);
    connect(m_Server,SIGNAL(status(int,QString)),m_Parent,SLOT(printStatus(int,QString)));
   // connect(m_Server,SIGNAL(updateProgress(int,int)),m_Parent,SLOT(updateProgress(int,int)));
    if(!m_Server->listen(QHostAddress::Any, port)){

        qDebug() << "Failed to bind to port: " << port;
        emit listening(false);
        return;
    }

    emit listening(true);
}
void server::stopListening(){

    disconnect(m_Server,SIGNAL(updateProgress(int,int)),m_Parent,SLOT(updateProgress(int,int)));
	
	QList<QTcpSocket*> sockets = m_Server->m_ConnectionMap.values();
	foreach(QTcpSocket* socket,sockets){
		int id = socket->socketDescriptor();
		m_Server->disconnectRequest(id);
	}
    m_Server->close();
    emit listening(false);
}
