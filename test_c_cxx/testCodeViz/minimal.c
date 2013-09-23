//#include <stdio.h>
extern int printf (__const char *__restrict __format, ...);

struct point {
   int    x123;
   int    y124;
	 union {
	 int a125;
	 int b126;
	 };
};

void point_print2(struct point p);

struct point p1;

void point_print(struct point p)
{
  int i,s=0;
	//for (i=1;i<100000000;i++) s=s+i;
	p.b126=s;
  point_print2(p);
}

void point_print2(struct point p)
{
  int i,s=0;
	for (i=1;i<1000000;i++) s=s+i;
	p.a125=s;
  printf("p.x:%d p.y:%d p.a:%d\n",p.x123,p.y124,p.b126);
}

int main(int argc, char **argv)
{
  int i,s=0;
  struct point p2={11,22,33};
	//for (i=1;i<100000000;i++) s=s+i;
	p1.a125=s;
  point_print(p2);
	goto L1;
	point_print2(p1);
	L1:
  return 0;
}
