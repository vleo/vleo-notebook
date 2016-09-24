import sys
import zmq
from  multiprocessing import Process
import time
import pickle

pubSubscAddr = "ipc:///tmp/ngc_guiPSServ"
reqRespAddr = "ipc:///tmp/ngc_guiRRServ"

class Gui:

  def __init__(self):
    self.context = zmq.Context()
    self.socket = self.context.socket(zmq.PUB)
    self.socket.bind(pubSubscAddr)
    self.cb = []
    self.cb.append(lambda x: x*10)
    self.cb.append(lambda x: x*1000)

  def go(self,n):
    self.socket.send_json(("xyz",self.cb[n](7)))

  def setTau(self,v):
    self.tau=v
    print("setTau:",v)

  def reqRespServer(self):
    context = zmq.Context()
    socket = context.socket(zmq.REP)
    socket.bind(reqRespAddr)
    print("Start GUI server loop")

    while True:
      (cmd, value) = socket.recv_json()
      if cmd=="set_tau":
        (tau,)=value
        self.setTau(tau)
      socket.send(b"OK")
