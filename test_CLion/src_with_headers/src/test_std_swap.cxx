#include <algorithm>    // for std::swap
#include "xyz"
#include "xx.h"
#include "Boost"
int main ()
{
    class MyClass { };
    MyClass aa, bb;
    std::swap(aa, bb);          // doesn't compile
}
