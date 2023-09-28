.MODEL SMALL
.STACK
.CODE
    ; Írja ki a képernyőre (egymás alá) a nagybetű karaktereket.
main proc
               mov  cx, 26        ; 26 db betű
               mov  dl, 65        ; 'A'
    innerLoop: 
               mov  ah, 2         ; stdout kódja
               int  21h           ; kiíratás
               call cr_lf         ; új sor

               inc  dl            ; dl növelése
               loop innerLoop     ; cx csökkentése 1-gyel

               mov  ah, 4ch       ; sys exit kódja
               int  21h           ; kilépés

main endp

    ; Karakter kiíratása
write_char PROC
               PUSH AX
               MOV  AH, 2
               INT  21h
               POP  AX
               RET
write_char ENDP

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

END MAIN