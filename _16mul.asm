

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;      16 bit Multiplcation    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_16mul:
    pop 0x7f 
    pop 0x7e 
    pop 0x35    ;multiplicand 
    pop 0x34 
    pop 0x33    ;multiplier 
    pop 0x32 
    push 0x7e 
    push 0x7f

    setb psw^3  ;switch register bank 
    mov a,0x32 
    mov b,0x34 
    mul ab 
    mov r4,a 
    mov r5,b 
    mov a,0x32 
    mov b,0x35 
    mul ab 
    mov r6,a 
    mov r7,b 

    mov a,0x33 
    mov b,0x34 
    mul ab 
    mov r0,a 
    mov r1,b 
    mov a,0x33
    mov b,0x35 
    mul ab 
    mov r2,a 
    mov r3,b 

    mov 0x40    ;counter register 
    mov b,#0x0a ;10 in hex 
    mov a,r0    ;higher order word multiplied by 10 
    mul ab 
    push acc
    inc 0x40  
    mov a,b 
    cjne a,#0x00,skip1_16mul
        sjmp notswap1_16mul
skip1_16mul:
    push acc 
    inc 0x40
notswap1_16mul:
    mov a,r1 
    mov b,#0x0a 
    mul ab 
    push acc
    inc 0x40
    mov a,b 
    cjne a,#0x00,skip2_16mul
        sjmp notswap2_16mul
skip2_16mul:
    push acc 
    inc 0x40
notswap2_16mul:
    mov a,r2 
    mov b,#0x0a 
    mul ab 
    push acc 
    inc 0x40 
    mov a,b 
    cjne a,#0x00,skip3_16mul
        sjmp notswap3_16mul
skip3_16mul:
    push acc  
    inc 0x40
notswap3_16mul:
    mov a,r3 
    mov b,#0x0a 
    mul ab 
    push acc 
    inc 0x40 
    mov a,b 
    cjne a,#0x00,skip4_16mul
        sjmp notswap4_16mul
skip4_16mul:
    push acc 
    inc 0x40
notswap4_16mul:



                    ;higher order word multiplied by 10
                    ;using x*(8+2)
                    ;shift by 3 and add in 1 shift 

    mov a,r0 
    clr c 
    rlc a 
    jc increment_datapoi