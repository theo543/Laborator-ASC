.data
x: .long 2
y: .long 31
z: .long 121
min: .space 4
str: .asciz "The biggest number is %d\n"
.text
.globl printf
.globl main
main:
	mov x, %eax
	mov y, %ebx
	mov z, %ecx
	cmp %eax, %ebx
	cmovg %ebx, %eax
	cmp %eax, %ecx
	cmovg %ecx, %eax
	mov %eax, min
	
	push min
	push $str
	call printf
	mov $1, %eax
	mov $0, %ebx
	int $0x80

