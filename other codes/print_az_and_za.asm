.DOSSEG
.MODEL SMALL
.STACK

.CODE
    ; Kiírja a kisbetűket z-től a-ig majd a-tól z-ig
main PROC
                     MOV  CX, 26
                     MOV  DL, 'z'             ; Ha nagybetű akkor 'Z'
    lp:              
                     CALL write_char
                     DEC  DL
                     LOOP lp

                     CALL cr_lf
                     MOV  CX, 26
                     MOV  DL, 'a'             ; Ha nagybetű akkor 'A'

    lp2:             
                     CALL write_char
                     INC  DL
                     LOOP lp2

                     MOV  AH, 4Ch
                     INT  21h
main ENDP

read_char PROC
                     PUSH AX                  ; AX elmentése a verembe, mert itt használjuk ne írjuk felül
                     MOV  AH, 1               ; AH=1 stdin
                     INT  21h                 ; Karakter bekérése és elmentése AL-be
                     MOV  DL, AL              ; AL-ből DL-be rakjuk a karaktert
                     POP  AX                  ; AX visszatöltése a veremből
                     RET                      ; Visszatérés a hívóhoz
read_char ENDP

write_char PROC
                     PUSH AX
                     MOV  AH, 2               ; AH=2 stdout
                     INT  21h                 ; Karakter kiíratása a képernyőre
                     POP  AX
                     RET
write_char ENDP

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

cr_lf PROC
                     PUSH DX
                     MOV  DL, 13              ; Carriage return
                     CALL write_char
                     MOV  DL, 10              ; Line feed
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

END main