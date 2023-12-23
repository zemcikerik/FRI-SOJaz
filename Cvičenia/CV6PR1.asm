TITLE MASM CV6PR1    (main.asm)
INCLUDE Irvine32.inc

; Vypiste obsah registra AX v desiatkovej sustave.

.data
Retazec DB 5 DUP (?), 0

.code
main PROC
    call Clrscr

    ; varovanie: nasledujuci kod vyuziva instrukciu div, ktora ma implicitne operandy
    ; doporucujem pozriet info o instrukcie v knihe od prof. Janosikovej alebo zaznam / pdf z prednasky
    ; https://frdsa.fri.uniza.sk/~janosik/Kniha/Instr_arit.html

    ; pointa tejto ulohy je urobit to, co robi procedura WriteInt za nas
    mov AX, -2412          ; cislo, ktore chceme vypisat
    mov BX, 10             ; budeme delit konstantou 10, pretoze vypisujeme cislo v desiatkovej sustave
    mov ECX, 5             ; pocitadlo pre loop, 5 = pocet znakov maximalneho cisla
    mov EDI, 4             ; index vo vyslednom retazci (vyplnujeme odzadu)

    ; ak je cislo negativne, vypiseme hned na zaciatku znak minus '-' a cislo znegujeme
    cmp AX, 0
    jge Vypis

    push AX                ; odlozime cislo na zasobnik, pretoze potrebujeme register AL pre vypis
    mov AL, '-'
    call WriteChar
    pop AX                 ; vyber cislo zo zasobnika
    neg AX

  Vypis:
    xor DX, DX             ; implicitny operand pre div, vyssich 16 bitov 32 bitoveho cisla,
                           ; v tomto pripade musi byt nastaveny na 0 pred delenim

    div BX                 ; ulozi podiel do AX a zvysok do DX
    add DX, '0'            ; posun zvysok na spravnu poziciu v ASCII
    mov Retazec[EDI], DL

    cmp AX, 0
    jz  Koniec

    dec EDI
    loop Vypis


  Koniec:
    lea EDX, Retazec[EDI]  ; nacitaj adresu zaciatku cisla posunutu o hodnotu v EDI do registra EDX
                           ; ekvivalent pre: mov EDX, OFFSET Retazec
                           ;                 add EDX, EDI
    call WriteString
    call CRLF

    exit
main ENDP

END main
