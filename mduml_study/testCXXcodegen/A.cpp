#include "A.hpp"
int A::f(int i)
{
  return i;
}

int main(int argc, char* argv[])
{
  A a;
  return a.f(100);
}
