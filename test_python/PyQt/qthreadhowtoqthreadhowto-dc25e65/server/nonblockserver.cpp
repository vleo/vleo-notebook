#include "nonblockserver.h"
#include "server.h"

nonBlockServer::nonBlockServer(QWidget *parent, Qt::WFlags flags)
	: QMainWindow(parent, flags){
	
	ui.setupUi(this); 
    ui.pushButton_2->setEnabled(false);
   
	m_Server = new server(this);
	
	connect(this,SIGNAL(_start(quint16)),m_Server,SLOT(startListening(quint16)));
	connect(m_Server,SIGNAL(listening(bool)),this,SLOT(updateServerStatus(bool)));
	connect(this, SIGNAL(_stop()),m_Server,SLOT(stopListening()));
    
}

nonBlockServer::~nonBlockServer(){
   
}
void nonBlockServer::updateServerStatus(bool status){
	if(status){
		ui.statusBar->showMessage(_listening_);
		ui.pushButton->setEnabled(false);
		ui.pushButton_2->setEnabled(true);
	}
	else{
		ui.statusBar->showMessage(_notListening_);
		ui.pushButton->setEnabled(true);
		ui.pushButton_2->setEnabled(false);
	}
}
void nonBlockServer::startServer(){
	emit _start(ui.spinBox->value());
}
void nonBlockServer::stopServer(){
	emit _stop();
}

void nonBlockServer::printStatus(int cid, const QString& status){
	QString message = QString("CID: %1: ").arg(cid) + status;
    ui.textBrowser->append(message);
}