.section .init
.globl _start

start:
	b go
	.section .text

.globl go
go:
	mov sp, #0x8000
	bl EnableJTAG

	bl frameBuffer

	mov r5, #0
waitFull:
	cmp r5, #16
	bg	leaveLoop
	ldr r0, =0x20003004	//address of CLO
	ldr r1, [r0]		//read CLO
	add r1, #12			//add 12 micros
waitLoop:
	ldr r2, [r0]
	cmp r1, r2			//stop when CLO = r1
	bhi waitLoop	

waitHalf:
	cmp r5, #16
	bg	leaveLoop
	ldr r0, =0x20003004	//address of CLO
	ldr r1, [r0]		//read CLO
	add r1, #6			//add 12 micros
waitLoop2:
	ldr r2, [r0]
	cmp r1, r2			//stop when CLO = r1
	bhi waitLoop2	
leaveLoop:
	

	



haltLoop$:
	b haltLoop $		//end program

/************************************************************
	functions
*/
.section .init

.globl readGPIO
readGPIO:
	push	{r4, r5, lr}
	
	bitMask .req r4
	buttonWord .req r5

	mov bitmask, #1
	mov conWord, #0

	mov r0, #11				//clock
	mov r1, #1
	bl setGPIO				//write 1 to clock

	mov r0, #10				//latch
	mov r1, #1
	bl setGPIO				//write 1 to latch

	mov r0, #12				//move full cycle 12us
	bl waitFull

	mov	r0, #9				//latch
	mov r1, #0
	bl setGPIO				//write 0 to latch

/*****************************************************************/
.globl setGPIO
setGPIO:	

/*****************************************************************/
