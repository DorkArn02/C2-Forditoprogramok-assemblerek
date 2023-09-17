.MODEL SMALL
.STACK
.CODE

main proc

              mov  cx, 26
              mov  dx, 65
    innerLoop:
              mov  ah, 2
              int  21h

              inc  dx
              loop innerLoop

              mov  ah, 4ch
              int  21h

main endp

END MAIN