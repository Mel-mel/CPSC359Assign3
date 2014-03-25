.section    .init
.globl drawMap

drawMap:
	push {lr}
	mov		r1, #100	// initializing x
	mov		r2, #20		// initializing y
	bl drawGrid			// draws grid
cont:
	mov	r9,	#0	
	ldr r7,	=mapArray
	mov	r1,	#100
	mov	r2,	#20
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
	mov r1,	#100
	add	r11,#40
	mov	r2,	r11
	cmp	r2,	#660
	bge		leaveMap
	b zero
leaveMap:
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
	add		r2,	#40
	mov		r1,	#100
	cmp		r2, #700
	bge		initVerticalGridLine
	b		drawGrid
	 

initVerticalGridLine:
	mov		r2,	#20
	mov		r1,	#100
drawVerticalGridLine:
	cmp		r0, #0
	beq		return
	ldr		r3,	=0x0000
	bl		DrawPixel16bpp
	add 	r2, #1
	cmp		r2,	#660
	beq		nextVerticalGridLine
	b drawVerticalGridLine
nextVerticalGridLine:
	add		r1,	#40
	mov		r2,	#20
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

.section .data

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
