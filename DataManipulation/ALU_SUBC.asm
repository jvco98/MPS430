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

			mov.w	#Var1, R4				; R4 points to Var1
			mov.w	#Var2, R5				; R5 points to Var2
			mov.w	#Diff12, R6				; R6 points to Diff12

			mov.w	0(R4), R7
			mov.w	0(R5), R8
			sub.w	R8, R7					; R7 = R7 - R8
			mov.w	R7, 0(R6)

			mov.w	2(R4), R7
			mov.w	2(R5), R8
			subc.w	R8, R7					; R7 = R7 - R8
			mov.w	R7, 2(R6)				; Diff12 = R7

			jmp		main

;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------
			.data
			.retain

Var1:		.long	#0E4651FFFh
Var2:		.long	#011112222h

Diff12:		.space	4



                                            

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
            
