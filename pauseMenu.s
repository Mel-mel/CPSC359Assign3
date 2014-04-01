.section .init
.globl pauseScreen

pauseScreen:
	push {lr}				// push
	bl initDrawInsideLines	// branch link
	pop {lr}				// pop
	bx	lr

/********************************************************************/
/*DRAW PAUSE MENU SCREEN W/ BORDER*/
.globl box
box:
initDrawInsideLines:
	push {lr}				// push
	mov r1, #150			// x value
	mov r2, #60				// y value
drawHorizontalLine:
	ldr r3, =0x0000			// load black colour
	bl DrawPixel			// branch link
	add r1, #1				// increment x
	cmp r1, #800			// compare x to 800
	beq	initNextHorizontalLineLoop	// branch equal
	b drawHorizontalLine	// branch
initNextHorizontalLineLoop:
	mov r1, #150			// move x value back
	add r2, #1				// increment y
	cmp r2, #700			// compare y to 700
	beq initDrawTopBorderLine	// branch equal
	b drawHorizontalLine	// branch

initDrawTopBorderLine:
	mov r1, #150			// move new x value
	mov r2, #60				// move new y value
drawTopBorderLine:
	ldr r3, =0xF0F0			// load magenta colour
	bl DrawPixel			// branch link
	add r1, #1				// increment x 
	cmp r1, #700			// compare x to 700
	beq initDrawBottomBorderLine	// branch equal
	b drawTopBorderLine		// branch 
initDrawBottomBorderLine:
	mov r1, #150			// move new x value
	mov r2, #700			// move new y value
drawBottomBorderLine:
	ldr r3, =0xF0F0			// load magenta colour
	bl DrawPixel			// branch link
	add r1, #1				// increment x
	cmp r1, #700			// compare x to 700
	beq initDrawLeftBorderLine	// branch equal
	b drawBottomBorderLine	// branch

initDrawLeftBorderLine:
	mov r1, #150			// move new x value
	mov r2, #60				// move new y value
drawLeftBorderLine:
	ldr r3, =0xF0F0			// load magenta colour
	bl DrawPixel			// branch link
	add r2, #1				// increment y
	cmp r2, #700			// compare y to 700
	beq initDrawRightBorderLine	// branch equal
	b drawLeftBorderLine	// branch
initDrawRightBorderLine:
	mov r1, #700			// move new x value
	mov r2, #60				// move new y value
drawRightBorderLine:
	ldr r3, =0xF0F0			// load magenta colour
	bl DrawPixel			// branch link
	add r2, #1				// increment y
	cmp r2, #700			// compare y to 700
	beq returnFromDrawingBoard	// branch equal
	b drawRightBorderLine	// branch

returnFromDrawingBoard:
	pop 	{lr}			// pop
	bx	lr

/********************************************************************/
/*DRAWING OPTION POINTER*/

initPointer:
	push {lr}				// push
	mov r0, r8				// copy frame buffer pointer
	mov r1, #200			// initialize x value
	mov r2, r3				// initialize y value
	mov r10, r3				// copy y value for later comparison
	mov r4, r3				// copy y value for ending boundary
	add r4, #5				// add 5 to copied y coordinate
drawPointerLoop:
	ldr r3, =0xFFFF			// load white colour
	bl DrawPixel			// branch link
	add r1, #1				// increment x
	cmp r1, #205			// compare x to 205
	beq drawNextPointerLineLoop	// branch equal
	b drawPointerLoop		// branch
drawNextPointerLineLoop:
	mov r1, #200			// initialize new x value
	add r2, #1				// increment y
	cmp r2, r4				// compare y and end value
	beq checkOppositePointer	// branch equal
	b drawPointerLoop		// branch 

checkOppositePointer:
	cmp r10, #190			// compare stored y value to 190
	bne eraseDown			// branch if not equal
	beq eraseUp				// branch if equal
eraseUp:
	mov r2, #250			// move 250 into r2
	b initErasePointer		// branch
eraseDown:
	mov r2, #190			// move 190 into r2
initErasePointer:
	mov r1, #200			// initialize x
	mov r4, r2				// move r3 into r4
	add r4, #5				// add 5 to copied y coordinate
erasePointerLoop:
	ldr r3, =0x0000			// load black colour
	bl DrawPixel			// branch link
	add r1, #1				// increment x
	cmp r1, #205			// compare x to 205
	beq eraseNextPointerLineLoop	// branch equal
	b erasePointerLoop		// branch
eraseNextPointerLineLoop:
	mov r1, #200			// initialize x
	add r2, #1				// increment y
	cmp r2, r4				// compare y values
	beq returnFromPointerErase	// branch equal
	b erasePointerLoop		// branch

returnFromPointerErase:
	bl menuOptions			// branch link
	bx	lr					// pop
/********************************************************************/
/*MENU OPTIONS*/

menuOptions:
	push {lr}				// push
	bl	initPointer			// branch link
	bl controllerInit		// branch link
resumeGame:
	ldr r2, =startButton	// load startButton value
	cmp r0, r2				// compare with pressed button
	bne optionUp			// branch if not equal
	beq exitPauseScreen		// branch if equal
optionUp:
	ldr r2, =moveUp			// load moveUp value
	cmp r0, r2				// compare with pressed button
	bne optionDown			// branch if not equal
	mov r3, #190			// move y=190 value into r3
	mov r11, r3				// copy 190 into r11
	b initPointer			// branch
optionDown:
	ldr r2, =moveDown		// load moveDown value
	cmp r0, r2				// compare with pressed button
	bne optionA				// branch if not equal
	mov r3, #250			// move y=250 value into r3
	mov r11, r3				// copy 250 into r11
	b initPointer			// branch
optionA:
	ldr r2, =pressedA		// load pressedA value
	cmp r0, r2				// compare with pressed button
	bne keepLooping			// branch if not equal
	mov r3, r11				// move stored r11 value into r3
	b restartOrQuit			// branch
	b return				// branch
keepLooping:
	b	menuOptions			// branch back to loop
exitPauseScreen:
	bl loopMain				// exit back into game

return:
	bx	lr					// pop
/********************************************************************/
/*CHECKING IF RESTART OR QUIT*/

restartOrQuit:
	push {lr}				// push
	cmp r3, #190			// compare stored y=190||250 with 190
	beq	restart				// branch if equal
	bne quit				// branch if not equal
	bl menuOptions			// branch link

restart:
	bl InitFrameBuffer		// branch link
	bl rerun				// branch link
	bl redraw				// branch link
	bl loopMain				// branch link
	
quit:
	bl InitFrameBuffer		// branch link
	bl rerun				// branch link
	bl redraw				// branch link
	bl main					// branch link


/********************************************************************/
/* Draw Pixel to a 1024x768x16bpp frame buffer
 * Note: no bounds checking on the (X, Y) coordinate
 *	r0 - frame buffer pointer
 *	r1 - pixel X coord
 *	r2 - pixel Y coord
 *	r3 - colour (use low half-word)
 */
.globl DrawPixel
DrawPixel:
	push	{r4}			// push

	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r1, r2, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset
	strh	r3,		[r0, offset]
	pop		{r4}			// pop
	bx		lr

/********************************************************************/
.section .data
.equ		moveUp,		0xffef
.equ		moveDown, 	0xffdf
.equ 		startButton, 0xfff7
.equ		pressedA, 	0xfeff
