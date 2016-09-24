#ifndef PRODUCER_H
#define PRODUCER_H

#include <QObject>
#include <QByteArray>
#include <QDataStream>
#include <QTime>
#include <QTimer>

#define BLOCK_SIZE 4096
#define SMOOTHING_FACTOR 100
class QFile;
class QTimer;

class Producer : public QObject
{
    Q_OBJECT

public:
    Producer(QObject *parent = 0);
    ~Producer();

public slots:
    void produce(bool);
	void frameData();
	void measurement(bool);

private:
    void transfer();
	qreal moving(int);
	void resetTimer();

public slots:
	void incTicks();

signals:
    void sendPacket(const QByteArray&,bool);
    void halt(bool);
	void setDlgMax(int);
	void setDlgVal(int);
	void setSeconds(int);

private:

  QFile *m_source; 
  QDataStream stream;
  
  qint64 m_size;
  qint64 m_numBlocks;
  qint64 m_blockCount;
  qint64 m_fragment;
  QTime m_timer;
  int m_elapsed;
  qint64 m_count;
  qreal m_average;
  qreal m_cumulativeTime;
  qreal m_maxTime;
  int m_seconds;
  int m_moving[SMOOTHING_FACTOR];
  QTimer *m_tickGenerator;
  int m_ticks;
 
};

#endif // PRODUCER_H
