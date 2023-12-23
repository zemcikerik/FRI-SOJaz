TITLE MASM CV10PR1    (main.asm)
INCLUDE Irvine32.inc

; Zostavte program, ktory vypocita strednu hodnotu nahodnej premennej "vyska pritomnych v triede".

.data
Pocet EQU 16
PocetPamat DD Pocet

Vysky DW 173, 178, 179, 185, 169, 186, 192, 190, 184, 173, 168, 186, 183, 180, 184, 183

.code

main PROC
    call Clrscr
    finit                         ; inicializuje FPU

    ; nakolko su vysky cele cisla, dalo by sa ich scitat aj mimo FPU

    mov ECX, Pocet - 1
    mov ESI, 1                    ; index momentalnej vysky
    fild Vysky                    ; nacitaj prvu hodnotu manualne, pouzivame fild pretoze ide o cele cislo
                                  ; ak by sme chceli nacitat float, pouzili by sme instrukciu fld

  ScitajHodnotyNaFPU:
    fild Vysky[2*ESI]
    fadd                          ; scita dve hodnoty na vrchole FPU zasobnika, ponecha iba vysledok na vrchole
    inc ESI
    loop ScitajHodnotyNaFPU

    fild PocetPamat               ; dalo by sa aj bez definovania pomocnej premennej (vid README.md)
    fdiv

    call WriteFloat               ; vypise hodnotu na vrchole FPU zasobnika (st(0))

    exit
main ENDP

END main
