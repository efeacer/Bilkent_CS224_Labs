#Lab 1 - Part 4 - EFE ACER
#The program evaluates the expression (a^2 - 5 * b + 7) % 4 where a and b are user inputs.
	.text
	.globl	__start	
__start:
	#Printing an intro message 
	la $a0, intro
	li $v0, 4
	syscall
	#Printing a prompt to read a
	la $a0, prompt1
	li $v0, 4
	syscall
	#Reading the value of a
	li $v0, 5
	syscall
	sw $v0, a
	#Printing a prompt to read b
	la $a0, prompt2
	li $v0, 4
	syscall
	#Reading the value of b
	li $v0, 5
	syscall
	sw $v0, b
	#Calling the calculate function with arguments a and b
	lw $a0, a
	lw $a1, b
	jal calculate
	sw $v0, answer
	#Printing a message to display the answer
	la $a0, result
	li $v0, 4
	syscall
	#Printing the answer
	lw $a0, answer
	li $v0 1
	syscall 
	#Stopping the execution
	li $v0, 10	
	syscall		

#Subprogram to evaluate (a^2 - 5 * b + 7) % 4 without using div 
calculate: 
	mul $a0, $a0, $a0 #$a0 holds a^2
	mul $a1, $a1, -5 #$a1 holds -5 * b
	add $a0, $a0, $a1 #$a0 holds a^2 - 5 * b
	addi $a0, $a0, 7 #$a0 holds a^2 - 5 * b - 7 now 
	bge $a0, $zero, else #if (a^2 - 5 * b - 7) >= 0 branch to else
	modNegative: #process to find the modulo of a negative number
		addi $a0, $a0, 4 #repeatedly add 2 to $t0
		blt $a0, $zero, modNegative #repeat until $t0 becomes positive
	j return #skip the else block 
	else: 
		modPositive: #process to find the modulo of a positive number
			subi $a0, $a0, 4 #repeatedly subtract 2 from $t0
			bge $a0, 4, modPositive #repeat until $t0 < 2
		
	return: 
		move $v0, $a0 #set $v0 to the remainder
		jr $ra #returning to the main program 

#The data segment
	    .data 
intro:	    .asciiz   "The program evaluates the expression (a^2 - 5 * b + 7) % 4.\n"
prompt1:    .asciiz   "Please enter the value of a:\n"
prompt2:    .asciiz   "Please enter the value of b:\n"
result:     .asciiz   "The answer is: "
answer:	    .word     0					
a:          .word     0
b:          .word     0
