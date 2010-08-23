#define _LARGEFILE64_SOURCE
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


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
    position += 1; \
    SEEK_TO_BLK(fd,position); \
  }

#define WRITE_BLK(fd,buf) \
  if (write (fd, buf, BLKSZ) != BLKSZ) \
  { \
    fprintf (stderr, "write error %m at position %lld\n", position);\
    exit (13);\
  }

#define BLKSZ 512

#define BLOCK_NUMBER atoll(argv[1])
#define FILE1 argv[2]

int main (int argc, char **argv)
{
  unsigned char buf[BLKSZ];
  long long int position = BLOCK_NUMBER;
  long long int ret;

  OPEN_FD (fd1, FILE1, O_RDONLY);
  SEEK_TO_BLK (fd1, position);

  do
  {
    READ_BLK(fd1,buf);
    position += 1;
  }
  while( 
    ! (
    buf[0] == 0x49 &&
    buf[1] == 0x49 &&
    buf[2] == 0x2a &&
    buf[3] == 0x00 &&
    buf[4] == 0xd0 &&
    buf[5] == 0x25 &&
    buf[6] == 0x05 &&
    buf[7] == 0x00 &&

    buf[8] == 0x81 &&
    buf[9] == 0xff &&
    buf[10] == 0x81 &&
    buf[11] == 0xff &&
    buf[12] == 0x81 &&
    buf[13] == 0xff &&
    buf[14] == 0x81 &&
    buf[15] == 0xff
    )
  );
  printf ("offset[blk512]=%lld\n",lseek64(fd1,0,SEEK_CUR)/512-1);

  close(fd1);

  return 0;
}
