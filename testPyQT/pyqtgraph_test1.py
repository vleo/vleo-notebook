from numpy import *

from math import *

import pyqtgraph as pg

##### Input Variables

a=7  # semi axis X value

b=2  # semi axis Y value

n=30 # number of ellipses

#####################

window=pg.plot(title="Concentric Ellipses") #Creates plot window called window

alpha=linspace(0,2*pi) # Creates line matrix with values from 0 to 2*pi

SA=size(alpha) # Gets the size of alpha matrix

E=zeros([2,SA]) # Creates a 2xSA matrix filled with zeros

for i in range(SA): # Gets X,Y values of the ellipse and stores them in E
  E[0,i]=a*cos(alpha[i])
  E[1,i]=b*sin(alpha[i])

beta=0 # Ellipse angle variable inicialization

for i in range(n): # Generates n concentric ellipses angled pi/n radians

  TM=[[cos(beta),-sin(beta)],[sin(beta),cos(beta)]] # Transformation matrix

  RE=dot(TM,E) # RE contains the coordinates of the rotated ellipse

  REX=RE[0,:] # RE X values extraction
  REY=RE[1,:] # RE Y values extraction

  window.plot(REX,REY) # Plots the current rotated ellipse

  beta+=pi/n # Increases beta by pi/n steps

input('Press a key to exit')
