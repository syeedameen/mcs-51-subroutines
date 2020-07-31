;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          BUBBLE SORT SUBROUTINE DESCRIPTION          ;;
;;          1. PUSH BASE ADDRESS OF ARRAY               ;;
;;          2. PUSH NO. OF ELEMENTS                     ;;
;;                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;bubble sorting for maximum 16 bit counter register 

BUBBLESORT:
    POP 0X7F    ;pop return address 
    POP 0X7E 

    POP DPH     ;base address of Array 
    POP DPL 

    POP 0X35    ;counter lower and upper byte 
    POP 0X34 

    PUSH 0X7E   ;push return address  
    PUSH 0X7F 
; get subroutine data 

    MOV R0,0X34 ;get counter register     
    MOV R1,0X35 

    MOV R2,0X34 
    MOV R3,0X35 
    

    MOV 0X33,DPH ;store datapointer 
    MOV 0X32,DPL 


;here repeating steps 
REPEAT2_BUBBLESORT:
    MOVX A,@DPTR 
    MOV R5,A 
    INC DPTR

REPEAT1_BUBBLESORT:
    MOVX A,@DPTR 
    MOV R6,A 

    SUBB A,R5   ;a[i] cmp a[i+1]
    JNC NOSWAPING_BUBBLESORT
    MOV A,R6    ;JNC change acc to requirment 
    XCH A,R5   
    MOVX @DPTR,A 
    
;decrement datapointer regsiter
    MOV A,DPL   
    SUBB A,#01H 
    JNC SKIP_BUBBLESORT
    MOV A,#FFH
    DEC DPH 
SKIP_BUBBLESORT:
    MOV DPL,A 

;move r5 register form it's position     
    MOV A,R5 
    MOVX @DPRT,A 
    INC DPTR

NOSWAPING_BUBBLESORT:
    MOVX A,@DPRT
    MOV R5,A 
    INC DPTR

    DJNZ R0,REPEAT1_BUBBLESORT
    MOV R0,#FFH 
    DJNZ R1,REPEAT1_BUBBLESORT

    MOV DPH,0X33
    MOV DPL,0X32 

    MOV R0,0X34 
    MOV R1,0X35 

    DJNZ R2,REPEAT2_BUBBLESORT
    MOV R2,#FFH
    DJNZ R3,REPEAT2_BUBBLESORT
    RET     ;return subroutine data 


