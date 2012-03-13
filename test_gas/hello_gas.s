	.file	"hello_gas.c"
	.text
	.type	do_write_trap, @function
do_write_trap:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %ecx
	movl	16(%ebp), %edx
	movl	%edx, -12(%ebp)
	movl	-8(%ebp), %ebx
	movl	-12(%ebp), %edx
#APP
# 6 "hello_gas.c" 1
	movl $4, %eax
	int $0x80
	
# 0 "" 2
#NO_APP
	addl	$8, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	do_write_trap, .-do_write_trap
.globl hwStr
	.section	.rodata
.LC0:
	.string	"Hello, world!\n"
	.data
	.align 4
	.type	hwStr, @object
	.size	hwStr, 4
hwStr:
	.long	.LC0
	.text
.globl main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$16, %esp
	movl	hwStr, %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, %edx
	movl	hwStr, %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	do_write_trap
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.4.3 20100127 (Red Hat 4.4.3-4)"
	.section	.note.GNU-stack,"",@progbits
