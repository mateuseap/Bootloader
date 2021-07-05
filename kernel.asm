org 0x7e00
jmp 0x0000:start

data:
    random_chosen db 0
    ans db 'a',13, 10, 0 

    endl db ' ', 13, 10, 0

    q0 db '   Qual eh o resultado de 1+1?      ',13,10,0

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

    ac db '  Resposta correta! Tu mandou bem',13,10,0

    cow10 db '            \   ^__^             ',13,10,0
    cow11 db '             \  (^^)\_______     ',13,10,0
    cow12 db '                (__)\       )\/\ ',13,10,0
    cow13 db '                    ||----w |    ',13,10,0
    cow14 db '                    ||     ||    ',13,10,0
    
    res1 db '        a. 1     b. 2     c. 3   ',13,10,0
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

move_random:
    cmp byte[random_chosen], 0
    je .sub0
    cmp byte[random_chosen], 1
    je .sub1
    cmp byte[random_chosen], 2
    je .sub2
    cmp byte[random_chosen], 3
    je .sub3
    cmp byte[random_chosen], 4
    je .sub4
    cmp byte[random_chosen], 5
    je .sub5
    cmp byte[random_chosen], 6
    je .sub6
    cmp byte[random_chosen], 7
    je .sub7
    cmp byte[random_chosen], 8
    je .sub8
    cmp byte[random_chosen], 9
    je .sub9
    ret
    .sub0:
        mov al, '0'
        call put_char
        ret
    .sub1:
        mov al, '1'
        call put_char
        ret
    .sub2:
        mov al, '2'
        call put_char
        ret
    .sub3:
        mov al, '3'
        call put_char
        ret
    .sub4:
        mov al, '4'
        call put_char
        ret
    .sub5:
        mov al, '5'
        call put_char
        ret
    .sub6:
        mov al, '6'
        call put_char
        ret
    .sub7:
        mov al, '7'
        call put_char
        ret
    .sub8:
        mov al, '8'
        call put_char
        ret
    .sub9:
        mov al, '9'
        call put_char
        ret 
    ret

compare:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;
    cmp al, [ans]
    je .end
    call incorrect
    ret
    .end:
        call correct
        ret

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

    ret

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

    ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ;Código do projeto...

    call video_mode

    call random_number
    call move_random

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

    mov si, q0
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
    
    mov si, res1
    call print_string

    call compare
    
jmp $