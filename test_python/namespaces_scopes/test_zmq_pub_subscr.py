import sys
import zmq
from  multiprocessing import Process
import time
import pickle

pubSubscAddr = "ipc:///tmp/ngc_guiPSServ"

def worker():
    context = zmq.Context()
    socket = context.socket(zmq.SUB)
    socket.connect(pubSubscAddr)
    socket.setsockopt(zmq.SUBSCRIBE, b'')

    cmd=""
    while cmd != "exit":
      print("before recv")
      cmd,vv = socket.recv_json()
      print(cmd,vv)


def main():
    context = zmq.Context()
    socket = context.socket(zmq.PUB)
    socket.bind(pubSubscAddr)
    Process(target=worker, args=()).start()

    time.sleep(1)
    print("before send")
    socket.send_json(("xyz",123))
    print("after send")
    socket.send_json(("exit",0))
    print("after send1")

if __name__ == "__main__":
    main()
