.data
	input: .asciz "%d"
	output: .asciz "%d\n"
	input_nr: .long 0
.globl main
.text
factorial:
	push %ebp
	mov %esp, %ebp

	mov -8(%ebp), %eax
	cmp $1, %eax
	jne else
	mov $1, %eax
	jmp endif
	jmp endif
	else:
	push %eax
	subl $1, (%esp)
	call factorial
	addl $1, (%esp)
	mull (%esp)
	endif:

	pop %ebp
	ret

main:
	pushl $input_nr
	push $input
	call scanf
	add $8, %esp
	pushl input_nr
	call factorial
	add $4, %esp
	push %eax
	push $output
	call printf
	add $8, %esp
	pushl $0
	call exit
