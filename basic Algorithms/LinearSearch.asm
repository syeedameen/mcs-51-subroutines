;------------------------------------------------------------------;
;		 			LINEAR SEARCH 								   ;
;------------------------------------------------------------------;
LINEARSEARCH:
	POP 0X7F 	;RET ADDRESS OF SUBROUTINE 
	POP 0X7E 

	POP DPH		;base address of array  
	POP DPL
	POP ACC		;key element
	POP 0X35 	;16-BIT COUNTER 	
	POP 0X34

	PUSH 0X7E 
	PUSH 0X7F 	
	
	MOV R0,A		;searching element into r0 register
	MOV R1,0X34 
	MOV R2,0X35 

REPEAT_LINEARSEARCH:	
	MOVX A,@DPTR 
	INC DPTR 
	CJNE A,R0,NOTEQUAL_LINEARSEARCH
	POP 0X7F 
	POP 0X7E 
	POP DPL 
	POP DPH 
	PUSH 0X7E 
	PUSH 0X7F 
	RET 
	NOTEQUAL_LINEARSEARCH:
		DJNZ R1,REPEAT_LINEARSEARCH
		MOV R1,#0XFF 
	DJNZ R2,REPEAT_LINEARSEARCH
	POP 0X7F 
	POP 0X7E 
	MOV A,#0X00 
	PUSH ACC 	; if key is not found return 0 
	PUSH ACC 
	PUSH 0X7E 
	PUSH 0X7F 
	RET 

	
