.data
str: .asciz "Hello! !eybdooG"
rev: .space rev - str
size: .long rev - str
output: .asciz "str = %s\nrev = %s\n"
.text
.globl main
main:
	mov $str, %esi
	mov $rev, %edi
	addl size, %edi
	sub $1, %edi
	movb $0, (%edi)
	sub $1, %edi
loop2:
	movb (%esi), %bl
	cmp $0, %bl
	je end
	movb %bl, (%edi)
	add $1, %esi
	sub $1, %edi
	jmp loop2
end:
	pushl $rev
	pushl $str
	pushl $output
	call printf

	pushl $0
	call exit
