#include <algorithm>    // for std::swap
#include "xyz"
int main ()
{
    class MyClass { };
    MyClass aa, bb;
    std::swap(aa, bb);          // doesn't compile
}
