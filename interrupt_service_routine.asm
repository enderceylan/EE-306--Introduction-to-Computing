; to be used in conjunction with user_program.asm

.ORIG x1500

ST R0, SAVER0
ST R1, SAVER1
ST R2, SAVER2
ST R3, SAVER3
ST R4, SAVER4
ST R5, SAVER5
ST R6, SAVER6

AND R2, R2, #0
AND R3, R3, #0

LDI R1, KBSR
LDI R0, KBDR

NOT R2, R0
ADD R2, R2, #1
LD R4, A
ADD R3, R2, R4
BRp END

LD R4, Z
ADD R3, R2, R4
BRn END

AND R4, R4, #0
ADD R4, R4, #10
LOOP1 LDI R1, DSR
STI R0, DDR
ADD R4, R4, #-1
BRp LOOP1

LD R5, LOWER
ADD R0, R0, R5

AND R4, R4, #0
ADD R4, R4, #10
LOOP2 LDI R1, DSR
STI R0, DDR
ADD R4, R4, #-1
BRp LOOP2

LD R0, BREAK
LDI R1, DSR
STI R0, DDR


END LD R0, SAVER0
LD R1, SAVER1
LD R2, SAVER2
LD R3, SAVER3
LD R4, SAVER4
LD R5, SAVER5
LD R6, SAVER6
RTI

KBSR	.FILL xFE00
KBDR	.FILL xFE02
DSR	.FILL xFE04
DDR	.FILL xFE06
A	.FILL x0041
Z	.FILL x005A
LOWER	.FILL #32
BREAK	.FILL x000A

SAVER0	.BLKW 1
SAVER1	.BLKW 1
SAVER2	.BLKW 1
SAVER3	.BLKW 1
SAVER4	.BLKW 1
SAVER5	.BLKW 1
SAVER6	.BLKW 1
SAVER7	.BLKW 1

.END