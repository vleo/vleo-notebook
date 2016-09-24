#ifndef NONBLOCKSERVER_H
#define NONBLOCKSERVER_H

#include <QMainWindow>
#include "ui_nonblockserver.h"

class server;

const QString _listening_("Server running");
const QString _notListening_("Server not running");


class nonBlockServer : public QMainWindow{

	Q_OBJECT

public:
	nonBlockServer(QWidget *parent = 0, Qt::WFlags flags = 0);
	~nonBlockServer();

public slots:
	void updateServerStatus(bool);
	void startServer();
	void stopServer();
    void printStatus(int,const QString&);

signals:
	void _start(quint16);
	void _stop();
    

private:
	Ui::nonBlockServerClass ui;
	server *m_Server;
	
};

#endif // NONBLOCKSERVER_H
