#include "progressdialog.h"
#include "consumer.h"
#include "producer.h"
#include <QProgressDialog>
#include <QString>

progressDialog::progressDialog(QWidget *parent, Qt::WFlags flags)
    : QMainWindow(parent, flags){

    ui.setupUi(this);

    Consumer *c = new Consumer();
    Producer *p = new Producer();

    Thread *t1 = new Thread(0);
    Thread *t2 = new Thread(0);

    connect(this,SIGNAL(begin(bool)),c,SLOT(startReceiving(bool)));
    connect(c,SIGNAL(initiate(bool)),p,SLOT(produce(bool)));
    connect(p,SIGNAL(sendPacket(const QByteArray,bool)),c,SLOT(receiveFrame(const QByteArray,bool)));
    connect(ui.pushButton,SIGNAL(clicked(bool)),this,SLOT(_begin(bool)));
    connect(p,SIGNAL(halt(bool)),c,SLOT(startReceiving(bool)));
	connect(c,SIGNAL(blockDone()),p,SLOT(frameData()));
	connect(c,SIGNAL(measure(bool)),p,SLOT(measurement(bool)),Qt::DirectConnection);
	connect(c,SIGNAL(openDialog()),this,SLOT(startDlg()));
	connect(c,SIGNAL(closeDialog()),this,SLOT(closeDlg()));
	connect(p,SIGNAL(setDlgMax(int)),this,SLOT(setMaxVal(int)));
	connect(p,SIGNAL(setDlgVal(int)),this,SLOT(setVal(int)));
	connect(p,SIGNAL(setSeconds(int)),this,SLOT(setSecondsRemaining(int)));

    c->moveToThread(t1);
    p->moveToThread(t2);

    t1->start();
    t2->start();
}

progressDialog::~progressDialog(){
}
void progressDialog::_begin(bool){
   emit begin(true);
}
void progressDialog::startDlg(){
	m_progress = new QProgressDialog(this);
	m_progress->show();
}
void progressDialog::closeDlg(){
	m_progress->close();
	delete m_progress;
}
void progressDialog::setMaxVal(int val){
	m_progress->setRange(0,val);
}
void progressDialog::setVal(int val){
	m_progress->setValue(val);
}
void progressDialog::setSecondsRemaining(int val){
	m_progress->setLabelText(QString("About %1 seconds remaining.").arg(val));
}