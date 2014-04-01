.section    .init
.globl     _starting

_starting:
    b       main
    
.section .text
.globl main
main:
	mov     sp, #0x8000			// initialize sp
	bl		EnableJTAG			// branch link
	bl		InitFrameBuffer		// branch link
	mov		r12,	#900		// move 900 into r12
	mov		r7,	#0				// initialize number of keys
	mov		r8,	#150			// initialize number of actions (steps)
	mov		r10,	#0			// move 0 into r10
	mov		r11,	#0		//Game state set to 0 (game not won yet)

.globl loopStartMenu
loopStartMenu:
	bl controllerInit			// branch link
	mov r9, r0					// move button address into r9
	bl InitFrameBuffer			// branch link
	bl startMenu				// branch link
	b loopStartMenu				// branch

attempt1:
	bl 		controllerInit		// branch link
	mov		r9,	r0				// move button address into r9
	bl		InitFrameBuffer		// branch link
	bl		rerun				// branch link
	cmp		r12,	#900		// compare r12 and 900
	beq		loopStartMenu		// branch if equal
	b		attempt1			// branch

.globl loopMain
loopMain:
	bl drawMap					// branch link
	bl printactionkeys			// branch link
	bl actionKeys				// branch link
	cmp	r7,	#1					// compare if you have one key
	beq		oneKey				// branch if equal
	bl		printZero			// branch link
	b		nexter				// branch
oneKey:
	bl		printOne			// branch link
nexter:
	cmp	r12,	#1016			// compare r12 with 1016
	beq	attempt					// branch if equal
	bl controllerInit			// branch link
	mov		r9,	r0				// move button address into r9
	bl		InitFrameBuffer		// branch link
	ldr		r4,	=startButton	// load startButton value
	cmp		r9,	r4				// compare button pressed with value
	beq		pausing				// branch if equal
	bl redraw					// branch link
	b	loopMain				// branch
pausing:
	bl	box						// branch link
	bl	pointerR				// branch link
	bl	pauseMe					// branch link
	//bl	winScreen
	mov	r10,	#0				// move 0 to r10

going:
	bl	controllerInit			// branch link
	mov	r9,	r0					// move button address into r9
	bl	InitFrameBuffer			// branch link
	b checker					// branch

checker:
	ldr	r4,	=moveUp				// load moveUp value
	cmp	r9,	r4					// compare pressed button with moveUp value
	bne	downs					// branch if not equal
	mov	r10,	#0				// mov 0 to r10
	bl	pointerR				// branch link
	b	going					// branch
downs:
	ldr	r4,	=moveDown			// load moveDown value
	cmp	r9,	r4					// compare pressed button with moveDown value
	bne	as						// branch if not equal
	mov	r10,	#1				// move 1 to r10
	bl	pointerM				// branch link 
	b	going					// branch
as:
	ldr	r4,	=pressedA			// load pressedA value
	cmp	r9,	r4					// compare pressed button with pressedA value
	bne	starts					// branch if not equal
	cmp	r10,	#0				// compare 0 to r10
	bne	aser2					// branch if not equal
	bl	rerun					// branch link
	mov	r12,	#900			// move 900 to r12
	b	loopMain				// branch

aser2:	
	b	loopStartMenu			// branch

starts:
	ldr	r4,	=startButton		// load startButton value
	cmp	r9,	r4					// compare pressed button with startButton value
	bne	going					// branch if not equal
	mov	r3,	#0					// move 0 to r3
	b	loopMain				// branch
	
attempt:
	bl 		controllerInit		// branch link
	mov		r9,	r0				// move button address into r9
	bl		InitFrameBuffer		// branch link
	bl		rerun				// branch link
	cmp		r12,	#900		// compare r12 to 900
	beq		loopMain			// branch if equals
	
	//NOTE THAT WHEN r12 != #900 IT WILL KEEP GOING TO THE WIN CONDITION
	//cmp		r11,	#0
	//beq		loseCondition
	//b		attempt				// branch

winCondition:
	bl	blankScreen
	bl	win
	b	waiting

.globl	loseCondition
loseCondition:
	bl	blankScreen
	bl	lose
	b	waiting
	
waiting:
	bl 		controllerInit		// branch link
	mov		r9,	r0				// move button address into r9	
	ldr		r0, 	=nothingPress
	cmp		r9,	r0
	beq		waiting
	b	loopStartMenu

.globl haltLoop$
haltLoop$:
	b	haltLoop$				// end program, basically

.section .data


.EQU		moveUp,		0xffef
.EQU		moveDown, 	0xffdf
.EQU		pressedA, 	0xfeff
.EQU		startButton,	0xfff7
.EQU		nothingPress, 	0xffff
