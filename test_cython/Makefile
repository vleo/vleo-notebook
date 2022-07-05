BASENAME=test_clibiface

CFLAGS='-O0 -w'

CYTHON_MODULE_LIB=$(BASENAME).cpython-37m-x86_64-linux-gnu.so

all: $(CYTHON_MODULE_LIB)

$(CYTHON_MODULE_LIB): pysetup.py $(BASENAME).pyx
	BASENAME=$(BASENAME) python3 pysetup.py build_ext --inplace

test: $(CYTHON_MODULE_LIB)
	./atoi_test.py

clean:
	rm -rf $(CYTHON_MODULE_LIB) $(BASENAME).c build
