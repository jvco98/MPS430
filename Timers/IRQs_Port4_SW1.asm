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
;---- setup ports
			bis.b	#BIT0, &P1DIR			; set P1.0 to O/P (LED1)
			bic.b	#BIT0, &P1OUT			; initially set LED1 off

			bic.b	#BIT1, &P4DIR			; set P4.1 to I/P (SW1)
			bis.b	#BIT1, &P4REN			; enable pull up/down resistor
			bis.b	#BIT1, &P4OUT			; set pull up resistor

			bis.b	#BIT1, &P4IES			; assert IRQ sens to HI-to-LO

			bic.b	#LOCKLPM5, &PM5CTL0		; enable Digital I/O

;---- setup IRQ for SW1
			bis.b	#BIT1, &P4IE			; locally enable interrupts for SW1
			eint							; globally enable interrupts
			bic.b	#BIT1, &P4IFG			; clear flag

;---- setup timer
			bis.w	#TBCLR, &TB0CTL			; clear timer
			bis.w	#TBSSEL__ACLK, &TB0CTL	; select ACLK as source
			bis.w	#ID__8, &TB0CTL			; divide clock source by 8 (4kHz)
			bis.w	#MC__CONTINUOUS, &TB0CTL ; assert continuous count mode

;---- setup capture
			bis.w	#CAP, &TB0CCTL0			; select capture mode
			bis.w	#CM__BOTH, &TB0CCTL0	; capture on both edges
			bis.w	#CCIS__GND, &TB0CCTL0	; initially set input signal to GND

;----- init R4
			mov.w	#0, R4					; clear R4
                                            
main
			jmp		main
;-------------------------------------------------------------------------------
; Interrupt Service Routine
;-------------------------------------------------------------------------------
ISR_SW1:
			xor.b	#BIT0, &P1OUT			; toggle LED1
			xor.w	#CCIS0, &TB0CCTL0		; cause capture
			mov.w	#TB0CCR0, R4			; store value in R4
			bic.b	#BIT1, &P4IFG			; clear flag
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
            
            .sect   ".int22"                ; P4 Vector
            .short  ISR_SW1
