.MODEL SMALL
.STACK

.CODE

main PROC
                      CALL read_hexa
                      CALL cr_lf
                      CALL write_hexa
                      MOV  AH, 4Ch
                      INT  21h
main ENDP

read_char PROC
                      PUSH AX                   ; AX elmentése a verembe, mert itt használjuk ne írjuk felül
                      MOV  AH, 1                ; AH=1 stdin
                      INT  21h                  ; Karakter bekérése és elmentése AL-be
                      MOV  DL, AL               ; AL-ből DL-be rakjuk a karaktert
                      POP  AX                   ; AX visszatöltése a veremből
                      RET                       ; Visszatérés a hívóhoz
read_char ENDP

read_hexa proc
                      PUSH AX                   ;AX mentése a verembe
                      PUSH BX                   ;BX mentése a verembe
                      MOV  BX, 10h              ;BX-be a számrendszer alapszáma, ezzel szorzunk
                      XOR  AX, AX               ;AX törlése
    read_hexa_new:    
                      CALL read_char            ;Egy karakter beolvasása
                      CMP  DL, 13               ;ENTER ellenőrzése
                      JE   read_hexa_end        ;Vége, ha ENTER volt az utolsó karakter
                      CALL upcase               ;Kisbetű átalakítása naggyá
                      SUB  DL, "0"              ;Karakterkód minusz ”0” kódja
                      CMP  DL, 9                ;Számjegy karakter?
                      JBE  read_hexa_decimal    ;Ugrás, ha decimális számjegy
                      SUB  DL,7                 ;Betű esetén még 7-et levonunk
    read_hexa_decimal:
                      MUL  BL                   ;AX szorzása az alappal
                      ADD  AL, DL               ;A következő helyi érték hozzáadása
                      JMP  read_hexa_new        ;A következő karakter beolvasása
    read_hexa_end:    
                      MOV  DL, AL               ;DL-be a beírt szám
                      POP  BX                   ;BX visszaállítása
                      POP  AX                   ;AX visszaállítása
                      RET                       ;Visszatérés a hívó rutinba
read_hexa endp

upcase proc                                     ;DL-ben lévő kisbetű átalakítása nagybetűvé
                      CMP  DL, "a"              ;A karakterkód és ”a” kódjának összehasonlítása
                      JB   upcase_end           ;A kód kisebb, mint ”a”, nem kisbetű
                      CMP  DL, "z"              ;A karakterkód és ”z” kódjának összehasonlítása
                      JA   upcase_end           ;A kód nagyobb, mint ”z”, nem kisbetű
                      SUB  DL, "a"-"A"          ;DL-ből a kódok különbségét
    upcase_end:       
                      RET                       ;Visszatérés a hívó rutinba
upcase endp

write_hexa proc

                      push CX
                      push DX
                      mov  DH,DL
                      mov  CL, 4
                      SHR  DL,CL
                      call write_hexa_digit
                      mov  DL,DH
                      AND  DL, 0Fh
                      call write_hexa_digit
                      pop  DX
                      pop  CX
                      ret

write_hexa endp

write_char PROC
                      PUSH AX
                      MOV  AH, 2                ; AH=2 stdout
                      INT  21h                  ; Karakter kiíratása a képernyőre
                      POP  AX
                      RET
write_char ENDP

cr_lf PROC
                      PUSH DX
                      MOV  DL, 13               ; Carriage return
                      CALL write_char
                      MOV  DL, 10               ; Line feed
                      CALL write_char
                      POP  DX
                      RET
cr_lf ENDP

write_hexa_digit proc

                      push DX
                      CMP  DL,10
                      JB   non_hexa_letter
                      ADD  DL, 'A'-10-'0'
    non_hexa_letter:  
                      ADD  DL, '0'
                      call write_char
                      pop  DX
                      ret

write_hexa_digit endp

END MAIN