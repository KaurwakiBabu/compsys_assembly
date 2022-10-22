; ECE 109 Program #2 mines.asm 
; By: Kaurwaki Babu
; This game is essentially a simplified version of mindsweep. When prompted, enter an X-Coordinate that is between (0 and 15) and a Y-Coordinate that's between (0 and 14). 
; If either coordinate you enter is out of range, the message "Bogus" will be displayed and you will be prompted to re-enter an X and Y coordinate. 
; If the coordinate you entered has a hidden object, the coordinate you specified will turn red and the message "HIT" will be displayed. 
; If the coordinate you entered does NOT have a hidden object, the coordinate will turn white and the message "MISS" will be displayed. 
; The only way to exit the game is by pressing the character 'q'. Even if all the blocks are colored red or white, the game keeps going unless 'q' is pressed.
; When 'q' is pressed, the remaining coordinate that were not hit turn blue. Blocks that do not have any hidden objects remain either black or white, and the coordinate you discovered that do have hidden objects remain red. 
; Enjoy!

 
        .ORIG	x3000   

        JSR CSCR            ;subroutine 1 - clear screen

GOA     JSR CREG            ;subroutine 2 - clear all registers

        ;X-Coordinate Input

        LEA R0, Prompt1 
        PUTS
REDO    GETC
        OUT

        LD R2, NEGQuit      ;check if input 'q'
	ADD R1, R0, R2
	BRz QUIT

        LD R2, NEG0         ;check if within range 0-9
	ADD R1, R0, R2
	BRn REDO
	LD R2, NEG9
	ADD R1, R0, R2
	BRP REDO
	ADD R5, R5, R0
		
REDOA	GETC
	OUT

        LD R2, NEGQuit      ;check if input 'q'
	ADD R1, R0, R2
	BRz QUIT

        LD R2, NEGLF        ;check for line feed
	ADD R1, R0, R2
	BRz LF

	LD R2, NEG0         ;check if input within range 0-9 
	ADD R1, R0, R2
	BRn REDOA
	LD R2, NEG9
	ADD R1, R0, R2
	BRp REDOA
	ADD R6, R6, R0	

        JSR CONV            ;subroutine 4 - convert input to binary 
        ST R4, XINPUT
        BRnzp IN2

LF	LD R2, HexOFF
	ADD R5, R5, R2
	ST R5, XInput

    
IN2     JSR SPAC            ;subroutine 3 - spacing (print 2 line feeds)

        LD R2, XInput       ;check if 0 < x < 15
	AND R3, R3, 0
	ADD R4, R2, R3
	BRn BOGUS 
	LD R3, NEG15
	ADD R4, R2, R3
	BRp BOGUS
        BRnz IN3 
		
BOGUS   LEA R0, Prompt3     ;if XInput out of range
        PUTS
	BRnzp GOA
        
        ;Y-Coordinate Input 

IN3     JSR CREG

        LEA R0, Prompt2 
        PUTS
REDO2   GETC 
        OUT

        LD R2, NEGQuit      ;check if input 'q'
	ADD R1, R0, R2
        BRz QUIT

        LD R2, NEG0         ;check if input within range 0-9
	ADD R1, R0, R2
	BRn REDO2
	LD R2, NEG9
	ADD R1, R0, R2
	BRP REDO2
	ADD R5, R5, R0
		
REDOB	GETC
	OUT

        LD R2, NEGQuit      ;check if input 'q'
	ADD R1, R0, R2
	BRz QUIT

        LD R2, NEGLF        ;check for line feed
        ADD R1, R0, R2
	BRz LF2

	LD R2, NEG0         ;check if within range 0-9 
	ADD R1, R0, R2
	BRn REDOB
	LD R2, NEG9
	ADD R1, R0, R2
	BRp REDOB
	ADD R6, R6, R0	

        JSR CONV            ;subroutine 3 - convert input to binary 
        ST R4, YINPUT
        BRnzp IN4

LF2	LD R2, HexOFF
        ADD R5, R5, R2
	ST R5, YInput
        BRnzp IN4


Prompt1         .STRINGZ "\n\nEnter an X-Coordinate: "
Prompt2         .STRINGZ "\n\nEnter an Y-Coordinate: "
SPACING         .STRINGZ "\n\n"
Prompt3         .STRINGZ "Bogus"
Prompt4         .STRINGZ "Thank you for playing!"
HexOff          .FILL #-48
XInput          .FILL #0
YInput          .FILL #0  
DataRow         .FILL #16
RESULT          .FILL #0
NEGQuit		.FILL #-113
NEG0            .FILL #-48
NEG9            .FILL #-57
NEG15           .FILL #-15
NEG14           .FILL #-14
QTrack          .FILL x0000
NEGLF           .FILL #-10 
YCount          .FILL #0

IN4     JSR SPAC            ;subroutine 3 - spacing (print two line feeds)

        LD R5, YInput       ;check if 0 < y < 14 
	AND R3, R3, 0 
	ADD R4, R5, R3
	BRn BOGUS2
	LD R3, NEG14
	ADD R4, R5, R3
	BRp BOGUS2
        BRnz UPD 

BOGUS2  LEA R0, Prompt3     ;if YInput out of range 
        PUTS
	BRnzp GOA

UPD     LD R4, YInput       ;offset bitmap memory location by Y-Coordinate
        LD R1, Start
        ADD R1, R1, R4 
        ST R1, NStart 
        BRnzp CONT

QUIT    JSR SPAC            ;beginning of code for Quit 
        LD R0, Start
        ST R0, NStart
        LD R0, TopLeft
        ST R0, CURRCOORD
        AND R0, R0, 0
        ST R0, YCount

REDOQ   LD R0, YCount       ;set YCount so know when to halt 
        ST R0, YInput
  
        AND R2, R2, 0       ;know when X-Coordinate has reached 15 so it resets back to 0 
        LD R0, QTrack
        LD R1, DataRow
        NOT R0, R0
        ADD R0, R0, #1
        ADD R0, R0, R1
        BRnp CONTQ
        AND R0, R0, 0 
        ST R0, QTrack
        BRnzp SKIPQ

CONTQ   LD R0, QTrack
        ST R0, XInput
        NOT R0, R0
        ADD R0, R0, #1
        ADD R1, R1, R0
        BRnp Q2
        ADD R2, R2, #1
        BRnzp TH

SKIPQ   LD R0, YCount       ;when X-Coordinate is 15, the Y-Coordinate must jump to next row so this changes bitmap memory offset value
        ADD R0, R0, #1
        ST R0, YInput
        ST R0, YCount
        LD R1, NEG15
        ADD R0, R0, R1 
        BRz FINAL
        LD R0, NStart
        ADD R0, R0, #1
        ST R0, NStart
        BRnzp CONTQ    
         

LOLQ    ADD R2, R2, #1
        BRnzp TH

        JSR CREG            ;subroutine 1 - clear registers

        ST R0, QTrack
        ST R0, XInput
        BRnzp Q2
        
Q2      JSR TOBIN           ;subroutine 4 - convert input to binary 
TH      ST R2, RESULT
        JSR NEWC            ;subroutine 5 - convert input to 16-bit binary that can be used to mask 

        LD R2, RESULT       ;segment to AND XCoordinate with value located in bitmap memory to reveal hidden objects    
        LDI, R3, NSTART 
        AND R2, R3, R2 
        ADD R2, R2, #-1
        BRzp HITQ
        AND R2, R2, 0
        BRnzp MISSQ

HITQ    LDI R0, CURRCOORD   ;if the hidden object location is not already red or white, paint blue 
        BRnp SKIPP 
        LD R0, Blue     
        JSR PAINTQ          ;subroutine 6 - paint location 
SKIPP   BRnzp UPX

MISSQ   BRnzp UPX 

UPX     LD R0, QTrack       ;adds 1 to QTrack which is X-Coordinate 
        ADD R0, R0, #1 
        ST R0, QTrack
        BRnzp REDOQ         

FINAL   LEA R0, Prompt4     ;when Y-Coordinate offset is 14, we must halt as per constraints
        PUTS
        HALT


CONT    AND R2, R2, 0       ;subtracts XInput from 16. Result is the exponent 'n' (2^n) which is used to reveal hidden objects
        LD R0, XInput
        NOT R0, R0
        ADD R0, R0, #1
        LD R1, DataRow
        ADD R1, R1, R0
        BRnp TOTAL
        ADD R2, R2, #1
        BRnzp DETER

; iterate through loop at doubles value (starting with one) stored by 16 - n 

TOTAL   JSR TOBIN           ;subroutine 4 - convert Input to 16-bit binary 

; use AND to mask if value is equal to 0 or to 1

DETER   ST R2, RESULT

        JSR NEWC            ;subroutine 5 - convert coordinates to memory location

        LD R2, RESULT
        LDI, R3, NSTART 
        AND R2, R3, R2 
        ADD R2, R2, #-1
        BRzp HIT
        AND R2, R2, 0
        BRnzp MISS

HIT     LEA R0, HITS        ;if hit paint red
        PUTS
        LD R0, Red
        BRnzp PAINT         

MISS    LEA R0, MISSES      ;if miss paint white
        PUTS
        LD R0, White

PAINT   JSR PAINTQ          ;subroutine 6 - paint location 

        LD R1, OGCOORD
        ST R1, CURRCOORD 
        LD R0, RESTART
        JMP R0              ;need to jump due to PC-Offset out of range

HITS            .STRINGZ "HIT"
MISSES          .STRINGZ "MISS"
Start           .FILL x5000
NStart          .FILL x5000
Black           .FILL x0000
White           .FILL x7FFF
Red             .FILL x7C00
Blue            .FILL x001F
TopLeft         .FILL xC000
SCREEN          .FILL #15872
ROW	        .FILL #128
CURRCOORD       .FILL x0000
CURRCOL         .FILL x0000
OGCOORD         .FILL x0000
Pen             .FILL #8
Location        .FILL x0000 
AfterSc         .FILL xFE00
RESTART         .FILL x3001

;
;SUBROUTINES
;

;subroutine 1 - clear screen

CSCR    ST R7, Location
        LD R0, Black        ;load values to clear screen
	LD R1, TopLeft
	LD R3, SCREEN
	LD R4, ROW

CLR     STR R0, R1, #0      ;clear screen loop
	ADD R1, R1, #1
	ADD R3, R3, #-1
        BRp CLR
        LD R7, Location 
        RET 

;subroutine 2 - clear registers

CREG    AND R0, R0, 0           
        AND R1, R1, 0 
        AND R2, R2, 0 
        AND R3, R3, 0
        AND R4, R4, 0 
        AND R5, R5, 0
        AND R6, R6, 0
        RET

;subroutine 3 - spacing (print 2 line feeds after input)

SPAC    ST R7, Location 
        LEA R0, SPACING 
        PUTS
        LD R7, Location 
        RET

;subroutine 3 - convert input to binary. Remove ASCII as well

CONV    ST R7, Location
        LD R2, HexOff           ;strip ASCII offset of of the inputted characters
	ADD R5, R5, R2
	ADD R6, R6, R2

        AND R4, R4, 0           ;clear R4
        AND R3, R3, 0
        ADD R3, R3, #10
COMB    ADD R4, R4, R5 
        ADD R3, R3, #-1
        BRp COMB 

        ADD R4, R4, R6
        LD R7, Location
        RET

;subroutine 4 - convert XInput into binary (16-bit that can be used to reveal hidden objects with AND)

TOBIN   ST R7, Location
        ADD R2, R2, #1
        ADD R1, R1, #-1 
LOOPT   ADD R2, R2, R2
        ADD R1, R1, #-1 
        BRp LOOPT
        LD R7, Location 
        RET

;subroutine 5 - convert coordinates pixel locations and then to memory location

NEWC    ST R7, Location
        LD R3, XInput
        AND R2, R2, 0
        ADD R3, R3, #-1
        BRn NEXT

NEWPX   ADD R2, R2, #8
        ADD R3, R3, #-1
        BRzp NEWPX
        ST R2, XInput 

NEXT    LD R1, TopLeft
        LD R2, ROW
        LD R3, YInput
        AND R4, R4, 0 
        ADD R4, R4, #8
        ADD R3, R3, #-1
        BRn STAY

NEWPY   ADD R1, R1, R2
        ADD R4, R4, #-1 
        BRnp NEWPY
        ADD R4, R4, #8
        ADD R3, R3, #-1
        BRzp NEWPY
        ST R1, YInput 
        BRnzp NEWXY 

STAY    LD R3, YInput
        ADD R3, R1, R3
        ST R3, YInput

NEWXY   LD R0, YInput
        LD R1, XInput 
        ADD R0, R0, R1
        ST R0, CURRCOORD

        LD R7, Location
        RET
  
;subroutine 6 - paint current location

PAINTQ  ST R7, Location
        AND R4, R4, 0 
        ADD R4, R4, #8 

        LD R1, CURRCOORD    ;paint pen location 
        ST R1, OGCOORD
        
HORZ    LD R2, Pen
        LD R3, ROW

VERT	STR R0, R1, #0
        ADD R1, R1, R3 	    ;next row
        ADD R2, R2, #-1
        BRp VERT

        ADD R4, R4, #-1
        BRz SKIP

        LD R1, CURRCOORD
        ADD R1, R1, #1
        ST R1, CURRCOORD
        BRnzp HORZ

SKIP    LD R7, Location
        RET 