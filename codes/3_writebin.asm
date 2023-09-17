.MODEL SMALL
.STACK
    ; Bitforgatás balra carry-vel
    ; a - 11000010 forgatás után
    ; a - 01100001 forgatás előtt
.CODE
    ; Program kiindulási része
main PROC
                 CALL read_char
                 CALL cr_lf
                 CALL write_binary

                 MOV  AH, 4Ch
                 INT  21h
main ENDP

    ; Karakter beolvasása
read_char PROC
                 PUSH AX
                 MOV  AH, 1
                 INT  21h
                 MOV  DL, AL
                 POP  AX
                 RET
read_char ENDP

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
                 MOV  DL, 13          ; CR
                 CALL write_char
                 MOV  DL, 10          ; LF
                 CALL write_char
                 POP  DX
                 RET
cr_lf ENDP

    ; A regiszter bitjeinek kiírása balról jobbra
write_binary PROC
                 PUSH BX
                 PUSH CX
                 PUSH DX

                 MOV  BL, DL          ; beolvasott karakter elmentése BL-be
                 MOV  CX, 8           ; 8-szor írunk ki számjegyet

    binary_digit:
                 XOR  DL, DL          ; DL nullázása
                 RCL  BL, 1           ; BL elforgatása balra 1-gyel CF-be kerül az eredmény
                 ADC  DL, "0"         ; 0 + 0 = 1 VAGY 0 + 1 = 1, add with carry
                 CALL write_char
                 LOOP binary_digit    ; amíg CX nem nulla addig csökkenti a tartalmát
                 POP  DX
                 POP  CX
                 POP  BX
                 RET
write_binary ENDP

END MAIN