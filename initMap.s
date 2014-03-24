.section .init
.globl initMap
/*
LEGEND:
pp = player position = 3
wl = wall location = 1
hl = hall location = 0
kl = key location = 4
dl = door location = 5
edl = exit door location = 6
*/


initMap:
	ldr	r0, =mapArray
	
	bx	lr

haltLoop$:
	b	haltLoop$

.section .data

mapArray:
.byte	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte	1,0,0,0,0,0,0,0,5,0,0,0,0,0,0,1
.byte	1,0,1,1,1,0,1,0,1,1,1,1,1,1,0,1
.byte	1,0,1,4,1,0,1,0,1,0,0,0,0,1,0,1
.byte	1,0,1,0,1,0,1,0,5,0,1,0,0,1,0,1
.byte	1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1
.byte	1,0,0,0,0,0,1,0,1,0,1,0,0,1,0,1
.byte	1,1,1,1,1,1,1,5,1,0,1,0,1,1,0,1
.byte	1,4,0,0,0,0,1,0,1,0,1,0,5,0,0,1
.byte	1,1,1,1,1,0,1,0,1,0,1,0,1,1,1,1
.byte	1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1
.byte	1,0,1,1,1,1,1,0,1,0,1,1,1,1,0,1
.byte	1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1
.byte	1,1,1,1,1,1,1,0,1,1,1,1,0,1,0,1
.byte	1,3,0,0,0,0,0,0,1,4,0,0,0,1,0,1
.byte	1,1,1,1,1,1,1,1,1,1,1,1,1,1,6,1
