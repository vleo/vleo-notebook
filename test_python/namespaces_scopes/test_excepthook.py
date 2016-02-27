import sys
import traceback

def myExcepthook(cls,val,tb):
#    print("myExcepthook: type {} value {} traceback {}".format(cls,val,tb))
    (file,line,func,text) = traceback.extract_tb(tb)[-1]
    file = file.split('/')[-1]
    ename=cls.__name__

    print("{} in file {} line {}:\n\t{}".format(ename,file,line,val))

sys.excepthook=myExcepthook

raise Exception("This is so funny",123,("no","way"))