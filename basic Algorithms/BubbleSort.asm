;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        BUBBLE SORT SUBROUTINE DESCRIPTION            ;;
;;          1. PUSH NO. OF ELEMENT                      ;;
;;          2. PUSH BASE ADDRESS OF ARRAY               ;;
;;                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


BUBBLESORT:
    POP 0X7F                      ;RETURN ADDRESS OF SUBROUTINE 
    POP 0X7E      

    POP DPH                       ;BASE ADDRESS OF ARRAY 
    POP DPL   
    POP ACC                       ;COUNTER 

    PUSH 0X7E                     ;PUSH RETURN ADDRESS 
    PUSH 0X7F     

    MOV R0,A                      ;TEMPORARY STORE COUNTER REG.
    MOV R1,A                      ;AND BASE ADDRESS OF ARRAY
    MOV R2,A      
    MOV R3,DPL        
    MOV R4,DPH    

REPEAT_BUBBLESORT:
    MOVX A,@DPTR                  ;MOVE A[I] INTO ACCUMULATOR 
    MOV R5,A                
    
    INC DPTR 
    MOVX A,@DPTR        
    MOV R6,A 

    SUBB A,R5 
    JNC NOTSWAP_BUBBLESORT      ;SWAP IF A[I] > A[I+1]
    MOV A,R6 
    XCH A,R5 
    MOVX @DPTR,A 
    ACALL DEC_DPTR              ;CALL DECREMENT DATA POINTER 
    MOV A,R5 
    MOVX @DPTR,A 
    INC DPTR 
NOTSWAP_BUBBLESORT:             
    DJNZ R2,REPEAT_BUBBLESORT   ;LOWER COUNTER 
    MOV A,R0 
    MOV R2,A 
    MOV DPL,R3                  ;INITILIZE DPTR WITH BASE ADDRESS 
    MOV DPH,R4                  
    DJNZ R1,REPEAT_BUBBLESORT   ;UPPER COUNTER 
    RET                         ;RETURN SUBROUITNE 

                                ;DECREMENT DATA POINTER SUBROUITNE 
DEC_DPTR:
    MOV A,DPL 
    SUBB A,#01 
    JNC SKIP_DEC_DPTR
    MOV A,#0XFF 
    DEC DPH 
SKIP_DEC_DPTR:
    MOV DPL,A 
    RET 

  
    
