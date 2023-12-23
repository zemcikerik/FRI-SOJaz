TITLE MASM CV2PR2    (main.asm)
INCLUDE Irvine32.inc

; Vypiste retazec na obrazovku tak, aby kazde pismeno retazca spolu s nasledujucim pismenom v abecede bolo na samostatnom riadku.
; Napr. retazec AHOJ sa vypise takto:
; AB
; HI
; OP
; JK

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
    

    xor ESI, ESI   ; momentalny index v retazci

  Vypis:
    mov AL, NacitanyRetazec[ESI]   ; vyber pismeno z retazca
    cmp AL, 0
    jz  Koniec                     ; zastavenie vypisu na ukoncovacej nule
    call WriteChar                 ; vypise znak z registra AL
    inc AL
    call WriteChar
    call CRLF
    inc ESI
    jmp Vypis

  Koniec:
    exit
main ENDP

END main
