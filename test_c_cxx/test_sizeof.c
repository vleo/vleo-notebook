#include <stdio.h>
#include <stdint.h>
main()
{
  int8_t i8;
  int16_t i16;
  int32_t i32;
  int64_t i64;
  int s1 = sizeof i8;
  int a1 = __alignof i8;
  struct 
  {
      char f1;
      int f2;
  } s;

  printf("%d %d, %d %d, %d %d, %d %d, %d %d\n",s1,a1,sizeof i16,__alignof i16, sizeof(i32), __alignof i32, sizeof(i64), __alignof i64,sizeof s,__alignof s);
}
