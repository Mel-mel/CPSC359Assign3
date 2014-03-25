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
	add	r1,	#30, lsl #2	//Do i need "!" beside r1, (i think soo...?? its at the veryyyy beginning so somewhere at the very top right after initMap is done initializing)
	ldr	r7,	[r1]	//Player position at initialization (should move this value into a r3 as an arguement)

looping:

	bl snes whatevers	//Better change this :3

//Try to mush together right, left, up, and down using scratch registers to optimize it
//Im going to need to get the output from the SNES controller in r0 since im going to be using that to compare
checkRight:
	ldr	r6,	=moveRight	//Load address of moveRight
	ldr	r5,	[r6]		//Get binary value for moving right
	cmp	r0,	r5		//Compare binary values of moving right and input from controller
	bne	left			//Branch if values do not match
	bl	right			//Branch to right function
	b	looping	
	
checkLeft:
	ldr	r6,	=moveLeft	//Load address of moveLeft
	ldr	r5,	[r6]		//Get binary value for moving left
	cmp	r0,	r5,		//Compare binary value of moving left and input from the controller
	bne	up			//Branch if values do not match
	bl	left			//Branch to left function
	b	looping
	
checkUp:
	ldr	r6,	=moveUp		//Load address of moveUp
	ldr	r5,	[r6]		//Get binary value for moving up
	cmp	r0,	r5		//Compare binary value of moving up and input from the controller
	bne	down			//Branch if values do not match
	bl	up			//Branch to up function
	b	looping

checkDown:
	ldr	r6,	=moveDown	//Load address of moveDown
	ldr	r5,	[r6]		//Get binary value for moving down
	cmp	r0,	r5		//Compare binary value of moving down and input from the controller
	bne	pressButtonA		//Branch to pressButtonA since all directional buttons werent press
	bl	down			//Branch to down function
	b	looping
		
checkStart:
	ldr	r6,	=startButton	//Load address of startButton
	ldr	r5,	[r6]		//Get binary value of start button
	cmp	r0,	r5		//Compare binary value of start button to input from the controller
	bne	pressButtonA		//Branch to the pressButtonA if values do not match
	bl	gameMenu		//Branch to the game menu (in a different file)
	b	looping
	
pressButtonA:
	ldr	r3,	=pressedA	//Load address of pressedA
	ldr	r5,	[r3]		//Get binary value for pressing the "A" button
	cmp	r0,	r5		//Compare binary value of pressing the "A" button to inout from controller
	bne	looping			//If no other button is pressed other than the ones above. Branch back to looping to wait for another input from controller
	bl	pressedA
	b	looping


//Need to have the state of the game set first. Default is false
//since false in this case would mean that the game isnt complete yet
//Otherwise, set true if the game is complete and certain conditions are met
	
	
	


//need to compare the binary value if its moving or pressing then branch to corresponding function

//********************************
//This is strictly for determining if a move is valid as well as moving in the correct direction
//*Need to return the map address and move it to r1 (calculating the offset has been done already)*

	//r0 should binary value for a pressed button
	//r7 == 3 (player value)
	
right:
	push	{r7, lr}
	
	ldr	r4,	[r1, #16, lsl #2]	//Load the address of the tile to the right of the player
	cmp	r4,	#0		//Compare value of r4 to 0 (floor)
	beq	validMoveRight		//Branch if r4 == 0
	
	cmp	r4,	#1		//Compare value of r4 to 1 (wall)
	beq	invalidMove		//Branch if r4 == 1
	
	cmp	r4,	#4		//Compare value of r4 to 4 (key)
	beq	takeKeyRight		//Branch if r4 == 4
	
	cmp	r4,	#5		//Compare value of r4 to 5 (door)
	beq	invalidMove		//Branch if r4 == 5. This acts like a door. Cause if the player tries to move through
					//a door without using a key or they havent opened it yet with one
	pop	{r7, lr}
	bx	lr			//Branch back to the calling code
		
left:
	push	{r7, lr}
					
	ldrb	r4,	[r1, #-16, lsl #2]	//Load the address of the tile to the left of the player
	cmp	r4,	#0		//Compare value of r4 to 0 (floor)
	beq	validMoveLeft		//Branch if r4 == 0
	
	cmp	r4,	#1		//Compare value of r4 to 1 (wall)
	beq	invalidMove		//Branch if r4 == 1
	
	cmp	r4,	#4		//Compare value of r4 to 4 (key)
	beq	takeKeyLeft		//Branch if r4 == 4
	
	cmp	r4,	#5		//Compare value of r4 to 5 (door)
	beq	invalidMove		//Branch if r4 == 5. This acts like a wall. Same idea used in the right label
	
	pop	{r7, lr}
	bx	lr			//Branch back to the calling code
	
up:	
	push	{r7, lr}
	
	ldr	r4,	[r1, #-1, lsl #2]	//Load the address of the tile above the player
	cmp	r4,	#0		//Compare value of r4 to 0 (floor)
	beq	validMoveUp		//Branch if r4 == 0
	
	cmp	r4,	#1		//Compare value of r4 to 1 (wall)
	beq	invalidMove		//Branch if r4 == 1
	
	cmp	r4,	#4		//Compare value of r4 to 4 (key)
	beq	takeKeyUp		//Branch if r4 == 4
	
	cmp	r4,	#5		//Compare value of r4 to 5 (door)
	beq	invalidMove		//Branch if r4 == 5. This acts like a wall.
	
	pop	{r7, lr}
	bx 	lr			//Branch back to the calling code
	
down:
	push	{r7, lr}
	
	ldr	r4,	[r1, #1, lsl #2]	//Load the address of the tile below the player
	cmp	r4,	#0		//Compare value of r4 to 0 (floor)
	beq	validMoveDown		//Branch if r4 == 0
	
	cmp	r4,	#1		//Compare value of r4 to 1 (wall)
	beq	invalidMove		//Branch if r4 == 1
	
	cmp	r4,	#4		//Compare value of r4 to 4 (key)
	beq	takeKey			//Branch if r4 == 4
	
	cmp	r4,	#5		//Compare value of r4 to 5 (door)
	beq	invalidMove		//Branch if r4 == 5. This acts like a door.
	
	cmp	r4,	#6		//Compare value of r4 to 6 (exit door)
	beq	invalidMove		//Branch if r4 == 6. Cannot walk through a door without opening it first (check number of moves if not less than 150)
	
	pop	[r7, lr}
	bx	lr			//Branch back to the calling code

//--------
	
//May need to change the offset to a different number depending on where it moves
validMoveRight:
	str	r7,	[r1, #16, lsl #2]!	//Place player to the right
	bl	decMove			//Branch to decMoves to decrement remaining moves left
	pop	{r7, lr}
	bx	lr			
	
validMoveLeft: 
	str	r7,	[r1, #-16, lsl #2]!	//Place player to the left
	bl	decMove			//Branch to decMoves to decrement remaining moves left
	pop	{r7, lr}
	bx	lr
	
validMoveUp:
	str	r7,	[r1, #-1, lsl #2]!	//Place player above its previous position
	bl	decMove			//Branch to decMoves to decrement remaining moves left
	pop	{r7, lr}
	bx	lr
	
validMoveDown:
	str	r7,	[r1, #1, lsl #2]!	//Place player below its previous position
	bl	decMove			//Branch to decMoves to decrement remaining moves left
	pop	{r7, lr}
	bx	lr
	
takeKeyLeft:
	ldr	r2,	=numKeys	//Load address of numKeys
	ldr	r6,	[r2]		//Get value of numKeys
	add	r6,	#1		//Increment number of total keys
	str	r6,	[r2]		//Store result back into numKeys address
	str	r7,	[r1, #-16, lsl #2]!	//Place player where the key was on the left (how would i set this to 0 after the player moves out and tries to move back in)
	bl	decMove			//Branch to decMove to decrement remaining moves left
	bl	fillSpace		//Branch to fillSpace when player moves
	
	pop	{r7, lr}//???
	bx	lr
	
takeKeyUp:
	ldr	r2,	=numKeys	//Load address of numKeys
	ldr	r6,	[r2]		//Get value of numKeys
	add	r6,	#1		//Increment number of total keys
	str	r6,	[r2]		//Store result back into numKeys address
	str	r7,	[r1, #-1, lsl #2]	//Place player where the key was above (how to set it to 0 after moving away from it and blah)
	bl	decMove			//Branch to decMove to decrement remaining moves left
	bl	fillSpaceUp		//Branch to fillSpaceDown 
	
	pop	{r7, lr}
	bx	lr

decMove:
	ldr	r8,	=actionMoves	//Load address of actionMoves
	ldr	r9,	[r8]		//Get value of remaining moves left
	
	sub	r9,	#1		//Subtract remaining moves by 1
	str	r9,	[r8]		//Storing result back into actionMoves
	
	pop	{r7, lr}
	bx	lr
	
fillSpaceDown:
	mov	r9,	#0
	//check which direction the player was when it moved
	//ldr	r9,	[r1, #-1, lsl #2]//Get character for player at this location. not sure if this idea works as a general thing
	str	r9,	[r1, #1, lsl #2]//Fill space where player was when it moved up (fill down space)
	

//********************************

//********************************
//This is for not invalid movement. You wont move if you press random buttons or tried some silly stuff 
invalidMove:
	push	{r7, lr}
	str	r7,	[r1]!		//Keep the player at its current position
	pop	{r7, lr}
	bx	lr
//********************************

//********************************
//This is strictly for pressing a button to open a door
//*Need to return the map address and move it to r1 (calculating the offset has been done already)*


pressedA:
	push	{r7, lr}		//SHOULD I HAVE THIS HERE FOR EVERY LABEL IN THIS PART?
	ldr	r2,	=numKeys	//Load address of numKeys
	ldr	r6,	[r2]		//Get current values of key

doorOnSides:	
	//from current player position, get the right tile
	//r1 should have the address of the map from the initMap
	ldr	r8,	[r1, #16, lsl #2]//Getting the value of right tile from the player (dont change the address)
	cmp	r8,	#5		//Comparing r8 to 5
	beq	openDoor		//Branch to openDoor when r8 == 5
	
	ldr	r8,	[r1, #-16, lsl #2]//Getting the value of the left tile from the player	
	
	sub	r6, 	#1		//Decrement total number of keys by 1
	strb	r6,	[r2]		//Store decremented result back into numKeys
	
	pop	{r7, lr}
	bx	lr			//Branch back to calling code
	
	//Need to be sure that i change the tile where the key was to a 0 to make it a floor tile after the player moves off of it...
	
openDoor:
	cmp	r6,	#0		//Compare r6 to 0
	beq	noKeys			//Branch to noKeys if r6 == 0

//********************************


haltLoop$:
	b	haltLoop$

.section .data

actionMoves:	.int	150	//Setting max number of actions
numKeys:	.int	0	//Setting default number of keys
gameState:	.byte	0	//Setting game state (win/lose)


.EQU	moveRight,	0b	//Binary value for pressing the right directional button
.EQU	moveLeft,	0b	//Binary value for pressing the left directional button
.EQU	moveUp,		0b	//Binary value for pressing the up directional button
.EQU	moveDown,	0b	//Binary value for presssing the down directional button
.EQU	pressedA,	0b	//Binary value for presssing the "A" button
.EQU	startButton,	0b	//Binary value for pressing the "start" button
.EQU	selectButton,	0b	//Binary value for pressing the "select" button

