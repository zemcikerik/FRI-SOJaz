TITLE MASM CV8PR1    (main.asm)
INCLUDE Irvine32.inc

; Vytvorte bitovu reprezentaciu prazdnej mnoziny X, ktora moze obsahovat cisla z intervalu <0;31>.
; Vlozte do mnoziny 10 nahodne vygenerovanych cisiel z intervalu <0;31>.
; Vypiste mnozinu z jej bitovej reprezentacie.
; Vytvorte proceduru, ktora vygeneruje 10-prvkovu mnozinu celych cisiel z intervalu <0;31>. Mnozina je parameter procedury volany odkazom.
; Vytvorte proceduru pre vypis mnoziny z jej bitovej reprezentacie. Mnozina je parameter volany hodnotou.
; Vygenerujte mnozinu X. Vypocitajte a vypiste jej doplnok.
; Vygenerujte druhu mnozinu Y. Vypocitajte a vypiste prienik a zjednotenie mnozin X a Y.

.data
MnozinaX DD 0                 ; bitova reprezentacia mnoziny
MnozinaY DD 0

.code
VygenerujMnozinu PROC USES EAX EBX ECX EDX AdresaMnoziny: DWORD
    mov EBX, AdresaMnoziny   ; smernik na vystup
    mov ECX, 10              ; chceme vygenerovat 10 nahodnych prvkov
    xor EDX, EDX             ; vygenerovana mnozina

  VygenerujNahodnePrvky:
    mov EAX, 32              ; generujeme hodnoty od 0 do 31, vstupny parameter pre RandomRange
    call RandomRange         ; vlozi do EAX nahodne cislo podla parametra v EAX
    push ECX

    mov CL, AL               ; jediny register, ktory sa da pouzit ako operand instrukcie shl
    mov EAX, 1
    shl EAX, CL
    or  EDX, EAX         ; zarad nahodny prvok do mnoziny

    pop ECX
    loop VygenerujNahodnePrvky

    mov [EBX], EDX
    ret
VygenerujMnozinu ENDP


VypisMnozinu PROC USES EAX Mnozina: DWORD
    mov EAX, Mnozina
    call WriteBin
    call CRLF
    ret
VypisMnozinu ENDP


main PROC
    call Clrscr
    call Randomize           ; musi sa zavolat na zaciatku pre nahodny seed (plni rovnaky ucel ako srand v C)

    invoke VygenerujMnozinu, OFFSET MnozinaX
    invoke VypisMnozinu, MnozinaX

    ; doplnok mnoziny X
    mov EAX, MnozinaX
    not EAX
    invoke VypisMnozinu, EAX

    invoke VygenerujMnozinu, OFFSET MnozinaY
    invoke VypisMnozinu, MnozinaY

    ; zjednotenie mnoziny X a Y
    mov EAX, MnozinaX
    or  EAX, MnozinaY
    invoke VypisMnozinu, EAX

    ; prienik mnoziny X a Y
    mov EAX, MnozinaX
    and EAX, MnozinaY
    invoke VypisMnozinu, EAX

    exit
main ENDP

END main
