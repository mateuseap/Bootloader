org 0x7e00
jmp 0x0000:start

data:
    ans0 db 'a',13,10,0
    ans1 db 'b',13,10,0
    ans2 db 'c',13,10,0
    ans3 db 'a',13,10,0
    ans4 db 'b',13,10,0
    ans5 db 'c',13,10,0
    ans6 db 'a',13,10,0
    ans7 db 'b',13,10,0
    ans8 db 'c',13,10,0
    ans9 db 'a',13,10,0

    check0 db 0
    check1 db 0
    check2 db 0
    check3 db 0
    check4 db 0
    check5 db 0
    check6 db 0
    check7 db 0
    check8 db 0
    check9 db 0
    
    random_chosen db 0
    questionAns db 0

    endl db ' ', 13, 10, 0

    q0 db '   Qual eh o resultado de 1+1?      ',13,10,0
    q1 db '   Qual eh o resultado de 2+2?      ',13,10,0
    q2 db '   Qual eh o resultado de 3+3?      ',13,10,0
    q3 db '   Qual eh o resultado de 4+4?      ',13,10,0
    q4 db '   Qual eh o resultado de 5+5?      ',13,10,0
    q5 db '   Qual eh o resultado de 6+6?      ',13,10,0
    q6 db '   Qual eh o resultado de 7+7?      ',13,10,0
    q7 db '   Qual eh o resultado de 8+8?      ',13,10,0
    q8 db '   Qual eh o resultado de 9+9?      ',13,10,0
    q9 db '   Qual eh o resultado de 10+10?    ',13,10,0

    cow0 db '            \   ^__^             ',13,10,0
    cow1 db '             \  (oo)\_______     ',13,10,0
    cow2 db '                (__)\       )\/\ ',13,10,0
    cow3 db '                    ||----w |    ',13,10,0
    cow4 db '                    ||     ||    ',13,10,0

    wa db '   Resposta errada! Que decadente...',13,10,0

    cow5 db '            \   ^__^             ',13,10,0
    cow6 db '             \  (xx)\_______     ',13,10,0
    cow7 db '                (__)\       )\/\ ',13,10,0
    cow8 db '                    ||----w |    ',13,10,0
    cow9 db '                    ||     ||    ',13,10,0

    rst db '   Aperte SPACE para recomecar   ',13,10,0

    ac db '  Resposta correta! Tu mandou bem',13,10,0

    cow10 db '            \   ^__^             ',13,10,0
    cow11 db '             \  (^^)\_______     ',13,10,0
    cow12 db '                (__)\       )\/\ ',13,10,0
    cow13 db '                    ||----w |    ',13,10,0
    cow14 db '                    ||     ||    ',13,10,0

    nxt db ' Aperte SPACE para proxima questao',13,10,0
    
    res0 db '        a. 2     b. 1     c. 3   ',13,10,0
    res1 db '        a. 1     b. 4     c. 3   ',13,10,0
    res2 db '        a. 1     b. 2     c. 6   ',13,10,0
    res3 db '        a. 8     b. 2     c. 3   ',13,10,0
    res4 db '        a. 1     b. 10     c. 3  ',13,10,0
    res5 db '        a. 1     b. 2     c. 12  ',13,10,0
    res6 db '        a. 14     b. 2     c. 3  ',13,10,0
    res7 db '        a. 1     b. 16     c. 3  ',13,10,0
    res8 db '        a. 1     b. 2     c. 18  ',13,10,0
    res9 db '        a. 20     b. 2     c. 3  ',13,10,0
    
    ;Dados do projeto...

video_mode:
    ;modo video
    mov ah, 0h 
    mov al, 13h ;mov al, 0xd modo antigo
    int 10h

    mov ah, 0xb 
    mov bh, 0 
    mov bl, 14 ;cor
    int 10h
    ret

put_char:
    mov ah, 0x0e ;número da chamada para mostrar na tela um caractere que está em al
    int 10h ;interrupção de vídeo
    ret

read_char:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado
    ret ;após a execução dessa interrupção int 16h o caractere lido estará armazenado em al

print_string:
    .loop:
        lodsb ;carrega uma letra de si em al
        cmp al, 0 ;checa se chegou no final da string (equivalente a um '\0)
        je .endloop 
        call put_char 
        jmp .loop
    .endloop:
    ret

get_string:
    mov al, 0
    .for:
        call read_char
        stosb ;guarda o que está em al
        cmp al, 13
        je .fim
        call put_char
        jmp .for
     .fim:
    dec di
    mov al, 0
    stosb
    mov si, endl
    call print_string
    ret


random_number:
    random_start:
        mov AH, 00h  ; interru  pts to get system time        
        int 1AH      ; CX:DX now hold number of clock ticks since midnight      

        mov  ax, dx
        xor  dx, dx
        mov  cx, 10    
        div  cx       ; here dx contains the remainder of the division - from 0 to 9

        ;add  dl, '0'  ; to ascii from '0' to '9'
        mov byte[random_chosen], dl
    ret

%macro question 3
    call video_mode

    mov si, endl
    call print_string
    mov si, endl
    call print_string    
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string

    mov si, %1
    call print_string

    mov si, endl
    call print_string

    mov si, cow0
    call print_string
    mov si, cow1
    call print_string
    mov si, cow2
    call print_string
    mov si, cow3
    call print_string
    mov si, cow4
    call print_string

    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    
    mov si, %2
    call print_string

    mov ax, [%3]
    mov [questionAns], ax
    call compare
%endmacro

move_random:
    cmp byte[random_chosen], 0
    jne .if0
        cmp byte[check0], 0
        je .question0
        call random_number
        call move_random
    .if0:
    cmp byte[random_chosen], 1
    jne .if1
        cmp byte[check1], 0
        je .question1
        call random_number
        call move_random
    .if1:
    cmp byte[random_chosen], 2
    jne .if2
        cmp byte[check2], 0
        je .question2
        call random_number
        call move_random
    .if2:
    cmp byte[random_chosen], 3
    jne .if3
        cmp byte[check3], 0
        je .question3
        call random_number
        call move_random
    .if3:
    cmp byte[random_chosen], 4
    jne .if4
        cmp byte[check4], 0
        je .question4
        call random_number
        call move_random
    .if4:
    cmp byte[random_chosen], 5
    jne .if5
        cmp byte[check5], 0
        je .question5
        call random_number
        call move_random
        ret
    .if5:
    cmp byte[random_chosen], 6
    jne .if6
        cmp byte[check6], 0
        je .question6
        call random_number
        call move_random
    .if6:
    cmp byte[random_chosen], 7
    jne .if7
        cmp byte[check7], 0
        je .question7
        call random_number
        call move_random
    .if7:
    cmp byte[random_chosen], 8
    jne .if8
        cmp byte[check8], 0
        je .question8
        call random_number
        call move_random
    .if8:
    cmp byte[random_chosen], 9
    jne .if9
        cmp byte[check9], 0
        je .question9
        call random_number
        call move_random
    .if9:
    ret;podemos inserir aqui a função da tela de vitória
    .question0:
        mov byte[check0], 1
        question q0, res0, ans0
    .question1:
        mov byte[check1], 1
        question q1, res1, ans1
    .question2:
        mov byte[check2], 1
        question q2, res2, ans2        
    .question3:
        mov byte[check3], 1
        question q3, res3, ans3    
    .question4:
        mov byte[check4], 1
        question q4, res4, ans4   
    .question5:
        mov byte[check5], 1
        question q5, res5, ans5       
    .question6:
        mov byte[check6], 1
        question q6, res6, ans6          
    .question7:
        mov byte[check7], 1
        question q7, res7, ans7     
    .question8:
        mov byte[check8], 1
        question q8, res8, ans8    
    .question9:
        mov byte[check9], 1
        question q9, res9, ans9       

compare:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h
    cmp al, [questionAns]
    je .end
    call incorrect
    .end:
        call correct

correct:
    call video_mode

    mov si, endl
    call print_string
    mov si, endl
    call print_string    
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string

    mov si, ac
    call print_string

    mov si, endl
    call print_string

    mov si, cow10
    call print_string
    mov si, cow11
    call print_string
    mov si, cow12
    call print_string
    mov si, cow13
    call print_string
    mov si, cow14
    call print_string

    mov si, endl
    call print_string
    mov si, endl
    call print_string

    mov si, nxt
    call print_string

    .loop:
        call read_char
        cmp al, 32
        je .end
        jmp .loop
    .end:
        ;incrementar o contador de acertos
        call random_number
        call move_random

incorrect:
    call video_mode

    mov si, endl
    call print_string
    mov si, endl
    call print_string    
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string
    mov si, endl
    call print_string

    mov si, wa
    call print_string

    mov si, endl
    call print_string

    mov si, cow5
    call print_string
    mov si, cow6
    call print_string
    mov si, cow7
    call print_string
    mov si, cow8
    call print_string
    mov si, cow9
    call print_string

    mov si, endl
    call print_string
    mov si, endl
    call print_string

    mov si, rst
    call print_string

    .loop:
        call read_char
        cmp al, 32
        je .end
        jmp .loop
    .end:
        ;zerar as flags e o contador de acertos
        call random_number
        call move_random

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    call video_mode

    call random_number
    call move_random
    
jmp $