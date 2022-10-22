; ECE 109, SPRING 2022, 
;       PROJECT 1 by Kaurwaki Babu 

		.ORIG x3000
		
GOA     AND R5, R5, 0    ;clear registers
		AND R6, R6, 0	
		AND R1, R1, 0
		
		LEA R0, Prompt1	
		PUTS
REDO	GETC
		OUT
		
		LD R2, NEGQuit  ;check if input 'q'
		ADD R1, R0, R2
		BRz QUIT
    
		LD R2, NEG0     ;check if within range 0-9
		ADD R1, R0, R2
		BRn REDO
		LD R2, NEG9
		ADD R1, R0, R2
		BRP REDO
		ADD R5, R5, R0
		
REDOA	GETC
		OUT

		LD R2, NEGQuit  ;check for 'q'
		ADD R1, R0, R2
		BRz QUIT

		LD R2, NEGLF    ;check for line feed
		ADD R1, R0, R2
		BRz LF

		LD R2, NEG0     ;check if within range 0-9 
		ADD R1, R0, R2
		BRn REDOA
		LD R2, NEG9
		ADD R1, R0, R2
		BRP REDOA
		ADD R6, R6, R0	
		
		LD R2, NEGASCII ;strip ASCII offset of of the inputted characters
		ADD R5, R5, R2
		ADD R6, R6, R2

        ;combining integers
		AND R4, R4, 0       ;clear R4 

        ADD R4, R4, R5      ;1 x R5 
        ADD R4, R4, R5      ;2 x R5
        ADD R4, R4, R5      ;3 X R5
        ADD R4, R4, R5      ;4 X R5
        ADD R4, R4, R5      ;5 X R5
        ADD R4, R4, R5      ;6 x R5 
        ADD R4, R4, R5      ;7 x R5 
        ADD R4, R4, R5      ;8 x R5 
        ADD R4, R4, R5      ;9 x R5 
        ADD R4, R4, R5      ;10 x R5 

        ADD R4, R4, R6      ;adding in ones digit 
		
		ST R4, FirstNum
		BRnzp SKIPME

LF	    LD R2, NEGASCII
		ADD R5, R5, R2
		ST R5, FirstNum		
		BRnzp SKIPME
		
NEGLF       .FILL #-10		
Prompt1     .STRINGZ "\n\nEnter First Number (0-49): "
Prompt2     .STRINGZ "\n\nEnter End Number: "
Prompt4     .STRINGZ "\n\nThank you for playing!"
Prompt5     .STRINGZ "\n\nInvalid Entry"
Prompt6     .STRINGZ "\n\nThe difference is: "
NEG02       .FILL 0
NEG49       .FILL #-49
NEGASCII    .FILL #-48
ASCIIOFF    .FILL #48
NEG0        .FILL #-48
NEG9        .FILL #-57
NEGSign     .FILL x002D
POSSign     .FILL x0020
NEGOver     .FILL xFFF6
FirstNum    .FILL x0000
SecNum      .FILL x0000
NEGQuit		.FILL #-113
TOTAL       .FILL 0
SIGN        .FILL 0
		

				; Halfway Jump for QUIT due to range
QUIT		BRnzp QUIT2
		
		
		
		
		
		
SKIPME	LEA R0, PROMPT2	
		PUTS
REDO2	GETC
		OUT
		
		;check for 'q'
		LD R2, NEGQuit
		ADD R1, R0, R2
		BRz QUIT

		
		AND R5, R5, 0
		AND R6, R6, 0
		
		;check if within range
		LD R2, NEG0
		ADD R1, R0, R2
		BRn REDO2
		LD R2, NEG9
		ADD R1, R0, R2
		BRP REDO2
		ADD R5, R5, R0
		
REDOA2  GETC
		OUT
		
		;check for 'q'
		LD R2, NEGQuit
		ADD R1, R0, R2
		BRz QUIT

        ;line feed
		LD R2, NEGLF
		ADD R1, R0, R2
		BRz LF2
		
		;checking if within range  
		LD R2, NEG0
		ADD R1, R0, R2
		BRn REDOA2
		LD R2, NEG9
		ADD R1, R0, R2
		BRP REDOA2
		ADD R6, R6, R0	
	
		;strip ASCII offset of of the inputted characters
		LD R2, NEGASCII
		ADD R5, R5, R2
		ADD R6, R6, R2

	
		;combining digits
		
		AND R4, R4, 0       ;clear R4 

        ADD R4, R4, R5      ;1 x R5 
        ADD R4, R4, R5      ;2 x R5
        ADD R4, R4, R5      ;3 X R5
        ADD R4, R4, R5      ;4 X R5
        ADD R4, R4, R5      ;5 X R5
        ADD R4, R4, R5      ;6 x R5 
        ADD R4, R4, R5      ;7 x R5 
        ADD R4, R4, R5      ;8 x R5 
        ADD R4, R4, R5      ;9 x R5 
        ADD R4, R4, R5      ;10 x R5 

        ADD R4, R4, R6          ;adding in ones digit
		
		ST R4, SecNum
		BRnzp SKIPME2

LF2     LD R2, NEGASCII
		ADD R5, R5, R2
		ST R5, SecNum

SKIPME2	
		;check if both inputs are within range 0-49
		LD R2, FirstNum
		LD R3, NEG02
		ADD R4, R2, R3
		BRn INVAL
		LD R3, NEG49
		ADD R4, R2, R3
		BRp INVAL
		
		LD R5, SecNum
		LD R3, NEG02
		ADD R4, R5, R3
		BRn INVAL
		LD R3, NEG49
		ADD R4, R5, R3
		BRp INVAL
		BRnz GOSUB
		
INVAL   LEA R0, Prompt5
        PUTS
		BRnzp GOA
		
GOSUB   NOT R5, R5
        ADD R5, R5, #1
        ADD R2, R2, R5
        ST R2, TOTAL 

        LD R5, SecNum
        LD R3, POSSign
        ST R3, SIGN 
        LD R2, FirstNum
        NOT R2, R2
        ADD R2, R2, #1 
        ADD R3, R5, R2
        BRnz CONT
        AND R2, R2, 0
        LD R5, TOTAL 
        NOT R5, R5
        ADD R5, R5, #1
        ST R5, TOTAL
        LD R3, NEGSign
        ST R3, SIGN 

		;separate 10s and 1s
		
CONT    LD R5, TOTAL
		AND R6, R6, 0       ;clear R6
		
DIV10   ADD R6, R6, 1		;increment counter
		ADD R5, R5, #-10    ;sub 10
		BRp  DIV10			;keep going
		
		ADD R5, R5, 10		;ones
		ADD R6, R6, -1		;tens

        AND R3, R3, 0
        LD R3, NEGOver
        ADD R3, R5, R3
        BRz OVER
		
        AND R3, R3, 0
        ADD R3, R6, #-1     ;check for leading zeros 
        BRn LEAD

		;display
REG     LEA R0, Prompt6
		PUTS
        LD R0, SIGN         ;blank for pos num and dash for neg num
        OUT
		LD R2, ASCIIOFF
		ADD R0, R6, R2
		OUT
		ADD R0, R5, R2
		OUT
		JMP R0

        ;getting rid of leading zeros 
LEAD	LEA R0, Prompt6
		PUTS
        LD R0, SIGN
        OUT
		LD R2, ASCIIOFF
		ADD R0, R5, R2
		OUT
		JMP R0

        ;values in which the one's place is 10 
OVER    LEA R0, Prompt6
		PUTS
        LD R0, SIGN
        OUT
		LD R2, ASCIIOFF   
        ADD R6, R6, #1
		ADD R0, R6, R2
		OUT
        AND R5, R5, 0
		ADD R0, R5, R2
		OUT
		JMP R0


QUIT2	LEA R0, Prompt4
		PUTS	
		HALT
		


		
		


