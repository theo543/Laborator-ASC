# f(1) -> stop
# f(x par) -> apel f(x/2)
# f(x impar) -> apel f(3*x + 1)
.data
    in_str: .asciz "%d"
    out_str: .asciz "%d\n"
    counter: .long 0
    input: .long 0
.text
.global main
f:
    push %ebp
    mov %esp, %ebp
    cmpl $1, 8(%ebp)
    je stop
    incl counter
    movl 8(%ebp), %edx
    mov %edx, %eax
    and $1, %eax
    cmp $0, %eax
    je even
odd:
    lea 1(%edx, %edx, 2), %edx
    push %edx
    call f
    pop %edx
    jmp stop
even:
    shr $1, %edx
    push %edx
    call f
    pop %edx
stop:
    movl counter, %eax
    pop %ebp
    ret

main:
    pushl $input
    pushl $in_str
    call scanf
    addl $8, %esp
    push input
    call f
    addl $4, %esp
    pushl %eax
    pushl $out_str
    call printf
    addl $8, %esp

    mov $1, %eax
    mov $0, %ebx
    int $0x80
