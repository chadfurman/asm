.data
	Newline:
		.asciz "\n"
	PromptString:
		.asciz "Please enter a string: "
	PromptStringSize:
		.int 23
	InvalidStringMessage:
		.asciz "You entered an empty string.\n"
	InvalidStringMessageSize:
		.int 29
	ValidStringMessage:
		.asciz "You entered: "
	ValidStringMessageSize:
		.int 13
	PromptCount:
		.int 10
.bss
	.lcomm PromptStringCopy, 100
	.lcomm UserString, 1000
.text
	.globl _start
	.type Write, @function
	.type ReadResponse, @function
	.type LoopPrompt, @function

	Write:
		pushl %ebp
		movl %esp, %ebp

		movl $4, %eax
		movl $1, %ebx
		movl 8(%ebp), %ecx # pointer to prompt string
		movl 12(%ebp), %edx # prompt length
		int $0x80

		movl %ebp, %esp
		popl %ebp
		ret

	ReadResponse:
		pushl %ebp
		movl %esp, %ebp

		movl $3, %eax
		movl $0, %ebx
		movl 8(%ebp), %ecx # pointer to response buffer
		movl 12(%ebp), %edx # number of characters to read in
		int $0x80

		movl %ebp, %esp
		popl %ebp
		ret
		
	LoopPrompt:
		pushl %ebp
		movl %esp, %ebp

		movl 8(%ebp), %ecx # counter
		PromptLoop:
			pushl %ecx

			pushl PromptStringSize
			pushl $PromptString
			call Write
			addl $8, %esp

			pushl $100
			pushl $UserString
			call ReadResponse 
			addl $8, %esp
			# TODO: if UserString is blank, show error and ask for another string

			movl $UserString, %esi
			movl $Newline, %edi
			cmpsb 
			jnz ValidString

			InvalidString:
				# This happens when we have no text
				pushl InvalidStringMessageSize
				pushl $InvalidStringMessage
				call Write
				addl $8, %esp
				jmp PromptLoop

			ValidString:
				# prelude to displaying user entry
				pushl ValidStringMessageSize
				pushl $ValidStringMessage
				call Write
				addl $8, %esp

				# display what the user typed
				pushl $100
				pushl $UserString
				call Write
				addl $8, %esp

			popl %ecx
		loop PromptLoop

		movl %ebp, %esp
		popl %ebp
		ret
		
		

	_start:
		nop
		# copy PromptString to PromptStringCopy
		movl $PromptString, %esi
		movl $PromptStringCopy, %edi
		movl PromptStringSize, %ecx

		pushl PromptCount
		call LoopPrompt
		add $4, %esp

	ExitCall:
		movl $1, %eax
		movl $0, %ebx
		int $0x80
