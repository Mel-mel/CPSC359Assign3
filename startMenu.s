.section .init
.globl startMenu

startMenu:
	push {lr, r9}				// push
	b initDrawInsideLines1		// branch
	pop	{r9, pc}				// pop
	bx lr						// pop

/***********************************************************************/
/*DRAW START MENU SCREEN W/ BORDER*/
initDrawInsideLines1:
	push {lr}					// push
	mov r1, #80					// initialize x value
	mov r2, #60					// initialize y value
drawHorizontalLine1:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r1, #1					// increments x value
	cmp r1, #800				// compares x and 800
	beq	initNextHorizontalLineLoop1		// branch if equal
	b drawHorizontalLine1		// branch
initNextHorizontalLineLoop1:
	mov r1, #80					// initialize x value
	add r2, #1					// increment y value
	cmp r2, #700				// compares y and 700
	beq initDrawTopBorderLine1	// branch if equal
	b drawHorizontalLine1		// branch

initDrawTopBorderLine1:
	mov r1, #150				// initialize x value
	mov r2, #60					// initialize y value
drawTopBorderLine1:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r1, #1					// increments x value
	cmp r1, #700				// compares y and 700
	beq initDrawBottomBorderLine1	// branch if equal
	b drawTopBorderLine1		// branch 
initDrawBottomBorderLine1:
	mov r1, #150				// initialize x value
	mov r2, #700				// initialize y value
drawBottomBorderLine1:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r1, #1					// increment x by 1
	cmp r1, #700				// compare x to 700
	beq initDrawLeftBorderLine1		// branch if equal
	b drawBottomBorderLine1		// branch

initDrawLeftBorderLine1:
	mov r1, #150				// initialize x value
	mov r2, #60					// initialize y value
drawLeftBorderLine1:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r2, #1					// increment y by 1
	cmp r2, #700				// compare y to 700
	beq initDrawRightBorderLine1	// branch if equal
	b drawLeftBorderLine1		// branch
initDrawRightBorderLine1:
	mov r1, #700				// initialize x value
	mov r2, #60					// initialize y value
drawRightBorderLine1:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r2, #1					// increment y by 1
	cmp r2, #700				// compare y to 700
	beq returnFromDrawingBoard1		// branch if equal
	b drawRightBorderLine1		// branch 


returnFromDrawingBoard1:
	mov r8, r0					// store frame buffer pointer for later use
	bl	startMe					// branch link
	mov	r0, #140				// initialize x value
	mov r3, #15					// initialize y value
	ldr	r2, =movesRemain		// load ascii string
	bl	charErase				// branch link
	mov	r0,	#540				// initialize x value
	mov	r3,	#15					// initialize y value
	ldr	r2,	=keysOwned			// load ascii string
	bl	charErase				// branch link
	mov	r0, #760				// initialize x value
	mov r3, #15					// initialize y value
	ldr	r2, =one				// load ascii string
	bl	charErase				// branch link
	mov	r0, #760				// initialize x value
	mov r3, #15					// initialize y value
	ldr	r2, =zero				// load ascii string
	bl	charErase				// branch link
temp:
	mov	r0, #440				// initialize x value
	mov r3, #15					// initialize y value
	ldr	r2, =one				// load ascii string
	bl	charErase				// branch link
	mov	r0, #456				// initialize x value
	mov r3, #15					// initialize y value
	ldr	r2, =five				// load ascii string
	bl	charErase				// branch link
	mov	r0, #472				// initialize x value
	mov r3, #15					// initialize y value
	ldr	r2, =zero				// load ascii string
	bl	charErase				// branch link
	mov r11, #400				// move "default" 400 into r11
	b initMainPointer			// branch
	pop {pc}					// pop
	bx	lr						// pop


/***********************************************************************/
/*DRAWING OPTION POINTER*/

initMainPointer:
	push {lr}					// push
	mov r0, r8					// move frame buffer pointer
	mov r1, #200				// initialize x value
	mov r2, r3					// initialize y value
	mov r10, r3					// copy y value
	mov r4, r3					// move r3 into r4
	add r4, #5					// add 5 to copied y coordinate
drawMainPointerLoop:
	ldr r3, =0xFFFF				// load white colour 
	bl DrawPixelTM				// branch link
	add r1, #1					// increment x by 1
	cmp r1, #205				// compare x to 205
	beq drawNextMainPointerLineLoop		// branch if equal
	b drawMainPointerLoop		// branch
drawNextMainPointerLineLoop:
	mov r1, #200				// initialize x value
	add r2, #1					// increment y value
	cmp r2, r4					// compare y value
	beq checkOppositeMainPointer		// branch if equal
	beq returnFromMainPointerErase		// branch if equal
	b drawMainPointerLoop		// branch

checkOppositeMainPointer:
	cmp r10, #400				// compare stored x to 400
	bne eraseMainDown			// branch if not equal
	beq eraseMainUp				// branch if equal
eraseMainUp:
	mov r2, #600				// initialize y value
	b initEraseMainPointer		// branch
eraseMainDown:
	mov r2, #400				// initialize y value
initEraseMainPointer:
	mov r1, #200				// initialize x value
	mov r4, r2					// move r3 into r4
	add r4, #5					// add 5 to copied y coordinate
eraseMainPointerLoop:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r1, #1					// increment x by 1
	cmp r1, #205				// compare x to 205
	beq eraseNextMainPointerLineLoop	// branch if equal
	b eraseMainPointerLoop		// branch
eraseNextMainPointerLineLoop:
	mov r1, #200				// initialize x value
	add r2, #1					// increment y value
	cmp r2, r4					// compare y value
	beq returnFromMainPointerErase		// branch if equal
	b eraseMainPointerLoop		// branch

returnFromMainPointerErase:
	b mainMenuOptions			// branch
	bx	lr						// pop

/***********************************************************************/
/*MENU OPTIONS*/

mainMenuOptions:
	push {lr}					// push
	bl controllerInit			// branch link
	mov		r9,	r0				// stores controller input for later
optionMUp:
	ldr r2, =moveUp				// load moveUp value
	cmp r0, r2					// compare both values
	bne optionMDown				// branch if not equal
	mov r3, #400				// initialize y value
	mov r11, r3					// copy y value into r11
	b initMainPointer			// branch
optionMDown:
	ldr r2, =moveDown			// load moveDown value
	cmp r0, r2					// compare both values
	bne optionMA				// branch if not equal
	mov r3, #600				// initialize y value
	mov r11, r3					// copy y value into r11
	b initMainPointer			// branch
optionMA:
	ldr r2, =pressedA			// load pressedA value
	cmp r0, r2					// compare both values
	bne keepMLooping			// branch if not equal
	mov r3, r11					// move stored y value into r3
	b startOrQuit				// branch
	b Mreturn					// branch
keepMLooping:
	b	mainMenuOptions			// branch

Mreturn:
	bx	lr						// pop
/***********************************************************************/
/*CHECKING IF RESTART OR QUIT*/

startOrQuit:
	push {lr}					// push
	cmp r3, #400				// compare y and 400
	beq	start					// branch if equal
	bne quitGame				// branch if not equal
	b mainMenuOptions			// branch

start:
	bl InitFrameBuffer			// branch link
	bl rerun					// branch link
	bl redraw					// branch link
	bl loopMain					// branch link
	bx lr						// pop

quitGame:
	bl initEraseGame			// branch link

initEraseGame:
	mov r0, r8					// copy frame buffer pointer
	mov r1, #150				// initialize x value
	mov r2, #60					// initialize y value
drawEraseGame:
	ldr r3, =0x0000				// load black colour
	bl DrawPixelTM				// branch link
	add r1, #1					// increment x value
	cmp r1, #800				// compare x with 800
	beq	nextDrawEraseGame		// branch if equal
	b drawEraseGame				// branch
nextDrawEraseGame:
	mov r1, #150				// initialize x value
	add r2, #1					// increment y value
	cmp r2, #700				// compare y and 700
	beq quitProgram				// branch if equal
	b drawEraseGame				// branch

quitProgram:
	b haltLoop$					// branch

/***********************************************************************/
/* Draw Pixel to a 1024x768x16bpp frame buffer
 * Note: no bounds checking on the (X, Y) coordinate
 *	r0 - frame buffer pointer
 *	r1 - pixel X coord
 *	r2 - pixel Y coord
 *	r3 - colour (use low half-word)
 */
.globl DrawPixelTM
DrawPixelTM:
	push	{r4}				// push

	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r1, r2, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset
	strh	r3,		[r0, offset]
	pop		{r4}				// pop
	bx		lr

/***********************************************************************/
.section .data
.EQU		moveUp,		0xffef
.EQU		moveDown, 	0xffdf
.EQU		pressedA, 	0xfeff

movesRemain:	.ascii	"Actions Remaining: \n"
keysOwned:	.ascii	"Keys Owned: \n"
one:		.ascii	"1\n"
zero:		.ascii	"0\n"
five:		.ascii 	"5\n"
