#include "stdio.h"
#include "xyz.h"
main()
{
  xyz_t* a = xyz_constr();
  printf("i=%d\n",xyz_get_i(a));
}
