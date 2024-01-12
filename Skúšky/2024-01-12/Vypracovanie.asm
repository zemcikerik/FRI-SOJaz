TITLE MASM Skuska12012024		(main.asm)

INCLUDE Irvine32.inc
.data
Matica DB 102,  98,  96,  94,  92,  91,  78,  82, 103, 107
       DB  99, 100,  98,  90,  75, 104,  99,  84, 152,  99
       DB  98,  95,  94,  95,  73,  64,  98,  86,  88,  93
       DB  83,  90,  80,  82,  84,  84,  71,  88,  98,  92
       DB  99,  81,  82,  78,  83,  78,  73, 102,  99,  90
       DB 100, 102,  82,  77,  76,  75,  95,  96,  90,  89
       DB  91,  84, 103,  94,  96,  82,  94,  93,  99,  99
       DB  98,  90,  91,  92,  95,  98,  92,  96,  94, 101
       DB 100,  96,  93,  96,  96,  94,  93,  95,  97, 100
       DB  99,  88,  94, 102,  98, 100,  91,  90,  96,  98

; matica je stvorcova, staci jeden rozmer 
RozmerMatice EQU 10
PocetPrvkov EQU RozmerMatice * RozmerMatice

SpravaZadajteIndexRiadok DB "Zadajte index riadku: ", 0
SpravaZadajteIndexStlpec DB "Zadajte index stlpca: ", 0
SpravaSusedia DB "Susedia:", 0Dh, 0Ah, 0
SpravaIndexyNajnizsiehoSusednehoPrvku DB "Indexy najnizsieho susedneho prvku (riadok, stlpec): (", 0
SpravaNajnizsiPodlaHeuristiky DB "Najnizsi prvok podla heuristiky: ", 0

.code

; VSTUP: EBX = prvok, ktoreho susedne prvky vypise
;        EDX = index stlpca prvku
VypisSusedovPrvku PROC
    ; nakolko nepotrebujeme ponechat hodnoty v inych registroch ako EBX, ECX a EDX,
    ; a hodnoty spomenutych registrov v procedure neprepisujeme, nepotrebujeme ich pridat
    ; do "USES" a mozeme volat proceduru pomocou call


    ; horny sused
    mov ESI, EBX               ; posunuty index o riadok
    sub ESI, RozmerMatice      ; odcitaj pocet prvkov riadku = posunie nas o riadok vyssie
    jc  NemaHornehoSuseda      ; v tomto pripade sub nastavi carry flag ak vysledok < 0
                               ; (pretoze vzdy odcitavame z cisla >= 0)
    movzx EAX, Matica[ESI]
    call WriteInt
    call CRLF

  NemaHornehoSuseda:

    ; lavy sused
    mov EAX, EDX               ; posunuty index stlpca
    sub EAX, 1                 ; pre posun musime pouzit instrukciu sub, pretoze instrkucia
    jc  NemaLavehoSuseda       ; dcx nemeni carry flag

    movzx EAX, Matica[EBX - 1]
    call WriteInt
    call CRLF

  NemaLavehoSuseda:

    ; pravy sused
    mov EAX, EDX               ; posunuty index stlpca
    inc EAX
    cmp EAX, RozmerMatice      ; skontroluj ci index + 1 < pocet stlpcov
    jae NemaPravehoSuseda

    movzx EAX, Matica[EBX + 1]
    call WriteInt
    call CRLF

  NemaPravehoSuseda:

    ; spodny sused
    mov ESI, EBX               ; posunuty index o riadok
    add ESI, RozmerMatice      ; pricitaj pocet prvkov riadku = posunie nas o riadok nizsie
    cmp ESI, PocetPrvkov       ; skontroluj ci vysledny index < celkovy pocet prkov
    jae NemaSpodnehoSuseda

    movzx EAX, Matica[ESI]
    call WriteInt
    call CRLF


  NemaSpodnehoSuseda:
    ret
VypisSusedovPrvku ENDP


; VSTUP: EBX = prvok, ktoreho susedne prvky prehladavame
;        ECX = index riadku prvku
;        EDX = index stlpca prvku

; VYSTUP: EBX = index prvku v matici najmensieho najdeneho prvku
;         ECX = index riadku najdeneho prvku
;         EDX = index stlpca najdeneho prvku
NajdiNajmensiSusednyPrvok PROC
    ; deklarujeme lokalne premenne v ktorych budeme ukladat momentalne informacie
    ; o zatial najmensiom prvku (v principe stacia iba registre, toto je vsak jednoduchsie)
    LOCAL RiadokNajmensiehoPrvku: DWORD
    LOCAL StlpecNajmensiehoPrvku: DWORD
    LOCAL IndexNajmensiehoPrvku: DWORD

    ; inicializujeme hodnotu najmensieho prvku na najvacsiu moznu hodnotu
    mov AL, 0FFh               ; hodnota momentalne najmensieho prvku

    ; v lokalnych premennach sa momentalne nachadza bordel, to nam vsak nevadi,
    ; pretoze ich budeme nastavovat ak bude kontrolovany prvok <= najmensiemu prvku


    ; v tejto procedure budeme pouzivat rovnake prehladavanie susednych prvkov
    ; ako v procedure VypisSusedovPrvku, pre viac info o prehladavani nahliadnite tam

    ; horny sused
    mov ESI, EBX               ; posunuty index o riadok
    sub ESI, RozmerMatice
    jc NemaHornehoSuseda

    mov AH, Matica[ESI]        ; hodnota horneho suseda
    cmp AL, AH                 ; porovnaj najmensi prvok s hornym susedom
    jb  HornySusedPrivelky

    ; v tomto bode je horny sused < zatial najmensi prvok
    mov AL, AH                 ; nastav najmensi prvok na horneho suseda

    push ECX
    dec ECX
    mov RiadokNajmensiehoPrvku, ECX
    pop ECX
    mov StlpecNajmensiehoPrvku, EDX
    mov IndexNajmensiehoPrvku, ESI

    
    ; od tohto bodu sa opakuje pattern vyssie s kontrolou z procedury VypisSusedovPrvku


  NemaHornehoSuseda:
  HornySusedPrivelky:


    ; lavy prvok
    mov EDI, EDX
    sub EDI, 1
    jc  NemaLavehoSuseda

    mov AH, Matica[EBX - 1]
    cmp AL, AH
    jb  LavySusedPrivelky

    mov AL, AH
    mov RiadokNajmensiehoPrvku, ECX
    mov StlpecNajmensiehoPrvku, EDI
    push EBX
    dec EBX
    mov IndexNajmensiehoPrvku, EBX
    pop EBX


  NemaLavehoSuseda:
  LavySusedPrivelky:

    ; pravy prvok
    mov EDI, EDX
    inc EDI
    cmp EDI, RozmerMatice
    jae NemaPravehoSuseda

    mov AH, Matica[EBX + 1]
    cmp AL, AH
    jb  PravySusedPrivelky

    mov AL, AH
    mov RiadokNajmensiehoPrvku, ECX
    mov StlpecNajmensiehoPrvku, EDI
    push EBX
    inc EBX
    mov IndexNajmensiehoPrvku, EBX
    pop EBX


  NemaPravehoSuseda:
  PravySusedPrivelky:


    ; spodny sused
    mov ESI, EBX
    add ESI, RozmerMatice
    cmp ESI, PocetPrvkov
    jae NemaSpodnehoSuseda

    mov AH, Matica[ESI]
    cmp AL, AH
    jb  SpodnySusedPrivelky

    mov AL, AH
    push ECX
    inc ECX
    mov RiadokNajmensiehoPrvku, ECX
    pop ECX
    mov StlpecNajmensiehoPrvku, EDX
    mov IndexNajmensiehoPrvku, ESI

  
  NemaSpodnehoSuseda:
  SpodnySusedPrivelky:

    ; nastavime navratove hodnoty podla ulozenych informacii
    mov EBX, IndexNajmensiehoPrvku
    mov ECX, RiadokNajmensiehoPrvku
    mov EDX, StlpecNajmensiehoPrvku
    ret
NajdiNajmensiSusednyPrvok ENDP


main PROC
    call Clrscr

    mov EDX, OFFSET SpravaZadajteIndexRiadok
    call WriteString
    call ReadInt

    mov ECX, EAX                   ; index riadku budeme potrebovat neskor, odlozime ho do ECX

    ; v EAX sa nachadza index riadku, vypocitame si na ktorom indexe prvku
    ; zacina dany riadok (IndexRiadku * PocetPrvkovVStlpci = IndexPrvehoPrvkuVRiadku)

    mov EBX, RozmerMatice
    mul EBX                        ; EAX * EBX = EDX:EAX

    ; v EAX sa teraz nachadza index prveho prvku daneho riadku,
    ; odlozime ho do EBX a nacitame index stlpca

    mov EBX, EAX
    mov EDX, OFFSET SpravaZadajteIndexStlpec
    call WriteString
    call ReadInt

    ; EBX = prvok, okolo ktoreho budeme prehladavat
    ; ZaciatocnyPrvok = IndexPrvehoPrvkuVRiadku + IndexStlpca
    add EBX, EAX

    ; index stlpca budeme este neskor potrebovat, odlozime ho do EDX
    mov EDX, EAX


    ; V tomto zadani je potrebne prehladavat susedov prvku.
    
    ; Pri prehladavni sa dokazeme jednoducho dostat k susednym prvkom pomocou
    ; indexu momentalneho prvku v matici, nedokazame vsak jednoducho skontrolovat
    ; ci sme na zaciatku riadka / konci riadka. Na toto si potrebujeme pamatat index stlpca prvku.

    ; V pripade riadka je kontrola jednoducha, staci aby index prvku bol >= 0 a < PocetPrvkov v matici.
    ; Index riadka si aj tak pamatame nadalej, bude sa nam hodit pre vypisovanie indexu susednych prvkov.


    ; vypis momentalny prvok a jeho susedov
    movzx EAX, Matica[EBX]
    call WriteInt
    call CRLF
    call CRLF
    call VypisSusedovPrvku
    call CRLF

    
    push EDX
    mov EDX, OFFSET SpravaIndexyNajnizsiehoSusednehoPrvku
    call WriteString
    pop EDX

    ; vypis indexy najmensieho susedneho prvku
    push EBX                        ; uchovaj index momentalneho prvku (tento register sa prepise pri volani procedury)
    call NajdiNajmensiSusednyPrvok
    
    mov EAX, ECX
    call WriteInt                   ; vypis riadok
    mov AL, ','
    call WriteChar                  ; formatovanie
    mov EAX, EDX
    call WriteInt                   ; vypis stlpec
    mov AL, ')'
    call WriteChar                  ; formatovanie
    call CRLF
    call CRLF


    ; heuristika "Best Admissible"
    ; pouzijeme vysledky z uz vykonaneho prehladavania kvoli predchazdajucej ulohe

    pop ESI                         ; index zadaneho prvku (odlozeny pred prehladavanim)
    mov AL, Matica[ESI]             ; do AL budeme odkladat najnizsi zatial dosiahnuty prvok
                                    ; a budeme prehladavat susedov tohto prvku

  BestAdmissibleLoop:
    mov AH, Matica[EBX]             ; hodnota najmensieho suseda
    cmp AL, AH                      ; porovnaj momentalny prvok s najnizsim susedom
    jbe Koniec                      ; koncime, ak neexistuje nizsi sused

    mov AL, AH                      ; nizsi prvok sa stava najnizsim, prehladavame jeho okolie
    push AX                         ; procedura prepise stav registra AX, preto ho odlozime
                                    ; (v principe nam staci AL, ale pushnut mozeme min. 16-bitovy register)
    call NajdiNajmensiSusednyPrvok
    pop AX
    jmp BestAdmissibleLoop

  Koniec:
    ; v registri AL sa nachadza najnizsi prvok podla heuristiky
    mov EDX, OFFSET SpravaNajnizsiPodlaHeuristiky
    call WriteString
    
    movzx EAX, AL
    call WriteInt
    call CRLF

    exit
main ENDP

; Na niektorych miestach su mov instrukcie navyse, ktore by sa dali zmazat (napr. niektore veci sa daju
; posunut ako dalsie parametre). Pre zjednodusenie citania kodu to vsak nechavam takto.

END main
