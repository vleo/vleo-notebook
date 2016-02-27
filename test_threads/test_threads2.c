#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int a,b,sum;
void* thread_one (void* unused)
{
  sleep(0);
  printf("thread1\n");
  a=3;
  b=1;
}

void* thread_two (void* unused)
{
  sleep(1);
  printf("thread2\n");
  if(b==1)
  {
    sum += a;
  }
}

/* The main program.  */
pthread_t thread_id1,thread_id2;
int main ()
{

  a=5;
  b=5;
  sum=0;

  /* Create a new thread. The new thread will run the thread_one
     function. */
  pthread_create (&thread_id1, NULL, &thread_one, NULL);
  pthread_create (&thread_id2, NULL, &thread_two, NULL);
  sleep(2);

  if (b==1)
    printf("sum=%d\n",sum);

  return 0;
}

