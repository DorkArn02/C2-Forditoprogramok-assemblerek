.MODEL SMALL
.STACK

.DATA

    adat DB "Ez egy pelda szoveg",0

.CODE

main proc
               MOV  AX, DGROUP    ;Adatszegmens helyének lekérdezése
               MOV  DS, AX        ;DS beállítása, hogy az adatszegmensre mutasson
               LEA  BX, adat      ;Az adat offset címének betöltése BX-be
    new:       
               MOV  DL, [BX]      ;DL-be egy karakter betöltése
               OR   DL, DL        ;Státuszbitek beállítása DL-nek megfelelően
               JZ   stop          ;Kilépés a ciklusból, ha DL=0
               CALL WRITE_CHAR    ;Egy karakter kiírása
               INC  BX            ;BX növelése, BX a következő karakterre mutat
               JMP  new           ;Vissza a ciklus elejére
    stop:      
               MOV  AH,4Ch        ;Kilépés
               INT  21h
main endp

    ; Karakter beolvasása stdinput-ról
read_char PROC
               PUSH AX            ; AX elmentése a verembe, mert itt használjuk ne írjuk felül
               MOV  AH, 1         ; AH=1 stdin
               INT  21h           ; Karakter bekérése és elmentése AL-be
               MOV  DL, AL        ; AL-ből DL-be rakjuk a karaktert
               POP  AX            ; AX visszatöltése a veremből
               RET                ; Visszatérés a hívóhoz
read_char ENDP

    ; Karakter kiíratása az stdout-al DL-ből olvassa ki
write_char PROC
               PUSH AX
               MOV  AH, 2         ; AH=2 stdout
               INT  21h           ; Karakter kiíratása a képernyőre
               POP  AX
               RET
write_char ENDP

END MAIN