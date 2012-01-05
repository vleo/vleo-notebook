#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>


int main(int argc,char** argv)
{
  uint8_t* i_ptr = malloc(0);
  printf("i_ptr= %p\n",i_ptr);
#ifdef FREE
  free(i_ptr);
#endif
}
