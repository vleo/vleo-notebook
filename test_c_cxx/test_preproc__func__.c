#include <stdio.h>
#define FUNCLOG(fmt,args...)  printf("%s("fmt")\n",__func__,args)

void main(void)
{
int i=123,j=456;
  FUNCLOG("%d,%d",i,j);
  FUNCLOG("",0);
}
