.section .init
.globl pauseScreen

pauseScreen:
	push {lr}
	push {r9}
	mov r1, #150	//x
	mov r2, #60		//y
	bl drawHorizontalLine
keepGoing:	
	//mov r1, #150	//x
	//mov r2, #60		//y
	//bl initColourBlock2
keepKeepGoing:
	bl menuOptions
	pop {r9}
	pop {pc}

drawHorizontalLine:
	ldr r3, =0x0000
	bl DrawPixel
	add r1, #1
	cmp r1, #800
	beq	initNextHorizontalLineLoop
	b drawHorizontalLine
initNextHorizontalLineLoop:
	mov r1, #150
	add r2, #1
	cmp r2, #700
	beq returnTo
	b drawHorizontalLine

returnTo:
	b	keepGoing

menuOptions:
	push {lr}
	bl controllerInit
	bl textStart
	mov		r9,	r0	
resumeGame:
	ldr r2, =startButton
	cmp r0, r2
	bne optionUp
	beq exitPauseScreen
optionUp:
	ldr r2, =moveUp
	cmp r0, r2
	bne optionDown
optionDown:
	ldr r2, =moveDown
	cmp r0, r2
	bne optionA
optionA:
	ldr r2, =pressedA
	cmp r0, r2
	bne keepLooping
keepLooping:
	b	menuOptions
exitPauseScreen:
	bl loopMain

return:
	pop {pc}
	bx	lr

/***********************************************************************/
/* Draw Pixel to a 1024x768x16bpp frame buffer
 * Note: no bounds checking on the (X, Y) coordinate
 *	r0 - frame buffer pointer
 *	r1 - pixel X coord
 *	r2 - pixel Y coord
 *	r3 - colour (use low half-word)
 */
.globl DrawPixel
DrawPixel:
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

/***********************************************************************/
//Drawing some text on the screen
.globl	textStart
textStart:
	bl	InitFrameBuffer
	bl	DrawCharB
/*
firstString:
	push	{lr}
	
	ldr		r4,	=font
	mov		r0,	#'A'
	//ldrb	r3,	=string
	//ldrb	r0,	[r3]
	add		r4,	r0,	lsl #4

	mov		r9,	#0	//Calculates offset apparently

	
	mov		r6,	#60	//Set y coordinate

charLoop:
	mov		r5,	#150	//Set x coordinate
	mov		r8,	#0x01	//Bit mask

	ldrb	r7,	[r8, r9]
	add		r9,	#1

rowLoop:
	tst		r7,	r8
	beq		noPixel

	mov		r0,	r5
	mov		r1,	r4
	mov		r2,	#0xF800
	bl		DrawPixel

noPixel:
	add		r5,	#1
	lsl		r8,	#1

	tst		r8,	#0x100
	beq		rowLoop

	add		r6,	#1

	tst		r4,	#0xF
	bne		charLoop

	pop		{lr}
*/
DrawCharB:
	push	{r4-r8, lr}

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr,	=font		// load the address of the font map
	mov		r0,		#'E'		// load the character into r0
	add		chAdr,	r0, lsl #4	// char address = font base + (char * 16)

	mov		py,		#70			// init the Y coordinate (pixel coordinate)

charLoop$:
	mov		px,		#160			// init the X coordinate

	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		// test row byte against the bitmask
	beq		noPixel$

	mov		r0,		px
	mov		r1,		py
	mov		r2,		#0xF800		// red
	bl		DrawPixel			// draw red pixel at (px, py)

noPixel$:
	add		px,		#1			// increment x coordinate by 1
	lsl		mask,	#1			// shift bitmask left by 1

	tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			// increment y coordinate by 1

	tst		chAdr,	#0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	pop		{r4-r8, pc}


/***********************************************************************/
.section .data
.align 4
font:		.incbin	"font.bin"

.equ		moveUp,		0xffef
.equ		moveDown, 	0xffdf
.equ 		startButton, 0xfff7
.equ		pressedA, 	0xfeff

string:	.byte	'M'



