org 0x7e00 ;endereço de memória que vai começar
jmp 0x0000:start ;começo do disco:"main" da linguagem de alto nível

data:
    ans0 db 'a',13,10,0
    ans1 db 'd',13,10,0
    ans2 db 'b',13,10,0
    ans3 db 'c',13,10,0
    ans4 db 'd',13,10,0
    ans5 db 'a',13,10,0
    ans6 db 'b',13,10,0
    ans7 db 'a',13,10,0
    ans8 db 'c',13,10,0
    ans9 db 'a',13,10,0

    q0 db '     O que eh um processo?          ',13,10,0
    q1 db 'Quais registradores abaixo possuem 32 bits e sao chamados de registradores de uso geral?',13,10,0
    q2 db 'Quais registradores abaixo possuem 16 bits?',13,10,0
    q3 db 'Quantos estagios possuem o bootloader desse projeto?',13,10,0
    q4 db 'Para que serve a instrucao MOV em ASM x86?',13,10,0
    q5 db '   As instrucoes da linguagem Assembly sao case insensitive?',13,10,0
    q6 db 'O que o kernel simula nesse projeto de bootloader?',13,10,0
    q7 db '    Quem fez o projeto? ',13,10,0
    q8 db ' Qual instrucao eh equivalente ao goto da linguagem C em ASM x86?',13,10,0
    q9 db ' Esse projeto eh de que disciplina?',13,10,0

    res0 db '    a. Um programa em execucao              b. Uma instrucao do ASM x86             c. Um arquivo em execucao               d. Um arquivo de texto     ',13,10,0
    res1 db '    a. EAH, EBX, ECX e EDX                  b. EAX, EBX, ECX e EDH                  c. EAH, EBH, ECH e EDH                  d. EAX, EBX, ECX e EDX     ',13,10,0
    res2 db '    a. AL, BL, CL e DL                      b. AX, BX, CX e DX                      c. AH, BH, CX e DH                      d. AH, BH, CH e DH         ',13,10,0
    res3 db '    a. Quatro estagios                      b. Tres estagios                        c. Dois estagios                        d. Um unico estagio        ',13,10,0
    res4 db '    a. Realizar operacoes aritmeticas       b. Retornar a execucao do processo      c. Realizar operacao logica bit a bit   d. Mover algo de um registrador para outro',13,10,0
    res5 db '    a. Sim                                  b. Nao',13,10,0
    res6 db '    a. A BIOs                               b. O Sistema Operacional                c. Um sistema de arquivos               d. Um escalonador          ',13,10,0
    res7 db '    a. Jonga, Elias, Bigodinho              b. Daylol, Kinho e Rods                 c. Zildao, Torugo e Aninha              d. Leo Bala, Igrr e Dourado',13,10,0
    res8 db '    a. mov                                  b. ret                                  c. jmp                                  d. jge                     ',13,10,0
    res9 db '    a. Infra. de Software                   b. Infra. de Hardware                   c. Infra. de Hardware e Software        d. Algoritmos              ',13,10,0

    cow0 db '            \   ^__^             ',13,10,0
    cow1 db '             \  (oo)\_______     ',13,10,0
    cow2 db '                (__)\       )\/\ ',13,10,0
    cow3 db '                    ||----w |    ',13,10,0
    cow4 db '                    ||     ||    ',13,10,0
    cow5 db '             \  (xx)\_______     ',13,10,0
    cow6 db '             \  (^^)\_______     ',13,10,0
    cow7 db '             \  (**)\_______     ',13,10,0
    cow8 db '             \  (&&)\_______     ',13,10,0

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
    counter db 0 ;Declara um byte contendo o valor 0.

    random_chosen db 0
    questionAns db 0
    
    endl db ' ',13,10,0

    wa db '   Resposta errada! Que decadente...',13,10,0
    rst db '      Aperte SPACE para recomecar',13,10,0
    ac db '  Resposta correta! Tu mandou bem',13,10,0
    nxt db '   Aperte SPACE para proxima questao',13,10,0
    win db '   Voce acertou tudo, parabains!   ',13,10,0
    eins db 'Acho que temos um novo Kinho, 138 de QI!',13,10,0
    wlcm db '   Bem vindo ao Show do Vacao     ',13,10,0
    strt db '   Aperte SPACE para iniciar o quiz',13,10,0

%macro printf 1 
    mov si, %1 ;macro que vai armazenar variável no si
    call print_string ;logo após vai ser chamada a print_string para printar frase
%endmacro

%macro print_cow 1
    printf cow0
    printf %1   ;como a única coisa que muda na vaquinha são os olhos
    printf cow2 ;esse macro serve para que seja printada o resto da vaquinha
    printf cow3 ;e é passado a linha referente aos olhos como parâmetro
    printf cow4
%endmacro

%macro blankspace 1 
    pusha       ;coloca os valores dos registradores na stack
    mov cx, %1  ;vai ser passado como parâmetro a quantidade de linhas que vão ser puladas
    %%volta:        ;loop básico que vai printar a quantidade de linhas puladas
        cmp cx, 0
        je %%fim
        printf endl
        dec cx
        jmp %%volta
    %%fim:
    popa    ;retorna os valores da stack para os registradores
%endmacro

%macro question 3
    call video_mode ;inicializa o video mode
    
    blankspace 6 ;utiliza as macros anteriores para printar a tela de questões do jogo
    printf %1
    blankspace 1
    print_cow cow1
    blankspace 3
    printf %2

    mov ax, [%3]            ;move a resposta certa que é passada como parâmetro para ax, que sera usado como "variavel temporária"
    mov [questionAns], ax   ;upa a resposta certa na variável 
    call compare            ;entra na compare
%endmacro

video_mode:
    mov ah, 0h ;escolhe o modo de vídeo
    mov al, 13h
    int 10h

    mov ah, 0xb
    mov bh, 0 
    mov bl, 15 ;cor da fonte
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
        cmp al, 0 ;checa se chegou no final da string (equivalente a um '\0')
        je .endloop 
        call put_char 
        jmp .loop
    .endloop:
    ret

reset_all: ;As flags atreladas as questões são zeradas e o contador de acertos também é zerado
    mov byte[check0], 0
    mov byte[check1], 0
    mov byte[check2], 0
    mov byte[check3], 0
    mov byte[check4], 0
    mov byte[check5], 0
    mov byte[check6], 0
    mov byte[check7], 0
    mov byte[check8], 0
    mov byte[check9], 0
    mov byte[counter], 0
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    ret

compare:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado 
    cmp al, [questionAns] ;compara a alternativa lida com a alternativa correta
    je .end
    call incorrect         ;se estiver errada chama a tela de derrota
    .end:
        call correct       ;se estiver certa chama a tela de acerto

random_number:
    random_start:
        mov AH, 00h  ;interrupção para pegar o tempo de sistema       
        int 1AH      ;CX:DX armazena o numero de tiques do clock desde meia noite  

        mov  ax, dx ;o valor do clock é armazenado em dx
        xor  dx, dx ;dx é zerado
        mov  cx, 10 ;armazenamos 10 em cx que vai ser o divisor de da divisão ax/cx 
        div  cx       ; aqui dx contém o resto da divisão (esse valor pode ser de 0 até 9)

        mov byte[random_chosen], dl ;dl que é o resto da divisão vai ser o numero randômico gerado
    ret

move_random:
    cmp byte[random_chosen], 0  ;compara o número randômico gerado com o número da questão
    jne .if0                    ;o jne vai funcionar como um if/else-if, que vai passar por todas as alternativas ate atingir a correta
        cmp byte[check0], 0     ;compara a flag da questão com 0 para ver se a questão já foi exibida
        je .question0           ;se for igual a 0 a questão ainda não foi exibida, e se ela ainda não foi exibida, a função para exibir a respectiva questão na tela é chamada
        call random_number      ;se a questão já foi exibida será gerado outro número aleatório (de 0 até 9)
        call move_random        ;e a função atual será chamada novamente para procurar outras questões que ainda não foram exibidas
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
        cmp byte[check9], 0
        je .question9
        call random_number
        call move_random
    .question0:
        mov byte[check0], 1       ;alterar o valor da flag da questão para 1, para que ela nao seja exibida novamente
        question q0, res0, ans0   ;chama o macro da questão para ela ser printada na tela
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

correct:
    call video_mode

    blankspace 6
    printf ac
    blankspace 1
    print_cow cow6
    blankspace 2
    printf nxt

    .loop:                         ;Essa tela será exibida quando o usuário responder a  
        call read_char             ;questão corretamente. Primeiro, chamamos o 'video_mode'
        cmp al, 32                 ;para limpar a tela e ativar o modo de video, depois
        je .end                    ;nós printamos as informações na tela utilizando
        jmp .loop                  ;os macros. Após isso, o código fica num loop, o usuário
    .end:                          ;precisa digitar a tecla 'space' (que equivale a 32 na tabela ASCII)
        cmp byte[counter], 9       ;para ir para próxima questão, enquanto ele não dá 'space' como input,
        jne .pass                  ;a tela não se modifica. Quando o usuário digita 'space' como input,
            call win_screen        ;nós checamos se o número de acertos obtidos pelo usuário
        .pass:                     ;é igual ao número de questões -1 do nosso quiz (temos o total de dez questoes),
            add byte[counter], 1   ;caso sejam iguais, mostramos a tela de vitoria, caso não sejam iguais o numero de acertos do
            call random_number     ;usuário com o número total de questões, nós acrescentemaos +1 no contador de acertos e passamos
            call move_random       ;para a próxima questão.

incorrect:
    call video_mode

    blankspace 6
    printf wa
    blankspace 1
    print_cow cow5
    blankspace 2
    printf rst

    .loop:                         ;Essa tela será exibida quando o usuário responder a  
        call read_char             ;questão de forma errada. Primeiro, chamamos o 'video_mode'
        cmp al, 32                 ;para limpar a tela e ativar o modo de video, depois
        je .end                    ;nós printamos as informações na tela utilizando
        jmp .loop                  ;os macros. Após isso, o código fica num loop, o usuário
    .end:                          ;precisa digitar a tecla 'space' (que equivale a 32 na tabela ASCII)                   
        call reset_all             ;para ir para recomeçar o quiz, enquanto ele não dá 'space' como input,
        call random_number         ;a tela não se modifica. Quando o usuário digita 'space' como input, nós zeramos todas as flags (flags essas atreladas as questões)
        call move_random           ;e também zeramos o contador de acertos (tudo isso com a função 'reset_all'), depois disso reiniciamos o quiz.

win_screen:
    call video_mode

    blankspace 6
    printf win
    blankspace 1
    print_cow cow7
    blankspace 2
    printf eins
    blankspace 2
    printf rst
    
    .loop:                         ;Essa tela será exibida quando o usuário responder a  
        call read_char             ;todas as questões do quiz corretamente. Primeiro, chamamos o 'video_mode'
        cmp al, 32                 ;para limpar a tela e ativar o modo de video, depois
        je .end                    ;nós printamos as informações na tela utilizando
        jmp .loop                  ;os macros. Após isso, o código fica num loop, o usuário
    .end:                          ;precisa digitar a tecla 'space' (que equivale a 32 na tabela ASCII)                   
        call reset_all             ;para ir para recomeçar o quiz, enquanto ele não dá 'space' como input,
        call random_number         ;a tela não se modifica. Quando o usuário digita 'space' como input, nós zeramos todas as flags (flags essas atreladas as questões)
        call move_random           ;e também zeramos o contador de acertos (tudo isso com a função 'reset_all'), depois disso reiniciamos o quiz.

menu:
    call video_mode

    blankspace 6
    printf wlcm
    blankspace 1
    print_cow cow8
    blankspace 4
    printf strt

    .loop:
        call read_char
        cmp al, 32
        je .end
        jmp .loop
    .end:
        call reset_all
        call random_number
        call move_random

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    call menu
jmp $
