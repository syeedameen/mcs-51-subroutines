;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       SELECTION SORT SUBROUTINE DESCRIPTION          ;;
;;          1. PUSH NO. OF ELEMENTS IN STACK            ;;
;;          2. PUSH BASE ADDRESS OF ARRAY               ;;
;;                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  

SELSORT:
;-----------------INITILIZATION----------------------------------
    POP 0X7F                        ;RETURN ADDRESS OF SUBROUTINE 
    POP 0X7E 
    POP DPH                         ;BASE ADDRESS OF ARRAY  
    POP DPL
    POP ACC                         ;COUNTER 
    PUSH 0X7E                       
    PUSH 0X7F                       ;PUSH RETURN ADDRESS OF SUBROUITNE 
 
    MOV R1,DPL                      ;LOWER DPTR BYTE 
    MOV R2,DPH                      ;HIGHER DPTR BYTE

    MOV R3,DPL                      ;INITIAL DATA POINTER LOWER 
    MOV R4,DPH                      ;INITIAL DATA POINTER HIGHER  
    
    MOV 0X35,A                      ;LOWER COUNTER 
    MOV 0X36,A                      ;REGISTER FOR STORE COMPARE VALUE 

    MOV A,#00
    MOV R0,A                        ;INDEX REGISTER  
;------------------INITILIZATION DONE-------------------------------


REPEAT2_SELSORT:  
    MOV A,R0  
    SUBB A,0X36
    JZ SKIP1_SELSORT                ;REPEAT UNTIL R0 == COUNTER(0X35)
    
    MOV A,R0                        ;CALL SUBROUTINE TO GET (DPTR+ACCUMULATOR) 
    ACALL ADDDPRT_SELSORT
   
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
    ACALL ADDDPRT_SELSORT
    MOV A,R5 
    MOVX @DPTR,A 

    MOV DPL,R3                       ;MOVE INITIAL DATA POINTER 
    MOV DPH,R4
NOSWAP_SELSORT:
    INC DPTR 
    DJNZ 0X35,REPEAT1_SELSORT       
    INC R0                          ;INCREMENT INDEX REGISTER 
    MOV DPL,R1          
    MOV DPH,R2
    MOV A,R0 
    ACALL ADDDPRT_SELSORT           ;INCREMENT DATA POINTER UPTO INDEX REG.
    INC DPTR                        ;POINT NEXT LOCATION 
    MOV R3,DPL                      
    MOV R4,DPH                      ;DPTR SAVE INTO ARRAY POINTER REGISTER 
    MOV DPL,R1              
    MOV DPH,R2                      ;LOAD DPTR TO ARRAY BASE LOCATION 
    SJMP REPEAT2_SELSORT

SKIP1_SELSORT:
    RET 

;---------------------------SUBROUTINE FUNCTION OF SELSORT---------------------

; SUBROUTINE TO PERFORM (DPTR + ACCUMULATOR)
ADDDPRT_SELSORT:
    MOV R7,A                       
    MOV A,DPL 
    ADD A,R7                        ;IF CARRY INCREMENT HIGHER BYTE OF DATA POINTER 
    JNC SKIP_ADDDPTR_SELSORT
    INC DPH  
SKIP_ADDDPTR_SELSORT:
    MOV DPL,A                       ;LOAD INTO DPL REGISTER BYTE 
    RET
