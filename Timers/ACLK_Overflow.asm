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
init:
;---- Setup LED
			bis.b	#BIT0, &P1DIR			; set P1.0 to O/P
			bic.b	#BIT0, &P1OUT			; initially turn LED1 off
			bic.b	#LOCKLPM5, &PM5CTL0		; enable Digital I/O

;---- Setup Timer B0	(16-bit register)
			bis.w	#TBCLR, &TB0CTL			; clear TB0
			bis.w	#TBSSEL__ACLK, &TB0CTL	; choose ACLK
			bis.w	#MC__CONTINUOUS, &TB0CTL	; assert continuous mode msb
			;bic.w	#MC__CONTINUOUS_L, &TB0CTL	; assert continuous mode lsb

;---- Setup overflow IRQ
			bis.w	#TBIE, &TB0CTL			; locally enable interrupts
			eint							; globally enable interrupts
			bic.w	#TBIFG, &TB0CTL			; clear flag for first use

main:
			jmp		main
;-------------------------------------------------------------------------------
; Interrupt Service Routines
;-------------------------------------------------------------------------------
ISR_TB0_Overflow:
			xor.b	#BIT0, &P1OUT			; toggle LED1
			bic.w	#TBIFG, &TB0CTL			; clear flag for first use
			reti							; return from ISR

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
            
            .sect	".int42"				; init vector table for TB0 overflow
            .short	ISR_TB0_Overflow
