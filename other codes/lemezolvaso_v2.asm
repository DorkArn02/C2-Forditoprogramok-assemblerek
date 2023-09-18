; keretezd be es kerd be hogy honnan olvasson
.MODEL SMALL
.STACK
.DATA
	block db 624 dup (?)
	;szoveg db "Irja be a meghajto szamat: ", 24h
.CODE

CR equ 13

main proc
	mov ax, DGROUP
	mov ds, ax
	lea bx, block


	call read_decimal

	mov al, dl	; A meghajto
	mov cx, 1	; 1db blokk
	mov dx, 0	; kezdocim

	int 25h
	popf		; flaget a stackbol feltolti

	mov ah, 06
	mov al, 0
	mov bh, 240
	mov ch, 0
	mov cl, 0
	mov dh, 50
	mov dl, 80
	int 10h

	xor dx, dx
	call write_block

	mov ah, 10h
	int 16h

	mov ax, 4c00h
	int 21h
main endp

write_block proc
	push cx
	push dx

	call vonal

	mov cx, 32
s_w_new:
	call out_line
	call cr_lf
	add dx, 16
	loop s_w_new

	mov dl, space
	call write_char

	call vonal

	pop dx
	pop cx
	ret
write_block endp

space equ ' '	; space szimboluma

out_line proc
	push bx
	push cx
	push dx

	mov bx, dx
	push bx

	mov dl, space
	call write_char
	mov dl, 178d
	call write_char

	mov cx, 16
hexa_out:
	mov dl, BLOCK [bx]	; a bx-nel levo blokk elejere all
	call write_hexa
	mov dl, space
	call write_char
	inc bx
	loop hexa_out

	mov dl, 176d;space
	call write_char
	mov cx, 16
	pop bx
ascii_out:
	mov dl, BLOCK [bx]
	cmp dl, space
	ja visible
	mov dl, space
visible:
	call write_char
	inc bx
	loop ascii_out

	mov dl, 178d
	call write_char

	pop dx
	pop cx
	pop bx
	ret
out_line endp

write_hexa proc
	push cx
	push dx

	mov dh, dl
	;sub dx, 30h
	mov cl, 04
	shr dl, cl
	call hexa_digit

	mov dl, dh
	and dl, 0fh
	call hexa_digit

	pop dx
	pop cx
	ret

hexa_digit:
	push dx
	cmp dl, 0ah
	jb non_hexa
	add dl, 7; 'A'-10-'0'

non_hexa:
	add dl, 30h ;'0'
	call write_char
	pop dx

	ret
write_hexa endp

cr_lf proc
    push dx

    mov dl, 0dh

    call write_char

    mov dl, 0ah

    call write_char

    pop dx

    ret
cr_lf endp

write_char proc
    push ax

    mov ah, 02
    int 21h

    pop ax

    ret
write_char endp

vonal proc
	push dx
	push cx

	;mov dl, space
	;call write_char
	
	mov dl, 178d
	mov cx, 67d
  cikl_v:
	call write_char
	loop cikl_v

	call cr_lf
	
	pop cx
	pop dx
	ret
vonal endp

read_decimal proc

	push AX	    ; AX regisztert elmentjük
	push BX
	push DX
	mov BX,10
	XOR AX,AX	    ; nullázzuk tartalmát
     r_d_new:
	call read_char
	CMP DL,CR
	JE r_d_end	    ; ha egyenlő
	SUB DL,'0'
	MUL BL
	ADD AL,DL
	JMP r_d_new
     r_d_end:
	MOV DL,AL
	pop DX
	pop BX
	pop AX
	ret

read_decimal endp

read_char proc
	push ax
	mov ah, 01
	int 21h
	mov dl, al
	pop ax
	ret
read_char endp

end main
