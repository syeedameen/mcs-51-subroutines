;-------------------------------------------------------;
;		      binary search subroutine                  ;
;-------------------------------------------------------;

;-------------------------------------------------------;
;               DISCRYPTION OF SUBROUTINE               ;
;                                                       ;
; 	1. push number of elements                          ;
; 	2. push key element                                 ;
; 	3. push base address of array (lower addr first)    ;
;-------------------------------------------------------;

;-------------------------------------------------------;
;                      ALGORITHM                        ;
;-------------------------------------------------------;
;             Binarysearch(A,n,key)                     ;
;             low  := 0                                 ;
;             high := n                                 ;
;             mid := 0                                  ;
;                                                       ;
;             while(low <= high)                        ;
;                mid = (low + high) / 2                 ;
;                if a[mid] == key                       ;
;                    return mid                         ;
;                if a[mid] < key                        ;
;                    low := mid+1                       ;
;                if a[mid] > key                        ;
;                    high := mid-1                      ;
;                                                       ;
;            search is not sucsessful                   ;
;            exit                                       ;  
;-------------------------------------------------------;

binsearch:
	pop 0x7f 
	pop 0x7e 

	pop dph 	; base address of array 	
	pop dpl

	pop acc 	
	mov r0,a 	; key element 
	pop acc		; number of elements 

	push 0x7e 
	push 0x7f 


	mov r1, #0x00 	; low index 
	mov r2, a 	    ; high index 
	mov r3, #0x00	; middle index 

repeat_binsearch:
	; check while (low < high)
	mov a, r1 
	subb a, r2 	; compare low with high 

; condition flags 
; low > high 	(C = 0, Z = 0)
; low == high 	(C = 0, Z = 1)
; low < high 	(C = 1, Z = 0)
	
	jc exit_loop_binsearch 
	pop 0x7f 
	pop 0x7e 
	mov a, #-1 
	push acc 
	push 0x7e 
	push 0x7f 
	ret 
	
exit_loop_binsearch:

	mov a, r1 
	push acc 
	mov a, r2 
	push acc 
	acall middle_position 
	pop acc 
	mov r3, a 		        ; middle index position 
	
	movc a, @a+dptr 	    ; fetch a[middle] element 
	subb a, r0 		        ; compare a[middle] with key element 
	
	jnz not_equal_binsearch
	pop 0x7f 
	pop 0x7e 
	mov a, r3 
	push 0x7e 
	push 0x7f 
	ret 	


; condition flags of comparision a[middle] with key 
;   if (a[middle] > key)    (C = 0)
;   if (a[middle] < key)    (C = 1)

not_equal_binsearch:
	jc greater_than_binsearch 	
	mov a, r3                   ; high = mid - 1
	mov r2, a 
	dec r2 
	rjmp repeat_binsearch 		

greater_than_binsearch:		; low = mid + 1
	mov a, r3 
	mov r1, a 
	inc r1 
	rjmp repeat_binsearch 
	
	
; calculate the middle position of array index 
middle_position:	
	pop 0x7f 
	pop 0x7e 
	pop b 
	pop acc 
	

	add a, b 
	mov b, #0x02 
	div ab 

	push acc 
	push 0x7e 
	push 0x7f 
	ret 