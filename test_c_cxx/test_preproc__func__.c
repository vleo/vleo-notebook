#include <stdio.h>
#define FUNCLOG(fmt,args...)  printf("%s("fmt")\n",__func__,args)

#define N 1
#define NN #define M 3

void main(void)
{
  int i=123,j=456;
  FUNCLOG("%d,%d",i,j);
  FUNCLOG("",0);

  printf("N=%d\n",NP(N));
}
