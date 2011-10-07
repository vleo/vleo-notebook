#include <stdio.h>
#include <string.h>
#define MAX_INDENT 100
static char indentStr[MAX_INDENT+1];
static char* repeatChr(int count, char c)
{
  if (count>MAX_INDENT) count=MAX_INDENT;
  memset(indentStr,c,count);
  indentStr[count]=0;
  return indentStr;
};

main()
{
  printf(">%s<\n",repeatChr(5,'*'));
}
