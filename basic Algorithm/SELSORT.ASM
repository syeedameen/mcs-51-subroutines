;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       SELECTION SORT SUBROUTINE DESCRIPTION          ;;
;;          1. PUSH BASE ADDRESS OF ARRAY               ;;
;;          2. PUSH NO. OF ELEMENTS                     ;;
;;                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  

SELSORT:
;-----------------INITILIZATION----------------------------------
    POP 0X7F                        ;RETURN ADDRESS OF SUBROUTINE 
    POP 0X7E                        
    POP ACC                         ;COUNTER 
    PUSH 0X7E                       
    PUSH 0X7F                       ;PUSH RETURN ADDRESS OF SUBROUITNE 
 
    MOV R1,DPL                      ;LOWER DPTR BYTE 
    MOV R2,DPH                      ;HIGHER DPTR BYTE

    MOV R3,DPL                      ;INITIAL DATA POINTER LOWER 
    MOV R4,DPH                      ;INITIAL DATA POINTER HIGHER  
    
    MOV 0X35,A                      ;LOWER COUNTER 
    MOV 0X36,A                      ;UPPER COUNTER 

    MOV A,#00
    MOV R0,A                        ;CLEAR R0 REGISTER 
;------------------INITILIZATION DONE-------------------------------


REPEAT2_SELSORT:  
    MOV A,R0  
    SUBB A,0X36
    JZ SKIP1_SELSORT                ;REPEAT UNTIL R0 == COUNTER(0X35)
    
    MOV A,R0                        ;CALL SUBROUTINE TO GET (DPTR+ACCUMULATOR) 
    PUSH DPL 
    PUSH DPH 
    PUSH ACC 
    ACALL ADDDPRT_SELSORT
    POP DPH 
    POP DPL 
    
    MOVX A,@DPTR                    
    MOV R5,A                        ;GET *(DPTR + ACCUMULATOR) INTO R5 
    MOV DPL,R3                      ;MOVE INITIAL DATA POINTER VALUE 
    MOV DPH,R4

REPEAT1_SELSORT:
    MOVX A,@DPTR                    ;COMPARE R5 WITH ENTIRE LIST OF ELEMENT (AND SWAP IF REQUIRED)
    MOV R6,A 
    SUBB A,R5 
    JNC NOSWAP_SELSORT
    MOV A,R6 
    XCH A,R5 
    MOVX @DPTR,A 
    
    MOV A,R0                        ;CALL SUBROUTINE TO GET (DPTR + ACCUMULATOR)
    PUSH DPL 
    PUSH DPH 
    PUSH ACC 
    ACALL ADDDPRT_SELSORT
    POP DPH 
    POP DPL 

    MOV A,R5 
    MOVX @DPTR,A 

    MOV DPL,R1                       ;MOVE INITIAL DATA POINTER 
    MOV DPH,R2
NOSWAP_SELSORT:
    INC DPTR 
    MOV R1,DPL 
    MOV R2,DPH 
    DJNZ 0X35,REPEAT1_SELSORT
    INC R0 
    AJMP REPEAT2_SELSORT

SKIP1_SELSORT:
    RET 

;---------------------------SUBROUTINE FUNCTION OF SELSORT---------------------

; SUBROUTINE TO PERFORM (DPTR + ACCUMULATOR)
ADDDPRT_SELSORT:
    POP 0X7F 
    POP 0X7E 
    
    POP 0X38 
    POP 0X37 
    POP ACC 

    ADD A,0X37
    JNC SKIP_ADDDPTR_SELSORT
    INC 0X38 
SKIP_ADDDPTR_SELSORT:
    MOV 0X37,A 

    PUSH 0X37 
    PUSH 0X38 
    PUSH 0X7E 
    PUSH 0X7F 
    RET 


; SUBROUTINE TO PERFORM (DPTR - ACCUMULATOR)
DECDPTR_SELSORT:
    POP 0X7F                            ;RETURN ADD. OF SUBROUTINE 
    POP 0X7E 
    
    POP 0X38                            ;DATA POINTER 
    POP 0X37    
    POP 0X39                            ;ACCUMULATOR 

    MOV A,0X37                          ;MOV DPL INTO ACCUMULATOR 
    SUBB A,0X39                         ;PERFORM (DPL - ACCUMULATOR)
    JNC SKIP_DECDPTR_SELSORT            
    DEC 0X37                            ;IF CARRY DECREMENT DPH BYTE 
SKIP_DECDPTR_SELSORT:
    MOV 0X37,A 

    PUSH 0X37 
    PUSH 0X38 
    PUSH 0X7E 
    PUSH 0X7F 
    RET 
    
