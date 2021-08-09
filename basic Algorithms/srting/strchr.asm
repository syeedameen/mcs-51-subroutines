;-----------------------------------------------------------------------------;
;       Program subrotutine to Searches for a character within a string.      ;
;       The function returns that character’s position from the start of the  ;
;       string as a pointer.                                                  ;
;-----------------------------------------------------------------------------;
;  SUBROUTINE DESCRIPTION                                                     ;
;                      1. push base address of string array                   ;                      
; RESOURCES                                                                   ;
;                      1. only use r0 & B register                            ;
;-----------------------------------------------------------------------------; 

; search the character into string end with '\0'
strchr:
	pop 0x7f 
	pop 0x7e 
	pop dph 
	pop dpl 
	pop acc 
	push 0x7f 
	push 0x7e 
	
	mov r0, #0x00 	; index counter for string 
	mov b, a 		; searching element store into b register 
	
repeat_strchr:
	movx a, @dptr 
	cjne a, #'\0', skip_strchr			
		pop 0x7f 			
		pop 0x7e 
		mov a, #-1 		; return -1 if end of string 
		push acc 
		push 0x7e 
		push 0x7f 
		ret
		
skip_strchr:
	cjne a, b, notequal_strchr	; compare with b (searching element)
		pop 0x7f 
		pop 0x7e 
		mov a, r0 		; push index counter
		push acc 
		push 0x7e 
		push 0x7f 
		ret 
	notequal_strchr:
	inc dptr 
	inc r0 
	rjmp repeat_strchr