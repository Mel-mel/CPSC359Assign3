.section .init
.globl begin

/*
Register Table:
r10 = game set state
*/
//0 = true
//1 = false


begin:
	b	gameLogic

.section .text
gameLogic:
	mov sp, #0x8000
	bl	EnableJTAG

	mov r10, #1			//Default game state to false
	
	bl	initMap			//Branch to initMap to initialize the map




//Need to have the state of the game set first. Default is false
//since false in this case would mean that the game isnt complete yet
//Otherwise, set true if the game is complete and certain conditions are met

//Setting state of game to false.

//Call function to draw game map (do after logic and controller functions
//are done)


//Moving left and/or down: decrement
//Moving right and/or up: increment




haltLoop$:
	b	haltLoop$

.section .data

actionMoves:	.byte	150	//Setting max number of actions
numKeys:		.byte	0	//Setting default number of keys
gameState:		.byte	0	//Setting game state (win/lose)
playerInitPos:	.byte	3	//Setting player value (to keep track of)

