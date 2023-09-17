.MODEL SMALL
.STACK

.CODE

main PROC
                     CALL read_char
                     CALL cr_lf
                     CALL write_hexa
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
                     MOV  DL, 13              ; CR
                     CALL write_char
                     MOV  DL, 10              ; LF
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

    ; Karakter kiíratása hexadecimális számként
write_hexa PROC
                     PUSH CX
                     PUSH DX
                     MOV  DH, DL              ; DL elmentése
                     MOV  CL, 4               ; Shiftelések száma
                     SHR  DL, CL              ; DL shift-elése 4 hellyel jobbra
                     CALL write_hexa_digit
                     MOV  DL, DH              ; Elmentett DL visszahelyezése
                     AND  DL, 0Fh             ; Felső 4 bit törlése
                     CALL write_hexa_digit
                     POP  DX
                     POP  CX
                     RET
write_hexa ENDP
    
write_hexa_digit PROC
                     PUSH DX
                     CMP  DL, 10              ; DL összehasonlítása 10-zel
                     JB   non_hexa_letter     ; Ugrás, ha kisebb mint 10
                     ADD  DL, "A"-"0"-10      ; A-F betű kiírása
    non_hexa_letter: 
                     ADD  DL, "0"             ; ASCII kód megadása
                     CALL write_char
                     POP  DX
                     RET
write_hexa_digit ENDP

END main