	
; delay n number of microsecond if frequency is 12 MHZ 
; microcontroller requied  12 clock cycle to execute 1 instruction 
; to delay 1 microsecond require execute n * 1000 instruction 

; maximum delay is 256 microsecond to perform these subroutine



DELAYMICRO:
		POP 0XF0
		POP 0XE0		;move number of usec dealy number
		POP 0XF0		;push return address of delaymicro subroutine
		MOV R1,A		;move n into Accumulator register
DELAYMICRO_MAIN:
		MOV R2,#250		
		MOV R3,#250
		
DELAYMICRO_1:
		DJNZ R3,DELAYMICRO_1
DELAYMICRO_2:
		DJNZ R2,DELAYMICRO_2
		
		DJNZ R1,DELAYMICRO_MAIN	
		