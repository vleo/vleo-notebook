#include "A.cpp"

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
	int g( );
	
	void s( const int n );
	private:
	int a;
	
};
