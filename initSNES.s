.section .init
.globl initSNES

setClock:
	ldr r0, =0x20200004	// address for GPFSEL1
	ldr r1, [r0]		// copy GPFSEL1 into r1
	mov r2, #7			// (b0111)
	lsl r2, #3			// index of 1st bit for pin11 (r2 = 0 111 000)
	bic r1, r2			// clear pin11 bits
	mov r3, #1			// output function code
	lsl r3, #3			// r3 = 0 001 000
	orr r1, r3			// set pin11 function in r1
	str r1, [r0]		// write back to GPFSEL1

setLatch:
	ldr r4, =0x20200004	// address for GPFSEL1
	ldr r5, [r4]		// copy GPFSEL1 into r1
	mov r6, #7			// (b0111)
	lsl r6, #27			// index of 1st bit for pin11 (r2 = 0 111 000)
	bic r5, r6			// clear pin11 bits
	mov r6, #1			// output function code
	lsl r6, #27			// r3 = 0 001 000
	orr r5, r6			// set pin11 function in r1
	str r5, [r4]		// write back to GPFSEL1

setData:
	ldr r4, =0x20200000	// address for GPFSEL1
	ldr r5, [r4]		// copy GPFSEL1 into r1
	mov r6, #7			// (b0111)
	bic r5, r6			// clear pin11 bits
	str r5, [r4]		// write back to GPFSEL1
