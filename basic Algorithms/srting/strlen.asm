;-----------------------------------------------------------------------------;
;  Program subrotutine to find the length of string terminate with '\0' char  ;
;-----------------------------------------------------------------------------;
;  SUBROUTINE DESCRIPTION                                                     ;
;                      1. push base address of string array                   ;                      
; RESOURCES                                                                   ;
;                      1. only use r0 register                                ;
;-----------------------------------------------------------------------------; 
strlen:
    pop 0x7f 
    pop 0x7e 
    pop dph             ; string array base address 
    pop dpl 
    push 0x7e 
    push 0x7f 

    mov r0, #0x00       ; length counter 

repeat_strlen:
    movx a, @dptr
    cjne a, #'\0', skip_strlen
        pop 0x7f
        pop 0x7e 
        mov a, r0
        push acc 
        push 0x7e
        push 0x7f 
        ret 
    skip_strlen:
    inc r0 
    inc dptr 
    rjmp repeat_strlen