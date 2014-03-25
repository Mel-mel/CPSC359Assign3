.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
	
	bl		EnableJTAG
	bl		InitFrameBuffer

	bl drawMap

snes:
	bl InitSNESController
	bl readSnesController
	
haltLoop$:
	b		haltLoop$



.section .data

