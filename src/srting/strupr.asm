;-----------------------------------------------------------------------------;
;       Program subrotutine to convert to lower case string upper case        ;
;-----------------------------------------------------------------------------;
;  SUBROUTINE DESCRIPTION                                                     ;
;                      1. push base address of string array                   ;                      
; RESOURCES                                                                   ;
;                      1. only use r0 register                                ;
;-----------------------------------------------------------------------------; 
strlwr:
    pop 0x7f 
    pop 0x7e 
    
    pop dph             ; base address of array 
    pop dpl 
    pop acc             ; number of characters 

    push 0x7e 
    push 0x7f 

    mov r0, a           ; character counter 
    
repeat_strlwr:
    movx a, @dptr 
    clr c               ; clear carry flag because it's subb (subtract with borowed) 
    subb a, #'a' - 'A'  ; subtract 32 or 'a' - 'A'
    movx @dptr, a 
    inc dptr 
    djnz r0, repeat_strlwr
    
    ret 