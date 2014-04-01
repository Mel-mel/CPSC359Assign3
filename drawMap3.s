.section    .init
.globl drawMap

drawMap:
	push {lr, r7, r8}		// push
	mov		r1, #150		// initializing x
	mov		r2, #60			// initializing y
	bl drawGrid				// draws grid
cont:
	mov	r9,	#0				// move 0 into r9
	ldr r7,	=mapArray		// load address into r7
	mov	r1,	#150			// initialize x value
	mov	r2,	#60				// initialize y value
	mov	r10,#0				// move 0 into r10
	mov r11,r2				// copy r2 into r11
zero:	
	cmp	r10,	#16			// compare r10 and 16
	beq	reint				// branch if equal
	ldr	r8,	[r7,r9]			// load value
	cmp	r8,	#1				// compare value
	bne		one				// branch if not equal
	add	r9,	#4				// add 4 to r9
	ldr		r3,	=0x00FF		// load dark blue colour 
	bl	initColourBlock		// branch link
	add	r1,	#39				// add 39 to r1
	mov	r2,	r11				// move r11 into r2
	add	r10,	#1			// increment r10
	b	zero				// branch
one:
	cmp	r8,	#0				// compare r8 and 0
	bne		three			// branch if not equal
	add	r9,	#4				// add 4 to r9
	ldr		r3,	=0xFFFF		// load white colour
	bl	initColourBlock		// branch link
	add	r1,	#39				// add 39 to r1
	mov	r2,	r11				// move r11 into r2
	add	r10,	#1			// increment r10
	b	zero				// branch
three:
	cmp	r8,	#3				// compare r8 and 3
	bne		four			// branch if not equal
	add	r9,	#4				// add 4 to r9
	ldr		r3,	=0x0F0F		// load magenta colour
	bl	initColourBlock		// branch link
	add	r1,	#39				// add 39 to r1
	mov	r2,	r11				// move r11 into r2
	add	r10,	#1			// increment r10
	b	zero				// branch
four:
	cmp	r8,	#4				// compare r8 and 4
	bne		five			// branch if not equal
	add	r9,	#4				// add 4 to r9
	ldr		r3,	=0xF00F		// load purple
	bl	initColourBlock		// branch link
	add	r1,	#39				// add 39 to r1
	mov	r2,	r11				// move r11 into r2
	add	r10,	#1			// increment r10
	b	zero
five:
	cmp	r8,	#5				// compare r8 and 5
	bne		six				// branch if not equal
	add	r9,	#4				// add 4 to r9
	ldr		r3,	=0x0FFF		// load colour
	bl	initColourBlock		// branch link
	add	r1,	#39				// add 39 to r1
	mov	r2,	r11				// move r11 into r2
	add	r10,	#1			// increment r10
	b	zero				// branch
six:
	add	r9,	#4				// add 4 to r9
	ldr		r3,	=0xFF660	// load colour
	bl	initColourBlock		// branch link
	add	r1,	#39				// add 39 to r1
	mov	r2,	r11				// move r11 into r2
	add	r10,	#1			// add 1 to r10
	b	zero				// branch
reint:	
	mov r10, #0				// move 0 into r10
	mov r1,	#150			// move 150 into r1
	add	r11,#40				// add 40 into r11
	mov	r2,	r11				// move r11 into r2
	cmp	r2,	#700			// compare r2 with 700
	bge		leaveMap		// branch if greater or equal to
	b zero					// branch
leaveMap:
	pop {r8, r7, lr}		// pop
	bx lr					// pop
/************************************************************************/
/* Colouring individual blocks (both vertical AND horizontal)
*/
.globl initColourBlock
initColourBlock:
	push	{lr}			// push
	add		r1,	#1			// increment x
	add		r2,	#1			// increment y
	add		r5,	r1,	#39		// calculate x-end
	add		r6,	r2,	#39		// calculate y-end
ColoursBlockLINEIn:
	cmp		r0, #0			// compare r0 to 0
	beq		exit2			// branch if equal
	bl		DrawPixel16bpp	// branch link
	add		r1,	#1			// increment x
	cmp		r1,	r5			// compare x with x-end
	beq		nextBlockLineToColour	//branch if equal
	b		ColoursBlockLINEIn		// branch
nextBlockLineToColour:
	add		r2,	#1			// increment y
	sub		r1,	#39			// subtract 39 from r1
	cmp		r2,	r6			// compare y with y-end
	bge		exit2			// branch if greater or equal to
	b		ColoursBlockLINEIn		// branch

exit2:
	pop		{lr}			// pop
	bx	lr					// pop
/***********************************************************************/
/*Draws the grid*/
drawGrid:
	cmp		r0, #0			// compare r0 to 0
	beq		return			// branch if equal
	ldr		r3,	=0x0000		// load black colour
	bl		DrawPixel16bpp	// branch link
	add		r1, #1			// increment x
	cmp		r1,	#740		// compare x to 740
	beq		nextHorizontalGridLine	// branch if equal
	b		drawGrid		// branch
nextHorizontalGridLine:
	add		r2,	#80			// add 80 to y
	mov		r1,	#150		// move 150 to x
	cmp		r2, #740		// compare y and 740 
	bge		initVerticalGridLine	// branch if greater or equal to
	b		drawGrid		// branch
	 

initVerticalGridLine:
	mov		r2,	#60			// initialize y
	mov		r1,	#150		// intialize x
drawVerticalGridLine:
	cmp		r0, #0			// compare r0 to 0
	beq		return			// branch if equal
	ldr		r3,	=0x0000		// load black colour
	bl		DrawPixel16bpp	// branch link
	add 	r2, #1			// increment y
	cmp		r2,	#700		// compare y to 700
	beq		nextVerticalGridLine	// branch if equal
	b drawVerticalGridLine	// branch
nextVerticalGridLine:
	add		r1,	#40			// add 40 to x
	mov		r2,	#60			// move 60 to y
	cmp		r1,	#780		// compare x and 780
	bge return				// branch if greater or equal to
	b drawVerticalGridLine	// branch

return:
	b	cont				// branch
/***********************************************************************/
/* Draw Pixel to a 1024x768x16bpp frame buffer
 * Note: no bounds checking on the (X, Y) coordinate
 *	r0 - frame buffer pointer
 *	r1 - pixel X coord
 *	r2 - pixel Y coord
 *	r3 - colour (use low half-word)
 */
.globl DrawPixel16bpp
DrawPixel16bpp:
	push	{r4}

	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r1, r2, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset
	strh	r3,		[r0, offset]
	pop		{r4}
	bx		lr
/***********************************************************************/

.globl redraw
redraw:
	push {lr}				// push
	push {r2}
checkStart:
	mov r3, #0				// move 0 to r3
	ldr r2, =startButton	// load button value to r2
	cmp r9, r2				// compare pressed button to value
	bne right				// branch if not equal to
	bl pauseScreen			// branch link
right:
	mov	r3,	#0				// move 0 into r3
	ldr	r4,	=mapArray		// load mapArray into r4
	ldr	r2,	=moveRight		// load button value to r2
	add	r11, r12, #4		// add r12+4 to r11
	mov	r5,	#3				// move 3 into r5
	mov	r6,	#0				// move 0 into r6
	cmp	r9,	r2				// compare pressed button to value
	bne	left				// branch if not equal
	ldr	r10,	[r4,r11]	// load into r10
	cmp	r10,	#1			// compare r10 and 1
	beq	tryAgain			// branch if equal
	cmp	r10,	#5			// compare r10 and 5
	beq	tryAgain			// branch if equal
	add	r3,	r12,	#4		// add r12+4 into r3
	str	r5,	[r4,	r3]		// store r5 into r4
	str	r6,	[r4,	r12]	// store r6 into r4
	sub	r8,		#1			// decrement r8
	add	r12,	#4			// add 4 to r12
	bl	decMoves		//Decrement remaining moves by 1 
	b	tryAgain			// branch
left:
	mov	r3,	#0				// move 0 to r3
	ldr	r4,	=mapArray		// load address into r4
	ldr	r2,	=moveLeft		// load address into r2
	sub r11,	r12,	#4	// subtract from r12
	cmp	r9,	r2				// compare button pressed to address loaded
	bne	up					// branch if not equal
	ldr	r10,	[r4,r11]	// load into r10
	cmp	r10,	#1			// compare r10 with #1	
	beq	tryAgain			// branch if equal 
	cmp	r10,	#5			// compare r10 to 5
	beq	tryAgain		 	// branch if equal
	cmp	r10,	#4			// compare r10 to 4
	bne	left2				// branch if not equal
	add	r7,	#1				// increment by 1
left2:
	sub	r3,	r12,	#4		// subtract from r3
	str	r5,	[r4,	r3]		// store r5
	str	r6,	[r4,	r12]	// store r6
	sub	r8,	#1				// decrement r8 by 1
	sub	r12,	#4			// subtract 4 from r12
	bl	decMoves		//Decrement remaining moves by 1
	b tryAgain				// branch
up:
	mov	r3,	#0				// move 0 into r3
	ldr	r4,	=mapArray		// load address into r4
	ldr	r2,	=moveUp			// load address into r2
	sub	r11, r12, #64		// subtract from r12
	cmp	r9,	r2				// compare r9 and r2
	bne	down				// branch if not equal
	ldr	r10,	[r4,r11]	// load r10
	cmp	r10,	#1			// compare 1 and r10
	beq	tryAgain			// branch if equal
	cmp	r10,	#5			// compare r10 and 5
	beq	tryAgain			// branch if equal
	cmp	r10,	#4			// compare r10 and 4
	bne	up2					// branch if not equal
	add	r7,	#1				// add one to r7
up2:
	sub	r3,	r12,	#64		// subtract from r12
	str	r5,	[r4,	r3]		// store into r4
	str	r6,	[r4,	r12]	// store into r4
	sub	r8,		#1			// decrement r8
	sub	r12,	#64			// subtract 64 from r12
	bl	decMoves		//Decrement remaining moves by 1
	b tryAgain				// branch
down:
	mov	r3,	#0				// move 0 into r3
	ldr	r4,	=mapArray		// load address into r4
	ldr	r2,	=moveDown		// load address into r2
	add	r11,	r12,	#64		// store r12+64 into r11
	cmp	r9,	r2				// compare r9 and r2
	bne	pressA				// branch if not equal
	ldr	r10,	[r4,r11]	// load into r10
	cmp	r10,	#1			// compare r10 to 1
	beq	tryAgain			// branch if equal
	cmp	r10,	#5			// compare r10 and 5
	beq	tryAgain			// branch if equal
	cmp 	r10,	#6			// compare r10 and 6
	beq	tryAgain			// branch if equal
	add	r3,	r12,	#64		// store r12+64 into r3
	str	r5,	[r4,	r3]		// store into r4
	str	r6,	[r4,	r12]	// store into r4
	sub	r8,	#1				// decrement r8
	add	r12,	#64			// add 64 to r8
	bl	decMoves		//Decrement remaining moves by 1
	b 	tryAgain				// branch
pressA:
	mov	r3,	#0				// move 0 into r3
	ldr	r4,	=mapArray		// load address into r4
	ldr	r2,	=pressedA		// load address into r2
	cmp	r9,	r2				// compare r9 and r2
	bne	tryAgain			// branch if not equal
	add	r11,	r12,	#4		// store r12+4 into r11
	ldr	r10,	[r4,	r11]	// load into r4
	cmp	r10,	#5			// compare r10 and 5
	bne	nextU				// branch if not equal
	cmp	r7,	#0				// compare r7 and 0
	beq	tryAgain			// branch if equal
	sub	r7, #1				// decrement r7 by 1
	str	r6,	[r4,	r11]		// store into r4
	b	tryAgain			// branch
nextU:
	sub	r11,	r12,	#64		// subtract 64 from r12, store in r11
	ldr	r10,	[r4,	r11]	// load into r10
	cmp	r10,	#5			// compare r10 and 5
	bne	nextD				// branch if not equal
	cmp	r7,	#0				// compare r7 to 0
	beq	tryAgain			// branch if equal
	sub	r7, #1				// decrement 1 from r7
	str	r6,	[r4,	r11]	// store into r4
	b	tryAgain			// branch
nextD:
	add	r11,	r12,	#64		// store r12+64 into r11
	ldr	r10,	[r4,	r11]	// load into r4
	cmp	r10,	#6			// compare r10 and 6
	bne tryAgain			// branch if not equal
	cmp	r7,	#0				// compare r7 and 0
	beq	tryAgain			// branch if equal
	sub	r7, #1				// decrement 1 from r7
	str	r6,	[r4,	r11]	// store into r4
	b	tryAgain			// branch
nextL:
	sub	r11,	r12,	#4		// subtract 4 from r12 and store into r11
	ldr	r10,	[r4,	r11]	// load into r10
	cmp	r10,	#5			// compare r10 and 5
	bne	tryAgain			// branch if not equals
	cmp	r7,	#0				// compare r7 and 0
	beq	tryAgain			// branch if equal
	sub	r7, #1				// decrement 1 from r7
	str	r6,	[r4,	r11]	// store into r4
	b	tryAgain			// branch

tryAgain:
	pop {r2}				// pop
	pop {lr}				// pop
	bx	lr					// pop
/****************************************************************************/
/*playerWin:
	ldr	r2, 	=remainingMoves		//Get address of remainingMoves
	ldr	r4,	[r2]			//Load value into r4
	cmp	r4,	#0			//Compare r4 to 0
	bne	checkState
	
checkState:
	mov	r4,	#150			//Set r4 to 150 to reset number of moves
	str	r4,	[r2]			//Store r4 into remainingMoves
	ldr	r2, 	=gameState		//Get address of gameState
	ldr	r4,	[r2]			//Load gameState value into r4
	cmp	r4,	#1			//Compare r4 to 1
	beq	winCondition			//Branch to winCondition if r4 == 1
	bl	rerun
	*/
.globl rerun
rerun:
	push	{r1,r2,r3}		// push
	mov	r2,	#0				// move 0 into r2
	ldr	r3,	=mapArray2		// load address into r3
	ldr	r4,	=mapArray		// load address into r4
	ldr	r10,=pressedA		// load address into r10
	cmp	r9,	r10				// compare r9 and r10
	bne	tryAgain2			// branch if not equal
loopz:
	cmp	r2,	#1020			// compare r2 to 1020
	beq	tryAgain2			// branch if equal
	ldr	r1,	[r3,	r2]		// load into r1
	str	r1,	[r4,	r2]		// store into r4
	add	r2,	#4				// add 4 to r2
	mov	r12,	#900		// move 900 into r12
	mov	r8,		#150		// move 150 into r8
	mov r7, #0				// move 0 to r7
	b	loopz				// branch
tryAgain2:
	ldr	r2, 	=remainingMoves		//Get address of remainingMoves
	ldr	r4,	[r2]			//Load value into r4
	mov	r4,	#150			//Set r4 to 150 to reset number of moves
	str	r4,	[r2]			//Store r4 into remainingMoves
	//b	playerWin
	pop	{r1,r2,r3}			// pop
	bx lr					// pop
/********************************************************************************/
.globl	pointerR
pointerR:
	push {lr}				// push
	mov	r1,	#200			// initialize x value
	mov	r2,	#190			// initialize y value

loop1:
	ldr	r3,	=0xFFFF			// load white colour
	bl	DrawPixel16bpp		// branch link
	add	r1,	#1				// increment x
	cmp	r1,	#205			// compare x with 205
	beq	loop2				// branch if equal
	b	loop1				// branch
loop2:
	mov	r1,	#200			// move 200 into r1
	add	r2,	#1				// increment y
	cmp	r2,	#195			// compare y to 195
	beq	nextPart			// branch if equal
	b	loop1				// branch
nextPart:
	mov	r1,	#200			// initialize x value
	mov	r2,	#250			// initialize y value
loop3:
	ldr	r3,	=0x0000			// load black colour
	bl	DrawPixel16bpp		// branch link
	add	r1,	#1				// increment x
	cmp	r1,	#205			// compare x with 205
	beq	loop4				// branch if equal
	b	loop3				// branch
loop4:
	mov	r1,	#200			// move 200 to r1
	add	r2,	#1				// increment y by 1
	cmp	r2,	#255			// compare y with 255
	beq	nextPart2			// branch if equal
	b	loop3				// branch
nextPart2:
	pop	{lr}				// pop
	bx	lr					// pop
/********************************************************************************/
.globl	pointerM
pointerM:
	push {lr}				// push
	mov	r1,	#200			// initialize x value
	mov	r2,	#250			// initialize y value

loop1b:
	ldr	r3,	=0xFFFF			// load white colour
	bl	DrawPixel16bpp		// branch link
	add	r1,	#1				// increment x
	cmp	r1,	#205			// compare x with 205
	beq	loop2b				// branch if equal
	b	loop1b				// branch
loop2b:
	mov	r1,	#200			// move 200 to r1
	add	r2,	#1				// increment y
	cmp	r2,	#255			// compare y and 255
	beq	nextPartb			// branch if equal
	b	loop1b				// branch
nextPartb:
	mov	r1,	#200			// initialize x value
	mov	r2,	#190			// initialize y value
loop3b:
	ldr	r3,	=0x0000			// load black colour
	bl	DrawPixel16bpp		// branch link
	add	r1,	#1				// increment x
	cmp	r1,	#205			// compare x with 205
	beq	loop4b				// branch equal
	b	loop3b				// branch
loop4b:
	mov	r1,	#200			// move 200 into r1
	add	r2,	#1				// increment y
	cmp	r2,	#195			// compare y with 195
	beq	nextPart2b			// branch if equal
	b	loop3b				// branch
nextPart2b:
	pop	{lr}				// pop
	bx	lr					// pop
/********************************************************************************/
//This is to decrement the total number of moves remaining as well as creating a delay in movement
.globl	decMoves
decMoves:
	push	{lr}
	ldr	r2, 	=remainingMoves		//Get address of remainingMoves
	ldr	r4,	[r2]			//Load value into r4
	sub	r4,	#1			//Subtract r4 (number of moves) by 1
	cmp	r4,	#0			//Compare r4 to 0
	beq	outOfMoves			//Branch to outOfMoves if r4 == 0
	str	r4,	[r2]			//Store the result back into remainingMoves
	//Need to print out the stuff for remaining moves
	//bl	actionKeys
	b	returnBack			//Branch to returnBack

outOfMoves:
	mov	r4,	#150			//Set r4 to 150 to reset number of moves
	str	r4,	[r2]			//Store r4 into remainingMoves
	bl	loseCondition			//Branch to lose condition
	//pop	{lr}
	//bx	lr	
returnBack:
	
	pop	{lr}		
	bx	lr		//Go back to the calling code

/********************************************************************************/

.section .data
remainingMoves:	.int	150	//Setting default number of moves

.EQU		moveRight,	0xff7f
.EQU		moveLeft,	0xffbf
.EQU		moveUp,		0xffef
.EQU		moveDown, 	0xffdf
.EQU		pressedA, 	0xfeff
.EQU		startButton,	0xfff7

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
mapArray2:
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
