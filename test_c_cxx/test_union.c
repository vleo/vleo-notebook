#include <stdio.h>

#pragma __packed__
union MY_PAGE_ENTRY_s {
  char c4[4];
  long int l4;
}; 

typedef union MY_PAGE_ENTRY_s  MY_PAGE_ENTRY;

typedef MY_PAGE_ENTRY MY_PAGE[4];

#define WHATEVER  '\xAB'
#define BAR  '\xEF'

#define IPE(w) printf("%c %c\n",w) 


main()
{
  MY_PAGE_ENTRY v = { .c4[0] = WHATEVER, .c4[1] = 'A', .c4[2] = 'B', .c4[3]= BAR };

  printf("%d %c %c %c %c %x\n",sizeof(v.l4), v.c4[0], v.c4[1], v.c4[2], v.c4[3], v.l4);
//  printf("%d %c %c %c %c %x\n",sizeof(v.l4), v1[0].s4.s1[0], v1[0].s4.s1[1], v1[0].s4.s1[2], v1[0].s4.s1[3], v1[0].l4);
  
}
