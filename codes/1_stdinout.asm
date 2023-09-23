.MODEL SMALL    ; A kód 64 kB-nál kisebb

.STACK          ; Veremszegmens

.CODE           ; Kódszegmens

MOV AH, 1       ; AH=1 akkor stdin (Ha AH=8 akkor nincs echo)
INT 21h         ; Karakter bekérése és elmentése AL-be

MOV DL, AL      ; AL-ben lévő karakter áthelyezése DL-be
MOV AH, 2       ; AH=2 akkor stdout
INT 21h         ; Karakter kiírása a képernyőre DL-ből

MOV AH, 4Ch     ; Kilépés, terminálás visszatérési kóddal
INT 21h         ; AL-ben lévő értékkel tér vissza a program

END