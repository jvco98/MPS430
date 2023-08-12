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
;--------------------- ----------------------------------------------------------
init:
;setup LED1
			bis.b	#BIT0, &P1DIR			; set P1.0 as O/P (LED1)
			bic.b	#BIT0, &P1OUT			; initially turn LED1 off
			bic.b	#LOCKLPM5, &PM5CTL0		; enable Digital I/O
;Setup Timer B0 (16-bit register)
			bis.w	#TBCLR, &TB0CTL			; initially clears timer
			bis.w	#TBSSEL__ACLK, &TB0CTL	; select ACLK as source
			bis.w	#MC__CONTINUOUS, &TB0CTL; assert continuous mode
			bis.w	#CNTL_1, &TB0CTL		; set timer to 12-bit mode
;Setup IRQ
			bis.w	#TBIE, &TB0CTL			; local enable for timer overflow
			eint							; globally enable interrupts
			bic.w	#TBIFG, &TB0CTL			; clear flag

main:
			jmp		main

;-------------------------------------------------------------------------------
; Interrupt Service Routine
;-------------------------------------------------------------------------------
ISR_TB0_12Bit_Overflow:
			xor.b	#BIT0, &P1OUT			; toggle LED1
			bic.w	#TBIFG, &TB0CTL			; clear flag
			reti
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
            
            .sect	".int42"
            .short	ISR_TB0_12Bit_Overflow
