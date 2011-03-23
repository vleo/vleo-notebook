#include <ctype.h>
#include <string.h>

char* upcaseName(const char * name)
{
#if HAVE_STRNDUP
  char *ret =strndup(name,200);
#else
  char *ret =strdup(name);
#endif
  char *c = ret;
//  c[199]=0;
   while(*c) 
     *c++ =toupper(*c);
  return ret;
}
