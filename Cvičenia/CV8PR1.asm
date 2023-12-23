TITLE MASM CV8PR1    (main.asm)
INCLUDE Irvine32.inc

; Sformulujte procedury pre nacitanie a vypis cisla. V procedurach zachovajte nastavenie registrov z volajuceho programu.
; Varovanie: Uloha tohto zadania mi pride dost "vague", existuje viacero spravnych rieseni.

.data
SpravaZadajteCislo DB "Zadajte cislo: ", 0

.code

; vracia cislo v registri AX
NacitajWordSoZnamienkom PROC USES BX ECX DX ESI DI
    LOCAL Retazec[7]: BYTE  ; retazec, do ktoreho nacitame raw string
                            ; mohol by aj definovany v datovom segmente ako vzdy, toto mi vsak pride "spravnejsie"

    lea EDX, Retazec        ; daj do EDX smernik na retazec (nemozeme pouzit mov a OFFSET,
    mov ECX, 7              ; pretoze adresa retazca nie je znama pri kompilacii) 
    call ReadString         ; (alebo pouzi normalnu premennu a mov + OFFSET)


    ; kod z CV5PR1.asm
    xor AX, AX             ; vysledne cislo, taktiez implicitny operand instrukcie mul
    mov BX, 10             ; budeme nasobit konstantou 10, pretoze sme v desiatkovej sustave
    mov ECX, 5             ; pocitadlo pre loop, 5 = pocet znakov maximalneho cisla
    xor ESI, ESI           ; momentalny index v retazci

    xor DI, DI             ; indikuje ci je vysledne cislo zaporne (0 = kladne, 1 zaporne)
                           ; register DI, pretoze je to jediny volny register ktory neskomplikuje jednoduchu
                           ; implementaciu. v principe by sa dala tato hodnota aj umiestnit do pamate ako BYTE

    cmp Retazec, '-'
    jne Parsuj             ; ak je cislo kladne, vsetko je nastavene spravne, zacni s parsovanim

    inc ESI                ; ak je zaporne, tak preskoc '-'
    inc DI                 ;                a nastav indikator na 1

  Parsuj:
    cmp Retazec[ESI], 0
    jz  Koniec             ; prestan, ak narazis na koniec retazca skor

    mul BX                 ; vysledok sa ulozi do dvojice registov DX:AX (DX = 0, ak cislo nepresiahlo horny limit)
    
    movzx DX, Retazec[ESI] ; nacita momentalne cislo (8-bitove) do registra DX tak, ze vynuluje vyssie chybajuce bity
    sub DX, '0'            ; DX obsahuje cislicu v ASCII kode, jej prislusne cislo ziskame odcitanim pozicie '0' v ASCII
    add AX, DX

    inc ESI
    loop Parsuj


  Koniec:
    cmp DI, 0
    jz  Navrat
    neg AX                 ; ak je cislo zaporne, urob na konci dvojkovy doplnok

  Navrat:
    ret
NacitajWordSoZnamienkom ENDP


VypisWord PROC USES AX BX ECX EDX EDI CisloNaVypis: WORD
    LOCAL Retazec[6]: BYTE
    mov Retazec[5], 0


    ; kod z CV6PR1.asm
    mov AX, CisloNaVypis   ; cislo, ktore chceme vypisat
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
    call WriteString
    ret
VypisWord ENDP


main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajteCislo
    call WriteString
    invoke NacitajWordSoZnamienkom

    invoke VypisWord, AX

    exit
main ENDP

END main
