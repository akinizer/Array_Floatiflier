.macro QSort(%a, %n)
.data

array: .word 1 2 3 4 5

.text
mainS:
# Main program entry
#
	addiu   $sp, $sp, -20	 # allocate space for a0,a1,a2,a3,ra
	sw      $ra, 16($sp)     # save return address
# Main body
	la	$a0,%a	  # setup the address
	
	blt 	$a1, 0, end
	li	$a1, %n	  # setup the length
	
	mul $s1, $a1, -4
	
	jal    	qsort 		  # make the call
	j 	output	  
qsort:				  #usealess stub
	jr	$ra
# Output code;
output:
	la 	$s0,Array		  # array start address
	#addi 	$s1,$s0,4         # array end address + 4
LP:	
	beqz 	$s1, exit
	lw 	$a0,0($s0)		  # read an element
	
	
	addi $t0, $s0, 4		#address of next element
	lw $a1, 0($t0)			#value of next element
	
	bge $a1, $a0, cond1		#if a1>a0
	
	return:
		nop	
				
	#beqz $a0, end
	#li 	$v0,1			  # print_int code
	#syscall
	#li 	$a0,0xA			  # put '\n' 
	#li	$v0,11			  # print_char
	#syscall			  # print end of line	
	addi	$s0,$s0,4		  # move ptr to next element
	addi 	$s1, $s1, 4
	j 	LP		  # loop until we've done all
	
	
exit:
        lw      $ra, 16($sp)	  # restore return address
        addiu   $sp, $sp, 20      # pop stack 
        #jr      $ra               # return
        
        
end:
	li 	$v0, 10
        syscall

cond1:
	lw $t1,0($s0)		#temp gets current value
	sw $a1, 0($s0)		#current address gets next value
	sw $t1,0($t0)		#next address gets current value
	
	j return
	
	
	

.end_macro 
