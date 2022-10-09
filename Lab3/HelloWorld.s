	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 127 (126 excluding the last line 'halt B halt').

		
		LDR R5, ZERO
		LDR R6, CONSOLE_OUT_ready	; UART ready for output flag
		LDR R7, CONSOLE_IN_valid	; UART new data flag
		LDR R8, CONSOLE		; UART
		LDR R9, SEVENSEG
		LDR R10, DIPS
		
		ADD R4, R5, #1
		STR R4, [R10, #-4] ; Set LED
WAIT_NUM_1
		LDR R1, [R10] ; Read num_1 from DIPS
		STR R1, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMN R4, #0
		BEQ	WAIT_NUM_1

		ADD R4, R5, #2
		STR R4, [R10, #-4] ; Set LED
WAIT_RESET_1
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_1

		ADD R4, R5, #3
		STR R4, [R10, #-4]
WAIT_NUM_2
		LDR R2, [R10] ; Read num_2 from DIPS
		STR R2, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMN R4, #0
		BEQ	WAIT_NUM_2

		ADD R4, R5, #4
		STR R4, [R10, #-4]
WAIT_RESET_2
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_2

CAL
		ADD R4, R5, #5
		STR R4, [R10, #-4]
CAL_ADD
		ADD R3, R1, R2
		STR R3, [R9] ; Display ADD result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_ADD

		ADD R4, R5, #6
		STR R4, [R10, #-4]
CAL_SUB
		SUB R3, R1, R2
		STR R3, [R9] ; Display SUB result
		LDR R4, [R10]
		CMP R4, #0
		BNE CAL_SUB
		
		ADD R4, R5, #7
		STR R4, [R10, #-4]
CAL_AND
		AND R3, R1, R2
		STR R3, [R9] ; Display AND result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_AND
		
		ADD R4, R5, #8
		STR R4, [R10, #-4]
CAL_ORR
		ORR R3, R1, R2
		STR R3, [R9] ; Display ORR result
		LDR R4, [R10]
		CMP R4, #0
		BNE CAL_ORR
		
		ADD R4, R5, #9
		STR R4, [R10, #-4]
CAL_ADD_IMM
		ADD R3, R1, #2 ; R3 = R1 + 2
		STR R3, [R9] ; Display ADD result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_ADD_IMM

		ADD R4, R5, #10
		STR R4, [R10, #-4]
CAL_SUB_SHIFT
		SUB R3, R1, R2, LSR #2 ; R3 = R1 - (R2 >> 2)
		STR R3, [R9] ; Display SUB result
		LDR R4, [R10]
		CMP R4, #0
		BNE CAL_SUB_SHIFT
		
		ADD R4, R5, #11
		STR R4, [R10, #-4]
CAL_AND_IMM
		AND R3, R1, #2 ; R3 = R1 & 2
		STR R3, [R9] ; Display AND result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_AND_IMM
		
		ADD R4, R5, #12
		STR R4, [R10, #-4]
CAL_ORR_SHIFT
		ORR R3, R1, R2, LSL #2 ; R3 = R1 | (R2 << 2)
		STR R3, [R9] ; Display ORR result
		LDR R4, [R10]
		CMP R4, #0
		BNE CAL_ORR_SHIFT
		B CAL
		
halt	
		B halt
; ------- <\code memory (ROM mapped to Instruction Memory) ends>


	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 
; ------- <constant memory (ROM mapped to Data Memory) begins>
; All constants should be declared in this section. This section is read only (Only LDR, no STR).
; Total number of constants should not exceed 128 (124 excluding the 4 used for peripheral pointers).
; If a variable is accessed multiple times, it is better to store the address in a register and use it rather than load it repeatedly.

;Peripheral pointers
LEDS
		DCD 0x00000C00		; Address of LEDs. //volatile unsigned int * const LEDS = (unsigned int*)0x00000C00;  
DIPS
		DCD 0x00000C04		; Address of DIP switches. //volatile unsigned int * const DIPS = (unsigned int*)0x00000C04;
PBS
		DCD 0x00000C08		; Address of Push Buttons. Used only in Lab 2
CONSOLE
		DCD 0x00000C0C		; Address of UART. Used only in Lab 2 and later
CONSOLE_IN_valid
		DCD 0x00000C10		; Address of UART. Used only in Lab 2 and later
CONSOLE_OUT_ready
		DCD 0x00000C14		; Address of UART. Used only in Lab 2 and later
SEVENSEG
		DCD 0x00000C18		; Address of 7-Segment LEDs. Used only in Lab 2 and later

; Rest of the constants should be declared below.
ZERO
		DCD 0x00000000		; constant 0
LSB_MASK
		DCD 0x000000FF		; constant 0xFF
DELAY_VAL
		DCD 0x00000002		; delay time.
variable1_addr
		DCD variable1		; address of variable1. Required since we are avoiding pseudo-instructions // unsigned int * const variable1_addr = &variable1;
constant1
		DCD 0xABCD1234		; // const unsigned int constant1 = 0xABCD1234;
string1   
		DCB  "\r\nWelcome to CG3207..\r\n",0	; // unsigned char string1[] = "Hello World!"; // assembler will issue a warning if the string size is not a multiple of 4, but the warning is safe to ignore
stringptr
		DCD string1			;
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	

	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (RAM mapped to Data Memory) begins>
; All variables should be declared in this section. This section is read-write.
; Total number of variables should not exceed 128. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it (i.e., write to a location using STR before reading using LDR).

variable1
		DCD 0x00000000		;  // unsigned int variable1;
; ------- <variable memory (RAM mapped to Data Memory) ends>	

		END	