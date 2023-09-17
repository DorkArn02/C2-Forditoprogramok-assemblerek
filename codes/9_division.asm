.MODEL SMALL
.STACK

.CODE

main PROC
                     CALL read_decimal        ; osztandó beolvasása
                     MOV  AL, DL
                     CALL cr_lf
                     CALL read_decimal        ; osztó beolvasása
                     MOV  BL, DL
                     CALL cr_lf
                     XOR  DX, DX              ; DX törlése
                     MOV  CX, 8               ; Ciklusszám
                     
    Cycle:           
                     SHL  AL, 1               ; Osztandó eggyel balra, CR-be a kilépő bit
                     RCL  DH, 1               ; Maradék eggyel balra, belép a CR tartalma
                     SHL  DL, 1               ;Hányados eggyel balra
                     CMP  DH, BL
                     JB   Next                ; A maradék kiseb,mint az osztó
                     SUB  DH, BL              ; Az osztó kivonása a maradékból
                     INC  DL                  ;Hányados növelése
    Next:            
                     LOOP Cycle
    Stop:            
                     CALL write_decimal       ; Hányados (DL) kiírása
                     CALL cr_lf
                     MOV  DL, DH
                     CALL write_decimal       ; Maradék (CL) kiírása
                     MOV  AH, 4CH
                     INT  21H
main ENDP

read_decimal PROC
                     PUSH AX
                     PUSH BX
                     MOV  BL, 10
                     XOR  AX, AX

    read_decimal_new:
                     CALL read_char
                     CMP  DL, 13              ; input karakter = ENTER
                     JE   read_decimal_end    ; ugrik, ha enter a karakter
                     SUB  DL, "0"             ; karakter - '0'
                     MUL  BL                  ; AX = AX * 10
                     ADD  AL, DL              ; Következő helyi érték hozzáadása
                     JMP  read_decimal_new    ; Következő karakter beolvasása

    read_decimal_end:
                     MOV  DL, AL
                     POP  BX
                     POP  AX
                     RET
read_decimal ENDP

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

read_char PROC
                     PUSH AX
                     MOV  AH, 1
                     INT  21H
                     MOV  DL, AL
                     POP  AX
                     RET
read_char ENDP

write_char PROC
                     PUSH AX
                     MOV  AH,2
                     INT  21H
                     POP  AX
                     RET
write_char ENDP

cr_lf PROC
                     PUSH DX
                     MOV  DL, 13
                     CALL write_char
                     MOV  DL, 10
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

END MAIN