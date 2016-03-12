# Show all the passes that get executed
import gcc
import re

def info(object, spacing=10, collapse=1):
  """Print methods and doc strings.

  Takes module, class, list, dictionary, or string."""
  methodList = [e for e in dir(object) if e != 'fullname' and callable(getattr(object, e))]
  nonmethodList = [e for e in dir(object) if e != 'fullname' and not callable(getattr(object, e))]
  processFunc = collapse and (lambda s: " ".join(s.split())) or (lambda s: s)
  print "\n".join(["%s %s" %
           (method.ljust(spacing),
            processFunc(str(getattr(object, method).__doc__)))
           for method in methodList])
  print nonmethodList

def showMethods(a):
  methodList = [method for method in dir(a) if hasattr(a,method) and callable(getattr(a, method))]
  print methodList
  nonMethodList = [method for method in dir(a) if hasattr(a,method) and not callable(getattr(a, method))]
  for atr in  nonMethodList:
    print atr,"=>",getattr(a,atr)

def my_pass_execution_callback(decl,*args, **kwargs):
  print decl.__class__
  #decl.debug()
  info(decl)
  if isinstance(decl,gcc.FunctionDecl):
    print "func ",decl.name,":", re.match(r'(.*)<T',str(decl.type)).group(1)
    args=decl.arguments
    for a in args:
      print "\t",a.name, ":", a.type

gcc.register_callback(gcc.PLUGIN_PRE_GENERICIZE, my_pass_execution_callback)
gcc.register_callback(gcc.PLUGIN_FINISH_DECL, my_pass_execution_callback)
