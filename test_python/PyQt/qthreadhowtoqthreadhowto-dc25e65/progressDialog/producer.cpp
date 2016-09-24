#include "producer.h"
#include <QFile>
#include <QDebug>


Producer::Producer(QObject *parent)
: QObject(parent){

    m_source = new QFile(".\\data\\data.dat");
    m_source->open(QIODevice::ReadOnly);
    m_elapsed = 0;
    for(int i=0;i<SMOOTHING_FACTOR;++i){
        m_moving[i]=0;
    }
    m_tickGenerator = new QTimer(this);

    connect(m_tickGenerator,SIGNAL(timeout()),this,SLOT(incTicks()));
}

Producer::~Producer(){
}
void Producer::produce(bool on){
    if(on)
        transfer();
    else
        emit halt(on);
}
void Producer::transfer(){

    m_count = 0;
    m_blockCount = 0;
    m_maxTime = 0;
    m_seconds = 0;
    m_ticks = 0;
    m_cumulativeTime = 0.0;

    if(m_source->isOpen()){

        stream.setDevice(m_source);
        stream.setVersion(QDataStream::Qt_4_6);
        stream.device()->seek(0);
        m_size = m_source->size();
        m_numBlocks = m_size/BLOCK_SIZE;
        m_blockCount = m_numBlocks;
        m_fragment = m_size - (m_numBlocks*BLOCK_SIZE);
    }
    frameData();
}
void Producer::frameData(){

    QByteArray block;
    quint8 c;
    measurement(true);
    m_count++;

    if(m_numBlocks > 0){
        for(int i=0;i<BLOCK_SIZE;++i){
            stream >> c;
            block.append(c);
        }
        m_numBlocks -= 1;
        emit sendPacket(block,false);	
    }
    else{
        if(m_fragment > 0){
            for(int j=0;j<m_fragment;++j){
                stream >> c;
                block.append(c);
            }
            emit sendPacket(block,true);
        }
        emit halt(false); 
    }
}
void Producer::measurement(bool onOff){

    if(onOff){
        m_tickGenerator->start(1);
    }else{
        m_average = moving(m_ticks);
        resetTimer();
        m_maxTime = m_average*(qreal)m_blockCount;
        emit setDlgMax((int)m_maxTime);
        emit setDlgVal(  (int)(m_count * m_average));
        emit setSeconds((int)((m_maxTime-((qreal)m_count*m_average))/1000.0));
    }
}
qreal Producer::moving(int current){

    int second = 0;

    for(int first=SMOOTHING_FACTOR-1;first >=0;--first){

        if(first>=1){
            second = first-1;
            m_moving[first] = m_moving[second];	
        }
        else{
            m_moving[first] = current;
        }
    }

    int cum = 0;
    for(int i = 0;i < SMOOTHING_FACTOR;i++){
        cum += m_moving[i];
    }

    qreal ave = cum/SMOOTHING_FACTOR;
    return ave;
}
void Producer::incTicks(){
    m_ticks++;
}
void Producer::resetTimer(){
    m_ticks = 0;
}

