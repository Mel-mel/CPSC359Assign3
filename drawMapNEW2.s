.section    .init
.globl drawMap

drawMap:
	push {lr}
	push {r7}
	push {r8}
	mov		r1, #150	// initializing x
	mov		r2, #60		// initializing y
	bl drawGrid			// draws grid
cont:
	mov	r9,	#0	
	ldr r7,	=mapArray
	mov	r1,	#150
	mov	r2,	#60
	mov	r10,#0
	mov r11,r2
zero:	
	cmp	r10,	#16
	beq	reint
	ldr	r8,	[r7,r9]
	cmp	r8,	#1
	bne		one
	add	r9,	#4
	ldr		r3,	=0x00FF
	bl	initColourBlock
	add	r1,	#39
	mov	r2,	r11
	add	r10,	#1
	b	zero
one:
	cmp	r8,	#0
	bne		three
	add	r9,	#4
	ldr		r3,	=0xFFFF
	bl	initColourBlock
	add	r1,	#39
	mov	r2,	r11
	add	r10,	#1
	b	zero
three:
	cmp	r8,	#3
	bne		four
	add	r9,	#4
	ldr		r3,	=0x0F0F
	bl	initColourBlock
	add	r1,	#39
	mov	r2,	r11
	add	r10,	#1
	b	zero
four:
	cmp	r8,	#4
	bne		five
	add	r9,	#4
	ldr		r3,	=0xF00F
	bl	initColourBlock
	add	r1,	#39
	mov	r2,	r11
	add	r10,	#1
	b	zero
five:
	cmp	r8,	#5
	bne		six
	add	r9,	#4
	ldr		r3,	=0x0FFF
	bl	initColourBlock
	add	r1,	#39
	mov	r2,	r11
	add	r10,	#1
	b	zero
six:
	add	r9,	#4
	ldr		r3,	=0xFF0F
	bl	initColourBlock
	add	r1,	#39
	mov	r2,	r11
	add	r10,	#1
	b	zero
reint:	
	mov r10, #0
	mov r1,	#150
	add	r11,#40
	mov	r2,	r11
	cmp	r2,	#700
	bge		leaveMap
	b zero
leaveMap:
	pop {r8}
	pop {r7}
	pop {lr}
	bx lr
/************************************************************************/
/* Colouring individual blocks (both vertical AND horizontal)
*/
initColourBlock:
	push	{lr}
	add		r1,	#1
	add		r2,	#1
	add		r5,	r1,	#39
	add		r6,	r2,	#39
ColoursBlockLINEIn:
	cmp		r0, #0
	beq		exit2
	bl		DrawPixel16bpp
	add		r1,	#1
	cmp		r1,	r5
	beq		nextBlockLineToColour
	b		ColoursBlockLINEIn
nextBlockLineToColour:
	add		r2,	#1
	sub		r1,	#39
	cmp		r2,	r6
	bge		exit2
	b		ColoursBlockLINEIn

exit2:
	pop		{lr}
	bx	lr
/***********************************************************************/
/*Draws the grid*/
drawGrid:
	cmp		r0, #0
	beq		return
	ldr		r3,	=0x0000
	bl		DrawPixel16bpp
	add		r1, #1
	cmp		r1,	#740
	beq		nextHorizontalGridLine
	b		drawGrid
nextHorizontalGridLine:
	add		r2,	#80
	mov		r1,	#150
	cmp		r2, #740
	bge		initVerticalGridLine
	b		drawGrid
	 

initVerticalGridLine:
	mov		r2,	#60
	mov		r1,	#150
drawVerticalGridLine:
	cmp		r0, #0
	beq		return
	ldr		r3,	=0x0000
	bl		DrawPixel16bpp
	add 	r2, #1
	cmp		r2,	#700
	beq		nextVerticalGridLine
	b drawVerticalGridLine
nextVerticalGridLine:
	add		r1,	#40
	mov		r2,	#60
	cmp		r1,	#780
	bge return
	b drawVerticalGridLine

return:
	b	cont
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
	push {lr}
	push {r2}
checkStart:
	mov r3, #0
	ldr r2, =startButton
	cmp r9, r2
	bne right
	bl pauseScreen
right:
	mov	r3,	#0
	ldr	r4,	=mapArray
	ldr	r2,	=moveRight
	add	r11,	r12,	#4
	mov	r5,	#3
	mov	r6,	#0
	cmp	r9,	r2
	bne	left
	ldr	r10,	[r4,r11]
	cmp	r10,	#1
	beq	tryAgain
	cmp	r10,	#5
	beq	tryAgain
	add	r3,	r12,	#4
	str	r5,	[r4,	r3]
	str	r6,	[r4,	r12]
	sub	r8,		#1
	add	r12,	#4
	b	tryAgain
left:
	mov	r3,	#0
	ldr	r4,	=mapArray
	ldr	r2,	=moveLeft
	sub r11,	r12,	#4
	cmp	r9,	r2
	bne	up
	ldr	r10,	[r4,r11]
	cmp	r10,	#1
	beq	tryAgain
	cmp	r10,	#5
	beq	tryAgain
	cmp	r10,	#4
	bne	left2
	add	r7,	#1
left2:
	sub	r3,	r12,	#4
	str	r5,	[r4,	r3]
	str	r6,	[r4,	r12]
	sub	r8,	#1
	sub	r12,	#4
	b tryAgain
up:
		mov	r3,	#0
	ldr	r4,	=mapArray
	ldr	r2,	=moveUp
	sub	r11,	r12,	#64
	cmp	r9,	r2
	bne	down
	ldr	r10,	[r4,r11]
	cmp	r10,	#1
	beq	tryAgain
	cmp	r10,	#5
	beq	tryAgain
	cmp	r10,	#4
	bne	up2
	add	r7,	#1
up2:
	sub	r3,	r12,	#64
	str	r5,	[r4,	r3]
	str	r6,	[r4,	r12]
	sub	r8,		#1
	sub	r12,	#64
	b tryAgain
down:
	mov	r3,	#0
	ldr	r4,	=mapArray
	ldr	r2,	=moveDown
	add	r11,	r12,	#64
	cmp	r9,	r2
	bne	pressA
	ldr	r10,	[r4,r11]
	cmp	r10,	#1
	beq	tryAgain
	cmp	r10,	#5
	beq	tryAgain
	cmp r10,	#6
	beq	tryAgain
	add	r3,	r12,	#64
	str	r5,	[r4,	r3]
	str	r6,	[r4,	r12]
	sub	r8,	#1
	add	r12,	#64
	b tryAgain
pressA:
	mov	r3,	#0
	ldr	r4,	=mapArray
	ldr	r2,	=pressedA
	cmp	r9,	r2
	bne	tryAgain
	add	r11,	r12,	#4
	ldr	r10,	[r4,	r11]
	cmp	r10,	#5
	bne	nextU
	cmp	r7,	#0
	beq	tryAgain
	sub	r7, #1
	str	r6,	[r4,	r11]
	b	tryAgain
nextU:
	sub	r11,	r12,	#64
	ldr	r10,	[r4,	r11]
	cmp	r10,	#5
	bne	nextD
	cmp	r7,	#0
	beq	tryAgain
	sub	r7, #1
	str	r6,	[r4,	r11]
	b	tryAgain
nextD:
	add	r11,	r12,	#64
	ldr	r10,	[r4,	r11]
	cmp	r10,	#6
	bne tryAgain
	cmp	r7,	#0
	beq	tryAgain
	sub	r7, #1
	str	r6,	[r4,	r11]
	b	tryAgain
nextL:
	sub	r11,	r12,	#4
	ldr	r10,	[r4,	r11]
	cmp	r10,	#5
	bne	tryAgain
	cmp	r7,	#0
	beq	tryAgain
	sub	r7, #1
	str	r6,	[r4,	r11]
	b	tryAgain

tryAgain:
	pop {r2}
	pop {lr}

	bx	lr
.globl rerun
rerun:
	push	{r1,r2,r3}
	mov	r2,	#0
	ldr	r3,	=mapArray2
	ldr	r4,	=mapArray
	ldr	r10,	=pressedA
	cmp	r9,	r10
	bne	tryAgain2
loopz:
	cmp	r2,	#1020
	beq	tryAgain2
	ldr	r1,	[r3,	r2]
	str	r1,	[r4,	r2]
	add	r2,	#4
	mov	r12,	#900
	mov	r8,		#150
	b	loopz
tryAgain2:

	pop	{r1,r2,r3}
	bx lr
	
.section .data
.EQU		moveRight,	0xff7f
.EQU		moveLeft,	0xFFBF
.EQU		moveUp,		0xffef
.EQU		moveDown, 	0xffdf
.EQU		pressedA, 	0xfeff
.EQU		startButton,0xfff7

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
