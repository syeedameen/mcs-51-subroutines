; SUBROUTINE TO MULTIPLY (IEEE-754) PRECISION NUMBERS AND RETURN RESULT         DATE:   24-08-2020
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
SNGLPRE:
    MANTISSA_BYTE1       EQU 0X25               ;EQUATE MANTISSA BYTE INTO BIT ADDRESSABLE REGION
    MANTISSA_BYTE2       EQU 0X26 
    MANTISSA_BYTE3       EQU 0X27
    FLAG_BIT1            EQU 0X27^0             ;NUMBER 1 FLAG BIT 
    FLAG_BIT2            EQU 0X27^1             ;NUMBER 2 FLAG BIT 
    EXPONENT_NUM1        EQU 0X48               ;NUMBER 1 EXPONENT MEMORY LOCATION 
    EXPONENT_NUM2        EQU 0X47               ;NUMBER 2 EXPONENT MEMORY LOCATION 
    HIGHER_EXP_FLAG      EQU 0X27^2             ;HIGHER EXP BIT FLAG (0=FOR NUM 1, 1=FOR NUB 2)
       


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

    ACALL ADDEXP_SNGLPRE                   ;ABSOLUTE CALL DIFFRENT SUBROUITNES 
    ACALL MULMANTISSA_SNGLPRE
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

;---------------------------------EXPONENT ADDITION SUBROUTINE-----------------------------------------;
;   1.  RESULTANT EXPONENT PUT INOT R0 REGISTER                                                        ; 
;   2.  SIGN FLAGS ARE STORE INTO FLAG BITS                                                            ;
;------------------------------------------------------------------------------------------------------;                                             
ADDEXP_SNGLPRE:
    MOV A,0X60                                  ;MOVE FIRST NUMBER EXPONENT INTO R0 REGISTER 
    MOV R0,A                                    
    CLR C                                       ;CLEAR CARRY BEFORE ROTATION 
    RLC A                                       
    JNC NOCARRY1_ADDEXP_SNGLPRE                 
        SETB FLAG_BIT1                          ;SET FLAG BIT THAT SHOW (SIGN BIT)  
    NOCARRY1_ADDEXP_SNGLPRE:
    MOV R0,A                                    ;R0 REGISTER CONTAIN (FIRST NUMBER EXPONENT)

    MOV A,0X59 
    CLR C 
    RLC A
    JNC SKIP1_ADDEXP_SNGLPRE
        MOV A,R0                                ;IF BIT IS SET (SET ACCUMULATOR BIT 0)
        SETB ACCUMULATOR^0 
    SKIP1_ADDEXP_SNGLPRE:

    MOV A,0X56                                  ;MOVE SECOND NUMBER EXPONENT INTO R1 REGISTER 
    MOV R1,A                                    
    CLR C                                       
    RLC A                                       ;ROTATE LEFT TO CHECK SIGN BIT     
    JNC NOCARRY2_ADDEXP_SNGLPRE 
        SETB FLAG_BIT2                          ;SET FLAG BIT THAT SHOW (SIGN BIT)
    NOCARRY2_ADDEXP_SNGLPRE:
    MOV R1,A                                    ;R1 REGISTER CONTAIN (SECOND NUMBER EXPONENT)

    MOV A,0X55 
    CLR C 
    RLC A 
    JNC SKIP2_ADDEXP_SNGLPRE
        MOV A,R1 
        SETB ACCUMULATOR^0
    SKIP2_ADDEXP_SNGLPRE:
    

    MOV A,R0                                    ;SUBTRACT 127 (EXPONENT BAIS)
    SUBB A,#127 
    MOV R0,A 

    MOV A,R1                                    ;SUBTRACT 127 (EXPONENT BAIS)
    SUBB A,#127 
    MOV R1,A 


    MOV R0,A 
    ADD A,R1 
    ADD A,#127
    MOV R0,A                                    ;R0 REG. CONTAIN RESULT EXPONENT 
    RET                                         ;RETURN EXPONENT ADDITION SUBROUTINE 
;------------------------------------------------------------------------------------------------------------;

;---------------------------------MANTISSA MULTIPLICATION SUBROUTINE-----------------------------------------;
;   1.
;


MULMANTISSA_SNGLPRE:
    MOV MANTISSA_BYTE1,0X    

