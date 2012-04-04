/**
 * @(#) global.cpp
 */


#include "iostream"
#include "XYZ.h"
#include "global.h"

int main( const int argc, const char ** argv )
{
  std::XYZ vi;

  vi.days.push_back(123);
  std::cout << vi.days[0] << std::endl;
  
	return 0;
}
