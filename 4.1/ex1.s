.data
    x: .long 10
    y: .long 20
.text
.globl main
main:
    mov x, %eax
    mov y, %ebx
    mov %eax, y
    mov %ebx, x

    mov $1, %eax
    mov $0, %ebx
    int $0x80
