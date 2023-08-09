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
			bis.b	#BIT0, &P1DIR			; set P1DIR(0) to O/P
			bic.b	#BIT0, &P1OUT			; set initial value of LED1 = OFF

			bic.b	#BIT1, &P4DIR			; set P4DIR(1) to I/P
			bis.b	#BIT1, &P4REN			; enable pull up/down resistor P4REN(1)
			bis.b	#BIT1, &P4OUT			; configure resistor as pull up

			bis.b	#LOCKLPM5, &PM5CTL0		; turn on Digital IO


main:
			bit.b	#BIT1, &P4IN			; compare P4.1 with 1
			jz		toggle					; if P4IN == 1, Toggle LED1

			jmp		main

toggle:
			bis.b	#BIT0, &P1OUT			; turn on LED1 (P1.0)
			bic.b	#BIT0, &P1OUT			; turn off LED1

			jmp		main


                                            

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
            
