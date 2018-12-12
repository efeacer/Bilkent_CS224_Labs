#Lab 1 - Part 5 - EFE ACER
#The program lets the user initialize an array and perform certain operations on it, it provides
#a simple comment based menu for the operation selection.

	.text
	.globl	__start
__start:
	la $a0, intro #pringting an intro message 
	li $v0, 4
	syscall
	#Calling the readArraySize function to determine the array's size
	jal readArraySize
	#Calling the readItems function to read the values of the elements
	jal readItems
	#The loop based menu 
	li $t7, 'd' #$t7 holds the quit option
	mainLoop:
		jal printOptions
		li $t1, 'a'
		li $t2, 'b'
		li $t3, 'c'
		li $v0, 12 #reading a character    
 		syscall
 		#Different cases regarding different menu options
 		caseA:
 			bne $v0, $t1, caseB 
 			jal printSumOfNumsGreaterThan
 			j default
 		caseB:
 			bne $v0, $t2, caseC
 			jal printSumOfOddAndEvenItems
 			j default
 		caseC:
 			bne $v0, $t3, caseD
 			jal printNumberOfItemsDivisibleBy
 			j default
 		caseD:	bne $v0, $t7, caseInvalid
 			j default
 		caseInvalid:
 			la $a0, error #pringting a prompt to read items one by one
			li $v0, 4
			syscall
 		default:
 			bne $v0, $t7, mainLoop
	li $v0, 10 #Stopping the execution
	syscall
	
#Subprogram to read the array size
readArraySize: 
	la $a0, prompt1 #pringting a prompt to read arraySize
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, arraySize
	jr $ra #returning to the main program
	
#Subprogram to read arraySize number of itens to the array
readItems:
	la $a0, prompt2 #pringting a prompt to read items one by one
	li $v0, 4
	syscall
	lw $t0, arraySize #t0 is set to ArraySize (counter)
	la $t1, array #$t1 points to the base address of the array
	readItem: 
		li $v0, 5 #reading an item to the current indexed position
		syscall
		sw $v0, 0($t1)
		subi $t0, $t0, 1 #decrementing the counter
		addi $t1, $t1, 4 #incrementing the pointer to the next item's adress
		bgt $t0, $zero, readItem #repeat while $t0(counter) > 0
	jr $ra #returning to the main program  

#Subprogram to find and print the summation of items in the array that are greater than a certain number
printSumOfNumsGreaterThan:
	la $a0, prompt3 #pringting a prompt to read the input number 
	li $v0, 4
	syscall
	li $v0, 5 #reading the input number that the items will be compared to
	syscall #$v0 currently holds the input number
	lw $t0, arraySize #$t0 is set to ArraySize (counter)
	la $t1, array #$t1 points to the base address of the array
	li $t2, 0 #$t2 holds the summation
	nextIteration1: 
		lw $t3, 0($t1) #store the current indexed item in $t3
		ble $t3, $v0, iterate1
		add $t2, $t2, $t3
		iterate1: subi $t0, $t0, 1 #decrementing the counter
			  addi $t1, $t1, 4 #incrementing the pointer to the next item's adress
		bgt $t0, $zero, nextIteration1  #repeat while $t0(counter) > 0
	la $a0, result1 #pringting a prompt to display the sum 
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	jr $ra

#Subprogram to find and print the sum of odd and even items
printSumOfOddAndEvenItems:
	lw $t0, arraySize #$t0 is set to ArraySize (counter)
	la $t1, array #$t1 points to the base address of the array
	li $t2, 0 #$t2 holds the summation of even numbers
	li $t3, 0 #$t3 holds the summation of odd numbers
	li $t5, 2 #$t5 holds the value of 2
	nextIteration3:
		lw $t6, 0($t1) #store the current indexed item in $t6
		div $t6, $t5 #dividing the indexed item by 2
	        mfhi $t4 #storing the remainder in $t4
	        beq $t4, $zero, evenCase
	        add $t3, $t3, $t6 #the case when the item is odd, incerementing the sum of odds
	        j iterate3
		evenCase: #the case when the item is even 
			add $t2, $t2, $t6 #incerementing the sum of evens
		iterate3: 
			subi $t0, $t0, 1 #decrementing the counter
			addi $t1, $t1, 4 #incrementing the pointer to the next item's adress
		bgt $t0, $zero, nextIteration3  #repeat while $t0(counter) > 0
	la $a0, result3 #pringting a prompt to display the sum of evens
	li $v0, 4
	syscall
	move $a0, $t2 #printing the sum of evens
	li $v0, 1
	syscall
	la $a0, result4 #pringting a prompt to display the sum of odds
	li $v0, 4
	syscall
	move $a0, $t3 #printing the sum of odds
	li $v0, 1
	syscall
	jr $ra
	
#Subprogram to find and print the number of occurences of items divisible by a certain input number
printNumberOfItemsDivisibleBy:
	la $a0, prompt4 #pringting a prompt to read the input number 
	li $v0, 4
	syscall
	li $v0, 5 #reading the input number that the items will be compared to
	syscall #$v0 currently holds the input number
	lw $t0, arraySize #$t0 is set to ArraySize (counter)
	la $t1, array #$t1 points to the base address of the array
	li $t2, 0 #$t2 holds the number of items divisible by $v0
	nextIteration2:
		lw $t3, 0($t1) #store the current indexed item in $t3
		div $t3, $v0 #dividing the indexed item by the input number
	        mfhi $t4 #storing the remainder in $t4
	        bne $t4, $zero, iterate2
	        addi $t2, $t2, 1
		iterate2: subi $t0, $t0, 1 #decrementing the counter
			  addi $t1, $t1, 4 #incrementing the pointer to the next item's adress
		bgt $t0, $zero, nextIteration2  #repeat while $t0(counter) > 0
	la $a0, result2 #pringting a prompt to display the number of occurrences
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	jr $ra

#Subprogram to print the options
printOptions: #pringting the options
	li $v0, 4
	la $a0, prompt0 
	syscall
	la $a0, option1 
	syscall
	la $a0, option2
	syscall
	la $a0, option3
	syscall
	la $a0, option4 
	syscall
	jr $ra


#The data segment
	   .data
array:	   .space   400 #400 / 4 = 100 words (a word is 4 bytes)
arraySize: .word    0
sum:       .word    0	
intro: 	   .asciiz  "The program lets the user initialize an array and perform certain operations on it.\n"
prompt1:   .asciiz  "Please enter the array size (must be between 1 and 100):\n"
prompt2:   .asciiz  "Please enter the elements one by one:\n"
prompt3:   .asciiz  "\nPlease enter the input number that the items will be compared to:\n"
prompt4:   .asciiz  "\nPlease enter the input number that the items' divisibility will be tested with:\n"
result1:   .asciiz  "The sum of numbers greater than your input number is:\n"
result2:   .asciiz  "The number of items that are divisible by your input number is:\n"
result3:   .asciiz  "\nThe sum of even items is:\n"
result4:   .asciiz  "\nThe sum of odd items is:\n"
error:     .asciiz  "\nInvalid character.\n"
prompt0:   .asciiz  "\nPress:\n"
option1:   .asciiz  "a. Find summation of numbers stored in the array which is greater than an input number.\n"
option2:   .asciiz  "b. Find summation of even and odd numbers and display them.\n"
option3:   .asciiz  "c. Display the number of occurrences of the array elements divisible by a certain input number.\n"
option4:   .asciiz  "d. Quit.\n"
