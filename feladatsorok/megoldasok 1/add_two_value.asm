.MODEL SMALL
.STACK
.CODE
    ; Olvasson be két darab bájtos értéket, adja össze azokat, majd az eredményt írja ki a képernyőre.
    ; 1 bájt = 8 bit ez lehetne decimális szám is, de ha megnézed ASCII táblát jól adja össze
    ; Pl. space + esc = ; pontosvessző
main PROC
               XOR  AX, AX
               CALL read_char
               MOV  BL, DL
               CALL cr_lf
               CALL read_char
               ADD  DL, BL
               CALL cr_lf
               CALL write_char
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