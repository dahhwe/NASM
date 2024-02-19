section .data
    input_format db "%d", 0
    output_x_y db "x = %d, y = %d", 10, 0
    formula1_desc db "Formula 1: Z = (X+Y)/(X-Y)", 10, 0
    formula2_desc db "Formula 2: Z = -1/X^3 + 3", 10, 0
    formula3_desc db "Formula 3: Z = X - Y/X + 1", 10, 0
    formula4_desc db "Formula 4: Z = ((X+Y)/Y^2 - 1)*X", 10, 0
    formula5_desc db "Formula 5: Z = (X-Y)/(XY+1)", 10, 0
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

formula1:
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

    jmp formula2

formula2:
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

    jmp formula3

formula3:
    ; ---- Формула 3 ----
    push formula3_desc
    call printf
    add esp, 4

    ;Y/X
    mov eax, [y]
    cdq
    mov ebx, [x]
    test ebx, ebx
    jz division_by_zero_formula3
    idiv ebx

    push eax

    mov eax, [x]
    pop ebx
    sub eax, ebx        ; X - (Y/X)
    add eax, 1          ; + 1

    cvtsi2sd xmm0, eax
    movq [z], xmm0

    ; Вывод результата
    push dword [z+4]
    push dword [z]
    push output_format
    call printf
    add esp, 12
    jmp formula4


formula4:
    ; ---- Формула 4 ----
    push formula4_desc
    call printf
    add esp, 4

    mov eax, [y]
    test eax, eax
    jz division_by_zero_formula4

    ;Y^2
    imul eax, eax    ; Y * Y
    cvtsi2sd xmm1, eax

    ;X + Y
    mov eax, [x]
    add eax, [y]
    cvtsi2sd xmm0, eax
    divsd xmm0, xmm1


    movsd xmm1, [minus_one_double]
    addsd xmm0, xmm1

    cvtsi2sd xmm1, [x]
    mulsd xmm0, xmm1

    movq [z], xmm0
    push dword [z+4]
    push dword [z]
    push output_format
    call printf
    add esp, 12
    jmp formula5

formula5:
    ; ---- Формула 5 ----
    push formula5_desc
    call printf
    add esp, 4

    mov eax, [x]
    mov ebx, [y]
    imul eax, ebx    ; X * Y
    add eax, 1       ; XY + 1
    mov ebx, [x]
    sub ebx, [y]     ; X - Y
    cvtsi2sd xmm0, ebx ; (X-Y)
    cvtsi2sd xmm1, eax ; (XY+1)
    divsd xmm0, xmm1   ; (X-Y) / (XY+1)
    movq [z], xmm0
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
    jmp formula2

division_by_zero_formula2:
    push division_by_zero_msg
    call printf
    add esp, 4
    jmp formula3

division_by_zero_formula3:
    push division_by_zero_msg
    call printf
    add esp, 4
    jmp formula4

division_by_zero_formula4:
    push division_by_zero_msg
    call printf
    add esp, 4
    jmp formula5

division_by_zero_formula5:
    push division_by_zero_msg
    call printf
    add esp, 4
    jmp end_program

end_program:
    ; Завершение программы
    push 0
    call exit
