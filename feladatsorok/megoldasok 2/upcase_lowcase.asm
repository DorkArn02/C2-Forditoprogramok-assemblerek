.MODEL SMALL
.STACK
.DATA
    msg1 db "Adjon meg egy kisbetut:$"
    msg2 db "Adjon meg egy nagybetut:$"
.CODE
    ; 1 db karaktert kér be a program kétszer és:
    ; Nagybetű -> kisbetű konvertálás
    ; Kisbetű -> nagybetű konvertálás
main PROC
                 CALL cls
                 MOV  AX, DGROUP
                 MOV  DS, AX
                 MOV  AH, 9
                 LEA  DX, msg1        ; vagy MOV DX, offset msg1
                 INT  21h
                 
                 CALL read_char
                 CALL toUpperCase
                 CALL cr_lf
                 
                 MOV  AH, 9
                 LEA  DX, msg2
                 INT  21h
                 
                 CALL read_char
                 CALL toLowerCase
                 
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
                 MOV  DL, 13
                 CALL write_char
                 MOV  DL, 10
                 CALL write_char
                 POP  DX
                 RET
cr_lf ENDP

toUpperCase PROC
                 PUSH DX
                 CMP  DL, 'a'         ; Ha kisebb, mint  a betű akkor írassuk ki
                 JL   print
                 CMP  DL, 'z'         ; Ha kisebb vagy egyenlő, mint a z betű akkor alakítsuk nagybetűvé
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
                 CMP  DL, 'Z'         ; Ha Z-nél nagyobb, akkor kiíratjuk
                 JG   print2
                 CMP  DL, 'A'         ; Ha A-nál kisebb, akkor kiíratjuk
                 JL   print2
                 JGE  convertLower    ; Ha A-nál nagyobb vagy egyenlő akkor konvertáljuk kisbetűvé
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