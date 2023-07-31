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
			mov.w	#Var1, R4				; store Var1's address in R4
			mov.w	#Var2, R5				; store Var2's address in R5
			mov.w	#Sum12, R6				; store Sum12's address in R6

			mov.w	0(R4), R7
			mov.w	0(R5), R8
			add.w	R7, R8					; add lower 16-bits
			mov.w	R8, 0(R6)


			mov.w	2(R4), R7
			mov.w	2(R5), R8
			add.w	R7, R8					; add upper 16-bits w/ carry
			mov.w	R8, 2(R6)

			jmp		main
                                            
;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------
			.data							; go to data memory @2000h
			.retain							; do not optimize this section out

Var1:		.long	0E371FFFFh				; create 32-bit constant
Var2:		.long	11112222h				; create 32-bit constant
Sum12:		.space	4						; reserve 4-bytes for sum
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
            
