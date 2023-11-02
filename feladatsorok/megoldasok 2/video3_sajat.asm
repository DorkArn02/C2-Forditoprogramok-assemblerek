.MODEL SMALL
.STACK
.CODE
    ; Keszitsen  programot,  amely  beolvas  egy  karaktert.  Majd  a  beolvasott  karakterbol,  (tetszoleges attributummal) bekeretezi a kepernyot. Hasznalja a megfelelo alprogramokat!
main PROC
                     MOV  AX, 0B800h                  ; Kepernyo-memoria szegmenscime ES-be
                     MOV  ES, AX
                     CALL cls
                     mov  cl, 1                       ; x
                     mov  ch, 1                       ; y
    lp:              
                     CALL draw_side
                     CMP  CH, 25
                     JNE  lp

                     mov  cl, 80                      ; x
                     mov  ch, 1                       ; y
    lp2:             
                     CALL draw_side
                     CMP  CH, 25
                     JNE  lp2

                     mov  cl, 1                       ; x
                     mov  ch, 25                      ; y
    lp3:             
                     CALL draw_vertical
                     CMP  CL, 80
                     JNE  lp3

                     mov  cl, 1                       ; x
                     mov  ch, 1                       ; y
    lp4:             
                     CALL draw_vertical
                     CMP  CL, 80
                     JNE  lp4

                     MOV  AH, 4Ch                     ; Kilepes
                     INT  21h
main ENDP

set_videomode PROC
                     PUSH AX
                     MOV  AH, 0h                      ; Kepernyouzemmod (AH)
                     MOV  AL, 3h                      ; 80x25 felbontas szines mod (AL)
                     INT  10H
                     POP  AX
                     RET
set_videomode ENDP

draw_side PROC
                     PUSH AX
                     PUSH BX
                     PUSH DX
                     PUSH DI
    ; Pozicio keplet
    ; 2[(y-1)*80 + (x-1)] = 160(y-1) + 2(x-1)
                     XOR  AX, AX                      ; AX torlese
                     MOV  DL, CH
    ;CALL read_decimal         ; y bekerese
                     MOV  AL, DL
                     DEC  AL                          ; y-1
                     MOV  BL, 160
                     MUL  BL                          ; (y-1)*160 Elso tag
                     MOV  DI, AX                      ; Elso tag eltarolasa a DI-ba

                     XOR  AX, AX                      ; AX torlese
                     MOV  DL, CL
    ;CALL read_decimal         ; x bekerese
                     MOV  AL, DL
                     DEC  AL                          ; x-1
                     SHL  AL, 1                       ; 2(x-1) Masodik tag
                     ADD  DI, AX                      ; DI = DI + AL

    ;CALL read_char            ; Karakter beolvasasa
                     MOV  AL, 'a'                     ; Karakter az also 4 bithelyre
    ;CALL read_decimal         ; Attributum bekerese
                     MOV  AH, 128 * 0 + 16 * 0 + 4    ; Attributum a felso 4 bithelyre

                     MOV  ES:[DI], AX                 ; Kepernyo memoriara iras

                     INC  CH

                     POP  DI
                     POP  DX
                     POP  BX
                     POP  AX
                     RET
draw_side ENDP

draw_vertical PROC
                     PUSH AX
                     PUSH BX
                     PUSH DX
                     PUSH DI
    ; Pozicio keplet
    ; 2[(y-1)*80 + (x-1)] = 160(y-1) + 2(x-1)
                     XOR  AX, AX                      ; AX torlese
                     MOV  DL, CH
    ;CALL read_decimal         ; y bekerese
                     MOV  AL, DL
                     DEC  AL                          ; y-1
                     MOV  BL, 160
                     MUL  BL                          ; (y-1)*160 Elso tag
                     MOV  DI, AX                      ; Elso tag eltarolasa a DI-ba

                     XOR  AX, AX                      ; AX torlese
                     MOV  DL, CL
    ;CALL read_decimal         ; x bekerese
                     MOV  AL, DL
                     DEC  AL                          ; x-1
                     SHL  AL, 1                       ; 2(x-1) Masodik tag
                     ADD  DI, AX                      ; DI = DI + AL

    ;CALL read_char            ; Karakter beolvasasa
                     MOV  AL, 'a'                     ; Karakter az also 4 bithelyre
    ;CALL read_decimal         ; Attributum bekerese
                     MOV  AH, 128 * 0 + 16 * 0 + 4    ; Attributum a felso 4 bithelyre

                     MOV  ES:[DI], AX                 ; Kepernyo memoriara iras

                     INC  CL

                     POP  DI
                     POP  DX
                     POP  BX
                     POP  AX
                     RET
draw_vertical ENDP

read_char PROC
                     PUSH AX                          ; AX elmentése a verembe, mert itt használjuk ne írjuk felül
                     MOV  AH, 1                       ; AH=1 stdin
                     INT  21h                         ; Karakter bekérése és elmentése AL-be
                     MOV  DL, AL                      ; AL-ből DL-be rakjuk a karaktert
                     POP  AX                          ; AX visszatöltése a veremből
                     RET                              ; Visszatérés a hívóhoz
read_char ENDP

write_char PROC
                     PUSH AX
                     MOV  AH, 2                       ; AH=2 stdout
                     INT  21h                         ; Karakter kiíratása a képernyőre
                     POP  AX
                     RET
write_char ENDP

cr_lf PROC
                     PUSH DX
                     MOV  DL, 13                      ; Carriage return
                     CALL write_char
                     MOV  DL, 10                      ; Line feed
                     CALL write_char
                     POP  DX
                     RET
cr_lf ENDP

read_decimal PROC
                     PUSH AX
                     PUSH BX
                     MOV  BL, 10
                     XOR  AX, AX

    read_decimal_new:
                     CALL read_char
                     CMP  DL, 13                      ; input karakter = ENTER
                     JE   read_decimal_end            ; ugrik, ha enter a karakter
                     SUB  DL, "0"                     ; karakter - '0'
                     MUL  BL                          ; AX = AX * 10
                     ADD  AL, DL                      ; Következő helyi érték hozzáadása
                     JMP  read_decimal_new            ; Következő karakter beolvasása

    read_decimal_end:
                     MOV  DL, AL
                     POP  BX
                     POP  AX
                     RET
read_decimal ENDP

write_decimal proc
                     push AX
                     push CX
                     push DX
                     push SI
                     XOR  DH, DH                      ; Felső 8 bit törlése, csak az alsó 8 van meg stdin-ból
                     mov  AX, DX                      ; osztandó szám AX-be
                     mov  SI, 10                      ; osztó
                     XOR  CX, CX                      ; CX = 0
    decimal_non_zero:
                     XOR  DX, DX                      ; DX = 0
                     DIV  SI                          ; AX osztása SI-vel, eredmény AX-be, maradék DX-be kerül
                     push DX                          ; maradék mentése verembe
                     inc  CX                          ; osztások száma + 1
                     OR   AX, AX                      ; státuszbitek beállítása AX-nek megfelelően
                     JNE  decimal_non_zero            ; Ugrás, ha nem nulla
    decimal_loop:    
                     pop  DX                          ; maradék kivétele veremből
                     call write_hexa_digit            ; kiíratás
                     loop decimal_loop                ; ciklus
                     pop  SI
                     pop  DX
                     pop  CX
                     pop  AX
                     ret

write_decimal endp
    
write_hexa_digit PROC
                     PUSH DX
                     CMP  DL, 10                      ; DL összehasonlítása 10-zel
                     JB   non_hexa_letter             ; Ugrás, ha kisebb mint 10
                     ADD  DL, "A"-"0"-10              ; A-F betű kiírása
    non_hexa_letter: 
                     ADD  DL, "0"                     ; ASCII kód megadása
                     CALL write_char
                     POP  DX
                     RET
write_hexa_digit ENDP

cls PROC
                     PUSH AX
                     mov  ax, 3
                     int  10h
                     POP  AX
                     RET
cls ENDP

clear_screen PROC
                     xor  AL,AL
                     xor  CX,CX
                     MOV  DH,49
                     MOV  DL,79
                     MOV  BH,7
                     MOV  AH,6
                     INT  10h
                     RET
clear_screen ENDP

END main