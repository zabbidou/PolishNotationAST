; Gherman Maria Irina @ 324 CB

%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .data
    string db "-15023", 0

section .text

atoi:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp + 8] ; ecx -> adresa stringului (continutul lui data)
    xor eax, eax ; tinem rez in eax
    xor edx, edx ; nu e folosibil, il tinem 0 pt impartire
    xor ebx, ebx ; aici tinem rezultatul
    xor edi, edi
    mov edi, 10 ; const 10
    xor esi, esi ; un fel de bool daca avem 0
    
    mov al, byte[ecx]
    sub al, 48
    
    cmp byte[ecx], 45
    jne atoi_plus ; daca avem nr pozitiv
atoi_minus:
    inc ecx
    mov al, byte[ecx] ; ignoram minusul
    sub al, 48
    mov esi, 1 ; tinem minte ca aveam -
    
atoi_plus:
    cmp byte[ecx + 1], 0 ; daca mai avem cifre
    je discutie_de_semn
    
    mul edi ; inmultim cu 10
    
    inc ecx
    xor edx, edx
    mov dl, byte[ecx] ; luam urm cifra
    sub dl, 48
    
    add eax, edx ; o adaugam la rezultatul inmultit cu 10

    cmp byte[ecx + 1], 0 ; daca mai avem cifre, continuam
    jne atoi_plus
    
discutie_de_semn:
    cmp esi, 1
    jne end ; nr era pozitiv
    
    not eax
    inc eax
    
end:
    leave
    ret
        
    
math:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 16] ; operatorul
    mov eax, [ebp + 12] ; primul numar (ala din stg)
    mov ecx, [ebp + 8] ; al doilea nr
    
    cmp byte[ebx], '+'
    je plus
    
    cmp byte[ebx], '-'
    je minus
    
    cmp byte[ebx], '*'
    je inmul
    
    cmp byte[ebx], '/'
    je impart
    
    jmp finish
    
plus:
    add eax, ecx

    jmp finish
    
minus:
    sub eax, ecx

    jmp finish
    
inmul:
    mul ecx

    jmp finish
    
impart:
    xor edx, edx
    cdq
    idiv ecx

    jmp finish
    
finish:
    leave
    ret

compute:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    mov ebx, eax
    mov eax, [eax]
    
    cmp byte[eax], 45 ; daca are minus in fata
    jne not_minus
    
    cmp byte[eax + 1], 0 ; daca e doar operatorul -
    jne cifra_plus_plus ; daca nu, e cifra
    je operator
    
not_minus:
    cmp dword[eax], 48
    jae cifra_plus_plus ; daca e cifra, nu mai mergem
    
operator:
    xor ecx, ecx
    mov ebx, [ebp + 8]
    
    push dword[ebx + 4]
    call compute
    add esp, 4
    
    push eax
    
    mov ebx, [ebp + 8]
    push dword[ebx + 8]
    call compute
    add esp, 4
    
    pop edx
    
    jmp calcul
    
cifra_plus_plus:
    push eax
    call atoi
    add esp, 4

    jmp continue
    
calcul:
    xor ecx, ecx
    mov ebx, [ebp + 8]
    mov ebx, [ebx]
    
    push ebx
    push edx
    push eax
    
    call math
    
    add esp, 8
    
    xor ecx, ecx
    inc ecx

continue:   
    leave
    ret
      

global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    
    mov eax, [root]
    push eax
    call compute
    add esp, 4
    
    PRINT_DEC 4, EAX
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret