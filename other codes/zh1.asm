.MODEL SMALL
.STACK
.DATA?
    szoveg DB 100 DUP(?)    ; Tetszoleges szoveget itt tarolom
.DATA
    kerdes1 DB 'Kerem az elso (x) koordinatat: ', 0
    kerdes2 DB 'Kerem a masodik (y) koordinatat: ', 0
    kerdes3 DB 'Kerem a tetszoleges szoveget: ', 0
    x       DB 1
    y       DB 1
    attr    DB 128 * 0 + 16 * 0 + 4                      ; Fekete hatter, piros szin attributum
    tmp     DB ' '                                       ; Itt tarolom az eppen kiirando karaktert
.CODE
    ; Olvasson be ket egesz szamot es egy tetszoleges szoveget
    ; A megadott x, y irja ki a szoveget vizszintesen ugy, hogy nagybetu->kisbetu alakitja
    ; Beolvasas alatt kerdesek kiiratasa
    ; Attributum tetszoleges lehet
main proc
                       MOV  AX, DGROUP
                       MOV  DS, AX
                       CALL cls

    ; Ket egesz szam beolvasasa
                       LEA  BX, kerdes1
                       CALL write_string
                       CALL read_decimal
                       MOV  x, DL

                       LEA  BX, kerdes2
                       CALL write_string
                       CALL read_decimal
                       MOV  y, DL
    ; Tetszoleges szoveg bekerese
                       LEA  BX, kerdes3
                       CALL write_string
                       LEA  BX, szoveg
                       CALL read_string
    ; Amiutan bekertuk az adatokat toroljuk a kepernyot
                       CALL cls
    ; Kepernyo beallitasa
                       CALL set_videomode
    ; Kiiratas a kepernyore a videomemoria segitsegevel
    ; Tetszoleges attributum lehet
                       LEA  BX, szoveg
    write_str_new2:    
                       MOV  DL, [BX]
                       OR   DL, DL
                       JZ   write_str_end2
                       CALL lowcase              ; Kisbetuve alakitja
                       
                       MOV  tmp, DL              ; Aktualis karakter eltarolasa a kiiratas vegett
                       CALL draw_side            ; Kiiratas (x,y) pozicioban

                       INC  BX                   ; Kovetkezo karakter
                       INC  x                    ; Vizszintesen jobbra megyunk
                       JMP  write_str_new2
    write_str_end2:    

                       MOV  AH, 4Ch
                       INT  21h
main endp

    ; Ez egy seged szubrutin, amely segitsegevel adott (x,y) koordinatara tudunk irni a kepernyore
draw_side PROC
                       PUSH AX
                       PUSH BX
                       PUSH DX
                       PUSH DI
    ; Pozicio keplet
    ; 2[(y-1)*80 + (x-1)] = 160(y-1) + 2(x-1)
                       XOR  AX, AX               ; AX torlese
                       MOV  DL, y

                       MOV  AL, DL
                       DEC  AL                   ; y-1
                       MOV  BL, 160
                       MUL  BL                   ; (y-1)*160 Elso tag
                       MOV  DI, AX               ; Elso tag eltarolasa a DI-ba

                       XOR  AX, AX               ; AX torlese
                       MOV  DL, x

                       MOV  AL, DL
                       DEC  AL                   ; x-1
                       SHL  AL, 1                ; 2(x-1) Masodik tag
                       ADD  DI, AX               ; DI = DI + AL

                       MOV  AL, tmp              ; Karakter az also 4 bithelyre
                       MOV  AH, attr             ; Attributum a felso 4 bithelyre

                       MOV  ES:[DI], AX          ; Kepernyo memoriara iras

                       INC  CH

                       POP  DI
                       POP  DX
                       POP  BX
                       POP  AX
                       RET
draw_side ENDP

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

write_binary PROC
                       PUSH BX
                       PUSH CX
                       PUSH DX

                       MOV  BL, DL
                       MOV  CX, 8

    binary_digit:      
                       XOR  DL, DL
                       RCL  BL, 1
                       ADC  DL, "0"
                       CALL write_char
                       LOOP binary_digit
                       POP  DX
                       POP  CX
                       POP  BX
                       RET
write_binary ENDP

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

read_hexa proc
                       PUSH AX
                       PUSH BX
                       MOV  BX, 10h
                       XOR  AX, AX
    read_hexa_new:     
                       CALL read_char
                       CMP  DL, 13
                       JE   read_hexa_end
                       CALL upcase
                       SUB  DL, "0"
                       CMP  DL, 9
                       JBE  read_hexa_decimal
                       SUB  DL,7
    read_hexa_decimal: 
                       MUL  BL
                       ADD  AL, DL
                       JMP  read_hexa_new
    read_hexa_end:     
                       MOV  DL, AL
                       POP  BX
                       POP  AX
                       RET
read_hexa endp

upcase proc
                       CMP  DL, "a"
                       JB   upcase_end
                       CMP  DL, "z"
                       JA   upcase_end
                       SUB  DL, "a"-"A"
    upcase_end:        
                       RET
upcase endp

    ; Ez alakitja a DL-ben levo betut kisbetuve
lowcase proc
                       CMP  DL, 'Z'
                       JG   exitlower
                       CMP  DL, 'A'
                       JL   exitlower
                       JGE  convertLower2
    convertLower2:     
                       ADD  DL, 'a'-'A'
    exitlower:         
                       RET
lowcase endp

read_binary proc
                       PUSH AX
                       XOR  AX, AX
    read_binary_new:   
                       CALL read_char
                       CMP  DL, 13
                       JE   read_binary_end
                       SUB  DL, "0"
                       SAL  AL, 1
                       ADD  AL, DL
                       JMP  read_binary_new
    read_binary_end:   
                       MOV  DL, AL
                       POP  AX
                       RET
read_binary endp

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

cls PROC
                       PUSH AX
                       MOV  AX, 3
                       INT  10h
                       POP  AX
                       RET
cls ENDP

    ; Hasznalat elott kell puffer terulet pl. puffer DB 25 DUP('$')
read_string_int21 proc
                       PUSH AX
                       MOV  AH, 0Ah
                       INT  21h
                       POP  AX
                       RET
read_string_int21 endp

    ; Hasznalat elott kell adatterulet aminek a hossza puffer+1
    ; Kell kiiro es beolvaso koze cr_lf mert maskeppen nem latszodik
write_string_int21 proc
                       PUSH AX
                       MOV  AH, 9h
                       INT  21h
                       POP  AX
                       RET
write_string_int21 endp

toUpperCase PROC
                       PUSH DX
                       CMP  DL, 'a'
                       JL   print
                       CMP  DL, 'z'
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
                       CMP  DL, 'Z'
                       JG   print2
                       CMP  DL, 'A'
                       JL   print2
                       JGE  convertLower
    convertLower:      
                       ADD  DL, 'a'-'A'
    print2:            
                       CALL write_char
                       POP  DX
                       RET
toLowerCase ENDP

clear_screen PROC
                       PUSH AX
                       PUSH BX
                       PUSH CX
                       PUSH DX
                       XOR  AL, AL
                       XOR  CX, CX               ;Bal felso sarok (CL = 0, CH = 0)
                       MOV  DH, 24               ;49               ;50 soros kepernyo also sora (25 sorosnál ide 24 kell)
                       MOV  DL, 79               ;Jobb oldali oszlop sorszama
                       MOV  BH, 7                ;Torolt helyek attributuma
                       MOV  AH, 6                ;Sorgorgetes felfele (Scroll-up) funkcio
                       INT  10h                  ;Kepernyo torlese
                       POP  DX
                       POP  CX
                       POP  BX
                       POP  AX
                       RET
clear_screen ENDP

set_videomode PROC
                       PUSH AX
                       MOV  AX, 0B800h
                       MOV  ES, AX
                       MOV  AH, 0h
                       MOV  AL, 3h
                       INT  10H
                       POP  AX
                       RET
set_videomode ENDP

END MAIN