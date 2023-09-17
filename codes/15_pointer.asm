.MODEL SMALL
FPBYTE TYPEDEF FAR PTR BYTE
.STACK
.DATA?

    buf   DB   100 DUP (?)
          adat FPBYTE buf

.CODE
main proc
                     mov   ax, dgroup          ; Adatszegmens beállítása
                     mov   ds, ax
                     les   di, adat            ; Sztring-pointer betöltése ES:DI-be
                     call  read_string
                     call  cr_lf
                     lds   si, adat            ; Sztring-pointer betöltése DS:DI-be
                     call  write_string
                     mov   ah, 4ch
                     int   21h
main endp

    CR               EQU   13
    LF               EQU   10

cr_lf proc
                     push  DX
                     mov   DL,CR
                     call  write_char
                     mov   DL,LF
                     call  write_char
                     pop   DX
                     ret
cr_lf endp

write_char proc
                     push  AX
                     mov   AH, 2h
                     int   21h
                     pop   AX
                     ret
write_char endp

read_char proc
                     push  AX
                     mov   AH, 1h
                     int   21h
                     mov   DL, AL
                     pop   AX
                     ret
read_char endp

write_string proc
                     PUSH  AX                  ;AX mentése
                     PUSH  DX                  ;DX mentése
                     CLD                       ;Irányjelző beállítása
    write_string_new:
                     LODSB                     ;DS:SI tartalma AL-be, SI-t eggyel megnöveli
                     OR    AL, AL              ;Sztring végének ellenőrzése
                     JZ    write_string_end
                     MOV   DL, AL              ;DL-be a kiírandó karakter
                     CALL  write_char          ;Karakter kiírása
                     JMP   write_string_new    ;Új karakter
    write_string_end:
                     POP   DX                  ;DX visszaállítása
                     POP   AX                  ;AX visszaállítása
                     RET
write_string endp

read_string proc
                     PUSH  DX                  ;DX mentése a verembe
                     PUSH  AX                  ;BX mentése a verembe
                     CLD                       ;Irányjelző beállítása
    read_string_new: 
                     CALL  read_char           ;Egy karakter beolvasása
                     CMP   DL, CR              ;ENTER ellenőrzése
                     JE    read_string_end     ;Vége, ha ENTER volt az utolsó karakter
                     MOV   AL, DL              ;AL-be a karakter
                     STOSB                     ;AL tartalma ES:DI címre, DI-t eggyel megnöveli
                     JMP   read_string_new     ;Következő karakter beolvasása
    read_string_end: 
                     XOR   AL,AL
                     STOSB                     ; Sztring lezárása 0-val
                     POP   AX                  ;BX visszaállítása
                     POP   DX                  ;DX visszaállítása
                     RET                       ;Visszatérés
read_string endp

END main