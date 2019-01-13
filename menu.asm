.include "macros.asm"
.include "quickSort.asm"
.data
	#ask: .asciiz "\n-----\nMenu\n-----\n1)special_case\n2)get_rand_FP\n3)FastSort\n4)SlowSort\n5)FillArray\n6)CompareFP\n-----\nEnter option: "
	
	ZERO: .float +0.0
	NERO: .float -0.0
	prompt: .asciiz "Enter integer (0 to break) :\n"
	size: .asciiz "\nEnter size of array:"
	Array: .space 100
	Sz: .word 
	text:   .asciiz "List: "
	space: .asciiz " "
	
	
.text
.globl _Lab3	
#########################################	#########################################
_Lab3:
	print_str("Welcome to Array Floatiflier. You can declare an array and with options menu")
	print_str("\nYou can work on floating points and sorting on arrays")
	
	jal asker
		
	move $a2,$v0	#size of array
	
	li $v0, 30
	syscall
	
	move $t2, $a0
	
	j arr
		
	back2arr:
		nop
	
	li $v0, 30
	syscall
	
	sub $t2, $a0,$t2
		
	
	
	j opt
	
	
	done
	

asker:
	
	# ask for size
	li $v0,4 
	la $a0, size 
	syscall 		
	# read input
	li $v0,5
	syscall	
	
	bltz $v0, asker
	
	jr $ra
	


#########################################	#########################################
# create array
arr:
  	# array intro
	#li $v0, 4 
  	#la $a0, prompt
  	#syscall
    
    	la $a1, Array	#Array
    	
    
    	
#########################################	#########################################  	
# read inputs for the array	


read_array:
	
	
	addi $sp, $sp, -12  # Decrement stack pointer by 12
   	sw   $a1, 0($sp)   # Save $r2 to stack
       	sw   $a2, 4($sp)   # Save $r3 to stack
       	sw   $ra, 8($sp)   # Save $r4 to stack
       	
    	beq $s4, $a2, back2arr
	addiu $s4, $s4, 1
    	
 	#read input   	
	move $a0, $v0	
	
	j get_rand_FP
	
	continue:
		nop
	
	move $v0, $a0
  	#li $v0, 5
    	#syscall
    	
	
	addi $t7, $t7, 1	 # update counter for median 
			   
    	#store inputs to a1 array
	sw $v0, 0($a1)
    
   	# next index
    	addiu $a1, $a1, 4
    	
    	# condition to jump to show list
    	beqz $v0, list
    	j read_array	# loop for inputs
    	
    	lw   $a1, 0($sp)   # Copy from stack 
    	lw   $a2, 4($sp)   # Copy from stack 
      	lw   $ra, 8($sp)   # Copy from stack 
      	addi $sp, $sp, 12  # Increment stack pointer by 12


#########################################	#########################################
# list of elements		
list:
	
	
	move $s3, $v0
	
	sw $s4, Sz
	move $s4, $0
    	la $a1, Array
	
	move $a3, $a0
	
    	#li $v0, 4
    	#la $a0, text
    	#syscall
    	
    	move $s5, $a3#timing for read array
    	
#########################################	#########################################	
while:

    	#t0 is current item for a1 Array 
    	
    	lw $t0, 0($a1) #copy current elet to t0
    	addiu $a1, $a1, 4	#cur = cur->next, current = current->next, size decreases by one

    	beqz $t0, opt #if there is no item, t0 is 0 as default, jump to options
    
    	#print current t0
    	li $v0, 1
    	move $a0, $t0	#carry t0 value to a0
 
    	syscall

	 #string print
 	li $v0, 4
	la $a0, space 
	syscall	 
	
    	j while
#########################################	#########################################
# option function
opt:	
	# ask for option
	li $v0,4 
	la $a0, ask
	syscall 
	
	# read input
	li $v0,5
	syscall	
	
	# option condition
	#beq $v0, 1, special_case
	#beq $v0, 2, get_rand_FP	
	beq $v0, 1, FastSort
	beq $v0, 2, SlowSort
	#beq $v0, 5, FillArray
	#beq $v0, 6, CompareFP
		
	# result 
	j opt
#########################################	#########################################	
special_case:
	la $a0, ZERO($0)
	move $t0, $a0
	
	la $a0, NERO($0)
	move $t1, $a0


	print_str("Enter value: ")	
	#read value
	
	#enter input, use a0 to read integer, use a1 for status. 
	#status: return 0 for ok, -1 for noninteger, -2 for cancel, -3 for no input given
	#dont move v0 to a1 or a0, just print a1 or a0
	
	#InputDialog syscall 51,52,53(int,float,double), 54(string)
	
	li $v0, 52
	syscall
		
	#print_int($a0)
	#print_int($a1)
	
	#ask again if there is no value entered or cancelled
	beq $a1, -2, special_case
	beq $a1, -3, special_case
	
	#status check
	beq $a0, 0, yes		#if input is zero
	beq $a1, 0, no		#if input is number and not zero
	
	beq $a1, -1, yes	#if input is noninteger
	
	seq $s0, $a0, $t0
	beq $s0, 1 , yes	#if input is +-infinity	
	
	seq $s0, $a0, $t1
	beq $a0, 1 , yes
	
	#j no
	j  special_case
yes:
	print_str("Yes, special case")
	done	
no:
	print_str("No, normal value")
	done
	
#########################################	#########################################	
random_int:
	
	li $v0, 42
	syscall
	
	#int to floating number
	mtc1 $a0, $f12
	cvt.s.w $f12, $f12 
	
  	jr $ra
		 
get_rand_FP:
		
	jal random_int
			
	#print float
	#print_str("Generated floating number: " )
	
	#li $v0,2
	#syscall
	
	#print_str("\n")
	
	#print_int($a0)
	#print_int($a1)
	
	#ask again if there is no value entered or cancelled
	beq $a1, -2, get_rand_FP
	beq $a1, -3, get_rand_FP
	
	#status check
	beq $a1, -1, nof	#if input is not invalid
	
	#j no
	j  yesf
yesf:
	print_str("floating number added\n")
	j continue	
nof:
	
	j continue
#########################################	#########################################
FillArray:
	li $s0, 0
	print_str("Enter size: ")
	li $v0, 5	
	move $s0, $v0
	syscall
	
	li $s1,3
	move $a3, $a1
	
	j FillArrayLoop
FillArrayLoop:
	addi $sp, $sp, -12  # Decrement stack pointer by 12
   	sw   $a1, 0($sp)   # Save $r2 to stack
       	sw   $a2, 4($sp)   # Save $r3 to stack
       	sw   $ra, 8($sp)   # Save $r4 to stack
	
	beq $s1, $s0, end
	addi $s1, $s1, 1
    	
 	#random 	
	li $v0, 42
	syscall
	
	#int to floating number
	mtc1 $a0, $f12
	cvt.s.w $f12, $f12 
		
	addi $t7, $t7, 1	 # update counter for median 
			   
    	#store inputs to f12 array
	l.s $f12, ($a3)
    
   	# next index
    	addiu $a3, $a3, 4
    	
    	# condition to jump to show list
    	
    	j FillArrayLoop
	
	
   	lw   $a1, 0($sp)   # Save $r2 to stack
       	lw   $a2, 4($sp)   # Save $r3 to stack
       	lw   $ra, 8($sp)   # Save $r4 to stack
	addi $sp, $sp, 12  # Increment stack pointer by 12
  	
#########################################	#########################################	
CompareFP:
	jal get_rand_FPP
	move $s0, $a0
	
	jal get_rand_FPP
	move $s1, $a0	
	
	bge $s0, $s1, print1
	ble $s0, $s1, print1

print1:
	move $v1, $s0
	move $v0, $s1
	done
print2:
	move $v0, $s0
	move $v1, $s1
	done
	
	
	
		 
get_rand_FPP:
		
	jal random_int
		
	
	#print_int($a0)
	#print_int($a1)
	
	#ask again if there is no value entered or cancelled
	beq $a1, -2, get_rand_FPP
	beq $a1, -3, get_rand_FPP
	
	#status check
	beq $a1, -1, nof	#if input is not invalid
	
	#j no
	jr $ra
#########################################	#########################################
SlowSort:
	addi $sp, $sp, -20  # Decrement stack pointer by 12
   	sw   $a0, 0($sp)   # Save $r2 to stack
       	sw   $s1, 4($sp)   # Save $r3 to stack
       	sw   $s2, 8($sp)   # Save $r4 to stack
	sw   $s3, 12($sp)   # Save $r4 to stack
	sw   $s7, 16($sp)   # Save $r4 to stack
	bubbleSort:	
		#lw $s7, ($v1) # get size of list
	
		lw $s7, Sz
		move $s1, $t7  # set counter for # of elems printed
		move $s2, $t7  # set offset from Array

	# outside loopper
	outL:
	
		beq $t0, $s7, endsorter			#end loop if counter reached size of Array
		addi $t1, $zero, 0				#reset inner loop counter
	
		# inside loopper
		inL: 
			sub $t4, $s7, $t0			#store the values of size - k for comparison later
			beq $t1, $t4, end_inL		#end inner loop if counter reached comparitor values
			mul $s2, $t1, 4
			lw $t2, Array($s2)			#load a[i]
			addi $s3, $s2, 4
			lw $t3, Array($s3)			#load a[i+1]
		
		
			ble $t2, $t3, exchangeF # the step when exchanging items
		
				move $t5, $t2			#store a[i] in temp
				move $t2, $t3			#swap
			
				move $t3, $t5
			
			
				sw $t2, Array($s2)
				sw $t3, Array($s3)
			
			
			
			exchangeF:
		
			addi $t1, $t1, 1			#increment inner counter
			j inL				#jump to start of inner

		end_inL:
		addi $t0, $t0, 1				#increment outer counter
		j outL						#jump to start of outer
	
	endsorter:
		
		addi $sp, $sp, -20  # Decrement stack pointer by 12
   		lw   $a0, 0($sp)   # Save $r2 to stack
     	  	lw   $a2, 4($sp)   # Save $r3 to stack
     	  	lw   $ra, 8($sp)   # Save $r4 to stack
     	  	lw   $ra, 12($sp)   # Save $r4 to stack
     	  	lw   $ra, 16($sp)   # Save $r4 to stack
	# main print loop
	move $s1, $zero  # set counter for # of elems printed
	move $s2, $zero  # set offset from Array

	showL:
		bge $s1, $s7, end # stop after last elem is printed
		lw $a0, Array($s2)  # print next value from the list
		li $v0, 1
		syscall
		la $a0, space # print a newline
		li $v0, 4
		syscall
		addi $s1, $s1, 1  # increment the loop counter
		addi $s2, $s2, 4  # step to the next Array elem

		j showL # repeat the loop
#########################################	#########################################
FastSort:
	QSort(Array,3)
#########################################	#########################################
quickS:
	# void quicksort(int list[], int low, int high ) {
	# int mid;
	quicksort:
		# register usage: stack frame:
		# $a0 points to list saved at 0($sp)
		# $a1 = low saved at 4($sp)
		# $a2 = high saved at 8($sp)
		# $s0 = mid saved at 12($sp)
		# return point = $ra saved at 16($sp)
		#
		# PROLOGUE:
			addiu $sp,$sp,-20
			sw $a0,0($sp)
			sw $a1,4($sp)
			sw $a2,8($sp)
			sw $s0,12($sp)
			sw $ra,16($sp)
			
			lw $s0,12($sp)
			lw $ra,16($sp)
			addiu $sp,$sp,20
			jr $ra
			
			# if( low < high) {
			slt $t0,$a1,$a2
			beq $t0,$0,skipIf
			# // partition the list into two sublists
			# mid = partition( list, low, high );
			jal quicksort #jal partition
			move $s0,$v0
			#
			# // recursively sort the lesser list
			# quicksort(list, low, mid-1);
			lw $a0,0($sp)
			lw $a1,4($sp)
			addi $a2,$s0,-1
			jal quicksort
			# quicksort(list, mid+1, high);
			lw $a0,0($sp)
			addi $a1,$s0,1
			lw $a2,8($sp)
			jal quicksort
		# }
		skipIf:
#########################################	#########################################


end:
	print_str("Read array timing: ")


	done
