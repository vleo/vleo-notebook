#define _LARGEFILE64_SOURCE
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BLKSZ 512

#define OPEN_FD(fd,name,mode) \
   int fd = open(name,mode); \
   if (fd<0) {fprintf(stderr,"line %d:%m\n",__LINE__);exit(10);}

#define SEEK_TO_BLK(fd,pos) \
  ret=lseek64(fd,pos*BLKSZ,SEEK_SET); \
  if (ret != pos*BLKSZ) \
    {fprintf(stderr,"line %d:%m\n",__LINE__);exit(15);}

#define READ_BLK(fd,buf) \
  if (read (fd, buf, BLKSZ) != BLKSZ) \
  { \
    fprintf (stderr, "read error %m at position %lld\n", position);\
    exit (13);\
  }

#define WRITE_BLK(fd,buf) \
  if (write (fd, buf, BLKSZ) != BLKSZ) \
  { \
    fprintf (stderr, "write error %m at position %lld\n", position);\
    exit (13);\
  }

#define BLOCK_NUMBER atoll(argv[1])
#define FILE1 "sdc4_b.1.img"
#define FILE2 "sdc4_b.3.img"

int main (int argc, char **argv)
{
  unsigned char buf[BLKSZ];
  long long int position = BLOCK_NUMBER;
  long long int ret;

  OPEN_FD (fd1, FILE1, O_RDONLY);
  SEEK_TO_BLK (fd1, position);

  OPEN_FD (fd2, FILE2, O_WRONLY);
  SEEK_TO_BLK (fd2, position);

  memset(buf,0,BLKSZ);
  READ_BLK(fd1,buf);
  WRITE_BLK(fd2,buf);

  close(fd1);
  close(fd2);

  return 0;
}
