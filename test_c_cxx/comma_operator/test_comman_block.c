#include <stdio.h>
main()
{

int a=0;
int x=0;

printf(" %d", x==0 ? (a=3, 33) : (a=2, 22));
printf(" %d\n",a);
x=1;
printf(" %d", x==0 ? (a=3, 33) : (a=2, 22));
printf(" %d\n",a);

}

