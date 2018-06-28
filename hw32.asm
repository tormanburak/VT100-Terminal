##################################
# Part 1 - String Functions
##################################

is_whitespace:
	######################
	li $t0, ' '
	li $t1, '\0'
	li $t2, '\n'
	beq $a0,$t0,whiteSpace
	beq $a0,$t1,whiteSpace
	beq $a0,$t2,whiteSpace
	
	li $v0,0
	jr $ra
	
	whiteSpace:
	li $v0,1
	######################
	jr $ra

cmp_whitespace:
	######################
	addi $sp,$sp,-12
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $ra,8($sp)
	
	li $s0,0 #counter for how many times to jal to is_whitespace
	
	
	cmpWhiteLoop:
	bgt $s0,1,checkedBothChars
	
	jal is_whitespace

	
	addi $s0,$s0,1
	move $s1,$v0
	move $a0,$a1
	j cmpWhiteLoop
	
	checkedBothChars:
	beqz $s1,notWhiteSpace
	beqz $v0,notWhiteSpace
	li $v0,1
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $ra,8($sp)
	addi $sp,$sp,12
	jr $ra
	notWhiteSpace:
	li $v0,0
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $ra,8($sp)
	addi $sp,$sp,12
	jr $ra

strcpy:
	######################
	ble $a0,$a1,doneCopying
	li $t0,0 #counter for how many bytes to be copied
	
	strcpyLoop:
	beq $t0,$a2,doneCopying
	lb $t1,0($a0)
	sb $t1,0($a1)
	
	addi $a0,$a0,1
	addi $a1,$a1,1
	addi $t0,$t0,1
	j strcpyLoop
	
	doneCopying:
	jr $ra

strlen:
	######################
	addi $sp,$sp,-20
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	sw $s3,12($sp)
	sw $ra,16($sp)
	
	li $s2,0
	li $s3,0
	move $s0,$a0
	
	strlenLoop:
	lb $s1,0($s0)
	move $a0,$s1

	jal is_whitespace
	
	bgtz $v0,doneCounting
	addi $s3,$s3,1
	addi $s0,$s0,1
	j strlenLoop
	
	
	
	doneCounting:
	move $v0,$s3
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	lw $ra,16($sp)
	addi $sp,$sp,20
	jr $ra

##################################
# Part 2 - vt100 MMIO Functions
##################################

set_state_color:
	######################
	beq $a3,0,setBoth
	beq $a3,1,setFg
	beq $a3,2,setBg
	
	setBoth:
	beq $a2,1,setBothHighlight
	sb $a1,0($a0)
	jr $ra
	setBothHighlight:
	addi $a0,$a0,1
	sb $a1,0($a0)
	jr $ra
	
	setFg:
	beq $a2,1,setFgHighlight
	lbu $t0,($a0)	
	andi $t0,$t0,0xf0
	andi $a1,$a1,0x0f
	or $a1,$a1,$t0
	sb $a1,0($a0)
	jr $ra
	setFgHighlight:
	addi $a0,$a0,1
	lbu $t0,($a0)	
	andi $t0,$t0,0xf0
	andi $a1,$a1,0x0f
	or $a1,$a1,$t0
	sb $a1,0($a0)
	jr $ra
	
	setBg:
	beq $a2,1,setBgHighlight
	lbu $t0,($a0)	
	andi $t0,$t0,0x0f
	andi $a1,$a1,0xf0
	or $a1,$a1,$t0
	sb $a1,0($a0)
	jr $ra
	setBgHighlight:
	addi $a0,$a0,1
	lbu $t0,($a0)	
	andi $t0,$t0,0x0f
	andi $a1,$a1,0xf0
	or $a1,$a1,$t0
	sb $a1,0($a0)
	jr $ra

save_char:
	######################
	# Insert your code here
	li $t0,0xffff0000
	li $t1,160
	li $t2,2
	
	lbu $t3,2($a0)	# cursor x value	
	lbu $t4,3($a0)	# cursor y value
	
	mul $t3,$t3,$t1
	mul $t4,$t4,$t2
	add $t3,$t3,$t4
	add $t0,$t0,$t3
	
	
	sb $a1,0($t0)
	
	jr $ra
reset:
	######################
	move $t0,$a0	#address of struct
	move $t1,$a1	# the condition value
	li $t4,0xffff0fa0	#last address of cells
	
	beqz $t1,resetBoth
	li $t2,0xffff0001
	resetColorLoop:
	bgt $t2,$t4,doneResetting
	lbu $t3,0($t0)
	sb $t3,0($t2)
	
	addi $t2,$t2,2
	j resetColorLoop
	
	
	resetBoth:
	li $t2,0xffff0000
	li $t5,'\0'
	resetBothLoop:
	bgt $t2,$t4,doneResetting
	lbu $t3,0($t0)
	sb $t3,1($t2)
	sb $t5,0($t2)
	addi $t2,$t2,2
	j resetBothLoop
	
	doneResetting:
	jr $ra

clear_line:
	######################
	li $t0,160 
	li $t5,0xffff0000
	mul $a0,$a0,$t0	#x position
	li $t0,2
	mul $a1,$a1,$t0	#y position
	add $t1,$a0,$a1	
	add $t6,$t5,$t1 #adress of the starting position (x,y)
	li $t2,79
	mul $t2,$t2,$t0
	add $t3,$t2,$a0	
	add $t7,$t5,$t3	# ending position
	li $t0, '\0'
	clearingLoop:
	bgt $t6,$t7,endClearing
	sb $t0,0($t6)
	sb $a2,1($t6)
	addi $t6,$t6,2
	j clearingLoop
	
	endClearing:
	
	jr $ra

set_cursor:
	######################
	li $t0,160
	li $t1,2
	li $t6,0xffff0000
	move $s1,$a1
	move $s2,$a2

	lbu $t2,2($a0)	# x in struct
	lbu $t3,3($a0)	# y in struct
	sb $s1,2($a0)
	sb $s2,3($a0)
	
	mul $t2,$t2,$t0
	mul $t3,$t3,$t1
	add $t4,$t3,$t2	
	add $t4,$t4,$t6	# cursors pos in struct
	mul $a1,$s1,$t0
	mul $a2,$s2,$t1
	add $t5,$a2,$a1
	add $t5,$t5,$t6	#cursors new position
	li $t0,0x88
	lb $t3,1($t4)
	lb $t2,1($t5)
	bgtz $a3,dontClearCursor
	xor $t3,$t3,$t0
	xor $t2,$t2,$t0
	sb $t3,1($t4)
	sb $t2,1($t5)
	jr $ra
	
	dontClearCursor:
	xor $t2,$t2,$t0
	sb $t2,1($t5)

	jr $ra


move_cursor:
	######################
	addi $sp,$sp,-16
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s4,8($sp)
	sw $ra,12($sp)
	move $s4,$a0
	lbu $s0,2($a0)	#x in struct
	lbu $s1,3($a0)	#y in struct
	
	beq $a1,'h',left
	beq $a1,'j',down
	beq $a1,'k',up
	
	#right
	li $t0,79
	beq $s1,$t0,dontMove		
	addi $a2,$s1,1	
	move $a1,$s0
	li $a3,0
	j moveIt
	
	left:
	li $t0,0
	beq $s1,$t0,dontMove		
	addi $a2,$s1,-1	
	move $a1,$s0
	li $a3,0
	j moveIt
	
	down:
	li $t0,24
	beq $s0,$t0,dontMove		
	addi $a1,$s0,1	
	move $a2,$s1
	li $a3,0
	j moveIt
	
	up:
	li $t0,0
	beq $s0,$t0,dontMove		
	addi $a1,$s0,-1	
	move $a2,$s1
	li $a3,0
	j moveIt
	
	
	moveIt:
	
	jal set_cursor
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s4,8($sp)
	lw $ra,12($sp)
	addi $sp,$sp,16
	jr $ra
	
	dontMove:
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s4,8($sp)
	lw $ra,12($sp)
	addi $sp,$sp,16	
	jr $ra


mmio_streq:
	######################
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0
	move $s1, $a1
	li $s2, 0
	li $s3, 0
	streqLoop:
	lb $s4, ($s0)	
	lb $s5, ($s1)	
	seq $s3, $s4, $s5	
	move $a0, $s4
	move $a1, $s5
	jal cmp_whitespace
	move $s2, $v0
	
	beq $s2, 1, endstreqLoop
	add $s2,$s3, $s2
	beq $s2, 0, endstreqLoopWithZero
	addi $s0, $s0, 2	#increment
	addi $s1, $s1, 1	
	j streqLoop
	endstreqLoopWithZero:
	move $v0, $0
	j streqDone
	endstreqLoop:
	li $v0, 1
	
	streqDone:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
	######################
	jr $ra

##################################
# Part 3 - UI/UX Functions
##################################

handle_nl:
	######################
	addi $sp,$sp,-8
	sw $s0,0($sp)
	sw $ra,4($sp)
	move $s0,$a0
	li $a1,'\n'
	jal save_char
	lw $s0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	
	
	addi $sp,$sp,-8
	sw $s0,0($sp)
	sw $ra,4($sp)
	lbu $t0,2($a0)
	lbu $t1,3($a0)
	lbu $t2,0($a0)
	move $a0,$t0
	move $a1,$t1
	move $a2,$t2
	jal clear_line
	lw $s0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	
	
	addi $sp,$sp,-8
	sw $s0,0($sp)
	sw $ra,4($sp)
	lbu $t0,2($s0)
	addi $a1,$t0,1
	move $a0,$s0
	li $a2,0
	li $a3,0
	jal set_cursor
	lw $s0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	jr $ra
handle_backspace:
	#a0,struct
	lbu $s0,2($a0)	# x in struct
	lbu $s1,3($a0)	# y in struct
	move $s6,$s1
	# settin (x,79) to null
	li $t0,160
	mul $t1,$t0,$s0
	li $t0,2
	li $t2,79
	mul $t2,$t2,$t0
	add $t1,$t1,$t2
	li $t0,0xffff0000
	add $t1,$t1,$t0
	li $t0, '\0'
	sb $t0,0($t1)
	##### shifting chars
	li $t0,160
	mul $t1,$t0,$s0
	li $t0,2
	mul $t2,$t0,$s1
	add $t1,$t1,$t2
	li $t0,0xffff0000
	add $t1,$t1,$t0	#cursor pos
	addi $t2,$t1,2	# n+1
	move $s2,$t1
	move $s3,$t2
	backSpaceLoop:
	li $t0,79
	beq $s6,$t0,doneBackSpace
	move $a0,$s3
	move $a1,$s2
	li $a2,1
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal strcpy
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	addi $s2,$s2,2
	addi $s3,$s3,2
	addi $s6,$s6,1
	j backSpaceLoop
	doneBackSpace:
	jr $ra

highlight:
	# a0, x
	# a1, y
	# a2, color
	# a3,n
	li $t0,160
	mul $t1,$a0,$t0
	li $t0,2
	mul $t2,$a1,$t0
	add $t1,$t1,$t2
	li $t0,0xffff0000
	add $t1,$t1,$t0	#starting position/cell
	li $t3,0 #counter
	highLoop:
	beq $t3,$a3,doneHighlight
	sb $a2,1($t1)
	addi $t1,$t1,2
	addi $t3,$t3,1
	j highLoop
	
	doneHighlight:
	
	jr $ra

highlight_all:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0		#color
	move $s4, $a1		#dic	
	li $s2, 0xffff0fa0	#last cell
	li $s3, 0xffff0000
	endHighlight:
	bge $s3, $s2, finishHighlight
	move $s1, $s4
		
	move $s5, $s3	
	firstHighlight:	
	lb $t0, ($s5)
	move $a0, $t0
	jal is_whitespace
	beq $v0, 0, endHighlightAll
	addi $s5, $s5, 2
	bge $s5, $s2, nextString
	j firstHighlight
	endHighlightAll:
		

	secondHighlight:
	lw $a1, ($s1)		
	move $a0, $s5 		
	jal mmio_streq
	
	beq $v0, 1, exitChecking 
	li $t2, 0x00  
	addi $s1, $s1, 4 
	lw $t3, ($s1)
	beq $t2, $t3, nextString
	j secondHighlight
	exitChecking:
	move $a0, $s5
	jal strlen
	move $t9, $v0		
	li $t3, 160
	li $t4, 2
	div $t9, $t4
	mflo $a3
	li $t9, 0xffff0000
	sub $t5, $s5, $t9	
	div $t5, $t3	
	mflo $a0		#x value
	mfhi $t6		
	div $t6, $t4
	mflo $a1		#y value
	move $a2, $s0		#color
	jal highlight
	nextString:
	bge $s5, $s2, moveString
	lb $t0, ($s5)
	move $a0, $t0
	jal is_whitespace
	beq $v0,1, moveString
	addi $s5, $s5, 2
	j nextString
	moveString:
	move $s3,$s5	
	j endHighlight
	finishHighlight:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28

	jr $ra
