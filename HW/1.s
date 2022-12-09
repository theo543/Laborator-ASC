.data
	number: .ascii "%d\0\0"
	size: .long 0
	req: .long 0
	.set maxsize, 100
	nodelens: .space maxsize
	mat: .space maxsize * maxsize
.text
.globl main

main:
	push %ebp
	mov %esp, %ebp
	sub $4, %esp

	pushl $req
	pushl $number
	call scanf

	cmpl $1, req
	jne exit_error

	movl $size, 4(%esp)
	call scanf

	cmpl $maxsize, size
	ja exit_error

	mov $nodelens, %esi
	mov size, %edi
	lea (%esi,%edi,4), %edi
	read_nodelens:
		movl %esi, 4(%esp)
		call scanf

		add $4, %esi
		cmp %esi, %edi
		ja read_nodelens

	xor %ebx, %ebx
	xor %edi, %edi
	lea (%ebp), %eax
	mov %eax, 4(%esp)
	read_edges_outer: # do while ebx < size
		mov nodelens(,%ebx,4), %esi
		read_edges_inner: # while esi
			cmp $0, %esi
			jbe read_edges_inner_exit

			call scanf
			mov (%ebp), %eax # eax = node
			add %edi, %eax # eax = node + x * size
			movl $1, mat(,%eax,4)

			sub $1, %esi
			jmp read_edges_inner
		read_edges_inner_exit:

		add size, %edi
		add $1, %ebx
		cmp %ebx, size
		ja read_edges_outer

	# edi == size * size

	movb $' ', number+2

	xor %esi, %esi

	print_matrix:
		xor %ebx, %ebx
		print_matrix_line: # do while ebx < size
			lea (%ebx,%esi,1), %eax
			movl mat(,%eax,4), %eax
			mov %eax, 4(%esp)
			call printf

			add $1, %ebx
			cmp %ebx, size
			ja print_matrix_line

		pushl $'\n'
		call putchar
		add $4, %esp

		add size, %esi
		cmp %esi, %edi
		ja print_matrix

	add $12, %esp
	pop %ebp
exit_normal:
	pushl $0
	call exit

exit_error:
	pushl $1
	call exit

