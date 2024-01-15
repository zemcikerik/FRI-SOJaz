TITLE MASM Skuska12012024		(main.asm)

INCLUDE Irvine32.inc
.data
TeamSNV DB "BK Spisska Nova Ves", 0
TeamSvit DB "Iskra Svit", 0
TeamLevice DB "Patrioti Levice", 0
TeamLucenec DB "BKM Lucenec", 0
TeamPrievidza DB "BC Prievidza", 0
TeamBratislava DB "Inter Bratislava", 0
TeamHandlova DB "MBK Banik Handlova", 0
TeamKomarno DB "MBK Komarno", 0

PocetTeamov EQU 9 - 1 ; okrem Slavie

; kazdy team ma unikatny index od 0 po 7, pomocou ktoreho sa
; dostaneme k jeho menu a informacii ci sme ho uz vypisali

; ostatne data nasledne budu mat priradeny team pomocou tohto indexu

MenoTeamu DD OFFSET TeamSNV, OFFSET TeamSvit, OFFSET TeamLevice
          DD OFFSET TeamLucenec, OFFSET TeamPrievidza, OFFSET TeamBratislava
          DD OFFSET TeamHandlova, OFFSET TeamKomarno

; v principe toto by sme dokazali drzat v jednom registri pomocou individualnych
; bitov, tento approach mi vsak pride jednoduchsi aj na napisanie, aj na pochopenie
BolTeamVypisany DB PocetTeamov DUP(0)     ; 0 = nevypisany, 1 = vypisany

VysledokIndexySuperov DB 0, 1, 2, 3, 4, 5, 6, 7      ; toto ma vyhodu ak by boli teamy poprehadzovane
                      DB 0, 1, 2, 3, 4, 5, 6, 7
                      DB 0, 1, 2, 3, 4, 5, 6, 7

VysledokPocetDanychGolov DB 95, 92, 60, 91, 98, 74, 88, 105
                         DB 82, 85, 75, 81, 77, 73, 97, 77
                         DB 107, 86, 80, 69, 72, 77, 93, 91

VysledokPocetDostanychGolov DB 87, 81, 85, 90, 82, 97, 83, 93
                            DB 94, 94, 88, 98, 92, 77, 89, 72
                            DB 82, 82, 87, 72, 68, 75, 87, 74

PocetOdohratychZapasov EQU 24

SpravaZadajteMinGoly DB "Zadajte minimalny pocet golov: ", 0
SpravaPriemernyPocetGolov DB "Priemerny pocet golov: ", 0

.code
main PROC
    call Clrscr
    finit

    mov EDX, OFFSET SpravaZadajteMinGoly
    call WriteString
    call ReadInt
    call CRLF


    mov EBX, EAX                       ; minimalny pocet golov
    mov ECX, PocetOdohratychZapasov
    xor ESI, ESI                       ; index spracovavaneho vysledku

  VypisVysledkySLepsimVysledkom:
    movzx EAX, VysledokPocetDanychGolov[ESI]
    cmp EAX, EBX
    jb  MenejGolov
    call WriteInt
    mov AL, ':'
    call WriteChar
    movzx EAX, VysledokPocetDostanychGolov[ESI]
    call WriteInt
    call CRLF

   MenejGolov:
    inc ESI
    loop VypisVysledkySLepsimVysledkom

    call CRLF


    mov ECX, PocetOdohratychZapasov
    xor ESI, ESI                       ; index spracovavaneho vysledku
    xor EDI, EDI                       ; sucet poctu golov, pre vypocet priemeru

  VypisMenaTeamov:
    movzx EAX, VysledokPocetDanychGolov[ESI]
    add EDI, EAX
    cmp EAX, EBX
    jl NevypisMenoTeamu

    movzx EDX, VysledokIndexySuperov[ESI]   ; index supera

    cmp BolTeamVypisany[EDX], 1
    jz  NevypisMenoTeamu               ; nevypis meno teamu ak uz bol pred tym vypisany

    mov BolTeamVypisany[EDX], 1        ; oznac team ako vypisany
    mov EDX, MenoTeamu[4*EDX]
    call WriteString
    call CRLF

   NevypisMenoTeamu:
    inc ESI
    loop VypisMenaTeamov

    call CRLF


    ; v registri EDI sa nachadza sucet vsetkych golov, ktore slavia dala
    ; na zasobnik FPU ich dostaneme pomocou triku s normalnym zasobnikom
    push EDI                         ; na zasobnik dame pocet golov
    fild DWORD PTR [ESP]             ; nacitame cislo z vrchola zasobnika do FPU
    pop EDI                          ; cleanup - odstranime cislo zo zasobnika

    ; tento isty trik mozeme pouzit na nacitanie konstanty
    mov DX, PocetOdohratychZapasov
    push DX
    fild WORD PTR [ESP]
    pop DX

    fdiv

    mov EDX, OFFSET SpravaPriemernyPocetGolov
    call WriteString
    call WriteFloat
    call CRLF

    exit
main ENDP

END main
