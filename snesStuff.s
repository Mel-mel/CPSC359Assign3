.section .init
/*******************************************************************/
/*Initializing SNES' GPIO lines*/
.globl InitSNESController
InitSNESController:
	push {lr}
	
	mov r0, #CLK
	mov r1, #1
	bl setGpioFunction
	
	mov r0, #LAT
	mov r1, #1
	bl setGpioFunction
	
	mov r0, #DAT
	mov r1, #0
	bl setGpioFunction
	
	pop {pc}
/*******************************************************************/
/*Reading the SNES controller*/
.globl readSnesController
readSnesController:
	push {r4, r5, lr}
	
	bitMask .req r4
	buttonWord .req r5
	
	mov bitMask, #1
	mov r7, #0
	
	mov r0, #CLK
	mov r1, #1
	bl setGpio
	
	mov r0, #LAT
	mov r1, #1
	bl setGpio
	
	mov r0, #FULLCYCLE
	bl timedWait
	
	mov r0, #LAT
	mov r1, #0
	bl setGpio
	
clockLoop:
	mov r0, #HALFCYCLE
	bl timedWait
	
	mov r0, #CLK
	mov r1, #0
	bl setGpio
	
	mov r0, #HALFCYCLE
	bl timedWait
	
	mov r0, #DAT
	bl getGpio
	
	teq r0, #0
	orrne buttonWord, bitMask
	
	mov r0, #CLK
	mov r1, #1
	bl setGpio
	
	lsl bitMask, #1
	
	cmp bitMask, #65536
	blo clockLoop
	
	mov r0, buttonWord
	
	pop {r4, r5, pc}
/*******************************************************************/
/*get GPIO base address*/
getGpioAddress:
	ldr r0, =0x202000000
	mov pc, lr
/*******************************************************************/	
/*Set pin function*/
setGpioFunction:
	push {lr}
	mov r2, r0
	bl getGpioAddress
	
functionLoop:
	cmp r2, #9
	subhi r2, #10
	addhi r0, #4
	bhi functionLoop
	
	add r2, r2, lsl #1
	lsl r1, r2
	mov r3, #7
	lsl r3, r2
	ldr r2, [r0]
	bic r2, r3
	orr r1, r2
	
	str r1, [r0]
	
	pop {pc}			//return
/*******************************************************************/
/*writing to (setting) a GPIO line*/
setGpio:
	push {lr}				// push lr on stack
	mov r2, r0			// store pinNum in r2

	bl getGpioAddress			// call GetGpioAddress
	
	lsr r3, r2, #5			//pinBank pinNum >> 5 (div by 32)
	lsl r3, #2				// pinBank <<= 2 (mult by 4)
	add r0, r3		// add pinBank offset to gpioAdr
	
	and r2, #31			// and-mask pinNum with 31 )%= 32)
	mov r3, #1
	lsl r3, r2

	
	teq r1, #0			// test if pinVal == 0
	streq r3, [r0, #40]			// store setBit at gpioAdr + 40 if pinVal == 0
	strne r3, [r0, #28]			// store setBit at gpioAdr + 28 if pinVal != 0
	
	pop {pc}				// return
/*******************************************************************/
/*reading (getting) a GPIO line*/
getGpio:
	push {r4, lr}
	
	mov r4, r0
	
	bl getGpioAddress
	
	pinBank .req r3
	lsr r3, r4, #5
	lsl r3, #2
	add r0, r3
	
	and r4, #31
	mov r3, #1
	lsl r3, r4
	
	ldr r4, [r0, #52]
	and r4, r3
	
	teq r4, #0
	moveq r0, #0
	movne r0, #1
	
	pop {r4, pc}
/*******************************************************************/
/*Timed wait*/
timedWait:
	cmp r5, #16
	bge	leaveTime
	ldr r1, =0x20003004	//address of CLO
	ldr r2, [r1]		//read CLO
	add r2, r0			//add number of micros (either 6 or 12)
waitLoop:
	ldr r3, [r1]
	cmp r2, r3			//stop when CLO = r1
	bhi waitLoop
	
leaveTime:
	pop {pc}
/*******************************************************************/
/*******************************************************************/
.section .data

.equ LAT, 9
.equ DAT, 10
.equ CLK, 11
.equ HALFCYCLE, 6
.equ FULLCYCLE, 12

