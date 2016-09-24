#ifndef PROGRESSDIALOG_H
#define PROGRESSDIALOG_H

#include <QtGui/QMainWindow>
#include "ui_progressdialog.h"
#include <QThread>

class QProgressDialog;

class Thread : public QThread{

public:

    Thread(QObject *parent = 0) : QThread(parent){
    }

protected:

    void run(){
        exec();
    }
};

class progressDialog : public QMainWindow
{
    Q_OBJECT

public:

    progressDialog(QWidget *parent = 0, Qt::WFlags flags = 0);
    ~progressDialog();
public slots:
	void startDlg();
	void closeDlg();
	void setMaxVal(int);
	void setVal(int);
	void setSecondsRemaining(int);
private slots:

     void _begin(bool);

signals:

    void begin(bool);

private:

    Ui::progressDialogClass ui;
	QProgressDialog *m_progress;
	int m_max;
};

#endif // PROGRESSDIALOG_H
