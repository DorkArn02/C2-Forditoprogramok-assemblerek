.MODEL SMALL
.STACK
.DATA
    txt        DB  "Hello World$"
    txt_length EQU $ - txt
.CODE

main PROC
                  MOV  AX, DGROUP
                  MOV  DS, AX
                  LEA  BX, txt + txt_length - 2
                  LEA  CX, txt
                  CALL write_string
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
cr_lf PROC
                  PUSH DX
                  MOV  DL, 13                      ; CR
                  CALL write_char
                  MOV  DL, 10                      ; LF
                  CALL write_char
                  POP  DX
                  RET
cr_lf ENDP
write_char PROC
                  PUSH AX
                  MOV  AH, 2
                  INT  21h
                  POP  AX
                  RET
write_char ENDP
write_string PROC
                  PUSH DX
                  PUSH BX
    previous_char:
                  MOV  DL, [BX]
                  OR   DL, DL
                  CALL write_char
                  CMP  BX, CX                      ; első karakter balról?
                  JE   stop
                  DEC  BX
                  JMP  previous_char
    stop:         
                  POP  BX
                  POP  DX
                  RET
write_string ENDP

END MAIN