.section    .init
.globl     _start

_start:
    b       mainChar
    
.section .text

mainChar:
    mov     sp, #0x8000
	
	bl		EnableJTAG

	bl		InitFrameBuffer

	bl		DrawCharB
    
haltLoop$:
	b		haltLoop$

/* Draw the character 'B' to (0,0)
 */
DrawCharB:
	push	{r4-r8, lr}

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8
//FROM HERE
loop:
	mov		r9,	#0		//This is counter for printing more shiz
	cmp		r9, #0
	beq		title
	
	cmp		r9,	#1
	beq		groupNames

	cmp		r9,	#2
	beq		options1
	
	cmp		r9, #3
	beq		options2
	
	cmp		r9,	#4
	beq		done
	
title:
	ldr		chAdr,	=font		// load the address of the font map
	mov		r0,		#'M, A, Z, E, , G, A, M, E'		// load the character into r0
	add		chAdr,	r0, lsl #4	// char address = font base + (char * 16)

	mov		py,		#50			// init the Y coordinate (pixel coordinate) HERE
	mov		px,		#10			// init the X coordinate HERE
	b		charLoop$
groupNames:

	ldr		chAdr,	=font
	mov		r0,	#'R, i, c, h, a, r, d, , H, u, y, n, h,,, E, m, i, l, y, , C, h, o, w,,, M, e, l, i, s, s, a, , T, a'  
	add		chAdr, r0, lsl #4
	
	mov		py,		#10			// init the Y coordinate (pixel coordinate) HERE
	mov		px,		#15			// init the X coordinate HERE
	b		charLoop$
	
options1:

	ldr		chAdr, =font
	mov		r0,	#'S, t, a, r, t, , G, a, m, e'
	add		chAdr, r0, lsl, #4
	
	mov		py,		#50			// init the Y coordinate (pixel coordinate) HERE
	mov		px,		#10			// init the X coordinate HERE
	b		charLoop$
	
options2:

	ldr		chAdr, =font
	mov		r0,	#'Q, u, i, t, , G, a, m, e'
	add		chAdr, r0, lsl #4
	
	mov		py,		#50			// init the Y coordinate (pixel coordinate) HERE
	mov		px,		#10			// init the X coordinate HERE
	b		charLoop$
	
	//TO HERE
charLoop$:
	
	
	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		// test row byte against the bitmask
	beq		noPixel$

	mov		r0,		px
	mov		r1,		py
	mov		r2,		#0xFF3300		// red (MORE LIKE ORANGE RED)
	bl		DrawPixel			// draw red pixel at (px, py)

noPixel$:
	add		px,		#1			// increment x coordinate by 1
	lsl		mask,	#1			// shift bitmask left by 1

	tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			// increment y coordinate by 1

	add		r9,	#1//HERE
	cmp		r9,	#4//HERE
	bne		loop//HERE
	/*tst		chAdr,	#0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)
*/
done:
	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	pop		{r4-r8, pc}

.section .data

.align 4
font:		.incbin	"font.bin"
