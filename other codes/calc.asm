.MODEL SMALL
.STACK
.DATA
    msg  DB "Kerem a muvelet tipusat:$"
    msg2 DB "Kerem az elso szamot:$"
    msg3 DB "Kerem a masodik szamot:$"
.CODE
    ; Számológép assembly-ben 2^8-1 = 255 maximum szám...
main PROC

                     MOV  AX, DGROUP
                     MOV  DS, AX

                     LEA  DX, msg
                     MOV  AH, 9               ; Sztring kiíratás
                     INT  21h

                     CALL read_char
                     CALL cr_lf
                     CMP  DL, 'a'             ; Összeadás
                     JE   addition
                     CMP  DL, 'b'             ; Kivonás
                     JE   subtract
                     CMP  DL, 'c'             ; Szorzás
                     JE   multiply
                     CMP  DL, 'd'             ; Osztás
                     JE   division
                     JMP  exit
    addition:        
                     LEA  DX, msg2            ; Sztring kiíratás
                     MOV  AH, 9
                     INT  21h

                     CALL read_decimal        ; Első szám
                     MOV  BL, DL
                    
                     LEA  DX, msg3            ; Sztring kiíratás
                     MOV  AH, 9
                     INT  21h

                     CALL read_decimal        ; Második szám

                     ADD  DL, BL
                    
                     CALL write_decimal
    subtract:        
                     LEA  DX, msg2            ; Sztring kiíratás
                     MOV  AH, 9
                     INT  21h

                     CALL read_decimal        ; Első szám
                     MOV  BL, DL
                    
                     LEA  DX, msg3            ; Sztring kiíratás
                     MOV  AH, 9
                     INT  21h

                     CALL read_decimal        ; Második szám

                     SUB  BL, DL

                     MOV  DL, BL
                    
                     CALL write_decimal
    multiply:        
                     XOR  AX, AX
                     XOR  DX, DX
                     CALL read_decimal        ; Első szám
                     MOV  AL, DL

                     CALL read_decimal        ; Második szám
                     MUL  DL
                     MOV  DL, AL
                     CALL write_decimal
    division:        
                     XOR  AX, AX
                     XOR  DX, DX
                     CALL read_decimal        ; Első szám
                     MOV  AL, DL

                     CALL read_decimal        ; Második szám
                     DIV  DL
                     MOV  DL, AL
                     CALL write_decimal
    exit:            
                     MOV  AH, 4Ch
                     INT  21h
main ENDP

cr_lf PROC
                     PUSH DX
                     MOV  DL, 13              ; Carriage return
                     CALL write_char
                     MOV  DL, 10              ; Line feed
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

write_char PROC
                     PUSH AX
                     MOV  AH, 2
                     INT  21h
                     POP  AX
                     RET
write_char ENDP

read_char PROC
                     PUSH AX
                     MOV  AH, 1
                     INT  21h
                     MOV  DL, AL
                     POP  AX
                     RET
read_char ENDP

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

END main