SOURCES := benchaes.cpp
EXEC := benchaes
LIBS := -lssl
# Objs are all the sources, with .cpp replaced by .o
OBJS := $(SOURCES:.cpp=.o)

all: $(EXEC)

# Compile the binary 't' by calling the compiler with cflags, lflags, and any libs (if defined) and the list of objects.
$(EXEC): $(OBJS)
	$(CXX) $(CFLAGS) -o $(EXEC) $(OBJS) $(LFLAGS) $(LIBS)

# Get a .o from a .cpp by calling compiler with cflags and includes (if defined)
.cpp.o:
	$(CXX) $(CFLAGS) $(INCLUDES) -c $<

clean:
	rm -f *.o $(EXEC)

run:
	./$(EXEC) 1 60

test:
	./$(EXEC) 1 10000 | md5sum > run_$($).tmp

