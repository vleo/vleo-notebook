#include <stdio.h>

#ifdef TD
typedef struct {
   int    x123;
   int    y124;
	 union {
	 int a125;
	 int b12;
	 };
} point;
#else
struct point {
   int    x123;
   int    y124;
	 union {
	 int a125;
	 int b126;
	 };
};
#endif

#ifdef TD
void point_print(point p)
#else
void point_print(struct point p)
#endif
{
  printf("p.x:%d p.y:%d p.a:%d\n",p.x123,p.y124,p.a125);
}
 
int
main(int argc, char **argv)
{

#ifdef TD
point p1 = {1,2};
point p2 = {.y124 = 20, .x123 = 10, .b126=33};
#else
//struct point p1 = {1,2};
//struct point p2 = {.y124 = 20, .x123 = 10, .b126=33};
//struct point p2 = {.y124 = 20, .x123 = 10};
struct point p1;
struct point p2;
p2.b126=33;
#endif

point_print(p1);
point_print(p2);

return 0;

}

/*
  PEP-7  
Local variables:
c-basic-offset: 4
indent-tabs-mode: nil
End:
*/
