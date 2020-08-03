; 4x4  Matrix keypad Subrotine  

keypad:
    row     equ 04 
    column  equ 04
        ;  register r4 (row number)
        ;  register r2 (column number)


    acall rowread_keypad
    acall columnread_keypad
    acall adjust_keypad
    pop 0x7f 
    pop 0x7e
    push acc    ;push key number into the Stack 
    push 0x7e 
    push 0x7f 
    ret 

    rowread_keypad:
        ;all column connect to groud (for Reading Rows)
        clr P0.0 
        clr P0.1
        clr P0.2
        clr P0.3
        ;check row number 
            jb P0.0,ret1_keypad
                mov r4,#00h 
                sjmp exit1_keypad
        ret1_keypad:
            jb P0.1,ret2_keypad
                mov r4,#01h 
                sjmp exit1_keypad
        ret2_keypad:
            jb P0.2,ret3_keypad
                mov r4,#02h 
                sjmp exit1_keypad
        ret3_keypad:
                mov r4,#03h 
        exit1_keypad:
        ret 

    columnread_keypad:
        ; all row connect to ground 
        clr P0.4
        clr P0.5 
        clr P0.6 
        clr P0.7 
        ; check column number 
            jb P0.4,ret4_keypad
                mov r2,#00h 
                sjmp exit2_keypad
        ret4_keypad:
            jb P0.5,ret5_keypad
                mov r2,#01h 
                sjmp exit2_keypad
        ret5_keypad:
            jb P0.6,ret6_keypad 
                mov r2,#02h 
                sjmp exit2_keypad
        ret6_keypad:
                mov r2,#03h 
        exit2_keypad:
        ret 

    adjust_keypad:
    ; ((row * scaler vector)+column)
        mov b,#column
        mov a,r4    ;row number
        mul ab      ;multiply by 4
        add a,r2    ;add column number 
        ret 
