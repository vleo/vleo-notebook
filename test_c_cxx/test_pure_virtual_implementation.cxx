#include <iostream>

using namespace std;

class A {
public:
virtual void f() = 0;

};

void A::f() {
cout<<"Test"<<endl;
};

class B : public A
{
public:
  void f(){ A::f(); }
};


int main()
{
  B b;
  b.f();
}


