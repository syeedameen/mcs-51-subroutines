
bubblesort:
    pop 0x7f    ;return address of Subroutine 
    pop 0x7e 
    pop dph     ;base address of Array 
    pop dpl 
    pop 0x35    ;16 bit counter 
    pop 0x34 
    push 0x7e   ;push return Address 
    push 0x7f 

    mov r2,dpl  ;temp save data pointer 
    mov r3,dph

    mov r4,0x34 ;lower counter 
    mov r5,0x35 

    mov r0,0x34 ;upper counter 
    mov r1,0x35 

repeat_bubblesort:
    movx a,@dptr 
    mov r6,a 
    inc dptr 
    movx a,@dptr 
    mov r7,a 

    subb a,r6 
    jnc notswap_bubblesort
        mov a,r7 
        xch a,r6 
        movx @dptr,a 
                     ; decrement Data pointer (start) 
        mov a,dpl 
        subb a,#01h 
        jnc skip1_bubblesort
            dec dph 
            mov a,#ffh 
    skip1_bubblesort:
        mov dpl,a 
                    ; decrement data pointer (end)
        mov a,r6 
        movx @dptr,a 
        inc dptr 
notswap_bubblesort:
    djnz r4,repeat_bubblesort
        mov r4,#ffh 
    djnz r5,repeat_bubblesort
        
        mov dpl,r2 
        mov dph,r3 
        mov r4,0x34 
        mov r5,0x35 
    djnz r0,repeat_bubblesort
        mov r0,#ffh 
    djnz r1,repeat_bubblesort
        ret         ; return Bubble sort Subroutine 


