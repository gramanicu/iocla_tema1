%include "io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main

preorder:
    ; void preorder(*node) { processData; preorder(node->left); preorder (node->right); }
    ; read parameters: eax = *node
    
    push ebp
    mov ebp, esp
    mov eax, dword [ebp + 8]
    
    ; move parameters into registers
    ; ebx = node->data (char*), ecx = node->left (*node), edx = node->right(*node)
    mov ebx, dword [eax]
    mov ecx, dword [eax + 8]
    mov edx, dword [eax + 8]
    
    
    ; recursive calls
    leave
    ret
    
    

main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    
    push eax
    call preorder
    
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret