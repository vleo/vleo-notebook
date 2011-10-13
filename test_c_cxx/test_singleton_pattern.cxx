#include <iostream>
using namespace std;

class Singleton
{
private:
  static bool instanceFlag;
  static Singleton *single;
    Singleton ()
  {
    //private constructor  
  }
public:
  static Singleton *getInstance ();
  // here our custom code goes vvvvvv
  void method ();
  // here our custom code goes ^^^^^^
  ~Singleton ()
  {
    instanceFlag = false;
  }
};

bool Singleton::instanceFlag = false;

Singleton *Singleton::single = NULL;

Singleton * Singleton::getInstance ()
{
  if (!instanceFlag)
    {
      single = new Singleton ();
      instanceFlag = true;
      return single;
    }
  else
    {
      return single;
    }
}

// here our custom code goes vvvvvv
void Singleton::method ()
{
  cout << "Method of the singleton class" << endl;
  cout << "instanceFlag : " << instanceFlag << endl;
}
// here our custom code goes ^^^^^^

int main ()
{
  Singleton *sc1, *sc2;
  sc1 = Singleton::getInstance ();
  sc1->method ();
  sc2 = Singleton::getInstance ();
  sc2->method ();

  return 0;
}
