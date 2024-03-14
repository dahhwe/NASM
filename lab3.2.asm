global _start

section .data
    input_prompt db "Введите строку: ", 0
    prompt_len equ $-input_prompt

section .bss
    buffer resb 256

section .text

_start:
    mov eax, 4              
    mov ebx, 1              
    mov ecx, input_prompt   
    mov edx, prompt_len     
    int 0x80                

    mov eax, 3              
    mov ebx, 0              
    mov ecx, buffer         
    mov edx, 255            
    int 0x80                

    mov byte [ecx+eax-1], 0

    lea esi, [buffer]       
    lea edi, [buffer]       

    xor eax, eax            

skip_leading_spaces:
    lodsb                   
    cmp al, ' '
    je skip_leading_spaces

skip_first_word:
    cmp al, ' '
    jne .read_next          
    jmp .copy_loop          

.read_next:
    lodsb                   
    cmp al, ' '
    je .skip_extra_spaces   
    test al, al
    jnz .read_next
    jmp .done               

.skip_extra_spaces:
    lodsb                   
    cmp al, ' '
    je .skip_extra_spaces
    dec esi                 

.copy_loop:
    lodsb                   
    test al, al
    jz .done                
    cmp al, ' '
    je .handle_space
    stosb                   
    jmp .copy_loop

.handle_space:
    mov byte [edi], ' '    
    inc edi                
    .skip_consecutive_spaces:
        lodsb
        cmp al, ' '
        je .skip_consecutive_spaces
        test al, al
        jz .done            
        dec esi             
        jmp .copy_loop

.done:
    mov byte [edi], 0xa
    inc edi
    mov byte [edi], 0      

    mov eax, 4             
    mov ebx, 1             
    mov ecx, buffer        
    mov edx, edi           
    sub edx, buffer
    int 0x80               

    mov eax, 1             
    xor ebx, ebx           
    int 0x80               
