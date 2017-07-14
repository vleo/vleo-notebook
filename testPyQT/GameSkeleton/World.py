#!/usr/bin/python3

import random

def weightedChoice(choices):

   total = sum(w for c, w in choices)
   r = random.uniform(0, total)
   upto = 0
   for c, w in choices:
      if upto + w >= r:
         return c
      upto += w
   assert False, "Shouldn't get here"

class World ():
	def __init__(self, Ww, Wh,rb):
		self.Ww = Ww#Ширина мира
		self.Wh = Wh#Высота мира
		self.registeredBlocks = rb
		self.m = []  #Матрица блоков

	def fillWorld():
		for y in range(self.Wh):
			choices = [(b,b.p(y)) for b in self.registeredBlocks]
			bx = []  #Список блоков по x в этом y
			for x in range(self.Ww):
					b = weightedChoice(choices)
					bx.append(b(x,y))
			self.m.append(bx)
					
						


if __name__ == '__main__':
	w = World(10,10,(Quarts,Cuprum,Iron,Coal,Stone,Dirt))

