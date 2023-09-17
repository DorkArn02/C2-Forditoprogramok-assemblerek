
.MODEL SMALL
.STACK

.CODE

main proc
         mov ax, 0b800h        ; videó-memória szegmenscíme
         mov es, ax            ; szegmenscím behelyezése es-be

         mov ah, 0h            ; képernyőírás kódja
         mov al, 3h
         int 10h
         MOV DI, 1838          ;Képernyő közepének ofszetcíme
         MOV AL, "*"           ;Kiírandó karakter
         MOV AH, 128+16*7+4    ;Színkód: szürke háttér, piros karakter, villog
         MOV ES:[DI], AX       ;Karakter beírása a képernyő-memóriába
         MOV AH, 4Ch           ;Kilépés
         INT 21h
main endp

END MAIN