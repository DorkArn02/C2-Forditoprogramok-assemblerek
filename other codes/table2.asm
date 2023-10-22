.MODEL SMALL
.STACK

.CODE
    ; Keret nem kell, mert nem irja a feladat...
main PROC
    ; Ket decimalis ertek beolvasasa
                     CALL read_decimal        ; pl. 65 - A
                     MOV  BL, DL
                     CALL read_decimal        ; pl. 90 - Z
                
    ; Sorrend eldontese
    ; Elso megadott szam kisebb, mint a masodik akkor mehet
                     CMP  BL, DL
                     JB   kisebb              ; Elso kisebb
                     JA   nagyobb             ; Elso nagyobb ekkor helycsere
                    
    ; Elsot ne irassa ki mert a ketto kozott kell ezert van INC BL
    ; Pl. A és Z között A-t nem irhatjuk ki mert nem kozotte
    ; Ket ertek kozotti karakterek kiiratasa es ASCII kodjuk
    ; Elsore megadottol halad masodik fele
    kisebb:          
                     INC  BL
                     JMP  lp
    nagyobb:                                  ; pl BL = 70 és DL = 65
                     MOV  AL, BL              ; AL = 70
                     MOV  BL, DL              ; BL = 65
                     MOV  DL, AL              ; DL = 70
                     INC  BL
                     JMP  lp

    lp:              PUSH DX
                     MOV  DL, BL
                     CALL write_char
                     CALL tabulator
                     CALL write_decimal
                     POP  DX
                     CALL cr_lf
                     
                     INC  BL
                     CMP  BL, DL
                     JE   exit
                     JMP  lp

    exit:            
                     MOV  AH, 4Ch
                     INT  21h

main ENDP

read_char PROC
                     PUSH AX
                     MOV  AH, 1
                     INT  21h
                     MOV  DL, AL
                     POP  AX
                     RET
read_char ENDP

write_char PROC
                     PUSH AX
                     MOV  AH, 2
                     INT  21h
                     POP  AX
                     RET
write_char ENDP

    ; Tablazatos forma miatt kell tabulatorozni
tabulator PROC
                     PUSH DX
                     MOV  DL, 9
                     CALL write_char
                     POP  DX
                     RET
tabulator ENDP

cr_lf PROC
                     PUSH DX
                     MOV  DL, 13
                     CALL write_char
                     MOV  DL, 10
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP
    
write_hexa_digit PROC
                     PUSH DX
                     CMP  DL, 10
                     JB   non_hexa_letter
                     ADD  DL, 7
    non_hexa_letter: 
                     ADD  DL, "0"
                     CALL write_char
                     POP  DX
                     RET
write_hexa_digit ENDP

write_decimal proc
                     push AX
                     push CX
                     push DX
                     push SI
                     XOR  DH, DH
                     mov  AX, DX
                     mov  SI, 10
                     XOR  CX, CX
    decimal_non_zero:
                     XOR  DX, DX
                     DIV  SI
                     push DX
                     inc  CX
                     OR   AX, AX
                     JNE  decimal_non_zero
    decimal_loop:    
                     pop  DX
                     call write_hexa_digit
                     loop decimal_loop
                     pop  SI
                     pop  DX
                     pop  CX
                     pop  AX
                     ret

write_decimal endp

read_decimal PROC
                     PUSH AX
                     PUSH BX
                     MOV  BL, 10
                     XOR  AX, AX

    read_decimal_new:
                     CALL read_char
                     CMP  DL, 13
                     JE   read_decimal_end
                     SUB  DL, "0"
                     MUL  BL
                     ADD  AL, DL
                     JMP  read_decimal_new

    read_decimal_end:
                     MOV  DL, AL
                     POP  BX
                     POP  AX
                     RET
read_decimal ENDP

upcase proc
                     CMP  DL, "a"
                     JB   upcase_end
                     CMP  DL, "z"
                     JA   upcase_end
                     SUB  DL, "a"-"A"
    upcase_end:      
                     RET
upcase endp

END main