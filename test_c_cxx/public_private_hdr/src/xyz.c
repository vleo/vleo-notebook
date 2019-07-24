#include <stdlib.h>
#include "xyz.h"

struct xyz
{ int i; 
};

xyz_t* xyz_constr()
{
  xyz_t *this = malloc(sizeof(xyz_t));
  this->i=1234;
  return this;
}

int xyz_get_i(xyz_t *this)
{
  return this->i;
}

