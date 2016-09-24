#include <stdlib.h>
#include <stdio.h>

/* the agreement is always pass only *p variables to functions */
/* and variables on lhs of assignemnt expression */ 

void func(int *p)
{
  *p = 777;
}

main()
{
  #define INT(p) int *p; p = malloc(sizeof(*p));
  #define ASG(p) p = malloc(sizeof(*p));

  int *p; p = malloc(sizeof(*p)); *p = 321;
  p = malloc(sizeof(*p)); *p = 444;

  INT(z) *z=123;
  printf("*z= %d\n",*z);
  ASG(z) *z=555;

  printf("*z= %d\n",*z);
  func(z);
  printf("*z= %d\n",*z);
}
