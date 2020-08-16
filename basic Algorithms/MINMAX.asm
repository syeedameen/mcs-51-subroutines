;Program to findout minimum or maximum number in the given Array

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          DESCRIPTION            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
;;  1. push base addr. of array    ;;
;;  2. no. of element in array     ;;
;;  3. flag variable               ;;
;;  4. if flag == 1                ;;
;;          find maximum           ;;
;;      else                       ;;
;;          find minimum           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MINMAX:
    POP 0X7F 
    POP 0X7E 

    POP DPH     ;base address of Array
    POP DPL 
    
    POP ACC     
    MOV R0,A    ;if R0 = 0 min
    POP ACC     ;if R0 = 1 max
    MOV R1,A    ;number of ele in A[]
    
    PUSH 0X7E 
    PUSH 0X7F 
 
    
    CJNE R0,#01H,FINDMIN_MINMAX
    ;start maxi no. findout function 
    MOVX A,@DPTR 
    INC DPTR
    MOV R2,A 
REPEAT1_MINMAX:
    MOVX A,@DPTR
    MOV R6,A 
    SUBB A,R2 
    JC NOTSWAP1_MINMAX
    MOV A,R6 
    XCH A,R2 
NOTSWAP1_MINMAX:
    INC DPTR 
    DJNZ R1,REPEAT1_MINMAX
    
    POP 0X7F 
    POP 0X7E 

    MOV A,R2 
    PUSH ACC 
    
    PUSH 0X7E 
    PUSH 0X7F 
    RET

FINDMIN_MINMAX:
    ; start minimum number findout function 
    MOVX A,@DPTR 
    INC DPTR
    MOV R2,A 
REPEAT2_MINMAX:
    MOVX A,@DPTR
    MOV R6,A 
    SUBB A,R2 
    JNC NOTSWAP2_MINMAX
    MOV A,R6 
    XCH A,R2 
NOTSWAP2_MINMAX:
    INC DPTR 
    DJNZ R1,REPEAT2_MINMAX
    POP 0X7F 
    POP 0X7E 

    MOV A,R2 
    PUSH ACC 
    
    PUSH 0X7E 
    PUSH 0X7F 
    RET
    