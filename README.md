Pred priamym skopírovaním do kódu je potrebné odstrániť diakritické znamienka (napr. pomocou: https://codebeautify.org/remove-accents).

### Výpis 8/16-bitového celého čísla bez znamienka

```asm
push EAX             ; ak budeme potrebovať hodnotu v EAX
movzx EAX, <ZDROJ>   ; zdroj = AX, DL, Pamäť, ...
call WriteInt
pop EAX              ; obnov hodnotu z EAX
```

### Výpis 8/16-bitového celého čísla so znamienkom

```asm
push EAX             ; ak budeme potrebovať hodnotu v EAX
movsx EAX, <ZDROJ>   ; zdroj = AX, DL, Pamäť, ...
call WriteInt
pop EAX              ; obnov hodnotu z EAX
```

### Načítanie 16-bitového celého čísla na vrchol FPU zásobníka st(0) z registra

```asm
push AX              ; dočasne pushni zdroj na zásobník
fild WORD PTR [ESP]  ; načítaj pushnuté celé číslo z vrchola zásobníka
pop AX               ; cleanup
```

### Načítanie 32-bitového celého čísla na vrchol FPU zásobníka st(0) z registra

```asm
push EAX             ; dočasne pushni zdroj na zásobník
fild DWORD PTR [ESP] ; načítaj pushnuté celé číslo z vrchola zásobníka
pop EAX              ; cleanup
```

### Odstránenie čísla z vrchola FPU zásobníka st(0)

```asm
fstp st(0)           ; ulož číslo z st(0) do st(0) a popni ho
```

### Porovnávanie čísel s pohyblivou radovou čiarkou na FPU

```asm
; nech v st(0) = A a st(1) = B sú čísla, ktoré chceme porovnať
fcom                 ; porovnaj číslo A s číslom B
fstsw AX             ; načítaj výsledok komparácie do EFLAGS pomocou registra AX
sahf                 ; (ak je v ňom niečo potrebné, pushni a popni!)

; v tomto bode môžeme použiť skokové inštrukcie pre čísla bez znamienka, napríklad:
jbe Navestie         ; skoč na zadané návestie ak A <= B    [st(0) <= st(1)]
ja  Navestie         ; skoč na zadané návestie ak A > B     [st(0) > st(1)]
```

Pre skoky sa v tomto prípade vždy používajú skokové inštrukcie pre čísla **bez** znamienka, aj keď ich dané číslá s pohyblivou radovou čiarkou majú.

Tento kód nemusí vždy fungovať kvôli limitovanej presnosti čísel pohyblivej radovej čiarky (hlavne pri veľmi veľkých číslach).
Kód pre bezpečné porovnávanie je uvedený v ďalšej sekcií.
*Na zadania z tohto predmetu je však pravdepobone postačujúci, výber porovnávacej metódy nechávam na Vás.*

### Bezpečné porovnávanie čísel s pohyblivou radovou čiarkou na FPU

V dátovom segmente definujeme presnosť `Epsilon`, s ktorou chceme porovnávať:
```asm
.data
Epsilon DD 0.00001   ; tolerancia
```

Kód pre porovnanie:
```asm
; nech v st(0) = A a st(1) = B sú čísla, ktoré chceme porovnať
fld st(0)            ; zduplikuj číslo - teraz sa nachádza na st(0) a st(1)
                     ;                   a druhé číslo bolo posunuté do st(2)
fsub st(0), st(2)
fcom Epsilon         ; porovnaj A - B s toleranciou
fstsw AX             ; načítaj výsledok komparácie do EFLAGS pomocou registra AX
sahf                 ; (ak je v ňom niečo potrebné, pushni a popni!)
ja AJeVacsie

fabs
fcomp Epsilon        ; porovnaj |A - B| s toleranciou
fstsw AX
sahf
jbe CislaSuRovnake

; v tomto bode je A < B

AJeVacsie:
fstp st(0)           ; v st(0) sa stále nachádza A - B, popni ho pre vyčistenie
; v tomto bode je A > B

CislaSuRovnake:
; v tomto bode je A = B podľa tolerancie
```

### Procedúra pre výpis stavu FPU zásobníka
Knižnica Irvine32 obsahuje procedúru `ShowFPUStack`, ktorá vypíše na konzolu obsah FPU zásobníka.
Toto môže pomôcť s debuggingom.

```asm
call ShowFPUStack
```

### Spracovanie symetrickej matice
Tento template spracováva iba potrebnú časť **symetrickej** matice. Vhodný pre úlohy typu: *"Nájdite najkratšiu hranu v grafe a vypíšte vrcholy, ktoré spája."*

Potrebný stav sa dá uložiť do voľných registrov alebo do pamäte.

Na riešenie takýchto úloh sa dá prejsť aj celá matica, kód bude potom podstatne jednoduchší, ale menej efektívny. *Neočakávam, že by to však urobilo rozdiel na výslednej známke. Tento kód nie je aj tak najefektívnejší, je určený pre jednoduchosť použitia.*

V dátovom segmente definujeme maticu bajtov a jej počet prvkov:
```asm
.data
Matica DB 0, 1, 2, 1
       DB 1, 0, 5, 4
       DB 2, 5, 0, 7
       DB 1, 4, 7, 0

PocetPrvkov EQU 4
```

Kód pre prehľadanie matice:
```asm
xor EAX, EAX                ; index riadku
mov EBX, 1                  ; index stlpca
mov ECX, PocetPrvkov - 1
mov ESI, EBX                ; index prvku v matici

SpracujRiadok:
  push ECX

  mov ECX, PocetPrvkov
  sub ECX, EBX

  SpracujStlpec:
    mov DL, Matica[ESI]
    ; kód pre spracovanie jednotlivých prvkov sem
    ; EAX = riadok, EBX = stĺpec, DL = samotný prvok
      
    ; ak by sme chceli pouziť register EAX/EBX/ECX/ESI, je potrebné
    ; predtým uložiť ich stav a pred ďalším cyklom ho obnoviť (push / pop)
    
    ; ak potrebujeme register EDX pre iné účely, je možné pristupovať
    ; k prvku priamo cez Matica[ESI]

    inc ESI
    loop SpracujStlpec

  pop ECX
  inc EAX
  mov EBX, EAX
  inc EBX
  add ESI, EBX
  loop SpracujRiadok
```

Ak by prvky neboli 8-bitové, ale 16/32-bitové, treba pozmeniť:
- pri definícií matice v dátovom segmente `DB` za `DW` / `DD`
- k jednotlivým prvkom je potrebné pristupovať cez `Matica[2*ESI]` / `Matica[4*ESI]`
- ako destináciu pre uloženie prvku bude potrebný 16/32-bitový register (napr.: `DX`, `EDX`)
