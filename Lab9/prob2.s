.data
format: .asciz "%s"
hw: .asciz "Hello World!\n"
input: .space 300
freq: .space 26
term: .asciz ""
out: .asciz "A\n" # to be changed in loop
.text
.globl main
main:
	pushl $input
	pushl $format
	call scanf

	mov $0, %ecx

	mov $freq, %esi
	init_freq:
	mov $26, %ebx
	cmp %ecx, %ebx
	je ex_init_freq
	movb $0, (%esi, %ecx, 1)
	inc %ecx
	jmp init_freq
	ex_init_freq:

	mov $0, %ecx
	mov $input, %esi
	mov $freq, %edi
	read_input:
	movb (%esi, %ecx, 1), %bl
	cmpb $0, %bl
	je ex_read_input
	subb $'a', %bl
	incb (%edi,%ebx,1)
	inc %ecx
	jmp read_input
	ex_read_input:

#	pushl $input
#	call printf

	mov $0, %ecx
	mov $freq, %esi
	print_freqs:
	movb (%esi,%ecx, 1), %bl
	cmpb $2, %bl
	jne skip_output
	movb %cl, %bl
	addb $'a', %bl
	movb %bl, (out)
	pushl %ecx
	pushl %esi
	pushl $out
	call printf
	popl %eax
	popl %esi
	popl %ecx

	skip_output:
	inc %ecx
	cmp $26, %ecx
	je exit_program
	jmp print_freqs

	exit_program:
	pushl $input
	call exit

