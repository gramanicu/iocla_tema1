%include "io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    
section .text
global main

preorder:
    push ebp
    mov ebp, esp
    
    ; save the registers that will be modified locally
    ; this is done in all functions, but, I never save eax register
    ; (because he will contain the return value, so he can't be restored)
    
    push ebx
    push ecx 
    push edx
    
    mov eax, dword [ebp + 8] ; *node
    mov ebx, [eax]      ; *data
    mov edx, [ebx+1]    ; data[1] - second char
    mov ebx, [ebx]      ; data[0] - fist char

    ; check what the second character in data is
    cmp edx, 0
    jnz preorder_number ; if data[1] is not a null terminator,
                        ; it means that "data" contains a number
    
    ; check if the first character is an operator
    cmp ebx, 0x2B ; "+"
    je preorder_operator
    
    cmp ebx, 0x2D ; "-"
    je preorder_operator
    
    cmp ebx, 0x2A ; "*"
    je preorder_operator
    
    cmp ebx, 0x2F ; "/"
    je preorder_operator
    
    ; if it failed all 4 checks, 
    ; it means that "data" contains a number
    
preorder_number:
    push dword [eax] ; give the pointer to the string
    call atoi
    add esp, 4
    jmp preorder_return

preorder_operator:
    ; compute left and right numbers
    mov eax, dword [ebp + 8]
    mov eax, [eax + 4]
    push eax
    call preorder
    add esp, 4
    
    
    ; move left value to ecx
    mov ecx, eax
    
    mov eax, dword [ebp + 8]
    mov eax, [eax + 8]
    push eax
    call preorder
    add esp, 4
    
    xchg eax, ecx ; for better workflow 
    
    ; now eax = left_value
    ;     ecx = right_value

    cmp ebx, 0x2B ; "+"
    je preorder_sum
    
    cmp ebx, 0x2D ; "-"
    je preorder_dif
    
    cmp ebx, 0x2A ; "*"
    je preorder_mul
    
    cmp ebx, 0x2F ; "/"
    je preorder_div
    

preorder_sum:
    add eax, ecx
    jmp preorder_return

preorder_dif:
    sub eax, ecx
    jmp preorder_return

preorder_mul:
    imul eax, ecx
    jmp preorder_return

preorder_div:
    cdq
    idiv ecx
    jmp preorder_return
    
preorder_return:
    ; restore registers
    pop edx
    pop ecx
    pop ebx
    
    leave
    ret ; preorder_return


atoi:
    ; this function will convert the *data (string) into a number (int)
    push ebp
    mov ebp, esp
    
    ; save the registers
    push ebx 
    push ecx
    xor ebx, ebx ; store the converted number
    mov ecx, 1   ; the sign of the number

    mov edi, dword [ebp + 8]
    
    ; check first char (if it's a negative number)
    
    xor eax, eax
    mov al, [edi]
    cmp eax, 0x2D
    jne atoi_while
    
    ; if it is a minus, jump over it and multiply at the end
    mov ecx, -1
    inc edi
    
atoi_while:
    xor eax, eax
    mov al, [edi]
    cmp eax, 0 ; check if we reached the string end
    jz atoi_while_end
    
    sub eax, 48 ; char -> int
    
    ; n = n * 10 + current_number
    imul ebx, 10
    add ebx, eax
    
    inc edi
    jmp atoi_while
atoi_while_end:
    mov eax, ebx
    imul eax, ecx
    
    ; restore the registers
    pop ecx
    pop ebx 

    leave
    ret ; atoi_return


main:
    mov ebp, esp; for correct debugging
    ; DO NOT CHANGE
    push ebp
    mov ebp, esp
    
    ; Read AST and write it to [root]
    call getAST
    mov [root], eax
    
    ; Do the math
    push eax
    call preorder
    add esp, 4
    
    PRINT_DEC 4, EAX
    
    ; DO NOT CHANGE
    ; free the memory used by AST
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret