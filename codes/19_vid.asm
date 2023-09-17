.MODEL SMALL 
.STACK
.DATA
    x    DB 10     ;X koordináta, oszlopszám
    y    DB 10     ;Y koordináta, sorszám
    kar  DB "A"    ;Kiírandó karakter
    att  DB 4      ;Kiírás attribútuma
.CODE
main proc
         MOV AX, dgroup     ;Adatszegmens beállítása
         MOV DS, AX
         MOV AX, 0B800h     ;Képernyő-memória szegmenscíme ES-be
         MOV ES, AX
         XOR AX, AX         ;AX törlése
         MOV BL, 160        ;Szorzó betöltése BL-be
         MOV AL, y          ;Y koordináta betöltése AL-be
         DEC AL             ;AL-1, az 1. karakter a memória 0. címén van
         MUL BL             ;AL szorzása 160-nal
         MOV DI, AX         ;DI-be a sorszámból számított memóriahely
         XOR AX, AX         ;AX törlése
         MOV AL, x          ;X koordináta betöltése AL-be
         DEC AL             ;AL-1, az 1. karakter a memória 0. címén van
         SHL AL, 1          ;AL szorzása 2-vel (1-el balra shift)
         ADD DI, AX         ;DI-hez hozzáadjuk az oszlopszámból
    ;számított memóriahelyet
         MOV AL, kar        ;AL-be a karakterkód
         MOV AH, att        ;AH-ba a karakter attribútuma
         MOV ES:[DI], AX    ;Betöltés a képernyő-memória kiszámított címére
         MOV AH, 4Ch        ;Program befejezése
         INT 21h
main endp
END main