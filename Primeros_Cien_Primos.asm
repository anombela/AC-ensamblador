	.data
	saltodelinea: .asciiz "\n"
	.text
	
	li $s0,1   # s0 guardo el numero que voy a comprobar
	li $s1,0   # s1 los numeros primos que llevo encontrados
	li $s2,100   #s2 guardo los primos que quiero calcular	
	
buclemain:
	beq $s1,$s2,finbuclemain
	move $a0,$s0 # guardo en a0 el numero que voy a comprobar si es primo
	jal esprimo
	move $s3,$v0 # s3 guardo si el numero es primo
	
if1:    beqz $s3,endif1
then1:			#el then cuando es primo
	li $v0,1
	move $a0,$s0
	syscall
	
	li $v0,4
	la $a0,saltodelinea
	syscall
	
	addiu $s1,$s1,1 #incremento el numero de primos encontrados
endif1:

	addiu $s0,$s0,1 #paso al siguiente numero	
	
	j buclemain	
finbuclemain:	

	li $v0,10
	syscall	

		
esprimo:
	subi $sp,$sp,32
	sw $ra,0($sp)
	sw $fp,4($sp)
	addiu $fp,$sp,28
	
	li $v0,1	# por defecto voy a decir que es primo		
	beq $a0,1,finesprimo	
	li $t0,2        #t0 numero que miro si es divisible	
	addiu $t1,$a0,-1 #llego hasta el numero que me pasan -1
bucle2:	
	bgt $t0,$t1,finesprimo					
	rem $t2,$a0,$t0
if2:	bnez $t2,endif2
then2:
	li $v0,0
	j finesprimo
endif2:	
											
	addiu $t0,$t0,1 #incremento el numero a mirar si es divisible																														
	j bucle2																				
finesprimo:										
	lw $ra,0($sp)
	lw $fp,4($sp)					
	addiu $sp,$sp,32							
	jr $ra
	
					
