#include <stdio.h>

void *addr = "ABCDEF";

main()
{
  printf("%p\n",addr);

  addr++;
  printf("%p\n",addr);

  (short int*)addr++;
  printf("%p\n",addr);

  (short int*)++addr;
  printf("%p\n",addr);

}
