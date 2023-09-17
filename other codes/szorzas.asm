.MODEL SMALL
.STACK 100h

.DATA
    num1   DW ?
    num2   DW ?
    num3   DW ?
    result DW ?
.CODE
MAIN PROC
                     MOV  AX, @DATA
                     MOV  DS, AX

                     XOR  DH, DH

                     CALL read_decimal        ; Read first number
                     MOV  num1, DX

                     CALL read_decimal
                     MOV  num2, DX
                     
                     CALL read_decimal
                     MOV  num3, DX

                     XOR  AX, AX
                     MOV  AX, num1
                     MUL  num2
                     MUL  num3
                     MOV  DX, AX
                     CALL write_decimal

                     MOV  AH, 4Ch
                     INT  21h

MAIN ENDP

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

cr_lf PROC
                     PUSH DX
                     MOV  DL, 13              ; Carriage return
                     CALL write_char
                     MOV  DL, 10              ; Line feed
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

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

END MAIN
