.data
	number: .asciz "%d"
	number_space: .asciz "%d "
	number_3: .asciz "%d%d%d"
	newline: .asciz "\n"
	size: .long 0
	req: .long 0
	.set maxsize, 100
	nodelens: .space 4 * maxsize
	mat: .space 4 * maxsize * maxsize
	tmp1: .space 4 * maxsize * maxsize
	tmp2: .space 4 * maxsize * maxsize
	path_len: .long 0
	path_bgn: .long 0
	path_end: .long 0
.text
.globl main

# void matrix_mult(int *m1, int *m2, int *mres, int size)
matrix_mult:
	push %ebp
	mov %esp, %ebp
	sub $8, %esp
	push %ebx
	push %esi
	push %edi
	mov 20(%ebp), %edx # edx = size, RESTORE AFTER MULTIPLYING

	movl $0, -4(%ebp)
	loop_m1: # loop over x / -4(%ebp)
		movl $0, -8(%ebp)
		loop_m2: # loop over y / -8(%ebp)
			xor %ecx, %ecx
			movl -4(%ebp), %eax
			mul %edx
			addl -8(%ebp), %eax
			movl 16(%ebp), %edi
			lea (%edi,%eax,4), %edi # edi = mres[x * size + y]
			movl $0, (%edi) # mres[x * size + y] = 0
			movl 8(%ebp), %ebx
			subl -8(%ebp), %eax
			lea (%ebx,%eax,4), %ebx # ebx = m1[x * n + 0]
			movl 12(%ebp), %esi
			movl -8(%ebp), %eax
			lea (%esi,%eax,4), %esi # esi = m2[0 * n + y]
			movl 20(%ebp), %edx # restore edx to size

			loop_mres: # lp over z / %ecx
				# mres[x * size + y] += m1[x * n + z] * m2[z * n + y]
				movl (%ebx), %eax
				mull (%esi)
				addl %eax, (%edi)
				mov 20(%ebp), %edx
				inc %ecx
				add $4, %ebx
				lea (%esi, %edx, 4), %esi
				cmp %ecx, %edx
				jg loop_mres
			incl -8(%ebp)
			cmp -8(%ebp), %edx
			jg loop_m2
		incl -4(%ebp)
		cmp -4(%ebp), %edx
		jg loop_m1

 	pop %edi
	pop %esi
	pop %ebx
	add $8, %esp
	pop %ebp
	ret

main:
	push %ebp
	mov %esp, %ebp
	sub $4, %esp

	pushl $req
	pushl $number
	call scanf
	add $8, %esp

	cmpl $1, req
	je req_is_ok
	cmpl $2, req
	je req_is_ok
	jmp exit_error
	req_is_ok:

	pushl $size
	pushl $number
	call scanf
	add $8, %esp

	cmpl $maxsize, size
	ja exit_error

	cmpl $0, size
	je exit_error

	mov $nodelens, %esi
	mov size, %edi
	lea (%esi,%edi,4), %edi
	read_nodelens:
		pushl %esi
		pushl $number
		call scanf
		addl $8, %esp

		add $4, %esi
		cmp %esi, %edi
		ja read_nodelens

	xor %ebx, %ebx
	xor %edi, %edi
	lea -4(%ebp), %eax
	push %eax # will scanf into this local a bunch of times
	push $number
	read_edges_outer: # do while ebx < size
		mov nodelens(,%ebx,4), %esi
		read_edges_inner: # while esi
			cmp $0, %esi
			jbe read_edges_inner_exit

			call scanf # read into the local
			mov -4(%ebp), %eax # eax = node
			add %edi, %eax # eax = node + x * size
			movl $1, mat(,%eax,4)

			sub $1, %esi
			jmp read_edges_inner
		read_edges_inner_exit:

		add size, %edi
		add $1, %ebx
		cmp %ebx, size
		ja read_edges_outer
	addl $8, %esp

	# edi == size * size
	cmpl $2, req
	je calc_paths
	xor %esi, %esi
	print_matrix:
		xor %ebx, %ebx
		print_matrix_line: # do while ebx < size
			lea (%ebx,%esi,1), %eax
			movl mat(,%eax,4), %eax
			push %eax
			push $number_space
			call printf
			add $8, %esp

			add $1, %ebx
			cmp %ebx, size
			ja print_matrix_line

		pushl $newline
		call printf
		add $4, %esp

		add size, %esi
		cmp %esi, %edi
		ja print_matrix

	jmp exit_normal

	calc_paths:
	pushl $path_end
	pushl $path_bgn
	pushl $path_len
	pushl $number_3
	call scanf
	add $16, %esp
	mov %edi, %eax # eax = size * size
	mov $tmp1, %esi # this is the last step
	mov $tmp2, %edi # this will be the next step
	xor %ecx, %ecx
	identity_matrix:
		movl $1, (%esi,%ecx,4)
		# ecx == i * size + i
		add size, %ecx
		inc %ecx
		cmp %ecx, %eax
		jg identity_matrix
	xor %ebx, %ebx
	raise_to_pow:
		push size
		push %edi
		push $mat
		push %esi
		call matrix_mult
		addl $16, %esp
		xchg %esi, %edi
		inc %ebx
		cmp %ebx, path_len
		jg raise_to_pow
	mov path_bgn, %eax
	mull size
	add path_end, %eax
	push (%esi, %eax, 4)
	push $number
	call printf
	add $8, %esp
	pushl $newline
	call printf
	add $4, %esp
	jmp exit_normal

exit_normal:
	mov %ebp, %esp # clear everything from the stack
	pop %ebp
	push $newline
	call printf # make sure output is flushed
	add $4, %esp
	push $0
	call exit # exit should flush stdout

exit_error:
	pushl $1
	call exit

