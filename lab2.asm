section .data
    msg_x db "Enter X: ", 0
    msg_a db "Enter A: ", 0
    format_in db "%lf", 0
    format_out db "Result: %lf", 10, 0
	
    ten dd 10.0
    one dd 1.0
    four dd 4.0
    two dd 2.0

section .bss
    x resd 1
    a resd 1
    y1 resd 1
    y2 resd 1
    result resd 1

section .text
    extern printf, scanf
    global _start

print_message:
    push eax
    call printf
    add esp, 4
    ret

read_float:
    push eax
    push ebx
    call scanf
    add esp, 8
    ret

_start:
    ; Prompt for X
    push msg_x
    call print_message

    ; Read X
	push format_in
	push x
	call scanf
	add esp, 8

    ; Prompt for A
    push msg_a
    call print_message

    ; Read A
    push a
    push format_in
    call read_float

    ; Calculate Y1 based on X
    fld dword [x]      ; Load X
    fcomp dword [one]  ; Compare X with 1.0
    fstsw ax           ; Store the comparison result
    sahf
    jbe _x_le_1        ; Jump if X <= 1

    ; If X > 1
    fld dword [x]
    fadd dword [ten]   ; Y1 = X + 10
    fstp dword [y1]
    jmp _calc_y2

_x_le_1:
    ; If X <= 1
    fld dword [x]
    fabs               ; Y1 = |X|
    fld dword [a]
    fadd               ; Y1 = |X| + A
    fstp dword [y1]

_calc_y2:
    ; Calculate Y2 based on X
    fld dword [x]
    fcomp dword [four]
    fstsw ax
    sahf
    jbe _x_le_4

    ; If X > 4
	mov eax, dword [two]  ; Move the value of 'two' into eax
	mov [y2], eax         ; Move the value from eax into y2
    jmp _calc_result

_x_le_4:
    ; If X <= 4
    fld dword [x]
    fistp dword [y2]  ; Y2 = X

_calc_result:
    fld dword [y1]
    fist dword [result]
    mov eax, [result]
    cdq
    idiv dword [y2]
    mov [result], edx

    ; Print result
    push dword [result]
    push format_out
    call printf
    add esp, 8

    ; Exit program
    mov eax, 1
    int 0x80
