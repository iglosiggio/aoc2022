section .text
global _start
_start:
    xor r13, r13
    xor r12, r12
    xor rbx, rbx
    .find_max:
        call read_number
        cmp rax, -1
        je exit
        mov r14, rax
        .read_group:
            call read_number
            cmp rax, 0
            jle .compare_group_sum
            add r14, rax
        jmp .read_group

        .compare_group_sum:
            cmp r14, r13
            cmova rbx, r12
            cmova r12, r13
            cmova r13, r14
            ja .find_max
            cmp r14, r12
            cmova rbx, r12
            cmova r12, r14
            ja .find_max
            cmp r14, rbx
            cmova rbx, r14
        jmp .find_max

exit:
    int3
    mov rax, 60
    mov rdi, 0
    syscall

read_char:
    sub rsp, 1
    mov rax, 0
    mov rdi, 0
    mov rsi, rsp
    mov rdx, 1
    syscall
    cmp rax, 1
    mov rdi, -1
    movzx rax, BYTE [rsp]
    cmovne rax, rdi
    add rsp, 1
    ret

read_number:
    xor r15, r15
    .loop:
        call read_char
        cmp rax, -1
        je .end_err
        cmp rax, 10 ; \n
        je .end
        sub rax, '0'
        lea rdi, [r15*8 + r15]
        add r15, rdi
        add r15, rax
        jmp .loop
.end:
    mov rax, r15
    ret
.end_err:
    mov rax, -1
    ret

write_char:
    sub rsp, 1
    mov [rsp], dil
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    cmp rax, 1
    jnz crash
    add rsp, 1
    ret

crash:
    mov rax, 60
    mov rdi, 1
    syscall
