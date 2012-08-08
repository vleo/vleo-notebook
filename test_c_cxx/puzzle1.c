#include <stdio.h>
int main()
{
  const char *cardsp = "JQK";
  char cards[4];
  strcpy(cards,cardsp);
  char a_card = cards[2];
  cards[2] = cards[1];
  cards[1] = cards[0];
  cards[0] = cards[2];
  cards[2] = cards[1];
  cards[1] = a_card;
  puts(cards);
  return 0;
}

