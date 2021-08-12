;-----------------------------------------------------------------------------;
;  Program subrotutine to compare two strings terminate with '\0' character   ;
;-----------------------------------------------------------------------------;
; SUBROUTINE DESCRIPTION                                                      ;
;                      1. push base both addresses of string array            ;                      
; RESOURCES                                                                   ;
;                      1. only use r0 register                                ;
;-----------------------------------------------------------------------------;

; PROCEDURE 

;/* String Comparision Function 
; 	if stirng equal return 0 otherwise 
; 	return difference between last two string
;*/

;int strcmp(char *m, char *n)
;{
;	while (*m != '\0' && *n != '\0')
;	{
;		if (*m == *n)
;		{
;			m++;
;			n++;
;		}
;		else 
;		{
;			return *m - *n;
;		}
;	}
;   return *m - *n;
;}

strcmp:
    pop 0x7f 
    pop 0x7e 
    
    pop acc             ; first string base address 
    mov r1, a 
    pop acc
    mov r0,a  

    pop acc             ; second string base address 
    mov r3, a 
    pop acc
    mov r2,a  

    push 0x7e
    push 0x7f 

	mov r4, #0x00 		; strcmp comparision return value 



repeat_strcmp:	
    mov dpl, r0 
    mov dph, r1 
    movx a, @dptr
    mov r5, a           ; first string character 
    cjne a, #'\0', notEqual_strcmp1
        mov dpl, r2                         ; if end of string return 
        mov dph, r3                         ; difference between to strings 
        movx a, @dptr
        xch a, r5               ; because return (*m - *n)
        subb a, r5 
        pop 0x7f 
        pop 0x7e 
        push acc 
        push 0x7e 
        push 0x7f 
        ret 
    notEqual_strcmp1:
    mov dpl, r2 
    mov dph, r3 
    movx a, @dptr
    mov r6, a
    cjne a, #'\0', notEqual_strcmp2
        xch a, r5               ; because return (*m - *n)
        subb a, r5  
        pop 0x7f 
        pop 0x7e 
        push acc 
        push 0x7e 
        push 0x7f 
        ret 
    notEqual_strcmp2:
        mov a, r5 
        xch a, r5 
        subb a, r6 
        jnz skip_strcmp         ; if both string char are equal than 
            inc dptr            ; increment pointer m++, n++ and repeat_strcmp
            mov r2, dpl     
            mov r3, dph 
            mov dpl, r0 
            mov dph, r1 
            inc dptr 
            mov r0, dpl 
            mov r1, dph 
            sjmp repeat_strcmp
    skip_strcmp:
        pop 0x7f 
        pop 0x7e 
        push acc 
        push 0x7e 
        push 0x7f 
        ret   