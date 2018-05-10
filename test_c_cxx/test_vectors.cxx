#include <stdio.h>

typedef int v4si __attribute__ ((vector_size (16)));

union Vec4 {
    v4si v;
    int e[4];
};

main() {

  Vec4 vec;
  vec.v = (v4si){1,2};

  for (const int i : vec.e) {
    printf("%d\n",i);
  }


}

