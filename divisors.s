.data
x: .long 0
zero: .long 0
two: .long 2
str: .asciz "%d"
str_out: .asciz "%d\n"
.text
.globl main
main:
	pushl $x
	pushl $str
	call scanf
	popl %eax
	popl %eax

	mov x, %eax
	mov $0, %edx
	divl two
	mov %eax, %edx
	mov $0, %ecx

lp:
	inc %ecx
	cmp %ecx, %edx
	jl ex
	pushl %ecx
	pushl %edx
	mov x, %eax
	mov $0, %edx
	div %ecx
	cmp %edx, zero
	jne cnt
	pushl %eax
	pushl $str_out
	call printf
	popl %eax
	popl %eax
cnt:
	popl %edx
	popl %ecx
	jmp lp
ex:
	pushl $0
	call exit
