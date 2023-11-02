.MODEL SMALL 
Space EQU " " 
.STACK
.DATA
    sz1 DB 'Kerem a meghajto sorszamat: ',0
.DATA?
    block DB 512 DUP (?)    ;1 blokknyi terulet kijelolese
.CODE

main proc
                     MOV  AX, DGROUP
                     MOV  DS, AX
                     LEA BX, sz1
                     CALL write_string
                     call read_decimal        ;Meghajto sorszam bekerese (A:0, B:1, ...)
                     MOV  AL, DL
                     LEA  BX, block
                     MOV  CX, 1               ;Egyszerre beolvasott blokkok szama
                     MOV  DX, 0               ;Lemezolvasas kezdoblokkja
                     INT  25h                 ;Olvasas
                     POPF
    ; ============================================================
                     mov  cx, 50
                     mov  DL, 201             ;Bal felso keret
                     CALL write_char
    btloop1:         
                     MOV  DL, 205             ;Keret felul hexadecimalis resz felett
                     CALL write_char
                     loop btloop1
                     mov  DL, 187             ;Keret felul hexadecimalis resz utan jobb
                     CALL write_char

                     mov  cx, 17
    btloop2:         
                     mov  dl, 205
                     call write_char          ;Keret felul szoveg felett
                     loop btloop2
                     mov  DL, 187             ;Keret jobb oldalon szoveg utan
                     CALL write_char
    ; ============================================================

                     XOR  DX, DX
                     CALL write_block         ;Egy blokk kiiratasa
    ; ============================================================

                     mov  cx, 50
                     mov  DL, 200             ;BAL ALSO KERET
                     CALL write_char
    btloop3:         
                     MOV  DL, 205             ;KERET ALUL HEXADECIMALISNAL
                     CALL write_char
                     loop btloop3
                     mov  DL, 188             ;KERET JOBB ALSO HEXA
                     CALL write_char

                     mov  cx, 17
    btloop4:         
                     mov  dl, 205
                     call write_char          ;KERET ALUL szoveg
                     loop btloop4
                     mov  DL, 188             ;KERET JOBB also szoveg
                     CALL write_char
    ; ============================================================
                     MOV  AH,4Ch
                     INT  21h
main endp

write_block proc                              ;Egy blokk kiirasa a kepernyore
                     PUSH CX
                     PUSH DX
                     MOV  CX, 32              ;Kiirando sorok szama CX-be
    write_block_new: 
                     CALL out_line            ;Egy sor kiirasa
                     push DX
                     MOV  DL, 186             ;JOBB OLDALI KERET SZOVEG
                     CALL write_char
                     POP  DX
                     CALL cr_lf               ;Soremeles
                     ADD  DX, 16              ;Kovetkezo sor adatainak kezdocime;
                     LOOP write_block_new     ;Uj sor
                     POP  DX
                     POP  CX
                     RET
write_block endp

cr_lf proc
                     push DX
                     mov  DL,13
                     call write_char
                     mov  DL,10
                     call write_char
                     pop  DX
                     ret
cr_lf endp

write_hexa PROC
                     PUSH CX
                     PUSH DX
                     MOV  DH, DL
                     MOV  CL, 4
                     SHR  DL, CL
                     CALL write_hexa_digit
                     MOV  DL, DH
                     AND  DL, 0Fh
                     CALL write_hexa_digit
                     POP  DX
                     POP  CX
                     RET
write_hexa ENDP
    
write_hexa_digit PROC
                     PUSH DX
                     CMP  DL, 10
                     JB   non_hexa_letter
                     ADD  DL, "A"-"0"-10
    non_hexa_letter: 
                     ADD  DL, "0"
                     CALL write_char
                     POP  DX
                     RET
write_hexa_digit ENDP

write_char proc
                     push AX
                     mov  AH, 2h
                     int  21h
                     pop  AX
                     ret
write_char endp

out_line proc
                     PUSH BX
                     PUSH CX
                     PUSH DX
                     MOV  BX,DX               ;Sor adatainak kezdocime BX-ben
                     PUSH BX                  ;Mentes a karakteres kiirashoz
                     MOV  CX, 16              ;Egy sorban 16 hexadecimalis karakter
                     push DX
                     MOV  DL, 186             ;BAL OLDALI KERET HEXA
                     call write_char
                     mov  DL, ' '
                     call write_char
                     pop  DX
    hexa_out:        
                     MOV  DL, Block[BX]       ;Egy bajt betoltese
                     CALL write_hexa          ;Kiiras hexadecimalis formaban
                     MOV  DL,Space            ;Szokoz kiirasa a hexa kodok kozott
                     CALL write_char
                     INC  BX                  ;Kovetkezo adatbajt cime
                     LOOP hexa_out            ;Kovetkezo bajt
                     MOV  DL, Space           ;Szokoz kiirasa a ketfele mod kozott
                     CALL write_char
                     MOV  CX, 16              ;Egy sorban 16 karakter
                     POP  BX                  ;Adatok kezdocimenek beallitasa
                     push DX
                     mov  DL,  186            ;HEXADECIMALIS RESZ JOBBOLDALI KERET
                     call write_char
                     mov  DL, ' '
                     call write_char
                     pop  DX
    ascii_out:       
                     MOV  DL, Block[BX]       ;Egy bajt betoltese
                     CMP  DL, Space           ;Vezerlokarakterek kiszurese
                     JA   visible             ;Ugras, ha lathato karakter
                     MOV  DL, Space           ;Nem lathato karakterek csereje szokozre
    visible:         
                     CALL write_char          ;Karakter kiirasa
                     INC  BX                  ;Kovetkezo adatbajt cime

	                
                     LOOP ascii_out           ;Kovetkezo bajt
                     POP  DX
                     POP  CX
                     POP  BX
                     RET
out_line endp

write_string proc

                     push BX
                     push DX

    w_s_uj:          
                     mov  DL, [BX]
                     OR   DL,DL
                     JZ   w_s_vege
                     call write_char
                     inc  BX
                     jmp  w_s_uj
    w_s_vege:        

                     pop  DX
                     pop  BX

write_string endp

read_char proc
                     push ax
                     mov  ah, 01
                     int  21h
                     mov  dl, al
                     pop  ax
                     ret
read_char endp

read_decimal proc

                     push AX
                     push BX
                     mov  BX,10
                     XOR  AX,AX
    r_d_new:         
                     call read_char
                     CMP  DL, 13
                     JE   r_d_end
                     SUB  DL,'0'
                     MUL  BL
                     ADD  AL,DL
                     JMP  r_d_new
    r_d_end:         
                     MOV  DL,AL
                     pop  BX
                     pop  AX
                     ret

read_decimal endp

END main