.section    .init
//**************************************
.globl	pauseMe
pauseMe:
	push 		{lr}				// push
	bl		InitFrameBufferPrint	// branch link
	mov		r0,	#320				// initialize x value
	mov		r3, 	#100			// initialize y value
	ldr		r2, 	=pause			// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#200				// initialize x value
	mov		r3,	#180				// initialize y value
	ldr		r2,	=restart			// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#200				// initialize x value
	mov		r3,	#240				// initialize y value
	ldr		r2,	=backToMain			// load address into r2
	bl		charDraw				// branch link
    	pop		{lr}				// pop
    	bx		lr					// pop
//**************************************

//**************************************
.globl	startMe
startMe:
	push 		{lr}				// push
	bl		InitFrameBufferPrint	// branch link
	
	mov		r0,	#360				// initialize x value
	mov		r3, 	#150			// initialize y value
	ldr		r2, 	=title			// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#340				// initialize x value
	mov		r3, 	#200			// initialize y value
	ldr		r2, 	=richard		// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#340				// initalize x value
	mov		r3, 	#250			// initialize y value
	ldr		r2, 	=emily			// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#340				// initialize x value
	mov		r3, 	#300			// initialize y value
	ldr		r2, 	=melissa		// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#200				// initialize x value
	mov		r3, 	#380			// initialize y value
	ldr		r2, 	=start			// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#200				// initialize x value
	mov		r3, 	#580			// initialize y value
	ldr		r2, 	=quitGame		// load address into r2
	bl		charDraw				// branch link
    	pop		{lr}				// pop
    	bx		lr					// pop
//**************************************
.globl printactionkeys
printactionkeys:
	push 		{lr}				// push
	bl		InitFrameBufferPrint	// branch link
	mov		r0,	#140				// initialize x value
	mov		r3, 	#15				// initialize y value
	ldr		r2, 	=movesRemain	// load address into r2
	bl		charDraw				// branch link
	
	mov		r0,	#540				// initialize x value
	mov		r3,	#15					// initialize y value
	ldr		r2,	=keysOwned			// load address into r2
	bl		charDraw				// branch link
	
    	pop		{lr}				// pop
    	bx		lr					// pop
//**************************************
.globl actionKeys
actionKeys:
	push {lr}						// push
	bl InitFrameBufferPrint			// branch link
	mov r0, #440					// move 440 into r0
	mov r3, #15						// move 15 into r3
	ldr r2, =one					// load address into r2
	bl charDraw						// branch link
	mov r0, #456					// move 456 into r0
	mov r3, #15						// move 15 into r3
	ldr r2, =five					// load address into r2
	bl charDraw						// branch link
	mov r0, #472					// move 472 into r0
	mov r3, #15						// move 15 into r3
	ldr r2, =zero					// load address into r2
	bl charDraw						// branch link

	pop {lr}						// pop
	bx lr							// pop

//**************************************
.globl printOne
printOne:
	push 	{r1, r2, r3, r7, lr}	// push
	bl		InitFrameBufferPrint	// branch link
	mov		r0, #760				// initialize x value
	mov 	r3, #15					// initialize y value
	ldr		r2, =zero				// load address into r2
	bl		charErase				// branch link
	
	mov		r0,	#760				// initialize x value
	mov		r3, 	#15				// initialize y value
	ldr		r2, 	=one			// load address into r2
	bl		charDraw				// branch link
	pop		{r1, r2, r3, r7, lr}	// pop
    bx		lr						// pop

.globl printZero	
printZero:
	push 	{r1, r2, r3, r7, lr}	// pop
	bl		InitFrameBufferPrint	// branch link
	mov		r0, #760				// initialize x value
	mov 	r3, #15					// initialize y value
	ldr		r2, =one				// load address into r2
	bl		charErase				// branch link

	mov		r0,	#760				// initialize x value
	mov		r3, 	#15				// initialize y value
	ldr		r2, 	=zero			// load address into r2
	bl		charDraw				// branch link
    pop		{r1, r2, r3, r7, lr}	// pop
    bx		lr						// pop

//**************************************
.globl	win
win:
	push 		{lr}				// push
	bl		InitFrameBufferPrint	// branch link

	mov		r0,	#260				// initialize x value
	mov		r3,	#300				// initialize y value
	ldr		r2,	=gameWin			// load address into r2
	bl		charDraw				// branch link
	
    	pop		{lr}				// pop
    	bx		lr					// pop
//**************************************

//**************************************
.globl	lose
lose:
	push 		{lr}				// push
	bl		InitFrameBufferPrint	// branch link

	mov		r0,	#220				// initialize x value
	mov		r3,	#300				// initialize y value
	ldr		r2,	=gameLose			// load address into r2
	bl		charDraw				// branch link
	
    	pop		{lr}				// pop
    	bx		lr					// pop
//**************************************
.globl	charDraw
charDraw:
	push	{r4-r8,r12, lr}			// push

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr,	=font			// load the address of the font map
	mov		r9,	#0					//Offset for the next character in string
	mov		r12,	r0				//Move y coordinate to r12
	
	mov		r10,	r3				//Move the y coordinate to r10
	mov		r3,	r1					//Moving the color to r3
	mov		r11,	r2				//Address of string...

changeCoord:
	mov		py,	r10					//Set the y coordinate
	mov		r1,	r11					//move r11 into r1
	ldrb	r0,	[r1, r9]			// load into r0
	add		r9,	#1					//Change offset by 1
	lsl		r9,	#4					//Times the offset by 8
	ldr		chAdr,	=font			// load the address of the font map
	add		chAdr,	r0,	lsl #4
	
	
	
charLoop$:
	mov		px,	r12					//Set the x coordinate
	add		px,	r9					//Changing the placement of the next character on the x axis
	mov		mask,	#0x01			// set the bitmask to 1 in the LSB
	ldrb	row,	[chAdr], #1		// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask			// test row byte against the bitmask
	beq		noPixel$				// branch if equal
	mov		r0,		px
	mov		r1,		py
	ldr		r2, 	=0xFFFF00		// yellow
	bl		DrawPixel2				// draw red pixel at (px, py)

noPixel$:
	add		px,		#2				// increment x coordinate by 1
	lsl		mask,	#1				// shift bitmask left by 1
	tst		mask,	#0x100			// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$				// branch if equal
	add		py,	#2					// increment y coordinate by 1
	
	
	tst		chAdr,	#0xF
	bne		charLoop$				// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)
	lsr		r9,	#4					// logical shift right
	sub		r9, 	#1				// subtract r9 by 1
	ldrb	r0,	[r11, r9]			// load char value into r0
	add		r9,	#1					// add r9 by 1
	cmp		r0,	#'\n'				// compare char value with char value of new line
	bne		changeCoord				// branch if not equal
	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	
	pop		{r4-r8,r12, lr}
	bx		lr

//**************************************
.globl	charErase
charErase:
	push	{r4-r8,r12, lr}			// push

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr,	=font			// load the address of the font map
	mov		r9,	#0					//Offset for the next character in string
	mov		r12,	r0				//Move y coordinate to r12
	
	mov		r10,	r3				//Move the y coordinate to r10
	mov		r3,	r1					//Moving the color to r3
	mov		r11,	r2				//Address of string...
changeCoord2:
	
	mov		py,	r10					//Set the y coordinate
	mov		r1,	r11					//move r11 into r1
	ldrb	r0,	[r1, r9]			//load into r0
	add		r9,	#1					//Change offset by 1
	lsl		r9,	#4					//Times the offset by 8
	ldr		chAdr,	=font			// load the address of the font map
	add		chAdr,	r0,	lsl #4		// add to chAdr
	
	
	
charLoop2$:
	mov		px,	r12					//Set the x coordinate
	add		px,	r9					//Changing the placement of the next character on the x axis
	mov		mask,	#0x01			// set the bitmask to 1 in the LSB
	ldrb	row,	[chAdr], #1		// load the row byte, post increment chAdr

rowLoop2$:
	tst		row,	mask			// test row byte against the bitmask
	beq		noPixel2$				// branch if equal
	mov		r0,		px				// move to r0
	mov		r1,		py				// move to r1
	ldr		r2, 	=0x0000			// black
	bl		DrawPixel2				// draw red pixel at (px, py)
noPixel2$:
	add		px,		#2				// increment x coordinate by 1
	lsl		mask,	#1				// shift bitmask left by 1

	tst		mask,	#0x100			// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop2$				// branch if equal
	
	add		py,		#2				// increment y coordinate by 1
	
	
	tst		chAdr,	#0xF
	bne		charLoop2$				// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)
	lsr		r9,	#4					// shift logically to the right
	sub		r9, #1					// subtract by 1
	ldrb	r0,	[r11, r9]			// load character value into r0
	add		r9,	#1					// increment by 1
	cmp		r0,	#'\n'				// compare current letter to that of the new line char
	bne		changeCoord2			// branch if not equal
	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	
	pop		{r4-r8,r12, lr}			// pop
	bx		lr						// pop
	
.section .data

.align 4
font:		.incbin	"font.bin"
title:		.ascii	"Maze Game!\n"
richard:	.ascii	"Richard Huynh\n"
emily:		.ascii	"Emily Chow\n"
melissa:	.ascii	"Melissa Ta\n"
pause:		.ascii	"Pause Menu\n"
restart:	.ascii	"Restart Game?\n"
backToMain:	.ascii	"Back to Main Menu\n"
start:		.ascii	"Start New Game\n"
quitGame:	.ascii	"Quit Game\n"
gameWin:	.ascii	"Congratulations, YOU WIN!\n"
gameLose:	.ascii	"Too bad! You lose. Try again.\n"
printPressA:	.ascii	"Press any button to continue to return to the Main Menu.\n"
movesRemain:	.ascii	"Actions Remaining: \n"
keysOwned:	.ascii	"Keys Owned: \n"
zero:		.ascii	"0\n"
one:		.ascii	"1\n"
five:		.ascii	"5\n"
