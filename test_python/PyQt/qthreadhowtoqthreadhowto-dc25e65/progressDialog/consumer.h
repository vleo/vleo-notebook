#ifndef CONSUMER_H
#define CONSUMER_H

#include <QObject>
#include <QByteArray>
#include <QDataStream>

#define BLOCK_SIZE 4096

class QFile;

class Consumer : public QObject
{
    Q_OBJECT

public:

    Consumer(QObject *parent = 0);
    ~Consumer();
    
signals:

    void initiate(bool);
	void blockDone();
	void measure(bool);
	void closeDialog();
	void openDialog();

public slots:

    void receiveFrame(const QByteArray&,bool);
    void startReceiving(bool);

private:

   QDataStream inStream;
   QFile *m_destination;
};

#endif // CONSUMER_H
