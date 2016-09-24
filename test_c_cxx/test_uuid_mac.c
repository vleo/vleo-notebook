#include <uuid/uuid.h>
#include <stdio.h>

main()
{

  uuid_t out;
  char s[200];

  uuid_generate_time(out);
  uuid_unparse(out,s);

  printf("%s\n",s);

  sprintf(s, "%02x:%02x:%02x:%02x:%02x:%02x",out[10],out[11],out[12],out[13],out[14],out[15]);

  printf("%s\n",s);

}

