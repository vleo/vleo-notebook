from multiprocessing import Process,Queue
import os

class TestMP:
    def __init__(self,n):
        self.n = n

    @staticmethod
    def worker(q):
        """worker function"""
#        print('worker',*args)
#        print("ppid= {} pid= {}".format(os.getppid(),os.getpid()))
        q.put([1,'x',(os.getpid(),[])])

        return

    def main(self):
        if __name__ == '__main__':
            jobs = []
            for i in range(self.n):
                q = Queue()
                p = Process(target=self.worker,args=(q,))
                jobs.append((p,q))
                p.start()
            for i in range(self.n):
                j=jobs.pop(0)
                j[0].join()
                msg = j[1].get()
                print("job no {} ended, msg: {}".format(i,msg))

m=TestMP(10)

m.main()
