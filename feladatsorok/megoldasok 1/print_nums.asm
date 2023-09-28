.MODEL SMALL
.STACK
.CODE
    ; Írja ki a képernyőre (egymás alá) a szám karaktereket.
main proc
               mov  cx, 10        ; 10 db számjegy
               mov  dl, 48        ; '0' ASCII kódja
    innerLoop: 
               mov  ah, 2         ; stdout kódja
               int  21h           ; kiíratás
               call cr_lf         ; új sor
               
               inc  dl            ; dl növelése
               loop innerLoop     ; loop, amíg cx nem nulla

               mov  ah, 4ch       ; sys exit kód
               int  21h           ; kilépés a programból

main endp

    ; Új sor
cr_lf PROC
               PUSH DX
               MOV  DL, 13        ; CR
               CALL write_char
               MOV  DL, 10        ; LF
               CALL write_char
               POP  DX
               RET
cr_lf ENDP

    ; Karakter kiíratása
write_char PROC
               PUSH AX
               MOV  AH, 2
               INT  21h
               POP  AX
               RET
write_char ENDP

END MAIN