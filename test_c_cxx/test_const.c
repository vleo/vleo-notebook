main()
{
  int i=1;
  const int j=2;    // constant var
  const int *k = &i;    // pointer to constant
  int * const l1 = &i;  // constant pointer
  int * const l2 = &i; 

   j=8;
  *k = 7;
  *l1 = 7;
   l2 = &j;
}
