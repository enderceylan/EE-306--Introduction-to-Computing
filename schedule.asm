
.ORIG x3000	;start program at x3000

;initializations
LDI R1, L1	     ;R1 = requests starting at x3200
LDI R2, L2	    ;R2 = room states starting at x3100
AND R3, R3, #0	;R3 = contains start requested by R1
AND R4, R4, #0	;R4 = contains end requested by R1
AND R5, R5, #0	;R5 = contains user ID of R1
LD R6, L1
LOOP AND R0, R0, #0	;R0 = extra counter

;initializing R3
ADD R0, R0, #-5	  ;counter = -5
LDR R7, R6, #0	  ;R7 = R1
B2 ADD R7, R7 #0
BRzp B1		        ;if first digit is 0, go to B1
ADD R3, R3, #1	  ;first digit = 1
B1 ADD R0, R0, #1	;counter++
ADD R0, R0, #0
BRzp BBB
ADD R3, R3, R3    ;shift R3 left
ADD R7, R7, R7	  ;shift R7 left
ADD R0, R0, #0
BRn B2		        ;go to B2 until counter = 0
BBB LD R0, MASK1
AND R3, R3, R0

;initializing R4
AND R0, R0, #0
ADD R0, R0, #-5	;counter = -5
ADD R7, R7, R7	;shift R7 left
C2 ADD R7, R7 #0
BRzp C1		;if first digit is 0, go to C1
ADD R4, R4, #1	;first digit = 1
C1 ADD R0, R0, #1	;counter++
ADD R0, R0, #0
BRzp CCC
ADD R4, R4, R4; shift R4 left
ADD R7, R7, R7	;shift R7 left
ADD R0, R0, #0
BRn C2		;go to C2 until counter = 0
CCC LD R0, MASK1
AND R4, R4, R0

;initializing R5
AND R0, R0, #0
ADD R0, R0, #-6	;counter = -6
ADD R7, R7, R7	;shift R7 left
D2 ADD R7, R7 #0
BRzp D1		;if first digit is 0, go to D1
ADD R5, R5, #1	;first digit = 1
D1 ADD R0, R0, #1	;counter++
ADD R0, R0, #0
BRzp DDD
ADD R5, R5, R5; shift R5 left
ADD R7, R7, R7	;shift R7 left
ADD R0, R0, #0
BRn D2		;go to D2 until counter = 0
DDD: LD R0, MASK2
AND R5, R5, R0

;go to start time requested
AND R7, R7, #0
LD R7, L2
AND R0, R0, #0
ADD R0, R0, R3
T1: LDR R2, R7, #1
ADD R7, R7, #1
ADD R0, R0, #-1
BRnp T1
AND R0, R0, #0

;check if room occupied
ST R2, COPY2
ST R5, COPY5
ST R3, COPY3
ST R4, COPY4
ST R0, COPY0
ST R6, COPY6
ST R7, COPY7
CHECK LDR R2, R7, #0	;check R2
BRnp SKIPTIME1	;if time occupied (R2!=x0000), go to SKIPTIME1
ADD R7, R7, #1
ADD R3, R3, #1	;start++
NOT R0, R3	;invert R3
ADD R0, R0, #1	;R3 = -R3
ADD R6, R4, R0	;R6 = R4-R0 (end-start)
BRp CHECK	;if start < end, go to CHECK
BRnzp SKIPCHECK

;check if room occupied by same user
SKIPTIME1 LD R2, COPY2
LD R3, COPY3
LD R4, COPY4
LD R0, COPY0
LD R6, COPY6
LD R7, COPY7
LD R5, COPY5
TOP: LDR R2, R7, #0	;check R2
AND R6, R6, #0
ADD R7, R7, #1
ADD R2, R2, #0
BRz BYPASS	;skip check if slot is empty
NOT R0, R2	;invert R2
ADD R0, R0, #1	;R2 = -R2
ADD R6, R5, R0	;R6 = R5-R2 (compare IDs)
BRnp SKIPTIME2	;if IDs different, go to SKIPTIME2
BYPASS AND R0, R0, #0
ADD R3, R3, #1
NOT R0, R3	;invert R3
ADD R0, R0, #1	;R3 = -R3
ADD R6, R4, R0	;R6 = R4-R0 (end-start)
BRp TOP	;if start < end, go to TOP

;change statuses
SKIPCHECK: LD R2, COPY2
LD R3, COPY3
LD R4, COPY4
LD R5, COPY5
LD R0, COPY0
LD R6, COPY6
LD R7, COPY7
AND R0, R0, #0
NEXTTIME STR R5, R7, #0;if time unoccupied, store ID in current room
AND R6, R6, #0
ADD R7, R7, #1
LDR R2, R7, #1	;go to next time requested
ADD R3, R3, #1	;start++
ST R3, COPY1
NOT R0, R3	;invert R3
ADD R0, R0, #1	;R3 = -R3
ADD R6, R4, R0	;R3 = R4-R0 (end-start)
BRp NEXTTIME	;if start < end, go to NEXTTIME

;next request
SKIPTIME2 LD R6, COPY6
ADD R6, R6, #1
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
LDR R1, R6, #0	;R1 = next request
BRnp LOOP	;go back to start of loop if R1 != x0000
DONE TRAP x25	;halt

;labels
L1 .FILL x3200
L2 .FILL x3100
MASK1 .FILL x001F ;mask 00000 000000 11111
MASK2 .FILL x003F ;mask 00000 00000 111111
COPY1 .BLKW 1		;reserve one word
COPY2 .BLKW 1
COPY3 .BLKW 1
COPY4 .BLKW 1
COPY5 .BLKW 1
COPY0 .BLKW 1
COPY6 .BLKW 1
COPY7 .BLKW 1
.END		;end program
