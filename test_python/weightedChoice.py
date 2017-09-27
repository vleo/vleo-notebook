#!/usr/bin/python3

import random

def weightedChoice(choices):

   total = sum(w for (c, w) in choices)
   r = random.uniform(0, total)
   upto = 0
   for c, w in choices:
      if upto + w >= r:
         return c
      upto += w
   assert False, "Shouldn't get here"



if __name__ == '__main__':
        choices = (('a',1),('b',2),('c',4))
        print(weightedChoice(choices))

