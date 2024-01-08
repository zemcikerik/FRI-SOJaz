TITLE MASM Skuska08012024		(main.asm)

INCLUDE Irvine32.inc
.data
Matica DB 01101100b
       DB 10110111b
       DB 11010000b
       DB 01100000b
       DB 10000110b
       DB 11001010b
       DB 01001101b
       DB 01000010b

Nemecko DB "Nemecko", 0
Rakusko DB "Rakusko", 0
Svajciaskso DB "Svajciarsko", 0
Lichtenstajnsko DB "Lichtenstajnsko", 0
Polsko DB "Polsko", 0
Cesko DB "Cesko", 0
Slovensko DB "Slovensko", 0
Madarsko DB "Madarsko", 0

NazvyStatov DD Nemecko, Rakusko, Svajciaskso, Lichtenstajnsko
            DD Polsko, Cesko, Slovensko, Madarsko

PocetStatov EQU 8


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

    mov AL, Matica[ESI]          ; momentalny riadok matice
    xor CL, CL                   ; pocet susedov momentalneho statu
    mov CH, 1                    ; maska ku ktoremu bitu prave pristupujeme

    ; tento cyklus sa vykona 8 krat kvoli 8-bitovemu registru
    ; postupne posuvame bit masky dolava cim pristupujeme ku vsetkym prvkom riadku matice
    SpracujStlpec:
      mov DL, AL                 ; skopiruj momentalny riadok matice
      and DL, CH                 ; instrukcia AND nastavi zero flag podla susednosti
      jz Nesusedia
      inc CL

     Nesusedia:
      shl CH, 1
      jnc SpracujStlpec

    cmp CL, BH                   ; ak ma momentalny stat viac susedov ako zatial "najsusednejsi :D"
    jbe MenejAleboRovnakoSusedov
    mov BX, SI                   ; register SI sa neda rozdelit na mensie a obsahuje 8-bitovu hodnotu,
    mov BH, CL                   ; preto skopirujeme celych 16 bitov do BX a hornych 8 neskor prepiseme

  MenejAleboRovnakoSusedov:
    mov EDX, NazvyStatov[4*ESI]
    call WriteString

    mov EDX, OFFSET SeparatorPocetSusedov
    call WriteString
    
    movzx EAX, CL
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
    mov BH, 1                    ; maska podla prveho indexu
    jecxz NultyPrvok             ; ak ma maska mat 1 na nultom bite, nesmieme vykonat cyklus

  PripravMasku:
    shl BH, 1
    loop PripravMasku

  NultyPrvok:
    mov EDX, OFFSET SpravaDruhyIndex
    call WriteString
    call ReadInt

    
    mov EDX, OFFSET SpravaNesusedia
    mov AL, Matica[EAX]          ; nacitaj riadok matice podla druheho indexu
    and AL, BH                   ; skontroluj ci susedi s prvym indexom podla masky
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
