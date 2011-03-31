CC=i686-pc-mingw32-gcc-4.4.1
#CC=gcc
CCFLAGS=-Wl,--enable-runtime-pseudo-reloc-v2,--enable-auto-import
#CCFLAGS=-Wl,--enable-runtime-pseudo-reloc,--enable-auto-import

all:
	$(CC) $(CCFLAGS) -shared -o dll1.dll dll1.c
	$(CC) $(CCFLAGS) -shared -o dll2.dll dll2.c dll1.dll -O2
	$(CC) $(CCFLAGS) -o main.exe main.c dll1.dll dll2.dll
clean:
	rm *.dll main.exe
