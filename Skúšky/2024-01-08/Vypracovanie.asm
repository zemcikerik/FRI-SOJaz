; TOTO VYPRACOVANIE JE ZLE KVOLI ZLYM DATAM, POKUSIM SA HO OPRAVIT

TITLE MASM Skuska08012024		(main.asm)

INCLUDE Irvine32.inc
.data
Matica DW 011011000b
       DW 101101111b
       DW 110100000b
       DW 011000000b
       DW 100001100b
       DW 110010100b
       DW 010011010b
       DW 010000101b
       DW 010000010b

Nemecko DB "Nemecko", 0
Rakusko DB "Rakusko", 0
Svajciaskso DB "Svajciarsko", 0
Lichtenstajnsko DB "Lichtenstajnsko", 0
Polsko DB "Polsko", 0
Cesko DB "Cesko", 0
Slovensko DB "Slovensko", 0
Madarsko DB "Madarsko", 0
Slovinsko DB "Slovinsko", 0

NazvyStatov DD Nemecko, Rakusko, Svajciaskso, Lichtenstajnsko
            DD Polsko, Cesko, Slovensko, Madarsko, Slovinsko

PocetStatov EQU 9


SpravaPoctySusedov DB "Pocty susedov:", 0Dh, 0Ah, 0
SeparatorPocetSusedov DB ": ", 0

SpravaPrvyIndex DB "Zadajte prvy index: ", 0
SpravaDruhyIndex DB "Zadajte druhy index: ", 0
SpravaSusedia DB "Susedia", 0Dh, 0Ah, 0
SpravaNesusedia DB "Nesusedia", 0Dh, 0Ah, 0

SpravaNajviacSusedov DB "Index statu s najviac susedmi: ", 0

.code
main PROC
    call Clrscr

    mov EDX, OFFSET SpravaPoctySusedov
    call WriteString


    xor BX, BX                   ; BL = index statu s najviac susedmi, BH = pocet jeho susedov
    mov ECX, PocetStatov
    xor ESI, ESI                 ; index momentalneho riadku

  SpracujRiadok:
    push ECX

    mov ECX, PocetStatov
    xor DL, DL                   ; pocet susedov momentalneho statu
    mov DI, 1                    ; maska ku ktoremu bitu prave pristupujeme

    ; postupne posuvame bit masky dolava cim pristupujeme ku vsetkym prvkom riadku matice
    SpracujStlpec:
      mov AX, Matica[2*ESI]
      and AX, DI                 ; instrukcia AND nastavi zero flag podla susednosti
      jz Nesusedia
      inc DL

     Nesusedia:
      shl DI, 1
      loop SpracujStlpec

    cmp DL, BH                   ; ak ma momentalny stat viac susedov ako zatial "najsusednejsi :D"
    jbe MenejAleboRovnakoSusedov
    mov BX, SI                   ; register SI sa neda rozdelit na mensie a obsahuje 8-bitovu hodnotu,
    mov BH, DL                   ; preto skopirujeme celych 16 bitov do BX a hornych 8 neskor prepiseme

  MenejAleboRovnakoSusedov:
    movzx EAX, DL
    mov EDX, NazvyStatov[4*ESI]
    call WriteString

    mov EDX, OFFSET SeparatorPocetSusedov
    call WriteString
    
    call WriteInt
    call CRLF

    pop ECX
    inc ESI
    loop SpracujRiadok

    call CRLF
    

    mov EDX, OFFSET SpravaPrvyIndex
    call WriteString
    call ReadInt

    mov ECX, PocetStatov - 1     ; nakolko indexujeme zlava a maska zacina sprava, "otoc" masku
    sub ECX, EAX
    mov DI, 1                    ; maska podla prveho indexu
    jecxz NultyPrvok             ; ak ma maska mat 1 na nultom bite, nesmieme vykonat cyklus

  PripravMasku:
    shl DI, 1
    loop PripravMasku

  NultyPrvok:
    mov EDX, OFFSET SpravaDruhyIndex
    call WriteString
    call ReadInt

    
    mov EDX, OFFSET SpravaNesusedia
    mov AX, Matica[2*EAX]        ; nacitaj riadok matice podla druheho indexu
    and AX, DI                   ; skontroluj ci susedi s prvym indexom podla masky
    jz  IndexyNesusedia

    mov EDX, OFFSET SpravaSusedia

  IndexyNesusedia:
    call WriteString
    call CRLF


    mov EDX, OFFSET SpravaNajviacSusedov
    call WriteString
    
    movzx EAX, BL
    call WriteInt

    ; extra
    mov AL, ' '
    call WriteChar
    mov AL, '('
    call WriteChar
    movzx ESI, BL
    mov EDX, NazvyStatov[4*ESI]
    call WriteString
    mov AL, ')'
    call WriteChar
    call CRLF


    exit
main ENDP

END main
