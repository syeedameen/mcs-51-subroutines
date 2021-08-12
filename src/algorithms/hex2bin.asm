;-----------------------------------------------------------------------------;
;   Program subrotutine to convert hexadecimal number into decimal number     ;
;-----------------------------------------------------------------------------;
;                      HEX2DEC SUBROUTINE DESCRIPTION                         ;
;                      1. push 32-bit hexadecimal number                      ;
;                      2. return (5 BYTE DECIMAL DIGIT)                       ;
;-----------------------------------------------------------------------------; 
HEX2DEC4:
    POP 0X7F 
    POP 0X7E 
    POP ACC 
    MOV R3, A 
    POP ACC 
    MOV R2, A 
    POP ACC 
    MOV R1, A 
    POP ACC 
    MOV R0, A 
    PUSH 0X7E 
    PUSH 0X7F 

    MOV R4, #0x00       ; CLEAR MOST SIGNIFICANT DIGIT CARRY 

    ACALL HEX2DEC2
    MOV R0, A           ; GET LOWER BYTE INTO R0 REGISTER 

    MOV A, R1           
    ADD A, B 
    ACALL HEX2DEC2
    MOV R1, A           ; GET SECOND LOWER BYTE 

    MOV A, R2
    ADD A, B 
    ACALL HEX2DEC2
    MOV R2, A           ; GET THIRD LOWER BYTE 

    MOV A, R3 
    ADD A, B 
    ACALL HEX2DEC2
    MOV R3, A           ; GET HIGHER BYTE 
    JNC SKIP_HEX2DEC4 
        INC R4 
    SKIP_HEX2DEC4:
    

    POP 0x7F 
    POP 0x7E 
    
    MOV A, R0 
    PUSH ACC 
    MOV A, R1 
    PUSH ACC 
    MOV A, R2 
    PUSH ACC 
    MOV A, R3
    PUSH ACC 
    MOV A, R4 
    PUSH ACC 
    
    PUSH 0x7E 
    PUSH 0x7F 
    RET     

;-----------------------------------------------------------------------------;
;                 1-BYTE DIGIT HEX TO BCD CONVERSION SUBROUTINE               ;
;                      1. store hexadecimal digit into accumulator            ;
;                      2. return (1 BYTE DECIMAL DIGIT) carry in B reg        ;
;-----------------------------------------------------------------------------; 
HEX2DEC2:
    ; USED REGISTERS R7, R6, B 
    ; CARRY STORE INTO B REG
    MOV B, #0x00        ; CLEAR B REGISTER 
    MOV R7, A           ; TEMPORARY STORE RESULT INTO R7 REGISTER 

    ANL A, #0x0F        ; GET LOWER ORDER BYTE 
    ADD A, #0x00 
    DA A 
    MOV R6, A           ; MOVE LOWER ORDER BYTE INTO R6 REG 

    MOV A, R7  
    ANL A, #0xF0 
    ADD A, #0x00 
    DA A 
    ADDC A, R6          ; ADD LOWER & HIGHER ORDER BYTE 
    JNC SKIP_HEX2DEC2
        MOV B, #0x01   ; IF CARRY STORE INTO B REG 
    SKIP_HEX2DEC2:
    RET 