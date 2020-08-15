; Program subrotutine to convert hexadecimal number into decimal number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          HEX2DEC SUBROUTINE DESCRIPTION           ;;
;;          1. push hexadecimal number               ;;
;;          2. return number 2 BYTE DECIMAL NUMBER   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


; check again ***###***
HEX2DEC:
    POP 0X7F        ;get return address into b reg.
    POP 0X7E 
    
    POP ACC         ;hexadecimal number for conversion 

    POP 0X7E 
    POP 0X7F        ;again push return address 

    MOV R0,A

    ANL A,#0X0F     ;get lower nibble of number
    MOV B,#0X01
    MUL AB 
    DA A
    MOV R1,A        ;dec lower nible 
    
    MOV A,R0
    ANL A,#0XF0     ;get higher nibble of number
    MOV B,#0X10
    MUL AB 
    MOV R3,A 

    ANL A,#0X0F 
    DA A 
    MOV R4,A 
    MOV A,R3
    ANL A,#0XF0 
    DA A 
    ORL A,R4 
    MOV R2,#00H

    ;addition of lower and upper nibble 
    ADD A,R1 
    DA A 
    JNC SKIP_HEX2DEC
    INC R2 
SKIP_HEX2DEC:
    ; push decimal digit  
    POP 0X7F
    POP 0X7E
    
    PUSH ACC 
    MOV A,R2 
    PUSH ACC 

    PUSH 0X7E 
    PUSH 0X7F 
    RET 
