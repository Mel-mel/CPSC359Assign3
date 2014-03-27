.section	.init
.globl		controllerInit
controllerInit:
	push	{lr}
	ldr	r0,	=0x20200004	//Sets gpio 11 clk
	ldr	r1,	[r0]
	mov	r2,	#7
	lsl	r2,	#3
	bic	r1,	r2
	mov	r3,	#1
	lsl	r3,	#3
	orr	r1,	r3
	str	r1,	[r0]

	ldr	r0,	=0x20200004	//Sets gpio 10 data
	ldr	r1,	[r0]
	mov	r2,	#7
	bic	r1,	r2
	str	r1,	[r0]

	ldr	r0,	=0x20200000	//sets gpio 9 latch
	ldr	r1,	[r0]
	mov	r2,	#7
	lsl	r2,	#27
	bic	r1,	r2
	mov	r3,	#1
	lsl	r3,	#27
	orr	r1,	r3
	str	r1,	[r0]

	b	controller

	pop	{lr}
	bx	lr


controller:
	push {lr}
	mov r6, #0			
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
	//lsr	r6,	#1					// shift
	bl	waiting6				// wait 6us
	mov	r1,	#0					// move for clear
	mov	r0,	#11					// for clock
	bl	writeGPIO				// clear clock
	bl	waiting6				// wait 6us
	mov	r0,	#10					// move data
	bl	readGPIO				// read data
check:
	lsl r4, r5
	orr	r6,	r4					// store into r6
	mov	r1,	#1					// move for set
	mov	r0,	#11					// for clock
	bl	writeGPIO				// set clock
	add	r5,	#1
	cmp	r5,	#16
	bge	end
	b	pulseLoop
end:
	pop	{lr}


readGPIO:
	ldr	r2,	=0x20200000
	ldr	r1,	[r2, #52]
	mov	r3,	#1
	lsl	r3,	r0
	and	r1,	r3
	teq	r1,	#0
	moveq	r4,	#0
	movne	r4,	#1
	bx lr
	

writeGPIO:
	ldr	r2,	=0x20200000
	mov	r3,	#1
	lsl	r3,	r0
	teq	r1,	#0
	streq	r3,	[r2,	#40]
	strne	r3,	[r2,	#28]
	bx	lr

waiting12:
	ldr	r0,	=0x20003004
	ldr	r1,	[r0]
	add	r1,	#12

waitLoop:
	ldr	r2,	[r0]
	cmp	r1,	r2
	bhi waitLoop
	bx	lr

waiting6:
	ldr	r0,	=0x20003004
	ldr	r1,	[r0]
	add	r1,	#6

waitLoop6:
	ldr	r2,	[r0]
	cmp	r1,	r2
	bhi waitLoop6
	bx	lr
