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
  vi.maxday=0;
  std::cout << vi.days[vi.maxday] << std::endl;
  
	return 0;
}
