#ifndef _SHARED_H_
#define _SHARED_H_

#include <QString>

#define REQ_SND		0x01
#define SND         0x02
#define ACK			0x03
#define END			0x04

typedef char * dataPtr_t;


typedef struct data_
{
	dataPtr_t data;
    quint8   req_type;
	qint64   blocks;
	qint64   blockSize;
    qint64   lastBlockSize;
}dataDescriptor_t;

class _TestConfiguration_{

public:
	_TestConfiguration_(
		
		int prt = 6000,
		int blkSize = 1024,
		int conn = 1,
		
		QString hName = "localhost", 
		bool aul = false)
		:
		port(prt),
		blockSize(blkSize),
		connections(conn),
		hostName(hName),
		autoUpload(aul){
	}
	_TestConfiguration_(const _TestConfiguration_& c){

		
		port = c.port;
		blockSize = c.blockSize;
		connections = c.connections;
		hostName = c.hostName;
		autoUpload = c.autoUpload;
	}
	~_TestConfiguration_(){}

	
	int port;
	int blockSize;
	int connections;
	QString hostName;
	bool autoUpload;

};


Q_DECLARE_METATYPE(_TestConfiguration_)

#endif
