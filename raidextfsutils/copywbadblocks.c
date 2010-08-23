#define _LARGEFILE64_SOURCE
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXBLOCK (long long)475540065*2
//#define SKIPTOBLK (long long)619413688
#define SKIPTOBLK (long long) 0

int main(int argc,char **argv)
{
  unsigned char buf[512];
  long long int position=0;
  long long int ret;

  int fd1 = open("/dev/sdb4",O_RDONLY);
  if (fd1<0) {fprintf(stderr,"line %d:%m\n",__LINE__);exit(10);};
  position=SKIPTOBLK;
  ret=lseek64(fd1,SKIPTOBLK*512,SEEK_SET);
  if (ret != SKIPTOBLK*512)
    {fprintf(stderr,"line %d:%m\n",__LINE__);exit(15);};

//  int fd2 = open("sdc4_b.img",O_WRONLY | O_CREAT | O_TRUNC,0644);
  int fd2 = open("sdc4_b.img",O_WRONLY | O_CREAT,0644);
  if (fd2<0) {fprintf(stderr,"line %d:%m\n",__LINE__);exit(11);};
  ret=lseek64(fd2,SKIPTOBLK*512,SEEK_SET);
  if (ret != SKIPTOBLK*512)
    {fprintf(stderr,"line %d:%m\n",__LINE__);exit(16);};

  do
  {
    if(read(fd1,buf,512) != 512)
    {
      fprintf(stderr,"!");fflush(stderr);
      printf("BAD BLOCK POS: %lld\n",position);fflush(stdout);
      memset(buf,'\0',512);
      ret=lseek64(fd1,512,SEEK_CUR);
      if (ret != position*512+512)
        {fprintf(stderr,"line %d:%m expect %lld got %lld\n",__LINE__,position*512,ret);exit(17);};
    }
    if(write(fd2,buf,512) != 512)
      {
         fprintf(stderr,"write error %m on position %lld\n",position);
         exit(13);
      }
    if(position % (1024*1024*1024/512) == 0) 
      { fprintf(stderr,"%lld ",position >> 21 ); fflush(stderr); }
    position++;
  }
  while(position < MAXBLOCK);
  return 0;
}
