TITLE MASM CV3PR1    (main.asm)
INCLUDE Irvine32.inc

; Nacitajte znak. Vypiste pocet vyskytov zadaneho znaku v retazci.

.data
Dlzka EQU 100 + 1
NacitanyRetazec DB Dlzka DUP(?)

SpravaZadajteRetazec DB "Zadajte retazec: ", 0
SpravaZadajteZnak DB "Zadajte znak: ", 0

.code
main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajteRetazec
    call WriteString

    mov EDX, OFFSET NacitanyRetazec
    mov ECX, Dlzka
    call ReadString


    mov EDX, OFFSET SpravaZadajteZnak
    call WriteString
    call ReadChar                        ; nacita znak do registra AL (nevypise spat na konzolu)
    call WriteChar                       ; manualne echo
    call CRLF


    xor EDX, EDX                         ; pocet vyskytov
    xor ESI, ESI                         ; momentalny index v retazci

  Hladanie:
    mov AH, NacitanyRetazec[ESI]
    cmp AH, 0
    jz  Koniec                           ; stop ked narazime na ukoncovaciu nulu

    cmp AH, AL
    jne InyZnak                          ; ak sa momentalny znak nerovna s hladanym, preskoc zvysenie vyskytov
    inc EDX

  InyZnak:
    inc ESI
    jmp Hladanie


  Koniec:
    mov EAX, EDX
    call WriteInt                        ; vypise cislo v registri EAX
    exit
main ENDP

END main
