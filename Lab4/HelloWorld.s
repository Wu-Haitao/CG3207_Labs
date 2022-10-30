	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 127 (126 excluding the last line 'halt B halt').

		
		LDR R5, ZERO
		LDR R9, SEVENSEG
		LDR R10, DIPS
		
		ADD R4, R5, #1
		STR R4, [R10, #-4] ; Set LED
		
WAIT_NUM_1
		LDR R1, [R10] ; Read num_1 from DIPS
		STR R1, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_1

WAIT_RESET_1
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_1

WAIT_NUM_2
		LDR R2, [R10] ; Read num_2 from DIPS
		STR R2, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_2

WAIT_RESET_2
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_2

CAL_EOR
		EOR R3, R1, R2
		STR R3, [R9] ; Display EOR result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_EOR

CAL_RSC
		RSC R3, R1, R2
		STR R3, [R9] ; Display RSC result
		LDR R4, [R10]
		CMP R4, #0
		BNE CAL_RSC

CAL_BIC
		BIC R3, R1, R2
		STR R3, [R9] ; Display BIC result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_BIC

WAIT_RESET_3
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_3

		ADD R4, R5, #2
		STR R4, [R10, #-4] ; Set LED
		
WAIT_NUM_3
		LDR R1, [R10] ; Read num_1 from DIPS
		MOV R1, R1, LSL #16
		STR R1, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_3

WAIT_RESET_4
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_4

WAIT_NUM_4
		LDR R2, [R10] ; Read num_2 from DIPS
		MOV R2, R2, LSL #16
		STR R2, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_4

WAIT_RESET_5
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_5

WAIT_NUM_5
		LDR R6, [R10] ; Read num_3 from DIPS
		STR R6, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_5

WAIT_RESET_7
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_7

WAIT_NUM_6
		LDR R7, [R10] ; Read num_4 from DIPS
		STR R7, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_6

WAIT_RESET_8
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_8

CAL_ADD
		ADDS R3, R1, R2
		ADC R8, R6, R7
		MOV R3, R3, LSR #16
		MOV R8, R8, LSL #16
		ADD R3, R3, R8
		STR R3, [R9] ; Display ADD result
		LDR R4, [R10]
		CMP R4, #3
		BNE CAL_ADD

WAIT_RESET_9
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_9
		
TEST_EQ
		ADD R4, R5, #3
		STR R4, [R10, #-4] ; Set LED
		
WAIT_NUM_7
		LDR R1, [R10] ; Read num_1 from DIPS
		STR R1, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_7

WAIT_RESET_10
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_10

WAIT_NUM_8
		LDR R2, [R10] ; Read num_2 from DIPS
		STR R2, [R9]
		LDR R4, [R10, #4] ; Get button state
		CMP R4, #2
		BNE	WAIT_NUM_8

WAIT_RESET_11
		LDR R4, [R10]
		CMP R4, #0
		BNE WAIT_RESET_11

		TEQ R1, R2
		BNE TEST_EQ

		ADD R4, R5, #4
		STR R4, [R10, #-4]
		MVN R3, R1
		STR R3, [R9] ; Display MVN result

halt	
		B halt

ISR
		SUB R12, LR, #4
		ADD R4, R5, #255
		STR R4, [R10, #-4] ; Set LESs on
		MOV PC, R12
		
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
