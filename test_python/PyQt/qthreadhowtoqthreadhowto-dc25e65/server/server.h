#ifndef SERVER_H
#define SERVER_H

#include <QTcpServer>
#include <QTcpSocket>
#include <QDataStream>
#include <QByteArray>
#include <QThread>
#include <QMap>
#include "shared.h"

class ServerThread : public QThread{

public:

	ServerThread(QObject *parent = 0) : QThread(parent){
	}

protected:

	void run(){
		exec();
	}
};

class ClientSocket : public QTcpSocket
{
	Q_OBJECT

public:

	ClientSocket(QObject *parent = 0,int fd = 0);
    virtual ~ClientSocket();

public slots:

	void closeDown(int);	

private slots:

	void readClient();
	
signals:

	void callProgress(int,int);
	void callMessage(int,const QString&);
	void reqDisconnection(int);

private:

	void sendResponse();
	bool m_newFrame;
    dataDescriptor_t *m_data;
    QObject *m_Parent;
	ServerThread *m_ServerThread;
	int m_fd;
};

class BlockServer : public QTcpServer
{
	Q_OBJECT

public:
	BlockServer(QObject *parent = 0);
	~BlockServer();

typedef QMap<int,QTcpSocket*> connectionMap_t;

friend class server;

public slots:
    void _hungUp();
	void progress(int,int);
	void message(int,const QString&);
	void disconnectRequest(int);

signals:
    void updateProgress(int,int);
    void status(int,const QString&);
	void closeClient(int);
	

private:
	void incomingConnection(int);
    int m_CurrentHandle;
	connectionMap_t m_ConnectionMap;
};

class server : public QObject{

	Q_OBJECT

public:
	server(QObject *parent = 0);
	~server();

signals:
	void listening(bool);
    
public slots:
	void startListening(quint16 port = 6000);
	void stopListening();

private:
	BlockServer *m_Server;
    QObject *m_Parent;
};

#endif // SERVER_H
