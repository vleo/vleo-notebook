#ifdef CL
class C;
#else
int C=1;
#endif

class A
{
public:
  A(int n):nn(n){};
  int nn;
};

// depending on context
// if CL
//   A is a function declaration 
A b(C);
// else
//  A is an object declartion (constructor call)
