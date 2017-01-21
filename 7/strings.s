.data
	HelloWorldString:
		.asciz "Hello World of Assembly!"
	H3ll0:
		.asciz "H3110"
.bss
	.lcomm Destination, 100
	.lcomm DestinationUsingRep, 100
	.lcomm DestinationUsingStos, 100
.text
	.globl _start
	_start:
		nop
		#1 Simple copying using movsb, movsw, movsl

		movl $HelloWorldString, %esi
		movl $Destination, %edi

		movsb
		movsw
		movsl

		#2 Setting /clearing the DF flag

		std # set DF
		cld # clear DF

		#3 using Rep

		movl $HelloWorldString, %esi
		movl $DestinationUsingRep, %edi
		movl $25, %ecx # set the string length in ECX
		cld # clear th DF
		rep movsb
		std

		#4 Loading string from memory into EAX register
		cld
		leal HelloWorldString, %esi
		lodsb
		movb $0, %al
		
		dec %esi
		lodsw
		movw $0, %ax

		subl $2, %esi # make ESI point back to the original string
		lodsl

		#5 storing strings from EAX to memory
		leal DestinationUsingStos, %edi
		stosb
		stosw
		stosl

		#6 comparing strings

		cld
		leal HelloWorldString, %esi
		leal H3ll0, %edi
		cmpsb
		
		dec %esi
		dec %edi
		cmpsw

		subl $2, %esi
		subl $2, %edi
		cmpsl

		movl $1, %eax
		movl $0, %ebx
		int $0x80
