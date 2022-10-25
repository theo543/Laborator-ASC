.data
x: .long 155
y: .long 123123
nr16: .long 16
print_bad: .asciz "FAIL\n"
print_good: .asciz "PASS\n"
.text
.globl main
main:
	movl x, %ebx
	movl y, %ecx
	shrl $4, %ebx
	shll $4, %ecx

	movl x, %eax
	movl $0, %edx
	divl nr16
	cmp %eax, %ebx
	jne fail

	movl y, %eax
	mull nr16
	cmp %eax, %ecx
	jne fail

	mov $4, %eax
	mov $1, %ebx
	mov $print_good, %ecx
	mov $6, %edx
	int $0x80
	jmp exit

	fail:
	mov $4, %eax
	mov $1, %ebx
	mov $print_bad, %ecx
	mov $10, %edx
	int $0x80

	exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

