#Prelab 3 - parts a and b
#This program recursively multiplies two numbers and finds the summation of numbers from 1 to N.
#Author: EFE ACER

	.text 
	.globl	__start

#Main
__start:
	la $a0, intro #print intro
	li $v0, 4
	syscall
	la $a0, prompt1 #print prompt to read a multiplicand
	li $v0, 4
	syscall
	li $v0, 5 #read the multiplicand
	syscall 
	move $t0, $v0
	la $a0, prompt2 #print prompt to read a multiplier
	li $v0, 4
	syscall
	li $v0, 5 #read the multiplier
	syscall 
	move $a0, $t0 #set $a0 to the multiplicand
	move $a1, $v0 #set $a1 to the multiplier
	jal recursiveMultiplication #call the multiplication method
	move $t0, $v0 #$t0 holds the result of the multiplication
	la $a0, result1 #print a message to display the result of the multiplication
	li $v0, 4
	syscall
	move $a0, $t0 #print the result of the multiplication
	li $v0, 1
	syscall
	la $a0, prompt3 #print prompt to read N
	li $v0, 4
	syscall
	li $v0, 5 #read N
	syscall 
	move $a0, $v0
	jal recursiveSummation #set $a0 to N
	move $t0, $v0 #$t0 holds the result of the summation
	la $a0, result2 #print a message to display the result of the summation
	li $v0, 4
	syscall
	move $a0, $t0 #print the result of the summation
	li $v0, 1
	syscall
	li $v0, 10 #stop execution 
	syscall

#This method performs a multiplication recursively
#Parameters: $a0 contains the multiplicand, $a1 contains the multiplier
#Return value: $v0 contains the result of the multiplication		
recursiveMultiplication:
	subi $sp, $sp, 8
	sw $a1, 4($sp) #push (save) the multiplier to the stack
	sw $ra, 0($sp) #push (save) the return address to the stack
	bgt $a1, 1, recursiveCaseMultiplication
	#baseCase:
		move $v0, $a0 #if (multiplier == 1) {sum = multiplicand;}
		addi $sp, $sp, 8
		jr $ra #jump to the previous call
	recursiveCaseMultiplication:
		subi $a1, $a1, 1 #decrement the multiplier for recursive call
		jal recursiveMultiplication
		lw $ra, 0($sp) #pop (load) the return address from the stack
		lw $a1, 4($sp) #pop (load) the multiplier from the stack
		addi $sp, $sp, 8
		add $v0, $v0, $a0 #increment the result after recursive calls	 
		jr $ra #jump to the previous call
		
#This method finds the summation of numbers from 1 to N
#Parameters: $a0 contains N
#Return value: $v0 contains the result of the summation
recursiveSummation:
	subi $sp, $sp, 8
	sw $a0, 4($sp) #push (save) N to the stack
	sw $ra, 0($sp)	#push (save) the return address to the stack
	bgt $a0, 1, recursiveCaseSummation	
	#baseCase: 
		move $v0, $a0 #if (N == 1) {sum = 1;}
		addi $sp, $sp, 8
		jr $ra #jump to the previous call
	recursiveCaseSummation:
		subi $a0, $a0, 1 #decrement N for the recursive call
		jal recursiveSummation
		lw $ra, 0($sp)	#pop (load) the return address from stack	
		lw $a0, 4($sp) #pop (load) N from the stack
		addi $sp, $sp, 8
		add $v0, $v0, $a0 #increment the result after recursive calls
		jr $ra #jump to the previous call

#The data segment		
		.data 
intro:		.asciiz	"This program recursively multiplies two numbers and finds the summation of numbers from 1 to N.\n"
prompt1: 	.asciiz	"\nPlease enter a value for the multiplicand: "
prompt2:	.asciiz	"\nPlease enter a value that is greater than 1 for the multiplier: "
prompt3:	.asciiz	"\n\nPlease enter a value that is greater than 1 for N: "
result1:	.asciiz	"\nThe result of the multiplication is: "
result2:	.asciiz	"\nThe result of the summation is: "

