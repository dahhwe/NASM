section .data
    input_format db "%d", 0
    output_x_y db "x = %d, y = %d", 10, 0
    formula1_desc db "Formula 1: Z = (X+Y)/(X-Y)", 10, 0
    formula2_desc db "Formula 2: Z = -1/X^3 + 3", 10, 0
    formula3_desc db "Formula 3: Z = X - Y/X + 1", 10, 0
    output_format db "Result: Z = %lf", 10, 0
    err_msg db "Error: division by zero.", 10, 0
    division_by_zero_msg db "Division by zero error in formula", 10, 0
    minus_one_double dq -1.0
    three_double dq 3.0

section .bss
    x resd 1
    y resd 1
    z resq 1

section .text
    global _start

extern printf
extern scanf
extern exit

_start:
    ; Считываем X
    push x
    push input_format
    call scanf
    add esp, 8

    ; Считываем Y
    push y
    push input_format
    call scanf
    add esp, 8

    ; Выводим введенные значения X и Y
    mov eax, [x]
    mov ebx, [y]
    push ebx
    push eax
    push output_x_y
    call printf
    add esp, 12

    ; ---- Формула 1 ----
    push formula1_desc
    call printf
    add esp, 4

    mov eax, [x]
    mov ebx, [y]
    add eax, ebx
    mov ecx, eax
    mov eax, [x]
    sub eax, ebx     ; X - Y
    test eax, eax    ; Проверяем результат X-Y на ноль
    jz division_by_zero_formula1
    cvtsi2sd xmm1, eax ; Конвертируем (X-Y) в double
    cvtsi2sd xmm0, ecx ; Конвертируем (X+Y) в double
    divsd xmm0, xmm1   ; Делим: (X + Y) / (X - Y)
    movq [z], xmm0     ; Сохраняем результат в z
    ; Выводим результат для формулы 1
    push dword [z+4]  ; Передаем старшую часть double
    push dword [z]    ; Передаем младшую часть double
    push output_format
    call printf
    add esp, 12

    ; ---- Формула 2 ----
    push formula2_desc
    call printf
    add esp, 4
    mov eax, [x]
    test eax, eax    ; Проверяем X на ноль
    jz division_by_zero_formula2
    imul eax, eax    ; X^2
    imul eax, [x]    ; X^3
    cvtsi2sd xmm0, eax
    movq xmm1, [minus_one_double]
    divsd xmm1, xmm0
    addsd xmm1, [three_double]
    movq [z], xmm1
    ; Выводим результат для формулы 2
    push dword [z+4]
    push dword [z]
    push output_format
    call printf
    add esp, 12

    ; ---- Формула 3 ----
    push formula3_desc
    call printf
    add esp, 4
    mov eax, [x]
    test eax, eax
    jz division_by_zero_formula3
    mov eax, [y]
    cdq
    idiv dword [x]
    sub [x], eax
    add dword [x], 1
    mov eax, [x]
    cvtsi2sd xmm0, eax
    movq [z], xmm0
    ; Выводим результат для формулы 3
    push dword [z+4]
    push dword [z]
    push output_format
    call printf
    add esp, 12

    jmp end_program

division_by_zero_formula1:
    push err_msg
    call printf
    add esp, 4
    jmp end_program

division_by_zero_formula2:
    push division_by_zero_msg
    call printf
    add esp, 4
    jmp end_program

division_by_zero_formula3:
    push division_by_zero_msg
    call printf
    add esp, 4
    jmp end_program

end_program:
    ; Завершение программы
    push 0
    call exit
