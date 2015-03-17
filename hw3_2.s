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
                #Increment the current input char.
		lb $t5, 0($t4)
		addi $t4, $t4, 1
                #Check if the current input is whitespace
		beq $t5, $t1, check_input
		beq $t5, $t2, check_input
		beq $t5, $t3, check_input
                #If we've made it to the end of input string then print error msg
		beq $t5, 0, print_error

	j read_pattern # Jump over the print error message
	
	print_error:
                #Display the whitespace error message
		li $v0, 4
		la $a0, error
		syscall
                #Don't run the rest of the proggy with error.
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
        #$t0 is our current input character
	li $t4, 0 #temp variable for word counting (seen_char)
	li $t5, 0 #temp variable for pattern matching (seen_pattern)
        #$t6 is our current pattern character
	
	input_loop:
		lb $t0, 0($s0) #load each successive input character
		addi $s0, $s0, 1		
		beq $t0, 0, exit_loop # If we ever reach the end of input than exit
                #Check if we need to increment the whitespace counter
		beq $t0, $t1, increment_whitespace
		beq $t0, $t2, increment_whitespace
		beq $t0, $t3, increment_whitespace
                #Non-Whitespace char so flip seen_char bit and increment the NW-Count
		li $t4, 1
		addi $s3, $s3, 1
	call_pattern: #This label is here so that increment whitespace can return to program 
		jal pattern_match #Pattern match is our function to check if the pattern continues.
		j input_loop # Reset the loop	
	
	increment_whitespace: # This function increments the whitespace counter and also checks if word needs to be incremented.
		addi $s2, $s2, 1
		beq $t4, 1, increment_word
		j call_pattern
	
	increment_word: #If we see a whitespace after seeing a Non-whitespace, then increment word.
		move $t4, $0
		addi $s4, $s4, 1
		j call_pattern
	
	pattern_match: #This function compares the input char to the pattern char and sets seen_pattern
		beq $t5, 1, exit_pattern # if the pattern is seen, than skip over this.
		lb $t6, 0($s1) #Load the pattern char
		beq $t6, 10, pattern_matched  #If we have the whole pattern than set seen_pattern
		beq $t6, $t0, increment_pattern_char # If we are in the middle of the pattern, increment the pattern
		move $s1, $s5 # If we get here then, the pattern has not been matched and we should reset.
		jr $31
	
	exit_pattern: # Return to main_loop
		jr $31
	
	pattern_matched: # Set pattern_seen to true and return to main_loop	
		li $t5, 1
		jr $31
		
	increment_pattern_char: #increment the pattern char then return to main_loop
		addi $s1, $s1, 1
		jr $31
	
	exit_loop:
	
	li $v0, 4
	la $a0, results
	syscall
	
	li $v0, 4
	la $a0, whitespace
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	li $v0, 4
	la $a0, non_whitespace
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	li $v0, 4
	la $a0, words
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall 
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	li $v0, 4
	beq $t5, 1 print_found
	
	la $a0, not_found
	syscall
	
	li $v0, 10
	syscall
	
	print_found:
		la $a0, found
		syscall 
		li $v0, 10
		syscall
