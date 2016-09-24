#ifndef CLIENT_H
#define CLIENT_H

#include <QtCore/QObject>
#include <QtNetwork/QTcpSocket>
#include <QtCore/QThread>
#include <QtCore/QTimer>
#include "shared.h"

class client : public QTcpSocket
{
    Q_OBJECT

public:
    client(QObject *parent = 0);
    ~client();

public slots:

    void connectToServer(const QString&,quint16);
    void sendRequest();
    void receiveResponse();
    void connectionClosedByServer();
    void error();
    void abortUpload();

    void startUpload(qint64,qint64,QDataStream*);


signals:

    void connectionStatus(bool);
    void message(const QString&);


private slots:
    void sendPacket();

private:
    void createPacket(QDataStream&);
    void setPacketType(int);
    void prependPacketSizeHeader(QDataStream&,qint64);
    dataDescriptor_t* createTestData(qint64,qint64);
    void closeClient();
    void closeConnection();
    qint64 m_NextBlockSize;

    bool m_Acked, m_header, m_inProgress;
    dataDescriptor_t *m_data;
    QDataStream* m_stream;



};

#endif // CLIENT_H

