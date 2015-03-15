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
  move $s0, $v0 # Int to be read  
  move $t0, $s0 # Copy of Int
  move $t1, $s0 # Copy of Int
  lw $s1, count # Zero Counter
  lw $s2, count # Loop counter
  lw $s3, count # One Counter
  lw $s4, count # Div 4 Counter
  li $s5, 9 # Smallest Decimal Digit

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

  #Now Check the second 16 bits for 1's
  lw $s2, count #Reset the loop counter
  oneCheck: bge $s2, 16, oneExit
    add $s2, $s2, 1 # Increment the loop counter.
    div $s0, $t2
    mfhi $t3 #Store the mod value
    mflo $s0 # Store the output of the division by 2.
    beq $t3, 1, leftIncrement #Test the result and increment the counter if needed.
    j oneCheck
  leftIncrement:
    add $s3, $s3, 1  #Increment the one counter.
    j oneCheck
  oneExit:
  #Print out the end chpt1 prompts 
    li $v0, 4
    la $a0, lefthand
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    li $v0, 4
    la $a0, nl
    syscall

  #Highest Power of 4
  #Check the zero case first
  beq $t1, 0, fourZeroCase
  j whileMod4

  fourZeroCase:
    li $s4, 0
    j exitWhileMod4

  li $t2, 4
  whileMod4:
    div $t0, $t2 
    mfhi $t3 #Store the mod value
    mflo $t0 # Store the output of the division by 4.
    bne $t3, 0, exitWhileMod4 #Check our two bits to see if they contain a one.
    addi $s4, $s4, 1 #Increment our div 4 counter by 1.
    j whileMod4

  exitWhileMod4:
  #Print out end chpt1 prompts
    li $v0, 4
    la $a0, largepf
    syscall
    li $v0, 1
    move $a0, $s4
    syscall
    li $v0, 4
    la $a0, nl
    syscall

  li $s5, 9 # Prep the min number
  li $t2, 10 # Prep the div number
  #Now find the smallest number in the decimal sequence
  #Check the zero case first.
  beq $t1, 0, decZeroCase
  j whileMinDec

  decZeroCase:
    li $s5, 0
    j exitMinDec

#Then proceed to the regular case.
  whileMinDec:
    beq $t1, 0, exitMinDec
    div $t1, $t2 
    mfhi $t3 # Store the mod value
    mflo $t1 # store the output of the division by 10
    blt $t3, $s5, updateMin # If the mod value is less than our current min update the min
    j whileMinDec # Reset loop

  updateMin:
    move $s5, $t3 #Update min val
    j whileMinDec #Return to loop
  #Print out the end chpt1 prompts
  exitMinDec:
    li $v0, 4
    la $a0, smallestd
    syscall
    li $v0, 1
    move $a0, $s5
    syscall
    li $v0, 4
    la $a0, nl
    syscall


  li $v0, 10
  syscall
