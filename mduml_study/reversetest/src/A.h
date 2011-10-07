//@(#) A.h

#ifndef A_H_H
#define A_H_H

#include "B.h"
class A
{
	
public:
	int f( const int i );
	void setC( const B & v );
	void setCval( const int v );
	
private:
	B * c;
	
	int i;
	
	char j;
	
	
};

#endif
