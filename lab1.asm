section .data
    promptX db "Enter a value for X: ", 0
    promptY db "Enter a value for Y: ", 0
    format db "%f", 0
    format3 db "Integer part: %d, Fractional part: %f", 10, 0
    errorMsg db "Error: Division by zero is undefined.", 10, 0
    formula1 db "Z = (X+Y)/(X-Y)", 10, 0
    formula2 db "Z = - 1/X^3 + 3", 10, 0
    formula3 db "Z = X - Y/X +1", 10, 0
    formula4 db "Z = ((X+Y)/Y^2 - 1)*X", 10, 0
    formula5 db "Z = (X-Y)/(XY+1)", 10, 0

section .bss
    x resd 1
    y resd 1
    z resd 1
    intPart resd 1
    fracPart resd 1

section .text
    extern printf, scanf
    global main

main:
    ; Prompt for X
    push promptX
    call printf
    add esp, 4

    ; Input X
    push x
    push format
    call scanf
    add esp, 8

    ; Prompt for Y
    push promptY
    call printf
    add esp, 4

    ; Input Y
    push y
    push format
    call scanf
    add esp, 8

    ; Calculate Z = (X+Y)/(X-Y)
    fld dword [x]
    fsub dword [y]
    fldz
    fucomip st0, st1
    jz .division_by_zero
    fld dword [x]
    fadd dword [y]
    fdivp st1, st0
    fstp dword [z]

    ; Print the formula and result
    push formula1
    call printf
    add esp, 4
    fld dword [z]
    frndint
    fistp dword [intPart]
    fld dword [z]
    fsub dword [intPart]
    fstp dword [fracPart]
    push dword [fracPart]
    push dword [intPart]
    push format3
    call printf
    add esp, 12

    ; Calculate Z = - 1/X^3 + 3
    fld1
    fld dword [x]
    fmul st0, st0
    fmul st0, st0
    fdivp st1, st0
    fchs
    fld1
    faddp st1, st0
    fstp dword [z]

    ; Print the formula and result
    push formula2
    call printf
    add esp, 4
    fld dword [z]
    frndint
    fistp dword [intPart]
    fld dword [z]
    fsub dword [intPart]
    fstp dword [fracPart]
    push dword [fracPart]
    push dword [intPart]
    push format3
    call printf
    add esp, 12

    ; Calculate Z = X - Y/X +1
    fld dword [x]
    fld dword [y]
    fdivr dword [x]
    fsubr st1, st0
    fld1
    faddp st1, st0
    fstp dword [z]

    ; Print the formula and result
    push formula3
    call printf
    add esp, 4
    fld dword [z]
    frndint
    fistp dword [intPart]
    fld dword [z]
    fsub dword [intPart]
    fstp dword [fracPart]
    push dword [fracPart]
    push dword [intPart]
    push format3
    call printf
    add esp, 12

    ; Calculate Z = ((X+Y)/Y^2 - 1)*X
    fld dword [x]
    fadd dword [y]
    fld dword [y]
    fmul st0, st0
    fdivp st1, st0
    fld1
    fsubp st1, st0
    fld dword [x]
    fmul st0, st1
    fstp dword [z]

    ; Print the formula and result
    push formula4
    call printf
    add esp, 4
    fld dword [z]
    frndint
    fistp dword [intPart]
    fld dword [z]
    fsub dword [intPart]
    fstp dword [fracPart]
    push dword [fracPart]
    push dword [intPart]
    push format3
    call printf
    add esp, 12

    ; Calculate Z = (X-Y)/(XY+1)
    fld dword [x]
    fsub dword [y]
    fld dword [x]
    fmul dword [y]
    fld1
    faddp st1, st0
    fdivp st1, st0
    fstp dword [z]

    ; Print the formula and result
    push formula5
    call printf
    add esp, 4
    fld dword [z]
    frndint
    fistp dword [intPart]
    fld dword [z]
    fsub dword [intPart]
    fstp dword [fracPart]
    push dword [fracPart]
    push dword [intPart]
    push format3
    call printf
    add esp, 12

    jmp .exit

.division_by_zero:
    push errorMsg
    call printf
    add esp, 4

.exit:
    ; Exit
    mov eax, 0x60
    xor edi, edi
    syscall
