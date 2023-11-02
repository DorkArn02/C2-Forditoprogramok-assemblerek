.MODEL SMALL
.STACK
.DATA
    string     DB 'Kerek egy 10 hosszusagu szoveget: $'
    pufferSize DB 10,0
    outString  DB 11 DUP ('$')
.CODE
    ; Hasznaljuk az INT21h-t string bekeresre es kiiratasra
main PROC
                    MOV  AX, DGROUP
                    MOV  DS, AX
                    LEA  DX, string
                    MOV  AH, 09h
                    INT  21h

                    LEA  DX, pufferSize
                    MOV  AH, 0Ah
                    INT  21h

                    CALL cr_lf

                    LEA  DX, outString
                    MOV  AH, 09h
                    INT  21h

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
    ; Új sor
cr_lf PROC
                    PUSH DX
                    MOV  DL, 13             ; CR
                    CALL write_char
                    MOV  DL, 10             ; LF
                    CALL write_char
                    POP  DX
                    RET
cr_lf ENDP
    ; Karakter kiíratása
write_char PROC
                    PUSH AX
                    MOV  AH, 2
                    INT  21h
                    POP  AX
                    RET
write_char ENDP

read_string PROC
                    PUSH DX
                    PUSH BX
    read_string_new:
                    CALL read_char
                    CMP  DL, 13
                    JE   read_string_end
                    MOV  [BX], DL
                    INC  BX
                    JMP  read_string_new
    read_string_end:
                    XOR  DL, DL
                    MOV  [BX], DL
                    POP  BX
                    POP  DX
                    RET
read_string ENDP

write_string PROC
                    PUSH DX
                    PUSH BX
    write_str_new:  
                    MOV  DL, [BX]
                    OR   DL, DL
                    JZ   write_str_end
                    CALL write_char
                    INC  BX
                    JMP  write_str_new
    write_str_end:  
                    POP  BX
                    POP  DX
                    RET
write_string ENDP

END MAIN