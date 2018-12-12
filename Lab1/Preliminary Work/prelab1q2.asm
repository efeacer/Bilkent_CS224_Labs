#Preliminary Work - Question 2 - EFE ACER
#Evaluates the expression x = (c - d) % 2 without using div instruction

	.text
	.globl	__start
__start:
	#Printing an intro message 
	la $a0, intro
	li $v0, 4
	syscall
	#Printing a prompt to read c
	la $a0, prompt1
	li $v0, 4
	syscall
	#Reading the value of c
	li $v0, 5
	syscall
	sw $v0, c
	#Printing a prompt to read d
	la $a0, prompt2
	li $v0, 4
	syscall
	#Reading the value of d
	li $v0, 5
	syscall
	sw $v0, d
	#Calling the calculate function with arguments c and d
	lw $a0, c
	lw $a1, d
	jal calculate
	sw $v0, x
	#Printing a message to display x
	la $a0, result
	li $v0, 4
	syscall
	#Printing the result value x
	lw $a0, x
	li $v0 1
	syscall 
	#Stopping the execution
	li $v0, 10	
	syscall		

#Subprogram to evaluate x = (c - d) % 2 without using div 
calculate: 
	sub $t0, $a0, $a1
	bge $t0, $zero, else #if (c - d) >= 0 branch to else
	modNegative: #process to find the modulo of a negative number
		addi $t0, $t0, 2 #repeatedly add 2 to $t0
		blt $t0, $zero, modNegative #repeat until $t0 becomes positive
	j return #skip the else block 
	else: 
		modPositive: #process to find the modulo of a positive number
			subi $t0, $t0, 2 #repeatedly subtract 2 from $t0
			bge $t0, 2, modPositive #repeat until $t0 < 2
		
	return: 
		move $v0, $t0 #set $v0 to the remainder
		jr $ra #returning to the main program 

#The data segment
	    .data 
intro:	    .asciiz   "The program evaluates the expression x = (c - d) % 2.\n"
prompt1:    .asciiz   "Please enter the value of c:\n"
prompt2:    .asciiz   "Please enter the value of d:\n"
result:     .asciiz   "The value of x is: "
x:	    .word     0					
c:          .word     0
d:          .word     0
