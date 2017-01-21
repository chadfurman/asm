.data
	HelloWorld:
		.asciz "Hello World!\n"
	HelloFunction:
		.asciz "Hello Function!\n"
.bss
	.lcomm StringPointer, 4
	.lcomm StringLength, 4
.text
	.globl _start
	.type Myfunction, @function
	MyFunction: # string pointer tand len to be added by caller
		movl $4, %eax
		movl $1, %ebx
		movl StringPointer, %ecx
		movl StringLength, %edx
		int $0x80
		ret
	_start:
		nop
		# print hello world string
		movl $HelloWorld, StringPointer
		movl $14, StringLength
		call MyFunction

		# print hello fucntion
		movl $HelloFunction, StringPointer
		movl $17, StringLength
		call MyFunction

	ExitCall:
		movl $1, %eax
		movl $0, %ebx
		int $0x80
