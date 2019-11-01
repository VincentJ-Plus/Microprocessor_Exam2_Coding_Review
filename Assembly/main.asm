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
		.data			; define the numbers and store in the memory
x:		.word 0x1111	; 0x2400-0x2404
y:		.word 0x2222
z: 		.word 0x3333

		.text
		mov.w x, R4		; assign x value to R4
		mov.w y, R5		; assign y value to R5
		mov.w z, R6
		inc.w R4		; execute f=x+1
		inc.w R5		; execute g=y+1
		inc.w R6		; execute h=z+1
		call #Logic_AND	; call the subroutine to execute the logic operation
		jmp OVER
Logic_AND:
		mov.w R4, R7	; assign R4(f) to R7
		and.w R5, R7	; execute R7(f) AND R5(g)
		and.w R6, R7	; execute R7(f and g) AND R6(h)
		ret
OVER:
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
            
