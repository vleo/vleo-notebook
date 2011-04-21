#include "A.h"

int A::f( const int i )
{
	return i+c->g();
}

void A::setC( const B & v )
{
  c = &v;
}

void A::setCval( const int v )
{
  c->s(v);
}

void B::s( const int n )
{
 a=n;	
}

int B::g( )
{
	return a;
}
