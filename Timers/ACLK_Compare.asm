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
; setup LED
			bis.b	#BIT0, &P1DIR			; set P1.0 to O/P (LED1)
			bic.b	#BIT0, &P1OUT			; initially turn LED1 off
			bic.b	#LOCKLPM5, PM5CTL0		; enable digital I/O
; setup timer B0
			bis.w	#TBCLR, &TB0CTL			; clear timer
            bis.w	#TBSSEL__ACLK, &TB0CTL	; choose ACLK as source
            bis.w	#MC__UP, &TB0CTL		; select UP mode
; setup compare
			mov.w	#16384, &TB0CCR0 		; setup compare value
			bis.w	#CCIE, &TB0CCTL0		; locally enable interrupts
			eint							; globally enable interrupts
			bic.w	#CCIFG, &TB0CCTL0       ; clear flag
main:
			jmp		main
;-------------------------------------------------------------------------------
; Interrupt Service Routine
;-------------------------------------------------------------------------------
ISR_TB0_CCR0:
			xor.b	#BIT0, &P1OUT			; toggle LED1
			bic.w	#CCIFG, &TB0CCTL0       ; clear compare flag
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
            
            .sect   ".int43"                ; TB0 compare Vector
            .short  ISR_TB0_CCR0
