#——-——ISAM——>10/12/2013: torre hanoi
	.data
IntroducirNumero: .asciiz "Introduce el numero de discos(1-8)> "
MoverDisco: 	.asciiz "Mover disco "
Desde:	    	.asciiz " desde la torre "
Hasta:		.asciiz " hasta la torre "
Blanco: 	.asciiz "\n"
	.text
main:
	la $a0, IntroducirNumero 
	li $v0, 4 
	syscall

	li $v0,5		#n = read_int();
	syscall	
	move $a0, $v0	#int n (numero de discos)
	#_______hanoi(n, 1, 2, 3);____________________
	li $a1, 1		#Start
	li $a2, 2		#Finish
	li $a3, 3		#Extra
	jal hanoi 	#void hanoi(n,start,finish,extra)

exit:
	li $v0,10 
	syscall	

#######################################################
# void hanoi(int n, int start, int finish, int extra) #
#######################################################
hanoi:
	beqz $a0, return 	#si n es 0 acaba
	
	subu $sp, $sp, 32
	sw $ra, 0($sp)
	sw $fp, 4($sp)
	addiu $fp, $sp, 8

	sw $a0, 0($fp)
	sw $a1, 4($fp)
	sw $a2, 8($fp)
	sw $a3, 12($fp)

#hanoi1____hanoi(n-1, start, extra, finish);
	sub $a0, $a0, 1 #n-1
	lw $a2, 12($fp)
	lw $a3, 8($fp)
	jal hanoi  

#print
	la $a0, MoverDisco 
	li $v0, 4 
	syscall
	lw $a0, 0($fp) #n
	li $v0, 1 
	syscall
	
	la $a0, Desde 
	li $v0, 4 
	syscall
	lw $a0, 4($fp) #start
	li $v0, 1 
	syscall

	la $a0, Hasta 
	li $v0, 4 
	syscall
	lw $a0, 8($fp) #finish
	li $v0, 1 
	syscall
	
	la $a0, Blanco 
	li $v0, 4 
	syscall

#hanoi2_____hanoi(n-1, extra, finish, start);
	lw $a0, 0($fp)
	sub $a0, $a0, 1
	lw $a1, 12($fp)
	lw $a2, 8($fp)
	lw $a3, 4($fp)
	jal hanoi
	
	lw $ra, 0($sp)
	lw $fp, 4($sp)
	addiu $sp, $sp, 32

return:
	jr $ra


