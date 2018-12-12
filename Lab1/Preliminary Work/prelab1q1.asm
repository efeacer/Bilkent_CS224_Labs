#Preliminary Work - Question 1 - EFE ACER
#Initializes an array of a specified size, reads the items from the user, prints the
#array, reverses the array contents and prints the array again. 

	.text
	.globl	__start
__start:
	#Printing an intro message 
	la $a0, intro
	li $v0, 4
	syscall
	#Printing a prompt to read arraySize
	la $a0, prompt1
	li $v0, 4
	syscall
	#Reading the value of arraySize
	li $v0, 5
	syscall
	sw $v0, arraySize
	#Calling the readItems function
	jal readItems
	#Calling the printItems function
	jal printItems
	#Calling the reverseArrayContents function and printing the array again
	la $a0, 0($t0) #Passing the address of $t0 as an argument for reverseArrayContents 
	jal reverseArrayContents
	la $a0, result2 #printing a message to inform the user that the contents are reversed
	li $v0, 4
	syscall
	jal printItems
	#Stopping the execution
	li $v0, 10	
	syscall

#Subprogram to read arraySize items to the array 
readItems: 
	la $t0, array #$t0 points to the base address of the array
	lw $t1, arraySize #$t1 is set to arraySize (counter for the repeat structure)
	la $a0, prompt2 #printing a prompt to read items one by one
	li $v0, 4
	syscall
	readItem:
		li $v0, 5 #reading a single item to the current indexed position
		syscall
		sw $v0, 0($t0)
		addi $t0, $t0, 4 #increments the pointer to the next address
		subi $t1, $t1, 1 #decrementing the counter 
		bgt $t1, $zero, readItem #repeat until $t1(counter) > 0
	jr $ra #returning to the main program 

#Subprogram to print array items
printItems: 
	la $t0, array #$t0 points to the base address of the array
	lw $t1, arraySize #$t1 is set to arraySize (counter for the repeat structure)
	la $a0, result1 #printing a message to inform the user 
	li $v0, 4
	syscall
	printItem:
		beq $t1, 1, printWithoutSeparator #if counter == 1 skip if block
		lw $a0, 0($t0) #printing the current indexed item
		li $v0, 1
		syscall
		la $a0, separator #printing the separator after the item (if block)
		li $v0, 4
		syscall
		j continue #skipping the else block
		printWithoutSeparator: #printing the item without a separator (else block)
			lw $a0, 0($t0) #printing the current indexed item
			li $v0, 1
			syscall
		continue:
			addi $t0, $t0, 4 #increments the pointer to the next address
			subi $t1, $t1, 1 #decrementing the counter 
			bgt $t1, $zero, printItem #repeat until $t1(counter) > 0
	jr $ra #returning to the main program 
	
#Subprogram to reverse array contents
reverseArrayContents: 
	subi $t0, $a0, 4 #$t0 points to the last item's address in the array
	la $t1, array #$t1 points to the base address of the array
	reverseItems:
		#Swapping two items pointed by $t0 and $t1
		lw $t2, 0($t1) #base adress to $t2
		lw $t3, 0($t0) #last adress to $t3
		sw $t2, 0($t0) #word in $t2 to $t0
		sw $t3, 0($t1) #word in $t3 to $t1
		#Computing the difference between the pointers and modifying them
		sub $t2, $t0, $t1 
		subi $t0, $t0, 4
		addi $t1, $t1, 4
		bge $t2, 4, reverseItems #repeat until $t0 - $t1 < 4
	jr $ra #returning to the main program 

#The data segment
	      .data
array:	      .space    80 #80/4 = 20 words (a word is 4 bytes)
arraySize:    .word     0
intro:	      .asciiz   "The program initializes, reverses and prints an array created by the user.\n"
prompt1:      .asciiz   "Please enter the array size (must be between 1 and 20):\n"
prompt2:      .asciiz   "Please enter the items one by one:\n"
result1:      .asciiz   "The array contents:\n"
result2:      .asciiz   "\nArray contents are reversed.\n"
separator:    .asciiz   ", "
