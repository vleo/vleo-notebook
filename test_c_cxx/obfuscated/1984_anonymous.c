#include <stdio.h>
#include <unistd.h>

int i=0;
char* s ="zello, world!\n";

main () {
  while(s[i])
    write (STDERR_FILENO, &s[i++], 1);
}
