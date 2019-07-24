FLAGS = $(shell gnustep-config --objc-flags)
LIBS = $(shell gnustep-config --base-libs)

test: test1.m
	$(CC) $< $(FLAGS) $(LIBS) -o $@

clean:
	rm -rf test test.d
