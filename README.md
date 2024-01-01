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
push AX              ; dočasne pushni zdroj na zásobník
fild DWORD PTR [ESP] ; načítaj pushnuté celé číslo z vrchola zásobníka
pop AX               ; cleanup
```

### Odstránenie čísla z vrchola FPU zásobníka st(0)

```asm
fstp st(0)           ; ulož číslo z st(0) do st(0) a popni ho
```

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

### TODO: template na spracovanie symetrickej matice
