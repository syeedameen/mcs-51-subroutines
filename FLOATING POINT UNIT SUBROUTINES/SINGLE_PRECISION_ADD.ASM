; SUBROUTINE TO ADD/SUBTRACT (IEEE-754) PRECISION NUMBERS AND RETURN RESULT         DATE:   22-08-2020
; BY SYEED MOHD AMEEN 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      SUBROUTINE DESCRIPTION                          ;;
;-----------------------------------------------------------------------;;
;; 1. PUSH FIRST NUMBER                                                 ;;
;; 2. PUSH SECOND NUMBER                                                ;;
;;----------------------------------------------------------------------;;
;;         -------------------------------------------------------      ;;
;;        |SIGN BIT|   EXPONENET  |          MANTISSA             |     ;;
;;         -------------------------------------------------------      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-------------------MAIN SUBROUTINE---------------------------------------
SINGLEPRE:
    MANTISSA_BYTE1       EQU 0X25               ;EQUATE MANTISSA BYTE INTO BIT ADDRESSABLE REGION
    MANTISSA_BYTE2       EQU 0X26 
    MANTISSA_BYTE3       EQU 0X27
    FLAG_BIT1            EQU 0X27^0             ;NUMBER 1 FLAG BIT 
    FLAG_BIT2            EQU 0X27^1             ;NUMBER 2 FLAG BIT 
    EXPONENT_NUM1        EQU 0X48               ;NUMBER 1 EXPONENT MEMORY LOCATION 
    EXPONENT_NUM2        EQU 0X47               ;NUMBER 2 EXPONENT MEMORY LOCATION 
       


    POP 0X7F                                     ;RETURN ADDRESS OF SUBROUTINE 
    POP 0X7E                         
            
    POP 0X60                                     ;FIRST NUMBER 
    POP 0X59                         
    POP 0X58                     
    POP 0X57                     
            
    POP 0X56                                     ;SECOND NUMBER 
    POP 0X55                     
    POP 0X54                     
    POP 0X53                     
                
    PUSH 0X7E                                    ;PUSH SUBROUTINE RETURN ADDRESS 
    PUSH 0X7F 

    ACALL CHECK_FLAG_SINGLEPRE                   ;ABSOLUTE CALL DIFFRENT SUBROUITNES 
    ACALL ADJSUT_EXP_SINGLEPRE
    ACALL ADD_SINGLEPRE
    ACALL RELEXLIZATION_SINGLEPRE

    POP 0X7F 
    POP 0X7E 

    MOV A,0X49                                    ;PUSH RESULT 
    PUSH ACC                     
    MOV A,0X50                   
    PUSH ACC                     
    MOV A,0X51                    
    PUSH ACC                     
    MOV A,0X52                     
    PUSH ACC                     
            
    PUSH 0X7E                                    ;PUSH RETURN ADDRESS 
    PUSH 0X7F 
    RET 
;----------------------------------------------------------------------


;------------------CHECK SIGN SUBROUTINES----------------------;
;   1.REGISTER R7       SIGN FLAG FOR NUMBER 1                 ;
;   2.REGISTER R6       SIGN FLAG FOR NUBMER 2                 ;
;--------------------------------------------------------------;


;-----R7 REG. CONTAIN (0 OR 1) ACCORDING TO SIGN CONDITION------  
CHECK_FLAG_SINGLEPRE:
    CLR FLAG_BIT1                               ;CLEAR SIGN FLAG BIT
    CLR FLAG_BIT2

    MOV A,0X60                                  ;MOVE MSB BYTE INTO ACCUMULATOR
    JNB PSW^7,SKIP1_CHECK_FLAG_SINGLEORE        ;JUMP IF {MSB NOT SET (NUMBER +VE)} OTHERWISE -VE 
    SETB FLAG_BIT1                              ;SET SIGN FLAG BIT  
    SKIP1_CHECK_FLAG_SINGLEORE:


;-----R6 REG. CONTAIN (0 OR 1) ACCORDING TO SIGN CONDITION------

    MOV A,0X56                                  ;MOVE MSB BYTE INTO ACCUMULATOR 
    JNB PSW^7,SKIP2_CHECK_FLAG_SINGLEORE        ;JUMP IF {MSB NOT SET (NUMBER +VE)} OTHERWISE -VE 
    SETB FLAG_BIT2                              ;SET SIGN FLAG BIT 
SKIP2_CHECK_FLAG_SINGLEORE:                     
    RET                                         ;RETURN SUBROUTINE 

;-------------ADJUST EXPONENET SUBROUTINE------------------------;
;   1.EXPONENT STORE INTO R1,R0 REGISTERS                        ;
;   2.THOSE WHO ARE SMALLER EXPONENT EQUATE WITH LARGER          ;
;     BY RIGHT SHIFTING MANTISSA N BIT                           ;
;----------------------------------------------------------------;

ADJSUT_EXP_SINGLEPRE:
    MOV R1,0X60                                 ;FIRST NUMBER EXPONENT WITH SIGN BIT  
    MOV R0,0X56                                 ;SECOND NUMBER EXPONENT WITH SIGN BIT 

;-----------------MASKING FOR FIRST NUMBER EXPONENT-------------------
    MOV A,R1                                                                
    CLR C                                       ;CLEAR CARRY FLAG BEFORE ROTATION (1 BIT LEFT) 
    RLC A                                       ;ROTATE LEFT (DECABLE LSB BIT OF EXPONENT) 
    MOV R1,A                                    

    MOV A,0X59                                  ;NEXT BYTE WHERE EXPONENT LBS STORE 
    ANL A,#0X80                                 ;MASKING (ONLY MSB BIT IS ENABLE)
    XRL A,R1                                    ;XOR WITH R1 REGISTER CONATAIN
    MOV EXPONENT_NUM1,A                         ;FIRST NUMBER EXPONENT STORE INTO DIRECT MEMORY LOCATION  
;-----------------MASKING FOR SECOND NUMBER EXPONENT------------------
    MOV A,R0                                     
    CLR C                                       ;CLEAR CARRY FLAG BEFORE ROTATE LEFT THROUGH CARRAY 
    RLC A                                       
    MOV R0,A                        

    MOV A,0X55                                  
    ANL A,#0X80                                 ;MASKING (ONLY MSB BIT IS ENABLE)
    XRL A,R0 
    MOV EXPONENT_NUM2,A                         ;SECOND NUMBER EXPONENT STORE INTO DIRECT MEMORY LOCATION  

;-------------LEFT SHIFT MANTISSA FOR EXPONENT ADJUST------------------


;****************SHIFT LEFT FIRST NUM MANTISSA************************

    MOV R2,0X59                                 ;FIRST NUMBER MANTISSA STORE INTO WORKING REG.
    MOV R1,0X58
    MOV R0,0X57

    MOV MANTISSA_BYTE1,R0                       ;MANTISSA STORE INTO BIT ADDRESSABLE AREA 
    MOV MANTISSA_BYTE2,R1 
    MOV MANTISSA_BYTE3,R2 

    MOV A,R2                                    
    CLR C 
    RLC A 
    MOV MANTISSA_BYTE3,A 
    JNB MANTISSA_BYTE2^7,NO_BIT1 
    SETB MANTISSA_BYTE3^0
NO_BIT1:
    MOV A,R1
    CLR C 
    RLC A 
    MOV MANTISSA_BYTE2,A 
    JNB MANTISSA_BYTE1^7,NO_BIT2
    SETB MANTISSA_BYTE2^0
NO_BIT2:
    MOV A,R0 
    CLR C 
    RLC A 
    MOV MANTISSA_BYTE1,A 
    

    MOV 0X59,MANTISSA_BYTE3                     ;STORE MANTISSA INTO IT'S POSITION 
    MOV 0X58,MANTISSA_BYTE2
    MOV 0X57,MANTISSA_BYTE1
;******************SHIFT LEFT SECOND NUM MANTISSA************************
    MOV R2,0X55                                 ;SECOND NUMBER MANTISSA STORE INTO WORKING REG.           
    MOV R1,0X54 
    MOV R0,0X53 

    MOV MANTISSA_BYTE1,R0                       ;MANTISSA STORE INTO BIT ADDRESSABLE AREA 
    MOV MANTISSA_BYTE2,R1
    MOV MANTISSA_BYTE3,R2

    MOV A,R2 
    CLR C 
    RLC A 
    MOV MANTISSA_BYTE3,A 
    JNB MANTISSA_BYTE2^7,NO_BIT4
    SETB MANTISSA_BYTE3^0
NO_BIT4:
    MOV A,R1 
    CLR C 
    RLC A 
    MOV MANTISSA_BYTE2,A 
    JNB MANTISSA_BYTE1^7,NO_BIT5 
    SETB MANTISSA_BYTE2^0 
NO_BIT5:
    MOV A,R0 
    CLR C 
    RLC A 
    MOV MANTISSA_BYTE1,A 


    MOV 0X55,MANTISSA_BYTE3                     ;STORE MANTISSA INTO IT'S POSITION 
    MOV 0X54,MANTISSA_BYTE2
    MOV 0X53,MANTISSA_BYTE1
    
;------------------COMPARE NUMBERS EXPONENT---------------------------
    MOV R1,EXPONENT_NUM1
    MOV R0,EXPONENT_NUM2

    MOV A,R1                                    ;FIRST NUMBER EXPONENT 
    CJNE A,R0,EXPNOTEQU_ADJUST_EXP_SINGLEPRE    ;JUMP IF EXPONENT ARE NOT EQUL (AND ADJUST EQUAL EXPONENTS)
    RET                                         ;IF EQUL RETURN SUBROUTINE (NO NEED TO ADJUST EXPONENTS)

EXPNOTEQU_ADJUST_EXP_SINGLEPRE:
    SUBB A,R0                                   ;SUBTRACT FIRST EXP WITH SECOND EXP
    JNC NUM1_GTR_ADJUST_EXP_SINGLEPRE
    MOV A,R0 
    SUBB A,R1 
    MOV R3,A                                    ;FIRST NUMBER MANTISSA SHIFTING COUNTER 
;***************RIGHT SHIFT NUM 1 MANTISSA FOR ADJUST EXP*****************
    MOV R4,0X57                                 ;FIRST NUMBER MANTISSA (SHIFT 1 BIT FOR EXP RELXIZATION)
    MOV R5,0X58     
    MOV R6,0X59                                 

    MOV MANTISSA_BYTE1,R4                       ;MANTISSA MOVE INTO BIT ADDRESSABLE AREA 
    MOV MANTISSA_BYTE2,R5 
    MOV MANTISSA_BYTE3,R6 

REPEAT1_ADJUST_EXP_SINGLEPRE:
    MOV A,R4 
    CLR C 
    RRC A 
    MOV MANTISSA_BYTE1,A 
    JNB MANTISSA_BYTE2^0,NOSET_BIT1
    SETB MANTISSA_BYTE1^7 
NOSET_BIT1:
    MOV A,R5 
    CLR C 
    RRC A 
    MOV MANTISSA_BYTE2,A 
    JNB MANTISSA_BYTE3^0,NOSET_BIT2
    SETB MANTISSA_BYTE2^7 
NOSET_BIT2:
    MOV A,R6 
    CLR C 
    RRC A 
    MOV MANTISSA_BYTE3,A 
    
    MOV R4,MANTISSA_BYTE1
    MOV R5,MANTISSA_BYTE2
    MOV R6,MANTISSA_BYTE3

    DJNZ R3,REPEAT1_ADJUST_EXP_SINGLEPRE        ;REPEAT UNTIL R3 == 0
    MOV 0X57,R4                                 ;AFTER ADJUST EXPONENT MANTISSA STORE INTO IT'S POSITION 
    MOV 0X58,R5
    MOV 0X59,R6
    
    AJMP SKIP_NO_SHIFT_SECOND_MANTISSA
;**************************************************************************

;**************RIGHT SHIFT NUM 2 MANTISSA FOR ADJUST EXP*******************
NUM1_GTR_ADJUST_EXP_SINGLEPRE:
    MOV R3,A                                    ;SECOND NUMBER MANTISSA SHIFTIHNG COUNTER
    
    MOV R4,0X53                                 ;LOAD SECOND NMBER INTO GENERAL PURPOSE REG.
    MOV R5,0X54 
    MOV R6,0X55 

    MOV MANTISSA_BYTE1,R4                       ;MANTISSA STORE INTO BIT ADDRESSABLE AREA 
    MOV MANTISSA_BYTE2,R5 
    MOV MANTISSA_BYTE3,R6 

REPEAT2_ADJUST_EXP_SINGLEPRE:
    MOV A,R4            
    CLR C 
    RRC A 
    MOV MANTISSA_BYTE1,A 
    JNB MANTISSA_BYTE2^0,NOSET_BIT3
    SETB MANTISSA_BYTE1^7 
NOSET_BIT3:
    MOV A,R5 
    CLR C 
    RRC A 
    MOV MANTISSA_BYTE2,A 
    JNB MANTISSA_BYTE3^0,NOSET_BIT4
    SETB MANTISSA_BYTE2^7 
NOSET_BIT4:
    MOV A,R6 
    CLR C 
    RRC A 
    MANTISSA_BYTE3,A 
    
    MOV R4,MANTISSA_BYTE1
    MOV R5,MANTISSA_BYTE2
    MOV R6,MANTISSA_BYTE3

    DJNZ R3,REPEAT2_ADJUST_EXP_SINGLEPRE        ;REPEAT UNTIL R3 == 0 
    MOV 0X53,R4 
    MOV 0X54,R5 
    MOV 0X55,R6 

SKIP_SHIFT_MANTISSA:
    RET
;****************************************************************************


;-----------------ADDITION SINGLE PRECISION MANTISSAS------------------------;
;  1.ADD MANTISSS AND STORE INTO BIT ADDRESSABLE AREA                        ;



ADD_SINGLEPRE:  
    MOV R2,0X59                                 ;MOVE FIRST NUM MANTISSA INTO WORKING REG.
    MOV R1,0X58 
    MOV R0,0X57                                 ;LSB 

    MOV R5,0X55                                 ;MOVE SECOND NUM MANTISSA INTO WORKING RERG 
    MOV R4,0X54 
    MOV R3,0X53                                 ;LSB 

    MOV R6,#0X00                                ;CLEAR REG. FOR TURN AROUND CARRY STORE


    MOV A,R0 
    ADD A,R3
    JNC SKIP1_ADD_SINGLEPRE
    INC R1                                      ;IF CARRY INCREMENT SECOND REGISTER 
SKIP1_ADD_SINGLEPRE:
    MOV MANTISSA_BYTE1,A 
    MOV A,R1
    ADD A,R4 
    JNC SKIP2_ADD_SINGLEPRE
    INC R2 
SKIP2_ADD_SINGLEPRE:
    MOV MANTISSA_BYTE2,A 
    MOV A,R2 
    ADD A,R5 
    JNC SKIP3_ADD_SINGLEPRE
    INC R6                                      ;TURN AROUND CARRY 
SKIP3_ADD_SINGLEPRE: 
    MOV MANTISSA_BYTE3,A        
    RET                                         ;RETURN SUBROUTINE                    




;----------------------RELEXLIZATION RESULT NUMBER----------------------;
RELEXLIZATION_SINGLEPRE:
    CJNE R6,#0X00,NO_INCREMENT_EXP
    
    

NO_INCREMENT_EXP:

