##
##	Program3.asm is a loop implementation
##	of the Fibonacci function
##        

#################################
#					 	#
#		text segment		#
#						#
#################################

	.text		
.globl __start
 
__start:			# execution starts here
	li $a0,7		# to calculate fib(7)
	jal fib		# call fib #FIX: changed 'l' in the "flb" to 'i'
	move $a0,$v0	# print result
	li $v0, 1
	syscall #FIX: added a 'l' at the end

	la $a0,endl		# print newline #FIX: added a 'l' to "end"
	li $v0,4
	syscall #FIX: added a 'l' at the end

	li $v0,10 #FIX: changed 100 to 10
	syscall #FIX: added a 'l' at the end		# bye bye

#------------------------------------------------


fib:	move $v0,$a0	# initialise last element
	blt $a0,2,done	# fib(0)=0, fib(1)=1 #FIX: added a 'e' at the end of "don"

	li $t0,0		# second last element
	li $v0,1		# last element

loop:	add $t1,$t0, $v0	# get next value #FIX: added a "$" at the beginning of "vO"
	move $t0,$v0	# update second last
	move $v0,$t1	# update last element
	sub $a0,$a0,1	# decrement count
	bgt $a0,1,loop	# exit loop when count=0 #FIX: changes 1 to 0 because we should make
						 #n - 1 additions to find the n'th fib. number
done:	jr $ra

#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
endl:	.asciiz "\n"

##
## end of Program3.asm
