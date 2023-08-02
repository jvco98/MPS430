	;-------------------------------------------------------------------------------
	; MSP430 Assembler Code Template for use with TI Code Composer Studio
	;
	;
	;-------------------------------------------------------------------------------
	            .cdecls C,LIST,"msp430.h"       ; Include device header file
	            
	;-------------------------------------------------------------------------------
	            .def    RESET                   ; Export program entry-point to
	                                            ; make it known to linker.
	;-------------------------------------------------------------------------------
	            .text                           ; Assemble into program memory.
	            .retain                         ; Override ELF conditional linking
	                                            ; and retain current section.
	            .retainrefs                     ; And retain any sections that have
	                                            ; references to current section.
	
	;-------------------------------------------------------------------------------
	RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
	StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer
	
	
	;-------------------------------------------------------------------------------
	; Main loop here
	;-------------------------------------------------------------------------------
	
	main:
				mov.b	#10101010b, R4
				inv.b	R4						; invert R4
	
				mov.b	#11110000b, R5
				and.b	#00111111b, R5			; clear bits 6 and 7
	
				mov.b	#00010000b, R6
				and.b   #10000000b, R6			; is bit 7 a 0 or a 1? check Z flag
	
				mov.b	#00010000b, R7
				and.b   #00010000b, R7			; is bit 4 a 0 or a 1? check Z flag
	
				mov.b	#11000001b, R8
				or.b	#00011111b, R8			; set bits 4:0
	
				mov.b	#11110000b, R9
				xor.b	#11110000b, R9			; toggle bits 7:4
				xor.b	#00001111b, R9			; toggle bits 3:0
	
	
	
				jmp		main
	
	;-------------------------------------------------------------------------------
	; Memory Allocation
	;-------------------------------------------------------------------------------
	
	;-------------------------------------------------------------------------------
	; Stack Pointer definition
	;-------------------------------------------------------------------------------
	            .global __STACK_END
	            .sect   .stack
	            
	;-------------------------------------------------------------------------------
	; Interrupt Vectors
	;-------------------------------------------------------------------------------
	            .sect   ".reset"                ; MSP430 RESET Vector
	            .short  RESET
	            
