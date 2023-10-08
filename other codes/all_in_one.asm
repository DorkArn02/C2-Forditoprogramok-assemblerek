.MODEL SMALL
.STACK

.CODE

    ; Összes órai szubrutin lentebb
main PROC
                      CALL read_char
                      CALL cr_lf
                      CALL write_char
                      CALL cr_lf
                      CALL write_binary
                      CALL cr_lf
                      CALL write_hexa
                      CALL cr_lf
                      CALL write_decimal

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

END main