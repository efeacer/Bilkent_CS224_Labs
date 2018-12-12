#Lab 2- EFE ACER
#The program lets the user initialize an array of random entries and manipulate it.
	.text 
	.globl	__start
__start:
	jal monitor #Call to the monitor program that interacts with the user
	li $v0, 10 #Stop execution
	syscall 
		
#Subprogram to initialize an array of random entries with a user specified size,
#returns the base address in $a0, saves the array size to $a1.
readArray:
	la $a0, prompt1 #Print a prompt to read the array's size
	li $v0, 4 
	syscall
	li $v0, 5 #Read the size of the array to $v0
	syscall
	move $a1, $v0 #$a1 has the array size from now on
	move $t1, $v0 #$t1 also has the array size from now on
	subi $sp, $sp, 4 #Push(save) $a1 to the stack
	sw $a1, 0($sp) 
	mul $a0, $v0, 4 #Compute the number of bytes to allocate in $t0
	li $v0, 9 #Allocate heap memory
	syscall #$v0 has the base address of the array now
	move $a0, $v0 #$a0 has the base address too (as the return value)
	move $t0, $v0 #$t0 has the base address as well (as the index pointer)
	subi $sp, $sp, 4 #Push(save) $a0 to the stack
	sw $a0, 0($sp)
	putRandomItem:
		li $a1, 101 #setting the upper bound (max(randomInt) = 100)
		li $v0, 42  #Generate the random number in $a0 (between 0 and 100)
    		syscall
    		sw $a0, 0($t0) #Save the random item to the current index of the array
    		addi $t0, $t0, 4 #Increment the index pointer
		subi $t1, $t1, 1 #counter - ($a1's original value will be restored)
		bgt $t1, $zero, putRandomItem 
	lw $a0, 0($sp) #Pop(load) $a0 and $a1 from the stack
	lw $a1, 4($sp) 
	addi $sp, $sp, 8 
	jr $ra #Return
	
#Subprogram that displays the array contents. $a0 should contain the base address and
#$a1 should contain the array size, before the call
displayArray:
	subi $sp, $sp, 8 #Push(save) $a0 and $a1 to the stack
	sw $a0, 4($sp) 
	sw $a1, 0($sp)
	move $t0, $a0
	la $a0, display #Display a message to print the array contents
	li $v0, 4 
	syscall
	printItem:
		lw $a0, 0($t0) #Print current indexed item
		li $v0, 1
		syscall
		beq $a1, 1, skipComma #Don't print a comma if it is the last item
		la $a0, comma #Print comma to separate items
		li $v0, 4
		syscall
		skipComma:	
			addi $t0, $t0, 4 #Increment the pointer
			subi $a1, $a1, 1 #Decrement the counter
			bgt $a1, $zero, printItem #Print until all items are printed
	lw $a1, 0($sp) #Pop(load) $a0 and $a1 from the stack
	lw $a0, 4($sp) 
	addi $sp, $sp, 8
	jr $ra #Return
	
#Sorts the a given array in ascending order, $a0 should contain the base address and
#$a1 should contain the array size before the call. Uses the Bubble Sort algorithm.
bubbleSort: 
	subi $sp, $sp, 4 #Push(save) $a1 to the stack
	sw $a1, 0($sp)
	beq $a1, 1, done
	sortPass:
		li $t0, 1 #$t0 is the cursor index
		move $t1, $a0 #t1 is the cursor address
		swapCheck:
			lw $t2, 0($t1) #First item in the comparison
			lw $t3, 4($t1) #Second item in the comparison
			ble $t2, $t3, skipSwap #The items are already in decreasing order (no need for swap)
			sw $t2, 4($t1) #Swapping the items (bubbling up)
			sw $t3, 0($t1) 
			skipSwap: #Skip the Swap operation
				addi $t1, $t1, 4 #updating the cursor
				addi $t0, $t0, 1
				blt $t0, $a1, swapCheck
		subi $a1, $a1, 1 #Decrement the counter
		bgt $a1, 1, sortPass #Sort until there are unsorted items
	done:
		lw $a1, 0($sp) #Pop(load) $a1 from the stack
		addi $sp, $sp, 4
		jr $ra #Return

#Finds and return the minimum and maximum items in an array in $v0 - $v1 registers.
#Receives the base address in $a0 and array size in $a1.
minMax:
	subi $sp, $sp, 8 #Push(save) $a0 and $a1 to the stack
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	lw $v0, 0($a0) #$v0 holds the min item, initialized to the first item
	lw $v1, 0($a0) #$v1 holds the max item, initialized to the first item
	iterate:
		lw $t0, 0($a0)
		blt $t0, $v0, newMin
		j checkMax
		newMin:
			move $v0, $t0
		checkMax:
			bgt $t0, $v1, newMax
			j continue	
			newMax:
				move $v1, $t0
		continue:
			addi $a0, $a0, 4 #Increment the pointer
			subi $a1, $a1, 1 #Decrement the counter 
			bgt $a1, $zero, iterate 
	lw $a0, 0($sp) #Pop(load) $a0 and $a1 from the stack
	lw $a1, 4($sp)
	addi $sp, $sp, 8 
	jr $ra #Return

#Finds and returns the number of unique array items in $v0. Receives base 
#address of the array in $a0 and array size in $a1.
noOfUniqueElements:
	subi $sp, $sp, 8 #Push(save) $a0 and $a1 to the stack
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	move $v0, $zero #$v0 contains the number of unique elements (initially 0)
	move $t0, $sp #$t0 holds the initial value of the stack pointer
	checkUniqueness:
		lw $t1, 0($a0) #load the current indexed item in the array
		bne $sp, $t0, check
		j unique
		check:
			lw $t2, 0($t0) #load the current item in the stack
			beq $t1, $t2, notUnique #the item is already in the stack
			addi $t0, $t0, 4
			bne $sp, $t0, check
			move $t0, $t3 #$t0 restores its old value
		unique:
			subi $t0, $t0, 4 #Push the unique item to the stack
			sw $t1, 0($t0)
			addi $v0, $v0, 1
			move $t3, $t0 #$t3 temporarily hold $t0's value
		notUnique:
			addi $a0, $a0, 4 #Increment the pointer
			subi $a1, $a1, 1 #Decrement the counter 
			bgt $a1, $zero, checkUniqueness
	lw $a0, 0($sp) #Pop(load) $a0 and $a1 from the stack
	lw $a1, 4($sp)
	addi $sp, $sp, 8 
	jr $ra #Return
	
#A subprogram that calls the subprograms and controls the user experience
monitor:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, intro #Display the intro
	syscall
	mainLoop:
		jal printOptions #Print the options
		li $t1, 'a'
		li $t2, 'b'
		li $t3, 'c'
		li $t4, 'd'
		li $t5, 'e'
		li $t6, 'f'
		li $v0, 12 #reading a character    
 		syscall
 		#Different cases regarding different menu options
 		caseA: #initialize
 			bne $v0, $t1, caseB 
 			jal readArray
 			jal displayArray
 			j default
 		caseB: #sort
 			beq $a1, $zero, shouldInitialize #if there is no initialized array
 			bne $v0, $t2, caseC
 			jal bubbleSort
 			jal displayArray
 			j default
 		caseC: #find min and max
 			beq $a1, $zero, shouldInitialize #if there is no initialized array
 			bne $v0, $t3, caseD
 			jal minMax
 			subi $sp, $sp, 4 #Push $a0 to the stack to save it (otherwise syscalls change it)
 			sw $a0, 0($sp)
 			move $t6, $v0
 			move $t7, $v1
 			la $a0, displayMin #Print the min item
			li $v0, 4 
			syscall
			move $a0, $t6
			li $v0, 1
			syscall
			la $a0, displayMax #Print the max item
			li $v0, 4 
			syscall
			move $a0, $t7
			li $v0, 1
			syscall
			lw $a0, 0($sp) #Pop $a0 to load it
			addi $sp, $sp, 4 
 			j default
 		caseD:	#find no. of unique elements
 			beq $a1, $zero, shouldInitialize #if there is no initialized array
 			bne $v0, $t4, caseE
 			jal noOfUniqueElements
 			move $t0, $v0 
 			subi $sp, $sp, 4 #Push $a0 to the stack to save it (otherwise syscalls change it)
 			sw $a0, 0($sp)
 			la $a0, displayUniq #Print the no. of unique items
			li $v0, 4 
			syscall
 			move $a0, $t0
			li $v0, 1 
			syscall
			lw $a0, 0($sp) #Pop $a0 to load it
			addi $sp, $sp, 4
 			j default
 		caseE: #display
 			beq $a1, $zero, shouldInitialize #if there is no initialized array
 			bne $v0, $t5, caseF
 			jal displayArray
 			j default
 		caseF: 	#quit
 			bne $v0, $t6, caseInvalid
 			j default
 		shouldInitialize: #the case where there is no initialized array
 			beq $v0, $t6, default
 			la $a0, error2 #Print an error
			li $v0, 4
			syscall
			j default
 		caseInvalid: #the case where no valid option is chosen
 			subi $sp, $sp, 4 #saving the value of $a0
			sw $a0, 0($sp)
 			la $a0, error1 #Print an error
			li $v0, 4
			syscall
			lw $a0, 0($sp) #restoring the value of $a0
			addi $sp, $sp, 4
 		default:
 			bne $v0, $t6, mainLoop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra #Return 
	
#Subprogram to print user's options
printOptions:
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	li $v0, 4 
	la $a0, option0 #Display the options
	syscall
	la $a0, option1
	syscall
	la $a0, option2
	syscall
	la $a0, option3
	syscall
	la $a0, option4
	syscall
	la $a0, option5
	syscall
	la $a0, option6
	syscall
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra #Return
	
		.data
intro:		.asciiz		"This program lets the user create an array of random entries and manipulate it."
display:        .asciiz		"\nThe array: "
prompt1:	.asciiz		"\nPlease enter the size of the array: "
displayMin:	.asciiz		"\nThe minimum item in the array is: "
displayMax:	.asciiz		"\nThe maximum item in the array is: "
displayUniq: 	.asciiz		"\nThe number of unique items is: "
option0: 	.asciiz 	"\nPress:"
option1:	.asciiz		"\na) Initialize an array of your desired size with random entries." 
option2:	.asciiz		"\nb) Sort the array (using the Bubble Sort Algorithm)." 
option3:	.asciiz		"\nc) Find the minimum and maximum items in the array." 
option4:	.asciiz		"\nd) Find the number of unique elements in the array." 
option5:	.asciiz		"\ne) Display the array." 
option6:	.asciiz		"\nf) Quit.\n"
error1:     	.asciiz  	"\nInvalid character.\n"
error2:		.asciiz		"\nYou should initialize the array first. (option a)"
comma:		.asciiz		", "