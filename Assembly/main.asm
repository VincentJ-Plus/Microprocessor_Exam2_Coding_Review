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
			.data			; define the grades group
			; assume the values
			; store min in R7
			; store max in R8
GRADES:		.word 90, 95, 87, 77, 79, 59, 99, 0	; set 0 as the end flag
        	.text
        	mov.w #GRADES, R4	; set R4 as a pointer
        	mov.w @R4, R7		; set R7 as a temporary register to store min value
			mov.w @R4, R8		; set R5 as a temporary register to store max value
			; to find the max value
COMP1:		cmp.w @R4+, R8		; after comparing, R4 point to next value
			jl SWAP1			; jump to move the larger number to R8
			mov.w @R4, R6
			cmp.w #0, R6		; detective if the pointer had pointed to the flag(end)
			jeq SET_R4			; if so ,jump to get the min value
			jmp COMP1
SWAP1:		decd.w R4
			mov.w @R4+, R8		; now the larger number has been assigned
			mov.w @R4, R6
			cmp.w #0, R6		; detective if the pointer had pointed to the flag(end)
			jeq SET_R4			; if so ,jump to get the min value
			jmp COMP1
			; to find the min value
SET_R4:		mov.w #GRADES, R4	; R4's value has changed, so reset R4
COMP2:		cmp.w @R4+, R7		; after comparing, R4 point to next value
			jge SWAP2			; jump to move the larger number to R5
			mov.w @R4, R6
			cmp.w #0, R6		; detective if the pointer had pointed to the flag(end)
			jeq OVER			; if so ,jump to OVER
			jmp COMP2
SWAP2:		decd.w R4
			mov.w @R4+, R7		; now the lower number has been assigned
			mov.w @R4, R6
			cmp.w #0, R6		; detective if the pointer had pointed to the flag(end)
			jeq OVER			; if so ,jump to OVER
			jmp COMP2

OVER:		jmp $

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
            
