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
	li $t1, 32 #single whitespace
	li $t2, 9 #tab
	li $t3, 10 #newline

	input_loop:
		lb $t0, 0($s0) #load each successive input character
		beq $t0, $t1, increment_whitespace
		beq $t0, $t2, increment_whitespace
		beq $t0, $t3, increment_whitespace
		addi $s3, $s3, 1
		
		increment_whitespace:
			addi $s2, $s2, 1	
	li $v0, 10
	syscall