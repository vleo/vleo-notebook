#include <stdio.h>

int main()
{
  int x[] = {7,3,5};
  int *v;
  int n = sizeof x / sizeof *x;
  for (v=x;v<x+n;v++) {
    printf("%d\n",*v);
  }
  return 0;
}
