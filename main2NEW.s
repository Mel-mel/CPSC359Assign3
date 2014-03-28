.section    .init
.globl     _starting

_starting:
    b       main
    
.section .text

main:
    mov     sp, #0x8000

	bl		EnableJTAG
	bl		InitFrameBuffer
	mov		r12,	#900
	mov		r7,	#0
	mov		r8,	#150
loopMain:
	bl drawMap
testing:
	cmp	r12,	#1016
	beq	attempt
looping:
	bl controllerInit
	mov		r9,	r0
	bl		InitFrameBuffer
	bl redraw
bam:
	b	loopMain
attempt:
	bl 		controllerInit
	mov		r9,	r0
	bl		InitFrameBuffer
	bl		rerun
	cmp		r12,	#900
	beq		loopMain
	b		attempt



haltLoop$:
	b	haltLoop$


