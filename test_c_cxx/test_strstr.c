#include <stdio.h>
#include <string.h>

int main(int argc,char** argv)
{
  char *s1="abc";
  char *s2="b";

  printf("%p %p %p\n",s1,s2,strstr(s1,s2));
}
