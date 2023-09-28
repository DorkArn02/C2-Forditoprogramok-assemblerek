.MODEL SMALL
.STACK
.CODE
    ;Olvasson be két bináris számot, végezze el az AND műveltet, majd az eredményt írja ki a képernyőre.

main PROC
                    CALL read_binary
                    MOV  BL, DL
                    CALL cr_lf
                    CALL read_binary
                    AND  DL, BL
                    CALL write_binary
                    
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

read_binary proc
                    PUSH AX                 ;AX mentése a verembe
                    XOR  AX, AX             ;AX törlése
    read_binary_new:
                    CALL read_char          ;Egy karakter beolvasása
                    CMP  DL, 13             ;ENTER ellenőrzése
                    JE   read_binary_end    ;Vége, ha ENTER volt az utolsó karakter
                    SUB  DL, "0"            ;Karakterkód minusz ”0” kódja
                    SAL  AL, 1              ;Szorzás 2-vel, shift eggyel balra
                    ADD  AL, DL             ;A következő helyi érték hozzáadása
                    JMP  read_binary_new    ;A következő karakter beolvasása
    read_binary_end:
                    MOV  DL, AL             ;DL-be a beírt szám
                    POP  AX                 ;AX visszaállítása
                    RET                     ;Visszatérés a hívó rutinba
read_binary endp

write_binary PROC
                    PUSH BX
                    PUSH CX
                    PUSH DX

                    MOV  BL, DL             ; beolvasott karakter elmentése BL-be
                    MOV  CX, 8              ; 8-szor írunk ki számjegyet

    binary_digit:   
                    XOR  DL, DL             ; DL nullázása
                    RCL  BL, 1              ; BL elforgatása balra 1-gyel CF-be kerül az eredmény
                    ADC  DL, "0"            ; 0 + 0 = 1 VAGY 0 + 1 = 1, add with carry
                    CALL write_char
                    LOOP binary_digit       ; amíg CX nem nulla addig csökkenti a tartalmát
                    POP  DX
                    POP  CX
                    POP  BX
                    RET
write_binary ENDP

write_char PROC
                    PUSH AX
                    MOV  AH, 2
                    INT  21h
                    POP  AX
                    RET
write_char ENDP

cr_lf PROC
                    PUSH DX
                    MOV  DL, 13             ; CR
                    CALL write_char
                    MOV  DL, 10             ; LF
                    CALL write_char
                    POP  DX
                    RET
cr_lf ENDP

END MAIN