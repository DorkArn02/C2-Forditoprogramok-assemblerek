.MODEL SMALL 
Space EQU " " ;Szóköz karakter 
.STACK
.DATA?
    block DB 512 DUP (?)    ;1 blokknyi terület kijelölése
.CODE
main proc
                     MOV  AX, Dgroup          ;DS beállítása
                     MOV  DS, AX
                     LEA  BX, block           ;DS:BX memóriacímre tölti a blokkot
                     MOV  AL, 0               ;Lemezmeghajtó száma (A:0, B:1, C:2, stb.)
                     MOV  CX, 1               ;Egyszerre beolvasott blokkok száma
                     MOV  DX, 0               ;Lemezolvasás kezdőblokkja
                     INT  25h                 ;Olvasás
                     POPF                     ;A veremben tárolt jelzőbitek törlése
                     XOR  DX, DX              ;Kiírandó adatok kezdőcíme DS:DX
                     CALL write_block         ;Egy blokk kiírása
                     MOV  AH,4Ch              ;Kilépés a programból
                     INT  21h
main endp
write_block proc                              ;Egy blokk kiírása a képernyőre
                     PUSH CX                  ;CX mentése
                     PUSH DX                  ;DX mentése
                     MOV  CX, 32              ;Kiírandó sorok száma CX-be
    write_block_new: 
                     CALL out_line            ;Egy sor kiírása
                     CALL cr_lf               ;Soremelés
                     ADD  DX, 16              ;Következő sor adatainak kezdőcíme;
                     LOOP write_block_new     ;Új sor
                     POP  DX                  ;DX visszaállítása
                     POP  CX                  ;CX visszaállítása
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

write_char proc
                     push AX
                     mov  AH, 2h
                     int  21h
                     pop  AX
                     ret
write_char endp

out_line proc
                     PUSH BX                  ;BX mentése
                     PUSH CX                  ;CX mentése
                     PUSH DX                  ;DX mentése
                     MOV  BX,DX               ;Sor adatainak kezdőcíme BX-be
                     PUSH BX                  ;Mentés a karakteres kiíráshoz
                     MOV  CX, 16              ;Egy sorban 16 hexadecimális karakter
    hexa_out:        
                     MOV  DL, Block[BX]       ;Egy bájt betöltése
                     CALL write_hexa          ;Kiírás hexadecimális formában
                     MOV  DL,Space            ;Szóköz kiírása a hexa kódok között
                     CALL write_char
                     INC  BX                  ;Következő adatbájt címe
                     LOOP hexa_out            ;Következő bájt
                     MOV  DL, Space           ;Szóköz kiírása a kétféle mód között
                     CALL write_char
                     MOV  CX, 16              ;Egy sorban 16 karakter
                     POP  BX                  ;Adatok kezdőcímének beállítása
    ascii_out:       
                     MOV  DL, Block[BX]       ;Egy bájt betöltése
                     CMP  DL, Space           ;Vezérlőkarakterek kiszűrése
                     JA   visible             ;Ugrás, ha látható karakter
                     MOV  DL, Space           ;Nem látható karakterek cseréje szóközre
    visible:         
                     CALL write_char          ;Karakter kiírása
                     INC  BX                  ;Következő adatbájt címe
                     LOOP ascii_out           ;Következő bájt
                     POP  DX                  ;DX visszaállítása
                     POP  CX                  ;CX visszaállítása
                     POP  BX                  ;BX visszaállítása
                     RET                      ;Vissza a hívó programba
out_line endp

END main