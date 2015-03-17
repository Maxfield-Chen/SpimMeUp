	.data
input:	.space 100
pattern: .space 11
input_prompt:	.asciiz "Enter an input line: "
pattern_prompt:	.asciiz "Enter a prompt to search for: "
new_line:	.asciiz "\n"
results:	.asciiz "Results\n"
whitespace:	.asciiz "# of whitespace characters: "
non_whitespace:	.asciiz "# of non-whitespace characters: "
words:	.asciiz "# of words: "
found:	.asciiz "The user pattern was found within the input line\n"
not_found:	.asciiz	"The user pattern was NOT found within the input line \n"
error:	.asciiz "Line contains whitespace characters only!\n"

	.text
	.globl main
main:
	li $t1, 32 #single whitespace
	li $t2, 9 #tab
	li $t3, 10 #newline
	
	#print the input prompt
	li $v0, 4
	la $a0, input_prompt
	syscall
	
	#read the input
	li $v0, 8
	la $a0, input
	li $a1, 100
	move $s0, $a0  #save the input string to $s0
	syscall
	
	move $t4, $s0
	#check if only whitespace
	check_input:
		lb $t5, 0($t4)
		addi $t4, $t4, 1
		beq $t5, $t1, check_input
		beq $t5, $t2, check_input
		beq $t5, $t3, check_input
		beq $t5, 0, print_error

	j read_pattern
	
	print_error:
		li $v0, 4
		la $a0, error
		syscall
		li $v0, 10
		syscall #to the batmobile
		
	read_pattern:
	
	#print the pattern prompt
	li $v0, 4
	la $a0, pattern_prompt
	syscall	
	
	#read the pattern
	li $v0, 8
	la $a0, pattern
	li $a1, 11
	move $s1, $a0  #save the pattern string to $s0
	syscall	
	
	#$s0 is input, $s1 is pattern
	
	li $s2, 0 #whitespace count
	li $s3, 0 #non-whitespace count
	li $s4, 0 #word count
	move $s5, $s1 #for going to start of pattern
	li $t4, 0 #temp variable for word counting (seen_char)
	li $t5, 0 #temp variable for pattern matching (seen_pattern)
	
	input_loop:
		lb $t0, 0($s0) #load each successive input character
		addi $s0, $s0, 1		
		beq $t0, 0, exit_loop
		beq $t0, $t1, increment_whitespace
		beq $t0, $t2, increment_whitespace
		beq $t0, $t3, increment_whitespace
		li $t4, 1
		addi $s3, $s3, 1
	call_pattern:
		jal pattern_match
		j input_loop	
	
	increment_whitespace:
		addi $s2, $s2, 1
		beq $t4, 1, increment_word
		j call_pattern
	
	increment_word:
		move $t4, $0
		addi $s4, $s4, 1
		j call_pattern
	
	pattern_match:
		beq $t5, 1, exit_pattern
		lb $t6, 0($s1)
		beq $t6, 10, pattern_matched
		beq $t6, $t0, increment_pattern_char
		move $s1, $s5
		jr $31
	
	exit_pattern:
		jr $31
	
	pattern_matched:	
		li $t5, 1
		jr $31
		
	increment_pattern_char:
		addi $s1, $s1, 1
		jr $31
	
	exit_loop:
	
	#print the results string
	li $v0, 4
	la $a0, results
	syscall
	
	#print whitespace count string
	li $v0, 4
	la $a0, whitespace
	syscall
	
	#print the number of whitespaces (single space, tab, newline)
	li $v0, 1
	move $a0, $s2
	syscall
	
	#a new line
	li $v0, 4
	la $a0, new_line
	syscall
	
	#print non-whitespace count string
	li $v0, 4
	la $a0, non_whitespace
	syscall
	
	#print the number of non-whitespace characters
	li $v0, 1
	move $a0, $s3
	syscall
	
	#another new line
	li $v0, 4
	la $a0, new_line
	syscall
	
	#words count string
	li $v0, 4
	la $a0, words
	syscall
	
	#print the number of words
	li $v0, 1
	move $a0, $s4
	syscall 
	
	#another new line
	li $v0, 4
	la $a0, new_line
	syscall
	
	#checks if the program found the pattern, jumps to print_found if it did
	li $v0, 4
	beq $t5, 1 print_found
	
	#pattern not found 
	la $a0, not_found
	syscall
	li $v0, 10 #just exit since there's nothing more to do
	syscall
	
	#pattern found
	print_found:
		la $a0, found
		syscall 
		li $v0, 10
		syscall