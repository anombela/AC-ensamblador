#——-——ISAM——>09/12/2014: strcpy
#insertara el \0 de la origen en la destino
	.data	
cadena_origen:	.space 1024
cadena_destino:	.space 1024
str:	.asciiz "Introduce una cadena de caracteres: "
n:	.asciiz " \n"

	.text
main:	
	li $v0, 4
	la $a0,str
	syscall
	la $a0, cadena_origen  #direcion donde se almacena la cadena
	li $a1, 1024	#maximo numero de caracteres leidos
	jal read_string #lee primera cadena
	
	li $v0, 4
	la $a0,str
	syscall
	la $a0, cadena_destino
	li $a1, 1024
	jal read_string #lee segunda cadena

	la $a0, cadena_destino   #pdest
	la $a1, cadena_origen   #porig
	jal strcpy 		# void strcpy(*pdest,*porig)

#print destino (cambiado)
	la $a0, cadena_destino
	li $v0, 4
	syscall

exit:
	li $v0, 10
	syscall


###############################################
# void read_string(char *pstring, int nchars) #
###############################################
read_string:#a0 y a1 ya estan dados
	li $v0, 8    #lee cadena de vcaracteres
	syscall
	jr $ra

#########################################
# void strcpy(char *pdest, char *porig) #
#########################################
strcpy:
	subu $sp, $sp,32
	sw $ra ,20($sp)          
	sw $fp,16($sp)
	addiu $fp,$sp,28

	sw $a0,0($fp)  	#destino
	sw $a1,-4($fp) 	#origen

	lw $a0, -4($fp) 
	jal strlen  		#longitud de la cadena origen

	move $t0, $v0 #longitud cadena origen (empieza en 1)
	lw $a0,0($fp)  	#destino
	lw $a1,-4($fp) 	#origen

	li $t1, 0 #contador

copy:
	add $t2, $a0, $t1 #posicion cadena destino
	add $t3, $a1, $t1 #posicion cadena origen
	
	lb $t4, 0($t3)  ##sobreescribe este
	sb $t4, 0($t2) #en este
	addiu $t1, $t1, 1
	blt $t1, $t0, copy #si t1 es menor que t0(longitud origen)

	add $t2, $a0, $t1
	sb $zero, 0($t2)  #inserta el \0 al final

	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra

########################################################
# int strlen(char *string), devuelve longitud sin '\0' #
########################################################
strlen:
	li $t0, 0

count:
	add $t1, $a0, $t0 	#va desplazando a la direciion correcta
	lb $t2, 0($t1)
	beqz $t2, return 	#si es igual a 0 salta
	addiu $t0, $t0, 1
	b count

return:
	sub $t0, $t0,1 	#1 QUITO SOLO \0
	move $v0, $t0
	jr $ra

