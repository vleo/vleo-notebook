import sys
import zmq
import multiprocessing as mp
import time

pubSubscAddr = "ipc:///tmp/ngc_guiPSServ"
reqRespAddr = "ipc:///tmp/ngc_guiRRServ"

class model:
  def __init__(self):
    self.context = zmq.Context()
    self.socket = self.context.socket(zmq.SUB)
    self.socket.connect(pubSubscAddr)
    self.socket.setsockopt(zmq.SUBSCRIBE, b'')

  def run(self):
    cmd=""
    while cmd != "exit":
      print(".",end="")
      sys.stdout.flush()
      if self.socket.poll(1000):
        cmd,vv = self.socket.recv_json()
        print("\n",cmd,vv)

class ReqRespClient_t:

  def __init__(self):
    self.context = zmq.Context()
    self.socket = self.context.socket(zmq.REQ)
    print("Connecting to GUI server")
    self.socket.connect(reqRespAddr)

  def set_tau(self, tau):
    self.socket.send_json(("set_tau",(tau,)))
    m=self.socket.recv()
    assert m==b"OK"

