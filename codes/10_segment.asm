.MODEL SMALL
.STACK

.DATA

    adat DB 65    ; A betű ASCII kódja

.CODE

main proc
               MOV  AX, DGROUP    ;Adatszegmens helyének lekérdezése
               MOV  DS, AX        ;DS beállítása, hogy az adatszegmensre mutasson
               LEA  BX, adat      ;Az adat offset címének betöltése BX-be
               MOV  DL, [BX]      ;DL-be tölti a BX-el címzett memória tartalmát
               CALL write_char    ;Karakter kiírása
               MOV  AH,4Ch        ;Visszatérés az operációs rendszerbe
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