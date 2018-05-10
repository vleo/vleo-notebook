# Keiser keyboard cable pinout:
# 1 - VCC 5V
# 2 - GND
# 3 - CLK : Clock transition L to H shifts right
# 4 - PL : Parallele load active L
# 5 - Q7 : shift register output
# based on 74HC16D IC

# Labjack-U3-HV connections:
# FIO4 - CLK
# FIO5 - PL
# FIO6 - Q7

import u3
d=u3.U3()

def readSensors(d):
  d.setFIOState(5,0) # load parallel data
  d.setFIOState(5,1)
  l=[]
  for i in range(8):
    l.append(d.getFIOState(6)) # read shift out bit
    d.setFIOState(4,0) # shift to the right
    d.setFIOState(4,1)
  return l

def readSensCycle(d):
  while True:
    sleep(0.1)
    print(readSensors(d),end="\r")

readSensCycle(d)
