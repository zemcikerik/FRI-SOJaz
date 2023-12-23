TITLE MASM CV7PR2    (main.asm)
INCLUDE Irvine32.inc

; Nacitajte postupnost cisiel typu word. Vypiste najmensie cislo a jeho poradie v postupnosti.

.data
PocetCisel EQU 10
Postupnost DW PocetCisel DUP(?)

SpravaZadajtePostupnost DB "Zadajte 10 cisel postupnosti:", 0Ah, 0Dh, 0
SpravaNajnizsieCislo DB "Najnizsie cislo: ", 0
SpravaIndex DB "Index najnizsieho cisla: ", 0

.code
main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajtePostupnost
    call WriteString

    
    mov ECX, PocetCisel
    xor EDI, EDI                    ; index v postupnosti

  NacitajCisla:
    call ReadInt
    mov Postupnost[2*EDI], AX       ; uloz nacitane cislo do postupnosti, 2*EDI pretoze 16-bitove cisla (WORD-y)
    inc EDI
    loop NacitajCisla



    mov AX, Postupnost              ; hodnota najmensieho cisla postupnosti, na zaciatku prve cislo
    xor EBX, EBX                    ; index najmensieho cisla postupnosti
    mov ECX, PocetCisel - 1         ; -1 pretoze prve cislo sme spracovali manualne, pojdeme od druheho (index 1)
    mov ESI, 1                      ; index v postupnosti

  NajdiNajmensieCislo:
    mov DX, Postupnost[2*ESI]
    cmp DX, AX
    jge VacsieAleboRovne

    mov AX, DX
    mov EBX, ESI

   VacsieAleboRovne:
    inc ESI
    loop NajdiNajmensieCislo


  
    call CRLF
    mov EDX, OFFSET SpravaNajnizsieCislo
    call WriteString

    movsx EAX, AX
    call WriteInt
    call CRLF

    mov EDX, OFFSET SpravaIndex
    call WriteString

    mov EAX, EBX
    call WriteInt
    call CRLF

    exit
main ENDP

END main
