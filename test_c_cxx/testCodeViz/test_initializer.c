#include <stdio.h>

typedef struct {
   int    x;
   int    y;
} point;

void point_print(point p)
{
  printf("p.x:%d p.y:%d\n",p.x,p.y);
}
 
main()
{
point p1 = {1,2};

point p2 = {.y = 20, .x = 10};

point_print(p1);
point_print(p2);

}
