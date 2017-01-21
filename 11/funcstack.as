.data
	HelloWorld:
		.asciz "Hello World!\n"
.text
	.globl _start
	PrintFunction:
		pushl %ebp # store current EBP on stack
		movl %esp, %ebp # make EBP point to top of stack
		
		movl $4, %eax
		movl $1, %ebx
		movl 8(%ebp), %ecx
		movl 12(%ebp), %edx
		int $0x80

		movl %ebp, %esp # restore the old value of ESP
		popl %ebp # restore old value of EBP
		ret # change EIP to start the next instruction

	_start:
		nop

		# push the strlen on the stack
		pushl $13

		# push the string pointer on the stack
		pushl $HelloWorld

		# call the function
		call PrintFunction

		# adjust stack pointer by removing our two args
		addl $8, %esp

		ExitCall:
			movl $1, %eax
			movl $0, %ebx
			int $0x80
