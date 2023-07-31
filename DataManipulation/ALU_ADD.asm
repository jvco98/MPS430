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
			mov.w	#371, R4				; copy 371 into R4
			mov.w	#465, R5				; copy 465 into R5
			add.w	R4, R5					; R5 = R4 +

			mov.w	#0FFFEh, R6				; copy FFFEh into R6
			add.w	#001h, R6				; R6 = 0FFFEh + R6

			mov.w	#0FFFFh, R7				; copy FFFFh into R7
			add.w	#1h, R7					; R7 = 1 + R7
			
			mov.b	#255, R8
			mov.b	#1, R9
			add.b	R8, R9
			
			mov.b	#-1, R10
			add.b	#1,	R10
			
			mov.b	#127, R11
			add.b	#127, R11	

			jmp		main
                                            

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
            
