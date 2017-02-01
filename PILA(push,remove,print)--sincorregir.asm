#—AC————————>11/12/2015: PILA (push, remove, print)
#$s0 es la cima de la pila
#typedef struct _node_t {
#	int val; /* valor del nodo; tamaño palabra */
#	struct _node_t *prev; /* puntero al nodo anterior */
#} node_t; 

	.data
str1:  .asciiz "Introduce valores en la pila, 0 acaba.\n"
str2:  .asciiz "Introducir valor:"
str3:  .asciiz "\n"
str4:  .asciiz "valores de la pila:\n"
str5:  .asciiz "Introducir valor para borrar: "

	.text
main:
	la $a0, str1
	li $v0, 4
	syscall

read:
	la $a0, str2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	beqz $v0,continue  #deja de leer y pasa a hacer otras cosas	
	move $a0, $s0 	#node_t *top
	move $a1, $v0 	#int val
	jal push       #node_t * push(node_t *top, int val)
	move $s0, $v0  #actualizo la cima
	b read

continue:
	la $a0, str4
	li $v0, 4
	syscall
	move $a0, $s0 	#node_t *top
	jal print 	#void print(node_t *top):

	la $a0, str5
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a0, $s0 	#node_t *top
	move $a1, $v0 	#int val
	jal remove     #node_t * remove(node_t *top, int val)
	
	move $a0, $s0
    	jal print 	#pinta de nuevo sin el valor eliminado

exit:
	li $v0 10
	syscall


######################################################################
#	node_t * push(node_t *top, int val):	 devuelve direcion nodo #
######################################################################
push:
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)  	#node_t *top
	sw $a1, -4($fp) 	#int val (-4 para que no deesborde)

	li $a0, 8 
	li $v0, 9       	#reserva 8 byts de memoria
	syscall  

	lw $a0, 0($fp)  	#node_t *top (restaurado)
    	lw $a1, -4($fp) 	#int val  (restaurado)
	sw $a1, 0($v0)  	#valor en posicion 0 del nodo
	sw $s0, 4($v0)	 	#nodo anterior en posicion 4 del nodo
	#el nuevo nodo apunta a la cima ahora

	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra


#####################################################################
#void print(node_t *top): (recursivo y orden inverso al introducido #
#####################################################################
print:
	beqz $a0, return   #se cumplira si solo se introduce el valor "0"
	#quiere decir que no hay nada guardado

printaux:
#aqui solo entra si hay algun nodo (se creara minimo 1 pila)
	subu $sp, $sp, 32
	sw $ra, 0($sp)
    	sw $fp, 4($sp)
    	addiu $fp, $sp, 28
	
	sw $a0, -4($fp)  	#lo  guarda para luego (recursivo)
#################################################################
#Esto es para imprimir en orden inverso  al que se introdujeron #
#################################################################
#	lw $a0, 0($a0)									    #
#									                   #
#	li $v0, 1									         #
#	syscall									         #
#	la $a0, str3									    #
#	li $v0, 4									    	    #
#	syscall									  	    #
#									    			    #
#	lw $a0, -4($fp)								    #
#################################################################
    	lw $a0, 4($a0)  	#el anterior nodo

	beqz $a0, print_pila #si el siguiente nodo es 0 (no hara jal)

	jal printaux 		

print_pila:
#################################################################
#Esto es para pintar en  mismo orden en el que se introdujeron  #
#################################################################
	lw $a0, -4($fp) 	#obtiene el nodo				    #		
	lw $a0, 0($a0)  	#valor del nodo (posicion primera)     #
										              #
	li $v0, 1									         #
	syscall									         #
	la $a0, str3									    #
	li $v0, 4									         #
	syscall									         #
#################################################################
	lw $ra, 0($sp)
    	lw $fp, 4($sp)
    	addiu $sp, $sp, 32

#esto asi para que acabe tambien en el caso de no crear pila 
#sin tener que restaurar
return:
	jr $ra


######################################################################
# node_t * remove(node_t *top, int val): devuelve direccion del nodo #
######################################################################
remove:
#no borra la cima
	lw $t1, 4($a0) 		#siguiente nodo
    	beqz $t1, notfound		#si no hay siguiente nodo acaba

    	lw $t0, 0($t1) 		#valor del nodo
    	beq $a1, $t0, rm		#si es igual pasa a eliminar

    	lw $a0, 4($a0)  		#siguiente nodo 
    	b remove

rm:
    lw $t2, 4($t1)  #nodo siguiente al siguiente nodo
    sw $t2, 4($a0)
    move $v0, $t1 #devuelve direcion del nodo borrado
    jr $ra  #va a volver a  el jal de remove primero
    
notfound:
    li, $v0, 0  	#devuleve null si no encuentra que borrar
    jr $ra


#¿como seria hacer pop, eliminar la cima?
