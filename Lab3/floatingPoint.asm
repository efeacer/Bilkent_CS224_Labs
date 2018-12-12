#This program and converts an integer given by the user to floating point representation 
#using bit manipulation.
#author: EFE ACER

	.text
	.globl	__start
__start:
	la $a0, intro #print intro
	li $v0, 4
	syscall
	li $s1, 'a'
	li $s2, 'q'
	interact:
		la $a0, option #print options
		li $v0, 4
		syscall
		li $v0, 12 #reading a character    
 		syscall
 		move $t1, $v0
 		caseA:
 			bne $t1, $s1, caseB
			la $a0, prompt1 #prompt for a positive integer
			li $v0, 4  
			syscall
			li $v0, 5 #read the positive integer
			syscall #$v0 holds the positive integer
			move $a0, $v0
			jal set$t0ToFloatingPointRepresentation #$v0 holds the binary form, $v1 holds the exponent
			mtc1 $t0, $f12
			li $v0, 2
			syscall 
		caseB:
			bne $t1, $s2, interact
			li $v0, 10 #stop execution
			syscall
	

#Sets $t0 to a positive decimal number's floating point representation
#Parameters: $a0 contains the decimal number
set$t0ToFloatingPointRepresentation:
	move $t1, $a0
	move $s0, $zero #initial exponent is 0
	countExponent: 
		ble $t1, 1, continue1
		div $t1, $t1, 2 #divide $t1 by 2
		addi $s0, $s0, 1 #increment the exponent
		j countExponent
	continue1:
	move $t0, $zero #$t0 is initially 0...0
	li $t1, 23
	add $t0, $t0, $s0
	addi $t0, $t0, 0x7F #add the excess amount to the exponent
	shiftExponent: #shifting the exponent to its correct place
		sll $t0, $t0, 1
		subi $t1, $t1, 1
		bgt $t1, $zero, shiftExponent
	move $t1, $s0
	li $t2, 1 #$t2 is the mask
	createMask: 
		ble $t1, $zero, continue2
		sll $t2, $t2, 1
		subi $t1, $t1, 1
		j createMask
	continue2:	
	subi $t2, $t2,  1 #mask is ready
	and $a0, $a0, $t2 #mask the fraction
	li $t1, 23
	sub $t1, $t1, $s0
	shiftFraction: #shifting the fraction to its correct place
		sll $a0, $a0, 1
		subi $t1, $t1, 1
		bgt $t1, $zero, shiftFraction
	add $t0, $t0, $a0 #$t0 holds the floating point representation now
	jr $ra
	
		.data
test:		.word	10
intro:		.asciiz	"This program and converts an integer given by the user to its floating point representation.\n"
option:		.asciiz	"\nPress \"a\" to enter a positive integer and \"q\" to quit:\n"
prompt1:	.asciiz	"\nPlease enter a positive integer: "

