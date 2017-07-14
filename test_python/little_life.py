#!/usr/bin/python
import time

class World:
  def __init__(self,w,h,b0=None):
    self.board = []
    self.boardNext = []
    self.t = 0
    self.h = h
    self.w = w
    for y in range(h):
      self.board.append([])
      self.boardNext.append([])
      for x in range(w):
        self.board[y].append(0)
        self.boardNext[y].append(0)
        if b0:
          self.board[y][x] = b0[y][x]

  def __repr__(self):
    viewOut=""
    for y in range(self.h):
      for x in range(self.w):
        viewOut += " *" if self.board[y][x] else " ."
      viewOut += "\n"
    return viewOut

  def nextGen(self):
    for y in range(self.h):
      for x in range(self.w):
        self.boardNext[y][x] = self.nextCellGen(x,y)
    self.boardTmp = self.board
    self.board = self.boardNext
    self.boardNext = self.boardTmp
    self.t += 1

  def nextCellGen(self,x,y):
    sigma = 0
    for dy in range(-1,2):
      for dx in range(-1,2):
        if dx == 0 and dy == 0:
          pass
        else:
          sigma += self.board[(y+dy) % self.h][(x+dx) % self.w]
    # sigma - число живых соседей у клетки(x,y)
    if self.board[y][x] == 1:
      # живая клетка
      if sigma > 3 or sigma < 2:
        return 0
      else:
        return 1
    else:
      # мертвая клетка
      if sigma == 3:
        return 1
      else:
        return 0

  def rpentamino(self):
    self.board[3][2]=1; self.board[4][4]=1;
    for i in range(3,6): self.board[i][3]=1;



  def planer7(self):
      for i in range(3,7): self.board[10][i]=1;
      self.board[9][2]=1;
      self.board[9][6]=1;
      self.board[8][6]=1;
      self.board[7][5]=1;

  def runView(self, n=100,timeout=0.25):
    for i in range(n):
        self.nextGen()
        print(self.t)
        print(self)
        time.sleep(timeout)
