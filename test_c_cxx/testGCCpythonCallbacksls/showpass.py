# Show all the passes that get executed
import gcc
import re

def showMethods(a):
	methodList = [method for method in dir(a) if hasattr(a,method) and callable(getattr(a, method))]
	print methodList
	nonMethodList = [method for method in dir(a) if hasattr(a,method) and not callable(getattr(a, method))]
	for atr in  nonMethodList:
		print atr,"=>",getattr(a,atr)

def my_pass_execution_callback(decl,*args, **kwargs):
	print decl.__class__
	if isinstance(decl,gcc.FunctionDecl):
		print "func ",decl.name,":", re.match(r'(.*)<T',str(decl.type)).group(1)
		#	showMethods(decl.type)
		args=decl.arguments
		for a in args:
			print "\t",a.name, ":", a.type

gcc.register_callback(gcc.PLUGIN_PRE_GENERICIZE, my_pass_execution_callback)
gcc.register_callback(gcc.PLUGIN_FINISH_DECL, my_pass_execution_callback)
