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
			mov.w	PC,	R4					; copy PC into R4
			mov.w	R4, R5					; copy R4 into R5
			mov.w	R5, R6					; copy R5 into R6

			mov.b 	PC , R7					; copy lower byte of PC into R7
			mov.b 	R7, R8					; copy lower byte of R7 into R8
			mov.b   R8, R9					; copy lower byte of R8 into R9

			mov.w	SP, R10					; copy SP into R10
			mov.w	R10, R11				; copy R10 into R11
			mov.w	R11, R12				; copy R11 into R12

			mov.b	SP, R13					; copy SP into R13
			mov.b	R13, R14				; copy lower byte of R13 into R14
			mov.b	R14, R15				; copy lower byte of R14 into R15


			jmp main						; loop main

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
            
