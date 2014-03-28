.section .init
.globl drawMenu

drawMenu:
	push {lr}
	push {r7}
	push {r8}
	mov		r1, #100		// initializing x
	mov		r2, #20			// initializing y
	bl drawBorder			// draws border


//**********************
drawBorder:
	cmp		r0, #0
	beq		return
	ldr		r3,	=0x0000
	bl		DrawPixel16bpp
	add		r1, #1
	cmp		r1,	#740
	beq		nextHorizontalGridLine
	b		drawBorder
nextHorizontalGridLine:
	add		r2,	#40
	mov		r1,	#100
	cmp		r2, #700
	bge		initVerticalGridLine
	//b		drawBorder
	 

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
	//b drawVerticalGridLine

return:
	b	cont


//**********************
/************************************************************************/
/* Colouring individual blocks (both vertical AND horizontal)
*/
initColourBlock:
	push	{lr}
	add		r1,	#1
	add		r2,	#1
	add		r5,	r1,	#99//
	add		r6,	r2,	#99//
ColoursBlockLINEIn:
	cmp		r0, #0
	beq		exit2
	bl		DrawPixel16bpp
	
	/*add		r1,	#1
	cmp		r1,	r5
	beq		nextBlockLineToColour
	b		ColoursBlockLINEIn
nextBlockLineToColour:
	add		r2,	#1
	sub		r1,	#39
	cmp		r2,	r6
	bge		exit2
	b		ColoursBlockLINEIn
*/
exit2:
	pop		{lr}
	bx	lr
/***********************************************************************/
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

startMenu:
	.int	0
	.int	0