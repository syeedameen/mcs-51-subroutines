;-----------------------------------------------------------------------------;
;  Program subrotutine to compare two strings terminate with '\0' character   ;
;-----------------------------------------------------------------------------;
; SUBROUTINE DESCRIPTION                                                      ;
;                      1. push base both addresses of string array            ; 
;                           push address of n                                 ;
;                           push address of m                                 ;                     
; RESOURCES                                                                   ;
;                      2. only use r0,r1,r2,r3,r4,r5 register                 ;
;-----------------------------------------------------------------------------;

; PROCEDURE FOR STRING COMPARISION 


;	/* 	String Comparision Function if stirng equal return 0 otherwise 
; 		return difference between last two string
;	*/
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
    
    pop acc             ; first string base address (m) 
    mov r1, a 
    pop acc
    mov r0,a  

    pop acc             ; second string base address (n)
    mov r3, a 
    pop acc
    mov r2,a  

    push 0x7e
    push 0x7f
	

repeat_strcmp:
	mov dpl, r0 
	mov dph, r1 
	movx a, @dptr
	mov r4, a 			; *m    r4 <-- character of first string 
	
	mov dpl, r2 
	mov dph, r3 
	movx a, @dptr
	mov r5, a 			; *n    r5 <-- character of second string 
	
	cjne a, #'\0', checkSecond_strcmp
		mov a, r4       ; if first string end return *m - *n 
		clr c 		    
		subb a, r5 
		pop 0x7f 
		pop 0x7e 
		push acc 
		push 0x7e 
		push 0x7f 
		ret 

checkSecond_strcmp:
	cjne a, #'\0', skip_strcmp
		mov a, r4       ; if second string end return *m - *n 
		clr c 
		subb a, r5 
		pop 0x7f 
		pop 0x7e 
		push acc 
		push 0x7e 
		push 0x7f 
		ret
	skip_strcmp:
	
	mov a, r4           
	clr c 
	subb a, r5          ; cmp both string character by subb (make sure carry is 0)
	jnz notEqual_strcmp
		mov dpl, r0     ; if equal increment m++, n++ and repeat_strcmp 
		mov dph, r1 
		inc dptr 
		mov r0, dpl 
		mov r1, dph 
		
		mov dpl, r2 
		mov dph, r3 
		inc dptr 
		mov r2, dpl 
		mov r3, dph 
		jmp repeat_strcmp
	notEqual_strcmp:    
	mov a, r4           ; else return *m - *n 
	clr c 
	subb a, r5 
	pop 0x7f 
	pop 0x7e 
	push acc 
	push 0x7e 
	push 0x7f 
	ret 