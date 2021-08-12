;------------------------------------------------------;
;      Subroutine to calculate Avrage of a Array       ;
;------------------------------------------------------;

; error division of 16 bit register

ARRAYAVG:
    POP 0X7F 
    POP 0X7E 

    POP DPH                 ; base address of Array 
    POP DPL                 
    POP ACC                 
    MOV R0,A                ; Number of element in Array 
    MOV B,A                 ; division frequncy
    
    PUSH 0X7E 
    PUSH 0X7F 

    MOVX A,@DPTR 
    INC DPTR 
    MOV R5,A 

REPEAT_ARRAYAVG:
    MOVX A,@DPTR 
    INC DPTR 
    ADD A,R5 
    JNC SKIP1_ARRAYAVG
    INC R6
SKIP1_ARRAYAVG:
    MOV R5,A 
    DJNZ R0,REPEAT_ARRAYAVG
    ; now divided by frequency of number 
    MOV A,R5 
    DIV AB 
    MOV A,R5 
    
    POP 0X7F 
    POP 0X7E 

    PUSH ACC                  ; division  
    PUSH B                    ; reminder 

    PUSH 0X7F 
    PUSH 0X7F  
    RET 

