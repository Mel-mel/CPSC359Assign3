.section .init
.globl   begin

begin:
	b	gameLogic
	
.section .text
gameLogic:
	mov     sp, #0x8000
	bl	EnableJTAG

//Need to have the state of the game set first. Default is false
//since false in this case would mean that the game isnt complete yet
//Otherwise, set true if the game is complete and certain conditions are met

//Setting state of game to false. 

//Call function to draw game map (do after logic and controller functions 
//are done)

//Maybe having the color set to the player be something that we can
//compare to when it moves or does an action. 
//Ex. when moving player and you try to walk
//through a wall then compare the wall color to the color of the player
//since they do not equal then don't allow the player to move there.

//Moving left and/or down: decrement
//Moving right and/or up: increment




haltLoop$:
	b	haltLoop$
	
.section  .data

actionMoves:	.byte	150	//Setting max number of actions
