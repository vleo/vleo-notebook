GTK_INCLUDE = -I/usr/include/gtk-2.0 -I/usr/include/glib-2.0/ -I/usr/lib64/glib/include/
GTK_LIB = -L/usr/local/lib
X11_LIB = -L/usr/X11R6/lib
CC = gcc -g -Wall
CFLAGS = $(GTK_INCLUDE)
LDFLAGS = $(GTK_LIB) $(X11_LIB) -lgtk -lgdk -lglib -lX11 -lXext -lm

#EXEC = helloworld 
EXEC2 = gtkplus_hellow_world

#$(EXEC): helloworld.o

$(EXEC2): $(EXEC2).o
	$(CC) $(GTK_LIB) $(X11_LIB) $(OBJS) -o $(EXEC2) $(LDFLAGS)

clean:
	rm -f *.o *~ $(EXEC1) $(EXEC2)
