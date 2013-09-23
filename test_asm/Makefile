N=hellow_world
$N : $N.s
	as $< -o $@.o
	ld -o $@ $@.o
	objdump -h -s -d $@

clean:
	rm -f $N.o $N
