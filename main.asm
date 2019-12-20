;variaveis definidas em tempo de compilação
%define SYS_WRITE 1
%define SYS_EXIT 60

%define TOWER_LEN 10
%define DET 2*TOWER_LEN


global _start
global _break
section .data

message: db "Feliz natal!", 0x0
newline: db 0xA, 0x0
space: db " ", 0x0
tower_top: db ">>#<<", 0xA, 0x0
tower_bottom: db "|||||", 0xA, 0x0
tower: db "-", 0x0

section .text

;Calcula o tamaho da string
strlen:                                      
    xor rax, rax
    .loop:
        inc rax
        cmp byte[rdi + rax], 0
        jne .loop
    .end:
    ret

;Imprime uma String
print_string:       
    call strlen
    mov rdx, rax
    mov rsi, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    ret

_start:

;-----Estrela----------

    mov r10, (DET-6)/2  
    xor rcx, rcx        

    .loop1:
        mov rdi, space
        push rcx
        call print_string
        pop rcx
        inc rcx
        cmp rcx, r10
        jne .loop1
    .endloop1:

    mov rdi, tower_top
    call print_string

;-----Corpo------------
    _break:

    xor rcx, rcx

    .loop2:

        cmp rcx, TOWER_LEN
        jge .endloop2

        mov rax, 2
        mul rcx
        inc rax

        ;imprime os espacos
        push rax
        mov r10, DET-1
        sub r10, rax

        mov rax, r10
        mov r10, 2
        div r10

        xor r12, r12

        .loop3:
            cmp rax, r12
            jle .endloop3
            push rax
            push rcx
            mov rdi, space
            call print_string
            pop rcx
            pop rax
            inc r12
            jmp .loop3
        .endloop3:
        
        pop rax
        push rcx
        
        ;imprime o corpo
        xor r12, r12
        .loop4:
            cmp rax, r12
            jle .endloop4
            push rax
            push rcx
            mov rdi, tower
            call print_string
            pop rcx
            pop rax
            inc r12
            jmp .loop4
        .endloop4:

        mov rdi, newline
        call print_string
        pop rcx
        pop rax

        inc rcx
        jmp .loop2
    .endloop2:

;-----tronco-----------

    mov r10, (DET-6)/2  
    xor rcx, rcx        

    .loop1:
        mov rdi, space
        push rcx
        call print_string
        pop rcx
        inc rcx
        cmp rcx, r10
        jne .loop1
    .endloop1:

    mov rdi, tower_bottom
    call print_string

;-----Saida------------

    mov rdi, newline
    call print_string

    mov rdi, message
    call print_string    

    mov rdi, newline
    call print_string
    
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
