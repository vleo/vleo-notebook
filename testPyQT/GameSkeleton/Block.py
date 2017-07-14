#!/usr/bin/python3

class Block:
  w = 1
  h = 1
  def __init__(self,x,y):
    self.x = x
    self.y = y
    self.texture = None

class Stone(Block):

  def __init__(self,x,y):
    super(Stone, self).__init__(x,y)
    self.texture = '/home/fvleonov/My_Game/Game/Texture/Blocks/Stone.png'
  def p(y):
    if y > 20:
      return 0.3
    elif y > 5:
      return 0.8
    elif y > 3:
      return 0.5
    elif y < 3:
      return 0.1
    elif y == 0:
      return 0.0

class Dirt(Block):
  def __init__(self,x,y):
    super(Dirt, self).__init__(x,y)
    self.texture = '/home/fvleonov/My_Game/Game/Texture/Blocks/Dirt.png'
  def p(y):
    if y > 10:
      return 0.0
    elif y > 3:
      return 0.3
    elif y < 3:
      return 0.9
    elif y == 0:
      return 1.0
class Coal(Block):
  def __init__(self,x,y):
    super(Coal, self).__init__(x,y)
    self.texture = '/home/fvleonov/My_Game/Game/Texture/Blocks/Coal.png'
  def p(y):
    if y < 5:
      return 0.0
    elif y > 5:
      return 0.1
    elif y > 10:
      return 0.5
    elif y > 20:
      return 0.2
class Iron(Block):
  def __init__(self,x,y):
    super(Iron, self).__init__(x,y)
    self.texture = '/home/fvleonov/My_Game/Game/Texture/Blocks/Iron.png'
  def p(y):
    if y < 5:
      return 0.0
    elif y > 7:
      return 0.2
    elif y > 15:
      return 0.5
    elif y > 25:
      return 0.3

class Cuprum(Block):
  def __init__(self,x,y):
    super(Cuprum, self).__init__(x,y)
    self.texture = '/home/fvleonov/My_Game/Game/Texture/Blocks/Cuprum.png'
  def p(y):
    if y < 5:
      return 0.00001
    elif y > 10:
      return 0.05
    elif y > 15:
      return 0.1
    elif y > 30:
      return 0.3
    elif y > 35:
      return 0.08
class Quarts(Block):
  def __init__(self,x,y):
    super(Quartz, self).__init__(x,y)
    self.texture = '/home/fvleonov/My_Game/Game/Texture/Blocks/Quarts.png'
  def p(y):
    if y < 25:
      return 0.0
    elif y > 25:
      return 0.2
    elif y > 30:
      return 0.12
