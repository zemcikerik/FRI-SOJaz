TITLE MASM CV4PR1    (main.asm)
INCLUDE Irvine32.inc

; Nacitajte retazec R. Skopirujte R do retazca S tak, ze dvojicu pismen 'as' nahradite znakom '*'.
; Retazec S vypiste. Pri pristupe k retazcom pouzite nepriamu adresu s bazou a indexom.

.data
Dlzka EQU 100 + 1
ZdrojovyRetazec DB Dlzka DUP(?)
VyslednyRetazec DB Dlzka DUP(?)

SpravaZadajteRetazec DB "Zadajte retazec: ", 0

.code
main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajteRetazec
    call WriteString

    mov EDX, OFFSET ZdrojovyRetazec
    mov ECX, Dlzka
    call ReadString

    
    mov EBX, OFFSET ZdrojovyRetazec    ; baza zdrojoveho retazca
    mov ECX, OFFSET VyslednyRetazec    ; baza cieloveho retazca
    xor ESI, ESI                       ; index v zdrojovom retazci
    xor EDI, EDI                       ; index v cielovom retazci

  Kopirovanie:
    mov AL, [EBX + ESI]                ; skopiruj momentalny znak zo zdrojoveho retazca
    cmp AL, 0
    jz  Koniec

    cmp AL, 'a'                        ; skontroluj ci dva nasledujuce znaky nie su "as"
    jne InaSekvencia

    cmp [EBX + ESI + 1], BYTE PTR 's'  ; vysvetlenie pre BYTE PTR je nizsie
    jne InaSekvencia

    ; v tomto bode vieme, ze sa nachadzame na sekvencii "as"
    ; daj do cielu '*' a posun zdrojovy index o 2 (preskok "as")
    mov [ECX + EDI], BYTE PTR '*'      ; kompilator nevie aku velkost ma mat '*', nakolko na lavej strane je adresa z registra
    inc ESI                            ; (normalne by zobral tuto informaciu z velkosti symbolu (BYTE, WORD, ...)),
    inc ESI                            ; preto mu to musime povedat manualne pomocou "BYTE PTR" (nech '*' je jednobajtova)
    inc EDI
    jmp Kopirovanie

   InaSekvencia:
    mov [ECX + EDI], AL                ; nie je hladana sekvencia, skopiruj do ciela
    inc ESI
    inc EDI
    jmp Kopirovanie

    
  Koniec:
    ; kopirujeme po nulu (bez), treba do cieloveho retazca este umiestnit ukoncovaciu nulu
    mov [ECX + EDI], BYTE PTR 0


    mov EDX, OFFSET VyslednyRetazec
    call WriteString
    call CRLF


    exit
main ENDP

END main
