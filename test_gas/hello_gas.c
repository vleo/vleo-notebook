#include "string.h"

static inline void do_write_trap(int fd, const void *buf, unsigned long count)
{
/*  __asm__ __volatile__ (*/
  asm(
 "movl $4, %%eax\n\t"
 "int $0x80\n\t"
        :
        : "ebx" (fd) ,"ecx" (buf),"edx" (count)
        : "eax"
  );

}

char *hwStr="Hello, world!\n";

main()
{

  do_write_trap(1,hwStr,strlen(hwStr));
}
