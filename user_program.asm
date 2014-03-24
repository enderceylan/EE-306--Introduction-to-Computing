; to be used in conjunction with interrupt_service_routine.asm

.ORIG x3000

; initialize the stack pointer
LD R6, PRELOAD	;set R6 to x3000, indicating an empty stack

; set up the keyboard interrupt vector table entry
LD R1, ISR
STI R1, VECTOR

; enable keyboard interrupts
LD R2, A
STI R2, KBSR

; start of actual user program to print Texas checkerboard
LOOP LEA R0, LINE1
TRAP x22
LD R0, BREAK
TRAP x21
JSR DELAY
LEA R0, LINE2
TRAP x22
LD R0, BREAK
TRAP x21
BRnzp LOOP

TRAP x25

LINE1	.STRINGZ "Texas       Texas       Texas       Texas"
LINE2	.STRINGZ "       Texas       Texas       Texas"
BREAK	.FILL x000A
PRELOAD .FILL x3000
VECTOR	.FILL x0180
ISR	.FILL x1500
KBSR 	.FILL xFE00
A	.FILL x4000

;delay code
DELAY   ST  R1, SaveR1
        LD  R1, COUNT
REP     ADD R1,R1,#-1
        BRp REP
        LD  R1, SaveR1
        RET
COUNT   .FILL x7FFF
SaveR1  .BLKW 1

.END
