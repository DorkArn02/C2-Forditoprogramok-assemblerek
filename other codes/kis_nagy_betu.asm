.MODEL SMALL
.STACK
.DATA
    adat_1 DB "Elso sor",0
.CODE
    ; Kis nagybetu string konvertalo
main PROC
                  MOV  AX, DGROUP
                  MOV  DS, AX
                  LEA  BX, adat_1
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

                  CMP  DL, 'z'
                  CALL toLowerCase
                  INC  BX
                  JMP  write_str_new
    write_str_end:
                  POP  BX
                  POP  DX
                  RET
write_string ENDP

toUpperCase PROC
                  PUSH DX
                  CMP  DL, 'a'          ; Ha kisebb, mint  a betű akkor írassuk ki
                  JL   print
                  CMP  DL, 'z'          ; Ha kisebb vagy egyenlő, mint a z betű akkor alakítsuk nagybetűvé
                  JLE  convert
    convert:      
                  SUB  DL, 'a'-'A'
    print:        
                  CALL write_char
                  POP  DX
                  RET
toUpperCase ENDP

toLowerCase PROC
                  PUSH DX
                  CMP  DL, 'Z'          ; Ha Z-nél nagyobb, akkor kiíratjuk
                  JG   print2
                  CMP  DL, 'A'          ; Ha A-nál kisebb, akkor kiíratjuk
                  JL   print2
                  JGE  convertLower     ; Ha A-nál nagyobb vagy egyenlő akkor konvertáljuk kisbetűvé
    convertLower: 
                  ADD  DL, 'a'-'A'
    print2:       
                  CALL write_char
                  POP  DX
                  RET
toLowerCase ENDP

END MAIN