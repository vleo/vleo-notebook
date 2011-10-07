#include <stdio.h>
main()
{
  char indentStr[100];
  int i = 1;
  sprintf(indentStr,"%%%ds",i);
  sprintf(indentStr,indentStr,"");
  printf(">%s<\n",indentStr);
}
