.MODEL SMALL
.STACK

.CODE

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

    CR         EQU  13            ; konstans deklarálás: név EQU érték
    LF         EQU  10

    ; Új sor kiíratása
cr_lf PROC
               PUSH DX
               MOV  DL, CR        ; Carriage return
               CALL write_char
               MOV  DL, LF        ; Line feed
               CALL write_char
               POP  DX
               RET
cr_lf ENDP

    ; A program kezdőpontja
main PROC                         ; main eljárás kezdete
               CALL read_char     ; read_char szubrutin meghívása
               CALL cr_lf
               CALL write_char    ; write_char szubrutin meghívása

               MOV  AH, 4Ch
               INT  21h

main ENDP                         ; main eljárás vége

END main