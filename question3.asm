.data

startingText: .ascii "Enter n and formulae:"
	.asciiz "\n"
.align 4

textInput:
	.space 2000 #get string input

endText: 
	.ascii "The values are:"
	.asciiz "\n"

.text
main:
	li $s1,0 #overall sum
	li $s3, 0 #litte sum
	la $a0, startingText #load addresses  
	li $s0, 0 #tracker1 for LoopOne
	li $s2, 0 #tracker2 for LoopTwo
	la $t1, textInput
	
	li $v0, 4 #print string when loading v0
	syscall #to process the instruction
	
	li $v0, 5 #get value
	syscall #to process the instruction
	move $t0, $v0
	#get input from user a certain number of times 
	#and store in addresses
	
	
	LoopOne:
		beq $s0, $t0, FinalText #branch if counter=limit
		addi $s0, $s0, 1 #increment
		
		#get user input
		
		move $a0, $t1
		li $a1, 20
		li $v0, 8 #read string , we will process characters 
		syscall


		#use stack pointer to store
		#user inputs
		
		sw $a0, 0($sp) #initially $a0
		addi $sp, $sp, 4 #increment pointer

		addi $t1, $t1, 20 #increment to new string area
		
		b LoopOne
	#newLine:
		#b LoopOne
	
	FinalText:
		la $a0, endText #load addresses
		li $v0, 4 #print string when loading v0
		syscall #to process the instruction
		
		#b ResetStackPointer
		
		#get starting position
		#reset $sp
		mul $t4, $t0, -4
		add $sp, $sp, $t4 # $sp - ($t0*4)
		
		
		
		b LoopTwo
	Equal: 
		#reset a bunch of variables for re-use
		sub $s3, $s3, $s3 #reset little sum
		sub $t4, $t4, $t4
		sub $s4, $s4, $s4
		sub $t8, $t8, $t8
		sub $t7, $t7, $t7
		sub $s5, $s5, $s5
		addi $t9, $t9, 0x01 #go to next character 
		b indexLoop

	indexOp:
		#load word in that position
		#get position
		mul $t4, $s2, -4 #value of integers printed times -4, decrement stack pointer 
		add $s4, $sp, $t4   # $sp - ($t0*4), original starting point
		
		#increment s3
		#add $s3, $s3, 1
		
		mul $t8, $s3, 4 #mul little sum by 4
		add $t7, $s4, $t8 #example =1, $sp+1*4, get address relative to stack pointer
		lw $t5, ($t7) #get word in that position
		#store word in that position
		addi $sp, $sp, -4
		sw $t5, ($sp)
		addi $sp, $sp, 4
		
		#print associated number
		move $a0, $t5
		li $v0, 4
		syscall	
		move $t9, $a0

		b resetLittleSum

	resetLittleSum:
		sub $s3, $s3, $s3
		b loopThrough
	
	indexLoop:
		#now work with each word integer
		
		lb $a0, ($t9) #loading each byte
 		
		#a bunch of checks
		beq $a0, 10, indexOp
		
		sub $a0, $a0, 48 
		move $t2 , $a0	 #inserts char into t2

		mul $s3, $s3, 10
		add $s3,$s3,$t2

		addi $t9, $t9, 0x01 #go to next character
		
		b indexLoop
		

	loopThrough:
		#now work with each word integer
		lb $a0, 0($t9) #loading each byte
 		
		#a bunch of checks
		beq $a0, 10, LoopTwo
		beq $a0, '=', Equal
		
		sub $a0, $a0, 48 
		move $t2 , $a0	 #inserts char into t2

		mul $s3, $s3, 10
		add $s3,$s3,$t2

		addi $t9, $t9, 0x01 #go to next character
		
		b loopThrough
		
	LoopTwo:
		
		add $s1, $s1, $s3 #add little sum to big sum
		#reset little sum
		sub $s3, $s3, $s3

		beq $s2, $t0, Exit
	
		addi $s2, $s2, 1
		
		#addi $sp, $sp, -4
		lw $t9, 0($sp) #get stored integer
		addi $sp, $sp, 4
		
		#decrement word position
		#print result
		
		lb $t6, 0($t9)
		beq $t6, '=', loopThrough
		#addi $sp, $sp, 4
		
		move $a0, $t9
		li $v0, 4
		syscall		
		
		
		b loopThrough

	Exit:
		move $a0, $s1 #print sum
		li $v0, 1
		syscall

		li $v0, 10
		syscall

