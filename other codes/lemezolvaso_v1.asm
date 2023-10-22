.MODEL SMALL
.STACK
.DATA?
	block db 512 DUP(?)
.CODE
main proc
	                 mov  AX, dgroup
	                 mov  DS, AX
	                 call read_decimal

	                 mov  AL, DL          	; meghajtó
	                 mov  CX, 1           	; 1 db blokkot olvasunk be
	                 lea  BX, block

	                 mov  DX, 0           	; kezdőblokk címe, kezdőcím
	                 int  25h             	; ennek hatására a 0-s meghajtóról 1 blokkot betölt a megadott címre (DS:BX reg.)
	; nem közönséges regiszterbe mentünk, hanem a státuszregiszterre
	                 popf                 	; stackról letölti a státuszregisztert
	                 xor  DX, DX

	                 call write_block     	; soronkénti ciklus - ki fog írni 32 db sort

	                 mov  AH, 4ch
	                 int  21h

main endp


write_block proc

	                 push CX
	                 push DX

	                 mov  CX, 32          	; ciklusváltozó (lépésszám)
	s_w_new:         
	                 call out_line
	                 call cr_lf
	                 add  DX, 16
	                 loop s_w_new

	                 pop  DX
	                 pop  CX
	                 ret

write_block endp


	space            EQU  ' '


out_line proc

	                 push BX
	                 push CX
	                 push DX

	                 mov  BX, DX
	                 push BX
	                 mov  CX, 16

	                 push DX
	                 mov  DL, '|'
	                 call write_char
	                 mov  DL, ' '
	                 call write_char
	                 pop  DX

	hexa_out:        
	                 mov  DL, block[BX]
	                 call write_hexa
	                 inc  BX
	                 loop hexa_out
	                 mov  DL, space
	                 call write_char
	                 mov  CX, 16
	                 pop  BX

	                 push DX
	                 mov  DL, '|'
	                 call write_char
	                 mov  DL, ' '
	                 call write_char
	                 pop  DX

	ascii_out:       
	                 mov  DL, block[BX]
	                 CMP  DL, space
	                 JA   visible
	                 mov  DL, space
	visible:         
	                 call write_char
	                 inc  BX
	                 loop ascii_out



	                 pop  DX
	                 pop  CX
	                 pop  BX

	                 ret

out_line endp


	; Régi szubrutinok:


write_string proc

	                 push BX
	                 push DX

	w_s_uj:          
	                 mov  DL, [BX]
	                 OR   DL,DL
	                 JZ   w_s_vege
	                 call write_char
	                 inc  BX
	                 jmp  w_s_uj
	w_s_vege:        

	                 pop  DX
	                 pop  BX

write_string endp


read_char proc
	                 push ax
	                 mov  ah, 01
	                 int  21h
	                 mov  dl, al
	                 pop  ax
	                 ret
read_char endp

read_decimal proc

	                 push AX              	; AX regisztert elmentjük
	                 push BX
	                 mov  BX,10
	                 XOR  AX,AX           	; nullázzuk tartalmát
	r_d_new:         
	                 call read_char
	                 CMP  DL,CR
	                 JE   r_d_end         	; ha egyenlő
	                 SUB  DL,'0'
	                 MUL  BL
	                 ADD  AL,DL
	                 JMP  r_d_new
	r_d_end:         
	                 MOV  DL,AL
	                 pop  BX
	                 pop  AX
	                 ret

read_decimal endp

write_hexa proc

	                 push CX
	                 push DX
	                 mov  DH,DL
	                 mov  CL, 4
	                 SHR  DL,CL
	                 call write_hexa_digit
	                 mov  DL,DH
	                 AND  DL, 0Fh
	                 call write_hexa_digit
	                 pop  DX
	                 pop  CX
	                 ret

write_hexa endp


write_hexa_digit proc

	                 push DX
	                 CMP  DL,10
	                 JB   non_hexa_letter
	                 ADD  DL, 'A'-10-'0'
	non_hexa_letter: 
	                 ADD  DL, '0'
	                 call write_char
	                 pop  DX
	                 ret

write_hexa_digit endp


write_char proc

	                 push AX
	                 mov  AH, 2h
	                 int  21h
	                 pop  AX
	                 ret

write_char endp


	CR               EQU  13              	; ld.03
	LF               EQU  10              	; ld.03

cr_lf proc

	                 push DX
	                 mov  DL, CR
	                 call write_char
	                 mov  DL, LF
	                 call write_char
	                 pop  DX
	                 ret

cr_lf endp



END main

; cím adása
; egy bekérés legyen (meghajtó sorszáma, stb.)
; a táblázat megformázása, keretezés
; jó lenne még tavaszi szünet előttre
