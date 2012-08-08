obj_base := foo
obj-m := $(obj_base).o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
clean:
	rm -f *.o *.ko *.mod.c *.ko.unsigned modules.order  Module.symvers
