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
;---- Setup LED
			bis.b	#BIT0, &P1DIR			; set P1.0 to O/P (LED1)
			bic.b	#BIT0, &P1OUT			; initially turn LED1 off
			bic.b	#LOCKLPM5, &PM5CTL0		; enable Digital I/O
;---- Setup timer B0 (16-bit register)
			bis.w	#TBCLR, &TB0CTL			; clear timer
			bis.w	#TBSSEL__ACLK, &TB0CTL	; select ACLK clock source
			bis.w	#MC_1, TB0CTL			; select UP mode
;---- Setup compares
			mov.w	#32768, &TB0CCR0		; CCR0 = 32,768
			mov.w	#1638, &TB0CCR1			; CCR1 = 1,638
;---- Setup IRQs
			bis.w	#CCIE, &TB0CCTL0		; locally enable interrupts for CCR0
			bic.w	#CCIFG, &TB0CCTL0		; clear CCR0 interrupt flag

			bis.w	#CCIE, &TB0CCTL1			; locally enable interrupts for CCR1
			bic.w	#CCIFG, &TB0CCTL1		; clear CCR1interrupt flag

			eint							; globally enable interrupts
main:
			jmp		main

;-------------------------------------------------------------------------------
; Interrupt Service Routine
;-------------------------------------------------------------------------------
ISR_TB0_CCR0:
			bis.b	#BIT0, &P1OUT			; toggle LED1
			bic.w	#CCIFG, &TB0CCTL0		; clear CCR0 interrupt flag
			reti

ISR_TB0_CCR1:
			bic.b	#BIT0, &P1OUT			; toggle LED1
			bic.w	#CCIFG, &TB0CCTL1		; clear CCR1interrupt flag
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
            
            .sect   ".int43"				; CCR0 Vector
            .short  ISR_TB0_CCR0

            .sect   ".int42"                ; CCR1 Vector
            .short  ISR_TB0_CCR1
