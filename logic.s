.section .init
.globl	go

go:
	b	logic
	
.section .text
logic:
	mov	sp, #0x8000
	bl	EnableJTag
	
	mov	r1,	#1
	ldr	r0,	=gameState
	str	r1,	[r0]
	
	//bl	initMap
	
	ldr	r1,	=mapArray	//Load mapArray address
	add	r1,	#30
	lsl	r1,	#2
looping:
	bl	initSnesController	//Fix the name later	
	//Will be getting input value from r0
	
	
	mov	r3,	r0		//Move input value into r3
	

checkRight:
	ldr	r6,	=moveRight
	ldr	r5,	[r6]
	cmp	r3,	r5
	bne	checkLeft
	
	bl	right
	b	looping
	
checkLeft:



haltLoop$:
	b	haltLoop$

//*****************************
//This is for moving only

right:
	push	{lr}
	mov	r2,	r1
	lsl	r2,	#2	//Multiply by 4. Add to r1
	
	ldr	r4,	[r2]
	
	cmp	r4,	#0
	bl	validMoveRight
	
	cmp	r4,	#1
	bl	invalidMove
	
	cmp	r4,	#5
	beq	invalidMove
	
	pop	{lr}
	bx	lr
	
validMoveRight:
	push	{lr}
	ldr	r7,	[r1]		//Load player number 3 into r7
	str	r7,	[r1,	r2]!	//Changing r1 to new position to the right
	//bl	decMove
	//bl	fillSpaceLeft
	pop	{lr}
	bx	lr
	
invalidMove:
	push	{lr}
	//Dont need to store anything. just branch back to the check stuff
	pop	{lr}
	bx	lr	


//*****************************		
	
	
	
.section .data

gameState:	.byte	0	//Setting default game state


.EQU		moveRight,	0b1111111101111111


mapArray:
.int	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.int	1,0,0,0,0,0,0,0,5,0,0,0,0,0,0,1
.int	1,0,1,1,1,0,1,0,1,1,1,1,1,1,0,1
.int	1,0,1,4,1,0,1,0,1,0,0,0,0,1,0,1
.int	1,0,1,0,1,0,1,0,5,0,1,0,0,1,0,1
.int	1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1
.int	1,0,0,0,0,0,1,0,1,0,1,0,0,1,0,1
.int	1,1,1,1,1,1,1,5,1,0,1,0,1,1,0,1
.int	1,4,0,0,0,0,1,0,1,0,1,0,5,0,0,1
.int	1,1,1,1,1,0,1,0,1,0,1,0,1,1,1,1
.int	1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1
.int	1,0,1,1,1,1,1,0,1,0,1,1,1,1,0,1
.int	1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1
.int	1,1,1,1,1,1,1,0,1,1,1,1,0,1,0,1
.int	1,3,0,0,0,0,0,0,1,4,0,0,0,1,0,1
.int	1,1,1,1,1,1,1,1,1,1,1,1,1,1,6,1

