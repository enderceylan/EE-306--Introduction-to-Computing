;start at x3000 and reset all registers

.ORIG x3000

AND R0, R0, #0	;IN/OUT
AND R1, R1, #0

AND R2, R2, #0
	;ID requested
AND R3, R3, #0	;pointer to root
AND R4, R4, #0
  ;ID of node
AND R5, R5, #0
	;letter in name
AND R6, R6, #0

AND R7, R7, #0



;prompt for a student ID

LOOP LEA R0, PROMPT

TRAP x22	;OUT

TRAP x20	;get input

TRAP x21
JSR CHECKFORD
ADD R2, R0, #0
TRAP x20	;<Enter>
TRAP x21
BRnzp NOTD
YESD TRAP x20
TRAP x21
BRnzp END
NOTD LD R1, MINUS
ADD R2, R2, R1	;convert ASCII to decimal



;search the directory
AND R1, R1, #0
LDI R3, START	;point to first root
LOOP2 LDR R4, R3, #2	;R4 = ID of node
JSR ENDPOINT

;check if R4=R2
CONTINUE NOT R5, R2
ADD R5, R5, #1
ADD R5, R5, R4
BRp NEXTNODE1
BRn NEXTNODE2

;R4=R2, return name then go back to LOOP
LDR R0, R3, #3	;load first letter
TRAP x22
AND R0, R0, #0
ADD R0, R0, x0A
TRAP x21
BRnzp LOOP

;R4>R2, go to left child
NEXTNODE1 AND R5, R5, #0
LDR R3, R3, #0
BRnzp LOOP2

;R4<R2, go to right child
NEXTNODE2 AND R5, R5, #0
LDR R3, R3, #1
BRnzp LOOP2

;end of program
END TRAP x25	;HALT


PROMPT .STRINGZ "Type a student ID and press Enter:"

NONE .STRINGZ "No Entry"

START .FILL x3300
MINUS .FILL #-48
INPUT .BLKW 2

ENTRY .FILL x4000

D .FILL x64


;check if input is d, end loop if true
CHECKFORD
LD R5, D

NOT R5, R5

ADD R5, R5, #1

ADD R6, R0, R5

BRz YESD
AND R5, R5, #0
AND R6, R6, #0
RET

;check if name = null
ENDPOINT
LDR R7, R3, #3
BRnp CONTINUE
LEA R0, NONE
TRAP x22
AND R0, R0, #0
ADD R0, R0, x0A
TRAP x21
BRnzp LOOP
RET

.END

