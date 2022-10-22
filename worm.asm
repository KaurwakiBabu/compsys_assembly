; ECE 109 Program #2 worm.asm 
; By: Kaurwaki Babu
; Program Description: Create a path from origin (64, 62) using keys 'w' (up), 'a' (left), 's' (down), 'd'(right).
; You can change the color at the current location (represented by a 4x4 pixel) by using keys 'r' (red), 'g' (green), 'b' (blue), 'y' (yellow), and '[space]' (white). 
; You cannot leave the borders of the screen, if you try the pen will cycle through the colors (including black), but will stay in the same location.        
; Pressing the return key will clear the entire screen EXCEPT for where your pen is currently located. Press the 'q' key to quit, which will save your drawing on the screen, but not allow you to futher manipulate it. 
; Pressing any key (including capital variations) other than the one's listed above will do nothing. Press one of the valid keys to get a response. 
; Have Fun! 
    
        .ORIG	x3000
		
        AND R0, R0, 0           ; clear registers
        AND R1, R1, 0 
        AND R2, R2, 0 
        AND R3, R3, 0 
        ST R0, CURRCOL          ; load previous color 

RES     LD R0, Black            ; load values to clear screen
	    LD R1, TopLeft
	    LD R3, TOTAL
	    LD R4, ROW

CLEAR   STR R0, R1, #0          ; clear screen loop
	    ADD R1, R1, #1
	    ADD R3, R3, #-1
        BRp CLEAR
		
        LD R0, CURRCOORD
        BRnp PAINT
        LD R0, STARTCOOR
        ST R0, CURRCOORD        
        BRnzp PAINT             ; starting point
         
REDO    GETC

        AND R1, R1, 0           ; clear register 
        
        LD R1, NEG114           ; check if input red 
        ADD R2, R0, R1
        BRz RE 

        LD R1, NEG103           ; check if input green 
        ADD R2, R0, R1 
        BRz GRE

        LD R1, NEG98            ; check if input blue 
        ADD R2, R0, R1 
        BRz BLU

        LD R1, NEG121           ; check if input yellow 
        ADD R2, R0, R1 
        BRz YEL

        LD R1, NEGSP            ; check if input white
        ADD R2, R0 R1
        BRz WHI

        LD R3, CURRCOORD        ; ld data 
        LD R4, Move 
        LD R5, NEGRow
        LD R6, ROW
        ST R3, STCOORD

        LD R1, NEGW             ; check if input up 
        ADD R2, R0, R1
        BRz UP

        LD R1, NEGA             ; check if input left
        ADD R2, R0, R1
        BRz LEFT

        LD R1, NEGS             ; check if input down
        ADD R2, R0, R1
        BRz DOWN

        LD R1, NEGD             ; check if input right 
        ADD R2, R0, R1
        BRz RT

        LD R1, NEGQ             ; check if input 'q'
        ADD R2, R0, R1
        BRz QUIT  

        LD R1, NEGRET           ; check if input [return]
        ADD R2, R0, R1
        BRz RES

        ADD R0, R0, #0          ; ignore other inputs 
        BRnzp REDO         

GRE     LD R0, Green            ; change pen to green
        ST R0, CURRCOL
        BRnzp PAINT 

RE      LD R0, Red              ; change pen to red
        ST R0, CURRCOL
	    BRnzp PAINT 

BLU     LD R0, Blue             ; change pen to blue
        ST R0, CURRCOL  
        BRnzp PAINT 

YEL     LD R0, Yellow           ; change pen to yellow
        ST R0, CURRCOL  
        BRnzp PAINT

WHI     LD R0, White            ; change pen to white
        ST R0, CURRCOL
        BRnzp PAINT
  
UP      ADD R3, R3, R5          ; move pen up 4 pixels
        ADD R4, R4, #-1
        BRp UP
        BRnz GO 
        
LEFT    ADD R3, R3, #-1         ; move pen left 4 pixels 
        ADD R4, R4, #-1
        BRp LEFT
        BRnz GO

DOWN    ADD R3, R3, R6          ; move pen down 4 pixels 
        ADD R4, R4, #-1
        BRp DOWN
        BRnz GO

RT      ADD R3, R3, #1          ; move pen right 4 pixels
        ADD R4, R4, #-1
        BRp RT
        BRnz GO 

GO      ST R3, CURRCOORD        
        ST R3, OGCOORD

PAINT   LD R2, NEGRow
        LD R4, TopRight         
        LD R5, TopLeft
        LD R6, CURRCOORD
        NOT R4, R4
        ADD R4, R4, #1

        ADD R3, R6, R4          ; check if in top line
        BRp BOT 

        AND R3, R3, 0 
        NOT R6, R6
        ADD R6, R6, #1

CHECK1  ADD R3, R4, R5          ; check top boundary
        BRz PASS
        AND R3, R3, 0 
        ADD R3, R6, R5 
        BRnz NEXT
        LD R3, STCOORD
        ST R3, CURRCOORD
        LD R2, Counter 
        ADD R2, R2, #1
        ST R2, Counter  
        BRnzp COLOR

NEXT    AND R3, R3, 0
        ADD R5, R5, #1
        BRnzp CHECK1

BOT     LD R4, BotRight         
        LD R5, BotLeft
        LD R6, CURRCOORD
        NOT R5, R5
        ADD R5, R5, #1

        ADD R3, R6, R5          ; check if in bottom line
        BRn LSIDE 

        AND R3, R3, 0 
        NOT R6, R6
        ADD R6, R6, #1

CHECK2  ADD R3, R5, R4          ; check bottom boundary
        BRz PASS
        AND R3, R3, 0 
        ADD R3, R6, R4 
        BRzp NEXT2
        LD R3, STCOORD
        ST R3, CURRCOORD
        LD R2, Counter
        ADD R2, R2, #1
        ST R2, Counter 
        BRnzp COLOR 

NEXT2   AND R3, R3, 0
        ADD R4, R4, #1
        BRnzp CHECK2
        
LSIDE   LD R2, ROW
        LD R4, TopLeft
        LD R5, BotLeft
        LD R6, CURRCOORD
        NOT R6, R6
        ADD R6, R6, #1
        NOT R5, R5
        ADD R5, R5, #1 
        AND R3, R3, 0

CHECK3  ADD R3, R5, R4 
        BRzp PASS 
        AND R3, R3, 0 
        ADD R3, R4, R6  
        BRnp NEXT3 
        LD R3, STCOORD
        ST R3, CURRCOORD
        LD R2, Counter
        ADD R2, R2, #1
        ST R2, Counter  
        BRnzp COLOR

NEXT3   AND R3, R3, 0
        ADD R4, R4, R2
        BRnzp CHECK3  

COLOR   LD R2, Counter 
        ADD R2, R2, #-1 
        BRz CHR
        LD R2, Counter
        ADD R2, R2, #-2 
        BRz CHG
        LD R2, Counter
        ADD R2, R2, #-3 
        BRz CHB
        LD R2, Counter
        ADD R2, R2, #-4 
        BRz CHY
        LD R2, Counter
        ADD R2, R2, #-5
        BRz CHW 
        LD R2, Counter
        ADD R2, R2, #-6
        BRz CHBL    

CHR     LD R0, Red 
        ST R0, CURRCOL
        BRnzp PASS 

CHG     LD R0, Green
        ST R0, CURRCOL
        BRnzp PASS

CHB     LD R0, Blue
        ST R0, CURRCOL
        BRnzp PASS

CHY     LD R0, Yellow
        ST R0, CURRCOL
        BRnzp PASS

CHW     LD R0, White
        ST R0, CURRCOL
        BRnzp PASS 

CHBL    AND R2, R2, 0 
        ST R2, Counter
        LD R0, Black 
        ST R0, CURRCOL
        BRnzp CONT  

PASS    LD R0, CURRCOL
        BRnp CONT
        LD R0, White

CONT    AND R4, R4, 0 
        ADD R4, R4, #4 

        LD R1, CURRCOORD        ; paint pen location 
        ST R1, OGCOORD
        
HORZ2   LD R2, Pen
        LD R3, ROW

VERT2	STR R0, R1, #0
        ADD R1, R1, R3 	; next row
	    ADD R2, R2, #-1
	    BRp VERT2

        ADD R4, R4, #-1
        BRz SKIP

        LD R1, CURRCOORD
        ADD R1, R1, #1
        ST R1, CURRCOORD
        BRnzp HORZ2

SKIP    LD R1, OGCOORD
        ST R1, CURRCOORD
        BRnzp REDO

QUIT     HALT        

	
Red         .FILL x7C00
Green       .FILL x03E0
Blue        .FILL x001F
Yellow      .FILL x7FED
White       .FILL x7FFF
Black       .FILL x0000
STARTCOOR   .FILL xDF40
CURRCOORD   .FILL x0000
OGCOORD     .FILL x0000
STCOORD     .FILL x0000
CURRCOL     .FILL x0000
ROW	        .FILL #128
NEGRow      .FILL #-128
TOTAL       .FILL #15872
NEG114      .FILL #-114
NEG77       .FILL #-103
NEG98       .FILL #-98 
NEG121      .FILL #-121
NEG103      .FILL #-103
POS32       .FILL #32
NEGSP       .FILL #-32
TopLeft     .FILL xC000
TopRight    .FILL xC07F
BotRight    .FILL xFD80
BotLeft     .FILL xFDFF
Pen         .FILL #4
NEGW        .FILL #-119
NEGA        .FILL #-97
NEGS        .FILL #-115  
NEGD        .FILL #-100
NEGQ        .FILL #-113
NEGRET      .FILL #-10
Move        .FILL #4
Counter     .FILL #0

.END