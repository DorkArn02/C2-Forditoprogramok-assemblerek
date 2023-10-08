.MODEL SMALL
.STACK
.DATA
.CODE
; Olvassunk be 3 byte-os értéket, szorozzuk össze őket,
; és csak 0-9 karaktereket fogadjon el a read_decimal függvény
; MUL a szorzás, a célja mindig az akkumulátorregiszter (AX)
main proc
    XOR AX, AX
    XOR DX, DX

    MOV AL, 1   ; 1 kezdőérték

    MOV CX,3    ; 3 szám bekérése
    cikl:
    CALL read_decimal
    MUL dl
    LOOP cikl

    MOV DL,AL
    CALL write_decimal
    MOV AH, 4ch
    INT 21h

main endp

CR EQU 13	   
LF EQU 10	   

cr_lf proc

    push DX
    mov DL, CR
    call write_char
    mov DL, LF
    call write_char
    pop DX
    ret

cr_lf endp


write_char proc

    push AX
    mov AH, 2h
    int 21h
    pop AX
    ret

write_char endp


read_char proc

    push AX
    mov AH, 1
    int 21h
    mov DL, AL

    pop AX
    ret

read_char endp


write_hexa_digit proc

    push DX
    CMP DL,10
    JB non_hexa_letter
    ADD DL, 'A'-10-'0'
 non_hexa_letter:
    ADD DL, '0'
    call write_char
    pop DX
    ret

write_hexa_digit endp


write_decimal proc
    push AX
    push CX
    push DX
    push SI
    mov AX, DX
    mov SI, 10
    XOR CX, CX
 decimal_non_zero:
    XOR DX, DX
    DIV si
    push DX
    inc CX
    OR AX, AX
    JNE decimal_non_zero
 decimal_loop:
    pop DX
    call write_hexa_digit
    loop decimal_loop

    pop SI
    pop DX
    pop CX
    pop AX
    ret

write_decimal endp

read_decimal proc
    push AX
    push BX
    mov BX,10
    XOR AX,AX
 r_d_new:
    call read_char
    CMP DL,CR
    JE r_d_end
    SUB DL,'0'
    MUL BL
    ADD AL,DL
    JMP r_d_new
 r_d_end:
    MOV DL,AL
    pop BX
    pop AX
    ret
read_decimal endp

END main
