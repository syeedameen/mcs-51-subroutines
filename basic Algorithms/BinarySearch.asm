;               BINARY SEARCH


; Error (To Create lo <= hi)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;      ALGORITHM           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Binarysearch(A,n,key)  ;;
;;   lo := 0                ;;
;;   hi := n                ;;
;;   mid := (lo+hi)/2       ;;
;;                          ;;
;;   while(lo <= hi)        ;;
;;      if a[mid] == key    ;;
;;          return mid      ;;
;;      if a[mid] < key     ;;
;;          lo := mid+1     ;;
;;      if a[mid] > key     ;;
;;          hi := mid-1     ;;
;;      mid = (lo+hi)/2     ;;
;;  search is not sucsessful;;
;;  exit                    ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          DISCRYPTION OF ALGORITHM    ;;
;;  1. push the index address           ;;
;;  2. push number of elements          ;;  
;;  3. push key element                 ;;
;;                                      ;;
;;                                      ;;    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



BINSEARCH:  
    POP 0X7F 
    POP 0X7E 

    POP DPH     ;Base Addr. of Array  
    POP DPL 

    POP ACC     ;key element in r0 reg.
    MOV R0,A 

    POP ACC     ;no. of element 
    MOV R1,A 

    PUSH 0X7E 
    PUSH 0X7F 


    MOV R2,DPL  ;save datapointer reg.
    MOV R3,DPH 

    MOV R4,#0X00 ;define lo: and hi:
    MOV R5,A 

    ; First calculating mid for calling subroutine 

    MOV A,R4    ;push lo: & hi: for mid cal
    PUSH ACC 
    MOV A,R5 
    PUSH ACC

    ACALL MIDCAL_BINSEARCH     
    POP ACC     ;get mid into Accumulator
    MOV R6,A    ;temp store mid 
    
    ; check lo: <= hi:   
    ; if condition false searching is unsuccessful
    ; return 0x0000 address that is elemet not found 
START_BINSEARCH:
    MOV A,R4    ;mov acc = lo:
    SUBB A,R5   ;test lo: with hi:
    JC REPEAT_BINSEARCH
    MOV A,R4    ;jump if lo: = hi:
    SUBB A,R5 
    JZ REPEAT_BINSEARCH
    POP 0X7F 
    POP 0X7E 
    MOV A,#0X00
    PUSH ACC
    PUSH ACC
    PUSH 0X7E 
    PUSH 0X7F  
    RET

REPEAT_BINSEARCH:
    MOV A,R6 
    MOVC A,@A+DPTR  ;Mov a <-- a[mid+base Addr.] 
    MOV R7,A    ;temp store a[mid]
    SUBB A,R0      ;Compare with key element 
    JNZ NOTFOUND_BINSSEARCH
;if key element is equal (Search is Sucessfull)
    POP 0X7F 
    POP 0X7E 

    MOV A,R6    ;add mid into datapointer
    ADD A,DPL
    JNC SKIP_BINSEARCH ;if c=1 inc dph 
    INC DPH
SKIP_BINSEARCH:
    ; push addr. of key and return subroutine  
    PUSH DPL
    PUSH DPH
    PUSH 0X7E 
    PUSH 0X7F 
    RET 

;if element is not found 
NOTFOUND_BINSSEARCH:
    MOV A,R7    ;move a[mid] 
    SUBB A,R0   ;compare a[mid] with key element 
    JNC GREATER_BINSEARCH
    INC R6      ;increment mid 
    MOV A,R6 
    MOV R4,A    ;move lo: = mid +1

    MOV A,R4
    PUSH ACC 
    MOV A,R5 
    PUSH ACC
    POP ACC     ;get mid into Accumulator
    MOV R6,A    ;temp store mid 
    AJMP START_BINSEARCH

;a[mid] is greater a[mid] > key 
GREATER_BINSEARCH:
    DEC R6      ;decrement mid  
    MOV A,R6 
    MOV R5,A    ;mov hi: = mid -1


    MOV A,R4
    PUSH ACC 
    MOV A,R5 
    PUSH ACC

    ACALL MIDCAL_BINSEARCH
    POP ACC     ;get mid into Accumulator
    MOV R6,A    ;temp store mid 
    AJMP START_BINSEARCH

; Mid calculation subroutine 
MIDCAL_BINSEARCH:
    POP 0X7F 
    POP 0X7E 

    POP ACC 
    MOV 0X5F,A 
    POP ACC 

    
    ADD A,0X5F 
    MOV B,#0X02
    DIV AB  ;(low + high)/2 

    PUSH ACC 
    PUSH 0X7E
    PUSH 0X7F
    RET 


