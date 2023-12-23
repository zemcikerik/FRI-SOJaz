TITLE MASM CV4PR2    (main.asm)
INCLUDE Irvine32.inc

; Nacitajte cele cislo bez znamienka v rozsahu <0; 65 535>. Vypocitajte hodnotu cisla a ulozte ju do registra AX.

.data
Dlzka EQU 5 + 1
Retazec DB Dlzka DUP(?)

SpravaZadajteCislo DB "Zadajte cislo z rozsahu <0; 65 535>: ", 0

.code
main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajteCislo
    call WriteString
    
    mov EDX, OFFSET Retazec
    mov ECX, Dlzka
    call ReadString


    ; varovanie: nasledujuci kod vyuziva instrukciu mul, ktora ma implicitne operandy
    ; doporucujem pozriet info o instrukcie v knihe od prof. Janosikovej alebo zaznam / pdf z prednasky
    ; https://frdsa.fri.uniza.sk/~janosik/Kniha/Instr_arit.html


    xor AX, AX             ; vysledne cislo, taktiez implicitny operand instrukcie mul
    mov BX, 10             ; budeme nasobit konstantou 10, pretoze sme v desiatkovej sustave
    mov ECX, 5             ; pocitadlo pre loop, 5 = pocet znakov maximalneho cisla (65 535)
    xor ESI, ESI           ; momentalny index v retazci

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
    ; v registri AX sa nachadza cislo, ktore sme zadali
    ; pre jednoduchsiu kontrolu pouzijeme proceduru WriteInt, ta vsak ocakava cislo v EAX
    ; pre vynulovanie hornej casti EAX pouzijeme instrukciu movzx
    movzx EAX, AX
    call WriteInt

    exit
main ENDP

END main
