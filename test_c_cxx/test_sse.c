// gcc -mssse3  -ggdb3 -c test_sse.c; gcc test_sse.o -o test_sse; objdump -dS test_sse.o > test_sse.das
#define N 4
#include <stdio.h>
typedef float v4sf __attribute__ ((vector_size(4*N))); // vector of four single floats

union f4vector 
{
  v4sf v;
  float f[N];
};
  

int main()
{
  union f4vector a, b, c;
  int i;
  int n=1;

  
  for(i=0;i<N;i++) a.f[i] = n++;
  for(i=0;i<N;i++) b.f[i] = n++;

  c.v = a.v + b.v;

  for(i=0;i<N;i++) printf("%f ",c.f[i]);
  printf("\n");
}

