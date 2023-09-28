.MODEL SMALL
.STACK
.DATA
    adat_1 DB "forditoprogramok",0
    adat_2 DB "Masodik sor",0
.CODE
    ; Írja ki egy tetszőleges (konstans) szöveg páratlan számú karaktereit.
main PROC
                  CALL cls
                  MOV  AX, DGROUP
                  MOV  DS, AX
                  LEA  BX, adat_1
                  CALL write_string
                  CALL cr_lf
                  LEA  BX, adat_2
                  CALL write_string
                  MOV  AH, 4CH
                  INT  21H
main ENDP

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
    write_str_new:
                  MOV  DL, [BX]
                  OR   DL, DL
                  JZ   write_str_end
                  CALL write_char

                  INC  BX
                  MOV  DL, [BX]
                  OR   DL, DL
                  JZ   write_str_end

                  INC  BX
                  JMP  write_str_new
    write_str_end:
                  POP  BX
                  POP  DX
                  RET
write_string ENDP

cls PROC
                  PUSH AX
                  mov  ax, 3
                  int  10h
                  POP  AX
                  RET
cls ENDP

cr_lf PROC
                  PUSH DX
                  MOV  DL, 13
                  CALL write_char
                  MOV  DL, 10
                  CALL write_char
                  POP  DX
                  RET
cr_lf ENDP

END MAIN