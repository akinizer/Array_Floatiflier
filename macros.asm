.data
	
	.macro done
		li $v0, 10
		syscall
	.end_macro 

	.macro print_int (%x)
		li $v0, 1
		move $a0, %x
		syscall
	.end_macro
	
	.macro print_float (%y)
		li $v0, 2
		move $a0, %y
		syscall
	.end_macro
	
	.macro print_str (%str)
		.data
		str: .asciiz %str
		.text
		li $v0, 4
		la $a0, str
		syscall
	.end_macro
	
	
	
