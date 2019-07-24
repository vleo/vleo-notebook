#include "stdio.h"
#include "xyz.h"
int main()
{
  xyz_t* a = xyz_constr();
  printf("i=%d\n",xyz_get_i(a));
}
