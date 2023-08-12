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
;setup LEDs
			bis.b	#BIT0, &P1DIR			; set P1.0 to O/P (LED1)
			bis.b	#BIT6, &P6DIR			; set P6.6 to O/P (LED2)
			bic.b	#BIT0, &P1OUT			; initially turn LED1 off
			bis.b	#BIT6, &P6OUT			; initially turn LED2 on

			bic.b	#LOCKLPM5, &PM5CTL0		; enable Digital I/O
;setup timer
			bis.w	#TBCLR, &TB0CTL			; clear timer
			bis.w	#TBSSEL__SMCLK, &TB0CTL	; select 1MHz clock source
			bis.w	#ID_2, &TB0CTL			; divide clock source by 4
			bis.w	#MC__CONTINUOUS, &TB0CTL; assert continuous mode
;setup interrupts
			bis.w	#TBIE, &TB0CTL			; locally enable interrupts
            bic.w	#TBIFG, &TB0CTL			; clear interrupt flag
            eint							; globally enable interrupts
main:
			jmp		main
;-------------------------------------------------------------------------------
; Interrupt Service Routine
;-------------------------------------------------------------------------------
ISR_TB0_OVERFLOW_DIV4:
			xor.b	#BIT0, &P1OUT			; toggle LED1
			xor.b	#BIT6, &P6OUT			; toggle LED2
			bic.w	#TBIFG, &TB0CTL			; clear interrupt flag
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
            
            .sect   ".int42"                ; TB0 Vector
            .short  ISR_TB0_OVERFLOW_DIV4
