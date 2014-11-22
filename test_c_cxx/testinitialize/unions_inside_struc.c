#include <inttypes.h>
#include <stdio.h>

struct a_t {
  uint16_t a;
  uint16_t b;
  union {
      uint8_t c;
    uint16_t d;
  };
};

#if (1)
struct a_t alfa = {
  .a = 1,
  .b = 2,
  .c = 3, //Will not work
};
#elif (0)
struct a_t alfa = {
  .a = 1,
  .b = 2,
  {.c = 3}, //works
};
#elif (0)
struct a_t alfa = {
  .a = 1,
  {.c= 2}, //Does not work
  .b = 3,
}
#endif

int main(void)
{
  //alfa.c = 4;
  //alfa.d = 5;
  printf("%20s:%d\n","alfa.a",alfa.a);
  printf("%20s:%d\n","alfa.b",alfa.b);
  printf("%20s:%d\n","alfa.c",alfa.c);
  printf("%20s:%d\n","alfa.d",alfa.d);
 return 0; 
}
