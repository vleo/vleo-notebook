#include "client.h"
#include <QThread>

#include <QDataStream>
#include <QByteArray>
#include <QIODevice>

client::client(QObject *parent)
: QTcpSocket(parent){

    m_data = NULL;

    connect(this,SIGNAL(connected()),this,SLOT(sendRequest()));
    connect(this,SIGNAL(disconnected()),this,SLOT(connectionClosedByServer()));
    connect(this,SIGNAL(readyRead()),this,SLOT(receiveResponse()));
    connect(this,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(error()));
    m_header = true;
    m_Acked = true;
    m_inProgress = false;
}
client::~client(){

}

void client::closeClient(){
}
void client::connectToServer(const QString& host, quint16 port){

    m_NextBlockSize = 0;
    connectToHost(host,port);
}
void client::sendRequest(){
    emit connectionStatus(true);
}
void client::receiveResponse(){

    QDataStream in(this);
    in.setVersion(QDataStream::Qt_4_6);

    if(m_NextBlockSize == 0){
        if(bytesAvailable() < sizeof(qint64))
            return;
        in >> m_NextBlockSize;
    }
    qint64 bytes = bytesAvailable();

    if(bytes < m_NextBlockSize)
        return;

    quint8 respType;

    in >> respType;

    if(respType == ACK){
        emit message(QString("Received ACK from server"));
        m_Acked = true;
        qDebug() << "packet type set to: " << m_data->req_type;
        if(m_inProgress){
            sendPacket(); 
        }
        else{
         qDebug() << "not in progress";
        }
    }
    m_NextBlockSize = 0;
}
void client::connectionClosedByServer(){

    delete [] m_data->data;
    delete m_data;
    m_data = NULL;

    emit connectionStatus(false);
}
void client::error(){
}
void client::closeConnection(){
}

void client::abortUpload(){

    disconnectFromHost();
}
dataDescriptor_t* client::createTestData(qint64 blocks, qint64 size){

    dataDescriptor_t* data = new dataDescriptor_t();
    data->blocks = blocks;
    data->blockSize = size;
    qDebug() << m_stream->device()->size();
    data->lastBlockSize = (m_stream->device()->size() - (data->blockSize * data->blocks));

    if(m_stream->device()->size() > 0){
        data->data = new char [ m_stream->device()->size() ];
        m_stream->readRawData(data->data,m_stream->device()->size());

        return data;
    }
    else
        return NULL;
}

void client::startUpload(qint64 blocks, qint64 blockSize,QDataStream* stream){

    m_stream = stream;
    m_inProgress = true;
    m_data = createTestData(blocks,blockSize);
    setPacketType(REQ_SND);
    sendPacket();
}
void client::setPacketType(int type){
    if(m_data)
        m_data->req_type = type;
}
void client::sendPacket(){

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_6);


    createPacket(out);
    prependPacketSizeHeader(out,block.size());
    qint64 written = write(block);
    m_Acked = false;
    emit message(QString("Wrote: %1 bytes").arg(written));

}
void client::createPacket(QDataStream& stream){   
    static quint64 blockCount = 0;
    stream << qint64(0);

    switch(m_data->req_type){

     case REQ_SND : {  

         stream << m_data->req_type << m_data->blocks << m_data->blockSize << m_data->lastBlockSize;
         setPacketType(SND);
         m_header = false;

                    }break;
     case SND : { 
         if(m_Acked){
             
             if(blockCount == m_data->blocks){
                 blockCount = 0;
                 m_inProgress = false;
                 setPacketType(END);
                 if(m_data->lastBlockSize > 0)
                     stream.writeRawData(m_data->data,m_data->lastBlockSize); 
             }
             else{
                 ++blockCount;
                 qDebug() << "Blocks sent: " << blockCount; 
                 stream << (quint8)m_data->req_type;
                 stream.writeRawData(m_data->data, m_data->blockSize);
                 
             }
         }
                }break;
    
     default:break;

    }
}
void client::prependPacketSizeHeader(QDataStream& stream, qint64 size){

    stream.device()->seek(0);
    stream << qint64(size - sizeof(qint64));
}
