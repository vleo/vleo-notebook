#include <stdio.h>

int main()
{
  int x[] = {3,5,7};
  for (const int v : x) {
    printf("%d\n",v);
  }
  return 0;
}
