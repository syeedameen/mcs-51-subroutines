
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                   Device driver for 7 Segment Display                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 
;                     --------------------------------------------------      
;     a              |  hex   BCD numebr           seg pin              |
;    ----            |--------------------------------------------------|
;   |    |  b        |                         a  b  c  d  e  f  g  dot |
; d | g  |           |--------------------------------------------------|
;    ----            |   FC        0          1  1  1  1  1  1  0  0    |  
;   |    |  c        |   60        1          0  1  1  0  0  0  0  0    |
; e |    |           |   DA        2          1  1  0  1  1  0  1  0    |
;    ----  DOT       |   EA        3          1  1  1  0  1  0  1  0    |
;      d             |   66        4          0  1  1  0  0  1  1  0    |
;                    |   B6        5          1  0  1  1  0  1  1  0    |
;                    |   BE        6          1  0  1  1  1  1  1  0    |
;                    |   E0        7          1  1  1  0  0  0  0  0    |
;                    |   FE        8          1  1  1  1  1  1  1  1    |
;                    |   F6        9          1  1  1  1  0  1  1  0    |
;                     --------------------------------------------------


;   if they use common anode just complement the Accumulator before pass the port 
;   port 1 used data bus of (a-g) segment pins
;   port 3 used display enable lines (p3.0 to p3.3)         
;   loookup table provide BCD to 7 segment conversion 
;   NOTE    " use sapreate register for each display "
;   NOTE    " use trasistior for Enable display "


7segdisplay:
    pop 0x7f 
    pop 0x7e 
    pop b       ; fetch 16 bit BCD number 
    pop acc 
    push 0x7e
    push 0x7f 

                ; switch reg. bank for Subroutine 
    setb psw^3
    setb psw^4

                ; move lower digit r1,r0 
    mov r7,a 
    anl a,#0fh
    mov r0,a 
    mov a,r7 
    anl a,#f0h 
    mov r1,a 
                ; move higher digit r2,r3
    mov r7,b 
    mov a,r7 
    anl a,#0fh 
    mov r2,a 
    mov a,r7 
    anl a,#f0h 
    mov r3,a 

                ; transfer data and enable the pins 
    mov a,r3 
    acall 7segdisplay_lookup
    mov P2,a 
    setb P3.3 

    mov a,r2 
    acall 7segdisplay_lookup
    mov P2,a 
    setb P3.2 

    mov a,r1  
    acall 7segdisplay_lookup
    mov P2,a 
    setb p3.1 

    mov a,r0 
    acall 7segdisplay_lookup
    mov P2,a 
    setb P3.0 
    ret 


7segdisplay_lookup:
    movc a,@a+pc
    ret 
    db 0xfc;0
    db 0x60;1
    db 0xda;2 
    db 0xea;3
    db 0x66;4
    db 0xb6;5
    db 0xbe;6
    db 0xe0;7
    db 0xfe;8
    db 0xe6;9
    ret 
