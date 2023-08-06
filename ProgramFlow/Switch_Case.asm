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

			mov.w	#0, R4					; R4 = VarIn
			mov.w	#0, R5					; R5 = VarOut

while:
			cmp.w	#0, R4
			jeq		case0

			cmp.w	#1, R4
			jeq		case1

			cmp.w	#2, R4
			jeq		case2

			cmp.w	#3, R4
			jeq		case3

			jmp		default

default:
			mov.w	#0, R5
			jmp		end_while
case0:
			mov.w	#0x01, R5
			jmp		end_while
case1:
			mov.w	#0x02, R5
			jmp		end_while
case2:
			mov.w	#0x04, R5
			jmp		end_while
case3:
			mov.w	#0x08, R5
			jmp		end_while


end_while:
			jmp		while

                                            

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
            
