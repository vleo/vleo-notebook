#!/usr/bin/python
# -*- coding: utf-8 -*-     
from setupcon import setup_console
setup_console('utf-8',False)
# Guess the number game

import random
     
def main(max):
	print "\tФедор, добро пожаловать в игру 'Угадай число'!"
	print "\nЯ задумал число между 1 и 20."
	print "Угадай число за меньшее число попыток.\n"
	num = 1+random.randrange(20)
	tries = 0
	guess = -10
	while guess != -1 and guess != num:
		try:
			guess = int(raw_input("Федя, угадай число: "))
		except:
			print "Неправильное число"
			pass
			continue
		#print num," ",guess
		if guess < num:
			print "Ты набрал слишком маленькое число, Федор"
		elif guess > num:
			print "Ты набрал слишком большое число, Федор"
		tries += 1
		if tries >= max:
			print "Sorry, you took too many guesses. Game Over"
			exit()
	print "Ты угадал Федя - молодец!"
	again = raw_input("Нажмите Enter чтобы сыграть еще раз:")
	if again == "":
		main(333)
	else:
		exit()
     
main(3333)
     

