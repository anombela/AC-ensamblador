# Examen AC - 2 de Diciembre de 2016
# 
# Login lab: anombela
# Gecos: Alfonso Nombela Moreno
#
# RECUERDA __NO__ APAGAR EL EQUIPO CUANDO ACABES. PUEDES LEVANTARTE E IRTE SIN MAS.
# NO MODIFIQUES ESTAS LINEAS. REALIZA EL EJERCICIO A PARTIR DE ESTA CABECERA.
#####
	.data
newline: .asciiz "\n"
info: .asciiz "Introducir enteros, 0 sale, en el primer nodo no introducir 0:\n"
newvalue: .asciiz "Introducir valor: "
printpila: .asciiz "Valores en la pila: \n"
	.text
main:
	li $s0, 0
	
	la $a0, info
	li $v0, 4
	syscall
	
	la $a0, newvalue
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	move $a0, $v0 		#valor
	move $a1, $zero 	#siguiente valor sera 0 en el primero
	jal create 			#valor, next
	move $s0, $v0 		#--primer ndo insertado (apunta a 0
	
read:
	la $a0, newvalue
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	beqz $v0, continue
	 
	move $a0, $s0
	move $a1, $v0
	jal insert_in_order 	#first, val
	
	beqz $v0, read  	#si v0 es 0 no hay que modificar el puntero
	move $s0, $v0 		#si no se actualiza el puntero
	b read

continue:
	la $a0, printpila
	li $v0, 4
	syscall
	move $a0, $s0
	jal print
	
exit:
	li $v0, 10
	syscall
##############################################

#node_t * create(int val, node_t *next)
create:
	move $t0, $a0 		#guardo a0
	li $a0, 8
	li $v0, 9
	syscall	
	move $a0, $t0
	
	sw $a0, 0($v0)
	sw $a1, 4($v0)
	
	jr $ra 		#devolvera v0 
	
#node_t * insert_in_order(node_t *first, int val):
insert_in_order:
#ya hay 1 nodo insertado al principio
	subu $sp, $sp, 32
	sw $ra, 16($sp)
	sw $fp, 20($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	sw $a1, -4($fp)
	
	move $a0, $a1 	#valor
	move $a1, $zero 	#siguiente valor sera 0 en el primero
	jal create  		#crea nuevo nodo apuntando a 0
					#v0 es el nuevo nodo creado
	
	lw $a0, 0($fp) 		#recupero primero
	lw $a1, -4($fp) 		#recupero valor
	
first: #para el caso del primero (que solo hay uno
	lw $t0, 0($a0)  		#valor del nodo primero
	bgt $a1, $t0, insert_first
	b search  			#continua buscando
	
insert_first:
	sw $a0, 4($v0)
	#devuelve v0
	b return
	
search: #para despues del primero
	#t0 actual, a0 anterior
	lw $t0, 4($a0)
	beqz $t0, insert2  	#si es el ultimo ya lo insertara al final
	lw $t1, 0($t0)  		#valor del nodo actual
	bgt $a1, $t1, insert #si el nuevo es mayor que el acual, insertara
	lw $a0, 4($a0)
	b search
	
insert:
	#a0  anterior, #t0 el actual, #v0 es el nuevo
	sw $t0, 4($v0) 		#solo si el siguiente no es null
insert2:
	sw $v0, 4($a0)	
	li $v0, 0 			#no cambiara el nodo primero
	b return
	
return:
	lw $ra, 16($sp)
	lw $fp, 20($sp)
	addiu $sp, $sp, 32
	jr $ra


#print(nodo)
print:
	lw $t0, 4($a0)
	bnez $t0, print_recur
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	jr $ra
	
print_recur:
	subu $sp, $sp, 32
	sw $ra, 16($sp)
	sw $fp, 20($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	lw $a0, 4($a0)
	jal print
	
	lw $a0, 0($fp)
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall
	
	lw $ra, 16($sp)
	lw $fp, 20($sp)
	addiu $sp, $sp, 32
	jr $ra
