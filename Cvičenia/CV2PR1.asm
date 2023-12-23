TITLE MASM CV2PR1    (main.asm)
INCLUDE Irvine32.inc

; Nacitajte retazec a vypiste ho na obrazovku tak, aby kazde pismeno retazca bolo na samostatnom riadku.

.data
Dlzka EQU 100 + 1
NacitanyRetazec DB Dlzka DUP(?)

SpravaZadajteRetazec DB "Zadajte retazec: ", 0

.code
main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajteRetazec
    call WriteString

    mov EDX, OFFSET NacitanyRetazec
    mov ECX, Dlzka
    call ReadString
    

    xor ESI, ESI   ; momentalne pismeno

  Vypis:
    mov AL, NacitanyRetazec[ESI]   ; vyber pismeno z retazca
    cmp AL, 0
    jz  Koniec                     ; zastavenie vypisu na ukoncovacej nule
    call WriteChar                 ; vypise znak z registra AL
    call CRLF
    inc ESI
    jmp Vypis

  Koniec:
    exit
main ENDP

END main
