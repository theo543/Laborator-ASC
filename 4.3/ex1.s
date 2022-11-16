.data
numbers: .long 9, 3, 11, 11, 3, 3, 15, 14, 14, 15, 9, 15
size: .long (size - numbers)/4
output: .asciz "Max = %d, appearing %d times\n"
.text
.globl main
main:
	mov numbers, %eax
	mov $1, %ebx
	mov $1, %ecx
	mov $numbers, %esi
lp:
	cmp %ecx, size
	jle end
	mov (%esi, %ecx, 4), %edx
	cmp %eax, %edx
	jl cnt
	je eq
	jg lt
eq:
	inc %ebx
	jmp cnt
lt:
	mov %edx, %eax
	mov $1, %ebx
cnt:
	inc %ecx
	jmp lp
end:
	pushl %ebx
	pushl %eax
	pushl $output
	call printf

	pushl $0
	call exit
