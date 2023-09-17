.MODEL SMALL
.STACK
.DATA
    adat_1 DB "Elso sor",0
    adat_2 DB "Masodik sor",0
.CODE

main PROC
                  MOV  AX, DGROUP
                  MOV  DS, AX
                  LEA  BX, adat_1
                  CALL write_string
                  LEA  BX, adat_2
                  CALL write_string
                  MOV  AH, 4CH
                  INT  21H
main ENDP

    ; Karakter kiíratása az stdout-al DL-ből olvassa ki
write_char PROC
                  PUSH AX
                  MOV  AH, 2            ; AH=2 stdout
                  INT  21h              ; Karakter kiíratása a képernyőre
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
                  JMP  write_str_new
    write_str_end:
                  POP  BX
                  POP  DX
                  RET
write_string ENDP

END MAIN