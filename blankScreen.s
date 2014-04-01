.section .init
.globl blankScreen
blankScreen:
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
	beq goBack			// branch equal
	b drawHorizontalLine	// branch
	
goBack:
	pop	{pc}
	bx	lr
.section .data
