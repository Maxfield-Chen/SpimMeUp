# Maxfield Chen, Joe Shvedsky. SECTION: 2
.data
  nl: .asciiz "\n"
  prompt: .asciiz "Please input a positive integer: "
  righthand: .asciiz "The number of zeros in the right half of the number are: "
  lefthand: .asciiz "The number of ones in the left half of the number are: "
  largepf: .asciiz "The largest power of 4 that evenly divides the given integer is: "
  smallestd: .asciiz "The value of the smallest digit in the decimal representation of the number is "
  count: .word 0
.text
.globl main
main:
  # Print the prompt
  li $v0, 4
  la $a0, prompt
  syscall
  # Read the Integer
  li $v0, 5
  syscall
  # Init Vars
  move $s0, $v0  
  move $t0, $s0
  move $t1, $s0
  lw $s1, count
  lw $s2, count

  li $t2, 2
  #Check first 16 bits for 0's
  zeroCheck: bge $s2, 16, zeroExit
    add $s2, $s2, 1 # Increment the loop counter.
    div $s0, $t2
    mfhi $t3 #Store the mod value
    mflo $s0 # Store the output of the division by 2.
    beq $t3, 0, rightIncrement #Test the result and increment the counter if needed.
    j zeroCheck
  rightIncrement:
    add $s1, $s1, 1  #Increment the zero counter.
    j zeroCheck
  zeroExit:
  #Print out the end chpt1 prompts 
    li $v0, 4
    la $a0, righthand
    syscall
    li $v0, 1
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, nl
    syscall

  li $v0, 10
  syscall
