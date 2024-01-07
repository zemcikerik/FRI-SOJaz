TITLE MASM SkuskaMenoRedactedOops	(main.asm)

INCLUDE Irvine32.inc
.data

Matica DB 0, 1, 1, 0, 1, 1, 0, 0, 0
       DB 1, 0, 1, 1, 0, 1, 1, 1, 1
       DB 1, 1, 0, 1, 0, 0, 0, 0, 0
       DB 0, 1, 1, 0, 0, 0, 0, 0, 0
       DB 1, 0, 0, 0, 0, 1, 1, 0, 0
       DB 1, 1, 0, 0, 1, 0, 1, 0, 0
       DB 0, 1, 0, 0, 1, 1, 0, 1, 0
       DB 0, 1, 0, 0, 0, 0, 1, 0, 1
       DB 0, 1, 0, 0, 0, 0, 0, 1, 0

Nemecko DB "Nemecko", 0
Rakusko DB "Rakusko", 0
Svajciarsko DB "Svajciarsko", 0
Lichtenstajnsko DB "Lichtenstajnsko", 0
Polsko DB "Polsko", 0
Cesko DB "Cesko", 0
Slovensko DB "Slovensko", 0
Madarsko DB "Madarsko", 0
Slovinsko DB "Slovinsko", 0

PocetKrajin EQU 9

NazvyKrajin DD Nemecko, Rakusko, Svajciarsko, Lichtenstajnsko
            DD Polsko, Cesko, Slovensko, Madarsko, Slovinsko

SpravaIndexNajviacSusedov DB "Index krajiny s najviac susedmi: ", 0
SpravaZadajteIndex DB "Zadajte index krajiny: ", 0
SpravaListSusednychKrajin DB "List susednych krajin: ", 0Ah, 0Dh, 0
SpravaIndexMimoRozsahu DB "Index mimo rozsahu!", 0Ah, 0Dh, 0
Separator DB ": ", 0

.code
main PROC
    call Clrscr

    xor EAX, EAX ; riadok
    mov ECX, PocetKrajin
    xor ESI, ESI  ; index v matici

    xor EBX, EBX ; krajina najviac susedov - pocet
    xor EDI, EDI ; krajina najviac susedov - index

  SpracujRiadky:
    push ECX
    mov ECX, PocetKrajin

    mov EDX, NazvyKrajin[4*EAX]
    call WriteString
    mov EDX, OFFSET Separator
    call WriteString

    xor EDX, EDX ; pocet susedov

    SpracujStlpce:
      cmp Matica[ESI], 0
      jz  NieSuSusedne
      inc EDX

     NieSuSusedne:
      inc ESI
      loop SpracujStlpce

    push EAX
    mov EAX, EDX
    call WriteInt
    pop EAX
    call CRLF

    cmp EDX, EBX
    jle MenejAleboRovnakoSusedov
    mov EBX, EDX
    mov EDI, EAX


  MenejAleboRovnakoSusedov:
    pop ECX
    inc EAX
    loop SpracujRiadky


    call CRLF
    mov EDX, OFFSET SpravaIndexNajviacSusedov
    call WriteString
    
    mov EAX, EDI
    call WriteInt

    mov AL, ' '
    call WriteChar
    mov AL, '('
    call WriteChar
    mov EDX, NazvyKrajin[4*EDI]
    call WriteString
    mov AL, ')'
    call WriteChar
    call CRLF
    call CRLF


    mov EDX, OFFSET SpravaZadajteIndex
    call WriteString
    call ReadInt

    cmp EAX, 0
    jl MimoRozsah
    cmp EAX, PocetKrajin
    jge MimoRozsah


    mov EDX, OFFSET SpravaListSusednychKrajin
    call WriteString


    ; prehladavanie stlpca
    mov ECX, PocetKrajin
    mov ESI, EAX ; index v matici
    xor EBX, EBX ; krajina na porovnanie
    mov AL, 9h ; tab

  PrejdiSusedneKrajiny:
    cmp Matica[ESI], 0
    jz  Nesusedia
    
    call WriteChar
    mov EDX, NazvyKrajin[4*EBX]
    call WriteString
    call CRLF

   Nesusedia:
    inc EBX
    add ESI, PocetKrajin
    loop PrejdiSusedneKrajiny

    exit

  MimoRozsah:
    mov EDX, OFFSET SpravaIndexMimoRozsahu
    call WriteString
    exit
main ENDP

END main
