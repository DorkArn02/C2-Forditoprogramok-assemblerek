.MODEL SMALL
.STACK
.CODE
    ; Rovidebb megoldas, a hosszabb amikor video_4_sajat-ban csak hatterszin kitoltes karakter nelkul
    ; Keszitsen  programot,  amely  beolvas  egy  karaktert.  Majd  a  beolvasott  karakterbol,  (tetszoleges attributummal) kitolti a kepernyot. Hasznalja a megfelelo alprogramokat!
main PROC
                     CALL clear_screen
                     MOV  AH, 4Ch             ; Kilepes
                     INT  21h
main ENDP

read_char PROC                                ; AX = input, DL = output
                     PUSH AX
                     MOV  AH,8
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
    ; 16 * szinkod + 0 = hatterszin
clear_screen PROC
                     PUSH AX
                     PUSH BX
                     PUSH CX
                     PUSH DX
                     xor  AL,AL
                     xor  CX,CX
                     MOV  DH,24
                     MOV  DL,79
                     PUSH DX
                     CALL read_decimal
                     MOV  AL, DL
                     MOV  DL, 16
                     MUL  DL
                     MOV  BH, AL
                     POP  DX
                     MOV  AH,6
                     INT  10h
                     POP  DX
                     POP  CX
                     POP  BX
                     POP  AX
                     RET
clear_screen ENDP

END main