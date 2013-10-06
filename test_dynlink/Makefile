main : main.o libmylib.so.1

libmylib.so.1: libmylib.so.1.0
	ln -s  libmylib.so.1.0 libmylib.so.1

libmylib.so.1.0 : mylib.o
	gcc -shared -Wl,-soname,libmylib.so.1 -o libmylib.so.1.0 mylib.o

mylib.a :  mylib.o
	ar cr mylib.a mylib.o

clean:
	@rm -f *.o main libmylib.so.1.0 mylib.a libmylib.so.1 mylib.s
