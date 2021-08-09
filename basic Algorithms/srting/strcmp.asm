;-----------------------------------------------------------------------------;
;  Program subrotutine to compare two strings terminate with '\0' character   ;
;-----------------------------------------------------------------------------;
; SUBROUTINE DESCRIPTION                                                      ;
;                      1. push base both addresses of string array            ;                      
; RESOURCES                                                                   ;
;                      1. only use r0 register                                ;
;-----------------------------------------------------------------------------; 

strcmp:
    pop 0x7f 
    pop 0x7e 
    
    pop dph 
    pop dpl 

    mov r0, dpl  
    mov r1, dph 

    pop dph 
    pop dpl 

    mov r2, dpl 
    mov r3, dph 

    push 0x7e
    push 0x7f 

; while (*p != '\0' && *q != '\0')
;   {
;       if (*p == *q)
;           p++, q++;
;       else 
;           return false;
;   }
;   return false;
