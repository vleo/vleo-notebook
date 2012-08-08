#include <iostream>
#include <typeinfo>
#include <stdint.h>
#include <cxxabi.h>

#define ptn(t) abi::__cxa_demangle(typeid(t).name(),0,0,&status)

class Abc {
public:
    Abc():iv(333){};
    Abc(int n):iv(n){};
    virtual ~Abc(){};
    int iv;
    int64_t i64;
};

class Bbc: public Abc
{
public:
    Bbc():Abc(666),i32(777){ };
    int32_t i32;
};

main()
{
    int status;
    Abc a;
    Abc &b = a;
    a.iv = 123;
    std::cout << "iv=" << a.iv << std::endl;
    b.iv = 333;
    Abc *aa = new Bbc();
    Abc *aaa = new Abc();
    Bbc &bb = dynamic_cast<Bbc&>(*aa);
    // Bbc &bbb = dynamic_cast<Bbc&>(*aaa); // RUNTIME exception
    std::cout << "iv=" << a.iv << std::endl;
    std::cout << "name=" << ptn(a) << std::endl;
    std::cout << "name=" << ptn(&a) << std::endl;
    std::cout << "name=" << ptn(a.iv) << std::endl;
    std::cout << "name=" << ptn(a.i64) << std::endl;
    std::cout << "name=" << ptn(b) << std::endl;
    std::cout << "name=" << ptn(aa) << " iv=" << aa->iv << std::endl;
    std::cout << "name=" << ptn(*aa) << std::endl; // must dereference ptr in order to see the true class
    std::cout << "name=" << ptn(bb) << " iv=" << aa->iv << std::endl;
    //std::cout << "name=" << ptn(bbb) << " iv=" << aa->iv << std::endl;
}
