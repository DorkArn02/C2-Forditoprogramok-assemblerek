.MODEL SMALL
.STACK
.CODE
    ; Írja ki a képernyőre (egymás alá) a szám karakterek ASCII kódját.
main proc
                     mov  cx, 10              ; 10 db számjegy
                     mov  dl, 48              ; '0' számjegy ASCII kódja
    innerLoop:       
                     call write_decimal       ; szám ASCII kódjának kiíratása
                     call cr_lf               ; sortörés
                     inc  dl                  ; dl növelése
                     loop innerLoop           ; cx csökkentése 1-gyel

                     mov  ah, 4ch             ; sys exit kódja
                     int  21h                 ; kilépés

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
                     MOV  DL, 13              ; CR
                     CALL write_char
                     MOV  DL, 10              ; LF
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

write_decimal proc
                     push AX
                     push CX
                     push DX
                     push SI
                     XOR  DH, DH              ; Felső 8 bit törlése, csak az alsó 8 van meg stdin-ból
                     mov  AX, DX              ; osztandó szám AX-be
                     mov  SI, 10              ; osztó
                     XOR  CX, CX              ; CX = 0
    decimal_non_zero:
                     XOR  DX, DX              ; DX = 0
                     DIV  SI                  ; AX osztása SI-vel, eredmény AX-be, maradék DX-be kerül
                     push DX                  ; maradék mentése verembe
                     inc  CX                  ; osztások száma + 1
                     OR   AX, AX              ; státuszbitek beállítása AX-nek megfelelően
                     JNE  decimal_non_zero    ; Ugrás, ha nem nulla
    decimal_loop:    
                     pop  DX                  ; maradék kivétele veremből
                     call write_hexa_digit    ; kiíratás
                     loop decimal_loop        ; ciklus
                     pop  SI
                     pop  DX
                     pop  CX
                     pop  AX
                     ret

write_decimal endp
    
write_hexa_digit PROC
                     PUSH DX
                     CMP  DL, 10              ; DL összehasonlítása 10-zel
                     JB   non_hexa_letter     ; Ugrás, ha kisebb mint 10
                     ADD  DL, "A"-"0"-10      ; A-F betű kiírása
    non_hexa_letter: 
                     ADD  DL, "0"             ; ASCII kód megadása
                     CALL write_char
                     POP  DX
                     RET
write_hexa_digit ENDP

END MAIN