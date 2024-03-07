section .data
    inputXMsg    db 'Enter value for X: ', 0
    inputAMsg    db 'Enter value for A: ', 0
    outputMsg    db 'X = %d, Y = %d', 10, 0
    formatIn     db '%d', 0

section .bss
    x           resd 1
    a           resd 1
    y           resd 1
    i           resd 1
    current_x   resd 1
    y1          resd 1
    y2          resd 1

section .text
    extern  printf, scanf

global _start

_start:
    mov     eax, inputXMsg
    push    eax
    call    printf
    add     esp, 4
    
    mov     eax, formatIn
    push    x
    push    eax
    call    scanf
    add     esp, 8

    mov     eax, inputAMsg
    push    eax
    call    printf
    add     esp, 4
    
    mov     eax, formatIn
    push    a
    push    eax
    call    scanf
    add     esp, 8

    mov     dword [i], 0
loop_start:
    cmp     dword [i], 10
    jge     loop_end

    mov     eax, [x]
    add     eax, [i]
    mov     [current_x], eax

    cmp     eax, 1
    jle     less_than_one
    add     eax, 10  ; y1 = 10 + current_x
    jmp     y1_done

less_than_one:
    mov     edx, eax ; Move current_x to edx for abs calculation
    or      edx, edx ; Check if edx is negative
    jns     not_negative
    neg     edx      ; Negate if negative
not_negative:
    add     edx, [a] ; y1 = |current_x| + a
    mov     eax, edx

y1_done:
    mov     [y1], eax

    mov     eax, [current_x]
    cmp     eax, 4
    jle     less_than_four
    mov     eax, 2   ; y2 = 2
    jmp     y2_done

less_than_four:
    ; y2 = current_x is already in eax

y2_done:
    mov     [y2], eax
    mov     eax, [y1]
    xor     edx, edx
    div     dword [y2]
    mov     [y], edx

    push    dword [y]
    push    dword [current_x]
    push    outputMsg
    call    printf
    add     esp, 12

    inc     dword [i]
    jmp     loop_start

loop_end:
    mov     eax, 1
    xor     ebx, ebx
    int     0x80
