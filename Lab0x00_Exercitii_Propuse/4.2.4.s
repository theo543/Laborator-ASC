.data
x: .long 23
x_sqrt: .long 0
scanstr: .asciz "%d"
l1f: .asciz "Check 1: not prime\n"
l1s: .asciz "Check 1: prime\n"
l2f: .asciz "Check 2: not prime\n"
l2s: .asciz "Check 2: prime\n"
.text
.globl main
main:
	push $x
	push $scanstr
	call scanf
	addl $8, %esp

	finit
	fildl x
	fsqrt
	fistl x_sqrt

	mov x_sqrt, %eax
	add $1, %eax
	mov x, %ebx
	mov x_sqrt, %ecx
	cmp %eax, %ebx
	cmovne %eax, %ecx
	mov %ecx, x_sqrt


	# check 1

	mov $2, %ecx
	mov x, %ebx
	mov x_sqrt, %edi
	mov $0, %esi

	loop1:
	cmp %ecx, %edi
	jle loop1success
	movl %ebx, %eax
	movl $0, %edx
	div %ecx
	cmp %edx, %esi
	je loop1fail
	addl $1, %ecx
	jmp loop1
	loop1fail:
	push $l1f
	jmp loop1end
	loop1success:
	push $l1s
	loop1end:
	call printf
	addl $4, %esp

	# check 2

	mov x_sqrt, %ecx
	mov x, %ebx
	mov $0, %esi

	loop2:
	mov %ebx, %eax
	mov $0, %edx
	div %ecx
	cmp %edx, %esi
	je loop2end
	loop loop2
	loop2end:

	mov $1, %esi
	mov $l2f, %eax
	mov $l2s, %ebx
	cmp %ecx, %esi
	cmove %ebx, %eax
	push %eax
	call printf

	mov $1, %eax
	mov $0, %ebx
	int $0x80

