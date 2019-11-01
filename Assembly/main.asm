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
			.data			; define the three part score and store in the memory
Exam:		.word 90		; assume the values
Lab:		.word 95
Homework: 	.word 95
        	.text
        	mov.w Exam, R4
        	mov.w Lab, R5
        	mov.w Homework, R6
        	mov.w R4, &MPY 		; Load 1st operand Exam value
			mov.w #60 ,&OP2 	; Load 2nd operand equals Exam*60
			mov.w RESLO, R12	; assign result to R12
        	mov.w R5, &MPY 		; Load 1st operand Lab value
			mov.w #20 ,&OP2 	; Load 2nd operand equals Lab*20
			mov.w RESLO, R13	; assign result to R13
        	mov.w R6, &MPY 		; Load 1st operand Homework value
			mov.w #20 ,&OP2 	; Load 2nd operand equals Homework*20
			mov.w RESLO, R14	; assign result to R14
			clr.w R8			; ready for storing
			add.w R12, R8		; add operation
			add.w R13, R8
			add.w R14, R8		; Put the total grade in R8

			cmp.w #9000, R8		; compare the score
			jge LEVEL_A
			cmp.w #8000, R8		; compare the score
			jge LEVEL_B
			cmp.w #7000, R8		; compare the score
			jge LEVEL_C
			cmp.w #6000, R8		; compare the score
			jge LEVEL_D
			jl	LEVEL_E

; Put the letter grade in R9
LEVEL_A:	mov.w #4, R9		; represent that you got a A
			jmp OVER
LEVEL_B:	mov.w #3, R9		; represent that you got a B
			jmp OVER
LEVEL_C:	mov.w #2, R9		; represent that you got a C
			jmp OVER
LEVEL_D:	mov.w #1, R9		; represent that you got a D
			jmp OVER
LEVEL_E:	mov.w #0, R9		; represent that you got a E

OVER:		jmp $				; now the program is end
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
            
