.MODEL SMALL 
.STACK
.DATA
    Attr DB 10,0            ;Hossz adatok: puffer méret, karakterszám
    Adat DB 11 DUP ('$')    ;Adatterület, feltöltve ”$” karakterrel
.CODE
main proc
               MOV  AX, DGROUP    ;Adatszegmens beállítása
               MOV  DS, AX
               LEA  DX, Attr      ;Input puffer, az első két bájt a hosszakhoz
               MOV  AH, 0Ah       ;Puffered keyboard input
               INT  21h           ;Sztring beolvasása
               CALL cr_lf         ;Soremelés
               LEA  DX, Adat      ;Output puffer
               MOV  AH, 9h        ;Print string
               INT  21h           ;Sztring kiírás
               MOV  AH,4Ch        ;Visszatérés az operációs rendszerbe
               INT  21h
main endp

write_char proc
               push AX
               mov  AH, 2h
               int  21h
               pop  AX
               ret
write_char endp

cr_lf proc
               push DX
               mov  DL,13
               call write_char
               mov  DL,10
               call write_char
               pop  DX
               ret
cr_lf endp

END main