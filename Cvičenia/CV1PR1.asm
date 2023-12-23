TITLE MASM CV1PR1    (main.asm)
INCLUDE Irvine32.inc

; Nacitajte retazec a znovu ho vypiste na obrazovku.
; Po vypise retazca presunte kurzor na novy riadok.

.data
Dlzka EQU 100 + 1
NacitanyRetazec DB Dlzka DUP(?)

.code
main PROC
    call Clrscr

    mov EDX, OFFSET NacitanyRetazec    ; destinacia
    mov ECX, Dlzka                     ; dlzka retazca (aj s ukoncovacou nulou)
    call ReadString
    
    call WriteString                   ; berie zdroj z registra EDX, vypisuje po ukoncovaciu nulu
    call CRLF                          ; posun na dalsi riadok (vypise 0Dh, 0Ah)

    exit
main ENDP

END main
