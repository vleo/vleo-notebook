#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>


main()
{
  int f = open("xyzzy", O_RDWR);

  printf("errno= %d\n",errno);
  perror("--exiting--");
}
