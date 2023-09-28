.MODEL SMALL
.STACK
.DATA
    msg1 DB "Adjon meg egy szoveget:$"
    txt  DB 100 DUP (?)                   ; Futás közben feltöltődő memória terület...
.CODE
    ; Írjon ki egy tetszőleges (konstans) szöveget úgy, hogy a kisbetű karaktereket nagybetűre alakítja.
main PROC
                    CALL cls
                    MOV  AX, DGROUP         ; Adatszegmens beállítása
                    MOV  DS, AX
                    
                    LEA  DX, msg1
                    MOV  AH, 9h             ; szöveg kiíratás
                    INT  21h

                    LEA  BX, txt
                    CALL read_string
                    CALL cr_lf
                    CALL write_string

                    MOV  AH, 4Ch
                    INT  21h
main ENDP

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
                    CALL toUpperCase
                    INC  BX
                    JMP  write_str_new
    write_str_end:  
                    POP  BX
                    POP  DX
                    RET
write_string ENDP

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
                    MOV  DL, 13
                    CALL write_char
                    MOV  DL, 10
                    CALL write_char
                    POP  DX
                    RET
cr_lf ENDP

toUpperCase PROC
                    PUSH DX
                    CMP  DL, 'a'            ; Ha kisebb, mint  a betű akkor írassuk ki
                    JL   print
                    CMP  DL, 'z'            ; Ha kisebb vagy egyenlő, mint a z betű akkor alakítsuk nagybetűvé
                    JLE  convert
    convert:        
                    SUB  DL, 'a'-'A'
    print:          
                    CALL write_char
                    POP  DX
                    RET
toUpperCase ENDP

toLowerCase PROC
                    PUSH DX
                    CMP  DL, 'Z'            ; Ha Z-nél nagyobb, akkor kiíratjuk
                    JG   print2
                    CMP  DL, 'A'            ; Ha A-nál kisebb, akkor kiíratjuk
                    JL   print2
                    JGE  convertLower       ; Ha A-nál nagyobb vagy egyenlő akkor konvertáljuk kisbetűvé
    convertLower:   
                    ADD  DL, 'a'-'A'
    print2:         
                    CALL write_char
                    POP  DX
                    RET
toLowerCase ENDP

cls PROC
                    PUSH AX
                    mov  ax, 3
                    int  10h
                    POP  AX
                    RET
cls ENDP

END MAIN