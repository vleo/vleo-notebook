//@(#) A.h

#ifndef A_H_H
#define A_H_H

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
class B
{
	
public:
	B( const int n );
	virtual int g( );
	inline void s( const int n );
	
private:
	int a;
	
	
};

#endif
