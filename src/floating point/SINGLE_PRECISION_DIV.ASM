; SELECTION SORTING SUBROUTINE 

SELSORT:
    POP 0X7F                              ;(RETURN ADDRESS OF SUBROUTINE) POP FROM RAM LOCATION 
    POP 0X7E        
    POP DPH                               ;DATA ADDRESS OF ARRAY  
    POP DPL     
    POP ACC                               ;COUNTER REGISTER  
    PUSH 0X7E                       
    PUSH 0X7F                             ;(RETURN ADDRESS OF SUBROUTINE) PUSH INTO STACK LOCATION 
        
;EQUATE DIFFRENTS LOCATIONS         
DPTR_LOW            EQU 0X35              ;DATA POINTER LOCATION 
DPTR_HIGH           EQU 0X36              
T_DPTR_LOW          EQU 0X37              ;TEMPORARY DATA POINTER STORAGE LOCATION 
T_DPTR_HIGH         EQU 0X38        
        
        
    MOV R0,A                              
    MOV R1,A                              ;ENTIRE LIST SCANNING COUNTER REGISTER  
    MOV DPTR_LOW,DPL        
    MOV DPTR_HIGH,DPH       

LOOP_SELSORT:
    CJNE R0,#0X00,EXIT_SELSORT   
    MOVX A,@DPTR 
    MOV R5,A 
    
REPEAT_SELSORT:
    INC DPTR                        
    MOVX A,@DPTR
    MOV R6,A 

    SUBB A,R5 
    JNC NOSWAP_SELSORT
    MOV A,R6 
    XCH A,R5 
    MOVX @DPTR,A 
    MOV T_DPTR_HIGH,DPH 
    MOV T_DPTR_LOW,DPL                      ;TEMP STORE DATA POINTER REG. 


    MOV DPL,DPTR_LOW                        ;LOAD INITIAL DATA POINTER FOR A[I]
    MOV DPH,DPTR_HIGH
    MOV A,R5            
    MOVX @DPTR,A                            ;MOVE AT DATA POINTER LOCATION 

    MOV DPL,T_DPTR_LOW
    MOV DPH,T_DPTR_HIGH
NOSWAP_SELSORT:
    DJNZ R1,REPEAT_SELSORT                  ;RUN COUNTER REGSITER 
    DEC R0                                  ;DECREMENT INDEX REG. 
    
    MOV DPL,DPTR_LOW
    MOV DPH,DPTR_HIGH
    INC DPTR                                ;INCREMENT KEY ELEMENT DATA  POINTER REGISTER  
    MOV DPTR_HIGH,DPH 
    MOV DPTR_LOW,DPL

    SJMP LOOP_SELSORT                       ;SHORT JUMP (RELATIVE JUMP)
EXIT_SELSORT:
    RET 




;MOVE DATA POINTER FOR REGISTER ADDRESSABLE 
    DATA_TRANSFER:
        MOVX A,@DPTR 
        MOV R4,A 
        INC DPTR 
        MOVX A,@DPTR 
        ADD A,R4 
        JNC D

bubblesort:
    pop 0x7f                    ;return address of subroutine 
    pop 0x7e 
    pop dph                     ;base address of array
    pop dpl     
    pop acc                     ;counter register 
    push 0x7e 
    push 0x7f 

    mov r0,a 
    mov r1,a 
    mov r2,a 
    mov r3,dpl 
    mov r4,dph 

    movx a,@dptr 
    mov r5,a 
    inc dptr 

    movx a,@dptr 
    mov r6,a 
    subb a,r5 
    jnc notswap_bubblesort
        mov a,r6 
        xch a,r5 
        movx @dptr,a 

        mov a,dpl 
        subb a,#0x01 
        jnc skip1_bubblesort
            mov a,#0xff 
            dec dph 
        skip1_bubblesort:
        mov dpl,a 

        mov a,r5 
        movx @dptr,a 
        inc dptr 
notswap_bubblesort:
    djnz r2,repeat_bubblesort
    mov a,r0 
    mov r2,a 
    mov dpl,r3                      ;restore data pointer regisister 
    mov pdh,r4 
    djnz r1,repeat_bubblesort
    ret                             ;return subroutine 
