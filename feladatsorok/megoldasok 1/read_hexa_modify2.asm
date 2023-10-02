.MODEL SMALL
.STACK

.CODE
    ; Alakítsa  át  a  Read_hexa  szubrutint  úgy,  hogy  csak  a  tizenhatos  számrendszernek  megfelelő  karaktereket fogadja el.
main PROC
                     CALL read_hexa
                     CALL cr_lf
                     CALL write_hexa
                     MOV  AH, 4Ch
                     INT  21h
main ENDP

read_char PROC
                     PUSH AX                  ; AX elmentése a verembe, mert itt használjuk ne írjuk felül
                     MOV  AH, 8               ; AH=8 stdin echo nélkül
                     INT  21h                 ; Karakter bekérése és elmentése AL-be
                     MOV  DL, AL              ; AL-ből DL-be rakjuk a karaktert
                     POP  AX                  ; AX visszatöltése a veremből
                     RET                      ; Visszatérés a hívóhoz
read_char ENDP

read_hexa proc

                     push AX                  ; AX regisztert elmentjük
                     push BX
                     mov  BX,10h
                     XOR  AX,AX               ; nullázzuk tartalmát
    r_h_new:         
                     call read_char
                     CMP  DL,13
                     JE   r_h_end             ; ha egyenlő

                     CMP  DL,'0'
                     JE   r_h_continue
                     CMP  DL,'1'
                     JE   r_h_continue
                     CMP  DL,'2'
                     JE   r_h_continue
                     CMP  DL,'3'
                     JE   r_h_continue
                     CMP  DL,'4'
                     JE   r_h_continue
                     CMP  DL,'5'
                     JE   r_h_continue
                     CMP  DL,'6'
                     JE   r_h_continue
                     CMP  DL,'7'
                     JE   r_h_continue
                     CMP  DL,'8'
                     JE   r_h_continue
                     CMP  DL,'9'
                     JE   r_h_continue
                     CMP  DL,'a'
                     JE   r_h_continue
                     CMP  DL,'b'
                     JE   r_h_continue
                     CMP  DL,'c'
                     JE   r_h_continue
                     CMP  DL,'d'
                     JE   r_h_continue
                     CMP  DL,'e'
                     JE   r_h_continue
                     CMP  DL,'f'
                     JE   r_h_continue
                     CMP  DL,'A'
                     JE   r_h_continue
                     CMP  DL,'B'
                     JE   r_h_continue
                     CMP  DL,'C'
                     JE   r_h_continue
                     CMP  DL,'D'
                     JE   r_h_continue
                     CMP  DL,'E'
                     JE   r_h_continue
                     CMP  DL,'F'
                     JE   r_h_continue

                     JMP  r_h_new             ; ha nem hexa szám, visszaugrik

    r_h_continue:    
                     call write_char
                     call upcase
                     SUB  DL,'0'
                     CMP  DL,9
                     JBE  r_h_decimal
                     SUB  DL, 'A'-'0'-10
    r_h_decimal:     
                     MUL  BL
                     ADD  AL,DL
                     JMP  r_h_new
    r_h_end:         
                     MOV  DL,AL
                     pop  BX
                     pop  AX
                     ret

read_hexa endp

upcase proc                                   ;DL-ben lévő kisbetű átalakítása nagybetűvé
                     CMP  DL, "a"             ;A karakterkód és ”a” kódjának összehasonlítása
                     JB   upcase_end          ;A kód kisebb, mint ”a”, nem kisbetű
                     CMP  DL, "z"             ;A karakterkód és ”z” kódjának összehasonlítása
                     JA   upcase_end          ;A kód nagyobb, mint ”z”, nem kisbetű
                     SUB  DL, "a"-"A"         ;DL-ből a kódok különbségét
    upcase_end:      
                     RET                      ;Visszatérés a hívó rutinba
upcase endp

write_hexa proc

                     push CX
                     push DX
                     mov  DH,DL
                     mov  CL, 4
                     SHR  DL,CL
                     call write_hexa_digit
                     mov  DL,DH
                     AND  DL, 0Fh
                     call write_hexa_digit
                     pop  DX
                     pop  CX
                     ret

write_hexa endp

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

write_hexa_digit proc

                     push DX
                     CMP  DL,10
                     JB   non_hexa_letter
                     ADD  DL, 'A'-10-'0'
    non_hexa_letter: 
                     ADD  DL, '0'
                     call write_char
                     pop  DX
                     ret

write_hexa_digit endp

END MAIN