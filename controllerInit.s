.section	.init
.globl		controllerInit
controllerInit:
	push	{lr}				// push
	ldr	r0,	=0x20200004			// Sets gpio 11 clk
	ldr	r1,	[r0]				// load from address
	mov	r2,	#7					// move 7 into r2
	lsl	r2,	#3					// logical shift left by 3
	bic	r1,	r2					// bit clear r1 and r2
	mov	r3,	#1					// move 1 into r3
	lsl	r3,	#3					// logical shift left by 3
	orr	r1,	r3					// orr together r1 and r3
	str	r1,	[r0]				// store back into r0

	ldr	r0,	=0x20200004			// Sets gpio 10 data
	ldr	r1,	[r0]				// load from address
	mov	r2,	#7					// move 7 into r2
	bic	r1,	r2					// bit clear r1 and r2
	str	r1,	[r0]				// store back into r0

	ldr	r0,	=0x20200000			// sets gpio 9 latch
	ldr	r1,	[r0]				// load from address
	mov	r2,	#7					// move 7 into r2
	lsl	r2,	#27					// logical shift left
	bic	r1,	r2					// bit clear r1 and r2
	mov	r3,	#1					// move 1 into r3
	lsl	r3,	#27					// logical shift left
	orr	r1,	r3					// orr together r1 and r3
	str	r1,	[r0]				// store back into r0

	b	controller				// branch
	pop	{lr}					// pop
	bx	lr						// pop

/**********************************************************************/

controller:
	push {lr}					// push
	mov r6, #0					// move 0 into r5
	mov	r1,	#1					// move to set
	mov	r0,	#11					// for clock
	bl	writeGPIO				// set clock
	mov r1,	#1					// move for set
	mov	r0,	#9					// for latch
	bl	writeGPIO				// set latch
	bl	waiting12				// wait 12us
	mov	r1,	#0					// move for clear
	mov	r0,	#9					// for latch
	bl	writeGPIO				// clear latch
	mov	r5,	#0					// set i counter
pulseLoop:
	bl	waiting6				// wait 6us
	mov	r1,	#0					// move for clear
	mov	r0,	#11					// for clock
	bl	writeGPIO				// clear clock
	bl	waiting6				// wait 6us
	mov	r0,	#10					// move data
	bl	readGPIO				// read data
	lsl r4, r5					// logical shift left
	orr	r6,	r4					// store into r6
	mov	r1,	#1					// move for set
	mov	r0,	#11					// for clock
	bl	writeGPIO				// set clock
	add	r5,	#1					// increment counter by 1
	cmp	r5,	#16					// compare counter to 16
	bge	end						// branch if greater than or equal
	b	pulseLoop				// branch
end:	
	mov	r0,	r6					// move SNES action 
	pop	{lr}					// pop
	bx lr

/**********************************************************************/

readGPIO:
	ldr	r2,	=0x20200000			// load base address
	ldr	r1,	[r2, #52]			// load into r1
	mov	r3,	#1					// move 1 into r3
	lsl	r3,	r0					// logical shift left
	and	r1,	r3					// and together r1 and r3
	teq	r1,	#0					// test equal r1 and 0
	moveq	r4,	#0				// move 0 into r4 if equal
	movne	r4,	#1				// move 1 into r4 if not equal
	bx lr						// pop back
	
/**********************************************************************/

writeGPIO:
	ldr	r2,	=0x20200000			// load base address
	mov	r3,	#1					// move 1 into r3
	lsl	r3,	r0					// logical shift left
	teq	r1,	#0					// test equal r1 and 0
	streq	r3,	[r2,	#40]	// store into r2-offset40 if equal
	strne	r3,	[r2,	#28]	// store into r2-offset28 if equal
	bx	lr						// pop back

/**********************************************************************/

waiting12:
	ldr	r0,	=0x20003004			// load CLO address
	ldr	r1,	[r0]				// load from address
	add	r1,	#12					// increase by 12

waitLoop:
	ldr	r2,	[r0]				// load into r2
	cmp	r1,	r2					// compare r1 and r2
	bhi waitLoop				// branch-hi
	bx	lr						// pop back

waiting6:
	ldr	r0,	=0x20003004			// load CLO address
	ldr	r1,	[r0]				// load from address
	add	r1,	#6					// increase by 6

waitLoop6:
	ldr	r2,	[r0]				// load into r2
	cmp	r1,	r2					// compare r1 and r2
	bhi waitLoop6				// branch-hi
	bx	lr						// pop back
