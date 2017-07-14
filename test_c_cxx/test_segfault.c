int main()
{
  int *ip;
  ip = malloc(10);

  ip = ip - 100;

  *ip = 0;
}
